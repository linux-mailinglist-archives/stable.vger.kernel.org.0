Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079F0434864
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 11:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhJTJ7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 05:59:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229910AbhJTJ67 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 05:58:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AA1F60FE8;
        Wed, 20 Oct 2021 09:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634723805;
        bh=8XdQZwV8y0ONu1LnrKfAwlCO1HtRvF/miN/RtCPa1gQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUV/v9oSiiOrTujwmQeqFyYTbviIoJaaB3NO9Pjb6ZhdkEhhaKA+l4sl+ihR9s+Bd
         y/VWIV8x9jiWWDq63wStgxQB/6GRL6qYHeJh5ja2RD7Z1m+bbji4e43/KEMWIHMt0x
         Q+LGtHx6YWMSvnu6Cxhq4oQDF+1aMgf7gzfCUCsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.213
Date:   Wed, 20 Oct 2021 11:56:35 +0200
Message-Id: <16347237944674@kroah.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <16347237946398@kroah.com>
References: <16347237946398@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 484b0665e572..ac86ad939880 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 212
+SUBLEVEL = 213
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/arch/s390/lib/string.c b/arch/s390/lib/string.c
index a10e11f7a5f7..c1832eba50ea 100644
--- a/arch/s390/lib/string.c
+++ b/arch/s390/lib/string.c
@@ -227,14 +227,13 @@ EXPORT_SYMBOL(strcmp);
  */
 char *strrchr(const char *s, int c)
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
index 3dd2949b2b35..6348b0964e9c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1496,7 +1496,6 @@ config AMD_MEM_ENCRYPT
 
 config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
 	bool "Activate AMD Secure Memory Encryption (SME) by default"
-	default y
 	depends on AMD_MEM_ENCRYPT
 	---help---
 	  Say yes to have system memory encrypted by default if running on
diff --git a/arch/x86/kernel/cpu/intel_rdt.c b/arch/x86/kernel/cpu/intel_rdt.c
index b32fa6bcf811..d4993d42b741 100644
--- a/arch/x86/kernel/cpu/intel_rdt.c
+++ b/arch/x86/kernel/cpu/intel_rdt.c
@@ -563,6 +563,8 @@ static void domain_add_cpu(int cpu, struct rdt_resource *r)
 	}
 
 	if (r->mon_capable && domain_setup_mon_state(r, d)) {
+		kfree(d->ctrl_val);
+		kfree(d->mbps_val);
 		kfree(d);
 		return;
 	}
