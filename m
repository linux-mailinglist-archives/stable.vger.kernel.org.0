Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76AA0650AE2
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 12:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbiLSLn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 06:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbiLSLnM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 06:43:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EEEFCDA;
        Mon, 19 Dec 2022 03:42:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E6DC60F0A;
        Mon, 19 Dec 2022 11:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CE3C433D2;
        Mon, 19 Dec 2022 11:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671450168;
        bh=I0K2EwdtRX4GI6ttyQ2EjRno17MavtD7k4YZ9qzzUns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1/ef3w9/YiDZzZp+rmXbnhcKJKs4qa6aLI4CqrK7pz3X3nnjLoxXPRgcsssM8+LO
         zzaEOe7u9gaxDIoQCc8luX45GoqxKPIOOCFc0yFupP4uLP90lBcUSLvvvfnuNRBQjP
         aUtt+pqsdTzD4Vt5Lbq81Wgapa0Dvkr8G32QJhGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.0.14
Date:   Mon, 19 Dec 2022 12:42:45 +0100
Message-Id: <1671450164108214@kroah.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <1671450164220150@kroah.com>
References: <1671450164220150@kroah.com>
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

diff --git a/Makefile b/Makefile
index bf00f3240b3a..a3c02b45fb57 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 0
-SUBLEVEL = 13
+SUBLEVEL = 14
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/arch/x86/entry/vdso/vdso.lds.S b/arch/x86/entry/vdso/vdso.lds.S
index 4bf48462fca7..e8c60ae7a7c8 100644
--- a/arch/x86/entry/vdso/vdso.lds.S
+++ b/arch/x86/entry/vdso/vdso.lds.S
@@ -27,7 +27,9 @@ VERSION {
 		__vdso_time;
 		clock_getres;
 		__vdso_clock_getres;
+#ifdef CONFIG_X86_SGX
 		__vdso_sgx_enter_enclave;
+#endif
 	local: *;
 	};
 }
diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 218b098b261d..47619e9cb005 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -47,6 +47,10 @@
 #define MCBA_VER_REQ_USB 1
 #define MCBA_VER_REQ_CAN 2
 
+/* Drive the CAN_RES signal LOW "0" to activate R24 and R25 */
+#define MCBA_VER_TERMINATION_ON 0
+#define MCBA_VER_TERMINATION_OFF 1
+
 #define MCBA_SIDL_EXID_MASK 0x8
 #define MCBA_DLC_MASK 0xf
 #define MCBA_DLC_RTR_MASK 0x40
@@ -463,7 +467,7 @@ static void mcba_usb_process_ka_usb(struct mcba_priv *priv,
 		priv->usb_ka_first_pass = false;
 	}
 
-	if (msg->termination_state)
+	if (msg->termination_state == MCBA_VER_TERMINATION_ON)
 		priv->can.termination = MCBA_TERMINATION_ENABLED;
 	else
 		priv->can.termination = MCBA_TERMINATION_DISABLED;
@@ -785,9 +789,9 @@ static int mcba_set_termination(struct net_device *netdev, u16 term)
 	};
 
 	if (term == MCBA_TERMINATION_ENABLED)
-		usb_msg.termination = 1;
+		usb_msg.termination = MCBA_VER_TERMINATION_ON;
 	else
-		usb_msg.termination = 0;
+		usb_msg.termination = MCBA_VER_TERMINATION_OFF;
 
 	mcba_usb_xmit_cmd(priv, (struct mcba_usb_msg *)&usb_msg);
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 5aa254eaa8d0..5945632ded2d 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -72,7 +72,7 @@
 #include "fec.h"
 
 static void set_multicast_list(struct net_device *ndev);
-static void fec_enet_itr_coal_init(struct net_device *ndev);
+static void fec_enet_itr_coal_set(struct net_device *ndev);
 
 #define DRIVER_NAME	"fec"
 
@@ -1164,8 +1164,8 @@ fec_restart(struct net_device *ndev)
 		writel(0, fep->hwp + FEC_IMASK);
 
 	/* Init the interrupt coalescing */
-	fec_enet_itr_coal_init(ndev);
-
+	if (fep->quirks & FEC_QUIRK_HAS_COALESCE)
+		fec_enet_itr_coal_set(ndev);
 }
 
 static void fec_enet_stop_mode(struct fec_enet_private *fep, bool enabled)
@@ -2771,19 +2771,6 @@ static int fec_enet_set_coalesce(struct net_device *ndev,
 	return 0;
 }
 
