Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC714347D6
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 11:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhJTJXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 05:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230092AbhJTJXm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 05:23:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3167361359;
        Wed, 20 Oct 2021 09:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634721688;
        bh=nw2Q0RwMQaOtExRHN7YYHBQyZuHasc6iQvaR3Md0ZjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c05WuSYNH1VSW0GSy/3ChXPLRQ/dYbve9McUGlXjHOTb53K24tGm2uGOgToiLdfcC
         vET5pbWFgbyI4rjGYOhk/aJjs4MhT5NYVAKkGrPNnHMoI//LgNoiF/5ipbzSplV5OX
         x7/YTChNimiW+30XYVKnIxoYniN1epaxT8vZQqiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.252
Date:   Wed, 20 Oct 2021 11:21:18 +0200
Message-Id: <1634721676150155@kroah.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <163472167652240@kroah.com>
References: <163472167652240@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 184089eb1bdb..0e28fc045808 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 251
+SUBLEVEL = 252
 EXTRAVERSION =
 NAME = Petit Gorille
 
@@ -1162,7 +1162,7 @@ endef
 
 define filechk_version.h
 	(echo \#define LINUX_VERSION_CODE $(shell                         \
-	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
+	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255); \
 	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
 endef
 
diff --git a/arch/s390/lib/string.c b/arch/s390/lib/string.c
index dbf2fdad2724..7cdbc3e733a2 100644
--- a/arch/s390/lib/string.c
+++ b/arch/s390/lib/string.c
@@ -227,14 +227,13 @@ EXPORT_SYMBOL(strcmp);
  */
 char * strrchr(const char * s, int c)
 {
-       size_t len = __strend(s) - s;
-
-       if (len)
-	       do {
-		       if (s[len] == (char) c)
-			       return (char *) s + len;
-	       } while (--len > 0);
-       return NULL;
+	ssize_t len = __strend(s) - s;
+
+	do {
+		if (s[len] == (char)c)
+			return (char *)s + len;
+	} while (--len >= 0);
+	return NULL;
 }
 EXPORT_SYMBOL(strrchr);
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 64edc125c122..290254849f97 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1456,7 +1456,6 @@ config AMD_MEM_ENCRYPT
 
 config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
 	bool "Activate AMD Secure Memory Encryption (SME) by default"
-	default y
 	depends on AMD_MEM_ENCRYPT
 	---help---
 	  Say yes to have system memory encrypted by default if running on
