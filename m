Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8275D4CF29F
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 08:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbiCGHdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 02:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234444AbiCGHdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 02:33:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A6127CF3
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 23:32:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6116B8101C
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 07:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DB3C340F3;
        Mon,  7 Mar 2022 07:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646638339;
        bh=C4y89dBDOu23u3KIGOLZ6sRpfMAIEK+QEtk0Eo/1Nlw=;
        h=Subject:To:Cc:From:Date:From;
        b=PbKLs8cWhiB+Efx1gSXTWnOiRJZmEbqNuCP+ndbUpSMeQrCPMlAGs6++OHy+Y+Bk/
         XWB1HwtNlCz6mB8cgzeoydad9gEdW+7D0vAqDR6XrP1XRXoqX2lieHK7Ys74L0w4Af
         FjOVyX3PGrR8td14uUObe33vsEkIsPR1N38P1YLo=
Subject: FAILED: patch "[PATCH] btrfs: do not WARN_ON() if we have PageError set" failed to apply to 5.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Mar 2022 08:32:15 +0100
Message-ID: <16466383355542@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a50e1fcbc9b85fd4e95b89a75c0884cb032a3e06 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 18 Feb 2022 10:17:39 -0500
Subject: [PATCH] btrfs: do not WARN_ON() if we have PageError set

Whenever we do any extent buffer operations we call
assert_eb_page_uptodate() to complain loudly if we're operating on an
non-uptodate page.  Our overnight tests caught this warning earlier this
week

  WARNING: CPU: 1 PID: 553508 at fs/btrfs/extent_io.c:6849 assert_eb_page_uptodate+0x3f/0x50
  CPU: 1 PID: 553508 Comm: kworker/u4:13 Tainted: G        W         5.17.0-rc3+ #564
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
  Workqueue: btrfs-cache btrfs_work_helper
  RIP: 0010:assert_eb_page_uptodate+0x3f/0x50
  RSP: 0018:ffffa961440a7c68 EFLAGS: 00010246
  RAX: 0017ffffc0002112 RBX: ffffe6e74453f9c0 RCX: 0000000000001000
  RDX: ffffe6e74467c887 RSI: ffffe6e74453f9c0 RDI: ffff8d4c5efc2fc0
  RBP: 0000000000000d56 R08: ffff8d4d4a224000 R09: 0000000000000000
  R10: 00015817fa9d1ef0 R11: 000000000000000c R12: 00000000000007b1
  R13: ffff8d4c5efc2fc0 R14: 0000000001500000 R15: 0000000001cb1000
  FS:  0000000000000000(0000) GS:ffff8d4dbbd00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007ff31d3448d8 CR3: 0000000118be8004 CR4: 0000000000370ee0
  Call Trace:

   extent_buffer_test_bit+0x3f/0x70
   free_space_test_bit+0xa6/0xc0
   load_free_space_tree+0x1f6/0x470
   caching_thread+0x454/0x630
   ? rcu_read_lock_sched_held+0x12/0x60
   ? rcu_read_lock_sched_held+0x12/0x60
   ? rcu_read_lock_sched_held+0x12/0x60
   ? lock_release+0x1f0/0x2d0
   btrfs_work_helper+0xf2/0x3e0
   ? lock_release+0x1f0/0x2d0
   ? finish_task_switch.isra.0+0xf9/0x3a0
   process_one_work+0x26d/0x580
   ? process_one_work+0x580/0x580
   worker_thread+0x55/0x3b0
   ? process_one_work+0x580/0x580
   kthread+0xf0/0x120
   ? kthread_complete_and_exit+0x20/0x20
   ret_from_fork+0x1f/0x30

This was partially fixed by c2e39305299f01 ("btrfs: clear extent buffer
uptodate when we fail to write it"), however all that fix did was keep
us from finding extent buffers after a failed writeout.  It didn't keep
us from continuing to use a buffer that we already had found.

In this case we're searching the commit root to cache the block group,
so we can start committing the transaction and switch the commit root
and then start writing.  After the switch we can look up an extent
buffer that hasn't been written yet and start processing that block
group.  Then we fail to write that block out and clear Uptodate on the
page, and then we start spewing these errors.

Normally we're protected by the tree lock to a certain degree here.  If
we read a block we have that block read locked, and we block the writer
from locking the block before we submit it for the write.  However this
isn't necessarily fool proof because the read could happen before we do
the submit_bio and after we locked and unlocked the extent buffer.

Also in this particular case we have path->skip_locking set, so that
won't save us here.  We'll simply get a block that was valid when we
read it, but became invalid while we were using it.

What we really want is to catch the case where we've "read" a block but
it's not marked Uptodate.  On read we ClearPageError(), so if we're
!Uptodate and !Error we know we didn't do the right thing for reading
the page.

Fix this by checking !Uptodate && !Error, this way we will not complain
if our buffer gets invalidated while we're using it, and we'll maintain
the spirit of the check which is to make sure we have a fully in-cache
block while we're messing with it.

CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d6d48ecf823c..9081223c3230 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -6851,14 +6851,24 @@ static void assert_eb_page_uptodate(const struct extent_buffer *eb,
 {
 	struct btrfs_fs_info *fs_info = eb->fs_info;
 
+	/*
+	 * If we are using the commit root we could potentially clear a page
+	 * Uptodate while we're using the extent buffer that we've previously
+	 * looked up.  We don't want to complain in this case, as the page was
+	 * valid before, we just didn't write it out.  Instead we want to catch
+	 * the case where we didn't actually read the block properly, which
+	 * would have !PageUptodate && !PageError, as we clear PageError before
+	 * reading.
+	 */
 	if (fs_info->sectorsize < PAGE_SIZE) {
-		bool uptodate;
+		bool uptodate, error;
 
 		uptodate = btrfs_subpage_test_uptodate(fs_info, page,
 						       eb->start, eb->len);
-		WARN_ON(!uptodate);
+		error = btrfs_subpage_test_error(fs_info, page, eb->start, eb->len);
+		WARN_ON(!uptodate && !error);
 	} else {
-		WARN_ON(!PageUptodate(page));
+		WARN_ON(!PageUptodate(page) && !PageError(page));
 	}
 }
 

