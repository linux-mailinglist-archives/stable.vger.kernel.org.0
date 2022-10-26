Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440F060E407
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 17:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbiJZPEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 11:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbiJZPEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 11:04:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA69F6165
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 08:04:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76CC561F5E
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 15:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885C2C433D6;
        Wed, 26 Oct 2022 15:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666796639;
        bh=fn7RNiWqu8guysaC8YjMs/mKKrPrcpLsjPUcmVPDEUY=;
        h=Subject:To:Cc:From:Date:From;
        b=ultSpQmeD7qR6r19C7e/5WXyCFnxj9d/TOB0FL84cIgh5eEQulIq+DGZMv96A75AE
         JOXsx/0K4/Lh8RjQ6/NTxjWPB3p1NYd5+JUbPBgQVW/ARBJ3eve2cbjYuL8x7o6+Dj
         ISR3sku7FlqCmSFD4WC6UlKKGiwmPCsfecboGyDU=
Subject: FAILED: patch "[PATCH] btrfs: unlock locked extent area if we have contention" failed to apply to 5.15-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Oct 2022 17:03:49 +0200
Message-ID: <1666796629178176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

9e769bd7e5db ("btrfs: unlock locked extent area if we have contention")
994bcd1eae5b ("btrfs: remove failed_start argument from set_extent_bit")
c07d1004c55c ("btrfs: drop exclusive_bits from set_extent_bit")
e3974c669472 ("btrfs: move core extent_io_tree functions to extent-io-tree.c")
38830018387e ("btrfs: move a few exported extent_io_tree helpers to extent-io-tree.c")
04eba8932392 ("btrfs: temporarily export and then move extent state helpers")
91af24e48474 ("btrfs: temporarily export and move core extent_io_tree tree functions")
6962541e964f ("btrfs: move btrfs_debug_check_extent_io_range into extent-io-tree.c")
ec39e39bbf97 ("btrfs: export wait_extent_bit")
a66318872c41 ("btrfs: move simple extent bit helpers out of extent_io.c")
ad795329574c ("btrfs: convert BUG_ON(EXTENT_BIT_LOCKED) checks to ASSERT's")
83cf709a89fb ("btrfs: move extent state init and alloc functions to their own file")
c45379a20fbc ("btrfs: temporarily export alloc_extent_state helpers")
a40246e8afc0 ("btrfs: separate out the eb and extent state leak helpers")
a62a3bd9546b ("btrfs: separate out the extent state and extent buffer init code")
87c11705cc94 ("btrfs: convert the io_failure_tree to a plain rb_tree")
a2061748052c ("btrfs: unexport internal failrec functions")
0d0a762c419a ("btrfs: rename clean_io_failure and remove extraneous args")
917f32a23501 ("btrfs: give struct btrfs_bio a real end_io handler")
f1c2937976be ("btrfs: properly abstract the parity raid bio handling")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9e769bd7e5db5e3bd76e7c67004c261f7fcaa8f1 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 30 Sep 2022 16:45:08 -0400
Subject: [PATCH] btrfs: unlock locked extent area if we have contention

In production we hit the following deadlock

task 1			task 2			task 3
------			------			------
fiemap(file)		falloc(file)		fsync(file)
						  write(0, 1MiB)
						  btrfs_commit_transaction()
						    wait_on(!pending_ordered)
			  lock(512MiB, 1GiB)
			  start_transaction
			    wait_on_transaction

  lock(0, 1GiB)
    wait_extent_bit(512MiB)

task 4
------
finish_ordered_extent(0, 1MiB)
  lock(0, 1MiB)
  **DEADLOCK**

This occurs because when task 1 does it's lock, it locks everything from
0-512MiB, and then waits for the 512MiB chunk to unlock.  task 2 will
never unlock because it's waiting on the transaction commit to happen,
the transaction commit is waiting for the outstanding ordered extents,
and then the ordered extent thread is blocked waiting on the 0-1MiB
range to unlock.

To fix this we have to clear anything we've locked so far, wait for the
extent_state that we contended on, and then try to re-lock the entire
range again.

CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index 618275af19c4..83cb0378096f 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -1641,16 +1641,17 @@ int lock_extent(struct extent_io_tree *tree, u64 start, u64 end,
 	int err;
 	u64 failed_start;
 
-	while (1) {
+	err = __set_extent_bit(tree, start, end, EXTENT_LOCKED, &failed_start,
+			       cached_state, NULL, GFP_NOFS);
+	while (err == -EEXIST) {
+		if (failed_start != start)
+			clear_extent_bit(tree, start, failed_start - 1,
+					 EXTENT_LOCKED, cached_state);
+
+		wait_extent_bit(tree, failed_start, end, EXTENT_LOCKED);
 		err = __set_extent_bit(tree, start, end, EXTENT_LOCKED,
 				       &failed_start, cached_state, NULL,
 				       GFP_NOFS);
-		if (err == -EEXIST) {
-			wait_extent_bit(tree, failed_start, end, EXTENT_LOCKED);
-			start = failed_start;
-		} else
-			break;
-		WARN_ON(start > end);
 	}
 	return err;
 }

