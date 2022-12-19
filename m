Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A26650ADC
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 12:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbiLSLnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 06:43:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbiLSLmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 06:42:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA7AFAD6;
        Mon, 19 Dec 2022 03:42:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70CF160F07;
        Mon, 19 Dec 2022 11:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8157FC433D2;
        Mon, 19 Dec 2022 11:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671450161;
        bh=lsdsgFh7HKkj7Bk/V8bCOIDOwUfpYB+Dln+yaMJjqbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtMIM20tjjSRSGUPkTu+OvXLxvXSrLYH84X5tAc6TYmnB7/M0xU2kBc6LwfqgQKUF
         bx17Ozw2pp9bQHxzGmyi1/0B4Z5GhdKaszI0LCiteTTpie2/zq/9MMW6KIxnCBYAh7
         V2q0FiR+Btf9GjTaOYjPODwlt3YGoL9T4JtE8+KU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.84
Date:   Mon, 19 Dec 2022 12:42:33 +0100
Message-Id: <1671450152930@kroah.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <1671450152215246@kroah.com>
References: <1671450152215246@kroah.com>
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
index 7825a96e9c36..66cd053b3e7a 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 83
+SUBLEVEL = 84
 EXTRAVERSION =
 NAME = Trick or Treat
 
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
index 023bd34d48e3..e9ccdcce01cc 100644
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
@@ -469,7 +473,7 @@ static void mcba_usb_process_ka_usb(struct mcba_priv *priv,
 		priv->usb_ka_first_pass = false;
 	}
 
-	if (msg->termination_state)
+	if (msg->termination_state == MCBA_VER_TERMINATION_ON)
 		priv->can.termination = MCBA_TERMINATION_ENABLED;
 	else
 		priv->can.termination = MCBA_TERMINATION_DISABLED;
@@ -789,9 +793,9 @@ static int mcba_set_termination(struct net_device *netdev, u16 term)
 	};
 
 	if (term == MCBA_TERMINATION_ENABLED)
-		usb_msg.termination = 1;
+		usb_msg.termination = MCBA_VER_TERMINATION_ON;
 	else
-		usb_msg.termination = 0;
+		usb_msg.termination = MCBA_VER_TERMINATION_OFF;
 
 	mcba_usb_xmit_cmd(priv, (struct mcba_usb_msg *)&usb_msg);
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index a829ba128b9d..afb30d679a47 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -72,7 +72,7 @@
 #include "fec.h"
 
 static void set_multicast_list(struct net_device *ndev);
-static void fec_enet_itr_coal_init(struct net_device *ndev);
+static void fec_enet_itr_coal_set(struct net_device *ndev);
 
 #define DRIVER_NAME	"fec"
 
@@ -1163,8 +1163,8 @@ fec_restart(struct net_device *ndev)
 		writel(0, fep->hwp + FEC_IMASK);
 
 	/* Init the interrupt coalescing */
-	fec_enet_itr_coal_init(ndev);
-
+	if (fep->quirks & FEC_QUIRK_HAS_COALESCE)
+		fec_enet_itr_coal_set(ndev);
 }
 
 static void fec_enet_stop_mode(struct fec_enet_private *fep, bool enabled)