diff --git a/drivers/acpi/arm64/gtdt.c b/drivers/acpi/arm64/gtdt.c
index c39b36c558d6..7a181a8a9bf0 100644
--- a/drivers/acpi/arm64/gtdt.c
+++ b/drivers/acpi/arm64/gtdt.c
@@ -39,7 +39,7 @@ struct acpi_gtdt_descriptor {
 
 static struct acpi_gtdt_descriptor acpi_gtdt_desc __initdata;
 
-static inline void *next_platform_timer(void *platform_timer)
+static inline __init void *next_platform_timer(void *platform_timer)
 {
 	struct acpi_gtdt_header *gh = platform_timer;
 
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 8ea4b8431fc8..52cea1b3ea70 100644
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
index 97da083afd32..aa4abf1a94a1 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -37,8 +37,6 @@
 #include <acpi/ghes.h>
 #include <ras/ras_event.h>
 
-static char rcd_decode_str[CPER_REC_LEN];
-
 /*
  * CPER record ID need to be unique even after reboot, because record
  * ID is used as index for ERST storage, while CPER records from
@@ -311,6 +309,7 @@ const char *cper_mem_err_unpack(struct trace_seq *p,
 				struct cper_mem_err_compact *cmem)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
+	char rcd_decode_str[CPER_REC_LEN];
 
 	if (cper_mem_err_location(cmem, rcd_decode_str))
 		trace_seq_printf(p, "%s", rcd_decode_str);
@@ -325,6 +324,7 @@ static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem,
 	int len)
 {
 	struct cper_mem_err_compact cmem;
+	char rcd_decode_str[CPER_REC_LEN];
 
 	/* Don't trust UEFI 2.1/2.2 structure with bad validation bits */
 	if (len == sizeof(struct cper_sec_mem_err_old) &&
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index b31e3d3729a6..0a4309fe01b6 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -395,7 +395,7 @@ static void virt_efi_reset_system(int reset_type,
 				  unsigned long data_size,
 				  efi_char16_t *data)
 {
-	if (down_interruptible(&efi_runtime_lock)) {
+	if (down_trylock(&efi_runtime_lock)) {
 		pr_warn("failed to invoke the reset_system() runtime service:\n"
 			"could not get exclusive access to the firmware\n");
 		return;
diff --git a/drivers/gpu/drm/msm/dsi/dsi.c b/drivers/gpu/drm/msm/dsi/dsi.c
index 822cef472a7e..5cf6eac9c1d3 100644
--- a/drivers/gpu/drm/msm/dsi/dsi.c
+++ b/drivers/gpu/drm/msm/dsi/dsi.c
@@ -208,8 +208,10 @@ int msm_dsi_modeset_init(struct msm_dsi *msm_dsi, struct drm_device *dev,
 		goto fail;
 	}
 
-	if (!msm_dsi_manager_validate_current_config(msm_dsi->id))
+	if (!msm_dsi_manager_validate_current_config(msm_dsi->id)) {
+		ret = -EINVAL;
 		goto fail;
+	}
 
 	msm_dsi->encoder = encoder;
 
diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 3b78bca0bb4d..77dae147caf9 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -468,7 +468,7 @@ static int dsi_bus_clk_enable(struct msm_dsi_host *msm_host)
 
 	return 0;
 err:
-	for (; i > 0; i--)
+	while (--i >= 0)
 		clk_disable_unprepare(msm_host->bus_clks[i]);
 
 	return ret;
diff --git a/drivers/gpu/drm/msm/edp/edp_ctrl.c b/drivers/gpu/drm/msm/edp/edp_ctrl.c
index 7c72264101ff..2589b23c4131 100644
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
index 9515ca165dfd..a8e6046d3948 100644
--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -188,6 +188,7 @@ static int aspeed_adc_probe(struct platform_device *pdev)
 
 	data = iio_priv(indio_dev);
 	data->dev = &pdev->dev;
+	platform_set_drvdata(pdev, indio_dev);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	data->base = devm_ioremap_resource(&pdev->dev, res);
diff --git a/drivers/iio/adc/ti-adc128s052.c b/drivers/iio/adc/ti-adc128s052.c
index 7cf39b3e2416..9986fc81b737 100644
--- a/drivers/iio/adc/ti-adc128s052.c
+++ b/drivers/iio/adc/ti-adc128s052.c
@@ -168,7 +168,13 @@ static int adc128_probe(struct spi_device *spi)
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
index 2ab106bb3e03..3d11cfa03a31 100644
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
@@ -283,6 +283,8 @@ static int ssp_parse_dataframe(struct ssp_data *data, char *dataframe, int len)
 	for (idx = 0; idx < len;) {
 		switch (dataframe[idx++]) {
 		case SSP_MSG2AP_INST_BYPASS_DATA:
+			if (idx >= len)
+				return -EPROTO;
 			sd = dataframe[idx++];
 			if (sd < 0 || sd >= SSP_SENSOR_MAX) {
 				dev_err(SSP_DEV,
@@ -292,10 +294,13 @@ static int ssp_parse_dataframe(struct ssp_data *data, char *dataframe, int len)
 
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
@@ -303,6 +308,8 @@ static int ssp_parse_dataframe(struct ssp_data *data, char *dataframe, int len)
 			idx += ssp_offset_map[sd];
 			break;
 		case SSP_MSG2AP_INST_DEBUG_DATA:
+			if (idx >= len)
+				return -EPROTO;
 			sd = ssp_print_mcu_debug(dataframe, &idx, len);
 			if (sd) {
 				dev_err(SSP_DEV,
diff --git a/drivers/iio/dac/ti-dac5571.c b/drivers/iio/dac/ti-dac5571.c
index e39d1e901353..2ed927b582f4 100644
--- a/drivers/iio/dac/ti-dac5571.c
+++ b/drivers/iio/dac/ti-dac5571.c
@@ -355,6 +355,7 @@ static int dac5571_probe(struct i2c_client *client,
 		data->dac5571_pwrdwn = dac5571_pwrdwn_quad;
 		break;
 	default:
+		ret = -EINVAL;
 		goto err;
 	}
 
diff --git a/drivers/iio/light/opt3001.c b/drivers/iio/light/opt3001.c
index f9d13e4ec108..162eff78c673 100644
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
index eacb8af8b4fc..4423db71eda7 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -345,6 +345,7 @@ static const struct xpad_device {
 	{ 0x24c6, 0x5b03, "Thrustmaster Ferrari 458 Racing Wheel", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0x5d04, "Razer Sabertooth", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0xfafe, "Rock Candy Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
+	{ 0x3285, 0x0607, "Nacon GC-100", 0, XTYPE_XBOX360 },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },
 	{ 0x0000, 0x0000, "Generic X-Box pad", 0, XTYPE_UNKNOWN }
@@ -461,6 +462,7 @@ static const struct usb_device_id xpad_table[] = {
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
 
diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 2ac1dc5104b7..6bbc78698b77 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -150,6 +150,7 @@
 #define MEI_DEV_ID_CDF        0x18D3  /* Cedar Fork */
 
 #define MEI_DEV_ID_ICP_LP     0x34E0  /* Ice Lake Point LP */
+#define MEI_DEV_ID_ICP_N      0x38E0  /* Ice Lake Point N */
 
 #define MEI_DEV_ID_TGP_LP     0xA0E0  /* Tiger Lake Point LP */
 
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index b4bf12f27caf..35086f67d209 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -112,6 +112,7 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_H_3, MEI_ME_PCH8_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ICP_LP, MEI_ME_PCH12_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ICP_N, MEI_ME_PCH12_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_TGP_LP, MEI_ME_PCH12_CFG)},
 
diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index 6fde68aa13a4..02644283377a 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -98,6 +98,7 @@ config JME
 config KORINA
 	tristate "Korina (IDT RC32434) Ethernet support"
 	depends on MIKROTIK_RB532
+	select CRC32
 	---help---
 	  If you have a Mikrotik RouterBoard 500 or IDT RC32434
 	  based system say Y. Otherwise say N.
diff --git a/drivers/net/ethernet/arc/Kconfig b/drivers/net/ethernet/arc/Kconfig
index 5d0ab8e74b68..55622d41f1ba 100644
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
index b8983e73265a..85a54215616c 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -8569,7 +8569,7 @@ static void s2io_io_resume(struct pci_dev *pdev)
 			return;
 		}
 
-		if (s2io_set_mac_addr(netdev, netdev->dev_addr) == FAILURE) {
+		if (do_s2io_prog_unicast(netdev, netdev->dev_addr) == FAILURE) {
 			s2io_card_down(sp);
 			pr_err("Can't restore mac addr after reset.\n");
 			return;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 9d77f318d11e..43c85e584b6f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1067,6 +1067,7 @@ static int qed_slowpath_start(struct qed_dev *cdev,
 			} else {
 				DP_NOTICE(cdev,
 					  "Failed to acquire PTT for aRFS\n");
+				rc = -EINVAL;
 				goto err;
 			}
 		}
diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 418b0904cecb..cc2fd1957765 100644
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
index 30c040786fde..2e77d49c2657 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -1061,7 +1061,8 @@ static void nvmem_shift_read_buffer_in_place(struct nvmem_cell *cell, void *buf)
 		*p-- = 0;
 
 	/* clear msb bits if any leftover in the last byte */
-	*p &= GENMASK((cell->nbits%BITS_PER_BYTE) - 1, 0);
+	if (cell->nbits % BITS_PER_BYTE)
+		*p &= GENMASK((cell->nbits % BITS_PER_BYTE) - 1, 0);
 }
 
 static int __nvmem_cell_read(struct nvmem_device *nvmem,
diff --git a/drivers/platform/mellanox/mlxreg-io.c b/drivers/platform/mellanox/mlxreg-io.c
index acfaf64ffde6..1c3760c13f83 100644
--- a/drivers/platform/mellanox/mlxreg-io.c
+++ b/drivers/platform/mellanox/mlxreg-io.c
@@ -123,7 +123,7 @@ mlxreg_io_attr_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	/* Convert buffer to input value. */
-	ret = kstrtou32(buf, len, &input_val);
+	ret = kstrtou32(buf, 0, &input_val);
 	if (ret)
 		return ret;
 
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 19485c076ba3..d707993ac921 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -28,6 +28,7 @@
 #define PCI_VENDOR_ID_FRESCO_LOGIC	0x1b73
 #define PCI_DEVICE_ID_FRESCO_LOGIC_PDK	0x1000
 #define PCI_DEVICE_ID_FRESCO_LOGIC_FL1009	0x1009
+#define PCI_DEVICE_ID_FRESCO_LOGIC_FL1100	0x1100
 #define PCI_DEVICE_ID_FRESCO_LOGIC_FL1400	0x1400
 
 #define PCI_VENDOR_ID_ETRON		0x1b6f
@@ -89,6 +90,7 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	/* Look for vendor-specific quirks */
 	if (pdev->vendor == PCI_VENDOR_ID_FRESCO_LOGIC &&
 			(pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK ||
+			 pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1100 ||
 			 pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1400)) {
 		if (pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK &&
 				pdev->revision == 0x0) {
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 7c981ad34251..04c04328d075 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -339,16 +339,22 @@ static void xhci_handle_stopped_cmd_ring(struct xhci_hcd *xhci,
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
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index bebab0ec2978..c6eec712cc47 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3093,10 +3093,13 @@ static void xhci_endpoint_reset(struct usb_hcd *hcd,
 	ep = &vdev->eps[ep_index];
 
 	/* Bail out if toggle is already being cleared by a endpoint reset */
+	spin_lock_irqsave(&xhci->lock, flags);
 	if (ep->ep_state & EP_HARD_CLEAR_TOGGLE) {
 		ep->ep_state &= ~EP_HARD_CLEAR_TOGGLE;
+		spin_unlock_irqrestore(&xhci->lock, flags);
 		return;
 	}
+	spin_unlock_irqrestore(&xhci->lock, flags);
 	/* Only interrupt and bulk ep's use data toggle, USB2 spec 5.5.4-> */
 	if (usb_endpoint_xfer_control(&host_ep->desc) ||
 	    usb_endpoint_xfer_isoc(&host_ep->desc))
@@ -3182,8 +3185,10 @@ static void xhci_endpoint_reset(struct usb_hcd *hcd,
 	xhci_free_command(xhci, cfg_cmd);
 cleanup:
 	xhci_free_command(xhci, stop_cmd);
+	spin_lock_irqsave(&xhci->lock, flags);
 	if (ep->ep_state & EP_SOFT_CLEAR_TOGGLE)
 		ep->ep_state &= ~EP_SOFT_CLEAR_TOGGLE;
+	spin_unlock_irqrestore(&xhci->lock, flags);
 }
 
 static int xhci_check_streams_endpoint(struct xhci_hcd *xhci,
diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 2f6708b8b5c2..892d74507890 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -901,11 +901,13 @@ static int dsps_probe(struct platform_device *pdev)
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
index 524b3c6e96e2..eaf118ee2a86 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -246,11 +246,13 @@ static void option_instat_callback(struct urb *urb);
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
@@ -1111,6 +1113,9 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC25, 0xff, 0xff, 0xff),
 	  .driver_info = NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC25, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG91, 0xff, 0xff, 0xff),
+	  .driver_info = NUMEP2 },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG91, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG95, 0xff, 0xff, 0xff),
 	  .driver_info = NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG95, 0xff, 0, 0) },
@@ -1128,6 +1133,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0xff, 0x10),
 	  .driver_info = ZLP },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200S_CN, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200T, 0xff, 0, 0) },
 
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6001) },
@@ -1227,6 +1233,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1203, 0xff),	/* Telit LE910Cx (RNDIS) */
 	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1204, 0xff),	/* Telit LE910Cx (MBIM) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE910_USBCFG4),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE920),
diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 0f60363c1bbc..b1b9923162a0 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -165,6 +165,7 @@ static const struct usb_device_id id_table[] = {
 	{DEVICE_SWI(0x1199, 0x907b)},	/* Sierra Wireless EM74xx */
 	{DEVICE_SWI(0x1199, 0x9090)},	/* Sierra Wireless EM7565 QDL */
 	{DEVICE_SWI(0x1199, 0x9091)},	/* Sierra Wireless EM7565 */
+	{DEVICE_SWI(0x1199, 0x90d2)},	/* Sierra Wireless EM9191 QDL */
 	{DEVICE_SWI(0x413c, 0x81a2)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card */
 	{DEVICE_SWI(0x413c, 0x81a3)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card */
 	{DEVICE_SWI(0x413c, 0x81a4)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card */
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 59e36ef4920f..74f43ef2fb0f 100644
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
index 3a7b7e9cb889..e0fc8c094846 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1141,7 +1141,10 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
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
@@ -1151,7 +1154,9 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
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
@@ -1866,8 +1871,8 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 	struct btrfs_key log_key;
 	struct inode *dir;
 	u8 log_type;
-	int exists;
-	int ret = 0;
+	bool exists;
+	int ret;
 	bool update_size = (key->type == BTRFS_DIR_INDEX_KEY);
 	bool name_added = false;
 
@@ -1887,12 +1892,12 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
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
@@ -1907,7 +1912,14 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
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
index ec0a8998e52d..d6258638a07a 100644
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
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 008db8d59ace..fcfe41a95473 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -531,22 +531,28 @@ static int mqprio_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 		for (i = tc.offset; i < tc.offset + tc.count; i++) {
 			struct netdev_queue *q = netdev_get_tx_queue(dev, i);
 			struct Qdisc *qdisc = rtnl_dereference(q->qdisc);
-			struct gnet_stats_basic_cpu __percpu *cpu_bstats = NULL;
-			struct gnet_stats_queue __percpu *cpu_qstats = NULL;
 
 			spin_lock_bh(qdisc_lock(qdisc));
+
 			if (qdisc_is_percpu_stats(qdisc)) {
-				cpu_bstats = qdisc->cpu_bstats;
-				cpu_qstats = qdisc->cpu_qstats;
+				qlen = qdisc_qlen_sum(qdisc);
+
+				__gnet_stats_copy_basic(NULL, &bstats,
+							qdisc->cpu_bstats,
+							&qdisc->bstats);
+				__gnet_stats_copy_queue(&qstats,
+							qdisc->cpu_qstats,
+							&qdisc->qstats,
+							qlen);
+			} else {
+				qlen		+= qdisc->q.qlen;
+				bstats.bytes	+= qdisc->bstats.bytes;
+				bstats.packets	+= qdisc->bstats.packets;
+				qstats.backlog	+= qdisc->qstats.backlog;
+				qstats.drops	+= qdisc->qstats.drops;
+				qstats.requeues	+= qdisc->qstats.requeues;
+				qstats.overlimits += qdisc->qstats.overlimits;
 			}
-
-			qlen = qdisc_qlen_sum(qdisc);
-			__gnet_stats_copy_basic(NULL, &sch->bstats,
-						cpu_bstats, &qdisc->bstats);
-			__gnet_stats_copy_queue(&sch->qstats,
-						cpu_qstats,
-						&qdisc->qstats,
-						qlen);
 			spin_unlock_bh(qdisc_lock(qdisc));
 		}
 
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 0789109c2d09..35e1fb708f4a 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3673,7 +3673,7 @@ struct sctp_chunk *sctp_make_strreset_req(
 	outlen = (sizeof(outreq) + stream_len) * out;
 	inlen = (sizeof(inreq) + stream_len) * in;
 
-	retval = sctp_make_reconf(asoc, outlen + inlen);
+	retval = sctp_make_reconf(asoc, SCTP_PAD4(outlen) + SCTP_PAD4(inlen));
 	if (!retval)
 		return NULL;
 
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 657e69125a46..321c41562b97 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -222,7 +222,7 @@ if ($arch =~ /(x86(_64)?)|(i386)/) {
 $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
 $weak_regex = "^[0-9a-fA-F]+\\s+([wW])\\s+(\\S+)";
 $section_regex = "Disassembly of section\\s+(\\S+):";
-$function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
+$function_regex = "^([0-9a-fA-F]+)\\s+<([^^]*?)>:";
 $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s(mcount|__fentry__)\$";
 $section_type = '@progbits';
 $mcount_adjust = 0;
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
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 42c30fba699f..650439286208 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -519,6 +519,8 @@ static void alc_shutup_pins(struct hda_codec *codec)
 	struct alc_spec *spec = codec->spec;
 
 	switch (codec->core.vendor_id) {
+	case 0x10ec0236:
+	case 0x10ec0256:
 	case 0x10ec0283:
 	case 0x10ec0286:
 	case 0x10ec0288:
@@ -2523,7 +2525,8 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x67e1, "Clevo PB71[DE][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e5, "Clevo PC70D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x70d1, "Clevo PC70[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
-	SND_PCI_QUIRK(0x1558, 0x7714, "Clevo X170", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x7714, "Clevo X170SM", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x7715, "Clevo X170KM-G", ALC1220_FIXUP_CLEVO_PB51ED),
 	SND_PCI_QUIRK(0x1558, 0x9501, "Clevo P950HR", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1558, 0x9506, "Clevo P955HQ", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1558, 0x950a, "Clevo P955H[PR]", ALC1220_FIXUP_CLEVO_P950),
@@ -3364,7 +3367,8 @@ static void alc256_shutup(struct hda_codec *codec)
 	/* If disable 3k pulldown control for alc257, the Mic detection will not work correctly
 	 * when booting with headset plugged. So skip setting it for the codec alc257
 	 */
-	if (codec->core.vendor_id != 0x10ec0257)
+	if (spec->codec_variant != ALC269_TYPE_ALC257 &&
+	    spec->codec_variant != ALC269_TYPE_ALC256)
 		alc_update_coef_idx(codec, 0x46, 0, 3 << 12);
 
 	if (!spec->no_shutup_pins)
