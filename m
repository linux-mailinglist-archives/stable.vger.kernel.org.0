Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B27521679
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242254AbiEJNOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235563AbiEJNOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:14:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3556DE8F;
        Tue, 10 May 2022 06:10:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83483B81D7C;
        Tue, 10 May 2022 13:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A571CC385C2;
        Tue, 10 May 2022 13:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188243;
        bh=U5+FmEaWhhVakEBQ0TGM8mSVymqqCpM+PuY9LZVZOBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MtxSMJttT6Q1RqnefoDLKcA04LPV8ixDP4YYzmjBiN3jmgS/Xe0A8GteKb+BR9itE
         lTrsta0esC/jsIh8g7cSffyiVwfini0lOiN85KCx5SkJGsY/ynt2vB+N0boncU+Hiu
         gjBzkNe9fwVzbk6vPmafJybKiYRskLjO8s6AVyxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minh Yuan <yuanmingbuaa@gmail.com>,
        syzbot+8e8958586909d62b6840@syzkaller.appspotmail.com,
        cruise k <cruise4k@gmail.com>, Kyungtae Kim <kt0755@gmail.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Denis Efremov <efremov@linux.com>, Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 01/66] floppy: disable FDRAWCMD by default
Date:   Tue, 10 May 2022 15:06:51 +0200
Message-Id: <20220510130729.806574432@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.762341544@linuxfoundation.org>
References: <20220510130729.762341544@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
@@ -33,6 +33,22 @@ config BLK_DEV_FD
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
@@ -3016,6 +3016,8 @@ static const char *drive_name(int type,
 		return "(null)";
 }
 
+#ifdef CONFIG_BLK_DEV_FD_RAWCMD
+
 /* raw commands */
 static void raw_cmd_done(int flag)
 {
@@ -3227,6 +3229,35 @@ static int raw_cmd_ioctl(int cmd, void _
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
@@ -3414,7 +3445,6 @@ static int fd_locked_ioctl(struct block_
 {
 	int drive = (long)bdev->bd_disk->private_data;
 	int type = ITYPE(UDRS->fd_device);
-	int i;
 	int ret;
 	int size;
 	union inparam {
@@ -3565,16 +3595,7 @@ static int fd_locked_ioctl(struct block_
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