@@ -2760,19 +2760,6 @@ static int fec_enet_set_coalesce(struct net_device *ndev,
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
@@ -3526,6 +3513,10 @@ static int fec_enet_init(struct net_device *ndev)
 	fep->rx_align = 0x3;
 	fep->tx_align = 0x3;
 #endif
+	fep->rx_pkts_itr = FEC_ITR_ICFT_DEFAULT;
+	fep->tx_pkts_itr = FEC_ITR_ICFT_DEFAULT;
+	fep->rx_time_itr = FEC_ITR_ICTT_DEFAULT;
+	fep->tx_time_itr = FEC_ITR_ICTT_DEFAULT;
 
 	/* Check mask of the streaming and coherent API */
 	ret = dma_set_mask_and_coherent(&fep->pdev->dev, DMA_BIT_MASK(32));
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
index 34c0d2ddf9ef..a8286d0032d1 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
@@ -874,7 +874,6 @@ area_cache_get(struct nfp_cpp *cpp, u32 id,
 	}
 
 	/* Adjust the start address to be cache size aligned */
-	cache->id = id;
 	cache->addr = addr & ~(u64)(cache->size - 1);
 
 	/* Re-init to the new ID and address */
@@ -894,6 +893,8 @@ area_cache_get(struct nfp_cpp *cpp, u32 id,
 		return NULL;
 	}
 
+	cache->id = id;
+
 exit:
 	/* Adjust offset */
 	*offset = addr - cache->addr;
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 772bdc6845fb..d49df7123677 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -814,6 +814,8 @@ static blk_status_t nvme_setup_prp_simple(struct nvme_dev *dev,
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
diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index 513989b1c8cd..5d40a00fbce5 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1788,9 +1788,9 @@ int ksmbd_vfs_copy_file_ranges(struct ksmbd_work *work,
 		ret = vfs_copy_file_range(src_fp->filp, src_off,
 					  dst_fp->filp, dst_off, len, 0);
 		if (ret == -EOPNOTSUPP || ret == -EXDEV)
-			ret = generic_copy_file_range(src_fp->filp, src_off,
-						      dst_fp->filp, dst_off,
-						      len, 0);
+			ret = vfs_copy_file_range(src_fp->filp, src_off,
+						  dst_fp->filp, dst_off, len,
+						  COPY_FILE_SPLICE);
 		if (ret < 0)
 			return ret;
 
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index abfbb6953e89..d4adc599737d 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -574,8 +574,8 @@ ssize_t nfsd_copy_file_range(struct file *src, u64 src_pos, struct file *dst,
 	ret = vfs_copy_file_range(src, src_pos, dst, dst_pos, count, 0);
 
 	if (ret == -EOPNOTSUPP || ret == -EXDEV)
-		ret = generic_copy_file_range(src, src_pos, dst, dst_pos,
-					      count, 0);
+		ret = vfs_copy_file_range(src, src_pos, dst, dst_pos, count,
+					  COPY_FILE_SPLICE);
 	return ret;
 }
 
diff --git a/fs/read_write.c b/fs/read_write.c
index 8d3ec975514d..b4b15279b66b 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1418,7 +1418,9 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
 	 * and several different sets of file_operations, but they all end up
 	 * using the same ->copy_file_range() function pointer.
 	 */
-	if (file_out->f_op->copy_file_range) {
+	if (flags & COPY_FILE_SPLICE) {
+		/* cross sb splice is allowed */
+	} else if (file_out->f_op->copy_file_range) {
 		if (file_in->f_op->copy_file_range !=
 		    file_out->f_op->copy_file_range)
 			return -EXDEV;
@@ -1468,8 +1470,9 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 			    size_t len, unsigned int flags)
 {
 	ssize_t ret;
+	bool splice = flags & COPY_FILE_SPLICE;
 
-	if (flags != 0)
+	if (flags & ~COPY_FILE_SPLICE)
 		return -EINVAL;
 
 	ret = generic_copy_file_checks(file_in, pos_in, file_out, pos_out, &len,
@@ -1495,14 +1498,14 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	 * same sb using clone, but for filesystems where both clone and copy
 	 * are supported (e.g. nfs,cifs), we only call the copy method.
 	 */
-	if (file_out->f_op->copy_file_range) {
+	if (!splice && file_out->f_op->copy_file_range) {
 		ret = file_out->f_op->copy_file_range(file_in, pos_in,
 						      file_out, pos_out,
 						      len, flags);
 		goto done;
 	}
 
-	if (file_in->f_op->remap_file_range &&
+	if (!splice && file_in->f_op->remap_file_range &&
 	    file_inode(file_in)->i_sb == file_inode(file_out)->i_sb) {
 		ret = file_in->f_op->remap_file_range(file_in, pos_in,
 				file_out, pos_out,
@@ -1522,6 +1525,8 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	 * consistent story about which filesystems support copy_file_range()
 	 * and which filesystems do not, that will allow userspace tools to
 	 * make consistent desicions w.r.t using copy_file_range().
+	 *
+	 * We also get here if caller (e.g. nfsd) requested COPY_FILE_SPLICE.
 	 */
 	ret = generic_copy_file_range(file_in, pos_in, file_out, pos_out, len,
 				      flags);
@@ -1576,6 +1581,10 @@ SYSCALL_DEFINE6(copy_file_range, int, fd_in, loff_t __user *, off_in,
 		pos_out = f_out.file->f_pos;
 	}
 
+	ret = -EINVAL;
+	if (flags != 0)
+		goto out;
+
 	ret = vfs_copy_file_range(f_in.file, pos_in, f_out.file, pos_out, len,
 				  flags);
 	if (ret > 0) {
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
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 806ac72c7220..d55fdc02f82d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1990,6 +1990,14 @@ struct dir_context {
  */
 #define REMAP_FILE_ADVISORY		(REMAP_FILE_CAN_SHORTEN)
 
+/*
+ * These flags control the behavior of vfs_copy_file_range().
+ * They are not available to the user via syscall.
+ *
+ * COPY_FILE_SPLICE: call splice direct instead of fs clone/copy ops
+ */
+#define COPY_FILE_SPLICE		(1 << 0)
+
 struct iov_iter;
 
 struct file_operations {
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 44f982b73640..5422bd77c7d4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2367,6 +2367,7 @@ event_sched_out(struct perf_event *event,
 		    !event->pending_work) {
 			event->pending_work = 1;
 			dec = false;
+			WARN_ON_ONCE(!atomic_long_inc_not_zero(&event->refcount));
 			task_work_add(current, &event->pending_task, TWA_RESUME);
 		}
 		if (dec)
@@ -2412,6 +2413,7 @@ group_sched_out(struct perf_event *group_event,
 
 #define DETACH_GROUP	0x01UL
 #define DETACH_CHILD	0x02UL
+#define DETACH_DEAD	0x04UL
 
 /*
  * Cross CPU call to remove a performance event
@@ -2432,12 +2434,20 @@ __perf_remove_from_context(struct perf_event *event,
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
@@ -5212,9 +5222,7 @@ int perf_event_release_kernel(struct perf_event *event)
 
 	ctx = perf_event_ctx_lock(event);
 	WARN_ON_ONCE(ctx->parent_ctx);
-	perf_remove_from_context(event, DETACH_GROUP);
 
-	raw_spin_lock_irq(&ctx->lock);
 	/*
 	 * Mark this event as STATE_DEAD, there is no external reference to it
 	 * anymore.
@@ -5226,8 +5234,7 @@ int perf_event_release_kernel(struct perf_event *event)
 	 * Thus this guarantees that we will in fact observe and kill _ALL_
 	 * child events.
 	 */
-	event->state = PERF_EVENT_STATE_DEAD;
-	raw_spin_unlock_irq(&ctx->lock);
+	perf_remove_from_context(event, DETACH_GROUP|DETACH_DEAD);
 
 	perf_event_ctx_unlock(event, ctx);
 
@@ -6662,6 +6669,8 @@ static void perf_pending_task(struct callback_head *head)
 	if (rctx >= 0)
 		perf_swevent_put_recursion_context(rctx);
 	preempt_enable_notrace();
+
+	put_event(event);
 }
 
 /*              
diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index fc6a2bc311b4..c61b17dc2af8 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -146,7 +146,7 @@ static const struct snd_kcontrol_new cs42l51_snd_controls[] = {
 			0, 0xA0, 96, adc_att_tlv),
 	SOC_DOUBLE_R_SX_TLV("PGA Volume",
 			CS42L51_ALC_PGA_CTL, CS42L51_ALC_PGB_CTL,
-			0, 0x19, 30, pga_tlv),
+			0, 0x1A, 30, pga_tlv),
 	SOC_SINGLE("Playback Deemphasis Switch", CS42L51_DAC_CTL, 3, 1, 0),
 	SOC_SINGLE("Auto-Mute Switch", CS42L51_DAC_CTL, 2, 1, 0),
 	SOC_SINGLE("Soft Ramp Switch", CS42L51_DAC_CTL, 1, 1, 0),
diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index 9f90989ac59a..d1cd104f8584 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -191,6 +191,25 @@ static int fsl_micfil_reset(struct device *dev)
 		return ret;
 	}
 
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
index b8a169d3b830..12effaa59fdb 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -447,10 +447,15 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
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
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index cd8c703dde71..8f425473ccaa 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -245,7 +245,7 @@ bool bpf_probe_map_type(enum bpf_map_type map_type, __u32 ifindex)
 	case BPF_MAP_TYPE_RINGBUF:
 		key_size = 0;
 		value_size = 0;
-		max_entries = 4096;
+		max_entries = sysconf(_SC_PAGE_SIZE);
 		break;
 	case BPF_MAP_TYPE_UNSPEC:
 	case BPF_MAP_TYPE_HASH:
