Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784184E9015
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 10:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239322AbiC1IYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 04:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239327AbiC1IYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 04:24:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A93853A6B;
        Mon, 28 Mar 2022 01:22:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 014B8CE126F;
        Mon, 28 Mar 2022 08:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE39BC004DD;
        Mon, 28 Mar 2022 08:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648455740;
        bh=qN3KOx4FIZpM2BjI61uex4eEJkqvofY+pVltPWYcWwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ul0trcWBEvLuvoMl5JKCkxdq26BDtJAxA57O4Novk9q98B5W07nBAM7I51Tb2nHXd
         8jfbZ0JC1SuwnBSHOxAPzVS0gOgbU+RWzgzY0WFQn49YPPq67IxrtUCiSCJIfiEv8t
         pMsGDzdSMPG9Rx5HltpC45UFPS8aMjCfuiaEcwrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.32
Date:   Mon, 28 Mar 2022 10:22:06 +0200
Message-Id: <1648455725237162@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <164845572597136@kroah.com>
References: <164845572597136@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index eeeb806f0092..c2177c6e5555 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 31
+SUBLEVEL = 32
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/csky/include/asm/uaccess.h b/arch/csky/include/asm/uaccess.h
index c40f06ee8d3e..ac5a54f57d40 100644
--- a/arch/csky/include/asm/uaccess.h
+++ b/arch/csky/include/asm/uaccess.h
@@ -3,14 +3,13 @@
 #ifndef __ASM_CSKY_UACCESS_H
 #define __ASM_CSKY_UACCESS_H
 
-#define user_addr_max() \
-	(uaccess_kernel() ? KERNEL_DS.seg : get_fs().seg)
+#define user_addr_max() (current_thread_info()->addr_limit.seg)
 
 static inline int __access_ok(unsigned long addr, unsigned long size)
 {
-	unsigned long limit = current_thread_info()->addr_limit.seg;
+	unsigned long limit = user_addr_max();
 
-	return ((addr < limit) && ((addr + size) < limit));
+	return (size <= limit) && (addr <= (limit - size));
 }
 #define __access_ok __access_ok
 
diff --git a/arch/hexagon/include/asm/uaccess.h b/arch/hexagon/include/asm/uaccess.h
index ef5bfef8d490..719ba3f3c45c 100644
--- a/arch/hexagon/include/asm/uaccess.h
+++ b/arch/hexagon/include/asm/uaccess.h
@@ -25,17 +25,17 @@
  * Returns true (nonzero) if the memory block *may* be valid, false (zero)
  * if it is definitely invalid.
  *
- * User address space in Hexagon, like x86, goes to 0xbfffffff, so the
- * simple MSB-based tests used by MIPS won't work.  Some further
- * optimization is probably possible here, but for now, keep it
- * reasonably simple and not *too* slow.  After all, we've got the
- * MMU for backup.
  */
+#define uaccess_kernel() (get_fs().seg == KERNEL_DS.seg)
+#define user_addr_max() (uaccess_kernel() ? ~0UL : TASK_SIZE)
 
-#define __access_ok(addr, size) \
-	((get_fs().seg == KERNEL_DS.seg) || \
-	(((unsigned long)addr < get_fs().seg) && \
-	  (unsigned long)size < (get_fs().seg - (unsigned long)addr)))
+static inline int __access_ok(unsigned long addr, unsigned long size)
+{
+	unsigned long limit = TASK_SIZE;
+
+	return (size <= limit) && (addr <= (limit - size));
+}
+#define __access_ok __access_ok
 
 /*
  * When a kernel-mode page fault is taken, the faulting instruction
diff --git a/arch/m68k/include/asm/uaccess.h b/arch/m68k/include/asm/uaccess.h
index ba670523885c..60b786eb2254 100644
--- a/arch/m68k/include/asm/uaccess.h
+++ b/arch/m68k/include/asm/uaccess.h
@@ -12,14 +12,17 @@
 #include <asm/extable.h>
 
 /* We let the MMU do all checking */
