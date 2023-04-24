Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585AB6E10E1
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 17:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbjDMPUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 11:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbjDMPTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 11:19:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6654FAD30;
        Thu, 13 Apr 2023 08:19:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40C2C63F8B;
        Thu, 13 Apr 2023 15:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F54C433EF;
        Thu, 13 Apr 2023 15:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681399180;
        bh=y4gH/P2KYFlTPx1Fje/z6obRShhO+VXeiRgoRfbbCMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUd0mGpGoQfyCG2FgvG9jpqqXnddCWGxfLbMJFvK2OlzPWyFHkoSfMJ3sintVwHJN
         7Y0BXCC7h6lVV/x/PQMxP2GVvhCReS4uPCtIEX4H1ryJ/NnkExBvbky0/gs3xaj1G6
         vKh0+yTj4+L06FkqOEDUDvicptR+uViqXLlvnaus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.107
Date:   Thu, 13 Apr 2023 17:19:32 +0200
Message-Id: <2023041331-machine-unnerve-4201@gregkh>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <2023041331-roster-frozen-03e4@gregkh>
References: <2023041331-roster-frozen-03e4@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/devicetree/bindings/serial/renesas,scif.yaml b/Documentation/devicetree/bindings/serial/renesas,scif.yaml
index 6b8731f7f2fb..1a8d9bf89feb 100644
--- a/Documentation/devicetree/bindings/serial/renesas,scif.yaml
+++ b/Documentation/devicetree/bindings/serial/renesas,scif.yaml
@@ -79,7 +79,7 @@ properties:
           - description: Error interrupt
           - description: Receive buffer full interrupt
           - description: Transmit buffer empty interrupt
-          - description: Transmit End interrupt
+          - description: Break interrupt
       - items:
           - description: Error interrupt
           - description: Receive buffer full interrupt
@@ -94,7 +94,7 @@ properties:
           - const: eri
           - const: rxi
           - const: txi
-          - const: tei
+          - const: bri
       - items:
           - const: eri
           - const: rxi
diff --git a/Makefile b/Makefile
index 6459e91369fd..b06324521d28 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 106
+SUBLEVEL = 107
 EXTRAVERSION =
 NAME = Trick or Treat
 
@@ -1850,6 +1850,8 @@ modules modules_install:
 	@echo >&2 '***'
 	@exit 1
 
+KBUILD_MODULES :=
+
 endif # CONFIG_MODULES
 
 # Single targets
@@ -1875,18 +1877,12 @@ $(single-ko): single_modpost
 $(single-no-ko): descend
 	@:
 
-ifeq ($(KBUILD_EXTMOD),)
-# For the single build of in-tree modules, use a temporary file to avoid
-# the situation of modules_install installing an invalid modules.order.
-MODORDER := .modules.tmp
-endif
-
+# Remove MODORDER when done because it is not the real one.
 PHONY += single_modpost
 single_modpost: $(single-no-ko) modules_prepare
 	$(Q){ $(foreach m, $(single-ko), echo $(extmod_prefix)$m;) } > $(MODORDER)
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
-
-KBUILD_MODULES := 1
+	$(Q)rm -f $(MODORDER)
 
 export KBUILD_SINGLE_TARGETS := $(addprefix $(extmod_prefix), $(single-no-ko))
 
@@ -1894,10 +1890,8 @@ export KBUILD_SINGLE_TARGETS := $(addprefix $(extmod_prefix), $(single-no-ko))
 build-dirs := $(foreach d, $(build-dirs), \
 			$(if $(filter $(d)/%, $(KBUILD_SINGLE_TARGETS)), $(d)))
 
-endif
+KBUILD_MODULES := 1
 
-ifndef CONFIG_MODULES
-KBUILD_MODULES :=
 endif
 
 # Handle descending into subdirectories listed in $(build-dirs)
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 8ca301f49b30..aeb0e0865e89 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -271,10 +271,18 @@ static int handle_prog(struct kvm_vcpu *vcpu)
  * handle_external_interrupt - used for external interruption interceptions
  * @vcpu: virtual cpu
  *
- * This interception only occurs if the CPUSTAT_EXT_INT bit was set, or if
- * the new PSW does not have external interrupts disabled. In the first case,
- * we've got to deliver the interrupt manually, and in the second case, we
- * drop to userspace to handle the situation there.
+ * This interception occurs if:
+ * - the CPUSTAT_EXT_INT bit was already set when the external interrupt
+ *   occurred. In this case, the interrupt needs to be injected manually to
+ *   preserve interrupt priority.
+ * - the external new PSW has external interrupts enabled, which will cause an
+ *   interruption loop. We drop to userspace in this case.
+ *
+ * The latter case can be detected by inspecting the external mask bit in the
+ * external new psw.
+ *
+ * Under PV, only the latter case can occur, since interrupt priorities are
+ * handled in the ultravisor.
  */
 static int handle_external_interrupt(struct kvm_vcpu *vcpu)
 {
@@ -285,10 +293,18 @@ static int handle_external_interrupt(struct kvm_vcpu *vcpu)
 
 	vcpu->stat.exit_external_interrupt++;
 
-	rc = read_guest_lc(vcpu, __LC_EXT_NEW_PSW, &newpsw, sizeof(psw_t));
-	if (rc)
-		return rc;
-	/* We can not handle clock comparator or timer interrupt with bad PSW */
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
+		newpsw = vcpu->arch.sie_block->gpsw;
+	} else {
+		rc = read_guest_lc(vcpu, __LC_EXT_NEW_PSW, &newpsw, sizeof(psw_t));
+		if (rc)
+			return rc;
+	}
+
+	/*
+	 * Clock comparator or timer interrupt with external interrupt enabled
+	 * will cause interrupt loop. Drop to userspace.
+	 */
 	if ((eic == EXT_IRQ_CLK_COMP || eic == EXT_IRQ_CPU_TIMER) &&
 	    (newpsw.mask & PSW_MASK_EXT))
 		return -EOPNOTSUPP;
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 947474f6abb4..7b9def6b1004 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -100,7 +100,7 @@ config GPIO_GENERIC
 	tristate
 
 config GPIO_REGMAP
-	depends on REGMAP
+	select REGMAP
 	tristate
 
 # put drivers in the right section, in alphabetical order
diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index cb5afaa7ed48..0214244e9f01 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -326,7 +326,7 @@ static struct irq_chip gpio_irqchip = {
 	.irq_enable	= gpio_irq_enable,
 	.irq_disable	= gpio_irq_disable,
 	.irq_set_type	= gpio_irq_type,
-	.flags		= IRQCHIP_SET_TYPE_MASKED,
+	.flags		= IRQCHIP_SET_TYPE_MASKED | IRQCHIP_SKIP_SET_WAKE,
 };
 
 static void gpio_irq_handler(struct irq_desc *desc)
diff --git a/drivers/gpu/drm/bridge/lontium-lt9611.c b/drivers/gpu/drm/bridge/lontium-lt9611.c
index 0c6dea9ccb72..660e05fa4a70 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611.c
@@ -256,6 +256,7 @@ static int lt9611_pll_setup(struct lt9611 *lt9611, const struct drm_display_mode
 		{ 0x8126, 0x55 },
 		{ 0x8127, 0x66 },
 		{ 0x8128, 0x88 },
+		{ 0x812a, 0x20 },
 	};
 
 	regmap_multi_reg_write(lt9611->regmap, reg_cfg, ARRAY_SIZE(reg_cfg));
diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index 0722b907bfcf..73e24e0c9897 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -411,6 +411,35 @@ nv50_outp_atomic_check_view(struct drm_encoder *encoder,
 	return 0;
 }
 
