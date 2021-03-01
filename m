Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7293284C6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbhCAQnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:43:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:41536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232795AbhCAQgk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:36:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BDCA64F3E;
        Mon,  1 Mar 2021 16:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615993;
        bh=aLfuj5mD2oLztqKRN4jDi62Ax883JhvEoi73e4m+yp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x2JCXM2BsvbHiaOoZ0H+ACBBm/mGiaBM/cnpNg6+uQbiF9F1FltBX8G+odyxyVIfF
         gqsRVDWvg+BqGc6M9Yp5ZybKr5QWZN7YisD1KrAmXnwWpeA8R6YL2xMtdpVmF3YIra
         HHihSEJGETJCiV4LMnxAwg61fMMsboSAgjHf1tfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 102/134] btrfs: abort the transaction if we fail to inc ref in btrfs_copy_root
Date:   Mon,  1 Mar 2021 17:13:23 +0100
Message-Id: <20210301161018.585297020@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 867ed321f90d06aaba84e2c91de51cd3038825ef upstream.

While testing my error handling patches, I added a error injection site
at btrfs_inc_extent_ref, to validate the error handling I added was
doing the correct thing.  However I hit a pretty ugly corruption while
doing this check, with the following error injection stack trace:

btrfs_inc_extent_ref
  btrfs_copy_root
    create_reloc_root
      btrfs_init_reloc_root
	btrfs_record_root_in_trans
	  btrfs_start_transaction
	    btrfs_update_inode
	      btrfs_update_time
		touch_atime
		  file_accessed
		    btrfs_file_mmap

This is because we do not catch the error from btrfs_inc_extent_ref,
which in practice would be ENOMEM, which means we lose the extent
references for a root that has already been allocated and inserted,
which is the problem.  Fix this by aborting the transaction if we fail
to do the reference modification.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -279,9 +279,10 @@ int btrfs_copy_root(struct btrfs_trans_h
 		ret = btrfs_inc_ref(trans, root, cow, 1);
 	else
 		ret = btrfs_inc_ref(trans, root, cow, 0);
-
-	if (ret)
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
 		return ret;
+	}
 
 	btrfs_mark_buffer_dirty(cow);
 	*cow_ret = cow;