-static inline int access_ok(const void __user *addr,
+static inline int access_ok(const void __user *ptr,
 			    unsigned long size)
 {
-	/*
-	 * XXX: for !CONFIG_CPU_HAS_ADDRESS_SPACES this really needs to check
-	 * for TASK_SIZE!
-	 */
-	return 1;
+	unsigned long limit = TASK_SIZE;
+	unsigned long addr = (unsigned long)ptr;
+
+	if (IS_ENABLED(CONFIG_CPU_HAS_ADDRESS_SPACES) ||
+	    !IS_ENABLED(CONFIG_MMU))
+		return 1;
+
+	return (size <= limit) && (addr <= (limit - size));
 }
 
 /*
diff --git a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/include/asm/uaccess.h
index d2a8ef9f8978..5b6e0e7788f4 100644
--- a/arch/microblaze/include/asm/uaccess.h
+++ b/arch/microblaze/include/asm/uaccess.h
@@ -39,24 +39,13 @@
 
 # define uaccess_kernel()	(get_fs().seg == KERNEL_DS.seg)
 
-static inline int access_ok(const void __user *addr, unsigned long size)
+static inline int __access_ok(unsigned long addr, unsigned long size)
 {
-	if (!size)
-		goto ok;
+	unsigned long limit = user_addr_max();
 
-	if ((get_fs().seg < ((unsigned long)addr)) ||
-			(get_fs().seg < ((unsigned long)addr + size - 1))) {
-		pr_devel("ACCESS fail at 0x%08x (size 0x%x), seg 0x%08x\n",
-			(__force u32)addr, (u32)size,
-			(u32)get_fs().seg);
-		return 0;
-	}
-ok:
-	pr_devel("ACCESS OK at 0x%08x (size 0x%x), seg 0x%08x\n",
-			(__force u32)addr, (u32)size,
-			(u32)get_fs().seg);
-	return 1;
+	return (size <= limit) && (addr <= (limit - size));
 }
+#define access_ok(addr, size) __access_ok((unsigned long)addr, size)
 
 # define __FIXUP_SECTION	".section .fixup,\"ax\"\n"
 # define __EX_TABLE_SECTION	".section __ex_table,\"a\"\n"
diff --git a/arch/nds32/include/asm/uaccess.h b/arch/nds32/include/asm/uaccess.h
index d4cbf069dc22..37a40981deb3 100644
--- a/arch/nds32/include/asm/uaccess.h
+++ b/arch/nds32/include/asm/uaccess.h
@@ -70,9 +70,7 @@ static inline void set_fs(mm_segment_t fs)
  * versions are void (ie, don't return a value as such).
  */
 
-#define get_user	__get_user					\
-
-#define __get_user(x, ptr)						\
+#define get_user(x, ptr)						\
 ({									\
 	long __gu_err = 0;						\
 	__get_user_check((x), (ptr), __gu_err);				\
@@ -85,6 +83,14 @@ static inline void set_fs(mm_segment_t fs)
 	(void)0;							\
 })
 
+#define __get_user(x, ptr)						\
+({									\
+	long __gu_err = 0;						\
+	const __typeof__(*(ptr)) __user *__p = (ptr);			\
+	__get_user_err((x), __p, (__gu_err));				\
+	__gu_err;							\
+})
+
 #define __get_user_check(x, ptr, err)					\
 ({									\
 	const __typeof__(*(ptr)) __user *__p = (ptr);			\
@@ -165,12 +171,18 @@ do {									\
 		: "r"(addr), "i"(-EFAULT)				\
 		: "cc")
 
-#define put_user	__put_user					\
+#define put_user(x, ptr)						\
+({									\
+	long __pu_err = 0;						\
+	__put_user_check((x), (ptr), __pu_err);				\
+	__pu_err;							\
+})
 
 #define __put_user(x, ptr)						\
 ({									\
 	long __pu_err = 0;						\
-	__put_user_err((x), (ptr), __pu_err);				\
+	__typeof__(*(ptr)) __user *__p = (ptr);				\
+	__put_user_err((x), __p, __pu_err);				\
 	__pu_err;							\
 })
 
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 14bcd59bcdee..94ac7402c1ac 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1319,6 +1319,17 @@ static int __init disable_acpi_pci(const struct dmi_system_id *d)
 	return 0;
 }
 
+static int __init disable_acpi_xsdt(const struct dmi_system_id *d)
+{
+	if (!acpi_force) {
+		pr_notice("%s detected: force use of acpi=rsdt\n", d->ident);
+		acpi_gbl_do_not_use_xsdt = TRUE;
+	} else {
+		pr_notice("Warning: DMI blacklist says broken, but acpi XSDT forced\n");
+	}
+	return 0;
+}
+
 static int __init dmi_disable_acpi(const struct dmi_system_id *d)
 {
 	if (!acpi_force) {
@@ -1442,6 +1453,19 @@ static const struct dmi_system_id acpi_dmi_table[] __initconst = {
 		     DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 360"),
 		     },
 	 },
+	/*
+	 * Boxes that need ACPI XSDT use disabled due to corrupted tables
+	 */
+	{
+	 .callback = disable_acpi_xsdt,
+	 .ident = "Advantech DAC-BJ01",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "NEC"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "Bearlake CRB Board"),
+		     DMI_MATCH(DMI_BIOS_VERSION, "V1.12"),
+		     DMI_MATCH(DMI_BIOS_DATE, "02/01/2011"),
+		     },
+	 },
 	{}
 };
 
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index ead0114f27c9..56db7b4da514 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -60,6 +60,10 @@ MODULE_PARM_DESC(cache_time, "cache time in milliseconds");
 
 static const struct acpi_device_id battery_device_ids[] = {
 	{"PNP0C0A", 0},
+
+	/* Microsoft Surface Go 3 */
+	{"MSHW0146", 0},
+
 	{"", 0},
 };
 
@@ -1177,6 +1181,14 @@ static const struct dmi_system_id bat_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad"),
 		},
 	},
+	{
+		/* Microsoft Surface Go 3 */
+		.callback = battery_notification_delay_quirk,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 3"),
+		},
+	},
 	{},
 };
 
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 33474fd96991..7b9793cb55c5 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -409,6 +409,81 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "GA503"),
 		},
 	},
