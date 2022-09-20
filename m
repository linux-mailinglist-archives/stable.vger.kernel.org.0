Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63BB65BE384
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 12:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiITKmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 06:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiITKl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 06:41:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE943659D1;
        Tue, 20 Sep 2022 03:41:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7867CB827B4;
        Tue, 20 Sep 2022 10:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE74DC433D6;
        Tue, 20 Sep 2022 10:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663670506;
        bh=DORyq9DGrtEeVMeq8OP9ig03IyFdjtFMlxCHiZCHHJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IOiscR0ywQBi/MOk5QbC8DqIuRXGh4hS0+cOPOO0f7auBiyURL9dHVwZrNKeM61ey
         EcvfjbgTEd/0TvDXO2iiML23Rhr5KBUiUgqNj20iYohkq750E3Bh77fkRlG/ItQSlW
         msZQgaXF0L/d2ZklYO1KYaOIQOjpNWeJcz+R08Ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.259
Date:   Tue, 20 Sep 2022 12:42:09 +0200
Message-Id: <1663670528867@kroah.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <166367052860111@kroah.com>
References: <166367052860111@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/input/joydev/joystick.rst b/Documentation/input/joydev/joystick.rst
index 9746fd76cc58..f38c330c028e 100644
--- a/Documentation/input/joydev/joystick.rst
+++ b/Documentation/input/joydev/joystick.rst
@@ -517,6 +517,7 @@ All I-Force devices are supported by the iforce module. This includes:
 * AVB Mag Turbo Force
 * AVB Top Shot Pegasus
 * AVB Top Shot Force Feedback Racing Wheel
+* Boeder Force Feedback Wheel
 * Logitech WingMan Force
 * Logitech WingMan Force Wheel
 * Guillemot Race Leader Force Feedback
diff --git a/Makefile b/Makefile
index e35356f7a1e6..133683dfc7b8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 258
+SUBLEVEL = 259
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/drivers/gpu/drm/msm/msm_rd.c b/drivers/gpu/drm/msm/msm_rd.c
index d4cc5ceb22d0..bb65aab49c21 100644
--- a/drivers/gpu/drm/msm/msm_rd.c
+++ b/drivers/gpu/drm/msm/msm_rd.c
@@ -199,6 +199,9 @@ static int rd_open(struct inode *inode, struct file *file)
 	file->private_data = rd;
 	rd->open = true;
 
+	/* Reset fifo to clear any previously unread data: */
+	rd->fifo.head = rd->fifo.tail = 0;
+
 	/* the parsing tools need to know gpu-id to know which
 	 * register database to load.
 	 */