+static void
+nv50_outp_atomic_fix_depth(struct drm_encoder *encoder, struct drm_crtc_state *crtc_state)
+{
+	struct nv50_head_atom *asyh = nv50_head_atom(crtc_state);
+	struct nouveau_encoder *nv_encoder = nouveau_encoder(encoder);
+	struct drm_display_mode *mode = &asyh->state.adjusted_mode;
+	unsigned int max_rate, mode_rate;
+
+	switch (nv_encoder->dcb->type) {
+	case DCB_OUTPUT_DP:
+		max_rate = nv_encoder->dp.link_nr * nv_encoder->dp.link_bw;
+
+		/* we don't support more than 10 anyway */
+		asyh->or.bpc = min_t(u8, asyh->or.bpc, 10);
+
+		/* reduce the bpc until it works out */
+		while (asyh->or.bpc > 6) {
+			mode_rate = DIV_ROUND_UP(mode->clock * asyh->or.bpc * 3, 8);
+			if (mode_rate <= max_rate)
+				break;
+
+			asyh->or.bpc -= 2;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
 static int
 nv50_outp_atomic_check(struct drm_encoder *encoder,
 		       struct drm_crtc_state *crtc_state,
@@ -429,6 +458,9 @@ nv50_outp_atomic_check(struct drm_encoder *encoder,
 	if (crtc_state->mode_changed || crtc_state->connectors_changed)
 		asyh->or.bpc = connector->display_info.bpc;
 
+	/* We might have to reduce the bpc */
+	nv50_outp_atomic_fix_depth(encoder, crtc_state);
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_dp.c b/drivers/gpu/drm/nouveau/nouveau_dp.c
index 040ed88d362d..447b7594b35a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
@@ -220,8 +220,6 @@ void nouveau_dp_irq(struct nouveau_drm *drm,
 }
 
 /* TODO:
- * - Use the minimum possible BPC here, once we add support for the max bpc
- *   property.
  * - Validate against the DP caps advertised by the GPU (we don't check these
  *   yet)
  */
@@ -233,7 +231,11 @@ nv50_dp_mode_valid(struct drm_connector *connector,
 {
 	const unsigned int min_clock = 25000;
 	unsigned int max_rate, mode_rate, ds_max_dotclock, clock = mode->clock;
-	const u8 bpp = connector->display_info.bpc * 3;
+	/* Check with the minmum bpc always, so we can advertise better modes.
+	 * In particlar not doing this causes modes to be dropped on HDR
+	 * displays as we might check with a bpc of 16 even.
+	 */
+	const u8 bpp = 6 * 3;
 
 	if (mode->flags & DRM_MODE_FLAG_INTERLACE && !outp->caps.dp_interlace)
 		return MODE_NO_INTERLACE;
diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
index d6dda97e2591..b5ee076c2841 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -469,6 +469,7 @@ static int panfrost_mmu_map_fault_addr(struct panfrost_device *pfdev, int as,
 		if (IS_ERR(pages[i])) {
 			mutex_unlock(&bo->base.pages_lock);
 			ret = PTR_ERR(pages[i]);
+			pages[i] = NULL;
 			goto err_pages;
 		}
 	}
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 5e479d54918c..47fb412eafd3 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -315,6 +315,10 @@ void vmbus_disconnect(void)
  */
 struct vmbus_channel *relid2channel(u32 relid)
 {
+	if (vmbus_connection.channels == NULL) {
+		pr_warn_once("relid2channel: relid=%d: No channels mapped!\n", relid);
+		return NULL;
+	}
 	if (WARN_ON(relid >= MAX_CHANNEL_RELIDS))
 		return NULL;
 	return READ_ONCE(vmbus_connection.channels[relid]);
diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index aa64efa0e05f..2b22343918d6 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -411,7 +411,7 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
 		if (etm4x_sspcicrn_present(drvdata, i))
 			etm4x_relaxed_write32(csa, config->ss_pe_cmp[i], TRCSSPCICRn(i));
 	}
-	for (i = 0; i < drvdata->nr_addr_cmp; i++) {
+	for (i = 0; i < drvdata->nr_addr_cmp * 2; i++) {
 		etm4x_relaxed_write64(csa, config->addr_val[i], TRCACVRn(i));
 		etm4x_relaxed_write64(csa, config->addr_acc[i], TRCACATRn(i));
 	}
@@ -951,25 +951,21 @@ static bool etm4_init_iomem_access(struct etmv4_drvdata *drvdata,
 				   struct csdev_access *csa)
 {
 	u32 devarch = readl_relaxed(drvdata->base + TRCDEVARCH);
-	u32 idr1 = readl_relaxed(drvdata->base + TRCIDR1);
 
 	/*
 	 * All ETMs must implement TRCDEVARCH to indicate that
-	 * the component is an ETMv4. To support any broken
-	 * implementations we fall back to TRCIDR1 check, which
-	 * is not really reliable.
+	 * the component is an ETMv4. Even though TRCIDR1 also
+	 * contains the information, it is part of the "Trace"
+	 * register and must be accessed with the OSLK cleared,
+	 * with MMIO. But we cannot touch the OSLK until we are
+	 * sure this is an ETM. So rely only on the TRCDEVARCH.
 	 */
-	if ((devarch & ETM_DEVARCH_ID_MASK) == ETM_DEVARCH_ETMv4x_ARCH) {
-		drvdata->arch = etm_devarch_to_arch(devarch);
-	} else {
-		pr_warn("CPU%d: ETM4x incompatible TRCDEVARCH: %x, falling back to TRCIDR1\n",
-			smp_processor_id(), devarch);
-
-		if (ETM_TRCIDR1_ARCH_MAJOR(idr1) != ETM_TRCIDR1_ARCH_ETMv4)
-			return false;
-		drvdata->arch = etm_trcidr_to_arch(idr1);
+	if ((devarch & ETM_DEVARCH_ID_MASK) != ETM_DEVARCH_ETMv4x_ARCH) {
+		pr_warn_once("TRCDEVARCH doesn't match ETMv4 architecture\n");
+		return false;
 	}
 
+	drvdata->arch = etm_devarch_to_arch(devarch);
 	*csa = CSDEV_ACCESS_IOMEM(drvdata->base);
 	return true;
 }
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index 794b29639035..2305f32fedf6 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -669,14 +669,12 @@
  * TRCDEVARCH	- CoreSight architected register
  *                - Bits[15:12] - Major version
  *                - Bits[19:16] - Minor version
- * TRCIDR1	- ETM architected register
- *                - Bits[11:8] - Major version
- *                - Bits[7:4]  - Minor version
- * We must rely on TRCDEVARCH for the version information,
- * however we don't want to break the support for potential
- * old implementations which might not implement it. Thus
- * we fall back to TRCIDR1 if TRCDEVARCH is not implemented
- * for memory mapped components.
+ *
+ * We must rely only on TRCDEVARCH for the version information. Even though,
+ * TRCIDR1 also provides the architecture version, it is a "Trace" register
+ * and as such must be accessed only with Trace power domain ON. This may
+ * not be available at probe time.
+ *
  * Now to make certain decisions easier based on the version
  * we use an internal representation of the version in the
  * driver, as follows :
@@ -702,12 +700,6 @@ static inline u8 etm_devarch_to_arch(u32 devarch)
 				ETM_DEVARCH_REVISION(devarch));
 }
 
-static inline u8 etm_trcidr_to_arch(u32 trcidr1)
-{
-	return ETM_ARCH_VERSION(ETM_TRCIDR1_ARCH_MAJOR(trcidr1),
-				ETM_TRCIDR1_ARCH_MINOR(trcidr1));
-}
-
 enum etm_impdef_type {
 	ETM4_IMPDEF_HISI_CORE_COMMIT,
 	ETM4_IMPDEF_FEATURE_MAX,
diff --git a/drivers/iio/adc/ad7791.c b/drivers/iio/adc/ad7791.c
index cb579aa89f39..f7d7bc1e4445 100644
--- a/drivers/iio/adc/ad7791.c
+++ b/drivers/iio/adc/ad7791.c
@@ -253,7 +253,7 @@ static const struct ad_sigma_delta_info ad7791_sigma_delta_info = {
 	.has_registers = true,
 	.addr_shift = 4,
 	.read_mask = BIT(3),
-	.irq_flags = IRQF_TRIGGER_LOW,
+	.irq_flags = IRQF_TRIGGER_FALLING,
 };
 
 static int ad7791_read_raw(struct iio_dev *indio_dev,
diff --git a/drivers/iio/adc/ti-ads7950.c b/drivers/iio/adc/ti-ads7950.c
index a2b83f0bd526..d4583b76f1fe 100644
--- a/drivers/iio/adc/ti-ads7950.c
+++ b/drivers/iio/adc/ti-ads7950.c
@@ -634,6 +634,7 @@ static int ti_ads7950_probe(struct spi_device *spi)
 	st->chip.label = dev_name(&st->spi->dev);
 	st->chip.parent = &st->spi->dev;
 	st->chip.owner = THIS_MODULE;
+	st->chip.can_sleep = true;
 	st->chip.base = -1;
 	st->chip.ngpio = TI_ADS7950_NUM_GPIOS;
 	st->chip.get_direction = ti_ads7950_get_direction;
diff --git a/drivers/iio/dac/cio-dac.c b/drivers/iio/dac/cio-dac.c
index 95813569f394..77a6916b3d6c 100644
--- a/drivers/iio/dac/cio-dac.c
+++ b/drivers/iio/dac/cio-dac.c
@@ -66,8 +66,8 @@ static int cio_dac_write_raw(struct iio_dev *indio_dev,
 	if (mask != IIO_CHAN_INFO_RAW)
 		return -EINVAL;
 
-	/* DAC can only accept up to a 16-bit value */
-	if ((unsigned int)val > 65535)
+	/* DAC can only accept up to a 12-bit value */
+	if ((unsigned int)val > 4095)
 		return -EINVAL;
 
 	priv->chan_out_states[chan->channel] = val;
diff --git a/drivers/iio/imu/Kconfig b/drivers/iio/imu/Kconfig
index 001ca2c3ff95..1f8ed7b1ae84 100644
--- a/drivers/iio/imu/Kconfig
+++ b/drivers/iio/imu/Kconfig
@@ -47,6 +47,7 @@ config ADIS16480
 	depends on SPI
 	select IIO_ADIS_LIB
 	select IIO_ADIS_LIB_BUFFER if IIO_BUFFER
+	select CRC32
 	help
 	  Say yes here to build support for Analog Devices ADIS16375, ADIS16480,
 	  ADIS16485, ADIS16488 inertial sensors.
diff --git a/drivers/iio/light/cm32181.c b/drivers/iio/light/cm32181.c
index 97649944f1df..c14a630dd683 100644
--- a/drivers/iio/light/cm32181.c
+++ b/drivers/iio/light/cm32181.c
@@ -429,6 +429,14 @@ static const struct iio_info cm32181_info = {
 	.attrs			= &cm32181_attribute_group,
 };
 
+static void cm32181_unregister_dummy_client(void *data)
+{
+	struct i2c_client *client = data;
+
+	/* Unregister the dummy client */
+	i2c_unregister_device(client);
+}
+
 static int cm32181_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
@@ -458,6 +466,10 @@ static int cm32181_probe(struct i2c_client *client)
 		client = i2c_acpi_new_device(dev, 1, &board_info);
 		if (IS_ERR(client))
 			return PTR_ERR(client);
+
+		ret = devm_add_action_or_reset(dev, cm32181_unregister_dummy_client, client);
+		if (ret)
+			return ret;
 	}
 
 	cm32181 = iio_priv(indio_dev);
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index c5971a840b87..27f22d595a5d 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2272,9 +2272,10 @@ static bool irdma_check_mr_contiguous(struct irdma_pble_alloc *palloc,
  * @rf: RDMA PCI function
  * @iwmr: mr pointer for this memory registration
  * @use_pbles: flag if to use pble's
+ * @lvl_1_only: request only level 1 pble if true
  */
 static int irdma_setup_pbles(struct irdma_pci_f *rf, struct irdma_mr *iwmr,
-			     bool use_pbles)
+			     bool use_pbles, bool lvl_1_only)
 {
 	struct irdma_pbl *iwpbl = &iwmr->iwpbl;
 	struct irdma_pble_alloc *palloc = &iwpbl->pble_alloc;
@@ -2285,7 +2286,7 @@ static int irdma_setup_pbles(struct irdma_pci_f *rf, struct irdma_mr *iwmr,
 
 	if (use_pbles) {
 		status = irdma_get_pble(rf->pble_rsrc, palloc, iwmr->page_cnt,
-					false);
+					lvl_1_only);
 		if (status)
 			return -ENOMEM;
 
@@ -2328,16 +2329,10 @@ static int irdma_handle_q_mem(struct irdma_device *iwdev,
 	bool ret = true;
 
 	pg_size = iwmr->page_size;
-	err = irdma_setup_pbles(iwdev->rf, iwmr, use_pbles);
+	err = irdma_setup_pbles(iwdev->rf, iwmr, use_pbles, true);
 	if (err)
 		return err;
 
-	if (use_pbles && palloc->level != PBLE_LEVEL_1) {
-		irdma_free_pble(iwdev->rf->pble_rsrc, palloc);
-		iwpbl->pbl_allocated = false;
-		return -ENOMEM;
-	}
-
 	if (use_pbles)
 		arr = palloc->level1.addr;
 
@@ -2808,7 +2803,7 @@ static struct ib_mr *irdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 len,
 	case IRDMA_MEMREG_TYPE_MEM:
 		use_pbles = (iwmr->page_cnt != 1);
 
-		err = irdma_setup_pbles(iwdev->rf, iwmr, use_pbles);
+		err = irdma_setup_pbles(iwdev->rf, iwmr, use_pbles, false);
 		if (err)
 			goto error;
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 8a030dc0b8a3..bc363fca2895 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4967,7 +4967,7 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	 * .port_set_upstream_port method.
 	 */
 	.set_egress_port = mv88e6393x_set_egress_port,
-	.watchdog_ops = &mv88e6390_watchdog_ops,
+	.watchdog_ops = &mv88e6393x_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6393x_port_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index fa65ecd9cb85..ec49939968fa 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -931,6 +931,26 @@ const struct mv88e6xxx_irq_ops mv88e6390_watchdog_ops = {
 	.irq_free = mv88e6390_watchdog_free,
 };
 
+static int mv88e6393x_watchdog_action(struct mv88e6xxx_chip *chip, int irq)
+{
+	mv88e6390_watchdog_action(chip, irq);
+
+	/* Fix for clearing the force WD event bit.
+	 * Unreleased erratum on mv88e6393x.
+	 */
+	mv88e6xxx_g2_write(chip, MV88E6390_G2_WDOG_CTL,
+			   MV88E6390_G2_WDOG_CTL_UPDATE |
+			   MV88E6390_G2_WDOG_CTL_PTR_EVENT);
+
+	return IRQ_HANDLED;
+}
+
+const struct mv88e6xxx_irq_ops mv88e6393x_watchdog_ops = {
+	.irq_action = mv88e6393x_watchdog_action,
+	.irq_setup = mv88e6390_watchdog_setup,
+	.irq_free = mv88e6390_watchdog_free,
+};
+
 static irqreturn_t mv88e6xxx_g2_watchdog_thread_fn(int irq, void *dev_id)
 {
 	struct mv88e6xxx_chip *chip = dev_id;
diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index f3e27573a386..89ba09b663a2 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -361,6 +361,7 @@ int mv88e6xxx_g2_device_mapping_write(struct mv88e6xxx_chip *chip, int target,
 extern const struct mv88e6xxx_irq_ops mv88e6097_watchdog_ops;
 extern const struct mv88e6xxx_irq_ops mv88e6250_watchdog_ops;
 extern const struct mv88e6xxx_irq_ops mv88e6390_watchdog_ops;
+extern const struct mv88e6xxx_irq_ops mv88e6393x_watchdog_ops;
 
 extern const struct mv88e6xxx_avb_ops mv88e6165_avb_ops;
 extern const struct mv88e6xxx_avb_ops mv88e6352_avb_ops;
diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index b1273dce4795..08f4c0595efa 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -47,6 +47,8 @@
 
 #define GVE_RX_BUFFER_SIZE_DQO 2048
 
+#define GVE_GQ_TX_MIN_PKT_DESC_BYTES 182
+
 /* Each slot in the desc ring has a 1:1 mapping to a slot in the data ring */
 struct gve_rx_desc_queue {
 	struct gve_rx_desc *desc_ring; /* the descriptor ring */
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 9922ce46a635..43e7b74bdb76 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -283,8 +283,8 @@ static inline int gve_skb_fifo_bytes_required(struct gve_tx_ring *tx,
 	int bytes;
 	int hlen;
 
-	hlen = skb_is_gso(skb) ? skb_checksum_start_offset(skb) +
-				 tcp_hdrlen(skb) : skb_headlen(skb);
+	hlen = skb_is_gso(skb) ? skb_checksum_start_offset(skb) + tcp_hdrlen(skb) :
+				 min_t(int, GVE_GQ_TX_MIN_PKT_DESC_BYTES, skb->len);
 
 	pad_bytes = gve_tx_fifo_pad_alloc_one_frag(&tx->tx_fifo,
 						   hlen);
@@ -431,13 +431,11 @@ static int gve_tx_add_skb_copy(struct gve_priv *priv, struct gve_tx_ring *tx, st
 	pkt_desc = &tx->desc[idx];
 
 	l4_hdr_offset = skb_checksum_start_offset(skb);
-	/* If the skb is gso, then we want the tcp header in the first segment
-	 * otherwise we want the linear portion of the skb (which will contain
-	 * the checksum because skb->csum_start and skb->csum_offset are given
-	 * relative to skb->head) in the first segment.
+	/* If the skb is gso, then we want the tcp header alone in the first segment
+	 * otherwise we want the minimum required by the gVNIC spec.
 	 */
 	hlen = is_gso ? l4_hdr_offset + tcp_hdrlen(skb) :
-			skb_headlen(skb);
+			min_t(int, GVE_GQ_TX_MIN_PKT_DESC_BYTES, skb->len);
 
 	info->skb =  skb;
 	/* We don't want to split the header, so if necessary, pad to the end
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index f5e6ae2c683f..3b62f37b3cf1 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3103,7 +3103,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad ether dest mask %pM\n",
 					match.mask->dst);
-				return IAVF_ERR_CONFIG;
+				return -EINVAL;
 			}
 		}
 
@@ -3113,7 +3113,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad ether src mask %pM\n",
 					match.mask->src);
-				return IAVF_ERR_CONFIG;
+				return -EINVAL;
 			}
 		}
 
@@ -3148,7 +3148,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad vlan mask %u\n",
 					match.mask->vlan_id);
-				return IAVF_ERR_CONFIG;
+				return -EINVAL;
 			}
 		}
 		vf->mask.tcp_spec.vlan_id |= cpu_to_be16(0xffff);
@@ -3172,7 +3172,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad ip dst mask 0x%08x\n",
 					be32_to_cpu(match.mask->dst));
-				return IAVF_ERR_CONFIG;
+				return -EINVAL;
 			}
 		}
 
@@ -3181,14 +3181,14 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 				field_flags |= IAVF_CLOUD_FIELD_IIP;
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad ip src mask 0x%08x\n",
-					be32_to_cpu(match.mask->dst));
-				return IAVF_ERR_CONFIG;
+					be32_to_cpu(match.mask->src));
+				return -EINVAL;
 			}
 		}
 
 		if (field_flags & IAVF_CLOUD_FIELD_TEN_ID) {
 			dev_info(&adapter->pdev->dev, "Tenant id not allowed for ip filter\n");
-			return IAVF_ERR_CONFIG;
+			return -EINVAL;
 		}
 		if (match.key->dst) {
 			vf->mask.tcp_spec.dst_ip[0] |= cpu_to_be32(0xffffffff);
@@ -3209,7 +3209,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 		if (ipv6_addr_any(&match.mask->dst)) {
 			dev_err(&adapter->pdev->dev, "Bad ipv6 dst mask 0x%02x\n",
 				IPV6_ADDR_ANY);
-			return IAVF_ERR_CONFIG;
+			return -EINVAL;
 		}
 
 		/* src and dest IPv6 address should not be LOOPBACK
@@ -3219,7 +3219,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 		    ipv6_addr_loopback(&match.key->src)) {
 			dev_err(&adapter->pdev->dev,
 				"ipv6 addr should not be loopback\n");
-			return IAVF_ERR_CONFIG;
+			return -EINVAL;
 		}
 		if (!ipv6_addr_any(&match.mask->dst) ||
 		    !ipv6_addr_any(&match.mask->src))
@@ -3244,7 +3244,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad src port mask %u\n",
 					be16_to_cpu(match.mask->src));
-				return IAVF_ERR_CONFIG;
+				return -EINVAL;
 			}
 		}
 
@@ -3254,7 +3254,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad dst port mask %u\n",
 					be16_to_cpu(match.mask->dst));
-				return IAVF_ERR_CONFIG;
+				return -EINVAL;
 			}
 		}
 		if (match.key->dst) {
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index 4b738f739109..412deb36b645 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -731,6 +731,21 @@ static void ice_vc_fdir_rem_prof_all(struct ice_vf *vf)
 	}
 }
 
+/**
+ * ice_vc_fdir_reset_cnt_all - reset all FDIR counters for this VF FDIR
+ * @fdir: pointer to the VF FDIR structure
+ */
+static void ice_vc_fdir_reset_cnt_all(struct ice_vf_fdir *fdir)
+{
+	enum ice_fltr_ptype flow;
+
+	for (flow = ICE_FLTR_PTYPE_NONF_NONE;
+	     flow < ICE_FLTR_PTYPE_MAX; flow++) {
+		fdir->fdir_fltr_cnt[flow][0] = 0;
+		fdir->fdir_fltr_cnt[flow][1] = 0;
+	}
+}
+
 /**
  * ice_vc_fdir_has_prof_conflict
  * @vf: pointer to the VF structure
@@ -2136,7 +2151,7 @@ int ice_vc_add_fdir_fltr(struct ice_vf *vf, u8 *msg)
 		v_ret = VIRTCHNL_STATUS_SUCCESS;
 		stat->status = VIRTCHNL_FDIR_FAILURE_RULE_NORESOURCE;
 		dev_dbg(dev, "VF %d: set FDIR context failed\n", vf->vf_id);
-		goto err_free_conf;
+		goto err_rem_entry;
 	}
 
 	ret = ice_vc_fdir_write_fltr(vf, conf, true, is_tun);
@@ -2145,15 +2160,16 @@ int ice_vc_add_fdir_fltr(struct ice_vf *vf, u8 *msg)
 		stat->status = VIRTCHNL_FDIR_FAILURE_RULE_NORESOURCE;
 		dev_err(dev, "VF %d: writing FDIR rule failed, ret:%d\n",
 			vf->vf_id, ret);
-		goto err_rem_entry;
+		goto err_clr_irq;
 	}
 
 exit:
 	kfree(stat);
 	return ret;
 
-err_rem_entry:
+err_clr_irq:
 	ice_vc_fdir_clear_irq_ctx(vf);
+err_rem_entry:
 	ice_vc_fdir_remove_entry(vf, conf, conf->flow_id);
 err_free_conf:
 	devm_kfree(dev, conf);
@@ -2262,6 +2278,7 @@ void ice_vf_fdir_init(struct ice_vf *vf)
 	spin_lock_init(&fdir->ctx_lock);
 	fdir->ctx_irq.flags = 0;
 	fdir->ctx_done.flags = 0;
+	ice_vc_fdir_reset_cnt_all(fdir);
 }
 
 /**
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 728e68971c39..a3bd5396c2f8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6893,7 +6893,7 @@ static void stmmac_napi_del(struct net_device *dev)
 int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
-	int ret = 0;
+	int ret = 0, i;
 
 	if (netif_running(dev))
 		stmmac_release(dev);
@@ -6902,6 +6902,10 @@ int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 
 	priv->plat->rx_queues_to_use = rx_cnt;
 	priv->plat->tx_queues_to_use = tx_cnt;
+	if (!netif_is_rxfh_configured(dev))
+		for (i = 0; i < ARRAY_SIZE(priv->rss.table); i++)
+			priv->rss.table[i] = ethtool_rxfh_indir_default(i,
+									rx_cnt);
 
 	stmmac_napi_add(dev);
 
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 37b9a798dd62..692c291d9a01 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2784,7 +2784,8 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	return 0;
 
 err_of_clear:
-	of_platform_device_destroy(common->mdio_dev, NULL);
+	if (common->mdio_dev)
+		of_platform_device_destroy(common->mdio_dev, NULL);
 err_pm_clear:
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
@@ -2813,7 +2814,8 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 	 */
 	am65_cpsw_nuss_cleanup_ndev(common);
 
-	of_platform_device_destroy(common->mdio_dev, NULL);
+	if (common->mdio_dev)
+		of_platform_device_destroy(common->mdio_dev, NULL);
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
diff --git a/drivers/platform/x86/intel/int3472/Makefile b/drivers/platform/x86/intel/int3472/Makefile
index 2362e04db18d..771e720528a0 100644
--- a/drivers/platform/x86/intel/int3472/Makefile
+++ b/drivers/platform/x86/intel/int3472/Makefile
@@ -1,5 +1,4 @@
-obj-$(CONFIG_INTEL_SKL_INT3472)		+= intel_skl_int3472.o
-intel_skl_int3472-y			:= intel_skl_int3472_common.o \
-					   intel_skl_int3472_discrete.o \
-					   intel_skl_int3472_tps68470.o \
-					   intel_skl_int3472_clk_and_regulator.o
+obj-$(CONFIG_INTEL_SKL_INT3472)		+= intel_skl_int3472_discrete.o \
+					   intel_skl_int3472_tps68470.o
+intel_skl_int3472_discrete-y		:= discrete.o clk_and_regulator.o common.o
+intel_skl_int3472_tps68470-y		:= tps68470.o common.o
diff --git a/drivers/platform/x86/intel/int3472/clk_and_regulator.c b/drivers/platform/x86/intel/int3472/clk_and_regulator.c
new file mode 100644
index 000000000000..28353addffa7
--- /dev/null
+++ b/drivers/platform/x86/intel/int3472/clk_and_regulator.c
@@ -0,0 +1,210 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Author: Dan Scally <djrscally@gmail.com> */
+
+#include <linux/acpi.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/device.h>
+#include <linux/gpio/consumer.h>
+#include <linux/regulator/driver.h>
+#include <linux/slab.h>
+
+#include "common.h"
+
+/*
+ * The regulators have to have .ops to be valid, but the only ops we actually
+ * support are .enable and .disable which are handled via .ena_gpiod. Pass an
+ * empty struct to clear the check without lying about capabilities.
+ */
+static const struct regulator_ops int3472_gpio_regulator_ops;
+
+static int skl_int3472_clk_prepare(struct clk_hw *hw)
+{
+	struct int3472_gpio_clock *clk = to_int3472_clk(hw);
+
+	gpiod_set_value_cansleep(clk->ena_gpio, 1);
+	gpiod_set_value_cansleep(clk->led_gpio, 1);
+
+	return 0;
+}
+
+static void skl_int3472_clk_unprepare(struct clk_hw *hw)
+{
+	struct int3472_gpio_clock *clk = to_int3472_clk(hw);
+
+	gpiod_set_value_cansleep(clk->ena_gpio, 0);
+	gpiod_set_value_cansleep(clk->led_gpio, 0);
+}
+
+static int skl_int3472_clk_enable(struct clk_hw *hw)
+{
+	/*
+	 * We're just turning a GPIO on to enable the clock, which operation
+	 * has the potential to sleep. Given .enable() cannot sleep, but
+	 * .prepare() can, we toggle the GPIO in .prepare() instead. Thus,
+	 * nothing to do here.
+	 */
+	return 0;
+}
+
+static void skl_int3472_clk_disable(struct clk_hw *hw)
+{
+	/* Likewise, nothing to do here... */
+}
+
+static unsigned int skl_int3472_get_clk_frequency(struct int3472_discrete_device *int3472)
+{
+	union acpi_object *obj;
+	unsigned int freq;
+
+	obj = skl_int3472_get_acpi_buffer(int3472->sensor, "SSDB");
+	if (IS_ERR(obj))
+		return 0; /* report rate as 0 on error */
+
+	if (obj->buffer.length < CIO2_SENSOR_SSDB_MCLKSPEED_OFFSET + sizeof(u32)) {
+		dev_err(int3472->dev, "The buffer is too small\n");
+		kfree(obj);
+		return 0;
+	}
+
+	freq = *(u32 *)(obj->buffer.pointer + CIO2_SENSOR_SSDB_MCLKSPEED_OFFSET);
+
+	kfree(obj);
+	return freq;
+}
+
+static unsigned long skl_int3472_clk_recalc_rate(struct clk_hw *hw,
+						 unsigned long parent_rate)
+{
+	struct int3472_gpio_clock *clk = to_int3472_clk(hw);
+
+	return clk->frequency;
+}
+
+static const struct clk_ops skl_int3472_clock_ops = {
+	.prepare = skl_int3472_clk_prepare,
+	.unprepare = skl_int3472_clk_unprepare,
+	.enable = skl_int3472_clk_enable,
+	.disable = skl_int3472_clk_disable,
+	.recalc_rate = skl_int3472_clk_recalc_rate,
+};
+
+int skl_int3472_register_clock(struct int3472_discrete_device *int3472)
+{
+	struct clk_init_data init = {
+		.ops = &skl_int3472_clock_ops,
+		.flags = CLK_GET_RATE_NOCACHE,
+	};
+	int ret;
+
+	init.name = kasprintf(GFP_KERNEL, "%s-clk",
+			      acpi_dev_name(int3472->adev));
+	if (!init.name)
+		return -ENOMEM;
+
+	int3472->clock.frequency = skl_int3472_get_clk_frequency(int3472);
+
+	int3472->clock.clk_hw.init = &init;
+	int3472->clock.clk = clk_register(&int3472->adev->dev,
+					  &int3472->clock.clk_hw);
+	if (IS_ERR(int3472->clock.clk)) {
+		ret = PTR_ERR(int3472->clock.clk);
+		goto out_free_init_name;
+	}
+
+	int3472->clock.cl = clkdev_create(int3472->clock.clk, NULL,
+					  int3472->sensor_name);
+	if (!int3472->clock.cl) {
+		ret = -ENOMEM;
+		goto err_unregister_clk;
+	}
+
+	kfree(init.name);
+	return 0;
+
+err_unregister_clk:
+	clk_unregister(int3472->clock.clk);
+out_free_init_name:
+	kfree(init.name);
+
+	return ret;
+}
+
+void skl_int3472_unregister_clock(struct int3472_discrete_device *int3472)
+{
+	clkdev_drop(int3472->clock.cl);
+	clk_unregister(int3472->clock.clk);
+}
+
+int skl_int3472_register_regulator(struct int3472_discrete_device *int3472,
+				   struct acpi_resource_gpio *agpio)
+{
+	const struct int3472_sensor_config *sensor_config;
+	char *path = agpio->resource_source.string_ptr;
+	struct regulator_consumer_supply supply_map;
+	struct regulator_init_data init_data = { };
+	struct regulator_config cfg = { };
+	int ret;
+
+	sensor_config = int3472->sensor_config;
+	if (IS_ERR(sensor_config)) {
+		dev_err(int3472->dev, "No sensor module config\n");
+		return PTR_ERR(sensor_config);
+	}
+
+	if (!sensor_config->supply_map.supply) {
+		dev_err(int3472->dev, "No supply name defined\n");
+		return -ENODEV;
+	}
+
+	init_data.constraints.valid_ops_mask = REGULATOR_CHANGE_STATUS;
+	init_data.num_consumer_supplies = 1;
+	supply_map = sensor_config->supply_map;
+	supply_map.dev_name = int3472->sensor_name;
+	init_data.consumer_supplies = &supply_map;
+
+	snprintf(int3472->regulator.regulator_name,
+		 sizeof(int3472->regulator.regulator_name), "%s-regulator",
+		 acpi_dev_name(int3472->adev));
+	snprintf(int3472->regulator.supply_name,
+		 GPIO_REGULATOR_SUPPLY_NAME_LENGTH, "supply-0");
+
+	int3472->regulator.rdesc = INT3472_REGULATOR(
+						int3472->regulator.regulator_name,
+						int3472->regulator.supply_name,
+						&int3472_gpio_regulator_ops);
+
+	int3472->regulator.gpio = acpi_get_and_request_gpiod(path, agpio->pin_table[0],
+							     "int3472,regulator");
+	if (IS_ERR(int3472->regulator.gpio)) {
+		dev_err(int3472->dev, "Failed to get regulator GPIO line\n");
+		return PTR_ERR(int3472->regulator.gpio);
+	}
+
+	/* Ensure the pin is in output mode and non-active state */
+	gpiod_direction_output(int3472->regulator.gpio, 0);
+
+	cfg.dev = &int3472->adev->dev;
+	cfg.init_data = &init_data;
+	cfg.ena_gpiod = int3472->regulator.gpio;
+
+	int3472->regulator.rdev = regulator_register(&int3472->regulator.rdesc,
+						     &cfg);
+	if (IS_ERR(int3472->regulator.rdev)) {
+		ret = PTR_ERR(int3472->regulator.rdev);
+		goto err_free_gpio;
+	}
+
+	return 0;
+
+err_free_gpio:
+	gpiod_put(int3472->regulator.gpio);
+
+	return ret;
+}
+
+void skl_int3472_unregister_regulator(struct int3472_discrete_device *int3472)
+{
+	regulator_unregister(int3472->regulator.rdev);
+	gpiod_put(int3472->regulator.gpio);
+}
diff --git a/drivers/platform/x86/intel/int3472/common.c b/drivers/platform/x86/intel/int3472/common.c
new file mode 100644
index 000000000000..350655a9515b
--- /dev/null
+++ b/drivers/platform/x86/intel/int3472/common.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Author: Dan Scally <djrscally@gmail.com> */
+
+#include <linux/acpi.h>
+#include <linux/slab.h>
+
+#include "common.h"
+
+union acpi_object *skl_int3472_get_acpi_buffer(struct acpi_device *adev, char *id)
+{
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	acpi_handle handle = adev->handle;
+	union acpi_object *obj;
+	acpi_status status;
+
+	status = acpi_evaluate_object(handle, id, NULL, &buffer);
+	if (ACPI_FAILURE(status))
+		return ERR_PTR(-ENODEV);
+
+	obj = buffer.pointer;
+	if (!obj)
+		return ERR_PTR(-ENODEV);
+
+	if (obj->type != ACPI_TYPE_BUFFER) {
+		acpi_handle_err(handle, "%s object is not an ACPI buffer\n", id);
+		kfree(obj);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return obj;
+}
+
+int skl_int3472_fill_cldb(struct acpi_device *adev, struct int3472_cldb *cldb)
+{
+	union acpi_object *obj;
+	int ret;
+
+	obj = skl_int3472_get_acpi_buffer(adev, "CLDB");
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
+
+	if (obj->buffer.length > sizeof(*cldb)) {
+		acpi_handle_err(adev->handle, "The CLDB buffer is too large\n");
+		ret = -EINVAL;
+		goto out_free_obj;
+	}
+
+	memcpy(cldb, obj->buffer.pointer, obj->buffer.length);
+	ret = 0;
+
+out_free_obj:
+	kfree(obj);
+	return ret;
+}
diff --git a/drivers/platform/x86/intel/int3472/common.h b/drivers/platform/x86/intel/int3472/common.h
new file mode 100644
index 000000000000..d14944ee8586
--- /dev/null
+++ b/drivers/platform/x86/intel/int3472/common.h
@@ -0,0 +1,119 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Author: Dan Scally <djrscally@gmail.com> */
+
+#ifndef _INTEL_SKL_INT3472_H
+#define _INTEL_SKL_INT3472_H
+
+#include <linux/clk-provider.h>
+#include <linux/gpio/machine.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/types.h>
+
+/* FIXME drop this once the I2C_DEV_NAME_FORMAT macro has been added to include/linux/i2c.h */
+#ifndef I2C_DEV_NAME_FORMAT
+#define I2C_DEV_NAME_FORMAT					"i2c-%s"
+#endif
+
+/* PMIC GPIO Types */
+#define INT3472_GPIO_TYPE_RESET					0x00
+#define INT3472_GPIO_TYPE_POWERDOWN				0x01
+#define INT3472_GPIO_TYPE_POWER_ENABLE				0x0b
+#define INT3472_GPIO_TYPE_CLK_ENABLE				0x0c
+#define INT3472_GPIO_TYPE_PRIVACY_LED				0x0d
+
+#define INT3472_PDEV_MAX_NAME_LEN				23
+#define INT3472_MAX_SENSOR_GPIOS				3
+
+#define GPIO_REGULATOR_NAME_LENGTH				21
+#define GPIO_REGULATOR_SUPPLY_NAME_LENGTH			9
+
+#define CIO2_SENSOR_SSDB_MCLKSPEED_OFFSET			86
+
+#define INT3472_REGULATOR(_name, _supply, _ops)			\
+	(const struct regulator_desc) {				\
+		.name = _name,					\
+		.supply_name = _supply,				\
+		.type = REGULATOR_VOLTAGE,			\
+		.ops = _ops,					\
+		.owner = THIS_MODULE,				\
+	}
+
+#define to_int3472_clk(hw)					\
+	container_of(hw, struct int3472_gpio_clock, clk_hw)
+
+#define to_int3472_device(clk)					\
+	container_of(clk, struct int3472_discrete_device, clock)
+
+struct acpi_device;
+struct i2c_client;
+struct platform_device;
+
+struct int3472_cldb {
+	u8 version;
+	/*
+	 * control logic type
+	 * 0: UNKNOWN
+	 * 1: DISCRETE(CRD-D)
+	 * 2: PMIC TPS68470
+	 * 3: PMIC uP6641
+	 */
+	u8 control_logic_type;
+	u8 control_logic_id;
+	u8 sensor_card_sku;
+	u8 reserved[28];
+};
+
+struct int3472_gpio_function_remap {
+	const char *documented;
+	const char *actual;
+};
+
+struct int3472_sensor_config {
+	const char *sensor_module_name;
+	struct regulator_consumer_supply supply_map;
+	const struct int3472_gpio_function_remap *function_maps;
+};
+
+struct int3472_discrete_device {
+	struct acpi_device *adev;
+	struct device *dev;
+	struct acpi_device *sensor;
+	const char *sensor_name;
+
+	const struct int3472_sensor_config *sensor_config;
+
+	struct int3472_gpio_regulator {
+		char regulator_name[GPIO_REGULATOR_NAME_LENGTH];
+		char supply_name[GPIO_REGULATOR_SUPPLY_NAME_LENGTH];
+		struct gpio_desc *gpio;
+		struct regulator_dev *rdev;
+		struct regulator_desc rdesc;
+	} regulator;
+
+	struct int3472_gpio_clock {
+		struct clk *clk;
+		struct clk_hw clk_hw;
+		struct clk_lookup *cl;
+		struct gpio_desc *ena_gpio;
+		struct gpio_desc *led_gpio;
+		u32 frequency;
+	} clock;
+
+	unsigned int ngpios; /* how many GPIOs have we seen */
+	unsigned int n_sensor_gpios; /* how many have we mapped to sensor */
+	struct gpiod_lookup_table gpios;
+};
+
+union acpi_object *skl_int3472_get_acpi_buffer(struct acpi_device *adev,
+					       char *id);
+int skl_int3472_fill_cldb(struct acpi_device *adev, struct int3472_cldb *cldb);
+
+int skl_int3472_register_clock(struct int3472_discrete_device *int3472);
+void skl_int3472_unregister_clock(struct int3472_discrete_device *int3472);
+
+int skl_int3472_register_regulator(struct int3472_discrete_device *int3472,
+				   struct acpi_resource_gpio *agpio);
+void skl_int3472_unregister_regulator(struct int3472_discrete_device *int3472);
+
+#endif
diff --git a/drivers/platform/x86/intel/int3472/discrete.c b/drivers/platform/x86/intel/int3472/discrete.c
new file mode 100644
index 000000000000..401fa8f223d6
--- /dev/null
+++ b/drivers/platform/x86/intel/int3472/discrete.c
@@ -0,0 +1,439 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Author: Dan Scally <djrscally@gmail.com> */
+
+#include <linux/acpi.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/device.h>
+#include <linux/gpio/consumer.h>
+#include <linux/gpio/machine.h>
+#include <linux/i2c.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/overflow.h>
+#include <linux/platform_device.h>
+#include <linux/uuid.h>
+
+#include "common.h"
+
+/*
+ * 79234640-9e10-4fea-a5c1-b5aa8b19756f
+ * This _DSM GUID returns information about the GPIO lines mapped to a
+ * discrete INT3472 device. Function number 1 returns a count of the GPIO
+ * lines that are mapped. Subsequent functions return 32 bit ints encoding
+ * information about the GPIO line, including its purpose.
+ */
+static const guid_t int3472_gpio_guid =
+	GUID_INIT(0x79234640, 0x9e10, 0x4fea,
+		  0xa5, 0xc1, 0xb5, 0xaa, 0x8b, 0x19, 0x75, 0x6f);
+
+/*
+ * 822ace8f-2814-4174-a56b-5f029fe079ee
+ * This _DSM GUID returns a string from the sensor device, which acts as a
+ * module identifier.
+ */
+static const guid_t cio2_sensor_module_guid =
+	GUID_INIT(0x822ace8f, 0x2814, 0x4174,
+		  0xa5, 0x6b, 0x5f, 0x02, 0x9f, 0xe0, 0x79, 0xee);
+
+/*
+ * Here follows platform specific mapping information that we can pass to
+ * the functions mapping resources to the sensors. Where the sensors have
+ * a power enable pin defined in DSDT we need to provide a supply name so
+ * the sensor drivers can find the regulator. The device name will be derived
+ * from the sensor's ACPI device within the code. Optionally, we can provide a
+ * NULL terminated array of function name mappings to deal with any platform
+ * specific deviations from the documented behaviour of GPIOs.
+ *
+ * Map a GPIO function name to NULL to prevent the driver from mapping that
+ * GPIO at all.
+ */
+
+static const struct int3472_gpio_function_remap ov2680_gpio_function_remaps[] = {
+	{ "reset", NULL },
+	{ "powerdown", "reset" },
+	{ }
+};
+
+static const struct int3472_sensor_config int3472_sensor_configs[] = {
+	/* Lenovo Miix 510-12ISK - OV2680, Front */
+	{ "GNDF140809R", { 0 }, ov2680_gpio_function_remaps },
+	/* Lenovo Miix 510-12ISK - OV5648, Rear */
+	{ "GEFF150023R", REGULATOR_SUPPLY("avdd", NULL), NULL },
+	/* Surface Go 1&2 - OV5693, Front */
+	{ "YHCU", REGULATOR_SUPPLY("avdd", NULL), NULL },
+};
+
+static const struct int3472_sensor_config *
+skl_int3472_get_sensor_module_config(struct int3472_discrete_device *int3472)
+{
+	union acpi_object *obj;
+	unsigned int i;
+
+	obj = acpi_evaluate_dsm_typed(int3472->sensor->handle,
+				      &cio2_sensor_module_guid, 0x00,
+				      0x01, NULL, ACPI_TYPE_STRING);
+
+	if (!obj) {
+		dev_err(int3472->dev,
+			"Failed to get sensor module string from _DSM\n");
+		return ERR_PTR(-ENODEV);
+	}
+
+	if (obj->string.type != ACPI_TYPE_STRING) {
+		dev_err(int3472->dev,
+			"Sensor _DSM returned a non-string value\n");
+
+		ACPI_FREE(obj);
+		return ERR_PTR(-EINVAL);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(int3472_sensor_configs); i++) {
+		if (!strcmp(int3472_sensor_configs[i].sensor_module_name,
+			    obj->string.pointer))
+			break;
+	}
+
+	ACPI_FREE(obj);
+
+	if (i >= ARRAY_SIZE(int3472_sensor_configs))
+		return ERR_PTR(-EINVAL);
+
+	return &int3472_sensor_configs[i];
+}
+
+static int skl_int3472_map_gpio_to_sensor(struct int3472_discrete_device *int3472,
+					  struct acpi_resource_gpio *agpio,
+					  const char *func, u32 polarity)
+{
+	const struct int3472_sensor_config *sensor_config;
+	char *path = agpio->resource_source.string_ptr;
+	struct gpiod_lookup *table_entry;
+	struct acpi_device *adev;
+	acpi_handle handle;
+	acpi_status status;
+	int ret;
+
+	if (int3472->n_sensor_gpios >= INT3472_MAX_SENSOR_GPIOS) {
+		dev_warn(int3472->dev, "Too many GPIOs mapped\n");
+		return -EINVAL;
+	}
+
+	sensor_config = int3472->sensor_config;
+	if (!IS_ERR(sensor_config) && sensor_config->function_maps) {
+		const struct int3472_gpio_function_remap *remap;
+
+		for (remap = sensor_config->function_maps; remap->documented; remap++) {
+			if (!strcmp(func, remap->documented)) {
+				func = remap->actual;
+				break;
+			}
+		}
+	}
+
+	/* Functions mapped to NULL should not be mapped to the sensor */
+	if (!func)
+		return 0;
+
+	status = acpi_get_handle(NULL, path, &handle);
+	if (ACPI_FAILURE(status))
+		return -EINVAL;
+
+	ret = acpi_bus_get_device(handle, &adev);
+	if (ret)
+		return -ENODEV;
+
+	table_entry = &int3472->gpios.table[int3472->n_sensor_gpios];
+	table_entry->key = acpi_dev_name(adev);
+	table_entry->chip_hwnum = agpio->pin_table[0];
+	table_entry->con_id = func;
+	table_entry->idx = 0;
+	table_entry->flags = polarity;
+
+	int3472->n_sensor_gpios++;
+
+	return 0;
+}
+
+static int skl_int3472_map_gpio_to_clk(struct int3472_discrete_device *int3472,
+				       struct acpi_resource_gpio *agpio, u8 type)
+{
+	char *path = agpio->resource_source.string_ptr;
+	u16 pin = agpio->pin_table[0];
+	struct gpio_desc *gpio;
+
+	switch (type) {
+	case INT3472_GPIO_TYPE_CLK_ENABLE:
+		gpio = acpi_get_and_request_gpiod(path, pin, "int3472,clk-enable");
+		if (IS_ERR(gpio))
+			return (PTR_ERR(gpio));
+
+		int3472->clock.ena_gpio = gpio;
+		/* Ensure the pin is in output mode and non-active state */
+		gpiod_direction_output(int3472->clock.ena_gpio, 0);
+		break;
+	case INT3472_GPIO_TYPE_PRIVACY_LED:
+		gpio = acpi_get_and_request_gpiod(path, pin, "int3472,privacy-led");
+		if (IS_ERR(gpio))
+			return (PTR_ERR(gpio));
+
+		int3472->clock.led_gpio = gpio;
+		/* Ensure the pin is in output mode and non-active state */
+		gpiod_direction_output(int3472->clock.led_gpio, 0);
+		break;
+	default:
+		dev_err(int3472->dev, "Invalid GPIO type 0x%02x for clock\n", type);
+		break;
+	}
+
+	return 0;
+}
+
+/**
+ * skl_int3472_handle_gpio_resources: Map PMIC resources to consuming sensor
+ * @ares: A pointer to a &struct acpi_resource
+ * @data: A pointer to a &struct int3472_discrete_device
+ *
+ * This function handles GPIO resources that are against an INT3472
+ * ACPI device, by checking the value of the corresponding _DSM entry.
+ * This will return a 32bit int, where the lowest byte represents the
+ * function of the GPIO pin:
+ *
+ * 0x00 Reset
+ * 0x01 Power down
+ * 0x0b Power enable
+ * 0x0c Clock enable
+ * 0x0d Privacy LED
+ *
+ * There are some known platform specific quirks where that does not quite
+ * hold up; for example where a pin with type 0x01 (Power down) is mapped to
+ * a sensor pin that performs a reset function or entries in _CRS and _DSM that
+ * do not actually correspond to a physical connection. These will be handled
+ * by the mapping sub-functions.
+ *
+ * GPIOs will either be mapped directly to the sensor device or else used
+ * to create clocks and regulators via the usual frameworks.
+ *
+ * Return:
+ * * 1		- To continue the loop
+ * * 0		- When all resources found are handled properly.
+ * * -EINVAL	- If the resource is not a GPIO IO resource
+ * * -ENODEV	- If the resource has no corresponding _DSM entry
+ * * -Other	- Errors propagated from one of the sub-functions.
+ */
+static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
+					     void *data)
+{
+	struct int3472_discrete_device *int3472 = data;
+	struct acpi_resource_gpio *agpio;
+	union acpi_object *obj;
+	const char *err_msg;
+	int ret;
+	u8 type;
+
+	if (!acpi_gpio_get_io_resource(ares, &agpio))
+		return 1;
+
+	/*
+	 * ngpios + 2 because the index of this _DSM function is 1-based and
+	 * the first function is just a count.
+	 */
+	obj = acpi_evaluate_dsm_typed(int3472->adev->handle,
+				      &int3472_gpio_guid, 0x00,
+				      int3472->ngpios + 2,
+				      NULL, ACPI_TYPE_INTEGER);
+
+	if (!obj) {
+		dev_warn(int3472->dev, "No _DSM entry for GPIO pin %u\n",
+			 agpio->pin_table[0]);
+		return 1;
+	}
+
+	type = obj->integer.value & 0xff;
+
+	switch (type) {
+	case INT3472_GPIO_TYPE_RESET:
+		ret = skl_int3472_map_gpio_to_sensor(int3472, agpio, "reset",
+						     GPIO_ACTIVE_LOW);
+		if (ret)
+			err_msg = "Failed to map reset pin to sensor\n";
+
+		break;
+	case INT3472_GPIO_TYPE_POWERDOWN:
+		ret = skl_int3472_map_gpio_to_sensor(int3472, agpio, "powerdown",
+						     GPIO_ACTIVE_LOW);
+		if (ret)
+			err_msg = "Failed to map powerdown pin to sensor\n";
+
+		break;
+	case INT3472_GPIO_TYPE_CLK_ENABLE:
+	case INT3472_GPIO_TYPE_PRIVACY_LED:
+		ret = skl_int3472_map_gpio_to_clk(int3472, agpio, type);
+		if (ret)
+			err_msg = "Failed to map GPIO to clock\n";
+
+		break;
+	case INT3472_GPIO_TYPE_POWER_ENABLE:
+		ret = skl_int3472_register_regulator(int3472, agpio);
+		if (ret)
+			err_msg = "Failed to map regulator to sensor\n";
+
+		break;
+	default:
+		dev_warn(int3472->dev,
+			 "GPIO type 0x%02x unknown; the sensor may not work\n",
+			 type);
+		ret = 1;
+		break;
+	}
+
+	int3472->ngpios++;
+	ACPI_FREE(obj);
+
+	if (ret < 0)
+		return dev_err_probe(int3472->dev, ret, err_msg);
+
+	return ret;
+}
+
+static int skl_int3472_parse_crs(struct int3472_discrete_device *int3472)
+{
+	LIST_HEAD(resource_list);
+	int ret;
+
+	/*
+	 * No error check, because not having a sensor config is not necessarily
+	 * a failure mode.
+	 */
+	int3472->sensor_config = skl_int3472_get_sensor_module_config(int3472);
+
+	ret = acpi_dev_get_resources(int3472->adev, &resource_list,
+				     skl_int3472_handle_gpio_resources,
+				     int3472);
+	if (ret < 0)
+		return ret;
+
+	acpi_dev_free_resource_list(&resource_list);
+
+	/*
+	 * If we find no clock enable GPIO pin then the privacy LED won't work.
+	 * We've never seen that situation, but it's possible. Warn the user so
+	 * it's clear what's happened.
+	 */
+	if (int3472->clock.ena_gpio) {
+		ret = skl_int3472_register_clock(int3472);
+		if (ret)
+			return ret;
+	} else {
+		if (int3472->clock.led_gpio)
+			dev_warn(int3472->dev,
+				 "No clk GPIO. The privacy LED won't work\n");
+	}
+
+	int3472->gpios.dev_id = int3472->sensor_name;
+	gpiod_add_lookup_table(&int3472->gpios);
+
+	return 0;
+}
+
+static int skl_int3472_discrete_remove(struct platform_device *pdev);
+
+static int skl_int3472_discrete_probe(struct platform_device *pdev)
+{
+	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
+	struct int3472_discrete_device *int3472;
+	struct int3472_cldb cldb;
+	int ret;
+
+	ret = skl_int3472_fill_cldb(adev, &cldb);
+	if (ret) {
+		dev_err(&pdev->dev, "Couldn't fill CLDB structure\n");
+		return ret;
+	}
+
+	if (cldb.control_logic_type != 1) {
+		dev_err(&pdev->dev, "Unsupported control logic type %u\n",
+			cldb.control_logic_type);
+		return -EINVAL;
+	}
+
+	/* Max num GPIOs we've seen plus a terminator */
+	int3472 = devm_kzalloc(&pdev->dev, struct_size(int3472, gpios.table,
+			       INT3472_MAX_SENSOR_GPIOS + 1), GFP_KERNEL);
+	if (!int3472)
+		return -ENOMEM;
+
+	int3472->adev = adev;
+	int3472->dev = &pdev->dev;
+	platform_set_drvdata(pdev, int3472);
+
+	int3472->sensor = acpi_dev_get_first_consumer_dev(adev);
+	if (!int3472->sensor) {
+		dev_err(&pdev->dev, "INT3472 seems to have no dependents.\n");
+		return -ENODEV;
+	}
+
+	int3472->sensor_name = devm_kasprintf(int3472->dev, GFP_KERNEL,
+					      I2C_DEV_NAME_FORMAT,
+					      acpi_dev_name(int3472->sensor));
+	if (!int3472->sensor_name) {
+		ret = -ENOMEM;
+		goto err_put_sensor;
+	}
+
+	/*
+	 * Initialising this list means we can call gpiod_remove_lookup_table()
+	 * in failure paths without issue.
+	 */
+	INIT_LIST_HEAD(&int3472->gpios.list);
+
+	ret = skl_int3472_parse_crs(int3472);
+	if (ret) {
+		skl_int3472_discrete_remove(pdev);
+		return ret;
+	}
+
+	return 0;
+
+err_put_sensor:
+	acpi_dev_put(int3472->sensor);
+
+	return ret;
+}
+
+static int skl_int3472_discrete_remove(struct platform_device *pdev)
+{
+	struct int3472_discrete_device *int3472 = platform_get_drvdata(pdev);
+
+	gpiod_remove_lookup_table(&int3472->gpios);
+
+	if (int3472->clock.cl)
+		skl_int3472_unregister_clock(int3472);
+
+	gpiod_put(int3472->clock.ena_gpio);
+	gpiod_put(int3472->clock.led_gpio);
+
+	skl_int3472_unregister_regulator(int3472);
+
+	return 0;
+}
+
+static const struct acpi_device_id int3472_device_id[] = {
+	{ "INT3472", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(acpi, int3472_device_id);
+
+static struct platform_driver int3472_discrete = {
+	.driver = {
+		.name = "int3472-discrete",
+		.acpi_match_table = int3472_device_id,
+	},
+	.probe = skl_int3472_discrete_probe,
+	.remove = skl_int3472_discrete_remove,
+};
+module_platform_driver(int3472_discrete);
+
+MODULE_DESCRIPTION("Intel SkyLake INT3472 ACPI Discrete Device Driver");
+MODULE_AUTHOR("Daniel Scally <djrscally@gmail.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/platform/x86/intel/int3472/intel_skl_int3472_clk_and_regulator.c b/drivers/platform/x86/intel/int3472/intel_skl_int3472_clk_and_regulator.c
deleted file mode 100644
index 1700e7557a82..000000000000
--- a/drivers/platform/x86/intel/int3472/intel_skl_int3472_clk_and_regulator.c
+++ /dev/null
@@ -1,207 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Author: Dan Scally <djrscally@gmail.com> */
-
-#include <linux/acpi.h>
-#include <linux/clkdev.h>
-#include <linux/clk-provider.h>
-#include <linux/device.h>
-#include <linux/gpio/consumer.h>
-#include <linux/regulator/driver.h>
-#include <linux/slab.h>
-
-#include "intel_skl_int3472_common.h"
-
-/*
- * The regulators have to have .ops to be valid, but the only ops we actually
- * support are .enable and .disable which are handled via .ena_gpiod. Pass an
- * empty struct to clear the check without lying about capabilities.
- */
-static const struct regulator_ops int3472_gpio_regulator_ops;
-
-static int skl_int3472_clk_prepare(struct clk_hw *hw)
-{
-	struct int3472_gpio_clock *clk = to_int3472_clk(hw);
-
-	gpiod_set_value_cansleep(clk->ena_gpio, 1);
-	gpiod_set_value_cansleep(clk->led_gpio, 1);
-
-	return 0;
-}
-
-static void skl_int3472_clk_unprepare(struct clk_hw *hw)
-{
-	struct int3472_gpio_clock *clk = to_int3472_clk(hw);
-
-	gpiod_set_value_cansleep(clk->ena_gpio, 0);
-	gpiod_set_value_cansleep(clk->led_gpio, 0);
-}
-
-static int skl_int3472_clk_enable(struct clk_hw *hw)
-{
-	/*
-	 * We're just turning a GPIO on to enable the clock, which operation
-	 * has the potential to sleep. Given .enable() cannot sleep, but
-	 * .prepare() can, we toggle the GPIO in .prepare() instead. Thus,
-	 * nothing to do here.
-	 */
-	return 0;
-}
-
-static void skl_int3472_clk_disable(struct clk_hw *hw)
-{
-	/* Likewise, nothing to do here... */
-}
-
-static unsigned int skl_int3472_get_clk_frequency(struct int3472_discrete_device *int3472)
-{
-	union acpi_object *obj;
-	unsigned int freq;
-
-	obj = skl_int3472_get_acpi_buffer(int3472->sensor, "SSDB");
-	if (IS_ERR(obj))
-		return 0; /* report rate as 0 on error */
-
-	if (obj->buffer.length < CIO2_SENSOR_SSDB_MCLKSPEED_OFFSET + sizeof(u32)) {
-		dev_err(int3472->dev, "The buffer is too small\n");
-		kfree(obj);
-		return 0;
-	}
-
-	freq = *(u32 *)(obj->buffer.pointer + CIO2_SENSOR_SSDB_MCLKSPEED_OFFSET);
-
-	kfree(obj);
-	return freq;
-}
-
-static unsigned long skl_int3472_clk_recalc_rate(struct clk_hw *hw,
-						 unsigned long parent_rate)
-{
-	struct int3472_gpio_clock *clk = to_int3472_clk(hw);
-
-	return clk->frequency;
-}
-
-static const struct clk_ops skl_int3472_clock_ops = {
-	.prepare = skl_int3472_clk_prepare,
-	.unprepare = skl_int3472_clk_unprepare,
-	.enable = skl_int3472_clk_enable,
-	.disable = skl_int3472_clk_disable,
-	.recalc_rate = skl_int3472_clk_recalc_rate,
-};
-
-int skl_int3472_register_clock(struct int3472_discrete_device *int3472)
-{
-	struct clk_init_data init = {
-		.ops = &skl_int3472_clock_ops,
-		.flags = CLK_GET_RATE_NOCACHE,
-	};
-	int ret;
-
-	init.name = kasprintf(GFP_KERNEL, "%s-clk",
-			      acpi_dev_name(int3472->adev));
-	if (!init.name)
-		return -ENOMEM;
-
-	int3472->clock.frequency = skl_int3472_get_clk_frequency(int3472);
-
-	int3472->clock.clk_hw.init = &init;
-	int3472->clock.clk = clk_register(&int3472->adev->dev,
-					  &int3472->clock.clk_hw);
-	if (IS_ERR(int3472->clock.clk)) {
-		ret = PTR_ERR(int3472->clock.clk);
-		goto out_free_init_name;
-	}
-
-	int3472->clock.cl = clkdev_create(int3472->clock.clk, NULL,
-					  int3472->sensor_name);
-	if (!int3472->clock.cl) {
-		ret = -ENOMEM;
-		goto err_unregister_clk;
-	}
-
-	kfree(init.name);
-	return 0;
-
-err_unregister_clk:
-	clk_unregister(int3472->clock.clk);
-out_free_init_name:
-	kfree(init.name);
-
-	return ret;
-}
-
-void skl_int3472_unregister_clock(struct int3472_discrete_device *int3472)
-{
-	clkdev_drop(int3472->clock.cl);
-	clk_unregister(int3472->clock.clk);
-}
-
-int skl_int3472_register_regulator(struct int3472_discrete_device *int3472,
-				   struct acpi_resource_gpio *agpio)
-{
-	const struct int3472_sensor_config *sensor_config;
-	char *path = agpio->resource_source.string_ptr;
-	struct regulator_consumer_supply supply_map;
-	struct regulator_init_data init_data = { };
-	struct regulator_config cfg = { };
-	int ret;
-
-	sensor_config = int3472->sensor_config;
-	if (IS_ERR(sensor_config)) {
-		dev_err(int3472->dev, "No sensor module config\n");
-		return PTR_ERR(sensor_config);
-	}
-
-	if (!sensor_config->supply_map.supply) {
-		dev_err(int3472->dev, "No supply name defined\n");
-		return -ENODEV;
-	}
-
-	init_data.constraints.valid_ops_mask = REGULATOR_CHANGE_STATUS;
-	init_data.num_consumer_supplies = 1;
-	supply_map = sensor_config->supply_map;
-	supply_map.dev_name = int3472->sensor_name;
-	init_data.consumer_supplies = &supply_map;
-
-	snprintf(int3472->regulator.regulator_name,
-		 sizeof(int3472->regulator.regulator_name), "%s-regulator",
-		 acpi_dev_name(int3472->adev));
-	snprintf(int3472->regulator.supply_name,
-		 GPIO_REGULATOR_SUPPLY_NAME_LENGTH, "supply-0");
-
-	int3472->regulator.rdesc = INT3472_REGULATOR(
-						int3472->regulator.regulator_name,
-						int3472->regulator.supply_name,
-						&int3472_gpio_regulator_ops);
-
-	int3472->regulator.gpio = acpi_get_and_request_gpiod(path, agpio->pin_table[0],
-							     "int3472,regulator");
-	if (IS_ERR(int3472->regulator.gpio)) {
-		dev_err(int3472->dev, "Failed to get regulator GPIO line\n");
-		return PTR_ERR(int3472->regulator.gpio);
-	}
-
-	cfg.dev = &int3472->adev->dev;
-	cfg.init_data = &init_data;
-	cfg.ena_gpiod = int3472->regulator.gpio;
-
-	int3472->regulator.rdev = regulator_register(&int3472->regulator.rdesc,
-						     &cfg);
-	if (IS_ERR(int3472->regulator.rdev)) {
-		ret = PTR_ERR(int3472->regulator.rdev);
-		goto err_free_gpio;
-	}
-
-	return 0;
-
-err_free_gpio:
-	gpiod_put(int3472->regulator.gpio);
-
-	return ret;
-}
-
-void skl_int3472_unregister_regulator(struct int3472_discrete_device *int3472)
-{
-	regulator_unregister(int3472->regulator.rdev);
-	gpiod_put(int3472->regulator.gpio);
-}
diff --git a/drivers/platform/x86/intel/int3472/intel_skl_int3472_common.c b/drivers/platform/x86/intel/int3472/intel_skl_int3472_common.c
deleted file mode 100644
index 497e74fba75f..000000000000
--- a/drivers/platform/x86/intel/int3472/intel_skl_int3472_common.c
+++ /dev/null
@@ -1,106 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Author: Dan Scally <djrscally@gmail.com> */
-
-#include <linux/acpi.h>
-#include <linux/i2c.h>
-#include <linux/platform_device.h>
-#include <linux/slab.h>
-
-#include "intel_skl_int3472_common.h"
-
-union acpi_object *skl_int3472_get_acpi_buffer(struct acpi_device *adev, char *id)
-{
-	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
-	acpi_handle handle = adev->handle;
-	union acpi_object *obj;
-	acpi_status status;
-
-	status = acpi_evaluate_object(handle, id, NULL, &buffer);
-	if (ACPI_FAILURE(status))
-		return ERR_PTR(-ENODEV);
-
-	obj = buffer.pointer;
-	if (!obj)
-		return ERR_PTR(-ENODEV);
-
-	if (obj->type != ACPI_TYPE_BUFFER) {
-		acpi_handle_err(handle, "%s object is not an ACPI buffer\n", id);
-		kfree(obj);
-		return ERR_PTR(-EINVAL);
-	}
-
-	return obj;
-}
-
-int skl_int3472_fill_cldb(struct acpi_device *adev, struct int3472_cldb *cldb)
-{
-	union acpi_object *obj;
-	int ret;
-
-	obj = skl_int3472_get_acpi_buffer(adev, "CLDB");
-	if (IS_ERR(obj))
-		return PTR_ERR(obj);
-
-	if (obj->buffer.length > sizeof(*cldb)) {
-		acpi_handle_err(adev->handle, "The CLDB buffer is too large\n");
-		ret = -EINVAL;
-		goto out_free_obj;
-	}
-
-	memcpy(cldb, obj->buffer.pointer, obj->buffer.length);
-	ret = 0;
-
-out_free_obj:
-	kfree(obj);
-	return ret;
-}
-
-static const struct acpi_device_id int3472_device_id[] = {
-	{ "INT3472", 0 },
-	{ }
-};
-MODULE_DEVICE_TABLE(acpi, int3472_device_id);
-
-static struct platform_driver int3472_discrete = {
-	.driver = {
-		.name = "int3472-discrete",
-		.acpi_match_table = int3472_device_id,
-	},
-	.probe = skl_int3472_discrete_probe,
-	.remove = skl_int3472_discrete_remove,
-};
-
-static struct i2c_driver int3472_tps68470 = {
-	.driver = {
-		.name = "int3472-tps68470",
-		.acpi_match_table = int3472_device_id,
-	},
-	.probe_new = skl_int3472_tps68470_probe,
-};
-
-static int skl_int3472_init(void)
-{
-	int ret;
-
-	ret = platform_driver_register(&int3472_discrete);
-	if (ret)
-		return ret;
-
-	ret = i2c_register_driver(THIS_MODULE, &int3472_tps68470);
-	if (ret)
-		platform_driver_unregister(&int3472_discrete);
-
-	return ret;
-}
-module_init(skl_int3472_init);
-
-static void skl_int3472_exit(void)
-{
-	platform_driver_unregister(&int3472_discrete);
-	i2c_del_driver(&int3472_tps68470);
-}
-module_exit(skl_int3472_exit);
-
-MODULE_DESCRIPTION("Intel SkyLake INT3472 ACPI Device Driver");
-MODULE_AUTHOR("Daniel Scally <djrscally@gmail.com>");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/platform/x86/intel/int3472/intel_skl_int3472_common.h b/drivers/platform/x86/intel/int3472/intel_skl_int3472_common.h
deleted file mode 100644
index 714fde73b524..000000000000
--- a/drivers/platform/x86/intel/int3472/intel_skl_int3472_common.h
+++ /dev/null
@@ -1,122 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Author: Dan Scally <djrscally@gmail.com> */
-
-#ifndef _INTEL_SKL_INT3472_H
-#define _INTEL_SKL_INT3472_H
-
-#include <linux/clk-provider.h>
-#include <linux/gpio/machine.h>
-#include <linux/regulator/driver.h>
-#include <linux/regulator/machine.h>
-#include <linux/types.h>
-
-/* FIXME drop this once the I2C_DEV_NAME_FORMAT macro has been added to include/linux/i2c.h */
-#ifndef I2C_DEV_NAME_FORMAT
-#define I2C_DEV_NAME_FORMAT					"i2c-%s"
-#endif
-
-/* PMIC GPIO Types */
-#define INT3472_GPIO_TYPE_RESET					0x00
-#define INT3472_GPIO_TYPE_POWERDOWN				0x01
-#define INT3472_GPIO_TYPE_POWER_ENABLE				0x0b
-#define INT3472_GPIO_TYPE_CLK_ENABLE				0x0c
-#define INT3472_GPIO_TYPE_PRIVACY_LED				0x0d
-
-#define INT3472_PDEV_MAX_NAME_LEN				23
-#define INT3472_MAX_SENSOR_GPIOS				3
-
-#define GPIO_REGULATOR_NAME_LENGTH				21
-#define GPIO_REGULATOR_SUPPLY_NAME_LENGTH			9
-
-#define CIO2_SENSOR_SSDB_MCLKSPEED_OFFSET			86
-
-#define INT3472_REGULATOR(_name, _supply, _ops)			\
-	(const struct regulator_desc) {				\
-		.name = _name,					\
-		.supply_name = _supply,				\
-		.type = REGULATOR_VOLTAGE,			\
-		.ops = _ops,					\
-		.owner = THIS_MODULE,				\
-	}
-
-#define to_int3472_clk(hw)					\
-	container_of(hw, struct int3472_gpio_clock, clk_hw)
-
-#define to_int3472_device(clk)					\
-	container_of(clk, struct int3472_discrete_device, clock)
-
-struct acpi_device;
-struct i2c_client;
-struct platform_device;
-
-struct int3472_cldb {
-	u8 version;
-	/*
-	 * control logic type
-	 * 0: UNKNOWN
-	 * 1: DISCRETE(CRD-D)
-	 * 2: PMIC TPS68470
-	 * 3: PMIC uP6641
-	 */
-	u8 control_logic_type;
-	u8 control_logic_id;
-	u8 sensor_card_sku;
-	u8 reserved[28];
-};
-
-struct int3472_gpio_function_remap {
-	const char *documented;
-	const char *actual;
-};
-
-struct int3472_sensor_config {
-	const char *sensor_module_name;
-	struct regulator_consumer_supply supply_map;
-	const struct int3472_gpio_function_remap *function_maps;
-};
-
-struct int3472_discrete_device {
-	struct acpi_device *adev;
-	struct device *dev;
-	struct acpi_device *sensor;
-	const char *sensor_name;
-
-	const struct int3472_sensor_config *sensor_config;
-
-	struct int3472_gpio_regulator {
-		char regulator_name[GPIO_REGULATOR_NAME_LENGTH];
-		char supply_name[GPIO_REGULATOR_SUPPLY_NAME_LENGTH];
-		struct gpio_desc *gpio;
-		struct regulator_dev *rdev;
-		struct regulator_desc rdesc;
-	} regulator;
-
-	struct int3472_gpio_clock {
-		struct clk *clk;
-		struct clk_hw clk_hw;
-		struct clk_lookup *cl;
-		struct gpio_desc *ena_gpio;
-		struct gpio_desc *led_gpio;
-		u32 frequency;
-	} clock;
-
-	unsigned int ngpios; /* how many GPIOs have we seen */
-	unsigned int n_sensor_gpios; /* how many have we mapped to sensor */
-	struct gpiod_lookup_table gpios;
-};
-
-int skl_int3472_discrete_probe(struct platform_device *pdev);
-int skl_int3472_discrete_remove(struct platform_device *pdev);
-int skl_int3472_tps68470_probe(struct i2c_client *client);
-union acpi_object *skl_int3472_get_acpi_buffer(struct acpi_device *adev,
-					       char *id);
-int skl_int3472_fill_cldb(struct acpi_device *adev, struct int3472_cldb *cldb);
-
-int skl_int3472_register_clock(struct int3472_discrete_device *int3472);
-void skl_int3472_unregister_clock(struct int3472_discrete_device *int3472);
-
-int skl_int3472_register_regulator(struct int3472_discrete_device *int3472,
-				   struct acpi_resource_gpio *agpio);
-void skl_int3472_unregister_regulator(struct int3472_discrete_device *int3472);
-
-#endif
diff --git a/drivers/platform/x86/intel/int3472/intel_skl_int3472_discrete.c b/drivers/platform/x86/intel/int3472/intel_skl_int3472_discrete.c
deleted file mode 100644
index e59d79c7e82f..000000000000
--- a/drivers/platform/x86/intel/int3472/intel_skl_int3472_discrete.c
+++ /dev/null
@@ -1,413 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Author: Dan Scally <djrscally@gmail.com> */
-
-#include <linux/acpi.h>
-#include <linux/clkdev.h>
-#include <linux/clk-provider.h>
-#include <linux/device.h>
-#include <linux/gpio/consumer.h>
-#include <linux/gpio/machine.h>
-#include <linux/i2c.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/overflow.h>
-#include <linux/platform_device.h>
-#include <linux/uuid.h>
-
-#include "intel_skl_int3472_common.h"
-
-/*
- * 79234640-9e10-4fea-a5c1-b5aa8b19756f
- * This _DSM GUID returns information about the GPIO lines mapped to a
- * discrete INT3472 device. Function number 1 returns a count of the GPIO
- * lines that are mapped. Subsequent functions return 32 bit ints encoding
- * information about the GPIO line, including its purpose.
- */
-static const guid_t int3472_gpio_guid =
-	GUID_INIT(0x79234640, 0x9e10, 0x4fea,
-		  0xa5, 0xc1, 0xb5, 0xaa, 0x8b, 0x19, 0x75, 0x6f);
-
-/*
- * 822ace8f-2814-4174-a56b-5f029fe079ee
- * This _DSM GUID returns a string from the sensor device, which acts as a
- * module identifier.
- */
-static const guid_t cio2_sensor_module_guid =
-	GUID_INIT(0x822ace8f, 0x2814, 0x4174,
-		  0xa5, 0x6b, 0x5f, 0x02, 0x9f, 0xe0, 0x79, 0xee);
-
-/*
- * Here follows platform specific mapping information that we can pass to
- * the functions mapping resources to the sensors. Where the sensors have
- * a power enable pin defined in DSDT we need to provide a supply name so
- * the sensor drivers can find the regulator. The device name will be derived
- * from the sensor's ACPI device within the code. Optionally, we can provide a
- * NULL terminated array of function name mappings to deal with any platform
- * specific deviations from the documented behaviour of GPIOs.
- *
- * Map a GPIO function name to NULL to prevent the driver from mapping that
- * GPIO at all.
- */
-
-static const struct int3472_gpio_function_remap ov2680_gpio_function_remaps[] = {
-	{ "reset", NULL },
-	{ "powerdown", "reset" },
-	{ }
-};
-
-static const struct int3472_sensor_config int3472_sensor_configs[] = {
-	/* Lenovo Miix 510-12ISK - OV2680, Front */
-	{ "GNDF140809R", { 0 }, ov2680_gpio_function_remaps },
-	/* Lenovo Miix 510-12ISK - OV5648, Rear */
-	{ "GEFF150023R", REGULATOR_SUPPLY("avdd", NULL), NULL },
-	/* Surface Go 1&2 - OV5693, Front */
-	{ "YHCU", REGULATOR_SUPPLY("avdd", NULL), NULL },
-};
-
-static const struct int3472_sensor_config *
-skl_int3472_get_sensor_module_config(struct int3472_discrete_device *int3472)
-{
-	union acpi_object *obj;
-	unsigned int i;
-
-	obj = acpi_evaluate_dsm_typed(int3472->sensor->handle,
-				      &cio2_sensor_module_guid, 0x00,
-				      0x01, NULL, ACPI_TYPE_STRING);
-
-	if (!obj) {
-		dev_err(int3472->dev,
-			"Failed to get sensor module string from _DSM\n");
-		return ERR_PTR(-ENODEV);
-	}
-
-	if (obj->string.type != ACPI_TYPE_STRING) {
-		dev_err(int3472->dev,
-			"Sensor _DSM returned a non-string value\n");
-
-		ACPI_FREE(obj);
-		return ERR_PTR(-EINVAL);
-	}
-
-	for (i = 0; i < ARRAY_SIZE(int3472_sensor_configs); i++) {
-		if (!strcmp(int3472_sensor_configs[i].sensor_module_name,
-			    obj->string.pointer))
-			break;
-	}
-
-	ACPI_FREE(obj);
-
-	if (i >= ARRAY_SIZE(int3472_sensor_configs))
-		return ERR_PTR(-EINVAL);
-
-	return &int3472_sensor_configs[i];
-}
-
-static int skl_int3472_map_gpio_to_sensor(struct int3472_discrete_device *int3472,
-					  struct acpi_resource_gpio *agpio,
-					  const char *func, u32 polarity)
-{
-	const struct int3472_sensor_config *sensor_config;
-	char *path = agpio->resource_source.string_ptr;
-	struct gpiod_lookup *table_entry;
-	struct acpi_device *adev;
-	acpi_handle handle;
-	acpi_status status;
-	int ret;
-
-	if (int3472->n_sensor_gpios >= INT3472_MAX_SENSOR_GPIOS) {
-		dev_warn(int3472->dev, "Too many GPIOs mapped\n");
-		return -EINVAL;
-	}
-
-	sensor_config = int3472->sensor_config;
-	if (!IS_ERR(sensor_config) && sensor_config->function_maps) {
-		const struct int3472_gpio_function_remap *remap;
-
-		for (remap = sensor_config->function_maps; remap->documented; remap++) {
-			if (!strcmp(func, remap->documented)) {
-				func = remap->actual;
-				break;
-			}
-		}
-	}
-
-	/* Functions mapped to NULL should not be mapped to the sensor */
-	if (!func)
-		return 0;
-
-	status = acpi_get_handle(NULL, path, &handle);
-	if (ACPI_FAILURE(status))
-		return -EINVAL;
-
-	ret = acpi_bus_get_device(handle, &adev);
-	if (ret)
-		return -ENODEV;
-
-	table_entry = &int3472->gpios.table[int3472->n_sensor_gpios];
-	table_entry->key = acpi_dev_name(adev);
-	table_entry->chip_hwnum = agpio->pin_table[0];
-	table_entry->con_id = func;
-	table_entry->idx = 0;
-	table_entry->flags = polarity;
-
-	int3472->n_sensor_gpios++;
-
-	return 0;
-}
-
-static int skl_int3472_map_gpio_to_clk(struct int3472_discrete_device *int3472,
-				       struct acpi_resource_gpio *agpio, u8 type)
-{
-	char *path = agpio->resource_source.string_ptr;
-	u16 pin = agpio->pin_table[0];
-	struct gpio_desc *gpio;
-
-	switch (type) {
-	case INT3472_GPIO_TYPE_CLK_ENABLE:
-		gpio = acpi_get_and_request_gpiod(path, pin, "int3472,clk-enable");
-		if (IS_ERR(gpio))
-			return (PTR_ERR(gpio));
-
-		int3472->clock.ena_gpio = gpio;
-		break;
-	case INT3472_GPIO_TYPE_PRIVACY_LED:
-		gpio = acpi_get_and_request_gpiod(path, pin, "int3472,privacy-led");
-		if (IS_ERR(gpio))
-			return (PTR_ERR(gpio));
-
-		int3472->clock.led_gpio = gpio;
-		break;
-	default:
-		dev_err(int3472->dev, "Invalid GPIO type 0x%02x for clock\n", type);
-		break;
-	}
-
-	return 0;
-}
-
-/**
- * skl_int3472_handle_gpio_resources: Map PMIC resources to consuming sensor
- * @ares: A pointer to a &struct acpi_resource
- * @data: A pointer to a &struct int3472_discrete_device
- *
- * This function handles GPIO resources that are against an INT3472
- * ACPI device, by checking the value of the corresponding _DSM entry.
- * This will return a 32bit int, where the lowest byte represents the
- * function of the GPIO pin:
- *
- * 0x00 Reset
- * 0x01 Power down
- * 0x0b Power enable
- * 0x0c Clock enable
- * 0x0d Privacy LED
- *
- * There are some known platform specific quirks where that does not quite
- * hold up; for example where a pin with type 0x01 (Power down) is mapped to
- * a sensor pin that performs a reset function or entries in _CRS and _DSM that
- * do not actually correspond to a physical connection. These will be handled
- * by the mapping sub-functions.
- *
- * GPIOs will either be mapped directly to the sensor device or else used
- * to create clocks and regulators via the usual frameworks.
- *
- * Return:
- * * 1		- To continue the loop
- * * 0		- When all resources found are handled properly.
- * * -EINVAL	- If the resource is not a GPIO IO resource
- * * -ENODEV	- If the resource has no corresponding _DSM entry
- * * -Other	- Errors propagated from one of the sub-functions.
- */
-static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
-					     void *data)
-{
-	struct int3472_discrete_device *int3472 = data;
-	struct acpi_resource_gpio *agpio;
-	union acpi_object *obj;
-	const char *err_msg;
-	int ret;
-	u8 type;
-
-	if (!acpi_gpio_get_io_resource(ares, &agpio))
-		return 1;
-
-	/*
-	 * ngpios + 2 because the index of this _DSM function is 1-based and
-	 * the first function is just a count.
-	 */
-	obj = acpi_evaluate_dsm_typed(int3472->adev->handle,
-				      &int3472_gpio_guid, 0x00,
-				      int3472->ngpios + 2,
-				      NULL, ACPI_TYPE_INTEGER);
-
-	if (!obj) {
-		dev_warn(int3472->dev, "No _DSM entry for GPIO pin %u\n",
-			 agpio->pin_table[0]);
-		return 1;
-	}
-
-	type = obj->integer.value & 0xff;
-
-	switch (type) {
-	case INT3472_GPIO_TYPE_RESET:
-		ret = skl_int3472_map_gpio_to_sensor(int3472, agpio, "reset",
-						     GPIO_ACTIVE_LOW);
-		if (ret)
-			err_msg = "Failed to map reset pin to sensor\n";
-
-		break;
-	case INT3472_GPIO_TYPE_POWERDOWN:
-		ret = skl_int3472_map_gpio_to_sensor(int3472, agpio, "powerdown",
-						     GPIO_ACTIVE_LOW);
-		if (ret)
-			err_msg = "Failed to map powerdown pin to sensor\n";
-
-		break;
-	case INT3472_GPIO_TYPE_CLK_ENABLE:
-	case INT3472_GPIO_TYPE_PRIVACY_LED:
-		ret = skl_int3472_map_gpio_to_clk(int3472, agpio, type);
-		if (ret)
-			err_msg = "Failed to map GPIO to clock\n";
-
-		break;
-	case INT3472_GPIO_TYPE_POWER_ENABLE:
-		ret = skl_int3472_register_regulator(int3472, agpio);
-		if (ret)
-			err_msg = "Failed to map regulator to sensor\n";
-
-		break;
-	default:
-		dev_warn(int3472->dev,
-			 "GPIO type 0x%02x unknown; the sensor may not work\n",
-			 type);
-		ret = 1;
-		break;
-	}
-
-	int3472->ngpios++;
-	ACPI_FREE(obj);
-
-	if (ret < 0)
-		return dev_err_probe(int3472->dev, ret, err_msg);
-
-	return ret;
-}
-
-static int skl_int3472_parse_crs(struct int3472_discrete_device *int3472)
-{
-	LIST_HEAD(resource_list);
-	int ret;
-
-	/*
-	 * No error check, because not having a sensor config is not necessarily
-	 * a failure mode.
-	 */
-	int3472->sensor_config = skl_int3472_get_sensor_module_config(int3472);
-
-	ret = acpi_dev_get_resources(int3472->adev, &resource_list,
-				     skl_int3472_handle_gpio_resources,
-				     int3472);
-	if (ret < 0)
-		return ret;
-
-	acpi_dev_free_resource_list(&resource_list);
-
-	/*
-	 * If we find no clock enable GPIO pin then the privacy LED won't work.
-	 * We've never seen that situation, but it's possible. Warn the user so
-	 * it's clear what's happened.
-	 */
-	if (int3472->clock.ena_gpio) {
-		ret = skl_int3472_register_clock(int3472);
-		if (ret)
-			return ret;
-	} else {
-		if (int3472->clock.led_gpio)
-			dev_warn(int3472->dev,
-				 "No clk GPIO. The privacy LED won't work\n");
-	}
-
-	int3472->gpios.dev_id = int3472->sensor_name;
-	gpiod_add_lookup_table(&int3472->gpios);
-
-	return 0;
-}
-
-int skl_int3472_discrete_probe(struct platform_device *pdev)
-{
-	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
-	struct int3472_discrete_device *int3472;
-	struct int3472_cldb cldb;
-	int ret;
-
-	ret = skl_int3472_fill_cldb(adev, &cldb);
-	if (ret) {
-		dev_err(&pdev->dev, "Couldn't fill CLDB structure\n");
-		return ret;
-	}
-
-	if (cldb.control_logic_type != 1) {
-		dev_err(&pdev->dev, "Unsupported control logic type %u\n",
-			cldb.control_logic_type);
-		return -EINVAL;
-	}
-
-	/* Max num GPIOs we've seen plus a terminator */
-	int3472 = devm_kzalloc(&pdev->dev, struct_size(int3472, gpios.table,
-			       INT3472_MAX_SENSOR_GPIOS + 1), GFP_KERNEL);
-	if (!int3472)
-		return -ENOMEM;
-
-	int3472->adev = adev;
-	int3472->dev = &pdev->dev;
-	platform_set_drvdata(pdev, int3472);
-
-	int3472->sensor = acpi_dev_get_first_consumer_dev(adev);
-	if (!int3472->sensor) {
-		dev_err(&pdev->dev, "INT3472 seems to have no dependents.\n");
-		return -ENODEV;
-	}
-
-	int3472->sensor_name = devm_kasprintf(int3472->dev, GFP_KERNEL,
-					      I2C_DEV_NAME_FORMAT,
-					      acpi_dev_name(int3472->sensor));
-	if (!int3472->sensor_name) {
-		ret = -ENOMEM;
-		goto err_put_sensor;
-	}
-
-	/*
-	 * Initialising this list means we can call gpiod_remove_lookup_table()
-	 * in failure paths without issue.
-	 */
-	INIT_LIST_HEAD(&int3472->gpios.list);
-
-	ret = skl_int3472_parse_crs(int3472);
-	if (ret) {
-		skl_int3472_discrete_remove(pdev);
-		return ret;
-	}
-
-	return 0;
-
-err_put_sensor:
-	acpi_dev_put(int3472->sensor);
-
-	return ret;
-}
-
-int skl_int3472_discrete_remove(struct platform_device *pdev)
-{
-	struct int3472_discrete_device *int3472 = platform_get_drvdata(pdev);
-
-	gpiod_remove_lookup_table(&int3472->gpios);
-
-	if (int3472->clock.cl)
-		skl_int3472_unregister_clock(int3472);
-
-	gpiod_put(int3472->clock.ena_gpio);
-	gpiod_put(int3472->clock.led_gpio);
-
-	skl_int3472_unregister_regulator(int3472);
-
-	return 0;
-}
diff --git a/drivers/platform/x86/intel/int3472/intel_skl_int3472_tps68470.c b/drivers/platform/x86/intel/int3472/intel_skl_int3472_tps68470.c
deleted file mode 100644
index c05b4cf502fe..000000000000
--- a/drivers/platform/x86/intel/int3472/intel_skl_int3472_tps68470.c
+++ /dev/null
@@ -1,137 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Author: Dan Scally <djrscally@gmail.com> */
-
-#include <linux/i2c.h>
-#include <linux/mfd/core.h>
-#include <linux/mfd/tps68470.h>
-#include <linux/platform_device.h>
-#include <linux/regmap.h>
-
-#include "intel_skl_int3472_common.h"
-
-#define DESIGNED_FOR_CHROMEOS		1
-#define DESIGNED_FOR_WINDOWS		2
-
-static const struct mfd_cell tps68470_cros[] = {
-	{ .name = "tps68470-gpio" },
-	{ .name = "tps68470_pmic_opregion" },
-};
-
-static const struct mfd_cell tps68470_win[] = {
-	{ .name = "tps68470-gpio" },
-	{ .name = "tps68470-clk" },
-	{ .name = "tps68470-regulator" },
-};
-
-static const struct regmap_config tps68470_regmap_config = {
-	.reg_bits = 8,
-	.val_bits = 8,
-	.max_register = TPS68470_REG_MAX,
-};
-
-static int tps68470_chip_init(struct device *dev, struct regmap *regmap)
-{
-	unsigned int version;
-	int ret;
-
-	/* Force software reset */
-	ret = regmap_write(regmap, TPS68470_REG_RESET, TPS68470_REG_RESET_MASK);
-	if (ret)
-		return ret;
-
-	ret = regmap_read(regmap, TPS68470_REG_REVID, &version);
-	if (ret) {
-		dev_err(dev, "Failed to read revision register: %d\n", ret);
-		return ret;
-	}
-
-	dev_info(dev, "TPS68470 REVID: 0x%02x\n", version);
-
-	return 0;
-}
-
-/** skl_int3472_tps68470_calc_type: Check what platform a device is designed for
- * @adev: A pointer to a &struct acpi_device
- *
- * Check CLDB buffer against the PMIC's adev. If present, then we check
- * the value of control_logic_type field and follow one of the
- * following scenarios:
- *
- *	1. No CLDB - likely ACPI tables designed for ChromeOS. We
- *	create platform devices for the GPIOs and OpRegion drivers.
- *
- *	2. CLDB, with control_logic_type = 2 - probably ACPI tables
- *	made for Windows 2-in-1 platforms. Register pdevs for GPIO,
- *	Clock and Regulator drivers to bind to.
- *
- *	3. Any other value in control_logic_type, we should never have
- *	gotten to this point; fail probe and return.
- *
- * Return:
- * * 1		Device intended for ChromeOS
- * * 2		Device intended for Windows
- * * -EINVAL	Where @adev has an object named CLDB but it does not conform to
- *		our expectations
- */
-static int skl_int3472_tps68470_calc_type(struct acpi_device *adev)
-{
-	struct int3472_cldb cldb = { 0 };
-	int ret;
-
-	/*
-	 * A CLDB buffer that exists, but which does not match our expectations
-	 * should trigger an error so we don't blindly continue.
-	 */
-	ret = skl_int3472_fill_cldb(adev, &cldb);
-	if (ret && ret != -ENODEV)
-		return ret;
-
-	if (ret)
-		return DESIGNED_FOR_CHROMEOS;
-
-	if (cldb.control_logic_type != 2)
-		return -EINVAL;
-
-	return DESIGNED_FOR_WINDOWS;
-}
-
-int skl_int3472_tps68470_probe(struct i2c_client *client)
-{
-	struct acpi_device *adev = ACPI_COMPANION(&client->dev);
-	struct regmap *regmap;
-	int device_type;
-	int ret;
-
-	regmap = devm_regmap_init_i2c(client, &tps68470_regmap_config);
-	if (IS_ERR(regmap)) {
-		dev_err(&client->dev, "Failed to create regmap: %ld\n", PTR_ERR(regmap));
-		return PTR_ERR(regmap);
-	}
-
-	i2c_set_clientdata(client, regmap);
-
-	ret = tps68470_chip_init(&client->dev, regmap);
-	if (ret < 0) {
-		dev_err(&client->dev, "TPS68470 init error %d\n", ret);
-		return ret;
-	}
-
-	device_type = skl_int3472_tps68470_calc_type(adev);
-	switch (device_type) {
-	case DESIGNED_FOR_WINDOWS:
-		ret = devm_mfd_add_devices(&client->dev, PLATFORM_DEVID_NONE,
-					   tps68470_win, ARRAY_SIZE(tps68470_win),
-					   NULL, 0, NULL);
-		break;
-	case DESIGNED_FOR_CHROMEOS:
-		ret = devm_mfd_add_devices(&client->dev, PLATFORM_DEVID_NONE,
-					   tps68470_cros, ARRAY_SIZE(tps68470_cros),
-					   NULL, 0, NULL);
-		break;
-	default:
-		dev_err(&client->dev, "Failed to add MFD devices\n");
-		return device_type;
-	}
-
-	return ret;
-}
diff --git a/drivers/platform/x86/intel/int3472/tps68470.c b/drivers/platform/x86/intel/int3472/tps68470.c
new file mode 100644
index 000000000000..fd3bef449137
--- /dev/null
+++ b/drivers/platform/x86/intel/int3472/tps68470.c
@@ -0,0 +1,156 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Author: Dan Scally <djrscally@gmail.com> */
+
+#include <linux/i2c.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/tps68470.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+
+#include "common.h"
+
+#define DESIGNED_FOR_CHROMEOS		1
+#define DESIGNED_FOR_WINDOWS		2
+
+static const struct mfd_cell tps68470_cros[] = {
+	{ .name = "tps68470-gpio" },
+	{ .name = "tps68470_pmic_opregion" },
+};
+
+static const struct mfd_cell tps68470_win[] = {
+	{ .name = "tps68470-gpio" },
+	{ .name = "tps68470-clk" },
+	{ .name = "tps68470-regulator" },
+};
+
+static const struct regmap_config tps68470_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = TPS68470_REG_MAX,
+};
+
+static int tps68470_chip_init(struct device *dev, struct regmap *regmap)
+{
+	unsigned int version;
+	int ret;
+
+	/* Force software reset */
+	ret = regmap_write(regmap, TPS68470_REG_RESET, TPS68470_REG_RESET_MASK);
+	if (ret)
+		return ret;
+
+	ret = regmap_read(regmap, TPS68470_REG_REVID, &version);
+	if (ret) {
+		dev_err(dev, "Failed to read revision register: %d\n", ret);
+		return ret;
+	}
+
+	dev_info(dev, "TPS68470 REVID: 0x%02x\n", version);
+
+	return 0;
+}
+
+/** skl_int3472_tps68470_calc_type: Check what platform a device is designed for
+ * @adev: A pointer to a &struct acpi_device
+ *
+ * Check CLDB buffer against the PMIC's adev. If present, then we check
+ * the value of control_logic_type field and follow one of the
+ * following scenarios:
+ *
+ *	1. No CLDB - likely ACPI tables designed for ChromeOS. We
+ *	create platform devices for the GPIOs and OpRegion drivers.
+ *
+ *	2. CLDB, with control_logic_type = 2 - probably ACPI tables
+ *	made for Windows 2-in-1 platforms. Register pdevs for GPIO,
+ *	Clock and Regulator drivers to bind to.
+ *
+ *	3. Any other value in control_logic_type, we should never have
+ *	gotten to this point; fail probe and return.
+ *
+ * Return:
+ * * 1		Device intended for ChromeOS
+ * * 2		Device intended for Windows
+ * * -EINVAL	Where @adev has an object named CLDB but it does not conform to
+ *		our expectations
+ */
+static int skl_int3472_tps68470_calc_type(struct acpi_device *adev)
+{
+	struct int3472_cldb cldb = { 0 };
+	int ret;
+
+	/*
+	 * A CLDB buffer that exists, but which does not match our expectations
+	 * should trigger an error so we don't blindly continue.
+	 */
+	ret = skl_int3472_fill_cldb(adev, &cldb);
+	if (ret && ret != -ENODEV)
+		return ret;
+
+	if (ret)
+		return DESIGNED_FOR_CHROMEOS;
+
+	if (cldb.control_logic_type != 2)
+		return -EINVAL;
+
+	return DESIGNED_FOR_WINDOWS;
+}
+
+static int skl_int3472_tps68470_probe(struct i2c_client *client)
+{
+	struct acpi_device *adev = ACPI_COMPANION(&client->dev);
+	struct regmap *regmap;
+	int device_type;
+	int ret;
+
+	regmap = devm_regmap_init_i2c(client, &tps68470_regmap_config);
+	if (IS_ERR(regmap)) {
+		dev_err(&client->dev, "Failed to create regmap: %ld\n", PTR_ERR(regmap));
+		return PTR_ERR(regmap);
+	}
+
+	i2c_set_clientdata(client, regmap);
+
+	ret = tps68470_chip_init(&client->dev, regmap);
+	if (ret < 0) {
+		dev_err(&client->dev, "TPS68470 init error %d\n", ret);
+		return ret;
+	}
+
+	device_type = skl_int3472_tps68470_calc_type(adev);
+	switch (device_type) {
+	case DESIGNED_FOR_WINDOWS:
+		ret = devm_mfd_add_devices(&client->dev, PLATFORM_DEVID_NONE,
+					   tps68470_win, ARRAY_SIZE(tps68470_win),
+					   NULL, 0, NULL);
+		break;
+	case DESIGNED_FOR_CHROMEOS:
+		ret = devm_mfd_add_devices(&client->dev, PLATFORM_DEVID_NONE,
+					   tps68470_cros, ARRAY_SIZE(tps68470_cros),
+					   NULL, 0, NULL);
+		break;
+	default:
+		dev_err(&client->dev, "Failed to add MFD devices\n");
+		return device_type;
+	}
+
+	return ret;
+}
+
+static const struct acpi_device_id int3472_device_id[] = {
+	{ "INT3472", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(acpi, int3472_device_id);
+
+static struct i2c_driver int3472_tps68470 = {
+	.driver = {
+		.name = "int3472-tps68470",
+		.acpi_match_table = int3472_device_id,
+	},
+	.probe_new = skl_int3472_tps68470_probe,
+};
+module_i2c_driver(int3472_tps68470);
+
+MODULE_DESCRIPTION("Intel SkyLake INT3472 ACPI TPS68470 Device Driver");
+MODULE_AUTHOR("Daniel Scally <djrscally@gmail.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index c9ed2644bb8a..76f0d04e17f3 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -504,7 +504,7 @@ static ssize_t display_name_show(struct kobject *kobj, struct kobj_attribute *at
 static ssize_t current_value_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
 	struct tlmi_attr_setting *setting = to_tlmi_attr_setting(kobj);
-	char *item, *value;
+	char *item, *value, *p;
 	int ret;
 
 	ret = tlmi_setting(setting->index, &item, LENOVO_BIOS_SETTING_GUID);
@@ -514,10 +514,15 @@ static ssize_t current_value_show(struct kobject *kobj, struct kobj_attribute *a
 	/* validate and split from `item,value` -> `value` */
 	value = strpbrk(item, ",");
 	if (!value || value == item || !strlen(value + 1))
-		return -EINVAL;
-
-	ret = sysfs_emit(buf, "%s\n", value + 1);
+		ret = -EINVAL;
+	else {
+		/* On Workstations remove the Options part after the value */
+		p = strchrnul(value, ';');
+		*p = '\0';
+		ret = sysfs_emit(buf, "%s\n", value + 1);
+	}
 	kfree(item);
+
 	return ret;
 }
 
@@ -950,10 +955,10 @@ static int tlmi_analyze(void)
 			 * name string.
 			 * Try and pull that out if it's available.
 			 */
-			char *item, *optstart, *optend;
+			char *optitem, *optstart, *optend;
 
-			if (!tlmi_setting(setting->index, &item, LENOVO_BIOS_SETTING_GUID)) {
-				optstart = strstr(item, "[Optional:");
+			if (!tlmi_setting(setting->index, &optitem, LENOVO_BIOS_SETTING_GUID)) {
+				optstart = strstr(optitem, "[Optional:");
 				if (optstart) {
 					optstart += strlen("[Optional:");
 					optend = strstr(optstart, "]");
@@ -962,6 +967,7 @@ static int tlmi_analyze(void)
 							kstrndup(optstart, optend - optstart,
 									GFP_KERNEL);
 				}
+				kfree(optitem);
 			}
 		}
 		/*
diff --git a/drivers/pwm/pwm-cros-ec.c b/drivers/pwm/pwm-cros-ec.c
index 5e29d9c682c3..adfd03c11e18 100644
--- a/drivers/pwm/pwm-cros-ec.c
+++ b/drivers/pwm/pwm-cros-ec.c
@@ -157,6 +157,7 @@ static void cros_ec_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	state->enabled = (ret > 0);
 	state->period = EC_PWM_MAX_DUTY;
+	state->polarity = PWM_POLARITY_NORMAL;
 
 	/*
 	 * Note that "disabled" and "duty cycle == 0" are treated the same. If
diff --git a/drivers/pwm/pwm-sprd.c b/drivers/pwm/pwm-sprd.c
index 7004f55bbf11..869e696a503f 100644
--- a/drivers/pwm/pwm-sprd.c
+++ b/drivers/pwm/pwm-sprd.c
@@ -109,6 +109,7 @@ static void sprd_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 	duty = val & SPRD_PWM_DUTY_MSK;
 	tmp = (prescale + 1) * NSEC_PER_SEC * duty;
 	state->duty_cycle = DIV_ROUND_CLOSEST_ULL(tmp, chn->clk_rate);
+	state->polarity = PWM_POLARITY_NORMAL;
 
 	/* Disable PWM clocks if the PWM channel is not in enable state. */
 	if (!state->enabled)
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 594336004190..fe705b8bf464 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -767,13 +767,12 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi_cls_conn *cls_conn,
 		iscsi_set_param(cls_conn, param, buf, buflen);
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
-		iscsi_set_param(cls_conn, param, buf, buflen);
-
 		mutex_lock(&tcp_sw_conn->sock_lock);
 		if (!tcp_sw_conn->sock) {
 			mutex_unlock(&tcp_sw_conn->sock_lock);
 			return -ENOTCONN;
 		}
+		iscsi_set_param(cls_conn, param, buf, buflen);
 		tcp_sw_conn->sendpage = conn->datadgst_en ?
 			sock_no_sendpage : tcp_sw_conn->sock->ops->sendpage;
 		mutex_unlock(&tcp_sw_conn->sock_lock);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6063f4855808..2efe31327ed1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3573,6 +3573,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 probe_failed:
 	qla_enode_stop(base_vha);
 	qla_edb_stop(base_vha);
+	vfree(base_vha->scan.l);
 	if (base_vha->gnl.l) {
 		dma_free_coherent(&ha->pdev->dev, base_vha->gnl.size,
 				base_vha->gnl.l, base_vha->gnl.ldma);
diff --git a/drivers/tty/serial/8250/8250_exar.c b/drivers/tty/serial/8250/8250_exar.c
index d502240bbcf2..c767636d9bb0 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -43,6 +43,12 @@
 #define PCI_DEVICE_ID_EXAR_XR17V4358		0x4358
 #define PCI_DEVICE_ID_EXAR_XR17V8358		0x8358
 
+#define PCI_DEVICE_ID_SEALEVEL_710xC		0x1001
+#define PCI_DEVICE_ID_SEALEVEL_720xC		0x1002
+#define PCI_DEVICE_ID_SEALEVEL_740xC		0x1004
+#define PCI_DEVICE_ID_SEALEVEL_780xC		0x1008
+#define PCI_DEVICE_ID_SEALEVEL_716xC		0x1010
+
 #define UART_EXAR_INT0		0x80
 #define UART_EXAR_8XMODE	0x88	/* 8X sampling rate select */
 #define UART_EXAR_SLEEP		0x8b	/* Sleep mode */
@@ -623,7 +629,14 @@ exar_pci_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 
 	maxnr = pci_resource_len(pcidev, bar) >> (board->reg_shift + 3);
 
-	nr_ports = board->num_ports ? board->num_ports : pcidev->device & 0x0f;
+	if (pcidev->vendor == PCI_VENDOR_ID_ACCESSIO)
+		nr_ports = BIT(((pcidev->device & 0x38) >> 3) - 1);
+	else if (board->num_ports)
+		nr_ports = board->num_ports;
+	else if (pcidev->vendor == PCI_VENDOR_ID_SEALEVEL)
+		nr_ports = pcidev->device & 0xff;
+	else
+		nr_ports = pcidev->device & 0x0f;
 
 	priv = devm_kzalloc(&pcidev->dev, struct_size(priv, line, nr_ports), GFP_KERNEL);
 	if (!priv)
@@ -722,22 +735,6 @@ static int __maybe_unused exar_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(exar_pci_pm, exar_suspend, exar_resume);
 
-static const struct exar8250_board acces_com_2x = {
-	.num_ports	= 2,
-	.setup		= pci_xr17c154_setup,
-};
-
-static const struct exar8250_board acces_com_4x = {
-	.num_ports	= 4,
-	.setup		= pci_xr17c154_setup,
-};
-
-static const struct exar8250_board acces_com_8x = {
-	.num_ports	= 8,
-	.setup		= pci_xr17c154_setup,
-};
-
-
 static const struct exar8250_board pbn_fastcom335_2 = {
 	.num_ports	= 2,
 	.setup		= pci_fastcom335_setup,
@@ -822,13 +819,13 @@ static const struct exar8250_board pbn_exar_XR17V8358 = {
 	}
 
 static const struct pci_device_id exar_pci_tbl[] = {
-	EXAR_DEVICE(ACCESSIO, COM_2S, acces_com_2x),
-	EXAR_DEVICE(ACCESSIO, COM_4S, acces_com_4x),
-	EXAR_DEVICE(ACCESSIO, COM_8S, acces_com_8x),
-	EXAR_DEVICE(ACCESSIO, COM232_8, acces_com_8x),
-	EXAR_DEVICE(ACCESSIO, COM_2SM, acces_com_2x),
-	EXAR_DEVICE(ACCESSIO, COM_4SM, acces_com_4x),
-	EXAR_DEVICE(ACCESSIO, COM_8SM, acces_com_8x),
+	EXAR_DEVICE(ACCESSIO, COM_2S, pbn_exar_XR17C15x),
+	EXAR_DEVICE(ACCESSIO, COM_4S, pbn_exar_XR17C15x),
+	EXAR_DEVICE(ACCESSIO, COM_8S, pbn_exar_XR17C15x),
+	EXAR_DEVICE(ACCESSIO, COM232_8, pbn_exar_XR17C15x),
+	EXAR_DEVICE(ACCESSIO, COM_2SM, pbn_exar_XR17C15x),
+	EXAR_DEVICE(ACCESSIO, COM_4SM, pbn_exar_XR17C15x),
+	EXAR_DEVICE(ACCESSIO, COM_8SM, pbn_exar_XR17C15x),
 
 	CONNECT_DEVICE(XR17C152, UART_2_232, pbn_connect),
 	CONNECT_DEVICE(XR17C154, UART_4_232, pbn_connect),
@@ -864,6 +861,12 @@ static const struct pci_device_id exar_pci_tbl[] = {
 	EXAR_DEVICE(COMMTECH, 4224PCI335, pbn_fastcom335_4),
 	EXAR_DEVICE(COMMTECH, 2324PCI335, pbn_fastcom335_4),
 	EXAR_DEVICE(COMMTECH, 2328PCI335, pbn_fastcom335_8),
+
+	EXAR_DEVICE(SEALEVEL, 710xC, pbn_exar_XR17V35x),
+	EXAR_DEVICE(SEALEVEL, 720xC, pbn_exar_XR17V35x),
+	EXAR_DEVICE(SEALEVEL, 740xC, pbn_exar_XR17V35x),
+	EXAR_DEVICE(SEALEVEL, 780xC, pbn_exar_XR17V35x),
+	EXAR_DEVICE(SEALEVEL, 716xC, pbn_exar_XR17V35x),
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, exar_pci_tbl);
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index ac3c6c1e80cc..5cabc3c85eb1 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -829,11 +829,17 @@ static unsigned int lpuart32_tx_empty(struct uart_port *port)
 			struct lpuart_port, port);
 	unsigned long stat = lpuart32_read(port, UARTSTAT);
 	unsigned long sfifo = lpuart32_read(port, UARTFIFO);
+	unsigned long ctrl = lpuart32_read(port, UARTCTRL);
 
 	if (sport->dma_tx_in_progress)
 		return 0;
 
-	if (stat & UARTSTAT_TC && sfifo & UARTFIFO_TXEMPT)
+	/*
+	 * LPUART Transmission Complete Flag may never be set while queuing a break
+	 * character, so avoid checking for transmission complete when UARTCTRL_SBK
+	 * is asserted.
+	 */
+	if ((stat & UARTSTAT_TC && sfifo & UARTFIFO_TXEMPT) || ctrl & UARTCTRL_SBK)
 		return TIOCSER_TEMT;
 
 	return 0;
diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index c5c0f39cb1c7..25318176091b 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -31,6 +31,7 @@
 #include <linux/ioport.h>
 #include <linux/ktime.h>
 #include <linux/major.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/of.h>
@@ -2895,6 +2896,13 @@ static int sci_init_single(struct platform_device *dev,
 			sci_port->irqs[i] = platform_get_irq(dev, i);
 	}
 
+	/*
+	 * The fourth interrupt on SCI port is transmit end interrupt, so
+	 * shuffle the interrupts.
+	 */
+	if (p->type == PORT_SCI)
+		swap(sci_port->irqs[SCIx_BRI_IRQ], sci_port->irqs[SCIx_TEI_IRQ]);
+
 	/* The SCI generates several interrupts. They can be muxed together or
 	 * connected to different interrupt lines. In the muxed case only one
 	 * interrupt resource is specified as there is only one interrupt ID.
@@ -2960,7 +2968,7 @@ static int sci_init_single(struct platform_device *dev,
 	port->flags		= UPF_FIXED_PORT | UPF_BOOT_AUTOCONF | p->flags;
 	port->fifosize		= sci_port->params->fifosize;
 
-	if (port->type == PORT_SCI) {
+	if (port->type == PORT_SCI && !dev->dev.of_node) {
 		if (sci_port->reg_size >= 0x20)
 			port->regshift = 2;
 		else
diff --git a/drivers/usb/cdns3/cdnsp-ep0.c b/drivers/usb/cdns3/cdnsp-ep0.c
index d63d5d92f255..f317d3c84781 100644
--- a/drivers/usb/cdns3/cdnsp-ep0.c
+++ b/drivers/usb/cdns3/cdnsp-ep0.c
@@ -414,7 +414,7 @@ static int cdnsp_ep0_std_request(struct cdnsp_device *pdev,
 void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 {
 	struct usb_ctrlrequest *ctrl = &pdev->setup;
-	int ret = 0;
+	int ret = -EINVAL;
 	u16 len;
 
 	trace_cdnsp_ctrl_req(ctrl);
@@ -424,7 +424,6 @@ void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 
 	if (pdev->gadget.state == USB_STATE_NOTATTACHED) {
 		dev_err(pdev->dev, "ERR: Setup detected in unattached state\n");
-		ret = -EINVAL;
 		goto out;
 	}
 
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 46ef3ae9c0dd..4bcfcb98f5ec 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -47,6 +47,7 @@
 #define PCI_DEVICE_ID_INTEL_RPLS		0x7a61
 #define PCI_DEVICE_ID_INTEL_MTLM		0x7eb1
 #define PCI_DEVICE_ID_INTEL_MTLP		0x7ec1
+#define PCI_DEVICE_ID_INTEL_MTLS		0x7f6f
 #define PCI_DEVICE_ID_INTEL_MTL			0x7e7e
 #define PCI_DEVICE_ID_INTEL_TGL			0x9a15
 #define PCI_DEVICE_ID_AMD_MR			0x163a
@@ -434,6 +435,9 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTLP),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTLS),
+	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
+
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTL),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
index bdb776553826..32df571bb233 100644
--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1225,6 +1225,9 @@ static void tegra_xhci_id_work(struct work_struct *work)
 
 	mutex_unlock(&tegra->lock);
 
+	tegra->otg_usb3_port = tegra_xusb_padctl_get_usb3_companion(tegra->padctl,
+								    tegra->otg_usb2_port);
+
 	if (tegra->host_mode) {
 		/* switch to host mode */
 		if (tegra->otg_usb3_port >= 0) {
@@ -1339,9 +1342,6 @@ static int tegra_xhci_id_notify(struct notifier_block *nb,
 	}
 
 	tegra->otg_usb2_port = tegra_xusb_get_usb2_port(tegra, usbphy);
-	tegra->otg_usb3_port = tegra_xusb_padctl_get_usb3_companion(
-							tegra->padctl,
-							tegra->otg_usb2_port);
 
 	tegra->host_mode = (usbphy->last_event == USB_EVENT_ID) ? true : false;
 
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index a982b5346764..1fd2f6a850eb 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/pci.h>
+#include <linux/iommu.h>
 #include <linux/iopoll.h>
 #include <linux/irq.h>
 #include <linux/log2.h>
@@ -225,6 +226,7 @@ int xhci_reset(struct xhci_hcd *xhci, u64 timeout_us)
 static void xhci_zero_64b_regs(struct xhci_hcd *xhci)
 {
 	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
+	struct iommu_domain *domain;
 	int err, i;
 	u64 val;
 	u32 intrs;
@@ -243,7 +245,9 @@ static void xhci_zero_64b_regs(struct xhci_hcd *xhci)
 	 * an iommu. Doing anything when there is no iommu is definitely
 	 * unsafe...
 	 */
-	if (!(xhci->quirks & XHCI_ZERO_64B_REGS) || !device_iommu_mapped(dev))
+	domain = iommu_get_domain_for_dev(dev);
+	if (!(xhci->quirks & XHCI_ZERO_64B_REGS) || !domain ||
+	    domain->type == IOMMU_DOMAIN_IDENTITY)
 		return;
 
 	xhci_info(xhci, "Zeroing 64bit base registers, expecting fault\n");
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index fbdebf7e5502..b3f128bd4718 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -120,6 +120,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x826B) }, /* Cygnal Integrated Products, Inc., Fasttrax GPS demonstration module */
 	{ USB_DEVICE(0x10C4, 0x8281) }, /* Nanotec Plug & Drive */
 	{ USB_DEVICE(0x10C4, 0x8293) }, /* Telegesis ETRX2USB */
+	{ USB_DEVICE(0x10C4, 0x82AA) }, /* Silicon Labs IFS-USB-DATACABLE used with Quint UPS */
 	{ USB_DEVICE(0x10C4, 0x82EF) }, /* CESINEL FALCO 6105 AC Power Supply */
 	{ USB_DEVICE(0x10C4, 0x82F1) }, /* CESINEL MEDCAL EFD Earth Fault Detector */
 	{ USB_DEVICE(0x10C4, 0x82F2) }, /* CESINEL MEDCAL ST Network Analyzer */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index a8534065e0d6..fc12fee66141 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1198,6 +1198,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM520N, 0xff, 0xff, 0x30) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM520N, 0xff, 0, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM520N, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, 0x0900, 0xff, 0, 0), /* RM500U-CN */
+	  .driver_info = ZLP },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200U, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200S_CN, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200T, 0xff, 0, 0) },
@@ -1300,6 +1302,14 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1075, 0xff),	/* Telit FN990 (PCIe) */
 	  .driver_info = RSVD(0) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1080, 0xff),	/* Telit FE990 (rmnet) */
+	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1081, 0xff),	/* Telit FE990 (MBIM) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1082, 0xff),	/* Telit FE990 (RNDIS) */
+	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1083, 0xff),	/* Telit FE990 (ECM) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910_DUAL_MODEM),
diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec/altmodes/displayport.c
index c232a735a0c2..9378b44e0628 100644
--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -101,8 +101,12 @@ static int dp_altmode_configure(struct dp_altmode *dp, u8 con)
 		if (dp->data.status & DP_STATUS_PREFER_MULTI_FUNC &&
 		    pin_assign & DP_PIN_ASSIGN_MULTI_FUNC_MASK)
 			pin_assign &= DP_PIN_ASSIGN_MULTI_FUNC_MASK;
-		else if (pin_assign & DP_PIN_ASSIGN_DP_ONLY_MASK)
+		else if (pin_assign & DP_PIN_ASSIGN_DP_ONLY_MASK) {
 			pin_assign &= DP_PIN_ASSIGN_DP_ONLY_MASK;
+			/* Default to pin assign C if available */
+			if (pin_assign & BIT(DP_PIN_ASSIGN_C))
+				pin_assign = BIT(DP_PIN_ASSIGN_C);
+		}
 
 		if (!pin_assign)
 			return -EINVAL;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index fc736ced6f4a..26f87437b2dd 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -682,6 +682,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",acdirmax=%lu", cifs_sb->ctx->acdirmax / HZ);
 		seq_printf(s, ",acregmax=%lu", cifs_sb->ctx->acregmax / HZ);
 	}
+	seq_printf(s, ",closetimeo=%lu", cifs_sb->ctx->closetimeo / HZ);
 
 	if (tcon->ses->chan_max > 1)
 		seq_printf(s, ",multichannel,max_channels=%zu",
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 555bd386a24d..f6c41265fdfd 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2436,6 +2436,8 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 		return 0;
 	if (old->ctx->acdirmax != new->ctx->acdirmax)
 		return 0;
+	if (old->ctx->closetimeo != new->ctx->closetimeo)
+		return 0;
 
 	return 1;
 }
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index cca9ff01b30c..b3cf9ab50139 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -897,12 +897,12 @@ int cifs_close(struct inode *inode, struct file *file)
 				 * So, Increase the ref count to avoid use-after-free.
 				 */
 				if (!mod_delayed_work(deferredclose_wq,
-						&cfile->deferred, cifs_sb->ctx->acregmax))
+						&cfile->deferred, cifs_sb->ctx->closetimeo))
 					cifsFileInfo_get(cfile);
 			} else {
 				/* Deferred close for files */
 				queue_delayed_work(deferredclose_wq,
-						&cfile->deferred, cifs_sb->ctx->acregmax);
+						&cfile->deferred, cifs_sb->ctx->closetimeo);
 				cfile->deferred_close_scheduled = true;
 				spin_unlock(&cinode->deferred_lock);
 				return 0;
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 3b8ed36b3711..8455db6a26f5 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -143,6 +143,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_u32("actimeo", Opt_actimeo),
 	fsparam_u32("acdirmax", Opt_acdirmax),
 	fsparam_u32("acregmax", Opt_acregmax),
+	fsparam_u32("closetimeo", Opt_closetimeo),
 	fsparam_u32("echo_interval", Opt_echo_interval),
 	fsparam_u32("max_credits", Opt_max_credits),
 	fsparam_u32("handletimeout", Opt_handletimeout),
@@ -436,13 +437,14 @@ int smb3_parse_opt(const char *options, const char *key, char **val)
  * but there are some bugs that prevent rename from working if there are
  * multiple delimiters.
  *
- * Returns a sanitized duplicate of @path. The caller is responsible for
- * cleaning up the original.
+ * Returns a sanitized duplicate of @path. @gfp indicates the GFP_* flags
+ * for kstrdup.
+ * The caller is responsible for freeing the original.
  */
 #define IS_DELIM(c) ((c) == '/' || (c) == '\\')
-static char *sanitize_path(char *path)
+char *cifs_sanitize_prepath(char *prepath, gfp_t gfp)
 {
-	char *cursor1 = path, *cursor2 = path;
+	char *cursor1 = prepath, *cursor2 = prepath;
 
 	/* skip all prepended delimiters */
 	while (IS_DELIM(*cursor1))
@@ -464,7 +466,7 @@ static char *sanitize_path(char *path)
 		cursor2--;
 
 	*(cursor2) = '\0';
-	return kstrdup(path, GFP_KERNEL);
+	return kstrdup(prepath, gfp);
 }
 
 /*
@@ -526,7 +528,7 @@ smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx)
 	if (!*pos)
 		return 0;
 
-	ctx->prepath = sanitize_path(pos);
+	ctx->prepath = cifs_sanitize_prepath(pos, GFP_KERNEL);
 	if (!ctx->prepath)
 		return -ENOMEM;
 
@@ -1058,6 +1060,13 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		}
 		ctx->acdirmax = ctx->acregmax = HZ * result.uint_32;
 		break;
+	case Opt_closetimeo:
+		ctx->closetimeo = HZ * result.uint_32;
+		if (ctx->closetimeo > SMB3_MAX_DCLOSETIMEO) {
+			cifs_errorf(fc, "closetimeo too large\n");
+			goto cifs_parse_mount_err;
+		}
+		break;
 	case Opt_echo_interval:
 		ctx->echo_interval = result.uint_32;
 		break;
@@ -1496,6 +1505,7 @@ int smb3_init_fs_context(struct fs_context *fc)
 
 	ctx->acregmax = CIFS_DEF_ACTIMEO;
 	ctx->acdirmax = CIFS_DEF_ACTIMEO;
+	ctx->closetimeo = SMB3_DEF_DCLOSETIMEO;
 
 	/* Most clients set timeout to 0, allows server to use its default */
 	ctx->handle_timeout = 0; /* See MS-SMB2 spec section 2.2.14.2.12 */
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index 29601a4eb411..3cf8d6235162 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -123,6 +123,7 @@ enum cifs_param {
 	Opt_actimeo,
 	Opt_acdirmax,
 	Opt_acregmax,
+	Opt_closetimeo,
 	Opt_echo_interval,
 	Opt_max_credits,
 	Opt_snapshot,
@@ -243,6 +244,8 @@ struct smb3_fs_context {
 	/* attribute cache timemout for files and directories in jiffies */
 	unsigned long acregmax;
 	unsigned long acdirmax;
+	/* timeout for deferred close of files in jiffies */
+	unsigned long closetimeo;
 	struct smb_version_operations *ops;
 	struct smb_version_values *vals;
 	char *prepath;
@@ -275,4 +278,12 @@ static inline struct smb3_fs_context *smb3_fc2context(const struct fs_context *f
 extern int smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx);
 extern void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
 
+/*
+ * max deferred close timeout (jiffies) - 2^30
+ */
+#define SMB3_MAX_DCLOSETIMEO (1 << 30)
+#define SMB3_DEF_DCLOSETIMEO (1 * HZ) /* even 1 sec enough to help eg open/write/close/open/read */
+
+extern char *cifs_sanitize_prepath(char *prepath, gfp_t gfp);
+
 #endif
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 3a90ee314ed7..300f5f382e43 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1301,7 +1301,7 @@ int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix)
 	kfree(cifs_sb->prepath);
 
 	if (prefix && *prefix) {
-		cifs_sb->prepath = kstrdup(prefix, GFP_ATOMIC);
+		cifs_sb->prepath = cifs_sanitize_prepath(prefix, GFP_ATOMIC);
 		if (!cifs_sb->prepath)
 			return -ENOMEM;
 
diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 610abaadbb67..21cda82f156d 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -320,10 +320,7 @@ int ksmbd_conn_handler_loop(void *p)
 
 		/* 4 for rfc1002 length field */
 		size = pdu_size + 4;
-		conn->request_buf = kvmalloc(size,
-					     GFP_KERNEL |
-					     __GFP_NOWARN |
-					     __GFP_NORETRY);
+		conn->request_buf = kvmalloc(size, GFP_KERNEL);
 		if (!conn->request_buf)
 			break;
 
diff --git a/fs/namespace.c b/fs/namespace.c
index c9b2983ae011..1a9df6afb90b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4121,9 +4121,9 @@ static int do_mount_setattr(struct path *path, struct mount_kattr *kattr)
 	unlock_mount_hash();
 
 	if (kattr->propagation) {
-		namespace_unlock();
 		if (err)
 			cleanup_group_ids(mnt, NULL);
+		namespace_unlock();
 	}
 
 	return err;
diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 2e0040d3bca7..97f517e9b418 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -875,8 +875,8 @@ static const struct cred *get_backchannel_cred(struct nfs4_client *clp, struct r
 		if (!kcred)
 			return NULL;
 
-		kcred->uid = ses->se_cb_sec.uid;
-		kcred->gid = ses->se_cb_sec.gid;
+		kcred->fsuid = ses->se_cb_sec.uid;
+		kcred->fsgid = ses->se_cb_sec.gid;
 		return kcred;
 	}
 }
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index b817d24d25a6..3eb500adcda2 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1513,7 +1513,8 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 	u64 bytes_total = copy->cp_count;
 	u64 src_pos = copy->cp_src_pos;
 	u64 dst_pos = copy->cp_dst_pos;
-	__be32 status;
+	int status;
+	loff_t end;
 
 	/* See RFC 7862 p.67: */
 	if (bytes_total == 0)
@@ -1533,8 +1534,8 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 	/* for a non-zero asynchronous copy do a commit of data */
 	if (!copy->cp_synchronous && copy->cp_res.wr_bytes_written > 0) {
 		since = READ_ONCE(dst->f_wb_err);
-		status = vfs_fsync_range(dst, copy->cp_dst_pos,
-					 copy->cp_res.wr_bytes_written, 0);
+		end = copy->cp_dst_pos + copy->cp_res.wr_bytes_written - 1;
+		status = vfs_fsync_range(dst, copy->cp_dst_pos, end, 0);
 		if (!status)
 			status = filemap_check_wb_err(dst->f_mapping, since);
 		if (!status)
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index dfd3877fdd81..0394dd60a0b4 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2370,10 +2370,12 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 	for (i = 0; i < argp->opcnt; i++) {
 		op = &argp->ops[i];
 		op->replay = NULL;
+		op->opdesc = NULL;
 
 		if (xdr_stream_decode_u32(argp->xdr, &op->opnum) < 0)
 			return 0;
 		if (nfsd4_opnum_in_range(argp, op)) {
+			op->opdesc = OPDESC(op);
 			op->status = nfsd4_dec_ops[op->opnum](argp, &op->u);
 			if (op->status != nfs_ok)
 				trace_nfsd_compound_decode_err(argp->rqstp,
@@ -2384,7 +2386,7 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 			op->opnum = OP_ILLEGAL;
 			op->status = nfserr_op_illegal;
 		}
-		op->opdesc = OPDESC(op);
+
 		/*
 		 * We'll try to cache the result in the DRC if any one
 		 * op in the compound wants to be cached:
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 6d21f9bc6de1..a276a2d236ed 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2609,11 +2609,10 @@ static int nilfs_segctor_thread(void *arg)
 	goto loop;
 
  end_thread:
-	spin_unlock(&sci->sc_state_lock);
-
 	/* end sync. */
 	sci->sc_task = NULL;
 	wake_up(&sci->sc_wait_task); /* for nilfs_segctor_kill_thread() */
+	spin_unlock(&sci->sc_state_lock);
 	return 0;
 }
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index bc9690026225..9d5e4ce7426b 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -482,6 +482,7 @@ static void nilfs_put_super(struct super_block *sb)
 		up_write(&nilfs->ns_sem);
 	}
 
+	nilfs_sysfs_delete_device_group(nilfs);
 	iput(nilfs->ns_sufile);
 	iput(nilfs->ns_cpfile);
 	iput(nilfs->ns_dat);
@@ -1105,6 +1106,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 	nilfs_put_root(fsroot);
 
  failed_unload:
+	nilfs_sysfs_delete_device_group(nilfs);
 	iput(nilfs->ns_sufile);
 	iput(nilfs->ns_cpfile);
 	iput(nilfs->ns_dat);
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 1068ff40077c..0fa130362816 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -87,7 +87,6 @@ void destroy_nilfs(struct the_nilfs *nilfs)
 {
 	might_sleep();
 	if (nilfs_init(nilfs)) {
-		nilfs_sysfs_delete_device_group(nilfs);
 		brelse(nilfs->ns_sbh[0]);
 		brelse(nilfs->ns_sbh[1]);
 	}
@@ -305,6 +304,10 @@ int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 		goto failed;
 	}
 
+	err = nilfs_sysfs_create_device_group(sb);
+	if (unlikely(err))
+		goto sysfs_error;
+
 	if (valid_fs)
 		goto skip_recovery;
 
@@ -366,6 +369,9 @@ int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 	goto failed;
 
  failed_unload:
+	nilfs_sysfs_delete_device_group(nilfs);
+
+ sysfs_error:
 	iput(nilfs->ns_cpfile);
 	iput(nilfs->ns_sufile);
 	iput(nilfs->ns_dat);
@@ -697,10 +703,6 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 	if (err)
 		goto failed_sbh;
 
-	err = nilfs_sysfs_create_device_group(sb);
-	if (err)
-		goto failed_sbh;
-
 	set_nilfs_init(nilfs);
 	err = 0;
  out:
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 801e60bab955..c28bc983a7b1 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3403,10 +3403,12 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
 	ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
 	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
 
-	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
-	osb->cconn = NULL;
+	if (osb->cconn) {
+		ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
+		osb->cconn = NULL;
 
-	ocfs2_dlm_shutdown_debug(osb);
+		ocfs2_dlm_shutdown_debug(osb);
+	}
 }
 
 static int ocfs2_drop_lock(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 4f15750aac5d..86864a90de2c 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -157,7 +157,7 @@ static void ocfs2_queue_replay_slots(struct ocfs2_super *osb,
 	replay_map->rm_state = REPLAY_DONE;
 }
 
-static void ocfs2_free_replay_slots(struct ocfs2_super *osb)
+void ocfs2_free_replay_slots(struct ocfs2_super *osb)
 {
 	struct ocfs2_replay_map *replay_map = osb->replay_map;
 
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index d158acb8b38a..a54f20bce9fe 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -150,6 +150,7 @@ int ocfs2_recovery_init(struct ocfs2_super *osb);
 void ocfs2_recovery_exit(struct ocfs2_super *osb);
 
 int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
+void ocfs2_free_replay_slots(struct ocfs2_super *osb);
 /*
  *  Journal Control:
  *  Initialize, Load, Shutdown, Wipe a journal.
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index a03f0cabff0b..64e8a24e8239 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -980,28 +980,27 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
 		status = -EINVAL;
-		goto read_super_error;
+		goto out;
 	}
 
 	/* probe for superblock */
 	status = ocfs2_sb_probe(sb, &bh, &sector_size, &stats);
 	if (status < 0) {
 		mlog(ML_ERROR, "superblock probe failed!\n");
-		goto read_super_error;
+		goto out;
 	}
 
 	status = ocfs2_initialize_super(sb, bh, sector_size, &stats);
-	osb = OCFS2_SB(sb);
-	if (status < 0) {
-		mlog_errno(status);
-		goto read_super_error;
-	}
 	brelse(bh);
 	bh = NULL;
+	if (status < 0)
+		goto out;
+
+	osb = OCFS2_SB(sb);
 
 	if (!ocfs2_check_set_options(sb, &parsed_options)) {
 		status = -EINVAL;
-		goto read_super_error;
+		goto out_super;
 	}
 	osb->s_mount_opt = parsed_options.mount_opt;
 	osb->s_atime_quantum = parsed_options.atime_quantum;
@@ -1018,7 +1017,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
 	if (status)
-		goto read_super_error;
+		goto out_super;
 
 	sb->s_magic = OCFS2_SUPER_MAGIC;
 
@@ -1032,7 +1031,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 			status = -EACCES;
 			mlog(ML_ERROR, "Readonly device detected but readonly "
 			     "mount was not specified.\n");
-			goto read_super_error;
+			goto out_super;
 		}
 
 		/* You should not be able to start a local heartbeat
@@ -1041,7 +1040,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 			status = -EROFS;
 			mlog(ML_ERROR, "Local heartbeat specified on readonly "
 			     "device.\n");
-			goto read_super_error;
+			goto out_super;
 		}
 
 		status = ocfs2_check_journals_nolocks(osb);
@@ -1050,9 +1049,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 				mlog(ML_ERROR, "Recovery required on readonly "
 				     "file system, but write access is "
 				     "unavailable.\n");
-			else
-				mlog_errno(status);
-			goto read_super_error;
+			goto out_super;
 		}
 
 		ocfs2_set_ro_flag(osb, 1);
@@ -1068,10 +1065,8 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	status = ocfs2_verify_heartbeat(osb);
-	if (status < 0) {
-		mlog_errno(status);
-		goto read_super_error;
-	}
+	if (status < 0)
+		goto out_super;
 
 	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
 						 ocfs2_debugfs_root);
@@ -1085,15 +1080,14 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	status = ocfs2_mount_volume(sb);
 	if (status < 0)
-		goto read_super_error;
+		goto out_debugfs;
 
 	if (osb->root_inode)
 		inode = igrab(osb->root_inode);
 
 	if (!inode) {
 		status = -EIO;
-		mlog_errno(status);
-		goto read_super_error;
+		goto out_dismount;
 	}
 
 	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
@@ -1101,7 +1095,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	if (!osb->osb_dev_kset) {
 		status = -ENOMEM;
 		mlog(ML_ERROR, "Unable to create device kset %s.\n", sb->s_id);
-		goto read_super_error;
+		goto out_dismount;
 	}
 
 	/* Create filecheck sysfs related directories/files at
@@ -1110,14 +1104,13 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 		status = -ENOMEM;
 		mlog(ML_ERROR, "Unable to create filecheck sysfs directory at "
 			"/sys/fs/ocfs2/%s/filecheck.\n", sb->s_id);
-		goto read_super_error;
+		goto out_dismount;
 	}
 
 	root = d_make_root(inode);
 	if (!root) {
 		status = -ENOMEM;
-		mlog_errno(status);
-		goto read_super_error;
+		goto out_dismount;
 	}
 
 	sb->s_root = root;
@@ -1164,17 +1157,22 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	return status;
 
-read_super_error:
-	brelse(bh);
-
-	if (status)
-		mlog_errno(status);
+out_dismount:
+	atomic_set(&osb->vol_state, VOLUME_DISABLED);
+	wake_up(&osb->osb_mount_event);
+	ocfs2_free_replay_slots(osb);
+	ocfs2_dismount_volume(sb, 1);
+	goto out;
 
-	if (osb) {
-		atomic_set(&osb->vol_state, VOLUME_DISABLED);
-		wake_up(&osb->osb_mount_event);
-		ocfs2_dismount_volume(sb, 1);
-	}
+out_debugfs:
+	debugfs_remove_recursive(osb->osb_debug_root);
+out_super:
+	ocfs2_release_system_inodes(osb);
+	kfree(osb->recovery_map);
+	ocfs2_delete_osb(osb);
+	kfree(osb);
+out:
+	mlog_errno(status);
 
 	return status;
 }
@@ -1783,11 +1781,10 @@ static int ocfs2_get_sector(struct super_block *sb,
 static int ocfs2_mount_volume(struct super_block *sb)
 {
 	int status = 0;
-	int unlock_super = 0;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 
 	if (ocfs2_is_hard_readonly(osb))
-		goto leave;
+		goto out;
 
 	mutex_init(&osb->obs_trim_fs_mutex);
 
@@ -1797,44 +1794,58 @@ static int ocfs2_mount_volume(struct super_block *sb)
 		if (status == -EBADR && ocfs2_userspace_stack(osb))
 			mlog(ML_ERROR, "couldn't mount because cluster name on"
 			" disk does not match the running cluster name.\n");
-		goto leave;
+		goto out;
 	}
 
 	status = ocfs2_super_lock(osb, 1);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_dlm;
 	}
-	unlock_super = 1;
 
 	/* This will load up the node map and add ourselves to it. */
 	status = ocfs2_find_slot(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_super_lock;
 	}
 
 	/* load all node-local system inodes */
 	status = ocfs2_init_local_system_inodes(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_super_lock;
 	}
 
 	status = ocfs2_check_volume(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_system_inodes;
 	}
 
 	status = ocfs2_truncate_log_init(osb);
-	if (status < 0)
+	if (status < 0) {
 		mlog_errno(status);
+		goto out_check_volume;
+	}
 
-leave:
-	if (unlock_super)
-		ocfs2_super_unlock(osb, 1);
+	ocfs2_super_unlock(osb, 1);
+	return 0;
 
+out_check_volume:
+	ocfs2_free_replay_slots(osb);
+out_system_inodes:
+	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
+		ocfs2_shutdown_local_alloc(osb);
+	ocfs2_release_system_inodes(osb);
+	/* before journal shutdown, we should release slot_info */
+	ocfs2_free_slot_info(osb);
+	ocfs2_journal_shutdown(osb);
+out_super_lock:
+	ocfs2_super_unlock(osb, 1);
+out_dlm:
+	ocfs2_dlm_shutdown(osb, 0);
+out:
 	return status;
 }
 
@@ -1907,8 +1918,7 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	    !ocfs2_is_hard_readonly(osb))
 		hangup_needed = 1;
 
-	if (osb->cconn)
-		ocfs2_dlm_shutdown(osb, hangup_needed);
+	ocfs2_dlm_shutdown(osb, hangup_needed);
 
 	ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
 	debugfs_remove_recursive(osb->osb_debug_root);
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 832e65f06754..afc678d7fc86 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -850,7 +850,7 @@ static inline void __ftrace_enabled_restore(int enabled)
 #define CALLER_ADDR5 ((unsigned long)ftrace_return_address(5))
 #define CALLER_ADDR6 ((unsigned long)ftrace_return_address(6))
 
-static inline unsigned long get_lock_parent_ip(void)
+static __always_inline unsigned long get_lock_parent_ip(void)
 {
 	unsigned long addr = CALLER_ADDR0;
 
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index e7f45a966e6b..10b37773d9e4 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -163,7 +163,7 @@ static inline int htab_lock_bucket(const struct bpf_htab *htab,
 	unsigned long flags;
 	bool use_raw_lock;
 
-	hash = hash & HASHTAB_MAP_LOCK_MASK;
+	hash = hash & min_t(u32, HASHTAB_MAP_LOCK_MASK, htab->n_buckets - 1);
 
 	use_raw_lock = htab_use_raw_lock(htab);
 	if (use_raw_lock)
@@ -194,7 +194,7 @@ static inline void htab_unlock_bucket(const struct bpf_htab *htab,
 {
 	bool use_raw_lock = htab_use_raw_lock(htab);
 
-	hash = hash & HASHTAB_MAP_LOCK_MASK;
+	hash = hash & min_t(u32, HASHTAB_MAP_LOCK_MASK, htab->n_buckets - 1);
 	if (use_raw_lock)
 		raw_spin_unlock_irqrestore(&b->raw_lock, flags);
 	else
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2cdee62c3de7..dc57835e7096 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12024,7 +12024,7 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 	/*
 	 * If its not a per-cpu rb, it must be the same task.
 	 */
-	if (output_event->cpu == -1 && output_event->ctx != event->ctx)
+	if (output_event->cpu == -1 && output_event->hw.target != event->hw.target)
 		goto out;
 
 	/*
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a3a15fe90e0a..06927f772d50 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5383,12 +5383,15 @@ int modify_ftrace_direct(unsigned long ip,
 		ret = 0;
 	}
 
-	if (unlikely(ret && new_direct)) {
-		direct->count++;
-		list_del_rcu(&new_direct->next);
-		synchronize_rcu_tasks();
-		kfree(new_direct);
-		ftrace_direct_func_count--;
+	if (ret) {
+		direct->addr = old_addr;
+		if (unlikely(new_direct)) {
+			direct->count++;
+			list_del_rcu(&new_direct->next);
+			synchronize_rcu_tasks();
+			kfree(new_direct);
+			ftrace_direct_func_count--;
+		}
 	}
 
  out_unlock:
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 58b8e8b1fea2..c75c81f0a3c3 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3041,6 +3041,10 @@ rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 		if (RB_WARN_ON(cpu_buffer,
 			       rb_is_reader_page(cpu_buffer->tail_page)))
 			return;
+		/*
+		 * No need for a memory barrier here, as the update
+		 * of the tail_page did it for this page.
+		 */
 		local_set(&cpu_buffer->commit_page->page->commit,
 			  rb_page_write(cpu_buffer->commit_page));
 		rb_inc_page(&cpu_buffer->commit_page);
@@ -3050,6 +3054,8 @@ rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 	while (rb_commit_index(cpu_buffer) !=
 	       rb_page_write(cpu_buffer->commit_page)) {
 
+		/* Make sure the readers see the content of what is committed. */
+		smp_wmb();
 		local_set(&cpu_buffer->commit_page->page->commit,
 			  rb_page_write(cpu_buffer->commit_page));
 		RB_WARN_ON(cpu_buffer,
@@ -4632,7 +4638,12 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 
 	/*
 	 * Make sure we see any padding after the write update
-	 * (see rb_reset_tail())
+	 * (see rb_reset_tail()).
+	 *
+	 * In addition, a writer may be writing on the reader page
+	 * if the page has not been fully filled, so the read barrier
+	 * is also needed to make sure we see the content of what is
+	 * committed by the writer (see rb_set_commit_to_write()).
 	 */
 	smp_rmb();
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 83e2d1195fa4..dc097bd23dc3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9416,6 +9416,7 @@ static int __remove_instance(struct trace_array *tr)
 	tracefs_remove(tr->dir);
 	free_percpu(tr->last_func_repeats);
 	free_trace_buffers(tr);
+	clear_tracing_err_log(tr);
 
 	for (i = 0; i < tr->nr_topts; i++) {
 		kfree(tr->topts[i].topts);
diff --git a/mm/memory.c b/mm/memory.c
index a4d0f744a458..8d71a82462dd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3462,8 +3462,21 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 	struct vm_area_struct *vma = vmf->vma;
 	struct mmu_notifier_range range;
 
-	if (!lock_page_or_retry(page, vma->vm_mm, vmf->flags))
+	/*
+	 * We need a reference to lock the page because we don't hold
+	 * the PTL so a racing thread can remove the device-exclusive
+	 * entry and unmap it. If the page is free the entry must
+	 * have been removed already. If it happens to have already
+	 * been re-allocated after being freed all we do is lock and
+	 * unlock it.
+	 */
+	if (!get_page_unless_zero(page))
+		return 0;
+
+	if (!lock_page_or_retry(page, vma->vm_mm, vmf->flags)) {
+		put_page(page);
 		return VM_FAULT_RETRY;
+	}
 	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0, vma,
 				vma->vm_mm, vmf->address & PAGE_MASK,
 				(vmf->address & PAGE_MASK) + PAGE_SIZE, NULL);
@@ -3476,6 +3489,7 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	unlock_page(page);
+	put_page(page);
 
 	mmu_notifier_invalidate_range_end(&range);
 	return 0;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1551fb89769f..b7e1620adee6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -673,6 +673,7 @@ static void __del_from_avail_list(struct swap_info_struct *p)
 {
 	int nid;
 
+	assert_spin_locked(&p->lock);
 	for_each_node(nid)
 		plist_del(&p->avail_lists[nid], &swap_avail_heads[nid]);
 }
@@ -2565,8 +2566,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 		spin_unlock(&swap_lock);
 		goto out_dput;
 	}
-	del_from_avail_list(p);
 	spin_lock(&p->lock);
+	del_from_avail_list(p);
 	if (p->prio < 0) {
 		struct swap_info_struct *si = p;
 		int nid;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 8375eecc55de..3e482209a1c4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2927,9 +2927,11 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	 * allocation request, free them via __vfree() if any.
 	 */
 	if (area->nr_pages != nr_small_pages) {
-		warn_alloc(gfp_mask, NULL,
-			"vmalloc error: size %lu, page order %u, failed to allocate pages",
-			area->nr_pages * PAGE_SIZE, page_order);
+		/* vm_area_alloc_pages() can also fail due to a fatal signal */
+		if (!fatal_signal_pending(current))
+			warn_alloc(gfp_mask, NULL,
+				"vmalloc error: size %lu, page order %u, failed to allocate pages",
+				area->nr_pages * PAGE_SIZE, page_order);
 		goto fail;
 	}
 
diff --git a/net/can/isotp.c b/net/can/isotp.c
index 26821487a057..2a891f47b815 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1482,6 +1482,21 @@ static int isotp_init(struct sock *sk)
 	return 0;
 }
 
+static __poll_t isotp_poll(struct file *file, struct socket *sock, poll_table *wait)
+{
+	struct sock *sk = sock->sk;
+	struct isotp_sock *so = isotp_sk(sk);
+
+	__poll_t mask = datagram_poll(file, sock, wait);
+	poll_wait(file, &so->wait, wait);
+
+	/* Check for false positives due to TX state */
+	if ((mask & EPOLLWRNORM) && (so->tx.state != ISOTP_IDLE))
+		mask &= ~(EPOLLOUT | EPOLLWRNORM);
+
+	return mask;
+}
+
 static int isotp_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
 				  unsigned long arg)
 {
@@ -1497,7 +1512,7 @@ static const struct proto_ops isotp_ops = {
 	.socketpair = sock_no_socketpair,
 	.accept = sock_no_accept,
 	.getname = isotp_getname,
-	.poll = datagram_poll,
+	.poll = isotp_poll,
 	.ioctl = isotp_sock_no_ioctlcmd,
 	.gettstamp = sock_gettstamp,
 	.listen = sock_no_listen,
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 848b60c9ef79..bd8ec2433832 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -604,7 +604,10 @@ sk_buff *j1939_tp_tx_dat_new(struct j1939_priv *priv,
 	/* reserve CAN header */
 	skb_reserve(skb, offsetof(struct can_frame, data));
 
-	memcpy(skb->cb, re_skcb, sizeof(skb->cb));
+	/* skb->cb must be large enough to hold a j1939_sk_buff_cb structure */
+	BUILD_BUG_ON(sizeof(skb->cb) < sizeof(*re_skcb));
+
+	memcpy(skb->cb, re_skcb, sizeof(*re_skcb));
 	skcb = j1939_skb_to_cb(skb);
 	if (swap_src_dst)
 		j1939_skbcb_swap(skcb);
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index edfc0f8011f8..bd750863959f 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -137,6 +137,20 @@ static void queue_process(struct work_struct *work)
 	}
 }
 
+static int netif_local_xmit_active(struct net_device *dev)
+{
+	int i;
+
+	for (i = 0; i < dev->num_tx_queues; i++) {
+		struct netdev_queue *txq = netdev_get_tx_queue(dev, i);
+
+		if (READ_ONCE(txq->xmit_lock_owner) == smp_processor_id())
+			return 1;
+	}
+
+	return 0;
+}
+
 static void poll_one_napi(struct napi_struct *napi)
 {
 	int work;
@@ -183,7 +197,10 @@ void netpoll_poll_dev(struct net_device *dev)
 	if (!ni || down_trylock(&ni->dev_lock))
 		return;
 
-	if (!netif_running(dev)) {
+	/* Some drivers will take the same locks in poll and xmit,
+	 * we can't poll if local CPU is already in xmit.
+	 */
+	if (!netif_running(dev) || netif_local_xmit_active(dev)) {
 		up(&ni->dev_lock);
 		return;
 	}
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index f9eda596f301..3d05b9bf3485 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -277,11 +277,12 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 					    "lanes configuration not supported by device");
 			return -EOPNOTSUPP;
 		}
-	} else if (!lsettings->autoneg) {
-		/* If autoneg is off and lanes parameter is not passed from user,
-		 * set the lanes parameter to 0.
+	} else if (!lsettings->autoneg && ksettings->lanes) {
+		/* If autoneg is off and lanes parameter is not passed from user but
+		 * it was defined previously then set the lanes parameter to 0.
 		 */
 		ksettings->lanes = 0;
+		*mod = true;
 	}
 
 	ret = ethnl_update_bitset(ksettings->link_modes.advertising,
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 609c4ff7edc6..7b749a98327c 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -755,6 +755,11 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 		room = 576;
 	room -= sizeof(struct iphdr) + icmp_param.replyopts.opt.opt.optlen;
 	room -= sizeof(struct icmphdr);
+	/* Guard against tiny mtu. We need to include at least one
+	 * IP network header for this message to make any sense.
+	 */
+	if (room <= (int)sizeof(struct iphdr))
+		goto ende;
 
 	icmp_param.data_len = skb_in->len - icmp_param.offset;
 	if (icmp_param.data_len > room)
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 383442ded954..be63929b1ac5 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1913,8 +1913,13 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 	IP6_UPD_PO_STATS(net, rt->rt6i_idev, IPSTATS_MIB_OUT, skb->len);
 	if (proto == IPPROTO_ICMPV6) {
 		struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
+		u8 icmp6_type;
 
-		ICMP6MSGOUT_INC_STATS(net, idev, icmp6_hdr(skb)->icmp6_type);
+		if (sk->sk_socket->type == SOCK_RAW && !inet_sk(sk)->hdrincl)
+			icmp6_type = fl6->fl6_icmp_type;
+		else
+			icmp6_type = icmp6_hdr(skb)->icmp6_type;
+		ICMP6MSGOUT_INC_STATS(net, idev, icmp6_type);
 		ICMP6_INC_STATS(net, idev, ICMP6_MIB_OUTMSGS);
 	}
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 14db465289c5..e10bcfa20526 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1036,7 +1036,8 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 	list_del_rcu(&sta->list);
 	sta->removed = true;
 
-	drv_sta_pre_rcu_remove(local, sta->sdata, sta);
+	if (sta->uploaded)
+		drv_sta_pre_rcu_remove(local, sta->sdata, sta);
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
 	    rcu_access_pointer(sdata->u.vlan.sta) == sta)
diff --git a/net/qrtr/Makefile b/net/qrtr/Makefile
index 1b1411d158a7..8e0605f88a73 100644
--- a/net/qrtr/Makefile
+++ b/net/qrtr/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_QRTR) := qrtr.o ns.o
+obj-$(CONFIG_QRTR) += qrtr.o
+qrtr-y	:= af_qrtr.o ns.o
 
 obj-$(CONFIG_QRTR_SMD) += qrtr-smd.o
 qrtr-smd-y	:= smd.o
diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
new file mode 100644
index 000000000000..6e88ba812d2a
--- /dev/null
+++ b/net/qrtr/af_qrtr.c
@@ -0,0 +1,1323 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2015, Sony Mobile Communications Inc.
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ */
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/qrtr.h>
+#include <linux/termios.h>	/* For TIOCINQ/OUTQ */
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+
+#include <net/sock.h>
+
+#include "qrtr.h"
+
+#define QRTR_PROTO_VER_1 1
+#define QRTR_PROTO_VER_2 3
+
+/* auto-bind range */
+#define QRTR_MIN_EPH_SOCKET 0x4000
+#define QRTR_MAX_EPH_SOCKET 0x7fff
+#define QRTR_EPH_PORT_RANGE \
+		XA_LIMIT(QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET)
+
+/**
+ * struct qrtr_hdr_v1 - (I|R)PCrouter packet header version 1
+ * @version: protocol version
+ * @type: packet type; one of QRTR_TYPE_*
+ * @src_node_id: source node
+ * @src_port_id: source port
+ * @confirm_rx: boolean; whether a resume-tx packet should be send in reply
+ * @size: length of packet, excluding this header
+ * @dst_node_id: destination node
+ * @dst_port_id: destination port
+ */
+struct qrtr_hdr_v1 {
+	__le32 version;
+	__le32 type;
+	__le32 src_node_id;
+	__le32 src_port_id;
+	__le32 confirm_rx;
+	__le32 size;
+	__le32 dst_node_id;
+	__le32 dst_port_id;
+} __packed;
+
+/**
+ * struct qrtr_hdr_v2 - (I|R)PCrouter packet header later versions
+ * @version: protocol version
+ * @type: packet type; one of QRTR_TYPE_*
+ * @flags: bitmask of QRTR_FLAGS_*
+ * @optlen: length of optional header data
+ * @size: length of packet, excluding this header and optlen
+ * @src_node_id: source node
+ * @src_port_id: source port
+ * @dst_node_id: destination node
+ * @dst_port_id: destination port
+ */
+struct qrtr_hdr_v2 {
+	u8 version;
+	u8 type;
+	u8 flags;
+	u8 optlen;
+	__le32 size;
+	__le16 src_node_id;
+	__le16 src_port_id;
+	__le16 dst_node_id;
+	__le16 dst_port_id;
+};
+
+#define QRTR_FLAGS_CONFIRM_RX	BIT(0)
+
+struct qrtr_cb {
+	u32 src_node;
+	u32 src_port;
+	u32 dst_node;
+	u32 dst_port;
+
+	u8 type;
+	u8 confirm_rx;
+};
+
+#define QRTR_HDR_MAX_SIZE max_t(size_t, sizeof(struct qrtr_hdr_v1), \
+					sizeof(struct qrtr_hdr_v2))
+
+struct qrtr_sock {
+	/* WARNING: sk must be the first member */
+	struct sock sk;
+	struct sockaddr_qrtr us;
+	struct sockaddr_qrtr peer;
+};
+
+static inline struct qrtr_sock *qrtr_sk(struct sock *sk)
+{
+	BUILD_BUG_ON(offsetof(struct qrtr_sock, sk) != 0);
+	return container_of(sk, struct qrtr_sock, sk);
+}
+
+static unsigned int qrtr_local_nid = 1;
+
+/* for node ids */
+static RADIX_TREE(qrtr_nodes, GFP_ATOMIC);
+static DEFINE_SPINLOCK(qrtr_nodes_lock);
+/* broadcast list */
+static LIST_HEAD(qrtr_all_nodes);
+/* lock for qrtr_all_nodes and node reference */
+static DEFINE_MUTEX(qrtr_node_lock);
+
+/* local port allocation management */
+static DEFINE_XARRAY_ALLOC(qrtr_ports);
+
+/**
+ * struct qrtr_node - endpoint node
+ * @ep_lock: lock for endpoint management and callbacks
+ * @ep: endpoint
+ * @ref: reference count for node
+ * @nid: node id
+ * @qrtr_tx_flow: tree of qrtr_tx_flow, keyed by node << 32 | port
+ * @qrtr_tx_lock: lock for qrtr_tx_flow inserts
+ * @rx_queue: receive queue
+ * @item: list item for broadcast list
+ */
+struct qrtr_node {
+	struct mutex ep_lock;
+	struct qrtr_endpoint *ep;
+	struct kref ref;
+	unsigned int nid;
+
+	struct radix_tree_root qrtr_tx_flow;
+	struct mutex qrtr_tx_lock; /* for qrtr_tx_flow */
+
+	struct sk_buff_head rx_queue;
+	struct list_head item;
+};
+
+/**
+ * struct qrtr_tx_flow - tx flow control
+ * @resume_tx: waiters for a resume tx from the remote
+ * @pending: number of waiting senders
+ * @tx_failed: indicates that a message with confirm_rx flag was lost
+ */
+struct qrtr_tx_flow {
+	struct wait_queue_head resume_tx;
+	int pending;
+	int tx_failed;
+};
+
+#define QRTR_TX_FLOW_HIGH	10
+#define QRTR_TX_FLOW_LOW	5
+
+static int qrtr_local_enqueue(struct qrtr_node *node, struct sk_buff *skb,
+			      int type, struct sockaddr_qrtr *from,
+			      struct sockaddr_qrtr *to);
+static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
+			      int type, struct sockaddr_qrtr *from,
+			      struct sockaddr_qrtr *to);
+static struct qrtr_sock *qrtr_port_lookup(int port);
+static void qrtr_port_put(struct qrtr_sock *ipc);
+
+/* Release node resources and free the node.
+ *
+ * Do not call directly, use qrtr_node_release.  To be used with
+ * kref_put_mutex.  As such, the node mutex is expected to be locked on call.
+ */
+static void __qrtr_node_release(struct kref *kref)
+{
+	struct qrtr_node *node = container_of(kref, struct qrtr_node, ref);
+	struct radix_tree_iter iter;
+	struct qrtr_tx_flow *flow;
+	unsigned long flags;
+	void __rcu **slot;
+
+	spin_lock_irqsave(&qrtr_nodes_lock, flags);
+	/* If the node is a bridge for other nodes, there are possibly
+	 * multiple entries pointing to our released node, delete them all.
+	 */
+	radix_tree_for_each_slot(slot, &qrtr_nodes, &iter, 0) {
+		if (*slot == node)
+			radix_tree_iter_delete(&qrtr_nodes, &iter, slot);
+	}
+	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
+
+	list_del(&node->item);
+	mutex_unlock(&qrtr_node_lock);
+
+	skb_queue_purge(&node->rx_queue);
+
+	/* Free tx flow counters */
+	radix_tree_for_each_slot(slot, &node->qrtr_tx_flow, &iter, 0) {
+		flow = *slot;
+		radix_tree_iter_delete(&node->qrtr_tx_flow, &iter, slot);
+		kfree(flow);
+	}
+	kfree(node);
+}
+
+/* Increment reference to node. */
+static struct qrtr_node *qrtr_node_acquire(struct qrtr_node *node)
+{
+	if (node)
+		kref_get(&node->ref);
+	return node;
+}
+
+/* Decrement reference to node and release as necessary. */
+static void qrtr_node_release(struct qrtr_node *node)
+{
+	if (!node)
+		return;
+	kref_put_mutex(&node->ref, __qrtr_node_release, &qrtr_node_lock);
+}
+
+/**
+ * qrtr_tx_resume() - reset flow control counter
+ * @node:	qrtr_node that the QRTR_TYPE_RESUME_TX packet arrived on
+ * @skb:	resume_tx packet
+ */
+static void qrtr_tx_resume(struct qrtr_node *node, struct sk_buff *skb)
+{
+	struct qrtr_ctrl_pkt *pkt = (struct qrtr_ctrl_pkt *)skb->data;
+	u64 remote_node = le32_to_cpu(pkt->client.node);
+	u32 remote_port = le32_to_cpu(pkt->client.port);
+	struct qrtr_tx_flow *flow;
+	unsigned long key;
+
+	key = remote_node << 32 | remote_port;
+
+	rcu_read_lock();
+	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
+	rcu_read_unlock();
+	if (flow) {
+		spin_lock(&flow->resume_tx.lock);
+		flow->pending = 0;
+		spin_unlock(&flow->resume_tx.lock);
+		wake_up_interruptible_all(&flow->resume_tx);
+	}
+
+	consume_skb(skb);
+}
+
+/**
+ * qrtr_tx_wait() - flow control for outgoing packets
+ * @node:	qrtr_node that the packet is to be send to
+ * @dest_node:	node id of the destination
+ * @dest_port:	port number of the destination
+ * @type:	type of message
+ *
+ * The flow control scheme is based around the low and high "watermarks". When
+ * the low watermark is passed the confirm_rx flag is set on the outgoing
+ * message, which will trigger the remote to send a control message of the type
+ * QRTR_TYPE_RESUME_TX to reset the counter. If the high watermark is hit
+ * further transmision should be paused.
+ *
+ * Return: 1 if confirm_rx should be set, 0 otherwise or errno failure
+ */
+static int qrtr_tx_wait(struct qrtr_node *node, int dest_node, int dest_port,
+			int type)
+{
+	unsigned long key = (u64)dest_node << 32 | dest_port;
+	struct qrtr_tx_flow *flow;
+	int confirm_rx = 0;
+	int ret;
+
+	/* Never set confirm_rx on non-data packets */
+	if (type != QRTR_TYPE_DATA)
+		return 0;
+
+	mutex_lock(&node->qrtr_tx_lock);
+	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
+	if (!flow) {
+		flow = kzalloc(sizeof(*flow), GFP_KERNEL);
+		if (flow) {
+			init_waitqueue_head(&flow->resume_tx);
+			if (radix_tree_insert(&node->qrtr_tx_flow, key, flow)) {
+				kfree(flow);
+				flow = NULL;
+			}
+		}
+	}
+	mutex_unlock(&node->qrtr_tx_lock);
+
+	/* Set confirm_rx if we where unable to find and allocate a flow */
+	if (!flow)
+		return 1;
+
+	spin_lock_irq(&flow->resume_tx.lock);
+	ret = wait_event_interruptible_locked_irq(flow->resume_tx,
+						  flow->pending < QRTR_TX_FLOW_HIGH ||
+						  flow->tx_failed ||
+						  !node->ep);
+	if (ret < 0) {
+		confirm_rx = ret;
+	} else if (!node->ep) {
+		confirm_rx = -EPIPE;
+	} else if (flow->tx_failed) {
+		flow->tx_failed = 0;
+		confirm_rx = 1;
+	} else {
+		flow->pending++;
+		confirm_rx = flow->pending == QRTR_TX_FLOW_LOW;
+	}
+	spin_unlock_irq(&flow->resume_tx.lock);
+
+	return confirm_rx;
+}
+
+/**
+ * qrtr_tx_flow_failed() - flag that tx of confirm_rx flagged messages failed
+ * @node:	qrtr_node that the packet is to be send to
+ * @dest_node:	node id of the destination
+ * @dest_port:	port number of the destination
+ *
+ * Signal that the transmission of a message with confirm_rx flag failed. The
+ * flow's "pending" counter will keep incrementing towards QRTR_TX_FLOW_HIGH,
+ * at which point transmission would stall forever waiting for the resume TX
+ * message associated with the dropped confirm_rx message.
+ * Work around this by marking the flow as having a failed transmission and
+ * cause the next transmission attempt to be sent with the confirm_rx.
+ */
+static void qrtr_tx_flow_failed(struct qrtr_node *node, int dest_node,
+				int dest_port)
+{
+	unsigned long key = (u64)dest_node << 32 | dest_port;
+	struct qrtr_tx_flow *flow;
+
+	rcu_read_lock();
+	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
+	rcu_read_unlock();
+	if (flow) {
+		spin_lock_irq(&flow->resume_tx.lock);
+		flow->tx_failed = 1;
+		spin_unlock_irq(&flow->resume_tx.lock);
+	}
+}
+
+/* Pass an outgoing packet socket buffer to the endpoint driver. */
+static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
+			     int type, struct sockaddr_qrtr *from,
+			     struct sockaddr_qrtr *to)
+{
+	struct qrtr_hdr_v1 *hdr;
+	size_t len = skb->len;
+	int rc, confirm_rx;
+
+	confirm_rx = qrtr_tx_wait(node, to->sq_node, to->sq_port, type);
+	if (confirm_rx < 0) {
+		kfree_skb(skb);
+		return confirm_rx;
+	}
+
+	hdr = skb_push(skb, sizeof(*hdr));
+	hdr->version = cpu_to_le32(QRTR_PROTO_VER_1);
+	hdr->type = cpu_to_le32(type);
+	hdr->src_node_id = cpu_to_le32(from->sq_node);
+	hdr->src_port_id = cpu_to_le32(from->sq_port);
+	if (to->sq_port == QRTR_PORT_CTRL) {
+		hdr->dst_node_id = cpu_to_le32(node->nid);
+		hdr->dst_port_id = cpu_to_le32(QRTR_PORT_CTRL);
+	} else {
+		hdr->dst_node_id = cpu_to_le32(to->sq_node);
+		hdr->dst_port_id = cpu_to_le32(to->sq_port);
+	}
+
+	hdr->size = cpu_to_le32(len);
+	hdr->confirm_rx = !!confirm_rx;
+
+	rc = skb_put_padto(skb, ALIGN(len, 4) + sizeof(*hdr));
+
+	if (!rc) {
+		mutex_lock(&node->ep_lock);
+		rc = -ENODEV;
+		if (node->ep)
+			rc = node->ep->xmit(node->ep, skb);
+		else
+			kfree_skb(skb);
+		mutex_unlock(&node->ep_lock);
+	}
+	/* Need to ensure that a subsequent message carries the otherwise lost
+	 * confirm_rx flag if we dropped this one */
+	if (rc && confirm_rx)
+		qrtr_tx_flow_failed(node, to->sq_node, to->sq_port);
+
+	return rc;
+}
+
+/* Lookup node by id.
+ *
+ * callers must release with qrtr_node_release()
+ */
+static struct qrtr_node *qrtr_node_lookup(unsigned int nid)
+{
+	struct qrtr_node *node;
+	unsigned long flags;
+
+	mutex_lock(&qrtr_node_lock);
+	spin_lock_irqsave(&qrtr_nodes_lock, flags);
+	node = radix_tree_lookup(&qrtr_nodes, nid);
+	node = qrtr_node_acquire(node);
+	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
+	mutex_unlock(&qrtr_node_lock);
+
+	return node;
+}
+
+/* Assign node id to node.
+ *
+ * This is mostly useful for automatic node id assignment, based on
+ * the source id in the incoming packet.
+ */
+static void qrtr_node_assign(struct qrtr_node *node, unsigned int nid)
+{
+	unsigned long flags;
+
+	if (nid == QRTR_EP_NID_AUTO)
+		return;
+
+	spin_lock_irqsave(&qrtr_nodes_lock, flags);
+	radix_tree_insert(&qrtr_nodes, nid, node);
+	if (node->nid == QRTR_EP_NID_AUTO)
+		node->nid = nid;
+	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
+}
+
+/**
+ * qrtr_endpoint_post() - post incoming data
+ * @ep: endpoint handle
+ * @data: data pointer
+ * @len: size of data in bytes
+ *
+ * Return: 0 on success; negative error code on failure
+ */
+int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
+{
+	struct qrtr_node *node = ep->node;
+	const struct qrtr_hdr_v1 *v1;
+	const struct qrtr_hdr_v2 *v2;
+	struct qrtr_sock *ipc;
+	struct sk_buff *skb;
+	struct qrtr_cb *cb;
+	size_t size;
+	unsigned int ver;
+	size_t hdrlen;
+
+	if (len == 0 || len & 3)
+		return -EINVAL;
+
+	skb = __netdev_alloc_skb(NULL, len, GFP_ATOMIC | __GFP_NOWARN);
+	if (!skb)
+		return -ENOMEM;
+
+	cb = (struct qrtr_cb *)skb->cb;
+
+	/* Version field in v1 is little endian, so this works for both cases */
+	ver = *(u8*)data;
+
+	switch (ver) {
+	case QRTR_PROTO_VER_1:
+		if (len < sizeof(*v1))
+			goto err;
+		v1 = data;
+		hdrlen = sizeof(*v1);
+
+		cb->type = le32_to_cpu(v1->type);
+		cb->src_node = le32_to_cpu(v1->src_node_id);
+		cb->src_port = le32_to_cpu(v1->src_port_id);
+		cb->confirm_rx = !!v1->confirm_rx;
+		cb->dst_node = le32_to_cpu(v1->dst_node_id);
+		cb->dst_port = le32_to_cpu(v1->dst_port_id);
+
+		size = le32_to_cpu(v1->size);
+		break;
+	case QRTR_PROTO_VER_2:
+		if (len < sizeof(*v2))
+			goto err;
+		v2 = data;
+		hdrlen = sizeof(*v2) + v2->optlen;
+
+		cb->type = v2->type;
+		cb->confirm_rx = !!(v2->flags & QRTR_FLAGS_CONFIRM_RX);
+		cb->src_node = le16_to_cpu(v2->src_node_id);
+		cb->src_port = le16_to_cpu(v2->src_port_id);
+		cb->dst_node = le16_to_cpu(v2->dst_node_id);
+		cb->dst_port = le16_to_cpu(v2->dst_port_id);
+
+		if (cb->src_port == (u16)QRTR_PORT_CTRL)
+			cb->src_port = QRTR_PORT_CTRL;
+		if (cb->dst_port == (u16)QRTR_PORT_CTRL)
+			cb->dst_port = QRTR_PORT_CTRL;
+
+		size = le32_to_cpu(v2->size);
+		break;
+	default:
+		pr_err("qrtr: Invalid version %d\n", ver);
+		goto err;
+	}
+
+	if (!size || len != ALIGN(size, 4) + hdrlen)
+		goto err;
+
+	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
+	    cb->type != QRTR_TYPE_RESUME_TX)
+		goto err;
+
+	skb_put_data(skb, data + hdrlen, size);
+
+	qrtr_node_assign(node, cb->src_node);
+
+	if (cb->type == QRTR_TYPE_NEW_SERVER) {
+		/* Remote node endpoint can bridge other distant nodes */
+		const struct qrtr_ctrl_pkt *pkt;
+
+		if (size < sizeof(*pkt))
+			goto err;
+
+		pkt = data + hdrlen;
+		qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
+	}
+
+	if (cb->type == QRTR_TYPE_RESUME_TX) {
+		qrtr_tx_resume(node, skb);
+	} else {
+		ipc = qrtr_port_lookup(cb->dst_port);
+		if (!ipc)
+			goto err;
+
+		if (sock_queue_rcv_skb(&ipc->sk, skb)) {
+			qrtr_port_put(ipc);
+			goto err;
+		}
+
+		qrtr_port_put(ipc);
+	}
+
+	return 0;
+
+err:
+	kfree_skb(skb);
+	return -EINVAL;
+
+}
+EXPORT_SYMBOL_GPL(qrtr_endpoint_post);
+
+/**
+ * qrtr_alloc_ctrl_packet() - allocate control packet skb
+ * @pkt: reference to qrtr_ctrl_pkt pointer
+ * @flags: the type of memory to allocate
+ *
+ * Returns newly allocated sk_buff, or NULL on failure
+ *
+ * This function allocates a sk_buff large enough to carry a qrtr_ctrl_pkt and
+ * on success returns a reference to the control packet in @pkt.
+ */
+static struct sk_buff *qrtr_alloc_ctrl_packet(struct qrtr_ctrl_pkt **pkt,
+					      gfp_t flags)
+{
+	const int pkt_len = sizeof(struct qrtr_ctrl_pkt);
+	struct sk_buff *skb;
+
+	skb = alloc_skb(QRTR_HDR_MAX_SIZE + pkt_len, flags);
+	if (!skb)
+		return NULL;
+
+	skb_reserve(skb, QRTR_HDR_MAX_SIZE);
+	*pkt = skb_put_zero(skb, pkt_len);
+
+	return skb;
+}
+
+/**
+ * qrtr_endpoint_register() - register a new endpoint
+ * @ep: endpoint to register
+ * @nid: desired node id; may be QRTR_EP_NID_AUTO for auto-assignment
+ * Return: 0 on success; negative error code on failure
+ *
+ * The specified endpoint must have the xmit function pointer set on call.
+ */
+int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
+{
+	struct qrtr_node *node;
+
+	if (!ep || !ep->xmit)
+		return -EINVAL;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return -ENOMEM;
+
+	kref_init(&node->ref);
+	mutex_init(&node->ep_lock);
+	skb_queue_head_init(&node->rx_queue);
+	node->nid = QRTR_EP_NID_AUTO;
+	node->ep = ep;
+
+	INIT_RADIX_TREE(&node->qrtr_tx_flow, GFP_KERNEL);
+	mutex_init(&node->qrtr_tx_lock);
+
+	qrtr_node_assign(node, nid);
+
+	mutex_lock(&qrtr_node_lock);
+	list_add(&node->item, &qrtr_all_nodes);
+	mutex_unlock(&qrtr_node_lock);
+	ep->node = node;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(qrtr_endpoint_register);
+
+/**
+ * qrtr_endpoint_unregister - unregister endpoint
+ * @ep: endpoint to unregister
+ */
+void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
+{
+	struct qrtr_node *node = ep->node;
+	struct sockaddr_qrtr src = {AF_QIPCRTR, node->nid, QRTR_PORT_CTRL};
+	struct sockaddr_qrtr dst = {AF_QIPCRTR, qrtr_local_nid, QRTR_PORT_CTRL};
+	struct radix_tree_iter iter;
+	struct qrtr_ctrl_pkt *pkt;
+	struct qrtr_tx_flow *flow;
+	struct sk_buff *skb;
+	unsigned long flags;
+	void __rcu **slot;
+
+	mutex_lock(&node->ep_lock);
+	node->ep = NULL;
+	mutex_unlock(&node->ep_lock);
+
+	/* Notify the local controller about the event */
+	spin_lock_irqsave(&qrtr_nodes_lock, flags);
+	radix_tree_for_each_slot(slot, &qrtr_nodes, &iter, 0) {
+		if (*slot != node)
+			continue;
+		src.sq_node = iter.index;
+		skb = qrtr_alloc_ctrl_packet(&pkt, GFP_ATOMIC);
+		if (skb) {
+			pkt->cmd = cpu_to_le32(QRTR_TYPE_BYE);
+			qrtr_local_enqueue(NULL, skb, QRTR_TYPE_BYE, &src, &dst);
+		}
+	}
+	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
+
+	/* Wake up any transmitters waiting for resume-tx from the node */
+	mutex_lock(&node->qrtr_tx_lock);
+	radix_tree_for_each_slot(slot, &node->qrtr_tx_flow, &iter, 0) {
+		flow = *slot;
+		wake_up_interruptible_all(&flow->resume_tx);
+	}
+	mutex_unlock(&node->qrtr_tx_lock);
+
+	qrtr_node_release(node);
+	ep->node = NULL;
+}
+EXPORT_SYMBOL_GPL(qrtr_endpoint_unregister);
+
+/* Lookup socket by port.
+ *
+ * Callers must release with qrtr_port_put()
+ */
+static struct qrtr_sock *qrtr_port_lookup(int port)
+{
+	struct qrtr_sock *ipc;
+
+	if (port == QRTR_PORT_CTRL)
+		port = 0;
+
+	rcu_read_lock();
+	ipc = xa_load(&qrtr_ports, port);
+	if (ipc)
+		sock_hold(&ipc->sk);
+	rcu_read_unlock();
+
+	return ipc;
+}
+
+/* Release acquired socket. */
+static void qrtr_port_put(struct qrtr_sock *ipc)
+{
+	sock_put(&ipc->sk);
+}
+
+/* Remove port assignment. */
+static void qrtr_port_remove(struct qrtr_sock *ipc)
+{
+	struct qrtr_ctrl_pkt *pkt;
+	struct sk_buff *skb;
+	int port = ipc->us.sq_port;
+	struct sockaddr_qrtr to;
+
+	to.sq_family = AF_QIPCRTR;
+	to.sq_node = QRTR_NODE_BCAST;
+	to.sq_port = QRTR_PORT_CTRL;
+
+	skb = qrtr_alloc_ctrl_packet(&pkt, GFP_KERNEL);
+	if (skb) {
+		pkt->cmd = cpu_to_le32(QRTR_TYPE_DEL_CLIENT);
+		pkt->client.node = cpu_to_le32(ipc->us.sq_node);
+		pkt->client.port = cpu_to_le32(ipc->us.sq_port);
+
+		skb_set_owner_w(skb, &ipc->sk);
+		qrtr_bcast_enqueue(NULL, skb, QRTR_TYPE_DEL_CLIENT, &ipc->us,
+				   &to);
+	}
+
+	if (port == QRTR_PORT_CTRL)
+		port = 0;
+
+	__sock_put(&ipc->sk);
+
+	xa_erase(&qrtr_ports, port);
+
+	/* Ensure that if qrtr_port_lookup() did enter the RCU read section we
+	 * wait for it to up increment the refcount */
+	synchronize_rcu();
+}
+
+/* Assign port number to socket.
+ *
+ * Specify port in the integer pointed to by port, and it will be adjusted
+ * on return as necesssary.
+ *
+ * Port may be:
+ *   0: Assign ephemeral port in [QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET]
+ *   <QRTR_MIN_EPH_SOCKET: Specified; requires CAP_NET_ADMIN
+ *   >QRTR_MIN_EPH_SOCKET: Specified; available to all
+ */
+static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
+{
+	int rc;
+
+	if (!*port) {
+		rc = xa_alloc(&qrtr_ports, port, ipc, QRTR_EPH_PORT_RANGE,
+				GFP_KERNEL);
+	} else if (*port < QRTR_MIN_EPH_SOCKET && !capable(CAP_NET_ADMIN)) {
+		rc = -EACCES;
+	} else if (*port == QRTR_PORT_CTRL) {
+		rc = xa_insert(&qrtr_ports, 0, ipc, GFP_KERNEL);
+	} else {
+		rc = xa_insert(&qrtr_ports, *port, ipc, GFP_KERNEL);
+	}
+
+	if (rc == -EBUSY)
+		return -EADDRINUSE;
+	else if (rc < 0)
+		return rc;
+
+	sock_hold(&ipc->sk);
+
+	return 0;
+}
+
+/* Reset all non-control ports */
+static void qrtr_reset_ports(void)
+{
+	struct qrtr_sock *ipc;
+	unsigned long index;
+
+	rcu_read_lock();
+	xa_for_each_start(&qrtr_ports, index, ipc, 1) {
+		sock_hold(&ipc->sk);
+		ipc->sk.sk_err = ENETRESET;
+		sk_error_report(&ipc->sk);
+		sock_put(&ipc->sk);
+	}
+	rcu_read_unlock();
+}
+
+/* Bind socket to address.
+ *
+ * Socket should be locked upon call.
+ */
+static int __qrtr_bind(struct socket *sock,
+		       const struct sockaddr_qrtr *addr, int zapped)
+{
+	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
+	struct sock *sk = sock->sk;
+	int port;
+	int rc;
+
+	/* rebinding ok */
+	if (!zapped && addr->sq_port == ipc->us.sq_port)
+		return 0;
+
+	port = addr->sq_port;
+	rc = qrtr_port_assign(ipc, &port);
+	if (rc)
+		return rc;
+
+	/* unbind previous, if any */
+	if (!zapped)
+		qrtr_port_remove(ipc);
+	ipc->us.sq_port = port;
+
+	sock_reset_flag(sk, SOCK_ZAPPED);
+
+	/* Notify all open ports about the new controller */
+	if (port == QRTR_PORT_CTRL)
+		qrtr_reset_ports();
+
+	return 0;
+}
+
+/* Auto bind to an ephemeral port. */
+static int qrtr_autobind(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	struct sockaddr_qrtr addr;
+
+	if (!sock_flag(sk, SOCK_ZAPPED))
+		return 0;
+
+	addr.sq_family = AF_QIPCRTR;
+	addr.sq_node = qrtr_local_nid;
+	addr.sq_port = 0;
+
+	return __qrtr_bind(sock, &addr, 1);
+}
+
+/* Bind socket to specified sockaddr. */
+static int qrtr_bind(struct socket *sock, struct sockaddr *saddr, int len)
+{
+	DECLARE_SOCKADDR(struct sockaddr_qrtr *, addr, saddr);
+	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
+	struct sock *sk = sock->sk;
+	int rc;
+
+	if (len < sizeof(*addr) || addr->sq_family != AF_QIPCRTR)
+		return -EINVAL;
+
+	if (addr->sq_node != ipc->us.sq_node)
+		return -EINVAL;
+
+	lock_sock(sk);
+	rc = __qrtr_bind(sock, addr, sock_flag(sk, SOCK_ZAPPED));
+	release_sock(sk);
+
+	return rc;
+}
+
+/* Queue packet to local peer socket. */
+static int qrtr_local_enqueue(struct qrtr_node *node, struct sk_buff *skb,
+			      int type, struct sockaddr_qrtr *from,
+			      struct sockaddr_qrtr *to)
+{
+	struct qrtr_sock *ipc;
+	struct qrtr_cb *cb;
+
+	ipc = qrtr_port_lookup(to->sq_port);
+	if (!ipc || &ipc->sk == skb->sk) { /* do not send to self */
+		if (ipc)
+			qrtr_port_put(ipc);
+		kfree_skb(skb);
+		return -ENODEV;
+	}
+
+	cb = (struct qrtr_cb *)skb->cb;
+	cb->src_node = from->sq_node;
+	cb->src_port = from->sq_port;
+
+	if (sock_queue_rcv_skb(&ipc->sk, skb)) {
+		qrtr_port_put(ipc);
+		kfree_skb(skb);
+		return -ENOSPC;
+	}
+
+	qrtr_port_put(ipc);
+
+	return 0;
+}
+
+/* Queue packet for broadcast. */
+static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
+			      int type, struct sockaddr_qrtr *from,
+			      struct sockaddr_qrtr *to)
+{
+	struct sk_buff *skbn;
+
+	mutex_lock(&qrtr_node_lock);
+	list_for_each_entry(node, &qrtr_all_nodes, item) {
+		skbn = skb_clone(skb, GFP_KERNEL);
+		if (!skbn)
+			break;
+		skb_set_owner_w(skbn, skb->sk);
+		qrtr_node_enqueue(node, skbn, type, from, to);
+	}
+	mutex_unlock(&qrtr_node_lock);
+
+	qrtr_local_enqueue(NULL, skb, type, from, to);
+
+	return 0;
+}
+
+static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+{
+	DECLARE_SOCKADDR(struct sockaddr_qrtr *, addr, msg->msg_name);
+	int (*enqueue_fn)(struct qrtr_node *, struct sk_buff *, int,
+			  struct sockaddr_qrtr *, struct sockaddr_qrtr *);
+	__le32 qrtr_type = cpu_to_le32(QRTR_TYPE_DATA);
+	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
+	struct sock *sk = sock->sk;
+	struct qrtr_node *node;
+	struct sk_buff *skb;
+	size_t plen;
+	u32 type;
+	int rc;
+
+	if (msg->msg_flags & ~(MSG_DONTWAIT))
+		return -EINVAL;
+
+	if (len > 65535)
+		return -EMSGSIZE;
+
+	lock_sock(sk);
+
+	if (addr) {
+		if (msg->msg_namelen < sizeof(*addr)) {
+			release_sock(sk);
+			return -EINVAL;
+		}
+
+		if (addr->sq_family != AF_QIPCRTR) {
+			release_sock(sk);
+			return -EINVAL;
+		}
+
+		rc = qrtr_autobind(sock);
+		if (rc) {
+			release_sock(sk);
+			return rc;
+		}
+	} else if (sk->sk_state == TCP_ESTABLISHED) {
+		addr = &ipc->peer;
+	} else {
+		release_sock(sk);
+		return -ENOTCONN;
+	}
+
+	node = NULL;
+	if (addr->sq_node == QRTR_NODE_BCAST) {
+		if (addr->sq_port != QRTR_PORT_CTRL &&
+		    qrtr_local_nid != QRTR_NODE_BCAST) {
+			release_sock(sk);
+			return -ENOTCONN;
+		}
+		enqueue_fn = qrtr_bcast_enqueue;
+	} else if (addr->sq_node == ipc->us.sq_node) {
+		enqueue_fn = qrtr_local_enqueue;
+	} else {
+		node = qrtr_node_lookup(addr->sq_node);
+		if (!node) {
+			release_sock(sk);
+			return -ECONNRESET;
+		}
+		enqueue_fn = qrtr_node_enqueue;
+	}
+
+	plen = (len + 3) & ~3;
+	skb = sock_alloc_send_skb(sk, plen + QRTR_HDR_MAX_SIZE,
+				  msg->msg_flags & MSG_DONTWAIT, &rc);
+	if (!skb) {
+		rc = -ENOMEM;
+		goto out_node;
+	}
+
+	skb_reserve(skb, QRTR_HDR_MAX_SIZE);
+
+	rc = memcpy_from_msg(skb_put(skb, len), msg, len);
+	if (rc) {
+		kfree_skb(skb);
+		goto out_node;
+	}
+
+	if (ipc->us.sq_port == QRTR_PORT_CTRL) {
+		if (len < 4) {
+			rc = -EINVAL;
+			kfree_skb(skb);
+			goto out_node;
+		}
+
+		/* control messages already require the type as 'command' */
+		skb_copy_bits(skb, 0, &qrtr_type, 4);
+	}
+
+	type = le32_to_cpu(qrtr_type);
+	rc = enqueue_fn(node, skb, type, &ipc->us, addr);
+	if (rc >= 0)
+		rc = len;
+
+out_node:
+	qrtr_node_release(node);
+	release_sock(sk);
+
+	return rc;
+}
+
+static int qrtr_send_resume_tx(struct qrtr_cb *cb)
+{
+	struct sockaddr_qrtr remote = { AF_QIPCRTR, cb->src_node, cb->src_port };
+	struct sockaddr_qrtr local = { AF_QIPCRTR, cb->dst_node, cb->dst_port };
+	struct qrtr_ctrl_pkt *pkt;
+	struct qrtr_node *node;
+	struct sk_buff *skb;
+	int ret;
+
+	node = qrtr_node_lookup(remote.sq_node);
+	if (!node)
+		return -EINVAL;
+
+	skb = qrtr_alloc_ctrl_packet(&pkt, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	pkt->cmd = cpu_to_le32(QRTR_TYPE_RESUME_TX);
+	pkt->client.node = cpu_to_le32(cb->dst_node);
+	pkt->client.port = cpu_to_le32(cb->dst_port);
+
+	ret = qrtr_node_enqueue(node, skb, QRTR_TYPE_RESUME_TX, &local, &remote);
+
+	qrtr_node_release(node);
+
+	return ret;
+}
+
+static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
+			size_t size, int flags)
+{
+	DECLARE_SOCKADDR(struct sockaddr_qrtr *, addr, msg->msg_name);
+	struct sock *sk = sock->sk;
+	struct sk_buff *skb;
+	struct qrtr_cb *cb;
+	int copied, rc;
+
+	lock_sock(sk);
+
+	if (sock_flag(sk, SOCK_ZAPPED)) {
+		release_sock(sk);
+		return -EADDRNOTAVAIL;
+	}
+
+	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
+				flags & MSG_DONTWAIT, &rc);
+	if (!skb) {
+		release_sock(sk);
+		return rc;
+	}
+	cb = (struct qrtr_cb *)skb->cb;
+
+	copied = skb->len;
+	if (copied > size) {
+		copied = size;
+		msg->msg_flags |= MSG_TRUNC;
+	}
+
+	rc = skb_copy_datagram_msg(skb, 0, msg, copied);
+	if (rc < 0)
+		goto out;
+	rc = copied;
+
+	if (addr) {
+		/* There is an anonymous 2-byte hole after sq_family,
+		 * make sure to clear it.
+		 */
+		memset(addr, 0, sizeof(*addr));
+
+		addr->sq_family = AF_QIPCRTR;
+		addr->sq_node = cb->src_node;
+		addr->sq_port = cb->src_port;
+		msg->msg_namelen = sizeof(*addr);
+	}
+
+out:
+	if (cb->confirm_rx)
+		qrtr_send_resume_tx(cb);
+
+	skb_free_datagram(sk, skb);
+	release_sock(sk);
+
+	return rc;
+}
+
+static int qrtr_connect(struct socket *sock, struct sockaddr *saddr,
+			int len, int flags)
+{
+	DECLARE_SOCKADDR(struct sockaddr_qrtr *, addr, saddr);
+	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
+	struct sock *sk = sock->sk;
+	int rc;
+
+	if (len < sizeof(*addr) || addr->sq_family != AF_QIPCRTR)
+		return -EINVAL;
+
+	lock_sock(sk);
+
+	sk->sk_state = TCP_CLOSE;
+	sock->state = SS_UNCONNECTED;
+
+	rc = qrtr_autobind(sock);
+	if (rc) {
+		release_sock(sk);
+		return rc;
+	}
+
+	ipc->peer = *addr;
+	sock->state = SS_CONNECTED;
+	sk->sk_state = TCP_ESTABLISHED;
+
+	release_sock(sk);
+
+	return 0;
+}
+
+static int qrtr_getname(struct socket *sock, struct sockaddr *saddr,
+			int peer)
+{
+	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
+	struct sockaddr_qrtr qaddr;
+	struct sock *sk = sock->sk;
+
+	lock_sock(sk);
+	if (peer) {
+		if (sk->sk_state != TCP_ESTABLISHED) {
+			release_sock(sk);
+			return -ENOTCONN;
+		}
+
+		qaddr = ipc->peer;
+	} else {
+		qaddr = ipc->us;
+	}
+	release_sock(sk);
+
+	qaddr.sq_family = AF_QIPCRTR;
+
+	memcpy(saddr, &qaddr, sizeof(qaddr));
+
+	return sizeof(qaddr);
+}
+
+static int qrtr_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
+	struct sock *sk = sock->sk;
+	struct sockaddr_qrtr *sq;
+	struct sk_buff *skb;
+	struct ifreq ifr;
+	long len = 0;
+	int rc = 0;
+
+	lock_sock(sk);
+
+	switch (cmd) {
+	case TIOCOUTQ:
+		len = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
+		if (len < 0)
+			len = 0;
+		rc = put_user(len, (int __user *)argp);
+		break;
+	case TIOCINQ:
+		skb = skb_peek(&sk->sk_receive_queue);
+		if (skb)
+			len = skb->len;
+		rc = put_user(len, (int __user *)argp);
+		break;
+	case SIOCGIFADDR:
+		if (get_user_ifreq(&ifr, NULL, argp)) {
+			rc = -EFAULT;
+			break;
+		}
+
+		sq = (struct sockaddr_qrtr *)&ifr.ifr_addr;
+		*sq = ipc->us;
+		if (put_user_ifreq(&ifr, argp)) {
+			rc = -EFAULT;
+			break;
+		}
+		break;
+	case SIOCADDRT:
+	case SIOCDELRT:
+	case SIOCSIFADDR:
+	case SIOCGIFDSTADDR:
+	case SIOCSIFDSTADDR:
+	case SIOCGIFBRDADDR:
+	case SIOCSIFBRDADDR:
+	case SIOCGIFNETMASK:
+	case SIOCSIFNETMASK:
+		rc = -EINVAL;
+		break;
+	default:
+		rc = -ENOIOCTLCMD;
+		break;
+	}
+
+	release_sock(sk);
+
+	return rc;
+}
+
+static int qrtr_release(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	struct qrtr_sock *ipc;
+
+	if (!sk)
+		return 0;
+
+	lock_sock(sk);
+
+	ipc = qrtr_sk(sk);
+	sk->sk_shutdown = SHUTDOWN_MASK;
+	if (!sock_flag(sk, SOCK_DEAD))
+		sk->sk_state_change(sk);
+
+	sock_set_flag(sk, SOCK_DEAD);
+	sock_orphan(sk);
+	sock->sk = NULL;
+
+	if (!sock_flag(sk, SOCK_ZAPPED))
+		qrtr_port_remove(ipc);
+
+	skb_queue_purge(&sk->sk_receive_queue);
+
+	release_sock(sk);
+	sock_put(sk);
+
+	return 0;
+}
+
+static const struct proto_ops qrtr_proto_ops = {
+	.owner		= THIS_MODULE,
+	.family		= AF_QIPCRTR,
+	.bind		= qrtr_bind,
+	.connect	= qrtr_connect,
+	.socketpair	= sock_no_socketpair,
+	.accept		= sock_no_accept,
+	.listen		= sock_no_listen,
+	.sendmsg	= qrtr_sendmsg,
+	.recvmsg	= qrtr_recvmsg,
+	.getname	= qrtr_getname,
+	.ioctl		= qrtr_ioctl,
+	.gettstamp	= sock_gettstamp,
+	.poll		= datagram_poll,
+	.shutdown	= sock_no_shutdown,
+	.release	= qrtr_release,
+	.mmap		= sock_no_mmap,
+	.sendpage	= sock_no_sendpage,
+};
+
+static struct proto qrtr_proto = {
+	.name		= "QIPCRTR",
+	.owner		= THIS_MODULE,
+	.obj_size	= sizeof(struct qrtr_sock),
+};
+
+static int qrtr_create(struct net *net, struct socket *sock,
+		       int protocol, int kern)
+{
+	struct qrtr_sock *ipc;
+	struct sock *sk;
+
+	if (sock->type != SOCK_DGRAM)
+		return -EPROTOTYPE;
+
+	sk = sk_alloc(net, AF_QIPCRTR, GFP_KERNEL, &qrtr_proto, kern);
+	if (!sk)
+		return -ENOMEM;
+
+	sock_set_flag(sk, SOCK_ZAPPED);
+
+	sock_init_data(sock, sk);
+	sock->ops = &qrtr_proto_ops;
+
+	ipc = qrtr_sk(sk);
+	ipc->us.sq_family = AF_QIPCRTR;
+	ipc->us.sq_node = qrtr_local_nid;
+	ipc->us.sq_port = 0;
+
+	return 0;
+}
+
+static const struct net_proto_family qrtr_family = {
+	.owner	= THIS_MODULE,
+	.family	= AF_QIPCRTR,
+	.create	= qrtr_create,
+};
+
+static int __init qrtr_proto_init(void)
+{
+	int rc;
+
+	rc = proto_register(&qrtr_proto, 1);
+	if (rc)
+		return rc;
+
+	rc = sock_register(&qrtr_family);
+	if (rc)
+		goto err_proto;
+
+	rc = qrtr_ns_init();
+	if (rc)
+		goto err_sock;
+
+	return 0;
+
+err_sock:
+	sock_unregister(qrtr_family.family);
+err_proto:
+	proto_unregister(&qrtr_proto);
+	return rc;
+}
+postcore_initcall(qrtr_proto_init);
+
+static void __exit qrtr_proto_fini(void)
+{
+	qrtr_ns_remove();
+	sock_unregister(qrtr_family.family);
+	proto_unregister(&qrtr_proto);
+}
+module_exit(qrtr_proto_fini);
+
+MODULE_DESCRIPTION("Qualcomm IPC-router driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_NETPROTO(PF_QIPCRTR);
diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index e595079c2caf..3e40a1ba48f7 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -273,7 +273,7 @@ static struct qrtr_server *server_add(unsigned int service,
 	return NULL;
 }
 
-static int server_del(struct qrtr_node *node, unsigned int port)
+static int server_del(struct qrtr_node *node, unsigned int port, bool bcast)
 {
 	struct qrtr_lookup *lookup;
 	struct qrtr_server *srv;
@@ -286,7 +286,7 @@ static int server_del(struct qrtr_node *node, unsigned int port)
 	radix_tree_delete(&node->servers, port);
 
 	/* Broadcast the removal of local servers */
-	if (srv->node == qrtr_ns.local_node)
+	if (srv->node == qrtr_ns.local_node && bcast)
 		service_announce_del(&qrtr_ns.bcast_sq, srv);
 
 	/* Announce the service's disappearance to observers */
@@ -372,7 +372,7 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
 		}
 		slot = radix_tree_iter_resume(slot, &iter);
 		rcu_read_unlock();
-		server_del(node, srv->port);
+		server_del(node, srv->port, true);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
@@ -458,10 +458,13 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
 		kfree(lookup);
 	}
 
-	/* Remove the server belonging to this port */
+	/* Remove the server belonging to this port but don't broadcast
+	 * DEL_SERVER. Neighbours would've already removed the server belonging
+	 * to this port due to the DEL_CLIENT broadcast from qrtr_port_remove().
+	 */
 	node = node_get(node_id);
 	if (node)
-		server_del(node, port);
+		server_del(node, port, false);
 
 	/* Advertise the removal of this client to all local servers */
 	local_node = node_get(qrtr_ns.local_node);
@@ -566,7 +569,7 @@ static int ctrl_cmd_del_server(struct sockaddr_qrtr *from,
 	if (!node)
 		return -ENOENT;
 
-	return server_del(node, port);
+	return server_del(node, port, true);
 }
 
 static int ctrl_cmd_new_lookup(struct sockaddr_qrtr *from,
diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
deleted file mode 100644
index ec2322529727..000000000000
--- a/net/qrtr/qrtr.c
+++ /dev/null
@@ -1,1321 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright (c) 2015, Sony Mobile Communications Inc.
- * Copyright (c) 2013, The Linux Foundation. All rights reserved.
- */
-#include <linux/module.h>
-#include <linux/netlink.h>
-#include <linux/qrtr.h>
-#include <linux/termios.h>	/* For TIOCINQ/OUTQ */
-#include <linux/spinlock.h>
-#include <linux/wait.h>
-
-#include <net/sock.h>
-
-#include "qrtr.h"
-
-#define QRTR_PROTO_VER_1 1
-#define QRTR_PROTO_VER_2 3
-
-/* auto-bind range */
-#define QRTR_MIN_EPH_SOCKET 0x4000
-#define QRTR_MAX_EPH_SOCKET 0x7fff
-#define QRTR_EPH_PORT_RANGE \
-		XA_LIMIT(QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET)
-
-/**
- * struct qrtr_hdr_v1 - (I|R)PCrouter packet header version 1
- * @version: protocol version
- * @type: packet type; one of QRTR_TYPE_*
- * @src_node_id: source node
- * @src_port_id: source port
- * @confirm_rx: boolean; whether a resume-tx packet should be send in reply
- * @size: length of packet, excluding this header
- * @dst_node_id: destination node
- * @dst_port_id: destination port
- */
-struct qrtr_hdr_v1 {
-	__le32 version;
-	__le32 type;
-	__le32 src_node_id;
-	__le32 src_port_id;
-	__le32 confirm_rx;
-	__le32 size;
-	__le32 dst_node_id;
-	__le32 dst_port_id;
-} __packed;
-
-/**
- * struct qrtr_hdr_v2 - (I|R)PCrouter packet header later versions
- * @version: protocol version
- * @type: packet type; one of QRTR_TYPE_*
- * @flags: bitmask of QRTR_FLAGS_*
- * @optlen: length of optional header data
- * @size: length of packet, excluding this header and optlen
- * @src_node_id: source node
- * @src_port_id: source port
- * @dst_node_id: destination node
- * @dst_port_id: destination port
- */
-struct qrtr_hdr_v2 {
-	u8 version;
-	u8 type;
-	u8 flags;
-	u8 optlen;
-	__le32 size;
-	__le16 src_node_id;
-	__le16 src_port_id;
-	__le16 dst_node_id;
-	__le16 dst_port_id;
-};
-
-#define QRTR_FLAGS_CONFIRM_RX	BIT(0)
-
-struct qrtr_cb {
-	u32 src_node;
-	u32 src_port;
-	u32 dst_node;
-	u32 dst_port;
-
-	u8 type;
-	u8 confirm_rx;
-};
-
-#define QRTR_HDR_MAX_SIZE max_t(size_t, sizeof(struct qrtr_hdr_v1), \
-					sizeof(struct qrtr_hdr_v2))
-
-struct qrtr_sock {
-	/* WARNING: sk must be the first member */
-	struct sock sk;
-	struct sockaddr_qrtr us;
-	struct sockaddr_qrtr peer;
-};
-
-static inline struct qrtr_sock *qrtr_sk(struct sock *sk)
-{
-	BUILD_BUG_ON(offsetof(struct qrtr_sock, sk) != 0);
-	return container_of(sk, struct qrtr_sock, sk);
-}
-
-static unsigned int qrtr_local_nid = 1;
-
-/* for node ids */
-static RADIX_TREE(qrtr_nodes, GFP_ATOMIC);
-static DEFINE_SPINLOCK(qrtr_nodes_lock);
-/* broadcast list */
-static LIST_HEAD(qrtr_all_nodes);
-/* lock for qrtr_all_nodes and node reference */
-static DEFINE_MUTEX(qrtr_node_lock);
-
-/* local port allocation management */
-static DEFINE_XARRAY_ALLOC(qrtr_ports);
-
-/**
- * struct qrtr_node - endpoint node
- * @ep_lock: lock for endpoint management and callbacks
- * @ep: endpoint
- * @ref: reference count for node
- * @nid: node id
- * @qrtr_tx_flow: tree of qrtr_tx_flow, keyed by node << 32 | port
- * @qrtr_tx_lock: lock for qrtr_tx_flow inserts
- * @rx_queue: receive queue
- * @item: list item for broadcast list
- */
-struct qrtr_node {
-	struct mutex ep_lock;
-	struct qrtr_endpoint *ep;
-	struct kref ref;
-	unsigned int nid;
-
-	struct radix_tree_root qrtr_tx_flow;
-	struct mutex qrtr_tx_lock; /* for qrtr_tx_flow */
-
-	struct sk_buff_head rx_queue;
-	struct list_head item;
-};
-
-/**
- * struct qrtr_tx_flow - tx flow control
- * @resume_tx: waiters for a resume tx from the remote
- * @pending: number of waiting senders
- * @tx_failed: indicates that a message with confirm_rx flag was lost
- */
-struct qrtr_tx_flow {
-	struct wait_queue_head resume_tx;
-	int pending;
-	int tx_failed;
-};
-
-#define QRTR_TX_FLOW_HIGH	10
-#define QRTR_TX_FLOW_LOW	5
-
-static int qrtr_local_enqueue(struct qrtr_node *node, struct sk_buff *skb,
-			      int type, struct sockaddr_qrtr *from,
-			      struct sockaddr_qrtr *to);
-static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
-			      int type, struct sockaddr_qrtr *from,
-			      struct sockaddr_qrtr *to);
-static struct qrtr_sock *qrtr_port_lookup(int port);
-static void qrtr_port_put(struct qrtr_sock *ipc);
-
-/* Release node resources and free the node.
- *
- * Do not call directly, use qrtr_node_release.  To be used with
- * kref_put_mutex.  As such, the node mutex is expected to be locked on call.
- */
-static void __qrtr_node_release(struct kref *kref)
-{
-	struct qrtr_node *node = container_of(kref, struct qrtr_node, ref);
-	struct radix_tree_iter iter;
-	struct qrtr_tx_flow *flow;
-	unsigned long flags;
-	void __rcu **slot;
-
-	spin_lock_irqsave(&qrtr_nodes_lock, flags);
-	/* If the node is a bridge for other nodes, there are possibly
-	 * multiple entries pointing to our released node, delete them all.
-	 */
-	radix_tree_for_each_slot(slot, &qrtr_nodes, &iter, 0) {
-		if (*slot == node)
-			radix_tree_iter_delete(&qrtr_nodes, &iter, slot);
-	}
-	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
-
-	list_del(&node->item);
-	mutex_unlock(&qrtr_node_lock);
-
-	skb_queue_purge(&node->rx_queue);
-
-	/* Free tx flow counters */
-	radix_tree_for_each_slot(slot, &node->qrtr_tx_flow, &iter, 0) {
-		flow = *slot;
-		radix_tree_iter_delete(&node->qrtr_tx_flow, &iter, slot);
-		kfree(flow);
-	}
-	kfree(node);
-}
-
-/* Increment reference to node. */
-static struct qrtr_node *qrtr_node_acquire(struct qrtr_node *node)
-{
-	if (node)
-		kref_get(&node->ref);
-	return node;
-}
-
-/* Decrement reference to node and release as necessary. */
-static void qrtr_node_release(struct qrtr_node *node)
-{
-	if (!node)
-		return;
-	kref_put_mutex(&node->ref, __qrtr_node_release, &qrtr_node_lock);
-}
-
-/**
- * qrtr_tx_resume() - reset flow control counter
- * @node:	qrtr_node that the QRTR_TYPE_RESUME_TX packet arrived on
- * @skb:	resume_tx packet
- */
-static void qrtr_tx_resume(struct qrtr_node *node, struct sk_buff *skb)
-{
-	struct qrtr_ctrl_pkt *pkt = (struct qrtr_ctrl_pkt *)skb->data;
-	u64 remote_node = le32_to_cpu(pkt->client.node);
-	u32 remote_port = le32_to_cpu(pkt->client.port);
-	struct qrtr_tx_flow *flow;
-	unsigned long key;
-
-	key = remote_node << 32 | remote_port;
-
-	rcu_read_lock();
-	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
-	rcu_read_unlock();
-	if (flow) {
-		spin_lock(&flow->resume_tx.lock);
-		flow->pending = 0;
-		spin_unlock(&flow->resume_tx.lock);
-		wake_up_interruptible_all(&flow->resume_tx);
-	}
-
-	consume_skb(skb);
-}
-
-/**
- * qrtr_tx_wait() - flow control for outgoing packets
- * @node:	qrtr_node that the packet is to be send to
- * @dest_node:	node id of the destination
- * @dest_port:	port number of the destination
- * @type:	type of message
- *
- * The flow control scheme is based around the low and high "watermarks". When
- * the low watermark is passed the confirm_rx flag is set on the outgoing
- * message, which will trigger the remote to send a control message of the type
- * QRTR_TYPE_RESUME_TX to reset the counter. If the high watermark is hit
- * further transmision should be paused.
- *
- * Return: 1 if confirm_rx should be set, 0 otherwise or errno failure
- */
-static int qrtr_tx_wait(struct qrtr_node *node, int dest_node, int dest_port,
-			int type)
-{
-	unsigned long key = (u64)dest_node << 32 | dest_port;
-	struct qrtr_tx_flow *flow;
-	int confirm_rx = 0;
-	int ret;
-
-	/* Never set confirm_rx on non-data packets */
-	if (type != QRTR_TYPE_DATA)
-		return 0;
-
-	mutex_lock(&node->qrtr_tx_lock);
-	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
-	if (!flow) {
-		flow = kzalloc(sizeof(*flow), GFP_KERNEL);
-		if (flow) {
-			init_waitqueue_head(&flow->resume_tx);
-			if (radix_tree_insert(&node->qrtr_tx_flow, key, flow)) {
-				kfree(flow);
-				flow = NULL;
-			}
-		}
-	}
-	mutex_unlock(&node->qrtr_tx_lock);
-
-	/* Set confirm_rx if we where unable to find and allocate a flow */
-	if (!flow)
-		return 1;
-
-	spin_lock_irq(&flow->resume_tx.lock);
-	ret = wait_event_interruptible_locked_irq(flow->resume_tx,
-						  flow->pending < QRTR_TX_FLOW_HIGH ||
-						  flow->tx_failed ||
-						  !node->ep);
-	if (ret < 0) {
-		confirm_rx = ret;
-	} else if (!node->ep) {
-		confirm_rx = -EPIPE;
-	} else if (flow->tx_failed) {
-		flow->tx_failed = 0;
-		confirm_rx = 1;
-	} else {
-		flow->pending++;
-		confirm_rx = flow->pending == QRTR_TX_FLOW_LOW;
-	}
-	spin_unlock_irq(&flow->resume_tx.lock);
-
-	return confirm_rx;
-}
-
-/**
- * qrtr_tx_flow_failed() - flag that tx of confirm_rx flagged messages failed
- * @node:	qrtr_node that the packet is to be send to
- * @dest_node:	node id of the destination
- * @dest_port:	port number of the destination
- *
- * Signal that the transmission of a message with confirm_rx flag failed. The
- * flow's "pending" counter will keep incrementing towards QRTR_TX_FLOW_HIGH,
- * at which point transmission would stall forever waiting for the resume TX
- * message associated with the dropped confirm_rx message.
- * Work around this by marking the flow as having a failed transmission and
- * cause the next transmission attempt to be sent with the confirm_rx.
- */
-static void qrtr_tx_flow_failed(struct qrtr_node *node, int dest_node,
-				int dest_port)
-{
-	unsigned long key = (u64)dest_node << 32 | dest_port;
-	struct qrtr_tx_flow *flow;
-
-	rcu_read_lock();
-	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
-	rcu_read_unlock();
-	if (flow) {
-		spin_lock_irq(&flow->resume_tx.lock);
-		flow->tx_failed = 1;
-		spin_unlock_irq(&flow->resume_tx.lock);
-	}
-}
-
-/* Pass an outgoing packet socket buffer to the endpoint driver. */
-static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
-			     int type, struct sockaddr_qrtr *from,
-			     struct sockaddr_qrtr *to)
-{
-	struct qrtr_hdr_v1 *hdr;
-	size_t len = skb->len;
-	int rc, confirm_rx;
-
-	confirm_rx = qrtr_tx_wait(node, to->sq_node, to->sq_port, type);
-	if (confirm_rx < 0) {
-		kfree_skb(skb);
-		return confirm_rx;
-	}
-
-	hdr = skb_push(skb, sizeof(*hdr));
-	hdr->version = cpu_to_le32(QRTR_PROTO_VER_1);
-	hdr->type = cpu_to_le32(type);
-	hdr->src_node_id = cpu_to_le32(from->sq_node);
-	hdr->src_port_id = cpu_to_le32(from->sq_port);
-	if (to->sq_port == QRTR_PORT_CTRL) {
-		hdr->dst_node_id = cpu_to_le32(node->nid);
-		hdr->dst_port_id = cpu_to_le32(QRTR_PORT_CTRL);
-	} else {
-		hdr->dst_node_id = cpu_to_le32(to->sq_node);
-		hdr->dst_port_id = cpu_to_le32(to->sq_port);
-	}
-
-	hdr->size = cpu_to_le32(len);
-	hdr->confirm_rx = !!confirm_rx;
-
-	rc = skb_put_padto(skb, ALIGN(len, 4) + sizeof(*hdr));
-
-	if (!rc) {
-		mutex_lock(&node->ep_lock);
-		rc = -ENODEV;
-		if (node->ep)
-			rc = node->ep->xmit(node->ep, skb);
-		else
-			kfree_skb(skb);
-		mutex_unlock(&node->ep_lock);
-	}
-	/* Need to ensure that a subsequent message carries the otherwise lost
-	 * confirm_rx flag if we dropped this one */
-	if (rc && confirm_rx)
-		qrtr_tx_flow_failed(node, to->sq_node, to->sq_port);
-
-	return rc;
-}
-
-/* Lookup node by id.
- *
- * callers must release with qrtr_node_release()
- */
-static struct qrtr_node *qrtr_node_lookup(unsigned int nid)
-{
-	struct qrtr_node *node;
-	unsigned long flags;
-
-	spin_lock_irqsave(&qrtr_nodes_lock, flags);
-	node = radix_tree_lookup(&qrtr_nodes, nid);
-	node = qrtr_node_acquire(node);
-	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
-
-	return node;
-}
-
-/* Assign node id to node.
- *
- * This is mostly useful for automatic node id assignment, based on
- * the source id in the incoming packet.
- */
-static void qrtr_node_assign(struct qrtr_node *node, unsigned int nid)
-{
-	unsigned long flags;
-
-	if (nid == QRTR_EP_NID_AUTO)
-		return;
-
-	spin_lock_irqsave(&qrtr_nodes_lock, flags);
-	radix_tree_insert(&qrtr_nodes, nid, node);
-	if (node->nid == QRTR_EP_NID_AUTO)
-		node->nid = nid;
-	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
-}
-
-/**
- * qrtr_endpoint_post() - post incoming data
- * @ep: endpoint handle
- * @data: data pointer
- * @len: size of data in bytes
- *
- * Return: 0 on success; negative error code on failure
- */
-int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
-{
-	struct qrtr_node *node = ep->node;
-	const struct qrtr_hdr_v1 *v1;
-	const struct qrtr_hdr_v2 *v2;
-	struct qrtr_sock *ipc;
-	struct sk_buff *skb;
-	struct qrtr_cb *cb;
-	size_t size;
-	unsigned int ver;
-	size_t hdrlen;
-
-	if (len == 0 || len & 3)
-		return -EINVAL;
-
-	skb = __netdev_alloc_skb(NULL, len, GFP_ATOMIC | __GFP_NOWARN);
-	if (!skb)
-		return -ENOMEM;
-
-	cb = (struct qrtr_cb *)skb->cb;
-
-	/* Version field in v1 is little endian, so this works for both cases */
-	ver = *(u8*)data;
-
-	switch (ver) {
-	case QRTR_PROTO_VER_1:
-		if (len < sizeof(*v1))
-			goto err;
-		v1 = data;
-		hdrlen = sizeof(*v1);
-
-		cb->type = le32_to_cpu(v1->type);
-		cb->src_node = le32_to_cpu(v1->src_node_id);
-		cb->src_port = le32_to_cpu(v1->src_port_id);
-		cb->confirm_rx = !!v1->confirm_rx;
-		cb->dst_node = le32_to_cpu(v1->dst_node_id);
-		cb->dst_port = le32_to_cpu(v1->dst_port_id);
-
-		size = le32_to_cpu(v1->size);
-		break;
-	case QRTR_PROTO_VER_2:
-		if (len < sizeof(*v2))
-			goto err;
-		v2 = data;
-		hdrlen = sizeof(*v2) + v2->optlen;
-
-		cb->type = v2->type;
-		cb->confirm_rx = !!(v2->flags & QRTR_FLAGS_CONFIRM_RX);
-		cb->src_node = le16_to_cpu(v2->src_node_id);
-		cb->src_port = le16_to_cpu(v2->src_port_id);
-		cb->dst_node = le16_to_cpu(v2->dst_node_id);
-		cb->dst_port = le16_to_cpu(v2->dst_port_id);
-
-		if (cb->src_port == (u16)QRTR_PORT_CTRL)
-			cb->src_port = QRTR_PORT_CTRL;
-		if (cb->dst_port == (u16)QRTR_PORT_CTRL)
-			cb->dst_port = QRTR_PORT_CTRL;
-
-		size = le32_to_cpu(v2->size);
-		break;
-	default:
-		pr_err("qrtr: Invalid version %d\n", ver);
-		goto err;
-	}
-
-	if (!size || len != ALIGN(size, 4) + hdrlen)
-		goto err;
-
-	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
-	    cb->type != QRTR_TYPE_RESUME_TX)
-		goto err;
-
-	skb_put_data(skb, data + hdrlen, size);
-
-	qrtr_node_assign(node, cb->src_node);
-
-	if (cb->type == QRTR_TYPE_NEW_SERVER) {
-		/* Remote node endpoint can bridge other distant nodes */
-		const struct qrtr_ctrl_pkt *pkt;
-
-		if (size < sizeof(*pkt))
-			goto err;
-
-		pkt = data + hdrlen;
-		qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
-	}
-
-	if (cb->type == QRTR_TYPE_RESUME_TX) {
-		qrtr_tx_resume(node, skb);
-	} else {
-		ipc = qrtr_port_lookup(cb->dst_port);
-		if (!ipc)
-			goto err;
-
-		if (sock_queue_rcv_skb(&ipc->sk, skb)) {
-			qrtr_port_put(ipc);
-			goto err;
-		}
-
-		qrtr_port_put(ipc);
-	}
-
-	return 0;
-
-err:
-	kfree_skb(skb);
-	return -EINVAL;
-
-}
-EXPORT_SYMBOL_GPL(qrtr_endpoint_post);
-
-/**
- * qrtr_alloc_ctrl_packet() - allocate control packet skb
- * @pkt: reference to qrtr_ctrl_pkt pointer
- * @flags: the type of memory to allocate
- *
- * Returns newly allocated sk_buff, or NULL on failure
- *
- * This function allocates a sk_buff large enough to carry a qrtr_ctrl_pkt and
- * on success returns a reference to the control packet in @pkt.
- */
-static struct sk_buff *qrtr_alloc_ctrl_packet(struct qrtr_ctrl_pkt **pkt,
-					      gfp_t flags)
-{
-	const int pkt_len = sizeof(struct qrtr_ctrl_pkt);
-	struct sk_buff *skb;
-
-	skb = alloc_skb(QRTR_HDR_MAX_SIZE + pkt_len, flags);
-	if (!skb)
-		return NULL;
-
-	skb_reserve(skb, QRTR_HDR_MAX_SIZE);
-	*pkt = skb_put_zero(skb, pkt_len);
-
-	return skb;
-}
-
-/**
- * qrtr_endpoint_register() - register a new endpoint
- * @ep: endpoint to register
- * @nid: desired node id; may be QRTR_EP_NID_AUTO for auto-assignment
- * Return: 0 on success; negative error code on failure
- *
- * The specified endpoint must have the xmit function pointer set on call.
- */
-int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
-{
-	struct qrtr_node *node;
-
-	if (!ep || !ep->xmit)
-		return -EINVAL;
-
-	node = kzalloc(sizeof(*node), GFP_KERNEL);
-	if (!node)
-		return -ENOMEM;
-
-	kref_init(&node->ref);
-	mutex_init(&node->ep_lock);
-	skb_queue_head_init(&node->rx_queue);
-	node->nid = QRTR_EP_NID_AUTO;
-	node->ep = ep;
-
-	INIT_RADIX_TREE(&node->qrtr_tx_flow, GFP_KERNEL);
-	mutex_init(&node->qrtr_tx_lock);
-
-	qrtr_node_assign(node, nid);
-
-	mutex_lock(&qrtr_node_lock);
-	list_add(&node->item, &qrtr_all_nodes);
-	mutex_unlock(&qrtr_node_lock);
-	ep->node = node;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(qrtr_endpoint_register);
-
-/**
- * qrtr_endpoint_unregister - unregister endpoint
- * @ep: endpoint to unregister
- */
-void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
-{
-	struct qrtr_node *node = ep->node;
-	struct sockaddr_qrtr src = {AF_QIPCRTR, node->nid, QRTR_PORT_CTRL};
-	struct sockaddr_qrtr dst = {AF_QIPCRTR, qrtr_local_nid, QRTR_PORT_CTRL};
-	struct radix_tree_iter iter;
-	struct qrtr_ctrl_pkt *pkt;
-	struct qrtr_tx_flow *flow;
-	struct sk_buff *skb;
-	unsigned long flags;
-	void __rcu **slot;
-
-	mutex_lock(&node->ep_lock);
-	node->ep = NULL;
-	mutex_unlock(&node->ep_lock);
-
-	/* Notify the local controller about the event */
-	spin_lock_irqsave(&qrtr_nodes_lock, flags);
-	radix_tree_for_each_slot(slot, &qrtr_nodes, &iter, 0) {
-		if (*slot != node)
-			continue;
-		src.sq_node = iter.index;
-		skb = qrtr_alloc_ctrl_packet(&pkt, GFP_ATOMIC);
-		if (skb) {
-			pkt->cmd = cpu_to_le32(QRTR_TYPE_BYE);
-			qrtr_local_enqueue(NULL, skb, QRTR_TYPE_BYE, &src, &dst);
-		}
-	}
-	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
-
-	/* Wake up any transmitters waiting for resume-tx from the node */
-	mutex_lock(&node->qrtr_tx_lock);
-	radix_tree_for_each_slot(slot, &node->qrtr_tx_flow, &iter, 0) {
-		flow = *slot;
-		wake_up_interruptible_all(&flow->resume_tx);
-	}
-	mutex_unlock(&node->qrtr_tx_lock);
-
-	qrtr_node_release(node);
-	ep->node = NULL;
-}
-EXPORT_SYMBOL_GPL(qrtr_endpoint_unregister);
-
-/* Lookup socket by port.
- *
- * Callers must release with qrtr_port_put()
- */
-static struct qrtr_sock *qrtr_port_lookup(int port)
-{
-	struct qrtr_sock *ipc;
-
-	if (port == QRTR_PORT_CTRL)
-		port = 0;
-
-	rcu_read_lock();
-	ipc = xa_load(&qrtr_ports, port);
-	if (ipc)
-		sock_hold(&ipc->sk);
-	rcu_read_unlock();
-
-	return ipc;
-}
-
-/* Release acquired socket. */
-static void qrtr_port_put(struct qrtr_sock *ipc)
-{
-	sock_put(&ipc->sk);
-}
-
-/* Remove port assignment. */
-static void qrtr_port_remove(struct qrtr_sock *ipc)
-{
-	struct qrtr_ctrl_pkt *pkt;
-	struct sk_buff *skb;
-	int port = ipc->us.sq_port;
-	struct sockaddr_qrtr to;
-
-	to.sq_family = AF_QIPCRTR;
-	to.sq_node = QRTR_NODE_BCAST;
-	to.sq_port = QRTR_PORT_CTRL;
-
-	skb = qrtr_alloc_ctrl_packet(&pkt, GFP_KERNEL);
-	if (skb) {
-		pkt->cmd = cpu_to_le32(QRTR_TYPE_DEL_CLIENT);
-		pkt->client.node = cpu_to_le32(ipc->us.sq_node);
-		pkt->client.port = cpu_to_le32(ipc->us.sq_port);
-
-		skb_set_owner_w(skb, &ipc->sk);
-		qrtr_bcast_enqueue(NULL, skb, QRTR_TYPE_DEL_CLIENT, &ipc->us,
-				   &to);
-	}
-
-	if (port == QRTR_PORT_CTRL)
-		port = 0;
-
-	__sock_put(&ipc->sk);
-
-	xa_erase(&qrtr_ports, port);
-
-	/* Ensure that if qrtr_port_lookup() did enter the RCU read section we
-	 * wait for it to up increment the refcount */
-	synchronize_rcu();
-}
-
-/* Assign port number to socket.
- *
- * Specify port in the integer pointed to by port, and it will be adjusted
- * on return as necesssary.
- *
- * Port may be:
- *   0: Assign ephemeral port in [QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET]
- *   <QRTR_MIN_EPH_SOCKET: Specified; requires CAP_NET_ADMIN
- *   >QRTR_MIN_EPH_SOCKET: Specified; available to all
- */
-static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
-{
-	int rc;
-
-	if (!*port) {
-		rc = xa_alloc(&qrtr_ports, port, ipc, QRTR_EPH_PORT_RANGE,
-				GFP_KERNEL);
-	} else if (*port < QRTR_MIN_EPH_SOCKET && !capable(CAP_NET_ADMIN)) {
-		rc = -EACCES;
-	} else if (*port == QRTR_PORT_CTRL) {
-		rc = xa_insert(&qrtr_ports, 0, ipc, GFP_KERNEL);
-	} else {
-		rc = xa_insert(&qrtr_ports, *port, ipc, GFP_KERNEL);
-	}
-
-	if (rc == -EBUSY)
-		return -EADDRINUSE;
-	else if (rc < 0)
-		return rc;
-
-	sock_hold(&ipc->sk);
-
-	return 0;
-}
-
-/* Reset all non-control ports */
-static void qrtr_reset_ports(void)
-{
-	struct qrtr_sock *ipc;
-	unsigned long index;
-
-	rcu_read_lock();
-	xa_for_each_start(&qrtr_ports, index, ipc, 1) {
-		sock_hold(&ipc->sk);
-		ipc->sk.sk_err = ENETRESET;
-		sk_error_report(&ipc->sk);
-		sock_put(&ipc->sk);
-	}
-	rcu_read_unlock();
-}
-
-/* Bind socket to address.
- *
- * Socket should be locked upon call.
- */
-static int __qrtr_bind(struct socket *sock,
-		       const struct sockaddr_qrtr *addr, int zapped)
-{
-	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
-	struct sock *sk = sock->sk;
-	int port;
-	int rc;
-
-	/* rebinding ok */
-	if (!zapped && addr->sq_port == ipc->us.sq_port)
-		return 0;
-
-	port = addr->sq_port;
-	rc = qrtr_port_assign(ipc, &port);
-	if (rc)
-		return rc;
-
-	/* unbind previous, if any */
-	if (!zapped)
-		qrtr_port_remove(ipc);
-	ipc->us.sq_port = port;
-
-	sock_reset_flag(sk, SOCK_ZAPPED);
-
-	/* Notify all open ports about the new controller */
-	if (port == QRTR_PORT_CTRL)
-		qrtr_reset_ports();
-
-	return 0;
-}
-
-/* Auto bind to an ephemeral port. */
-static int qrtr_autobind(struct socket *sock)
-{
-	struct sock *sk = sock->sk;
-	struct sockaddr_qrtr addr;
-
-	if (!sock_flag(sk, SOCK_ZAPPED))
-		return 0;
-
-	addr.sq_family = AF_QIPCRTR;
-	addr.sq_node = qrtr_local_nid;
-	addr.sq_port = 0;
-
-	return __qrtr_bind(sock, &addr, 1);
-}
-
-/* Bind socket to specified sockaddr. */
-static int qrtr_bind(struct socket *sock, struct sockaddr *saddr, int len)
-{
-	DECLARE_SOCKADDR(struct sockaddr_qrtr *, addr, saddr);
-	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
-	struct sock *sk = sock->sk;
-	int rc;
-
-	if (len < sizeof(*addr) || addr->sq_family != AF_QIPCRTR)
-		return -EINVAL;
-
-	if (addr->sq_node != ipc->us.sq_node)
-		return -EINVAL;
-
-	lock_sock(sk);
-	rc = __qrtr_bind(sock, addr, sock_flag(sk, SOCK_ZAPPED));
-	release_sock(sk);
-
-	return rc;
-}
-
-/* Queue packet to local peer socket. */
-static int qrtr_local_enqueue(struct qrtr_node *node, struct sk_buff *skb,
-			      int type, struct sockaddr_qrtr *from,
-			      struct sockaddr_qrtr *to)
-{
-	struct qrtr_sock *ipc;
-	struct qrtr_cb *cb;
-
-	ipc = qrtr_port_lookup(to->sq_port);
-	if (!ipc || &ipc->sk == skb->sk) { /* do not send to self */
-		if (ipc)
-			qrtr_port_put(ipc);
-		kfree_skb(skb);
-		return -ENODEV;
-	}
-
-	cb = (struct qrtr_cb *)skb->cb;
-	cb->src_node = from->sq_node;
-	cb->src_port = from->sq_port;
-
-	if (sock_queue_rcv_skb(&ipc->sk, skb)) {
-		qrtr_port_put(ipc);
-		kfree_skb(skb);
-		return -ENOSPC;
-	}
-
-	qrtr_port_put(ipc);
-
-	return 0;
-}
-
-/* Queue packet for broadcast. */
-static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
-			      int type, struct sockaddr_qrtr *from,
-			      struct sockaddr_qrtr *to)
-{
-	struct sk_buff *skbn;
-
-	mutex_lock(&qrtr_node_lock);
-	list_for_each_entry(node, &qrtr_all_nodes, item) {
-		skbn = skb_clone(skb, GFP_KERNEL);
-		if (!skbn)
-			break;
-		skb_set_owner_w(skbn, skb->sk);
-		qrtr_node_enqueue(node, skbn, type, from, to);
-	}
-	mutex_unlock(&qrtr_node_lock);
-
-	qrtr_local_enqueue(NULL, skb, type, from, to);
-
-	return 0;
-}
-
-static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
-{
-	DECLARE_SOCKADDR(struct sockaddr_qrtr *, addr, msg->msg_name);
-	int (*enqueue_fn)(struct qrtr_node *, struct sk_buff *, int,
-			  struct sockaddr_qrtr *, struct sockaddr_qrtr *);
-	__le32 qrtr_type = cpu_to_le32(QRTR_TYPE_DATA);
-	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
-	struct sock *sk = sock->sk;
-	struct qrtr_node *node;
-	struct sk_buff *skb;
-	size_t plen;
-	u32 type;
-	int rc;
-
-	if (msg->msg_flags & ~(MSG_DONTWAIT))
-		return -EINVAL;
-
-	if (len > 65535)
-		return -EMSGSIZE;
-
-	lock_sock(sk);
-
-	if (addr) {
-		if (msg->msg_namelen < sizeof(*addr)) {
-			release_sock(sk);
-			return -EINVAL;
-		}
-
-		if (addr->sq_family != AF_QIPCRTR) {
-			release_sock(sk);
-			return -EINVAL;
-		}
-
-		rc = qrtr_autobind(sock);
-		if (rc) {
-			release_sock(sk);
-			return rc;
-		}
-	} else if (sk->sk_state == TCP_ESTABLISHED) {
-		addr = &ipc->peer;
-	} else {
-		release_sock(sk);
-		return -ENOTCONN;
-	}
-
-	node = NULL;
-	if (addr->sq_node == QRTR_NODE_BCAST) {
-		if (addr->sq_port != QRTR_PORT_CTRL &&
-		    qrtr_local_nid != QRTR_NODE_BCAST) {
-			release_sock(sk);
-			return -ENOTCONN;
-		}
-		enqueue_fn = qrtr_bcast_enqueue;
-	} else if (addr->sq_node == ipc->us.sq_node) {
-		enqueue_fn = qrtr_local_enqueue;
-	} else {
-		node = qrtr_node_lookup(addr->sq_node);
-		if (!node) {
-			release_sock(sk);
-			return -ECONNRESET;
-		}
-		enqueue_fn = qrtr_node_enqueue;
-	}
-
-	plen = (len + 3) & ~3;
-	skb = sock_alloc_send_skb(sk, plen + QRTR_HDR_MAX_SIZE,
-				  msg->msg_flags & MSG_DONTWAIT, &rc);
-	if (!skb) {
-		rc = -ENOMEM;
-		goto out_node;
-	}
-
-	skb_reserve(skb, QRTR_HDR_MAX_SIZE);
-
-	rc = memcpy_from_msg(skb_put(skb, len), msg, len);
-	if (rc) {
-		kfree_skb(skb);
-		goto out_node;
-	}
-
-	if (ipc->us.sq_port == QRTR_PORT_CTRL) {
-		if (len < 4) {
-			rc = -EINVAL;
-			kfree_skb(skb);
-			goto out_node;
-		}
-
-		/* control messages already require the type as 'command' */
-		skb_copy_bits(skb, 0, &qrtr_type, 4);
-	}
-
-	type = le32_to_cpu(qrtr_type);
-	rc = enqueue_fn(node, skb, type, &ipc->us, addr);
-	if (rc >= 0)
-		rc = len;
-
-out_node:
-	qrtr_node_release(node);
-	release_sock(sk);
-
-	return rc;
-}
-
-static int qrtr_send_resume_tx(struct qrtr_cb *cb)
-{
-	struct sockaddr_qrtr remote = { AF_QIPCRTR, cb->src_node, cb->src_port };
-	struct sockaddr_qrtr local = { AF_QIPCRTR, cb->dst_node, cb->dst_port };
-	struct qrtr_ctrl_pkt *pkt;
-	struct qrtr_node *node;
-	struct sk_buff *skb;
-	int ret;
-
-	node = qrtr_node_lookup(remote.sq_node);
-	if (!node)
-		return -EINVAL;
-
-	skb = qrtr_alloc_ctrl_packet(&pkt, GFP_KERNEL);
-	if (!skb)
-		return -ENOMEM;
-
-	pkt->cmd = cpu_to_le32(QRTR_TYPE_RESUME_TX);
-	pkt->client.node = cpu_to_le32(cb->dst_node);
-	pkt->client.port = cpu_to_le32(cb->dst_port);
-
-	ret = qrtr_node_enqueue(node, skb, QRTR_TYPE_RESUME_TX, &local, &remote);
-
-	qrtr_node_release(node);
-
-	return ret;
-}
-
-static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
-			size_t size, int flags)
-{
-	DECLARE_SOCKADDR(struct sockaddr_qrtr *, addr, msg->msg_name);
-	struct sock *sk = sock->sk;
-	struct sk_buff *skb;
-	struct qrtr_cb *cb;
-	int copied, rc;
-
-	lock_sock(sk);
-
-	if (sock_flag(sk, SOCK_ZAPPED)) {
-		release_sock(sk);
-		return -EADDRNOTAVAIL;
-	}
-
-	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
-				flags & MSG_DONTWAIT, &rc);
-	if (!skb) {
-		release_sock(sk);
-		return rc;
-	}
-	cb = (struct qrtr_cb *)skb->cb;
-
-	copied = skb->len;
-	if (copied > size) {
-		copied = size;
-		msg->msg_flags |= MSG_TRUNC;
-	}
-
-	rc = skb_copy_datagram_msg(skb, 0, msg, copied);
-	if (rc < 0)
-		goto out;
-	rc = copied;
-
-	if (addr) {
-		/* There is an anonymous 2-byte hole after sq_family,
-		 * make sure to clear it.
-		 */
-		memset(addr, 0, sizeof(*addr));
-
-		addr->sq_family = AF_QIPCRTR;
-		addr->sq_node = cb->src_node;
-		addr->sq_port = cb->src_port;
-		msg->msg_namelen = sizeof(*addr);
-	}
-
-out:
-	if (cb->confirm_rx)
-		qrtr_send_resume_tx(cb);
-
-	skb_free_datagram(sk, skb);
-	release_sock(sk);
-
-	return rc;
-}
-
-static int qrtr_connect(struct socket *sock, struct sockaddr *saddr,
-			int len, int flags)
-{
-	DECLARE_SOCKADDR(struct sockaddr_qrtr *, addr, saddr);
-	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
-	struct sock *sk = sock->sk;
-	int rc;
-
-	if (len < sizeof(*addr) || addr->sq_family != AF_QIPCRTR)
-		return -EINVAL;
-
-	lock_sock(sk);
-
-	sk->sk_state = TCP_CLOSE;
-	sock->state = SS_UNCONNECTED;
-
-	rc = qrtr_autobind(sock);
-	if (rc) {
-		release_sock(sk);
-		return rc;
-	}
-
-	ipc->peer = *addr;
-	sock->state = SS_CONNECTED;
-	sk->sk_state = TCP_ESTABLISHED;
-
-	release_sock(sk);
-
-	return 0;
-}
-
-static int qrtr_getname(struct socket *sock, struct sockaddr *saddr,
-			int peer)
-{
-	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
-	struct sockaddr_qrtr qaddr;
-	struct sock *sk = sock->sk;
-
-	lock_sock(sk);
-	if (peer) {
-		if (sk->sk_state != TCP_ESTABLISHED) {
-			release_sock(sk);
-			return -ENOTCONN;
-		}
-
-		qaddr = ipc->peer;
-	} else {
-		qaddr = ipc->us;
-	}
-	release_sock(sk);
-
-	qaddr.sq_family = AF_QIPCRTR;
-
-	memcpy(saddr, &qaddr, sizeof(qaddr));
-
-	return sizeof(qaddr);
-}
-
-static int qrtr_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
-	struct sock *sk = sock->sk;
-	struct sockaddr_qrtr *sq;
-	struct sk_buff *skb;
-	struct ifreq ifr;
-	long len = 0;
-	int rc = 0;
-
-	lock_sock(sk);
-
-	switch (cmd) {
-	case TIOCOUTQ:
-		len = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
-		if (len < 0)
-			len = 0;
-		rc = put_user(len, (int __user *)argp);
-		break;
-	case TIOCINQ:
-		skb = skb_peek(&sk->sk_receive_queue);
-		if (skb)
-			len = skb->len;
-		rc = put_user(len, (int __user *)argp);
-		break;
-	case SIOCGIFADDR:
-		if (get_user_ifreq(&ifr, NULL, argp)) {
-			rc = -EFAULT;
-			break;
-		}
-
-		sq = (struct sockaddr_qrtr *)&ifr.ifr_addr;
-		*sq = ipc->us;
-		if (put_user_ifreq(&ifr, argp)) {
-			rc = -EFAULT;
-			break;
-		}
-		break;
-	case SIOCADDRT:
-	case SIOCDELRT:
-	case SIOCSIFADDR:
-	case SIOCGIFDSTADDR:
-	case SIOCSIFDSTADDR:
-	case SIOCGIFBRDADDR:
-	case SIOCSIFBRDADDR:
-	case SIOCGIFNETMASK:
-	case SIOCSIFNETMASK:
-		rc = -EINVAL;
-		break;
-	default:
-		rc = -ENOIOCTLCMD;
-		break;
-	}
-
-	release_sock(sk);
-
-	return rc;
-}
-
-static int qrtr_release(struct socket *sock)
-{
-	struct sock *sk = sock->sk;
-	struct qrtr_sock *ipc;
-
-	if (!sk)
-		return 0;
-
-	lock_sock(sk);
-
-	ipc = qrtr_sk(sk);
-	sk->sk_shutdown = SHUTDOWN_MASK;
-	if (!sock_flag(sk, SOCK_DEAD))
-		sk->sk_state_change(sk);
-
-	sock_set_flag(sk, SOCK_DEAD);
-	sock_orphan(sk);
-	sock->sk = NULL;
-
-	if (!sock_flag(sk, SOCK_ZAPPED))
-		qrtr_port_remove(ipc);
-
-	skb_queue_purge(&sk->sk_receive_queue);
-
-	release_sock(sk);
-	sock_put(sk);
-
-	return 0;
-}
-
-static const struct proto_ops qrtr_proto_ops = {
-	.owner		= THIS_MODULE,
-	.family		= AF_QIPCRTR,
-	.bind		= qrtr_bind,
-	.connect	= qrtr_connect,
-	.socketpair	= sock_no_socketpair,
-	.accept		= sock_no_accept,
-	.listen		= sock_no_listen,
-	.sendmsg	= qrtr_sendmsg,
-	.recvmsg	= qrtr_recvmsg,
-	.getname	= qrtr_getname,
-	.ioctl		= qrtr_ioctl,
-	.gettstamp	= sock_gettstamp,
-	.poll		= datagram_poll,
-	.shutdown	= sock_no_shutdown,
-	.release	= qrtr_release,
-	.mmap		= sock_no_mmap,
-	.sendpage	= sock_no_sendpage,
-};
-
-static struct proto qrtr_proto = {
-	.name		= "QIPCRTR",
-	.owner		= THIS_MODULE,
-	.obj_size	= sizeof(struct qrtr_sock),
-};
-
-static int qrtr_create(struct net *net, struct socket *sock,
-		       int protocol, int kern)
-{
-	struct qrtr_sock *ipc;
-	struct sock *sk;
-
-	if (sock->type != SOCK_DGRAM)
-		return -EPROTOTYPE;
-
-	sk = sk_alloc(net, AF_QIPCRTR, GFP_KERNEL, &qrtr_proto, kern);
-	if (!sk)
-		return -ENOMEM;
-
-	sock_set_flag(sk, SOCK_ZAPPED);
-
-	sock_init_data(sock, sk);
-	sock->ops = &qrtr_proto_ops;
-
-	ipc = qrtr_sk(sk);
-	ipc->us.sq_family = AF_QIPCRTR;
-	ipc->us.sq_node = qrtr_local_nid;
-	ipc->us.sq_port = 0;
-
-	return 0;
-}
-
-static const struct net_proto_family qrtr_family = {
-	.owner	= THIS_MODULE,
-	.family	= AF_QIPCRTR,
-	.create	= qrtr_create,
-};
-
-static int __init qrtr_proto_init(void)
-{
-	int rc;
-
-	rc = proto_register(&qrtr_proto, 1);
-	if (rc)
-		return rc;
-
-	rc = sock_register(&qrtr_family);
-	if (rc)
-		goto err_proto;
-
-	rc = qrtr_ns_init();
-	if (rc)
-		goto err_sock;
-
-	return 0;
-
-err_sock:
-	sock_unregister(qrtr_family.family);
-err_proto:
-	proto_unregister(&qrtr_proto);
-	return rc;
-}
-postcore_initcall(qrtr_proto_init);
-
-static void __exit qrtr_proto_fini(void)
-{
-	qrtr_ns_remove();
-	sock_unregister(qrtr_family.family);
-	proto_unregister(&qrtr_proto);
-}
-module_exit(qrtr_proto_fini);
-
-MODULE_DESCRIPTION("Qualcomm IPC-router driver");
-MODULE_LICENSE("GPL v2");
-MODULE_ALIAS_NETPROTO(PF_QIPCRTR);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 5f6e6a6e91b3..a5344fddddbb 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1831,6 +1831,10 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 		err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len);
 		if (err)
 			goto err;