-static void fec_enet_itr_coal_init(struct net_device *ndev)
-{
-	struct ethtool_coalesce ec;
-
-	ec.rx_coalesce_usecs = FEC_ITR_ICTT_DEFAULT;
-	ec.rx_max_coalesced_frames = FEC_ITR_ICFT_DEFAULT;
-
-	ec.tx_coalesce_usecs = FEC_ITR_ICTT_DEFAULT;
-	ec.tx_max_coalesced_frames = FEC_ITR_ICFT_DEFAULT;
-
-	fec_enet_set_coalesce(ndev, &ec, NULL, NULL);
-}
-
 static int fec_enet_get_tunable(struct net_device *netdev,
 				const struct ethtool_tunable *tuna,
 				void *data)
@@ -3538,6 +3525,10 @@ static int fec_enet_init(struct net_device *ndev)
 	fep->rx_align = 0x3;
 	fep->tx_align = 0x3;
 #endif
+	fep->rx_pkts_itr = FEC_ITR_ICFT_DEFAULT;
+	fep->tx_pkts_itr = FEC_ITR_ICFT_DEFAULT;
+	fep->rx_time_itr = FEC_ITR_ICTT_DEFAULT;
+	fep->tx_time_itr = FEC_ITR_ICTT_DEFAULT;
 
 	/* Check mask of the streaming and coherent API */
 	ret = dma_set_mask_and_coherent(&fep->pdev->dev, DMA_BIT_MASK(32));
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 0f34114c4596..6867620bcc98 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -804,6 +804,8 @@ static blk_status_t nvme_setup_prp_simple(struct nvme_dev *dev,
 	cmnd->dptr.prp1 = cpu_to_le64(iod->first_dma);
 	if (bv->bv_len > first_prp_len)
 		cmnd->dptr.prp2 = cpu_to_le64(iod->first_dma + first_prp_len);
+	else
+		cmnd->dptr.prp2 = 0;
 	return BLK_STS_OK;
 }
 