+	/*
+	 * Clevo NL5xRU and NL5xNU/TUXEDO Aura 15 Gen1 and Gen2 have both a
+	 * working native and video interface. However the default detection
+	 * mechanism first registers the video interface before unregistering
+	 * it again and switching to the native interface during boot. This
+	 * results in a dangling SBIOS request for backlight change for some
+	 * reason, causing the backlight to switch to ~2% once per boot on the
+	 * first power cord connect or disconnect event. Setting the native
+	 * interface explicitly circumvents this buggy behaviour, by avoiding
+	 * the unregistering process.
+	 */
+	{
+	.callback = video_detect_force_native,
+	.ident = "Clevo NL5xRU",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "NL5xRU"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "Clevo NL5xRU",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "SchenkerTechnologiesGmbH"),
+		DMI_MATCH(DMI_BOARD_NAME, "NL5xRU"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "Clevo NL5xRU",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Notebook"),
+		DMI_MATCH(DMI_BOARD_NAME, "NL5xRU"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "Clevo NL5xRU",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "AURA1501"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "Clevo NL5xRU",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "EDUBOOK1502"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "Clevo NL5xNU",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "NL5xNU"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "Clevo NL5xNU",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "SchenkerTechnologiesGmbH"),
+		DMI_MATCH(DMI_BOARD_NAME, "NL5xNU"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "Clevo NL5xNU",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Notebook"),
+		DMI_MATCH(DMI_BOARD_NAME, "NL5xNU"),
+		},
+	},
 
 	/*
 	 * Desktops which falsely report a backlight and which our heuristics
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index ac90392cce33..0d5539066c0f 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -404,6 +404,8 @@ static const struct usb_device_id blacklist_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Realtek 8852AE Bluetooth devices */
+	{ USB_DEVICE(0x0bda, 0x2852), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0bda, 0xc852), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0bda, 0x385a), .driver_info = BTUSB_REALTEK |
@@ -481,6 +483,8 @@ static const struct usb_device_id blacklist_table[] = {
 	/* Additional Realtek 8761BU Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x190e), .driver_info = BTUSB_REALTEK |
 	  					     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x2550, 0x8761), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
index c08cbb306636..dc4c0a0a5129 100644
--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -69,7 +69,13 @@ static void tpm_dev_async_work(struct work_struct *work)
 	ret = tpm_dev_transmit(priv->chip, priv->space, priv->data_buffer,
 			       sizeof(priv->data_buffer));
 	tpm_put_ops(priv->chip);
-	if (ret > 0) {
+
+	/*
+	 * If ret is > 0 then tpm_dev_transmit returned the size of the
+	 * response. If ret is < 0 then tpm_dev_transmit failed and
+	 * returned an error code.
+	 */
+	if (ret != 0) {
 		priv->response_length = ret;
 		mod_timer(&priv->user_read_timer, jiffies + (120 * HZ));
 	}
diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
index 97e916856cf3..d2225020e4d2 100644
--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -58,12 +58,12 @@ int tpm2_init_space(struct tpm_space *space, unsigned int buf_size)
 
 void tpm2_del_space(struct tpm_chip *chip, struct tpm_space *space)
 {
-	mutex_lock(&chip->tpm_mutex);
-	if (!tpm_chip_start(chip)) {
+
+	if (tpm_try_get_ops(chip) == 0) {
 		tpm2_flush_sessions(chip, space);
-		tpm_chip_stop(chip);
+		tpm_put_ops(chip);
 	}
-	mutex_unlock(&chip->tpm_mutex);
+
 	kfree(space->context_buf);
 	kfree(space->session_buf);
 }
diff --git a/drivers/crypto/qat/qat_4xxx/adf_drv.c b/drivers/crypto/qat/qat_4xxx/adf_drv.c
index 359fb7989dfb..8fd44703115f 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_drv.c
@@ -52,6 +52,13 @@ static int adf_crypto_dev_config(struct adf_accel_dev *accel_dev)
 	if (ret)
 		goto err;
 
+	/* Temporarily set the number of crypto instances to zero to avoid
+	 * registering the crypto algorithms.
+	 * This will be removed when the algorithms will support the
+	 * CRYPTO_TFM_REQ_MAY_BACKLOG flag
+	 */
+	instances = 0;
+
 	for (i = 0; i < instances; i++) {
 		val = i;
 		bank = i * 2;
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index ece6776fbd53..3efbb3883601 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -136,6 +136,13 @@ int qat_crypto_dev_config(struct adf_accel_dev *accel_dev)
 	if (ret)
 		goto err;
 
+	/* Temporarily set the number of crypto instances to zero to avoid
+	 * registering the crypto algorithms.
+	 * This will be removed when the algorithms will support the
+	 * CRYPTO_TFM_REQ_MAY_BACKLOG flag
+	 */
+	instances = 0;
+
 	for (i = 0; i < instances; i++) {
 		val = i;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_BANK_NUM, i);
diff --git a/drivers/gpu/drm/virtio/virtgpu_gem.c b/drivers/gpu/drm/virtio/virtgpu_gem.c
index 2de61b63ef91..48d3c9955f0d 100644
--- a/drivers/gpu/drm/virtio/virtgpu_gem.c
+++ b/drivers/gpu/drm/virtio/virtgpu_gem.c
@@ -248,6 +248,9 @@ void virtio_gpu_array_put_free(struct virtio_gpu_object_array *objs)
 {
 	u32 i;
 
+	if (!objs)
+		return;
+
 	for (i = 0; i < objs->nents; i++)
 		drm_gem_object_put(objs->objs[i]);
 	virtio_gpu_array_free(objs);
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 5f1fc6582d74..78c7cbc372b0 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -696,6 +696,12 @@ static int xgene_enet_rx_frame(struct xgene_enet_desc_ring *rx_ring,
 	buf_pool->rx_skb[skb_index] = NULL;
 
 	datalen = xgene_enet_get_data_len(le64_to_cpu(raw_desc->m1));
+
+	/* strip off CRC as HW isn't doing this */
+	nv = GET_VAL(NV, le64_to_cpu(raw_desc->m0));
+	if (!nv)
+		datalen -= 4;
+
 	skb_put(skb, datalen);
 	prefetch(skb->data - NET_IP_ALIGN);
 	skb->protocol = eth_type_trans(skb, ndev);
@@ -717,12 +723,8 @@ static int xgene_enet_rx_frame(struct xgene_enet_desc_ring *rx_ring,
 		}
 	}
 
-	nv = GET_VAL(NV, le64_to_cpu(raw_desc->m0));
-	if (!nv) {
-		/* strip off CRC as HW isn't doing this */
-		datalen -= 4;
+	if (!nv)
 		goto skip_jumbo;
-	}
 
 	slots = page_pool->slots - 1;
 	head = page_pool->head;
diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index b2400e2417a5..f15e7bd690b5 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -667,14 +667,14 @@ ath_regd_init_wiphy(struct ath_regulatory *reg,
 
 /*
  * Some users have reported their EEPROM programmed with
- * 0x8000 or 0x0 set, this is not a supported regulatory
- * domain but since we have more than one user with it we
- * need a solution for them. We default to 0x64, which is
- * the default Atheros world regulatory domain.
+ * 0x8000 set, this is not a supported regulatory domain
+ * but since we have more than one user with it we need
+ * a solution for them. We default to 0x64, which is the
+ * default Atheros world regulatory domain.
  */
 static void ath_regd_sanitize(struct ath_regulatory *reg)
 {
-	if (reg->current_rd != COUNTRY_ERD_FLAG && reg->current_rd != 0)
+	if (reg->current_rd != COUNTRY_ERD_FLAG)
 		return;
 	printk(KERN_DEBUG "ath: EEPROM regdomain sanitized\n");
 	reg->current_rd = 0x64;
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index cf9e1396bd04..d51a78330135 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1474,6 +1474,9 @@ static int wcn36xx_platform_get_resources(struct wcn36xx *wcn,
 	if (iris_node) {
 		if (of_device_is_compatible(iris_node, "qcom,wcn3620"))
 			wcn->rf_id = RF_IRIS_WCN3620;
+		if (of_device_is_compatible(iris_node, "qcom,wcn3660") ||
+		    of_device_is_compatible(iris_node, "qcom,wcn3660b"))
+			wcn->rf_id = RF_IRIS_WCN3660;
 		if (of_device_is_compatible(iris_node, "qcom,wcn3680"))
 			wcn->rf_id = RF_IRIS_WCN3680;
 		of_node_put(iris_node);
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 428546a6047f..597f740f3c25 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -97,6 +97,7 @@ enum wcn36xx_ampdu_state {
 
 #define RF_UNKNOWN	0x0000
 #define RF_IRIS_WCN3620	0x3620
+#define RF_IRIS_WCN3660	0x3660
 #define RF_IRIS_WCN3680	0x3680
 
 static inline void buff_to_be(u32 *buf, size_t len)
diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index c8bdf078d111..0841e0e370a0 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -320,6 +320,11 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 			return -ENOMEM;
 
 		transaction->aid_len = skb->data[1];
+
+		/* Checking if the length of the AID is valid */
+		if (transaction->aid_len > sizeof(transaction->aid))
+			return -EINVAL;
+
 		memcpy(transaction->aid, &skb->data[2],
 		       transaction->aid_len);
 
@@ -329,6 +334,11 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 			return -EPROTO;
 
 		transaction->params_len = skb->data[transaction->aid_len + 3];
+
+		/* Total size is allocated (skb->len - 2) minus fixed array members */
+		if (transaction->params_len > ((skb->len - 2) - sizeof(struct nfc_evt_transaction)))
+			return -EINVAL;
+
 		memcpy(transaction->params, skb->data +
 		       transaction->aid_len + 4, transaction->params_len);
 
diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index 33451f8ff755..2018b7512d3d 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -398,6 +398,7 @@ struct snd_pcm_runtime {
 	wait_queue_head_t tsleep;	/* transfer sleep */
 	struct fasync_struct *fasync;
 	bool stop_operating;		/* sync_stop will be called */
+	struct mutex buffer_mutex;	/* protect for buffer changes */
 
 	/* -- private section -- */
 	void *private_data;
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 0d21a5cdc724..ef2dd131e955 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -554,16 +554,16 @@ rcu_preempt_deferred_qs_irqrestore(struct task_struct *t, unsigned long flags)
 			raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 		}
 
-		/* Unboost if we were boosted. */
-		if (IS_ENABLED(CONFIG_RCU_BOOST) && drop_boost_mutex)
-			rt_mutex_futex_unlock(&rnp->boost_mtx.rtmutex);
-
 		/*
 		 * If this was the last task on the expedited lists,
 		 * then we need to report up the rcu_node hierarchy.
 		 */
 		if (!empty_exp && empty_exp_now)
 			rcu_report_exp_rnp(rnp, true);
+
+		/* Unboost if we were boosted. */
+		if (IS_ENABLED(CONFIG_RCU_BOOST) && drop_boost_mutex)
+			rt_mutex_futex_unlock(&rnp->boost_mtx.rtmutex);
 	} else {
 		local_irq_restore(flags);
 	}
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 61970fd839c3..8aaf9cf3d74a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1476,8 +1476,8 @@ static int __ip6_append_data(struct sock *sk,
 		      sizeof(struct frag_hdr) : 0) +
 		     rt->rt6i_nfheader_len;
 
-	if (mtu < fragheaderlen ||
-	    ((mtu - fragheaderlen) & ~7) + fragheaderlen < sizeof(struct frag_hdr))
+	if (mtu <= fragheaderlen ||
+	    ((mtu - fragheaderlen) & ~7) + fragheaderlen <= sizeof(struct frag_hdr))
 		goto emsgsize;
 
 	maxfraglen = ((mtu - fragheaderlen) & ~7) + fragheaderlen -
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 3086f4a6ae68..99305aadaa08 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -275,6 +275,7 @@ static int llc_ui_autobind(struct socket *sock, struct sockaddr_llc *addr)
 {
 	struct sock *sk = sock->sk;
 	struct llc_sock *llc = llc_sk(sk);
+	struct net_device *dev = NULL;
 	struct llc_sap *sap;
 	int rc = -EINVAL;
 
@@ -286,14 +287,14 @@ static int llc_ui_autobind(struct socket *sock, struct sockaddr_llc *addr)
 		goto out;
 	rc = -ENODEV;
 	if (sk->sk_bound_dev_if) {
-		llc->dev = dev_get_by_index(&init_net, sk->sk_bound_dev_if);
-		if (llc->dev && addr->sllc_arphrd != llc->dev->type) {
-			dev_put(llc->dev);
-			llc->dev = NULL;
+		dev = dev_get_by_index(&init_net, sk->sk_bound_dev_if);
+		if (dev && addr->sllc_arphrd != dev->type) {
+			dev_put(dev);
+			dev = NULL;
 		}
 	} else
-		llc->dev = dev_getfirstbyhwtype(&init_net, addr->sllc_arphrd);
-	if (!llc->dev)
+		dev = dev_getfirstbyhwtype(&init_net, addr->sllc_arphrd);
+	if (!dev)
 		goto out;
 	rc = -EUSERS;
 	llc->laddr.lsap = llc_ui_autoport();
@@ -303,6 +304,11 @@ static int llc_ui_autobind(struct socket *sock, struct sockaddr_llc *addr)
 	sap = llc_sap_open(llc->laddr.lsap, NULL);
 	if (!sap)
 		goto out;
+
+	/* Note: We do not expect errors from this point. */
+	llc->dev = dev;
+	dev = NULL;
+
 	memcpy(llc->laddr.mac, llc->dev->dev_addr, IFHWADDRLEN);
 	memcpy(&llc->addr, addr, sizeof(llc->addr));
 	/* assign new connection to its SAP */
@@ -310,6 +316,7 @@ static int llc_ui_autobind(struct socket *sock, struct sockaddr_llc *addr)
 	sock_reset_flag(sk, SOCK_ZAPPED);
 	rc = 0;
 out:
+	dev_put(dev);
 	return rc;
 }
 
@@ -332,6 +339,7 @@ static int llc_ui_bind(struct socket *sock, struct sockaddr *uaddr, int addrlen)
 	struct sockaddr_llc *addr = (struct sockaddr_llc *)uaddr;
 	struct sock *sk = sock->sk;
 	struct llc_sock *llc = llc_sk(sk);
+	struct net_device *dev = NULL;
 	struct llc_sap *sap;
 	int rc = -EINVAL;
 
@@ -347,25 +355,27 @@ static int llc_ui_bind(struct socket *sock, struct sockaddr *uaddr, int addrlen)
 	rc = -ENODEV;
 	rcu_read_lock();
 	if (sk->sk_bound_dev_if) {
-		llc->dev = dev_get_by_index_rcu(&init_net, sk->sk_bound_dev_if);
-		if (llc->dev) {
+		dev = dev_get_by_index_rcu(&init_net, sk->sk_bound_dev_if);
+		if (dev) {
 			if (is_zero_ether_addr(addr->sllc_mac))
-				memcpy(addr->sllc_mac, llc->dev->dev_addr,
+				memcpy(addr->sllc_mac, dev->dev_addr,
 				       IFHWADDRLEN);
-			if (addr->sllc_arphrd != llc->dev->type ||
+			if (addr->sllc_arphrd != dev->type ||
 			    !ether_addr_equal(addr->sllc_mac,
-					      llc->dev->dev_addr)) {
+					      dev->dev_addr)) {
 				rc = -EINVAL;
-				llc->dev = NULL;
+				dev = NULL;
 			}
 		}
-	} else
-		llc->dev = dev_getbyhwaddr_rcu(&init_net, addr->sllc_arphrd,
+	} else {
+		dev = dev_getbyhwaddr_rcu(&init_net, addr->sllc_arphrd,
 					   addr->sllc_mac);
-	dev_hold(llc->dev);
+	}
+	dev_hold(dev);
 	rcu_read_unlock();
-	if (!llc->dev)
+	if (!dev)
 		goto out;
+
 	if (!addr->sllc_sap) {
 		rc = -EUSERS;
 		addr->sllc_sap = llc_ui_autoport();
@@ -397,6 +407,11 @@ static int llc_ui_bind(struct socket *sock, struct sockaddr *uaddr, int addrlen)
 			goto out_put;
 		}
 	}
+
+	/* Note: We do not expect errors from this point. */
+	llc->dev = dev;
+	dev = NULL;
+
 	llc->laddr.lsap = addr->sllc_sap;
 	memcpy(llc->laddr.mac, addr->sllc_mac, IFHWADDRLEN);
 	memcpy(&llc->addr, addr, sizeof(llc->addr));
@@ -407,6 +422,7 @@ static int llc_ui_bind(struct socket *sock, struct sockaddr *uaddr, int addrlen)
 out_put:
 	llc_sap_put(sap);
 out:
+	dev_put(dev);
 	release_sock(sk);
 	return rc;
 }
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1bf83b8d8402..3f625e836a03 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2110,14 +2110,12 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 		const struct mesh_setup *setup)
 {
 	u8 *new_ie;
-	const u8 *old_ie;
 	struct ieee80211_sub_if_data *sdata = container_of(ifmsh,
 					struct ieee80211_sub_if_data, u.mesh);
 	int i;
 
 	/* allocate information elements */
 	new_ie = NULL;
-	old_ie = ifmsh->ie;
 
 	if (setup->ie_len) {
 		new_ie = kmemdup(setup->ie, setup->ie_len,
@@ -2127,7 +2125,6 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 	}
 	ifmsh->ie_len = setup->ie_len;
 	ifmsh->ie = new_ie;
-	kfree(old_ie);
 
 	/* now copy the rest of the setup parameters */
 	ifmsh->mesh_id_len = setup->mesh_id_len;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2b2e0210a7f9..3e7f97a70721 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9208,17 +9208,23 @@ int nft_parse_u32_check(const struct nlattr *attr, int max, u32 *dest)
 }
 EXPORT_SYMBOL_GPL(nft_parse_u32_check);
 
-static unsigned int nft_parse_register(const struct nlattr *attr)
+static unsigned int nft_parse_register(const struct nlattr *attr, u32 *preg)
 {
 	unsigned int reg;
 
 	reg = ntohl(nla_get_be32(attr));
 	switch (reg) {
 	case NFT_REG_VERDICT...NFT_REG_4:
-		return reg * NFT_REG_SIZE / NFT_REG32_SIZE;
+		*preg = reg * NFT_REG_SIZE / NFT_REG32_SIZE;
+		break;
+	case NFT_REG32_00...NFT_REG32_15:
+		*preg = reg + NFT_REG_SIZE / NFT_REG32_SIZE - NFT_REG32_00;
+		break;
 	default:
-		return reg + NFT_REG_SIZE / NFT_REG32_SIZE - NFT_REG32_00;
+		return -ERANGE;
 	}
+
+	return 0;
 }
 
 /**
@@ -9260,7 +9266,10 @@ int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len)
 	u32 reg;
 	int err;
 
-	reg = nft_parse_register(attr);
+	err = nft_parse_register(attr, &reg);
+	if (err < 0)
+		return err;
+
 	err = nft_validate_register_load(reg, len);
 	if (err < 0)
 		return err;
@@ -9315,7 +9324,10 @@ int nft_parse_register_store(const struct nft_ctx *ctx,
 	int err;
 	u32 reg;
 
-	reg = nft_parse_register(attr);
+	err = nft_parse_register(attr, &reg);
+	if (err < 0)
+		return err;
+
 	err = nft_validate_register_store(ctx, reg, data, type, len);
 	if (err < 0)
 		return err;
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 866cfba04d6c..907e848dbc17 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -162,7 +162,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	struct nft_rule *const *rules;
 	const struct nft_rule *rule;
 	const struct nft_expr *expr, *last;
-	struct nft_regs regs;
+	struct nft_regs regs = {};
 	unsigned int stackptr = 0;
 	struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
 	bool genbit = READ_ONCE(net->nft.gencursor);
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index 3ee9edf85815..f158f0abd25d 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -774,6 +774,11 @@ static int snd_pcm_oss_period_size(struct snd_pcm_substream *substream,
 
 	if (oss_period_size < 16)
 		return -EINVAL;
+
+	/* don't allocate too large period; 1MB period must be enough */
+	if (oss_period_size > 1024 * 1024)
+		return -ENOMEM;
+
 	runtime->oss.period_bytes = oss_period_size;
 	runtime->oss.period_frames = 1;
 	runtime->oss.periods = oss_periods;
@@ -1043,10 +1048,9 @@ static int snd_pcm_oss_change_params_locked(struct snd_pcm_substream *substream)
 			goto failure;
 	}
 #endif
-	oss_period_size *= oss_frame_size;
-
-	oss_buffer_size = oss_period_size * runtime->oss.periods;
-	if (oss_buffer_size < 0) {
+	oss_period_size = array_size(oss_period_size, oss_frame_size);
+	oss_buffer_size = array_size(oss_period_size, runtime->oss.periods);
+	if (oss_buffer_size <= 0) {
 		err = -EINVAL;
 		goto failure;
 	}
diff --git a/sound/core/oss/pcm_plugin.c b/sound/core/oss/pcm_plugin.c
index 061ba06bc926..82e180c776ae 100644
--- a/sound/core/oss/pcm_plugin.c
+++ b/sound/core/oss/pcm_plugin.c
@@ -62,7 +62,10 @@ static int snd_pcm_plugin_alloc(struct snd_pcm_plugin *plugin, snd_pcm_uframes_t
 	width = snd_pcm_format_physical_width(format->format);
 	if (width < 0)
 		return width;
-	size = frames * format->channels * width;
+	size = array3_size(frames, format->channels, width);
+	/* check for too large period size once again */
+	if (size > 1024 * 1024)
+		return -ENOMEM;
 	if (snd_BUG_ON(size % 8))
 		return -ENXIO;
 	size /= 8;
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index ba4a987ed1c6..edd9849210f2 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -969,6 +969,7 @@ int snd_pcm_attach_substream(struct snd_pcm *pcm, int stream,
 	init_waitqueue_head(&runtime->tsleep);
 
 	runtime->status->state = SNDRV_PCM_STATE_OPEN;
+	mutex_init(&runtime->buffer_mutex);
 
 	substream->runtime = runtime;
 	substream->private_data = pcm->private_data;
@@ -1002,6 +1003,7 @@ void snd_pcm_detach_substream(struct snd_pcm_substream *substream)
 	} else {
 		substream->runtime = NULL;
 	}
+	mutex_destroy(&runtime->buffer_mutex);
 	kfree(runtime);
 	put_pid(substream->pid);
 	substream->pid = NULL;
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index a144a3f68e9e..d25b1b005429 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1905,9 +1905,11 @@ static int wait_for_avail(struct snd_pcm_substream *substream,
 		if (avail >= runtime->twake)
 			break;
 		snd_pcm_stream_unlock_irq(substream);
+		mutex_unlock(&runtime->buffer_mutex);
 
 		tout = schedule_timeout(wait_time);
 
+		mutex_lock(&runtime->buffer_mutex);
 		snd_pcm_stream_lock_irq(substream);
 		set_current_state(TASK_INTERRUPTIBLE);
 		switch (runtime->status->state) {
@@ -2201,6 +2203,7 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 
 	nonblock = !!(substream->f_flags & O_NONBLOCK);
 
+	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	err = pcm_accessible_state(runtime);
 	if (err < 0)
@@ -2288,6 +2291,7 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 	if (xfer > 0 && err >= 0)
 		snd_pcm_update_state(substream, runtime);
 	snd_pcm_stream_unlock_irq(substream);
+	mutex_unlock(&runtime->buffer_mutex);
 	return xfer > 0 ? (snd_pcm_sframes_t)xfer : err;
 }
 EXPORT_SYMBOL(__snd_pcm_lib_xfer);
diff --git a/sound/core/pcm_memory.c b/sound/core/pcm_memory.c
index 7fbd1ccbb5b0..f1fb856ff4ac 100644
--- a/sound/core/pcm_memory.c
+++ b/sound/core/pcm_memory.c
@@ -158,19 +158,20 @@ static void snd_pcm_lib_preallocate_proc_write(struct snd_info_entry *entry,
 	size_t size;
 	struct snd_dma_buffer new_dmab;
 
+	mutex_lock(&substream->pcm->open_mutex);
 	if (substream->runtime) {
 		buffer->error = -EBUSY;
-		return;
+		goto unlock;
 	}
 	if (!snd_info_get_line(buffer, line, sizeof(line))) {
 		snd_info_get_str(str, line, sizeof(str));
 		size = simple_strtoul(str, NULL, 10) * 1024;
 		if ((size != 0 && size < 8192) || size > substream->dma_max) {
 			buffer->error = -EINVAL;
-			return;
+			goto unlock;
 		}
 		if (substream->dma_buffer.bytes == size)
-			return;
+			goto unlock;
 		memset(&new_dmab, 0, sizeof(new_dmab));
 		new_dmab.dev = substream->dma_buffer.dev;
 		if (size > 0) {
@@ -183,7 +184,7 @@ static void snd_pcm_lib_preallocate_proc_write(struct snd_info_entry *entry,
 					 substream->pcm->card->number, substream->pcm->device,
 					 substream->stream ? 'c' : 'p', substream->number,
 					 substream->pcm->name, size);
-				return;
+				goto unlock;
 			}
 			substream->buffer_bytes_max = size;
 		} else {
@@ -195,6 +196,8 @@ static void snd_pcm_lib_preallocate_proc_write(struct snd_info_entry *entry,
 	} else {
 		buffer->error = -EINVAL;
 	}
+ unlock:
+	mutex_unlock(&substream->pcm->open_mutex);
 }
 
 static inline void preallocate_info_init(struct snd_pcm_substream *substream)
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index d233cb3b41d8..5cac630a141c 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -672,33 +672,40 @@ static int snd_pcm_hw_params_choose(struct snd_pcm_substream *pcm,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_SND_PCM_OSS)
+#define is_oss_stream(substream)	((substream)->oss.oss)
+#else
+#define is_oss_stream(substream)	false
+#endif
+
 static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 			     struct snd_pcm_hw_params *params)
 {
 	struct snd_pcm_runtime *runtime;
-	int err, usecs;
+	int err = 0, usecs;
 	unsigned int bits;
 	snd_pcm_uframes_t frames;
 
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
+	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	switch (runtime->status->state) {
 	case SNDRV_PCM_STATE_OPEN:
 	case SNDRV_PCM_STATE_SETUP:
 	case SNDRV_PCM_STATE_PREPARED:
+		if (!is_oss_stream(substream) &&
+		    atomic_read(&substream->mmap_count))
+			err = -EBADFD;
 		break;
 	default:
-		snd_pcm_stream_unlock_irq(substream);
-		return -EBADFD;
+		err = -EBADFD;
+		break;
 	}
 	snd_pcm_stream_unlock_irq(substream);
-#if IS_ENABLED(CONFIG_SND_PCM_OSS)
-	if (!substream->oss.oss)
-#endif
-		if (atomic_read(&substream->mmap_count))
-			return -EBADFD;
+	if (err)
+		goto unlock;
 
 	snd_pcm_sync_stop(substream, true);
 
@@ -786,16 +793,21 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 	if (usecs >= 0)
 		cpu_latency_qos_add_request(&substream->latency_pm_qos_req,
 					    usecs);
-	return 0;
+	err = 0;
  _error:
-	/* hardware might be unusable from this time,
-	   so we force application to retry to set
-	   the correct hardware parameter settings */
-	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
-	if (substream->ops->hw_free != NULL)
-		substream->ops->hw_free(substream);
-	if (substream->managed_buffer_alloc)
-		snd_pcm_lib_free_pages(substream);
+	if (err) {
+		/* hardware might be unusable from this time,
+		 * so we force application to retry to set
+		 * the correct hardware parameter settings
+		 */
+		snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
+		if (substream->ops->hw_free != NULL)
+			substream->ops->hw_free(substream);
+		if (substream->managed_buffer_alloc)
+			snd_pcm_lib_free_pages(substream);
+	}
+ unlock:
+	mutex_unlock(&runtime->buffer_mutex);
 	return err;
 }
 
@@ -835,26 +847,31 @@ static int do_hw_free(struct snd_pcm_substream *substream)
 static int snd_pcm_hw_free(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime;
-	int result;
+	int result = 0;
 
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
+	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	switch (runtime->status->state) {
 	case SNDRV_PCM_STATE_SETUP:
 	case SNDRV_PCM_STATE_PREPARED:
+		if (atomic_read(&substream->mmap_count))
+			result = -EBADFD;
 		break;
 	default:
-		snd_pcm_stream_unlock_irq(substream);
-		return -EBADFD;
+		result = -EBADFD;
+		break;
 	}
 	snd_pcm_stream_unlock_irq(substream);
-	if (atomic_read(&substream->mmap_count))
-		return -EBADFD;
+	if (result)
+		goto unlock;
 	result = do_hw_free(substream);
 	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
 	cpu_latency_qos_remove_request(&substream->latency_pm_qos_req);
+ unlock:
+	mutex_unlock(&runtime->buffer_mutex);
 	return result;
 }
 
@@ -1160,15 +1177,17 @@ struct action_ops {
 static int snd_pcm_action_group(const struct action_ops *ops,
 				struct snd_pcm_substream *substream,
 				snd_pcm_state_t state,
-				bool do_lock)
+				bool stream_lock)
 {
 	struct snd_pcm_substream *s = NULL;
 	struct snd_pcm_substream *s1;
 	int res = 0, depth = 1;
 
 	snd_pcm_group_for_each_entry(s, substream) {
-		if (do_lock && s != substream) {
-			if (s->pcm->nonatomic)
+		if (s != substream) {
+			if (!stream_lock)
+				mutex_lock_nested(&s->runtime->buffer_mutex, depth);
+			else if (s->pcm->nonatomic)
 				mutex_lock_nested(&s->self_group.mutex, depth);
 			else
 				spin_lock_nested(&s->self_group.lock, depth);
@@ -1196,18 +1215,18 @@ static int snd_pcm_action_group(const struct action_ops *ops,
 		ops->post_action(s, state);
 	}
  _unlock:
-	if (do_lock) {
-		/* unlock streams */
-		snd_pcm_group_for_each_entry(s1, substream) {
-			if (s1 != substream) {
-				if (s1->pcm->nonatomic)
-					mutex_unlock(&s1->self_group.mutex);
-				else
-					spin_unlock(&s1->self_group.lock);
-			}
-			if (s1 == s)	/* end */
-				break;
+	/* unlock streams */
+	snd_pcm_group_for_each_entry(s1, substream) {
+		if (s1 != substream) {
+			if (!stream_lock)
+				mutex_unlock(&s1->runtime->buffer_mutex);
+			else if (s1->pcm->nonatomic)
+				mutex_unlock(&s1->self_group.mutex);
+			else
+				spin_unlock(&s1->self_group.lock);
 		}
+		if (s1 == s)	/* end */
+			break;
 	}
 	return res;
 }
@@ -1337,10 +1356,12 @@ static int snd_pcm_action_nonatomic(const struct action_ops *ops,
 
 	/* Guarantee the group members won't change during non-atomic action */
 	down_read(&snd_pcm_link_rwsem);
+	mutex_lock(&substream->runtime->buffer_mutex);
 	if (snd_pcm_stream_linked(substream))
 		res = snd_pcm_action_group(ops, substream, state, false);
 	else
 		res = snd_pcm_action_single(ops, substream, state);
+	mutex_unlock(&substream->runtime->buffer_mutex);
 	up_read(&snd_pcm_link_rwsem);
 	return res;
 }
@@ -1830,11 +1851,13 @@ static int snd_pcm_do_reset(struct snd_pcm_substream *substream,
 	int err = snd_pcm_ops_ioctl(substream, SNDRV_PCM_IOCTL1_RESET, NULL);
 	if (err < 0)
 		return err;
+	snd_pcm_stream_lock_irq(substream);
 	runtime->hw_ptr_base = 0;
 	runtime->hw_ptr_interrupt = runtime->status->hw_ptr -
 		runtime->status->hw_ptr % runtime->period_size;
 	runtime->silence_start = runtime->status->hw_ptr;
 	runtime->silence_filled = 0;
+	snd_pcm_stream_unlock_irq(substream);
 	return 0;
 }
 
@@ -1842,10 +1865,12 @@ static void snd_pcm_post_reset(struct snd_pcm_substream *substream,
 			       snd_pcm_state_t state)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
+	snd_pcm_stream_lock_irq(substream);
 	runtime->control->appl_ptr = runtime->status->hw_ptr;
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK &&
 	    runtime->silence_size > 0)
 		snd_pcm_playback_silence(substream, ULONG_MAX);
+	snd_pcm_stream_unlock_irq(substream);
 }
 
 static const struct action_ops snd_pcm_action_reset = {
diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index 01f296d524ce..cb60a07d39a8 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -938,8 +938,8 @@ static int snd_ac97_ad18xx_pcm_get_volume(struct snd_kcontrol *kcontrol, struct
 	int codec = kcontrol->private_value & 3;
 	
 	mutex_lock(&ac97->page_mutex);
-	ucontrol->value.integer.value[0] = 31 - ((ac97->spec.ad18xx.pcmreg[codec] >> 0) & 31);
-	ucontrol->value.integer.value[1] = 31 - ((ac97->spec.ad18xx.pcmreg[codec] >> 8) & 31);
+	ucontrol->value.integer.value[0] = 31 - ((ac97->spec.ad18xx.pcmreg[codec] >> 8) & 31);
+	ucontrol->value.integer.value[1] = 31 - ((ac97->spec.ad18xx.pcmreg[codec] >> 0) & 31);
 	mutex_unlock(&ac97->page_mutex);
 	return 0;
 }
diff --git a/sound/pci/cmipci.c b/sound/pci/cmipci.c
index ea20236f35db..dc4232bac749 100644
--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -298,7 +298,6 @@ MODULE_PARM_DESC(joystick_port, "Joystick port address.");
 #define CM_MICGAINZ		0x01	/* mic boost */
 #define CM_MICGAINZ_SHIFT	0
 
-#define CM_REG_MIXER3		0x24
 #define CM_REG_AUX_VOL		0x26
 #define CM_VAUXL_MASK		0xf0
 #define CM_VAUXR_MASK		0x0f
@@ -3267,7 +3266,7 @@ static int snd_cmipci_probe(struct pci_dev *pci,
  */
 static const unsigned char saved_regs[] = {
 	CM_REG_FUNCTRL1, CM_REG_CHFORMAT, CM_REG_LEGACY_CTRL, CM_REG_MISC_CTRL,
-	CM_REG_MIXER0, CM_REG_MIXER1, CM_REG_MIXER2, CM_REG_MIXER3, CM_REG_PLL,
+	CM_REG_MIXER0, CM_REG_MIXER1, CM_REG_MIXER2, CM_REG_AUX_VOL, CM_REG_PLL,
 	CM_REG_CH0_FRAME1, CM_REG_CH0_FRAME2,
 	CM_REG_CH1_FRAME1, CM_REG_CH1_FRAME2, CM_REG_EXT_MISC,
 	CM_REG_INT_STATUS, CM_REG_INT_HLDCLR, CM_REG_FUNCTRL0,
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 83b56c1ba399..08bf8a77a3e4 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8866,6 +8866,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e8e, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x1d42, "ASUS Zephyrus G14 2022", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x16b2, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
 	SND_PCI_QUIRK(0x1043, 0x831a, "ASUS P901", ALC269_FIXUP_STEREO_DMIC),
@@ -8949,6 +8950,8 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x8561, "Clevo NH[57][0-9][ER][ACDH]Q", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1558, 0x8562, "Clevo NH[57][0-9]RZ[Q]", ALC269_FIXUP_DMIC),
 	SND_PCI_QUIRK(0x1558, 0x8668, "Clevo NP50B[BE]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x866d, "Clevo NP5[05]PN[HJK]", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x867d, "Clevo NP7[01]PN[HJK]", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8680, "Clevo NJ50LU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8686, "Clevo NH50[CZ]U", ALC256_FIXUP_MIC_NO_PRESENCE_AND_RESUME),
 	SND_PCI_QUIRK(0x1558, 0x8a20, "Clevo NH55DCQ-Y", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
@@ -10909,6 +10912,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x069f, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1632, "HP RP5800", ALC662_FIXUP_HP_RP5800),
 	SND_PCI_QUIRK(0x103c, 0x873e, "HP", ALC671_FIXUP_HP_HEADSET_MIC2),
+	SND_PCI_QUIRK(0x103c, 0x885f, "HP 288 Pro G8", ALC671_FIXUP_HP_HEADSET_MIC2),
 	SND_PCI_QUIRK(0x1043, 0x1080, "Asus UX501VW", ALC668_FIXUP_HEADSET_MODE),
 	SND_PCI_QUIRK(0x1043, 0x11cd, "Asus N550", ALC662_FIXUP_ASUS_Nx50),
 	SND_PCI_QUIRK(0x1043, 0x129d, "Asus N750", ALC662_FIXUP_ASUS_Nx50),
diff --git a/sound/soc/sti/uniperif_player.c b/sound/soc/sti/uniperif_player.c
index 2ed92c990b97..dd9013c47664 100644
--- a/sound/soc/sti/uniperif_player.c
+++ b/sound/soc/sti/uniperif_player.c
@@ -91,7 +91,7 @@ static irqreturn_t uni_player_irq_handler(int irq, void *dev_id)
 			SET_UNIPERIF_ITM_BCLR_FIFO_ERROR(player);
 
 			/* Stop the player */
-			snd_pcm_stop_xrun(player->substream);
+			snd_pcm_stop(player->substream, SNDRV_PCM_STATE_XRUN);
 		}
 
 		ret = IRQ_HANDLED;
@@ -105,7 +105,7 @@ static irqreturn_t uni_player_irq_handler(int irq, void *dev_id)
 		SET_UNIPERIF_ITM_BCLR_DMA_ERROR(player);
 
 		/* Stop the player */
-		snd_pcm_stop_xrun(player->substream);
+		snd_pcm_stop(player->substream, SNDRV_PCM_STATE_XRUN);
 
 		ret = IRQ_HANDLED;
 	}
@@ -138,7 +138,7 @@ static irqreturn_t uni_player_irq_handler(int irq, void *dev_id)
 		dev_err(player->dev, "Underflow recovery failed\n");
 
 		/* Stop the player */
-		snd_pcm_stop_xrun(player->substream);
+		snd_pcm_stop(player->substream, SNDRV_PCM_STATE_XRUN);
 
 		ret = IRQ_HANDLED;
 	}
diff --git a/sound/soc/sti/uniperif_reader.c b/sound/soc/sti/uniperif_reader.c
index 136059331211..065c5f0d1f5f 100644
--- a/sound/soc/sti/uniperif_reader.c
+++ b/sound/soc/sti/uniperif_reader.c
@@ -65,7 +65,7 @@ static irqreturn_t uni_reader_irq_handler(int irq, void *dev_id)
 	if (unlikely(status & UNIPERIF_ITS_FIFO_ERROR_MASK(reader))) {
 		dev_err(reader->dev, "FIFO error detected\n");
 
-		snd_pcm_stop_xrun(reader->substream);
+		snd_pcm_stop(reader->substream, SNDRV_PCM_STATE_XRUN);
 
 		ret = IRQ_HANDLED;
 	}
diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index 55eea90ee993..6ffd23f2ee65 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -536,6 +536,16 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.id = USB_ID(0x1b1c, 0x0a41),
 		.map = corsair_virtuoso_map,
 	},
+	{
+		/* Corsair Virtuoso SE Latest (wired mode) */
+		.id = USB_ID(0x1b1c, 0x0a3f),
+		.map = corsair_virtuoso_map,
+	},
+	{
+		/* Corsair Virtuoso SE Latest (wireless mode) */
+		.id = USB_ID(0x1b1c, 0x0a40),
+		.map = corsair_virtuoso_map,
+	},
 	{
 		/* Corsair Virtuoso (wireless mode) */
 		.id = USB_ID(0x1b1c, 0x0a42),
diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index d48729e6a3b0..d12b87e52d22 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -3362,9 +3362,10 @@ void snd_usb_mixer_fu_apply_quirk(struct usb_mixer_interface *mixer,
 		if (unitid == 7 && cval->control == UAC_FU_VOLUME)
 			snd_dragonfly_quirk_db_scale(mixer, cval, kctl);
 		break;
-	/* lowest playback value is muted on C-Media devices */
-	case USB_ID(0x0d8c, 0x000c):
-	case USB_ID(0x0d8c, 0x0014):
+	/* lowest playback value is muted on some devices */
+	case USB_ID(0x0d8c, 0x000c): /* C-Media */
+	case USB_ID(0x0d8c, 0x0014): /* C-Media */
+	case USB_ID(0x19f7, 0x0003): /* RODE NT-USB */
 		if (strstr(kctl->id.name, "Playback"))
 			cval->min_mute = 1;
 		break;
