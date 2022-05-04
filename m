Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7148351A5E7
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353442AbiEDQvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353097AbiEDQvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:51:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD28EFD2B;
        Wed,  4 May 2022 09:48:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FFE161744;
        Wed,  4 May 2022 16:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E261C385A5;
        Wed,  4 May 2022 16:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682890;
        bh=5HKhrFqmSPIq+BqSgu30j1FGtY9X74eIt1QMhVbVH1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOVA92uGzbYzpUeLxSA2E/ONONQ72c8UUb2IxEoWMH1O7dbGD3Pwe4au9egZn9rlO
         CdZxIP5lOtE5ZJgKaaWxd/uyilRr8RjKw0REBMj6snbqoNbnwhaeyLApdrJQl4AVMD
         wql8TXnlNtkBZFBBXi/aYGyiXKm6D30d6Df0mwbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minh Yuan <yuanmingbuaa@gmail.com>,
        syzbot+8e8958586909d62b6840@syzkaller.appspotmail.com,
        cruise k <cruise4k@gmail.com>, Kyungtae Kim <kt0755@gmail.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Denis Efremov <efremov@linux.com>, Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 01/84] floppy: disable FDRAWCMD by default
Date:   Wed,  4 May 2022 18:43:42 +0200
Message-Id: <20220504152927.867768825@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

commit 233087ca063686964a53c829d547c7571e3f67bf upstream.

Minh Yuan reported a concurrency use-after-free issue in the floppy code
between raw_cmd_ioctl and seek_interrupt.

[ It turns out this has been around, and that others have reported the
  KASAN splats over the years, but Minh Yuan had a reproducer for it and
  so gets primary credit for reporting it for this fix   - Linus ]

The problem is, this driver tends to break very easily and nowadays,
nobody is expected to use FDRAWCMD anyway since it was used to
manipulate non-standard formats.  The risk of breaking the driver is
higher than the risk presented by this race, and accessing the device
requires privileges anyway.

Let's just add a config option to completely disable this ioctl and
leave it disabled by default.  Distros shouldn't use it, and only those
running on antique hardware might need to enable it.

Link: https://lore.kernel.org/all/000000000000b71cdd05d703f6bf@google.com/
Link: https://lore.kernel.org/lkml/CAKcFiNC=MfYVW-Jt9A3=FPJpTwCD2PL_ULNCpsCVE5s8ZeBQgQ@mail.gmail.com
Link: https://lore.kernel.org/all/CAEAjamu1FRhz6StCe_55XY5s389ZP_xmCF69k987En+1z53=eg@mail.gmail.com
Reported-by: Minh Yuan <yuanmingbuaa@gmail.com>
Reported-by: syzbot+8e8958586909d62b6840@syzkaller.appspotmail.com
Reported-by: cruise k <cruise4k@gmail.com>
Reported-by: Kyungtae Kim <kt0755@gmail.com>
Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
Tested-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/Kconfig  |   16 ++++++++++++++++
 drivers/block/floppy.c |   43 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 48 insertions(+), 11 deletions(-)

--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -39,6 +39,22 @@ config BLK_DEV_FD
 	  To compile this driver as a module, choose M here: the
 	  module will be called floppy.
 
+config BLK_DEV_FD_RAWCMD
+	bool "Support for raw floppy disk commands (DEPRECATED)"
+	depends on BLK_DEV_FD
+	help
+	  If you want to use actual physical floppies and expect to do
+	  special low-level hardware accesses to them (access and use
+	  non-standard formats, for example), then enable this.
+
+	  Note that the code enabled by this option is rarely used and
+	  might be unstable or insecure, and distros should not enable it.
+
+	  Note: FDRAWCMD is deprecated and will be removed from the kernel
+	  in the near future.
+
+	  If unsure, say N.
+
 config AMIGA_FLOPPY
 	tristate "Amiga floppy support"
 	depends on AMIGA
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3012,6 +3012,8 @@ static const char *drive_name(int type,
 		return "(null)";
 }
 
+#ifdef CONFIG_BLK_DEV_FD_RAWCMD
+
 /* raw commands */
 static void raw_cmd_done(int flag)
 {
@@ -3223,6 +3225,35 @@ static int raw_cmd_ioctl(int cmd, void _
 	return ret;
 }
 
+static int floppy_raw_cmd_ioctl(int type, int drive, int cmd,
+				void __user *param)
+{
+	int ret;
+
+	pr_warn_once("Note: FDRAWCMD is deprecated and will be removed from the kernel in the near future.\n");
+
+	if (type)
+		return -EINVAL;
+	if (lock_fdc(drive))
+		return -EINTR;
+	set_floppy(drive);
+	ret = raw_cmd_ioctl(cmd, param);
+	if (ret == -EINTR)
+		return -EINTR;
+	process_fd_request();
+	return ret;
+}
+
+#else /* CONFIG_BLK_DEV_FD_RAWCMD */
+
+static int floppy_raw_cmd_ioctl(int type, int drive, int cmd,
+				void __user *param)
+{
+	return -EOPNOTSUPP;
+}
+
+#endif
+
 static int invalidate_drive(struct block_device *bdev)
 {
 	/* invalidate the buffer track to force a reread */
@@ -3410,7 +3441,6 @@ static int fd_locked_ioctl(struct block_
 {
 	int drive = (long)bdev->bd_disk->private_data;
 	int type = ITYPE(UDRS->fd_device);
-	int i;
 	int ret;
 	int size;
 	union inparam {
@@ -3561,16 +3591,7 @@ static int fd_locked_ioctl(struct block_
 		outparam = UDRWE;
 		break;
 	case FDRAWCMD:
-		if (type)
-			return -EINVAL;
-		if (lock_fdc(drive))
-			return -EINTR;
-		set_floppy(drive);
-		i = raw_cmd_ioctl(cmd, (void __user *)param);
-		if (i == -EINTR)
-			return -EINTR;
-		process_fd_request();
-		return i;
+		return floppy_raw_cmd_ioctl(type, drive, cmd, (void __user *)param);
 	case FDTWADDLE:
 		if (lock_fdc(drive))
 			return -EINTR;