diff --git a/drivers/pinctrl/mediatek/mtk-eint.c b/drivers/pinctrl/mediatek/mtk-eint.c
index f7b54a551764..c24583bffa99 100644
--- a/drivers/pinctrl/mediatek/mtk-eint.c
+++ b/drivers/pinctrl/mediatek/mtk-eint.c
@@ -287,12 +287,15 @@ static struct irq_chip mtk_eint_irq_chip = {
 
 static unsigned int mtk_eint_hw_init(struct mtk_eint *eint)
 {
-	void __iomem *reg = eint->base + eint->regs->dom_en;
+	void __iomem *dom_en = eint->base + eint->regs->dom_en;
+	void __iomem *mask_set = eint->base + eint->regs->mask_set;
 	unsigned int i;
 
 	for (i = 0; i < eint->hw->ap_num; i += 32) {
-		writel(0xffffffff, reg);
-		reg += 4;
+		writel(0xffffffff, dom_en);
+		writel(0xffffffff, mask_set);
+		dom_en += 4;
+		mask_set += 4;
 	}
 
 	return 0;
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index bdb1df843c78..58cc2bae2f8a 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1233,6 +1233,9 @@ static u32 rtc_handler(void *context)
 
 static inline void rtc_wake_setup(struct device *dev)
 {
+	if (acpi_disabled)
+		return;
+
 	acpi_install_fixed_event_handler(ACPI_EVENT_RTC, rtc_handler, dev);
 	/*
 	 * After the RTC handler is installed, the Fixed_RTC event should
@@ -1286,7 +1289,6 @@ static void cmos_wake_setup(struct device *dev)
 
 	use_acpi_alarm_quirks();
 
-	rtc_wake_setup(dev);
 	acpi_rtc_info.wake_on = rtc_wake_on;
 	acpi_rtc_info.wake_off = rtc_wake_off;
 
@@ -1344,6 +1346,9 @@ static void cmos_check_acpi_rtc_status(struct device *dev,
 {
 }
 
+static void rtc_wake_setup(struct device *dev)
+{
+}
 #endif
 
 #ifdef	CONFIG_PNP
@@ -1352,10 +1357,12 @@ static void cmos_check_acpi_rtc_status(struct device *dev,
 
 static int cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 {
+	int irq, ret;
+
 	cmos_wake_setup(&pnp->dev);
 
 	if (pnp_port_start(pnp, 0) == 0x70 && !pnp_irq_valid(pnp, 0)) {
-		unsigned int irq = 0;
+		irq = 0;
 #ifdef CONFIG_X86
 		/* Some machines contain a PNP entry for the RTC, but
 		 * don't define the IRQ. It should always be safe to
@@ -1364,13 +1371,17 @@ static int cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 		if (nr_legacy_irqs())
 			irq = RTC_IRQ;
 #endif
-		return cmos_do_probe(&pnp->dev,
-				pnp_get_resource(pnp, IORESOURCE_IO, 0), irq);
 	} else {
-		return cmos_do_probe(&pnp->dev,
-				pnp_get_resource(pnp, IORESOURCE_IO, 0),
-				pnp_irq(pnp, 0));
+		irq = pnp_irq(pnp, 0);
 	}
+
+	ret = cmos_do_probe(&pnp->dev, pnp_get_resource(pnp, IORESOURCE_IO, 0), irq);
+	if (ret)
+		return ret;
+
+	rtc_wake_setup(&pnp->dev);
+
+	return 0;
 }
 
 static void cmos_pnp_remove(struct pnp_dev *pnp)
@@ -1454,7 +1465,7 @@ static inline void cmos_of_init(struct platform_device *pdev) {}
 static int __init cmos_platform_probe(struct platform_device *pdev)
 {
 	struct resource *resource;
-	int irq;
+	int irq, ret;
 
 	cmos_of_init(pdev);
 	cmos_wake_setup(&pdev->dev);
@@ -1467,7 +1478,13 @@ static int __init cmos_platform_probe(struct platform_device *pdev)
 	if (irq < 0)
 		irq = -1;
 
-	return cmos_do_probe(&pdev->dev, resource, irq);
+	ret = cmos_do_probe(&pdev->dev, resource, irq);
+	if (ret)
+		return ret;
+
+	rtc_wake_setup(&pdev->dev);
+
+	return 0;
 }
 
 static int cmos_platform_remove(struct platform_device *pdev)
diff --git a/include/linux/can/platform/sja1000.h b/include/linux/can/platform/sja1000.h
index 5755ae5a4712..6a869682c120 100644
--- a/include/linux/can/platform/sja1000.h
+++ b/include/linux/can/platform/sja1000.h
@@ -14,7 +14,7 @@
 #define OCR_MODE_TEST     0x01
 #define OCR_MODE_NORMAL   0x02
 #define OCR_MODE_CLOCK    0x03
-#define OCR_MODE_MASK     0x07
+#define OCR_MODE_MASK     0x03
 #define OCR_TX0_INVERT    0x04
 #define OCR_TX0_PULLDOWN  0x08
 #define OCR_TX0_PULLUP    0x10
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 8dcbefd90b7f..91473e9f88cd 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2283,6 +2283,7 @@ event_sched_out(struct perf_event *event,
 		    !event->pending_work) {
 			event->pending_work = 1;
 			dec = false;
+			WARN_ON_ONCE(!atomic_long_inc_not_zero(&event->refcount));
 			task_work_add(current, &event->pending_task, TWA_RESUME);
 		}
 		if (dec)
@@ -2328,6 +2329,7 @@ group_sched_out(struct perf_event *group_event,
 
 #define DETACH_GROUP	0x01UL
 #define DETACH_CHILD	0x02UL
+#define DETACH_DEAD	0x04UL
 
 /*
  * Cross CPU call to remove a performance event
@@ -2348,12 +2350,20 @@ __perf_remove_from_context(struct perf_event *event,
 		update_cgrp_time_from_cpuctx(cpuctx, false);
 	}
 
+	/*
+	 * Ensure event_sched_out() switches to OFF, at the very least
+	 * this avoids raising perf_pending_task() at this time.
+	 */
+	if (flags & DETACH_DEAD)
+		event->pending_disable = 1;
 	event_sched_out(event, cpuctx, ctx);
 	if (flags & DETACH_GROUP)
 		perf_group_detach(event);
 	if (flags & DETACH_CHILD)
 		perf_child_detach(event);
 	list_del_event(event, ctx);
+	if (flags & DETACH_DEAD)
+		event->state = PERF_EVENT_STATE_DEAD;
 
 	if (!ctx->nr_events && ctx->is_active) {
 		if (ctx == &cpuctx->ctx)
@@ -5113,9 +5123,7 @@ int perf_event_release_kernel(struct perf_event *event)
 
 	ctx = perf_event_ctx_lock(event);
 	WARN_ON_ONCE(ctx->parent_ctx);
-	perf_remove_from_context(event, DETACH_GROUP);
 
-	raw_spin_lock_irq(&ctx->lock);
 	/*
 	 * Mark this event as STATE_DEAD, there is no external reference to it
 	 * anymore.
@@ -5127,8 +5135,7 @@ int perf_event_release_kernel(struct perf_event *event)
 	 * Thus this guarantees that we will in fact observe and kill _ALL_
 	 * child events.
 	 */
-	event->state = PERF_EVENT_STATE_DEAD;
-	raw_spin_unlock_irq(&ctx->lock);
+	perf_remove_from_context(event, DETACH_GROUP|DETACH_DEAD);
 
 	perf_event_ctx_unlock(event, ctx);
 
@@ -6569,6 +6576,8 @@ static void perf_pending_task(struct callback_head *head)
 	if (rctx >= 0)
 		perf_swevent_put_recursion_context(rctx);
 	preempt_enable_notrace();
+
+	put_event(event);
 }
 
 #ifdef CONFIG_GUEST_PERF_EVENTS
diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index 51721edd8f53..e88d9ff95cdf 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -143,7 +143,7 @@ static const struct snd_kcontrol_new cs42l51_snd_controls[] = {
 			0, 0xA0, 96, adc_att_tlv),
 	SOC_DOUBLE_R_SX_TLV("PGA Volume",
 			CS42L51_ALC_PGA_CTL, CS42L51_ALC_PGB_CTL,
-			0, 0x19, 30, pga_tlv),
+			0, 0x1A, 30, pga_tlv),
 	SOC_SINGLE("Playback Deemphasis Switch", CS42L51_DAC_CTL, 3, 1, 0),
 	SOC_SINGLE("Auto-Mute Switch", CS42L51_DAC_CTL, 2, 1, 0),
 	SOC_SINGLE("Soft Ramp Switch", CS42L51_DAC_CTL, 1, 1, 0),
diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index 79ef4e269bc9..4b86ef82fd93 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -194,6 +194,25 @@ static int fsl_micfil_reset(struct device *dev)
 	if (ret)
 		return ret;
 
+	/*
+	 * SRES is self-cleared bit, but REG_MICFIL_CTRL1 is defined
+	 * as non-volatile register, so SRES still remain in regmap
+	 * cache after set, that every update of REG_MICFIL_CTRL1,
+	 * software reset happens. so clear it explicitly.
+	 */
+	ret = regmap_clear_bits(micfil->regmap, REG_MICFIL_CTRL1,
+				MICFIL_CTRL1_SRES);
+	if (ret)
+		return ret;
+
+	/*
+	 * Set SRES should clear CHnF flags, But even add delay here
+	 * the CHnF may not be cleared sometimes, so clear CHnF explicitly.
+	 */
+	ret = regmap_write_bits(micfil->regmap, REG_MICFIL_STAT, 0xFF, 0xFF);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 47691119306f..55b009d3c681 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -464,10 +464,15 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 	ret = err;
 
 	if (snd_soc_volsw_is_stereo(mc)) {
-		unsigned int val2;
+		unsigned int val2 = ucontrol->value.integer.value[1];
+
+		if (mc->platform_max && val2 > mc->platform_max)
+			return -EINVAL;
+		if (val2 > max)
+			return -EINVAL;
 
 		val_mask = mask << rshift;
-		val2 = (ucontrol->value.integer.value[1] + min) & mask;
+		val2 = (val2 + min) & mask;
 		val2 = val2 << rshift;
 
 		err = snd_soc_component_update_bits(component, reg2, val_mask,
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 4221f73a74d0..3937f66c7f8d 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1963,7 +1963,7 @@ static int btf_dump_struct_data(struct btf_dump *d,
 {
 	const struct btf_member *m = btf_members(t);
 	__u16 n = btf_vlen(t);
-	int i, err;
+	int i, err = 0;
 
 	/* note that we increment depth before calling btf_dump_print() below;
 	 * this is intentional.  btf_dump_data_newline() will not print a
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 6d495656f554..29f7cde10741 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -233,7 +233,7 @@ static int probe_map_create(enum bpf_map_type map_type)
 	case BPF_MAP_TYPE_RINGBUF:
 		key_size = 0;
 		value_size = 0;
-		max_entries = 4096;
+		max_entries = sysconf(_SC_PAGE_SIZE);
 		break;
 	case BPF_MAP_TYPE_STRUCT_OPS:
 		/* we'll get -ENOTSUPP for invalid BTF type ID for struct_ops */