+		if (unlikely(sinfo->sinfo_stream >= asoc->stream.outcnt)) {
+			err = -EINVAL;
+			goto err;
+		}
 	}
 
 	if (sctp_state(asoc, CLOSED)) {
diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index d7ed7d49115a..a7d107167c05 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -415,14 +415,23 @@ static int unix_gid_hash(kuid_t uid)
 	return hash_long(from_kuid(&init_user_ns, uid), GID_HASHBITS);
 }
 
-static void unix_gid_put(struct kref *kref)
+static void unix_gid_free(struct rcu_head *rcu)
 {
-	struct cache_head *item = container_of(kref, struct cache_head, ref);
-	struct unix_gid *ug = container_of(item, struct unix_gid, h);
+	struct unix_gid *ug = container_of(rcu, struct unix_gid, rcu);
+	struct cache_head *item = &ug->h;
+
 	if (test_bit(CACHE_VALID, &item->flags) &&
 	    !test_bit(CACHE_NEGATIVE, &item->flags))
 		put_group_info(ug->gi);
-	kfree_rcu(ug, rcu);
+	kfree(ug);
+}
+
+static void unix_gid_put(struct kref *kref)
+{
+	struct cache_head *item = container_of(kref, struct cache_head, ref);
+	struct unix_gid *ug = container_of(item, struct unix_gid, h);
+
+	call_rcu(&ug->rcu, unix_gid_free);
 }
 
 static int unix_gid_match(struct cache_head *corig, struct cache_head *cnew)
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index c81c7671589d..86d07d06bd0c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2618,6 +2618,7 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1462, 0xda57, "MSI Z270-Gaming", ALC1220_FIXUP_GB_DUAL_CODECS),
 	SND_PCI_QUIRK_VENDOR(0x1462, "MSI", ALC882_FIXUP_GPIO3),
 	SND_PCI_QUIRK(0x147b, 0x107a, "Abit AW9D-MAX", ALC882_FIXUP_ABIT_AW9D_MAX),
