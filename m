Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919ED24B2B3
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgHTJff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:35:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728341AbgHTJfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:35:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A58CC20724;
        Thu, 20 Aug 2020 09:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916134;
        bh=+iu7Ap2ptMWD3TekcfG5/6x2zhfygQLXp2wM0sPiqD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azgzkq7uKDJeoJ17HhBb1nKks/CMXaoBFnr5DSR17TGN1vhNoOmjjA9D8ZptK2x+C
         u8CegL+AuQDZDnVnjfrlg0M2ZHx+2Z3QlYchqpMqpNlV/qeInQzndKFNb1YvHsNSL9
         LjTxUr5qxqbv4E2Me/0OtMa722xH4HeSA93gcEIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.7 022/204] btrfs: relocation: review the call sites which can be interrupted by signal
Date:   Thu, 20 Aug 2020 11:18:39 +0200
Message-Id: <20200820091607.369022615@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 44d354abf33e92a5e73b965c84caf5a5d5e58a0b upstream.

Since most metadata reservation calls can return -EINTR when get
interrupted by fatal signal, we need to review the all the metadata
reservation call sites.

In relocation code, the metadata reservation happens in the following
sites:

- btrfs_block_rsv_refill() in merge_reloc_root()
  merge_reloc_root() is a pretty critical section, we don't want to be
  interrupted by signal, so change the flush status to
  BTRFS_RESERVE_FLUSH_LIMIT, so it won't get interrupted by signal.
  Since such change can be ENPSPC-prone, also shrink the amount of
  metadata to reserve least amount avoid deadly ENOSPC there.

- btrfs_block_rsv_refill() in reserve_metadata_space()
  It calls with BTRFS_RESERVE_FLUSH_LIMIT, which won't get interrupted
  by signal.

- btrfs_block_rsv_refill() in prepare_to_relocate()

- btrfs_block_rsv_add() in prepare_to_relocate()

- btrfs_block_rsv_refill() in relocate_block_group()

- btrfs_delalloc_reserve_metadata() in relocate_file_extent_cluster()

- btrfs_start_transaction() in relocate_block_group()

- btrfs_start_transaction() in create_reloc_inode()
  Can be interrupted by fatal signal and we can handle it easily.
  For these call sites, just catch the -EINTR value in btrfs_balance()
  and count them as canceled.

CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/relocation.c |   12 ++++++++++--
 fs/btrfs/volumes.c    |   17 ++++++++++++++++-
 2 files changed, 26 insertions(+), 3 deletions(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2402,12 +2402,20 @@ static noinline_for_stack int merge_relo
 		btrfs_unlock_up_safe(path, 0);
 	}
 
-	min_reserved = fs_info->nodesize * (BTRFS_MAX_LEVEL - 1) * 2;
+	/*
+	 * In merge_reloc_root(), we modify the upper level pointer to swap the
+	 * tree blocks between reloc tree and subvolume tree.  Thus for tree
+	 * block COW, we COW at most from level 1 to root level for each tree.
+	 *
+	 * Thus the needed metadata size is at most root_level * nodesize,
+	 * and * 2 since we have two trees to COW.
+	 */
+	min_reserved = fs_info->nodesize * btrfs_root_level(root_item) * 2;
 	memset(&next_key, 0, sizeof(next_key));
 
 	while (1) {
 		ret = btrfs_block_rsv_refill(root, rc->block_rsv, min_reserved,
-					     BTRFS_RESERVE_FLUSH_ALL);
+					     BTRFS_RESERVE_FLUSH_LIMIT);
 		if (ret) {
 			err = ret;
 			goto out;
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4154,7 +4154,22 @@ int btrfs_balance(struct btrfs_fs_info *
 	mutex_lock(&fs_info->balance_mutex);
 	if (ret == -ECANCELED && atomic_read(&fs_info->balance_pause_req))
 		btrfs_info(fs_info, "balance: paused");
-	else if (ret == -ECANCELED && atomic_read(&fs_info->balance_cancel_req))
+	/*
+	 * Balance can be canceled by:
+	 *
+	 * - Regular cancel request
+	 *   Then ret == -ECANCELED and balance_cancel_req > 0
+	 *
+	 * - Fatal signal to "btrfs" process
+	 *   Either the signal caught by wait_reserve_ticket() and callers
+	 *   got -EINTR, or caught by btrfs_should_cancel_balance() and
+	 *   got -ECANCELED.
+	 *   Either way, in this case balance_cancel_req = 0, and
+	 *   ret == -EINTR or ret == -ECANCELED.
+	 *
+	 * So here we only check the return value to catch canceled balance.
+	 */
+	else if (ret == -ECANCELED || ret == -EINTR)
 		btrfs_info(fs_info, "balance: canceled");
 	else
 		btrfs_info(fs_info, "balance: ended with status: %d", ret);


