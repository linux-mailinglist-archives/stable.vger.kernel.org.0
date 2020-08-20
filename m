Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E6924BDEA
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgHTNPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:15:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728510AbgHTJfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:35:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7384520724;
        Thu, 20 Aug 2020 09:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916140;
        bh=f7dSuZvjHUqqU4m9HMc+xEo9Fm4qh0voDgmShpezLN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gOGVBuAVAhx0xdYfDChABlm+HwoVJEPN6TFaLdf0VWBQNAU6vm8rTT8e+xYL4RhEc
         e8ymD2NvJAo4dNi4dc/bWWP2BOevOgKmRSCcu1sg+eg2/7llNwnBFcY7bKySbeOy4q
         5E2SDsyZSvpKDqEAD1saUBtMdRUghJJtoIuYXSik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.7 024/204] btrfs: avoid possible signal interruption of btrfs_drop_snapshot() on relocation tree
Date:   Thu, 20 Aug 2020 11:18:41 +0200
Message-Id: <20200820091607.468694190@linuxfoundation.org>
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

commit f3e3d9cc35252a70a2fd698762c9687718268ec6 upstream.

[BUG]
There is a bug report about bad signal timing could lead to read-only
fs during balance:

  BTRFS info (device xvdb): balance: start -d -m -s
  BTRFS info (device xvdb): relocating block group 73001861120 flags metadata
  BTRFS info (device xvdb): found 12236 extents, stage: move data extents
  BTRFS info (device xvdb): relocating block group 71928119296 flags data
  BTRFS info (device xvdb): found 3 extents, stage: move data extents
  BTRFS info (device xvdb): found 3 extents, stage: update data pointers
  BTRFS info (device xvdb): relocating block group 60922265600 flags metadata
  BTRFS: error (device xvdb) in btrfs_drop_snapshot:5505: errno=-4 unknown
  BTRFS info (device xvdb): forced readonly
  BTRFS info (device xvdb): balance: ended with status: -4

[CAUSE]
The direct cause is the -EINTR from the following call chain when a
fatal signal is pending:

 relocate_block_group()
 |- clean_dirty_subvols()
    |- btrfs_drop_snapshot()
       |- btrfs_start_transaction()
          |- btrfs_delayed_refs_rsv_refill()
             |- btrfs_reserve_metadata_bytes()
                |- __reserve_metadata_bytes()
                   |- wait_reserve_ticket()
                      |- prepare_to_wait_event();
                      |- ticket->error = -EINTR;

Normally this behavior is fine for most btrfs_start_transaction()
callers, as they need to catch any other error, same for the signal, and
exit ASAP.

However for balance, especially for the clean_dirty_subvols() case, we're
already doing cleanup works, getting -EINTR from btrfs_drop_snapshot()
could cause a lot of unexpected problems.

>From the mentioned forced read-only report, to later balance error due
to half dropped reloc trees.

[FIX]
Fix this problem by using btrfs_join_transaction() if
btrfs_drop_snapshot() is called from relocation context.

Since btrfs_join_transaction() won't get interrupted by signal, we can
continue the cleanup.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>3
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5313,7 +5313,14 @@ int btrfs_drop_snapshot(struct btrfs_roo
 		goto out;
 	}
 
-	trans = btrfs_start_transaction(tree_root, 0);
+	/*
+	 * Use join to avoid potential EINTR from transaction start. See
+	 * wait_reserve_ticket and the whole reservation callchain.
+	 */
+	if (for_reloc)
+		trans = btrfs_join_transaction(tree_root);
+	else
+		trans = btrfs_start_transaction(tree_root, 0);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
 		goto out_free;