diff --git a/drivers/acpi/arm64/gtdt.c b/drivers/acpi/arm64/gtdt.c
index fbaa4effd24b..f35ff5fe612b 100644
--- a/drivers/acpi/arm64/gtdt.c
+++ b/drivers/acpi/arm64/gtdt.c
@@ -39,7 +39,7 @@ struct acpi_gtdt_descriptor {
 
 static struct acpi_gtdt_descriptor acpi_gtdt_desc __initdata;
 
-static inline void *next_platform_timer(void *platform_timer)
+static inline __init void *next_platform_timer(void *platform_timer)
 {
 	struct acpi_gtdt_header *gh = platform_timer;
 
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 53828b6c3044..9968b074fa96 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -329,7 +329,8 @@ static unsigned int pdc_data_xfer_vlb(struct ata_queued_cmd *qc,
 			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 
 		if (unlikely(slop)) {
-			__le32 pad;
+			__le32 pad = 0;
+
 			if (rw == READ) {
 				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
 				memcpy(buf + buflen - slop, &pad, slop);
@@ -719,7 +720,8 @@ static unsigned int vlb32_data_xfer(struct ata_queued_cmd *qc,
 			ioread32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 
 		if (unlikely(slop)) {
-			__le32 pad;
+			__le32 pad = 0;
+
 			if (rw == WRITE) {
 				memcpy(&pad, buf + buflen - slop, slop);
 				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index efbb13c6581e..d72c08e8d6cf 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -39,8 +39,6 @@
 
 #define INDENT_SP	" "
 
-static char rcd_decode_str[CPER_REC_LEN];
-
 /*
  * CPER record ID need to be unique even after reboot, because record
  * ID is used as index for ERST storage, while CPER records from
@@ -416,6 +414,7 @@ const char *cper_mem_err_unpack(struct trace_seq *p,
 				struct cper_mem_err_compact *cmem)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
+	char rcd_decode_str[CPER_REC_LEN];
 
 	if (cper_mem_err_location(cmem, rcd_decode_str))
 		trace_seq_printf(p, "%s", rcd_decode_str);
@@ -430,6 +429,7 @@ static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem,
 	int len)
 {
 	struct cper_mem_err_compact cmem;
+	char rcd_decode_str[CPER_REC_LEN];
 
 	/* Don't trust UEFI 2.1/2.2 structure with bad validation bits */
 	if (len == sizeof(struct cper_sec_mem_err_old) &&
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index dd7f63354ca0..60a32440daff 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -259,7 +259,7 @@ static void virt_efi_reset_system(int reset_type,
 				  unsigned long data_size,
 				  efi_char16_t *data)
 {
-	if (down_interruptible(&efi_runtime_lock)) {
+	if (down_trylock(&efi_runtime_lock)) {
 		pr_warn("failed to invoke the reset_system() runtime service:\n"
 			"could not get exclusive access to the firmware\n");
 		return;
diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index b9cb7c09e05a..ef4e81d77446 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -442,7 +442,7 @@ static int dsi_bus_clk_enable(struct msm_dsi_host *msm_host)
 
 	return 0;
 err:
-	for (; i > 0; i--)
+	while (--i >= 0)
 		clk_disable_unprepare(msm_host->bus_clks[i]);
 
 	return ret;
diff --git a/drivers/gpu/drm/msm/edp/edp_ctrl.c b/drivers/gpu/drm/msm/edp/edp_ctrl.c
index e32a4a4f3797..64faaa0c9845 100644
--- a/drivers/gpu/drm/msm/edp/edp_ctrl.c
+++ b/drivers/gpu/drm/msm/edp/edp_ctrl.c
@@ -1090,7 +1090,7 @@ void msm_edp_ctrl_power(struct edp_ctrl *ctrl, bool on)
 int msm_edp_ctrl_init(struct msm_edp *edp)
 {
 	struct edp_ctrl *ctrl = NULL;
-	struct device *dev = &edp->pdev->dev;
+	struct device *dev;
 	int ret;
 
 	if (!edp) {
@@ -1098,6 +1098,7 @@ int msm_edp_ctrl_init(struct msm_edp *edp)
 		return -EINVAL;
 	}
 
+	dev = &edp->pdev->dev;
 	ctrl = devm_kzalloc(dev, sizeof(*ctrl), GFP_KERNEL);
 	if (!ctrl)
 		return -ENOMEM;
diff --git a/drivers/iio/adc/aspeed_adc.c b/drivers/iio/adc/aspeed_adc.c
index c02b23d675cb..83656d8fc0ae 100644
--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -187,6 +187,7 @@ static int aspeed_adc_probe(struct platform_device *pdev)
 
 	data = iio_priv(indio_dev);
 	data->dev = &pdev->dev;
+	platform_set_drvdata(pdev, indio_dev);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	data->base = devm_ioremap_resource(&pdev->dev, res);
diff --git a/drivers/iio/adc/ti-adc128s052.c b/drivers/iio/adc/ti-adc128s052.c
index 89dfbd31be5c..b7c7cba2dc09 100644
--- a/drivers/iio/adc/ti-adc128s052.c
+++ b/drivers/iio/adc/ti-adc128s052.c
@@ -169,7 +169,13 @@ static int adc128_probe(struct spi_device *spi)
 	mutex_init(&adc->lock);
 
 	ret = iio_device_register(indio_dev);
+	if (ret)
+		goto err_disable_regulator;
 
+	return 0;
+
+err_disable_regulator:
+	regulator_disable(adc->reg);
 	return ret;
 }
 
diff --git a/drivers/iio/common/ssp_sensors/ssp_spi.c b/drivers/iio/common/ssp_sensors/ssp_spi.c
index 704284a475ae..645749b90ec0 100644
--- a/drivers/iio/common/ssp_sensors/ssp_spi.c
+++ b/drivers/iio/common/ssp_sensors/ssp_spi.c
@@ -147,7 +147,7 @@ static int ssp_print_mcu_debug(char *data_frame, int *data_index,
 	if (length > received_len - *data_index || length <= 0) {
 		ssp_dbg("[SSP]: MSG From MCU-invalid debug length(%d/%d)\n",
 			length, received_len);
-		return length ? length : -EPROTO;
+		return -EPROTO;
 	}
 
 	ssp_dbg("[SSP]: MSG From MCU - %s\n", &data_frame[*data_index]);
@@ -286,6 +286,8 @@ static int ssp_parse_dataframe(struct ssp_data *data, char *dataframe, int len)
 	for (idx = 0; idx < len;) {
 		switch (dataframe[idx++]) {
 		case SSP_MSG2AP_INST_BYPASS_DATA:
+			if (idx >= len)
+				return -EPROTO;
 			sd = dataframe[idx++];
 			if (sd < 0 || sd >= SSP_SENSOR_MAX) {
 				dev_err(SSP_DEV,
@@ -295,10 +297,13 @@ static int ssp_parse_dataframe(struct ssp_data *data, char *dataframe, int len)
 
 			if (indio_devs[sd]) {
 				spd = iio_priv(indio_devs[sd]);
-				if (spd->process_data)
+				if (spd->process_data) {
+					if (idx >= len)
+						return -EPROTO;
 					spd->process_data(indio_devs[sd],
 							  &dataframe[idx],
 							  data->timestamp);
+				}
 			} else {
 				dev_err(SSP_DEV, "no client for frame\n");
 			}
@@ -306,6 +311,8 @@ static int ssp_parse_dataframe(struct ssp_data *data, char *dataframe, int len)
 			idx += ssp_offset_map[sd];
 			break;
 		case SSP_MSG2AP_INST_DEBUG_DATA:
+			if (idx >= len)
+				return -EPROTO;
 			sd = ssp_print_mcu_debug(dataframe, &idx, len);
 			if (sd) {
 				dev_err(SSP_DEV,
diff --git a/drivers/iio/light/opt3001.c b/drivers/iio/light/opt3001.c
index 743fd2cfdd54..75dc0ff5873e 100644
--- a/drivers/iio/light/opt3001.c
+++ b/drivers/iio/light/opt3001.c
@@ -283,6 +283,8 @@ static int opt3001_get_lux(struct opt3001 *opt, int *val, int *val2)
 		ret = wait_event_timeout(opt->result_ready_queue,
 				opt->result_ready,
 				msecs_to_jiffies(OPT3001_RESULT_READY_LONG));
+		if (ret == 0)
+			return -ETIMEDOUT;
 	} else {
 		/* Sleep for result ready time */
 		timeout = (opt->int_time == OPT3001_INT_TIME_SHORT) ?
@@ -319,9 +321,7 @@ static int opt3001_get_lux(struct opt3001 *opt, int *val, int *val2)
 		/* Disallow IRQ to access the device while lock is active */
 		opt->ok_to_ignore_lock = false;
 
-	if (ret == 0)
-		return -ETIMEDOUT;
-	else if (ret < 0)
+	if (ret < 0)
 		return ret;
 
 	if (opt->use_irq) {
diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 4168ed0ef187..f8f6bd92e314 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -348,6 +348,7 @@ static const struct xpad_device {
 	{ 0x24c6, 0x5b03, "Thrustmaster Ferrari 458 Racing Wheel", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0x5d04, "Razer Sabertooth", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0xfafe, "Rock Candy Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
+	{ 0x3285, 0x0607, "Nacon GC-100", 0, XTYPE_XBOX360 },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },
 	{ 0x0000, 0x0000, "Generic X-Box pad", 0, XTYPE_UNKNOWN }
@@ -464,6 +465,7 @@ static const struct usb_device_id xpad_table[] = {
 	XPAD_XBOXONE_VENDOR(0x24c6),		/* PowerA Controllers */
 	XPAD_XBOXONE_VENDOR(0x2e24),		/* Hyperkin Duke X-Box One pad */
 	XPAD_XBOX360_VENDOR(0x2f24),		/* GameSir Controllers */
+	XPAD_XBOX360_VENDOR(0x3285),		/* Nacon GC-100 */
 	{ }
 };
 
diff --git a/drivers/misc/cb710/sgbuf2.c b/drivers/misc/cb710/sgbuf2.c
index 2a40d0efdff5..4d2a72a537d4 100644
--- a/drivers/misc/cb710/sgbuf2.c
+++ b/drivers/misc/cb710/sgbuf2.c
@@ -50,7 +50,7 @@ static inline bool needs_unaligned_copy(const void *ptr)
 #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 	return false;
 #else
-	return ((ptr - NULL) & 3) != 0;
+	return ((uintptr_t)ptr & 3) != 0;
 #endif
 }
 
diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index c60421339a98..d208b585c958 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -99,6 +99,7 @@ config JME
 config KORINA
 	tristate "Korina (IDT RC32434) Ethernet support"
 	depends on MIKROTIK_RB532
+	select CRC32
 	---help---
 	  If you have a Mikrotik RouterBoard 500 or IDT RC32434
 	  based system say Y. Otherwise say N.
diff --git a/drivers/net/ethernet/arc/Kconfig b/drivers/net/ethernet/arc/Kconfig
index e743ddf46343..fdd854c2a963 100644
--- a/drivers/net/ethernet/arc/Kconfig
+++ b/drivers/net/ethernet/arc/Kconfig
@@ -20,6 +20,7 @@ config ARC_EMAC_CORE
 	depends on ARC || ARCH_ROCKCHIP || COMPILE_TEST
 	select MII
 	select PHYLIB
+	select CRC32
 
 config ARC_EMAC
 	tristate "ARC EMAC support"
diff --git a/drivers/net/ethernet/microchip/encx24j600-regmap.c b/drivers/net/ethernet/microchip/encx24j600-regmap.c
index 44bb04d4d21b..46181559d1f1 100644
--- a/drivers/net/ethernet/microchip/encx24j600-regmap.c
+++ b/drivers/net/ethernet/microchip/encx24j600-regmap.c
@@ -505,13 +505,19 @@ static struct regmap_bus phymap_encx24j600 = {
 	.reg_read = regmap_encx24j600_phy_reg_read,
 };
 
-void devm_regmap_init_encx24j600(struct device *dev,
-				 struct encx24j600_context *ctx)
+int devm_regmap_init_encx24j600(struct device *dev,
+				struct encx24j600_context *ctx)
 {
 	mutex_init(&ctx->mutex);
 	regcfg.lock_arg = ctx;
 	ctx->regmap = devm_regmap_init(dev, &regmap_encx24j600, ctx, &regcfg);
+	if (IS_ERR(ctx->regmap))
+		return PTR_ERR(ctx->regmap);
 	ctx->phymap = devm_regmap_init(dev, &phymap_encx24j600, ctx, &phycfg);
+	if (IS_ERR(ctx->phymap))
+		return PTR_ERR(ctx->phymap);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(devm_regmap_init_encx24j600);
 
diff --git a/drivers/net/ethernet/microchip/encx24j600.c b/drivers/net/ethernet/microchip/encx24j600.c
index 84b6ad76f5bc..ff45326eb696 100644
--- a/drivers/net/ethernet/microchip/encx24j600.c
+++ b/drivers/net/ethernet/microchip/encx24j600.c
@@ -1032,10 +1032,13 @@ static int encx24j600_spi_probe(struct spi_device *spi)
 	priv->speed = SPEED_100;
 
 	priv->ctx.spi = spi;
-	devm_regmap_init_encx24j600(&spi->dev, &priv->ctx);
 	ndev->irq = spi->irq;
 	ndev->netdev_ops = &encx24j600_netdev_ops;
 
+	ret = devm_regmap_init_encx24j600(&spi->dev, &priv->ctx);
+	if (ret)
+		goto out_free;
+
 	mutex_init(&priv->lock);
 
 	/* Reset device and check if it is connected */
diff --git a/drivers/net/ethernet/microchip/encx24j600_hw.h b/drivers/net/ethernet/microchip/encx24j600_hw.h
index f604a260ede7..711147a159aa 100644
--- a/drivers/net/ethernet/microchip/encx24j600_hw.h
+++ b/drivers/net/ethernet/microchip/encx24j600_hw.h
@@ -15,8 +15,8 @@ struct encx24j600_context {
 	int bank;
 };
 
-void devm_regmap_init_encx24j600(struct device *dev,
-				 struct encx24j600_context *ctx);
+int devm_regmap_init_encx24j600(struct device *dev,
+				struct encx24j600_context *ctx);
 
 /* Single-byte instructions */
 #define BANK_SELECT(bank) (0xC0 | ((bank & (BANK_MASK >> BANK_SHIFT)) << 1))
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 462eda926b1c..55538722f6f3 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -8574,7 +8574,7 @@ static void s2io_io_resume(struct pci_dev *pdev)
 			return;
 		}
 
-		if (s2io_set_mac_addr(netdev, netdev->dev_addr) == FAILURE) {
+		if (do_s2io_prog_unicast(netdev, netdev->dev_addr) == FAILURE) {
 			s2io_card_down(sp);
 			pr_err("Can't restore mac addr after reset.\n");
 			return;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 62d514b60e23..df15c2a7f4d4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -998,6 +998,7 @@ static int qed_slowpath_start(struct qed_dev *cdev,
 			} else {
 				DP_NOTICE(cdev,
 					  "Failed to acquire PTT for aRFS\n");
+				rc = -EINVAL;
 				goto err;
 			}
 		}
diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index f28bd74ac275..bbebfe3d67ba 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -98,6 +98,10 @@ config USB_RTL8150
 config USB_RTL8152
 	tristate "Realtek RTL8152/RTL8153 Based USB Ethernet Adapters"
 	select MII
+	select CRC32
+	select CRYPTO
+	select CRYPTO_HASH
+	select CRYPTO_SHA256
 	help
 	  This option adds support for Realtek RTL8152 based USB 2.0
 	  10/100 Ethernet adapters and RTL8153 based USB 3.0 10/100/1000
diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 08b171731664..9fca86abc5a9 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -987,7 +987,8 @@ static inline void nvmem_shift_read_buffer_in_place(struct nvmem_cell *cell,
 		*p-- = 0;
 
 	/* clear msb bits if any leftover in the last byte */
-	*p &= GENMASK((cell->nbits%BITS_PER_BYTE) - 1, 0);
+	if (cell->nbits % BITS_PER_BYTE)
+		*p &= GENMASK((cell->nbits % BITS_PER_BYTE) - 1, 0);
 }
 
 static int __nvmem_cell_read(struct nvmem_device *nvmem,
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index efcadca832b4..0e419cb53de4 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -38,6 +38,7 @@
 #define PCI_VENDOR_ID_FRESCO_LOGIC	0x1b73
 #define PCI_DEVICE_ID_FRESCO_LOGIC_PDK	0x1000
 #define PCI_DEVICE_ID_FRESCO_LOGIC_FL1009	0x1009
+#define PCI_DEVICE_ID_FRESCO_LOGIC_FL1100	0x1100
 #define PCI_DEVICE_ID_FRESCO_LOGIC_FL1400	0x1400
 
 #define PCI_VENDOR_ID_ETRON		0x1b6f
@@ -99,6 +100,7 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	/* Look for vendor-specific quirks */
 	if (pdev->vendor == PCI_VENDOR_ID_FRESCO_LOGIC &&
 			(pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK ||
+			 pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1100 ||
 			 pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1400)) {
 		if (pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK &&
 				pdev->revision == 0x0) {
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 420ad7dc4fe8..d0c12de1c6d0 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -350,16 +350,22 @@ static void xhci_handle_stopped_cmd_ring(struct xhci_hcd *xhci,
 /* Must be called with xhci->lock held, releases and aquires lock back */
 static int xhci_abort_cmd_ring(struct xhci_hcd *xhci, unsigned long flags)
 {
-	u64 temp_64;
+	u32 temp_32;
 	int ret;
 
 	xhci_dbg(xhci, "Abort command ring\n");
 
 	reinit_completion(&xhci->cmd_ring_stop_completion);
 
-	temp_64 = xhci_read_64(xhci, &xhci->op_regs->cmd_ring);
-	xhci_write_64(xhci, temp_64 | CMD_RING_ABORT,
-			&xhci->op_regs->cmd_ring);
+	/*
+	 * The control bits like command stop, abort are located in lower
+	 * dword of the command ring control register. Limit the write
+	 * to the lower dword to avoid corrupting the command ring pointer
+	 * in case if the command ring is stopped by the time upper dword
+	 * is written.
+	 */
+	temp_32 = readl(&xhci->op_regs->cmd_ring);
+	writel(temp_32 | CMD_RING_ABORT, &xhci->op_regs->cmd_ring);
 
 	/* Section 4.6.1.2 of xHCI 1.0 spec says software should also time the
 	 * completion of the Command Abort operation. If CRR is not negated in 5
diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index a582c3847dc2..b3eebbc71df7 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -939,11 +939,13 @@ static int dsps_probe(struct platform_device *pdev)
 	if (usb_get_dr_mode(&pdev->dev) == USB_DR_MODE_PERIPHERAL) {
 		ret = dsps_setup_optional_vbus_irq(pdev, glue);
 		if (ret)
-			goto err;
+			goto unregister_pdev;
 	}
 
 	return 0;
 
+unregister_pdev:
+	platform_device_unregister(glue->musb);
 err:
 	pm_runtime_disable(&pdev->dev);
 	iounmap(glue->usbss_base);
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index dabf7f2d8eb1..f50de529445d 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -249,11 +249,13 @@ static void option_instat_callback(struct urb *urb);
 /* These Quectel products use Quectel's vendor ID */
 #define QUECTEL_PRODUCT_EC21			0x0121
 #define QUECTEL_PRODUCT_EC25			0x0125
+#define QUECTEL_PRODUCT_EG91			0x0191
 #define QUECTEL_PRODUCT_EG95			0x0195
 #define QUECTEL_PRODUCT_BG96			0x0296
 #define QUECTEL_PRODUCT_EP06			0x0306
 #define QUECTEL_PRODUCT_EM12			0x0512
 #define QUECTEL_PRODUCT_RM500Q			0x0800
+#define QUECTEL_PRODUCT_EC200S_CN		0x6002
 #define QUECTEL_PRODUCT_EC200T			0x6026
 
 #define CMOTECH_VENDOR_ID			0x16d8
@@ -1114,6 +1116,9 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC25, 0xff, 0xff, 0xff),
 	  .driver_info = NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC25, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG91, 0xff, 0xff, 0xff),
+	  .driver_info = NUMEP2 },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG91, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG95, 0xff, 0xff, 0xff),
 	  .driver_info = NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG95, 0xff, 0, 0) },
@@ -1131,6 +1136,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0xff, 0x10),
 	  .driver_info = ZLP },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200S_CN, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200T, 0xff, 0, 0) },
 
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6001) },
@@ -1230,6 +1236,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1203, 0xff),	/* Telit LE910Cx (RNDIS) */
 	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1204, 0xff),	/* Telit LE910Cx (MBIM) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE910_USBCFG4),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE920),
diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 7662b2eb50d8..8240c95c1d22 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -169,6 +169,7 @@ static const struct usb_device_id id_table[] = {
 	{DEVICE_SWI(0x1199, 0x907b)},	/* Sierra Wireless EM74xx */
 	{DEVICE_SWI(0x1199, 0x9090)},	/* Sierra Wireless EM7565 QDL */
 	{DEVICE_SWI(0x1199, 0x9091)},	/* Sierra Wireless EM7565 */
+	{DEVICE_SWI(0x1199, 0x90d2)},	/* Sierra Wireless EM9191 QDL */
 	{DEVICE_SWI(0x413c, 0x81a2)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card */
 	{DEVICE_SWI(0x413c, 0x81a3)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card */
 	{DEVICE_SWI(0x413c, 0x81a4)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card */
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index bf7ff3934d7f..4230b4e72f4a 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -222,6 +222,17 @@ static int virtio_dev_probe(struct device *_d)
 		driver_features_legacy = driver_features;
 	}
 
+	/*
+	 * Some devices detect legacy solely via F_VERSION_1. Write
+	 * F_VERSION_1 to force LE config space accesses before FEATURES_OK for
+	 * these when needed.
+	 */
+	if (drv->validate && !virtio_legacy_is_little_endian()
+			  && device_features & BIT_ULL(VIRTIO_F_VERSION_1)) {
+		dev->features = BIT_ULL(VIRTIO_F_VERSION_1);
+		dev->config->finalize_features(dev);
+	}
+
 	if (device_features & (1ULL << VIRTIO_F_VERSION_1))
 		dev->features = driver_features & device_features;
 	else
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index fbcfee38583b..08ab7ab909a8 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1161,7 +1161,10 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 	/* look for a conflicting sequence number */
 	di = btrfs_lookup_dir_index_item(trans, root, path, btrfs_ino(dir),
 					 ref_index, name, namelen, 0);
-	if (di && !IS_ERR(di)) {
+	if (IS_ERR(di)) {
+		if (PTR_ERR(di) != -ENOENT)
+			return PTR_ERR(di);
+	} else if (di) {
 		ret = drop_one_dir_item(trans, root, path, dir, di);
 		if (ret)
 			return ret;
@@ -1171,7 +1174,9 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 	/* look for a conflicing name */
 	di = btrfs_lookup_dir_item(trans, root, path, btrfs_ino(dir),
 				   name, namelen, 0);
-	if (di && !IS_ERR(di)) {
+	if (IS_ERR(di)) {
+		return PTR_ERR(di);
+	} else if (di) {
 		ret = drop_one_dir_item(trans, root, path, dir, di);
 		if (ret)
 			return ret;
@@ -1725,8 +1730,8 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 	struct btrfs_key log_key;
 	struct inode *dir;
 	u8 log_type;
-	int exists;
-	int ret = 0;
+	bool exists;
+	int ret;
 	bool update_size = (key->type == BTRFS_DIR_INDEX_KEY);
 	bool name_added = false;
 
@@ -1746,12 +1751,12 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 		   name_len);
 
 	btrfs_dir_item_key_to_cpu(eb, di, &log_key);
-	exists = btrfs_lookup_inode(trans, root, path, &log_key, 0);
-	if (exists == 0)
-		exists = 1;
-	else
-		exists = 0;
+	ret = btrfs_lookup_inode(trans, root, path, &log_key, 0);
 	btrfs_release_path(path);
+	if (ret < 0)
+		goto out;
+	exists = (ret == 0);
+	ret = 0;
 
 	if (key->type == BTRFS_DIR_ITEM_KEY) {
 		dst_di = btrfs_lookup_dir_item(trans, root, path, key->objectid,
@@ -1766,7 +1771,14 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 		ret = -EINVAL;
 		goto out;
 	}
-	if (IS_ERR_OR_NULL(dst_di)) {
+
+	if (dst_di == ERR_PTR(-ENOENT))
+		dst_di = NULL;
+
+	if (IS_ERR(dst_di)) {
+		ret = PTR_ERR(dst_di);
+		goto out;
+	} else if (!dst_di) {
 		/* we need a sequence number to insert, so we only
 		 * do inserts for the BTRFS_DIR_INDEX_KEY types
 		 */
diff --git a/net/nfc/af_nfc.c b/net/nfc/af_nfc.c
index d3e594eb36d0..adf16ff007cc 100644
--- a/net/nfc/af_nfc.c
+++ b/net/nfc/af_nfc.c
@@ -72,6 +72,9 @@ int nfc_proto_register(const struct nfc_protocol *nfc_proto)
 		proto_tab[nfc_proto->id] = nfc_proto;
 	write_unlock(&proto_tab_lock);
 
+	if (rc)
+		proto_unregister(nfc_proto->proto);
+
 	return rc;
 }
 EXPORT_SYMBOL(nfc_proto_register);
diff --git a/net/nfc/digital_core.c b/net/nfc/digital_core.c
index de6dd37d04c7..440322d069bb 100644
--- a/net/nfc/digital_core.c
+++ b/net/nfc/digital_core.c
@@ -286,6 +286,7 @@ int digital_tg_configure_hw(struct nfc_digital_dev *ddev, int type, int param)
 static int digital_tg_listen_mdaa(struct nfc_digital_dev *ddev, u8 rf_tech)
 {
 	struct digital_tg_mdaa_params *params;
+	int rc;
 
 	params = kzalloc(sizeof(*params), GFP_KERNEL);
 	if (!params)
@@ -300,8 +301,12 @@ static int digital_tg_listen_mdaa(struct nfc_digital_dev *ddev, u8 rf_tech)
 	get_random_bytes(params->nfcid2 + 2, NFC_NFCID2_MAXSIZE - 2);
 	params->sc = DIGITAL_SENSF_FELICA_SC;
 
-	return digital_send_cmd(ddev, DIGITAL_CMD_TG_LISTEN_MDAA, NULL, params,
-				500, digital_tg_recv_atr_req, NULL);
+	rc = digital_send_cmd(ddev, DIGITAL_CMD_TG_LISTEN_MDAA, NULL, params,
+			      500, digital_tg_recv_atr_req, NULL);
+	if (rc)
+		kfree(params);
+
+	return rc;
 }
 
 static int digital_tg_listen_md(struct nfc_digital_dev *ddev, u8 rf_tech)
diff --git a/net/nfc/digital_technology.c b/net/nfc/digital_technology.c
index 2021d1d58a75..c092b02fde8a 100644
--- a/net/nfc/digital_technology.c
+++ b/net/nfc/digital_technology.c
@@ -474,8 +474,12 @@ static int digital_in_send_sdd_req(struct nfc_digital_dev *ddev,
 	skb_put_u8(skb, sel_cmd);
 	skb_put_u8(skb, DIGITAL_SDD_REQ_SEL_PAR);
 
-	return digital_in_send_cmd(ddev, skb, 30, digital_in_recv_sdd_res,
-				   target);
+	rc = digital_in_send_cmd(ddev, skb, 30, digital_in_recv_sdd_res,
+				 target);
+	if (rc)
+		kfree_skb(skb);
+
+	return rc;
 }
 
 static void digital_in_recv_sens_res(struct nfc_digital_dev *ddev, void *arg,
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 591d6a1d1b21..526520204921 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3623,7 +3623,7 @@ struct sctp_chunk *sctp_make_strreset_req(
 	outlen = (sizeof(outreq) + stream_len) * out;
 	inlen = (sizeof(inreq) + stream_len) * in;
 
-	retval = sctp_make_reconf(asoc, outlen + inlen);
+	retval = sctp_make_reconf(asoc, SCTP_PAD4(outlen) + SCTP_PAD4(inlen));
 	if (!retval)
 		return NULL;
 
diff --git a/sound/core/seq_device.c b/sound/core/seq_device.c
index e40a2cba5002..5d16b2079119 100644
--- a/sound/core/seq_device.c
+++ b/sound/core/seq_device.c
@@ -162,6 +162,8 @@ static int snd_seq_device_dev_free(struct snd_device *device)
 	struct snd_seq_device *dev = device->device_data;
 
 	cancel_autoload_drivers();
+	if (dev->private_free)
+		dev->private_free(dev);
 	put_device(&dev->dev);
 	return 0;
 }
@@ -189,11 +191,7 @@ static int snd_seq_device_dev_disconnect(struct snd_device *device)
 
 static void snd_seq_dev_release(struct device *dev)
 {
-	struct snd_seq_device *sdev = to_seq_dev(dev);
-
-	if (sdev->private_free)
-		sdev->private_free(sdev);
-	kfree(sdev);
+	kfree(to_seq_dev(dev));
 }
 
 /*
