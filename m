Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516E466E27A
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 16:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbjAQPll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 10:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjAQPke (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 10:40:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EC82365A
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 07:38:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7825EB81647
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 15:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A7CC433F0;
        Tue, 17 Jan 2023 15:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673969896;
        bh=EMhy17m17dDxLDjM9TacuUTosxohkVg83zFxAx8QMCk=;
        h=Subject:To:From:Date:From;
        b=dv1dN5LiJM68+DTrBl5V+bDiaueeF1KNQQRbtAhL0JvQRWw3PYak/VTBGMqMd8/nj
         AdyD0IrC3GvWmkAWu1gCZ9aBtFvd1OZ0Tne5W4B+Sw6wZiS4MT2kgUv3kKa4ie5Jpx
         2BeQFk73Vv43sLQKM9lm9ZimIQeZdJaCPVj4Ul7c=
Subject: patch "USB: gadgetfs: Fix race between mounting and unmounting" added to usb-linus
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, sundaywind2004@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 17 Jan 2023 16:38:11 +0100
Message-ID: <1673969891218196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: gadgetfs: Fix race between mounting and unmounting

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d18dcfe9860e842f394e37ba01ca9440ab2178f4 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Fri, 23 Dec 2022 09:59:09 -0500
Subject: USB: gadgetfs: Fix race between mounting and unmounting

The syzbot fuzzer and Gerald Lee have identified a use-after-free bug
in the gadgetfs driver, involving processes concurrently mounting and
unmounting the gadgetfs filesystem.  In particular, gadgetfs_fill_super()
can race with gadgetfs_kill_sb(), causing the latter to deallocate
the_device while the former is using it.  The output from KASAN says,
in part:

BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:102 [inline]
BUG: KASAN: use-after-free in atomic_fetch_sub_release include/linux/atomic/atomic-instrumented.h:176 [inline]
BUG: KASAN: use-after-free in __refcount_sub_and_test include/linux/refcount.h:272 [inline]
BUG: KASAN: use-after-free in __refcount_dec_and_test include/linux/refcount.h:315 [inline]
BUG: KASAN: use-after-free in refcount_dec_and_test include/linux/refcount.h:333 [inline]
BUG: KASAN: use-after-free in put_dev drivers/usb/gadget/legacy/inode.c:159 [inline]
BUG: KASAN: use-after-free in gadgetfs_kill_sb+0x33/0x100 drivers/usb/gadget/legacy/inode.c:2086
Write of size 4 at addr ffff8880276d7840 by task syz-executor126/18689

CPU: 0 PID: 18689 Comm: syz-executor126 Not tainted 6.1.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
...
 atomic_fetch_sub_release include/linux/atomic/atomic-instrumented.h:176 [inline]
 __refcount_sub_and_test include/linux/refcount.h:272 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 put_dev drivers/usb/gadget/legacy/inode.c:159 [inline]
 gadgetfs_kill_sb+0x33/0x100 drivers/usb/gadget/legacy/inode.c:2086
 deactivate_locked_super+0xa7/0xf0 fs/super.c:332
 vfs_get_super fs/super.c:1190 [inline]
 get_tree_single+0xd0/0x160 fs/super.c:1207
 vfs_get_tree+0x88/0x270 fs/super.c:1531
 vfs_fsconfig_locked fs/fsopen.c:232 [inline]

The simplest solution is to ensure that gadgetfs_fill_super() and
gadgetfs_kill_sb() are serialized by making them both acquire a new
mutex.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: syzbot+33d7ad66d65044b93f16@syzkaller.appspotmail.com
Reported-and-tested-by: Gerald Lee <sundaywind2004@gmail.com>
Link: https://lore.kernel.org/linux-usb/CAO3qeMVzXDP-JU6v1u5Ags6Q-bb35kg3=C6d04DjzA9ffa5x1g@mail.gmail.com/
Fixes: e5d82a7360d1 ("vfs: Convert gadgetfs to use the new mount API")
CC: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/Y6XCPXBpn3tmjdCC@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/inode.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 01c3ead7d1b4..d605bc2e7e8f 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -229,6 +229,7 @@ static void put_ep (struct ep_data *data)
  */
 
 static const char *CHIP;
+static DEFINE_MUTEX(sb_mutex);		/* Serialize superblock operations */
 
 /*----------------------------------------------------------------------*/
 
@@ -2010,13 +2011,20 @@ gadgetfs_fill_super (struct super_block *sb, struct fs_context *fc)
 {
 	struct inode	*inode;
 	struct dev_data	*dev;
+	int		rc;
 
-	if (the_device)
-		return -ESRCH;
+	mutex_lock(&sb_mutex);
+
+	if (the_device) {
+		rc = -ESRCH;
+		goto Done;
+	}
 
 	CHIP = usb_get_gadget_udc_name();
-	if (!CHIP)
-		return -ENODEV;
+	if (!CHIP) {
+		rc = -ENODEV;
+		goto Done;
+	}
 
 	/* superblock */
 	sb->s_blocksize = PAGE_SIZE;
@@ -2053,13 +2061,17 @@ gadgetfs_fill_super (struct super_block *sb, struct fs_context *fc)
 	 * from binding to a controller.
 	 */
 	the_device = dev;
-	return 0;
+	rc = 0;
+	goto Done;
 
-Enomem:
+ Enomem:
 	kfree(CHIP);
 	CHIP = NULL;
+	rc = -ENOMEM;
 
-	return -ENOMEM;
+ Done:
+	mutex_unlock(&sb_mutex);
+	return rc;
 }
 
 /* "mount -t gadgetfs path /dev/gadget" ends up here */
@@ -2081,6 +2093,7 @@ static int gadgetfs_init_fs_context(struct fs_context *fc)
 static void
 gadgetfs_kill_sb (struct super_block *sb)
 {
+	mutex_lock(&sb_mutex);
 	kill_litter_super (sb);
 	if (the_device) {
 		put_dev (the_device);
@@ -2088,6 +2101,7 @@ gadgetfs_kill_sb (struct super_block *sb)
 	}
 	kfree(CHIP);
 	CHIP = NULL;
+	mutex_unlock(&sb_mutex);
 }
 
 /*----------------------------------------------------------------------*/
-- 
2.39.0