diff --git a/drivers/hid/intel-ish-hid/ishtp-hid.h b/drivers/hid/intel-ish-hid/ishtp-hid.h
index f5c7eb79b7b5..fa16983007f6 100644
--- a/drivers/hid/intel-ish-hid/ishtp-hid.h
+++ b/drivers/hid/intel-ish-hid/ishtp-hid.h
@@ -118,7 +118,7 @@ struct report_list {
  * @multi_packet_cnt:	Count of fragmented packet count
  *
  * This structure is used to store completion flags and per client data like
- * like report description, number of HID devices etc.
+ * report description, number of HID devices etc.
  */
 struct ishtp_cl_data {
 	/* completion flags */
diff --git a/drivers/input/joystick/iforce/iforce-main.c b/drivers/input/joystick/iforce/iforce-main.c
index 58d5cfe46526..12d96937c83f 100644
--- a/drivers/input/joystick/iforce/iforce-main.c
+++ b/drivers/input/joystick/iforce/iforce-main.c
@@ -64,6 +64,7 @@ static struct iforce_device iforce_device[] = {
 	{ 0x046d, 0xc291, "Logitech WingMan Formula Force",		btn_wheel, abs_wheel, ff_iforce },
 	{ 0x05ef, 0x020a, "AVB Top Shot Pegasus",			btn_joystick_avb, abs_avb_pegasus, ff_iforce },
 	{ 0x05ef, 0x8884, "AVB Mag Turbo Force",			btn_wheel, abs_wheel, ff_iforce },
+	{ 0x05ef, 0x8886, "Boeder Force Feedback Wheel",		btn_wheel, abs_wheel, ff_iforce },
 	{ 0x05ef, 0x8888, "AVB Top Shot Force Feedback Racing Wheel",	btn_wheel, abs_wheel, ff_iforce }, //?
 	{ 0x061c, 0xc0a4, "ACT LABS Force RS",                          btn_wheel, abs_wheel, ff_iforce }, //?
 	{ 0x061c, 0xc084, "ACT LABS Force RS",				btn_wheel, abs_wheel, ff_iforce },
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 6fcf9646d141..d1ca3d3f51a7 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18207,16 +18207,20 @@ static void tg3_shutdown(struct pci_dev *pdev)
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct tg3 *tp = netdev_priv(dev);
 
+	tg3_reset_task_cancel(tp);
+
 	rtnl_lock();
+
 	netif_device_detach(dev);
 
 	if (netif_running(dev))
 		dev_close(dev);
 
-	if (system_state == SYSTEM_POWER_OFF)
-		tg3_power_down(tp);
+	tg3_power_down(tp);
 
 	rtnl_unlock();
+
+	pci_disable_device(pdev);
 }
 
 /**
diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
index 0c89d3edf901..fa3a4db517d6 100644
--- a/drivers/net/ieee802154/cc2520.c
+++ b/drivers/net/ieee802154/cc2520.c
@@ -512,6 +512,7 @@ cc2520_tx(struct ieee802154_hw *hw, struct sk_buff *skb)
 		goto err_tx;
 
 	if (status & CC2520_STATUS_TX_UNDERFLOW) {
+		rc = -EINVAL;
 		dev_err(&priv->spi->dev, "cc2520 tx underflow exception\n");
 		goto err_tx;
 	}
diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index cffa0cb51720..3738beb0fb40 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -203,8 +203,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
 		if (misr_status < 0)
 			return misr_status;
 
-		misr_status |= (DP83822_RX_ERR_HF_INT_EN |
-				DP83822_ANEG_COMPLETE_INT_EN |
+		misr_status |= (DP83822_ANEG_COMPLETE_INT_EN |
 				DP83822_DUP_MODE_CHANGE_INT_EN |
 				DP83822_SPEED_CHANGED_INT_EN |
 				DP83822_LINK_STAT_INT_EN |
diff --git a/drivers/perf/arm_pmu_platform.c b/drivers/perf/arm_pmu_platform.c
index 199293450acf..0ffa4f45a839 100644
--- a/drivers/perf/arm_pmu_platform.c
+++ b/drivers/perf/arm_pmu_platform.c
@@ -118,7 +118,7 @@ static int pmu_parse_irqs(struct arm_pmu *pmu)
 
 	if (num_irqs == 1) {
 		int irq = platform_get_irq(pdev, 0);
-		if (irq && irq_is_percpu_devid(irq))
+		if ((irq > 0) && irq_is_percpu_devid(irq))
 			return pmu_parse_percpu_irq(pmu, irq);
 	}
 
diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index bd25c8a156d2..c73ce07b66c9 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -106,6 +106,7 @@ static const struct key_entry acer_wmi_keymap[] __initconst = {
 	{KE_KEY, 0x22, {KEY_PROG2} },    /* Arcade */
 	{KE_KEY, 0x23, {KEY_PROG3} },    /* P_Key */
 	{KE_KEY, 0x24, {KEY_PROG4} },    /* Social networking_Key */
+	{KE_KEY, 0x27, {KEY_HELP} },
 	{KE_KEY, 0x29, {KEY_PROG3} },    /* P_Key for TM8372 */
 	{KE_IGNORE, 0x41, {KEY_MUTE} },
 	{KE_IGNORE, 0x42, {KEY_PREVIOUSSONG} },
@@ -119,7 +120,13 @@ static const struct key_entry acer_wmi_keymap[] __initconst = {
 	{KE_IGNORE, 0x48, {KEY_VOLUMEUP} },
 	{KE_IGNORE, 0x49, {KEY_VOLUMEDOWN} },
 	{KE_IGNORE, 0x4a, {KEY_VOLUMEDOWN} },
-	{KE_IGNORE, 0x61, {KEY_SWITCHVIDEOMODE} },
+	/*
+	 * 0x61 is KEY_SWITCHVIDEOMODE. Usually this is a duplicate input event
+	 * with the "Video Bus" input device events. But sometimes it is not
+	 * a dup. Map it to KEY_UNKNOWN instead of using KE_IGNORE so that
+	 * udev/hwdb can override it on systems where it is not a dup.
+	 */
+	{KE_KEY, 0x61, {KEY_UNKNOWN} },
 	{KE_IGNORE, 0x62, {KEY_BRIGHTNESSUP} },
 	{KE_IGNORE, 0x63, {KEY_BRIGHTNESSDOWN} },
 	{KE_KEY, 0x64, {KEY_SWITCHVIDEOMODE} },	/* Display Switch */
diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 2f72753c3e22..0b37c8e550e7 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -62,6 +62,13 @@ UNUSUAL_DEV(0x0984, 0x0301, 0x0128, 0x0128,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_IGNORE_UAS),
 
+/* Reported-by: Tom Hu <huxiaoying@kylinos.cn> */
+UNUSUAL_DEV(0x0b05, 0x1932, 0x0000, 0x9999,
+		"ASUS",
+		"External HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 /* Reported-by: David Webb <djw@noc.ac.uk> */
 UNUSUAL_DEV(0x0bc2, 0x331a, 0x0000, 0x9999,
 		"Seagate",
diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 01b0eec4140d..4ad24d0371c8 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -142,6 +142,8 @@ struct tracefs_mount_opts {
 	kuid_t uid;
 	kgid_t gid;
 	umode_t mode;
+	/* Opt_* bitfield. */
+	unsigned int opts;
 };
 
 enum {
@@ -242,6 +244,7 @@ static int tracefs_parse_options(char *data, struct tracefs_mount_opts *opts)
 	kgid_t gid;
 	char *p;
 
+	opts->opts = 0;
 	opts->mode = TRACEFS_DEFAULT_MODE;
 
 	while ((p = strsep(&data, ",")) != NULL) {
@@ -276,24 +279,36 @@ static int tracefs_parse_options(char *data, struct tracefs_mount_opts *opts)
 		 * but traditionally tracefs has ignored all mount options
 		 */
 		}
+
+		opts->opts |= BIT(token);
 	}
 
 	return 0;
 }
 
-static int tracefs_apply_options(struct super_block *sb)
+static int tracefs_apply_options(struct super_block *sb, bool remount)
 {
 	struct tracefs_fs_info *fsi = sb->s_fs_info;
 	struct inode *inode = sb->s_root->d_inode;
 	struct tracefs_mount_opts *opts = &fsi->mount_opts;
 
-	inode->i_mode &= ~S_IALLUGO;
-	inode->i_mode |= opts->mode;
+	/*
+	 * On remount, only reset mode/uid/gid if they were provided as mount
+	 * options.
+	 */
+
+	if (!remount || opts->opts & BIT(Opt_mode)) {
+		inode->i_mode &= ~S_IALLUGO;
+		inode->i_mode |= opts->mode;
+	}
 
-	inode->i_uid = opts->uid;
+	if (!remount || opts->opts & BIT(Opt_uid))
+		inode->i_uid = opts->uid;
 
-	/* Set all the group ids to the mount option */
-	set_gid(sb->s_root, opts->gid);
+	if (!remount || opts->opts & BIT(Opt_gid)) {
+		/* Set all the group ids to the mount option */
+		set_gid(sb->s_root, opts->gid);
+	}
 
 	return 0;
 }
@@ -308,7 +323,7 @@ static int tracefs_remount(struct super_block *sb, int *flags, char *data)
 	if (err)
 		goto fail;
 
-	tracefs_apply_options(sb);
+	tracefs_apply_options(sb, true);
 
 fail:
 	return err;
@@ -360,7 +375,7 @@ static int trace_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_op = &tracefs_super_operations;
 
-	tracefs_apply_options(sb);
+	tracefs_apply_options(sb, false);
 
 	return 0;
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 5ee3c91450de..38541885ea45 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2567,6 +2567,7 @@ static void unmap_region(struct mm_struct *mm,
 {
 	struct vm_area_struct *next = prev ? prev->vm_next : mm->mmap;
 	struct mmu_gather tlb;
+	struct vm_area_struct *cur_vma;
 
 	lru_add_drain();
 	tlb_gather_mmu(&tlb, mm, start, end);
@@ -2581,8 +2582,12 @@ static void unmap_region(struct mm_struct *mm,
 	 * concurrent flush in this region has to be coming through the rmap,
 	 * and we synchronize against that using the rmap lock.
 	 */
-	if ((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) != 0)
-		tlb_flush_mmu(&tlb);
+	for (cur_vma = vma; cur_vma; cur_vma = cur_vma->vm_next) {
+		if ((cur_vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) != 0) {
+			tlb_flush_mmu(&tlb);
+			break;
+		}
+	}
 
 	free_pgtables(&tlb, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
 				 next ? next->vm_start : USER_PGTABLES_CEILING);