+	SND_PCI_QUIRK(0x1558, 0x3702, "Clevo X370SN[VW]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x50d3, "Clevo PC50[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65d1, "Clevo PB51[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65d2, "Clevo PB51R[CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
diff --git a/sound/soc/codecs/hdac_hdmi.c b/sound/soc/codecs/hdac_hdmi.c
index 66408a98298b..1acd82f81ba0 100644
--- a/sound/soc/codecs/hdac_hdmi.c
+++ b/sound/soc/codecs/hdac_hdmi.c
@@ -436,23 +436,28 @@ static int hdac_hdmi_setup_audio_infoframe(struct hdac_device *hdev,
 	return 0;
 }
 
-static int hdac_hdmi_set_tdm_slot(struct snd_soc_dai *dai,
-		unsigned int tx_mask, unsigned int rx_mask,
-		int slots, int slot_width)
+static int hdac_hdmi_set_stream(struct snd_soc_dai *dai,
+				void *stream, int direction)
 {
 	struct hdac_hdmi_priv *hdmi = snd_soc_dai_get_drvdata(dai);
 	struct hdac_device *hdev = hdmi->hdev;
 	struct hdac_hdmi_dai_port_map *dai_map;
 	struct hdac_hdmi_pcm *pcm;
+	struct hdac_stream *hstream;
 
-	dev_dbg(&hdev->dev, "%s: strm_tag: %d\n", __func__, tx_mask);
+	if (!stream)
+		return -EINVAL;
+
+	hstream = (struct hdac_stream *)stream;
+
+	dev_dbg(&hdev->dev, "%s: strm_tag: %d\n", __func__, hstream->stream_tag);
 
 	dai_map = &hdmi->dai_map[dai->id];
 
 	pcm = hdac_hdmi_get_pcm_from_cvt(hdmi, dai_map->cvt);
 
 	if (pcm)
-		pcm->stream_tag = (tx_mask << 4);
+		pcm->stream_tag = (hstream->stream_tag << 4);
 
 	return 0;
 }
@@ -1544,7 +1549,7 @@ static const struct snd_soc_dai_ops hdmi_dai_ops = {
 	.startup = hdac_hdmi_pcm_open,
 	.shutdown = hdac_hdmi_pcm_close,
 	.hw_params = hdac_hdmi_set_hw_params,
-	.set_tdm_slot = hdac_hdmi_set_tdm_slot,
+	.set_stream = hdac_hdmi_set_stream,
 };
 
 /*
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 8b1ba4b725e3..a9f974e5fb85 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -999,7 +999,11 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 	if (is_struct)
 		btf_dump_emit_bit_padding(d, off, t->size * 8, align, false, lvl + 1);
 
-	if (vlen)
+	/*
+	 * Keep `struct empty {}` on a single line,
+	 * only print newline when there are regular or padding fields.
+	 */
+	if (vlen || t->size)
 		btf_dump_printf(d, "\n");
 	btf_dump_printf(d, "%s}", pfx(lvl));
 	if (packed)
