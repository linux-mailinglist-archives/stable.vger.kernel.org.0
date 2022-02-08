Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05DDE4ADFEF
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 18:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384401AbiBHRzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 12:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384410AbiBHRzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 12:55:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF05C061578;
        Tue,  8 Feb 2022 09:55:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF45CB81CB5;
        Tue,  8 Feb 2022 17:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C128DC004E1;
        Tue,  8 Feb 2022 17:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644342899;
        bh=N4lpxxjjW2zVg8L4Gj3UG3bszqVcQVju13bn6N9dLvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QA9c/UYxuTlxOtXz8Kro3HMePbjYBcBY67JXorWi5xkC4/s0+pdoQA4yrk8gQguUz
         4WSmTeVUL6xQAp6GyYQyN7iE2fK8uSz9Rdxr6WKkNpTO2Xn5FX14v3F9GDUTpiyxq1
         siA7GBdsGGnm3ljJahW7FYPL394f/GNFiGlLutNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.265
Date:   Tue,  8 Feb 2022 18:54:48 +0100
Message-Id: <1644342887116223@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <1644342887240235@kroah.com>
References: <1644342887240235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c5508214fa1f..bc98aa57a6fa 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 264
+SUBLEVEL = 265
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 681f966b7211..332576017381 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -15,6 +15,7 @@ CFLAGS_prom_init.o      += -fPIC
 CFLAGS_btext.o		+= -fPIC
 endif
 
+CFLAGS_setup_32.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_cputable.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_prom_init.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_btext.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index c66c3626a216..00c34be4c604 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -10,6 +10,9 @@ ccflags-$(CONFIG_PPC64)	:= $(NO_MINIMAL_TOC)
 CFLAGS_REMOVE_code-patching.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_feature-fixups.o = $(CC_FLAGS_FTRACE)
 
+CFLAGS_code-patching.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
+CFLAGS_feature-fixups.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
+
 obj-y += string.o alloc.o code-patching.o feature-fixups.o
 
 obj-$(CONFIG_PPC32)	+= div64.o copy_32.o crtsavres.o
diff --git a/arch/s390/hypfs/hypfs_vm.c b/arch/s390/hypfs/hypfs_vm.c
index c4b7b681e055..90740be25cf8 100644
--- a/arch/s390/hypfs/hypfs_vm.c
+++ b/arch/s390/hypfs/hypfs_vm.c
@@ -20,6 +20,7 @@
 
 static char local_guest[] = "        ";
 static char all_guests[] = "*       ";
+static char *all_groups = all_guests;
 static char *guest_query;
 
 struct diag2fc_data {
@@ -62,10 +63,11 @@ static int diag2fc(int size, char* query, void *addr)
 
 	memcpy(parm_list.userid, query, NAME_LEN);
 	ASCEBC(parm_list.userid, NAME_LEN);
-	parm_list.addr = (unsigned long) addr ;
+	memcpy(parm_list.aci_grp, all_groups, NAME_LEN);
+	ASCEBC(parm_list.aci_grp, NAME_LEN);
+	parm_list.addr = (unsigned long)addr;
 	parm_list.size = size;
 	parm_list.fmt = 0x02;
-	memset(parm_list.aci_grp, 0x40, NAME_LEN);
 	rc = -1;
 
 	diag_stat_inc(DIAG_STAT_X2FC);
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index d3df44c3b43a..4cee9446ce58 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -417,7 +417,7 @@ void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_disk);
 	unsigned bytes = bio_integrity_bytes(bi, bytes_done >> 9);
 
-	bip->bip_iter.bi_sector += bytes_done >> 9;
+	bip->bip_iter.bi_sector += bio_integrity_intervals(bi, bytes_done >> 9);
 	bvec_iter_advance(bip->bip_vec, &bip->bip_iter, bytes);
 }
 EXPORT_SYMBOL(bio_integrity_advance);
diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
index d92090b127de..5cf180448a9e 100644
--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -357,7 +357,7 @@ static int altr_sdram_probe(struct platform_device *pdev)
 	if (irq < 0) {
 		edac_printk(KERN_ERR, EDAC_MC,
 			    "No irq %d in DT\n", irq);
-		return -ENODEV;
+		return irq;
 	}
 
 	/* Arria10 has a 2nd IRQ */
diff --git a/drivers/edac/xgene_edac.c b/drivers/edac/xgene_edac.c
index e8b81d7ef61f..028ddc790325 100644
--- a/drivers/edac/xgene_edac.c
+++ b/drivers/edac/xgene_edac.c
@@ -1934,7 +1934,7 @@ static int xgene_edac_probe(struct platform_device *pdev)
 			irq = platform_get_irq(pdev, i);
 			if (irq < 0) {
 				dev_err(&pdev->dev, "No IRQ resource\n");
-				rc = -EINVAL;
+				rc = irq;
 				goto out_err;
 			}
 			rc = devm_request_irq(&pdev->dev, irq,
diff --git a/drivers/gpu/drm/i915/intel_overlay.c b/drivers/gpu/drm/i915/intel_overlay.c
index aace22e7ccac..d3afa2b6ef9c 100644
--- a/drivers/gpu/drm/i915/intel_overlay.c
+++ b/drivers/gpu/drm/i915/intel_overlay.c
@@ -965,6 +965,9 @@ static int check_overlay_dst(struct intel_overlay *overlay,
 	const struct intel_crtc_state *pipe_config =
 		overlay->crtc->config;
 
+	if (rec->dst_height == 0 || rec->dst_width == 0)
+		return -EINVAL;
+
 	if (rec->dst_x < pipe_config->pipe_src_w &&
 	    rec->dst_x + rec->dst_width <= pipe_config->pipe_src_w &&
 	    rec->dst_y < pipe_config->pipe_src_h &&
diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
index c0a7fa56d9a7..32c7bf0d44fa 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
@@ -554,12 +554,14 @@ void __exit msm_dsi_phy_driver_unregister(void)
 int msm_dsi_phy_enable(struct msm_dsi_phy *phy, int src_pll_id,
 			struct msm_dsi_phy_clk_request *clk_req)
 {
-	struct device *dev = &phy->pdev->dev;
+	struct device *dev;
 	int ret;
 
 	if (!phy || !phy->cfg->ops.enable)
 		return -EINVAL;
 
+	dev = &phy->pdev->dev;
+
 	ret = dsi_phy_enable_resource(phy);
 	if (ret) {
 		dev_err(dev, "%s: resource enable failed, %d\n",
diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 3dad4687d3dd..7951f57f9202 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -321,7 +321,7 @@ static int msm_init_vram(struct drm_device *dev)
 		of_node_put(node);
 		if (ret)
 			return ret;
-		size = r.end - r.start;
+		size = r.end - r.start + 1;
 		DRM_INFO("using VRAM carveout: %lx@%pa\n", size, &r.start);
 
 		/* if we have no IOMMU, then we need to use carveout allocator.
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c
index f3c30b2a788e..8bff14ae16b0 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c
@@ -38,7 +38,7 @@ nvbios_addr(struct nvkm_bios *bios, u32 *addr, u8 size)
 		*addr += bios->imaged_addr;
 	}
 
-	if (unlikely(*addr + size >= bios->size)) {
+	if (unlikely(*addr + size > bios->size)) {
 		nvkm_error(&bios->subdev, "OOB %d %08x %08x\n", size, p, *addr);
 		return false;
 	}
diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 30a7f7fde651..033c89f8359d 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -359,7 +359,7 @@ static const struct lm90_params lm90_params[] = {
 		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT
 		  | LM90_HAVE_BROKEN_ALERT,
 		.alert_alarms = 0x7c,
-		.max_convrate = 8,
+		.max_convrate = 7,
 	},
 	[lm86] = {
 		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT,
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 3f8511104c5b..657b70338f7a 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -3346,7 +3346,7 @@ static void mlx4_ib_event(struct mlx4_dev *dev, void *ibdev_ptr,
 	case MLX4_DEV_EVENT_PORT_MGMT_CHANGE:
 		ew = kmalloc(sizeof *ew, GFP_ATOMIC);
 		if (!ew)
-			break;
+			return;
 
 		INIT_WORK(&ew->work, handle_port_mgmt_change_event);
 		memcpy(&ew->ib_eqe, eqe, sizeof *eqe);
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index ec9a20e06941..5dddbb9b06f1 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -30,6 +30,7 @@
 #include <linux/iommu.h>
 #include <linux/kmemleak.h>
 #include <linux/mem_encrypt.h>
+#include <linux/iopoll.h>
 #include <asm/pci-direct.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
@@ -770,6 +771,7 @@ static int iommu_ga_log_enable(struct amd_iommu *iommu)
 		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
 		if (status & (MMIO_STATUS_GALOG_RUN_MASK))
 			break;
+		udelay(10);
 	}
 
 	if (i >= LOOP_TIMEOUT)
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 25e85fdfb9d4..1f34835e12b5 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -543,9 +543,8 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 					    fn, &intel_ir_domain_ops,
 					    iommu);
 	if (!iommu->ir_domain) {
-		irq_domain_free_fwnode(fn);
 		pr_err("IR%d: failed to allocate irqdomain\n", iommu->seq_id);
-		goto out_free_bitmap;
+		goto out_free_fwnode;
 	}
 	iommu->ir_msi_domain =
 		arch_create_remap_msi_irq_domain(iommu->ir_domain,
@@ -569,7 +568,7 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 
 		if (dmar_enable_qi(iommu)) {
 			pr_err("Failed to enable queued invalidation\n");
-			goto out_free_bitmap;
+			goto out_free_ir_domain;
 		}
 	}
 
@@ -593,6 +592,14 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 
 	return 0;
 
+out_free_ir_domain:
+	if (iommu->ir_msi_domain)
+		irq_domain_remove(iommu->ir_msi_domain);
+	iommu->ir_msi_domain = NULL;
+	irq_domain_remove(iommu->ir_domain);
+	iommu->ir_domain = NULL;
+out_free_fwnode:
+	irq_domain_free_fwnode(fn);
 out_free_bitmap:
 	kfree(bitmap);
 out_free_pages:
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 76f6a4f628b3..cc0df7280fe5 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -69,7 +69,7 @@ KCOV_INSTRUMENT_lkdtm_rodata.o	:= n
 
 OBJCOPYFLAGS :=
 OBJCOPYFLAGS_lkdtm_rodata_objcopy.o := \
-	--rename-section .text=.rodata,alloc,readonly,load
+	--rename-section .text=.rodata,alloc,readonly,load,contents
 targets += lkdtm_rodata.o lkdtm_rodata_objcopy.o
 $(obj)/lkdtm_rodata_objcopy.o: $(obj)/lkdtm_rodata.o FORCE
 	$(call if_changed,objcopy)
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 8556962e6824..78412d6024aa 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -724,7 +724,9 @@ static void xgbe_stop_timers(struct xgbe_prv_data *pdata)
 		if (!channel->tx_ring)
 			break;
 
+		/* Deactivate the Tx timer */
 		del_timer_sync(&channel->tx_timer);
+		channel->tx_timer_active = 0;
 	}
 }
 
@@ -2720,6 +2722,14 @@ static int xgbe_rx_poll(struct xgbe_channel *channel, int budget)
 			buf2_len = xgbe_rx_buf2_len(rdata, packet, len);
 			len += buf2_len;
 
+			if (buf2_len > rdata->rx.buf.dma_len) {
+				/* Hardware inconsistency within the descriptors
+				 * that has resulted in a length underflow.
+				 */
+				error = 1;
+				goto skip_data;
+			}
+
 			if (!skb) {
 				skb = xgbe_create_skb(pdata, napi, rdata,
 						      buf1_len);
@@ -2749,8 +2759,10 @@ static int xgbe_rx_poll(struct xgbe_channel *channel, int budget)
 		if (!last || context_next)
 			goto read_again;
 
-		if (!skb)
+		if (!skb || error) {
+			dev_kfree_skb(skb);
 			goto next_packet;
+		}
 
 		/* Be sure we don't exceed the configured MTU */
 		max_len = netdev->mtu + ETH_HLEN;
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 4befc885efb8..8d8eb9e2465f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3691,12 +3691,6 @@ static void ibmvnic_tasklet(void *data)
 			ibmvnic_handle_crq(crq, adapter);
 			crq->generic.first = 0;
 		}
-
-		/* remain in tasklet until all
-		 * capabilities responses are received
-		 */
-		if (!adapter->wait_capability)
-			done = true;
 	}
 	/* if capabilities CRQ's were sent in this tasklet, the following
 	 * tasklet must wait until all responses are received
diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 438e2675bc13..bb46a635c7e5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -627,12 +627,12 @@ struct i40e_vsi {
 	struct rtnl_link_stats64 net_stats_offsets;
 	struct i40e_eth_stats eth_stats;
 	struct i40e_eth_stats eth_stats_offsets;
-	u32 tx_restart;
-	u32 tx_busy;
+	u64 tx_restart;
+	u64 tx_busy;
 	u64 tx_linearize;
 	u64 tx_force_wb;
-	u32 rx_buf_failed;
-	u32 rx_page_failed;
+	u64 rx_buf_failed;
+	u64 rx_page_failed;
 
 	/* These are containers of ring pointers, allocated at run-time */
 	struct i40e_ring **rx_rings;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index 8f326f87a815..126207be492d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -259,7 +259,7 @@ static void i40e_dbg_dump_vsi_seid(struct i40e_pf *pf, int seid)
 		 (unsigned long int)vsi->net_stats_offsets.rx_compressed,
 		 (unsigned long int)vsi->net_stats_offsets.tx_compressed);
 	dev_info(&pf->pdev->dev,
-		 "    tx_restart = %d, tx_busy = %d, rx_buf_failed = %d, rx_page_failed = %d\n",
+		 "    tx_restart = %llu, tx_busy = %llu, rx_buf_failed = %llu, rx_page_failed = %llu\n",
 		 vsi->tx_restart, vsi->tx_busy,
 		 vsi->rx_buf_failed, vsi->rx_page_failed);
 	rcu_read_lock();
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5b5434976698..5dac08c2c6e6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -778,9 +778,9 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	struct rtnl_link_stats64 *ns;   /* netdev stats */
 	struct i40e_eth_stats *oes;
 	struct i40e_eth_stats *es;     /* device's eth stats */
-	u32 tx_restart, tx_busy;
+	u64 tx_restart, tx_busy;
 	struct i40e_ring *p;
-	u32 rx_page, rx_buf;
+	u64 rx_page, rx_buf;
 	u64 bytes, packets;
 	unsigned int start;
 	u64 tx_linearize;
@@ -7245,15 +7245,9 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 	}
 	i40e_get_oem_version(&pf->hw);
 
-	if (test_bit(__I40E_EMP_RESET_INTR_RECEIVED, pf->state) &&
-	    ((hw->aq.fw_maj_ver == 4 && hw->aq.fw_min_ver <= 33) ||
-	     hw->aq.fw_maj_ver < 4) && hw->mac.type == I40E_MAC_XL710) {
-		/* The following delay is necessary for 4.33 firmware and older
-		 * to recover after EMP reset. 200 ms should suffice but we
-		 * put here 300 ms to be sure that FW is ready to operate
-		 * after reset.
-		 */
-		mdelay(300);
+	if (test_and_clear_bit(__I40E_EMP_RESET_INTR_RECEIVED, pf->state)) {
+		/* The following delay is necessary for firmware update. */
+		mdelay(1000);
 	}
 
 	/* re-verify the eeprom if we just had an EMP reset */
diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index b74c735a423d..3338e24b91a5 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -980,9 +980,7 @@ static int yam_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 				 sizeof(struct yamdrv_ioctl_mcs));
 		if (IS_ERR(ym))
 			return PTR_ERR(ym);
-		if (ym->cmd != SIOCYAMSMCS)
-			return -EINVAL;
-		if (ym->bitrate > YAM_MAXBITRATE) {
+		if (ym->cmd != SIOCYAMSMCS || ym->bitrate > YAM_MAXBITRATE) {
 			kfree(ym);
 			return -EINVAL;
 		}
diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 368369469e32..893a5787d81d 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -1770,6 +1770,7 @@ static int ca8210_async_xmit_complete(
 			status
 		);
 		if (status != MAC_TRANSACTION_OVERFLOW) {
+			dev_kfree_skb_any(priv->tx_skb);
 			ieee802154_wake_queue(priv->hw);
 			return 0;
 		}
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 834fa544d6d9..6b10d68e3e53 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3230,6 +3230,15 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 
 	macsec->real_dev = real_dev;
 
+	/* send_sci must be set to true when transmit sci explicitly is set */
+	if ((data && data[IFLA_MACSEC_SCI]) &&
+	    (data && data[IFLA_MACSEC_INC_SCI])) {
+		u8 send_sci = !!nla_get_u8(data[IFLA_MACSEC_INC_SCI]);
+
+		if (!send_sci)
+			return -EINVAL;
+	}
+
 	if (data && data[IFLA_MACSEC_ICV_LEN])
 		icv_len = nla_get_u8(data[IFLA_MACSEC_ICV_LEN]);
 	mtu = real_dev->mtu - icv_len - macsec_extra_len(true);
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 89d8efe8753e..a045fb3a698b 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -514,6 +514,11 @@ static int phylink_register_sfp(struct phylink *pl, struct device_node *np)
 	if (!sfp_np)
 		return 0;
 
+	if (!of_device_is_available(sfp_np)) {
+		of_node_put(sfp_np);
+		return 0;
+	}
+
 	pl->sfp_bus = sfp_register_upstream(sfp_np, pl->netdev, pl,
 					    &sfp_phylink_ops);
 	if (!pl->sfp_bus)
diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 8e2eb2061354..cea005cc7b2a 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -173,7 +173,7 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
 	if (tx_buf == NULL)
 		goto free_rx_urb;
 
-	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE,
+	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
 				    GFP_KERNEL, &rx_urb->transfer_dma);
 	if (rx_buf == NULL)
 		goto free_tx_buf;
@@ -198,7 +198,7 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
 
 static void ipheth_free_urbs(struct ipheth_device *iphone)
 {
-	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->rx_buf,
+	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN, iphone->rx_buf,
 			  iphone->rx_urb->transfer_dma);
 	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->tx_buf,
 			  iphone->tx_urb->transfer_dma);
@@ -371,7 +371,7 @@ static int ipheth_rx_submit(struct ipheth_device *dev, gfp_t mem_flags)
 
 	usb_fill_bulk_urb(dev->rx_urb, udev,
 			  usb_rcvbulkpipe(udev, dev->bulk_in),
-			  dev->rx_buf, IPHETH_BUF_SIZE,
+			  dev->rx_buf, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
 			  ipheth_rcvbulk_callback,
 			  dev);
 	dev->rx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
diff --git a/drivers/rpmsg/rpmsg_char.c b/drivers/rpmsg/rpmsg_char.c
index 6a5b5b16145e..3805bcce9691 100644
--- a/drivers/rpmsg/rpmsg_char.c
+++ b/drivers/rpmsg/rpmsg_char.c
@@ -100,7 +100,7 @@ static int rpmsg_eptdev_destroy(struct device *dev, void *data)
 	/* wake up any blocked readers */
 	wake_up_interruptible(&eptdev->readq);
 
-	device_del(&eptdev->dev);
+	cdev_device_del(&eptdev->cdev, &eptdev->dev);
 	put_device(&eptdev->dev);
 
 	return 0;
@@ -336,7 +336,6 @@ static void rpmsg_eptdev_release_device(struct device *dev)
 
 	ida_simple_remove(&rpmsg_ept_ida, dev->id);
 	ida_simple_remove(&rpmsg_minor_ida, MINOR(eptdev->dev.devt));
-	cdev_del(&eptdev->cdev);
 	kfree(eptdev);
 }
 
@@ -381,19 +380,13 @@ static int rpmsg_eptdev_create(struct rpmsg_ctrldev *ctrldev,
 	dev->id = ret;
 	dev_set_name(dev, "rpmsg%d", ret);
 
-	ret = cdev_add(&eptdev->cdev, dev->devt, 1);
+	ret = cdev_device_add(&eptdev->cdev, &eptdev->dev);
 	if (ret)
 		goto free_ept_ida;
 
 	/* We can now rely on the release function for cleanup */
 	dev->release = rpmsg_eptdev_release_device;
 
-	ret = device_add(dev);
-	if (ret) {
-		dev_err(dev, "device_add failed: %d\n", ret);
-		put_device(dev);
-	}
-
 	return ret;
 
 free_ept_ida:
@@ -461,7 +454,6 @@ static void rpmsg_ctrldev_release_device(struct device *dev)
 
 	ida_simple_remove(&rpmsg_ctrl_ida, dev->id);
 	ida_simple_remove(&rpmsg_minor_ida, MINOR(dev->devt));
-	cdev_del(&ctrldev->cdev);
 	kfree(ctrldev);
 }
 
@@ -496,19 +488,13 @@ static int rpmsg_chrdev_probe(struct rpmsg_device *rpdev)
 	dev->id = ret;
 	dev_set_name(&ctrldev->dev, "rpmsg_ctrl%d", ret);
 
-	ret = cdev_add(&ctrldev->cdev, dev->devt, 1);
+	ret = cdev_device_add(&ctrldev->cdev, &ctrldev->dev);
 	if (ret)
 		goto free_ctrl_ida;
 
 	/* We can now rely on the release function for cleanup */
 	dev->release = rpmsg_ctrldev_release_device;
 
-	ret = device_add(dev);
-	if (ret) {
-		dev_err(&rpdev->dev, "device_add failed: %d\n", ret);
-		put_device(dev);
-	}
-
 	dev_set_drvdata(&rpdev->dev, ctrldev);
 
 	return ret;
@@ -534,7 +520,7 @@ static void rpmsg_chrdev_remove(struct rpmsg_device *rpdev)
 	if (ret)
 		dev_warn(&rpdev->dev, "failed to nuke endpoints: %d\n", ret);
 
-	device_del(&ctrldev->dev);
+	cdev_device_del(&ctrldev->cdev, &ctrldev->dev);
 	put_device(&ctrldev->dev);
 }
 
diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index 18a6f15e313d..86b8858917b6 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -82,7 +82,7 @@ unsigned int mc146818_get_time(struct rtc_time *time)
 	time->tm_year += real_year - 72;
 #endif
 
-	if (century > 20)
+	if (century > 19)
 		time->tm_year += (century - 19) * 100;
 
 	/*
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 0c5fd722a72d..a7ed1edf2472 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -521,6 +521,8 @@ static void zfcp_fc_adisc_handler(void *data)
 		goto out;
 	}
 
+	/* re-init to undo drop from zfcp_fc_adisc() */
+	port->d_id = ntoh24(adisc_resp->adisc_port_id);
 	/* port is good, unblock rport without going through erp */
 	zfcp_scsi_schedule_rport_register(port);
  out:
@@ -534,6 +536,7 @@ static int zfcp_fc_adisc(struct zfcp_port *port)
 	struct zfcp_fc_req *fc_req;
 	struct zfcp_adapter *adapter = port->adapter;
 	struct Scsi_Host *shost = adapter->scsi_host;
+	u32 d_id;
 	int ret;
 
 	fc_req = kmem_cache_zalloc(zfcp_fc_req_cache, GFP_ATOMIC);
@@ -558,7 +561,15 @@ static int zfcp_fc_adisc(struct zfcp_port *port)
 	fc_req->u.adisc.req.adisc_cmd = ELS_ADISC;
 	hton24(fc_req->u.adisc.req.adisc_port_id, fc_host_port_id(shost));
 
-	ret = zfcp_fsf_send_els(adapter, port->d_id, &fc_req->ct_els,
+	d_id = port->d_id; /* remember as destination for send els below */
+	/*
+	 * Force fresh GID_PN lookup on next port recovery.
+	 * Must happen after request setup and before sending request,
+	 * to prevent race with port->d_id re-init in zfcp_fc_adisc_handler().
+	 */
+	port->d_id = 0;
+
+	ret = zfcp_fsf_send_els(adapter, d_id, &fc_req->ct_els,
 				ZFCP_FC_CTELS_TMO);
 	if (ret)
 		kmem_cache_free(zfcp_fc_req_cache, fc_req);
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 116a56f0af01..b91fd5ded559 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -80,7 +80,7 @@ static int bnx2fc_bind_pcidev(struct bnx2fc_hba *hba);
 static void bnx2fc_unbind_pcidev(struct bnx2fc_hba *hba);
 static struct fc_lport *bnx2fc_if_create(struct bnx2fc_interface *interface,
 				  struct device *parent, int npiv);
-static void bnx2fc_destroy_work(struct work_struct *work);
+static void bnx2fc_port_destroy(struct fcoe_port *port);
 
 static struct bnx2fc_hba *bnx2fc_hba_lookup(struct net_device *phys_dev);
 static struct bnx2fc_interface *bnx2fc_interface_lookup(struct net_device
@@ -515,7 +515,8 @@ static int bnx2fc_l2_rcv_thread(void *arg)
 
 static void bnx2fc_recv_frame(struct sk_buff *skb)
 {
-	u32 fr_len;
+	u64 crc_err;
+	u32 fr_len, fr_crc;
 	struct fc_lport *lport;
 	struct fcoe_rcv_info *fr;
 	struct fc_stats *stats;
@@ -549,6 +550,11 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
 	skb_pull(skb, sizeof(struct fcoe_hdr));
 	fr_len = skb->len - sizeof(struct fcoe_crc_eof);
 
+	stats = per_cpu_ptr(lport->stats, get_cpu());
+	stats->RxFrames++;
+	stats->RxWords += fr_len / FCOE_WORD_TO_BYTE;
+	put_cpu();
+
 	fp = (struct fc_frame *)skb;
 	fc_frame_init(fp);
 	fr_dev(fp) = lport;
@@ -631,16 +637,15 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
 		return;
 	}
 
-	stats = per_cpu_ptr(lport->stats, smp_processor_id());
-	stats->RxFrames++;
-	stats->RxWords += fr_len / FCOE_WORD_TO_BYTE;
+	fr_crc = le32_to_cpu(fr_crc(fp));
 
-	if (le32_to_cpu(fr_crc(fp)) !=
-			~crc32(~0, skb->data, fr_len)) {
-		if (stats->InvalidCRCCount < 5)
+	if (unlikely(fr_crc != ~crc32(~0, skb->data, fr_len))) {
+		stats = per_cpu_ptr(lport->stats, get_cpu());
+		crc_err = (stats->InvalidCRCCount++);
+		put_cpu();
+		if (crc_err < 5)
 			printk(KERN_WARNING PFX "dropping frame with "
 			       "CRC error\n");
-		stats->InvalidCRCCount++;
 		kfree_skb(skb);
 		return;
 	}
@@ -911,9 +916,6 @@ static void bnx2fc_indicate_netevent(void *context, unsigned long event,
 				__bnx2fc_destroy(interface);
 		}
 		mutex_unlock(&bnx2fc_dev_lock);
-
-		/* Ensure ALL destroy work has been completed before return */
-		flush_workqueue(bnx2fc_wq);
 		return;
 
 	default:
@@ -1220,8 +1222,8 @@ static int bnx2fc_vport_destroy(struct fc_vport *vport)
 	mutex_unlock(&n_port->lp_mutex);
 	bnx2fc_free_vport(interface->hba, port->lport);
 	bnx2fc_port_shutdown(port->lport);
+	bnx2fc_port_destroy(port);
 	bnx2fc_interface_put(interface);
-	queue_work(bnx2fc_wq, &port->destroy_work);
 	return 0;
 }
 
@@ -1530,7 +1532,6 @@ static struct fc_lport *bnx2fc_if_create(struct bnx2fc_interface *interface,
 	port->lport = lport;
 	port->priv = interface;
 	port->get_netdev = bnx2fc_netdev;
-	INIT_WORK(&port->destroy_work, bnx2fc_destroy_work);
 
 	/* Configure fcoe_port */
 	rc = bnx2fc_lport_config(lport);
@@ -1658,8 +1659,8 @@ static void __bnx2fc_destroy(struct bnx2fc_interface *interface)
 	bnx2fc_interface_cleanup(interface);
 	bnx2fc_stop(interface);
 	list_del(&interface->list);
+	bnx2fc_port_destroy(port);
 	bnx2fc_interface_put(interface);
-	queue_work(bnx2fc_wq, &port->destroy_work);
 }
 
 /**
@@ -1700,15 +1701,12 @@ static int bnx2fc_destroy(struct net_device *netdev)
 	return rc;
 }
 
-static void bnx2fc_destroy_work(struct work_struct *work)
+static void bnx2fc_port_destroy(struct fcoe_port *port)
 {
-	struct fcoe_port *port;
 	struct fc_lport *lport;
 
-	port = container_of(work, struct fcoe_port, destroy_work);
 	lport = port->lport;
-
-	BNX2FC_HBA_DBG(lport, "Entered bnx2fc_destroy_work\n");
+	BNX2FC_HBA_DBG(lport, "Entered %s, destroying lport %p\n", __func__, lport);
 
 	bnx2fc_if_destroy(lport);
 }
@@ -2563,9 +2561,6 @@ static void bnx2fc_ulp_exit(struct cnic_dev *dev)
 			__bnx2fc_destroy(interface);
 	mutex_unlock(&bnx2fc_dev_lock);
 
-	/* Ensure ALL destroy work has been completed before return */
-	flush_workqueue(bnx2fc_wq);
-
 	bnx2fc_ulp_stop(hba);
 	/* unregister cnic device */
 	if (test_and_clear_bit(BNX2FC_CNIC_REGISTERED, &hba->reg_with_cnic))
diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index 298b1dd46380..0321ac531df7 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -522,7 +522,7 @@ static void bcm_qspi_chip_select(struct bcm_qspi *qspi, int cs)
 	u32 rd = 0;
 	u32 wr = 0;
 
-	if (qspi->base[CHIP_SELECT]) {
+	if (cs >= 0 && qspi->base[CHIP_SELECT]) {
 		rd = bcm_qspi_read(qspi, CHIP_SELECT, 0);
 		wr = (rd & ~0xff) | (1 << cs);
 		if (rd == wr)
diff --git a/drivers/spi/spi-meson-spicc.c b/drivers/spi/spi-meson-spicc.c
index 4d1d7053291b..a050dfd8e623 100644
--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -529,6 +529,11 @@ static int meson_spicc_probe(struct platform_device *pdev)
 	writel_relaxed(0, spicc->base + SPICC_INTREG);
 
 	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		ret = irq;
+		goto out_master;
+	}
+
 	ret = devm_request_irq(&pdev->dev, irq, meson_spicc_irq,
 			       0, NULL, spicc);
 	if (ret) {
diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index 690e8ddf5f6b..faca2ab75899 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -498,7 +498,7 @@ static irqreturn_t mtk_spi_interrupt(int irq, void *dev_id)
 	else
 		mdata->state = MTK_SPI_IDLE;
 
-	if (!master->can_dma(master, master->cur_msg->spi, trans)) {
+	if (!master->can_dma(master, NULL, trans)) {
 		if (trans->rx_buf) {
 			cnt = mdata->xfer_len / 4;
 			ioread32_rep(mdata->base + SPI_RX_DATA_REG,
diff --git a/drivers/staging/typec/tcpm.c b/drivers/staging/typec/tcpm.c
index 4fff829b00aa..04734a827593 100644
--- a/drivers/staging/typec/tcpm.c
+++ b/drivers/staging/typec/tcpm.c
@@ -3103,7 +3103,8 @@ static void _tcpm_pd_vbus_off(struct tcpm_port *port)
 	case SNK_TRYWAIT_DEBOUNCE:
 		break;
 	case SNK_ATTACH_WAIT:
-		tcpm_set_state(port, SNK_UNATTACHED, 0);
+	case SNK_DEBOUNCED:
+		/* Do nothing, as TCPM is still waiting for vbus to reaach VSAFE5V to connect */
 		break;
 
 	case SNK_NEGOTIATE_CAPABILITIES:
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index c70e79a0e9f2..52a43922b4fe 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -325,6 +325,7 @@ static struct tty_driver *gsm_tty_driver;
 #define GSM1_ESCAPE_BITS	0x20
 #define XON			0x11
 #define XOFF			0x13
+#define ISO_IEC_646_MASK	0x7F
 
 static const struct tty_port_operations gsm_port_ops;
 
@@ -543,7 +544,8 @@ static int gsm_stuff_frame(const u8 *input, u8 *output, int len)
 	int olen = 0;
 	while (len--) {
 		if (*input == GSM1_SOF || *input == GSM1_ESCAPE
-		    || *input == XON || *input == XOFF) {
+		    || (*input & ISO_IEC_646_MASK) == XON
+		    || (*input & ISO_IEC_646_MASK) == XOFF) {
 			*output++ = GSM1_ESCAPE;
 			*output++ = *input++ ^ GSM1_ESCAPE_BITS;
 			olen++;
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 72015cc7b33f..527b394efb97 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -4808,8 +4808,30 @@ static const struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_INTASHIELD, PCI_DEVICE_ID_INTASHIELD_IS400,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,    /* 135a.0dc0 */
 		pbn_b2_4_115200 },
+	/* Brainboxes Devices */
 	/*
-	 * BrainBoxes UC-260
+	* Brainboxes UC-101
+	*/
+	{       PCI_VENDOR_ID_INTASHIELD, 0x0BA1,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	/*
+	 * Brainboxes UC-235/246
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0AA1,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_1_115200 },
+	/*
+	 * Brainboxes UC-257
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0861,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	/*
+	 * Brainboxes UC-260/271/701/756
 	 */
 	{	PCI_VENDOR_ID_INTASHIELD, 0x0D21,
 		PCI_ANY_ID, PCI_ANY_ID,
@@ -4817,7 +4839,81 @@ static const struct pci_device_id serial_pci_tbl[] = {
 		pbn_b2_4_115200 },
 	{	PCI_VENDOR_ID_INTASHIELD, 0x0E34,
 		PCI_ANY_ID, PCI_ANY_ID,
-		 PCI_CLASS_COMMUNICATION_MULTISERIAL << 8, 0xffff00,
+		PCI_CLASS_COMMUNICATION_MULTISERIAL << 8, 0xffff00,
+		pbn_b2_4_115200 },
+	/*
+	 * Brainboxes UC-268
+	 */
+	{       PCI_VENDOR_ID_INTASHIELD, 0x0841,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_4_115200 },
+	/*
+	 * Brainboxes UC-275/279
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0881,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_8_115200 },
+	/*
+	 * Brainboxes UC-302
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x08E1,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	/*
+	 * Brainboxes UC-310
+	 */
+	{       PCI_VENDOR_ID_INTASHIELD, 0x08C1,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	/*
+	 * Brainboxes UC-313
+	 */
+	{       PCI_VENDOR_ID_INTASHIELD, 0x08A3,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	/*
+	 * Brainboxes UC-320/324
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0A61,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_1_115200 },
+	/*
+	 * Brainboxes UC-346
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0B02,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_4_115200 },
+	/*
+	 * Brainboxes UC-357
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0A81,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0A83,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	/*
+	 * Brainboxes UC-368
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0C41,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_4_115200 },
+	/*
+	 * Brainboxes UC-420/431
+	 */
+	{       PCI_VENDOR_ID_INTASHIELD, 0x0921,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
 		pbn_b2_4_115200 },
 	/*
 	 * Perle PCI-RAS cards
diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index a10335e904ea..52bedd4e1603 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -402,7 +402,7 @@ static void stm32_start_tx(struct uart_port *port)
 {
 	struct circ_buf *xmit = &port->state->xmit;
 
-	if (uart_circ_empty(xmit))
+	if (uart_circ_empty(xmit) && !port->x_char)
 		return;
 
 	stm32_transmit_chars(port);
diff --git a/drivers/usb/common/ulpi.c b/drivers/usb/common/ulpi.c
index e02acfb1ca95..4f6e131a3d58 100644
--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -42,8 +42,11 @@ static int ulpi_match(struct device *dev, struct device_driver *driver)
 	struct ulpi *ulpi = to_ulpi_dev(dev);
 	const struct ulpi_device_id *id;
 
-	/* Some ULPI devices don't have a vendor id so rely on OF match */
-	if (ulpi->id.vendor == 0)
+	/*
+	 * Some ULPI devices don't have a vendor id
+	 * or provide an id_table so rely on OF match.
+	 */
+	if (ulpi->id.vendor == 0 || !drv->id_table)
 		return of_driver_match_device(dev, driver);
 
 	for (id = drv->id_table; id->vendor; id++)
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index d634db802fbd..c1f58b2e9f7e 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1679,6 +1679,13 @@ int usb_hcd_submit_urb (struct urb *urb, gfp_t mem_flags)
 		urb->hcpriv = NULL;
 		INIT_LIST_HEAD(&urb->urb_list);
 		atomic_dec(&urb->use_count);
+		/*
+		 * Order the write of urb->use_count above before the read
+		 * of urb->reject below.  Pairs with the memory barriers in
+		 * usb_kill_urb() and usb_poison_urb().
+		 */
+		smp_mb__after_atomic();
+
 		atomic_dec(&urb->dev->urbnum);
 		if (atomic_read(&urb->reject))
 			wake_up(&usb_kill_urb_queue);
@@ -1788,6 +1795,13 @@ static void __usb_hcd_giveback_urb(struct urb *urb)
 
 	usb_anchor_resume_wakeups(anchor);
 	atomic_dec(&urb->use_count);
+	/*
+	 * Order the write of urb->use_count above before the read
+	 * of urb->reject below.  Pairs with the memory barriers in
+	 * usb_kill_urb() and usb_poison_urb().
+	 */
+	smp_mb__after_atomic();
+
 	if (unlikely(atomic_read(&urb->reject)))
 		wake_up(&usb_kill_urb_queue);
 	usb_put_urb(urb);
diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
index bd6ebc9d17c8..ed6a542c4bed 100644
--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -686,6 +686,12 @@ void usb_kill_urb(struct urb *urb)
 	if (!(urb && urb->dev && urb->ep))
 		return;
 	atomic_inc(&urb->reject);
+	/*
+	 * Order the write of urb->reject above before the read
+	 * of urb->use_count below.  Pairs with the barriers in
+	 * __usb_hcd_giveback_urb() and usb_hcd_submit_urb().
+	 */
+	smp_mb__after_atomic();
 
 	usb_hcd_unlink_urb(urb, -ENOENT);
 	wait_event(usb_kill_urb_queue, atomic_read(&urb->use_count) == 0);
@@ -727,6 +733,12 @@ void usb_poison_urb(struct urb *urb)
 	if (!urb)
 		return;
 	atomic_inc(&urb->reject);
+	/*
+	 * Order the write of urb->reject above before the read
+	 * of urb->use_count below.  Pairs with the barriers in
+	 * __usb_hcd_giveback_urb() and usb_hcd_submit_urb().
+	 */
+	smp_mb__after_atomic();
 
 	if (!urb->dev || !urb->ep)
 		return;
diff --git a/drivers/usb/gadget/function/f_sourcesink.c b/drivers/usb/gadget/function/f_sourcesink.c
index 1c5745f7abea..16142c321df8 100644
--- a/drivers/usb/gadget/function/f_sourcesink.c
+++ b/drivers/usb/gadget/function/f_sourcesink.c
@@ -587,6 +587,7 @@ static int source_sink_start_ep(struct f_sourcesink *ss, bool is_in,
 
 	if (is_iso) {
 		switch (speed) {
+		case USB_SPEED_SUPER_PLUS:
 		case USB_SPEED_SUPER:
 			size = ss->isoc_maxpacket *
 					(ss->isoc_mult + 1) *
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 15915784071e..fedf7e2bc8af 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2320,6 +2320,16 @@ UNUSUAL_DEV(  0x2027, 0xa001, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_euscsi_init,
 		US_FL_SCM_MULT_TARG ),
 
+/*
+ * Reported by DocMAX <mail@vacharakis.de>
+ * and Thomas Weißschuh <linux@weissschuh.net>
+ */
+UNUSUAL_DEV( 0x2109, 0x0715, 0x9999, 0x9999,
+		"VIA Labs, Inc.",
+		"VL817 SATA Bridge",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 UNUSUAL_DEV( 0x2116, 0x0320, 0x0001, 0x0001,
 		"ST",
 		"2A",
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 034b5d0a0504..58d8fd654302 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1131,7 +1131,15 @@ static void ext4_restore_inline_data(handle_t *handle, struct inode *inode,
 				     struct ext4_iloc *iloc,
 				     void *buf, int inline_size)
 {
-	ext4_create_inline_data(handle, inode, inline_size);
+	int ret;
+
+	ret = ext4_create_inline_data(handle, inode, inline_size);
+	if (ret) {
+		ext4_msg(inode->i_sb, KERN_EMERG,
+			"error restoring inline_data for inode -- potential data loss! (inode %lu, error %d)",
+			inode->i_ino, ret);
+		return;
+	}
 	ext4_write_inline_data(inode, iloc, buf, 0, inline_size);
 	ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 }
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 5c26e90db588..c3ae37036b9d 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1607,6 +1607,24 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 
 no_open:
 	res = nfs_lookup(dir, dentry, lookup_flags);
+	if (!res) {
+		inode = d_inode(dentry);
+		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
+		    !S_ISDIR(inode->i_mode))
+			res = ERR_PTR(-ENOTDIR);
+		else if (inode && S_ISREG(inode->i_mode))
+			res = ERR_PTR(-EOPENSTALE);
+	} else if (!IS_ERR(res)) {
+		inode = d_inode(res);
+		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
+		    !S_ISDIR(inode->i_mode)) {
+			dput(res);
+			res = ERR_PTR(-ENOTDIR);
+		} else if (inode && S_ISREG(inode->i_mode)) {
+			dput(res);
+			res = ERR_PTR(-EOPENSTALE);
+		}
+	}
 	if (switched) {
 		d_lookup_done(dentry);
 		if (!res)
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 1c7a695ac265..6720c82ac351 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3423,8 +3423,10 @@ nfsd4_setclientid_confirm(struct svc_rqst *rqstp,
 			status = nfserr_clid_inuse;
 			if (client_has_state(old)
 					&& !same_creds(&unconf->cl_cred,
-							&old->cl_cred))
+							&old->cl_cred)) {
+				old = NULL;
 				goto out;
+			}
 			status = mark_client_expired_locked(old);
 			if (status) {
 				old = NULL;
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index e0e2bc19c929..592e9356f3ec 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -251,10 +251,6 @@ int udf_expand_file_adinicb(struct inode *inode)
 	char *kaddr;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 	int err;
-	struct writeback_control udf_wbc = {
-		.sync_mode = WB_SYNC_NONE,
-		.nr_to_write = 1,
-	};
 
 	WARN_ON_ONCE(!inode_is_locked(inode));
 	if (!iinfo->i_lenAlloc) {
@@ -298,8 +294,10 @@ int udf_expand_file_adinicb(struct inode *inode)
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_LONG;
 	/* from now on we have normal address_space methods */
 	inode->i_data.a_ops = &udf_aops;
+	set_page_dirty(page);
+	unlock_page(page);
 	up_write(&iinfo->i_data_sem);
-	err = inode->i_data.a_ops->writepage(page, &udf_wbc);
+	err = filemap_fdatawrite(inode->i_mapping);
 	if (err) {
 		/* Restore everything back so that we don't lose data... */
 		lock_page(page);
@@ -311,6 +309,7 @@ int udf_expand_file_adinicb(struct inode *inode)
 		unlock_page(page);
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
 		inode->i_data.a_ops = &udf_adinicb_aops;
+		iinfo->i_lenAlloc = inode->i_size;
 		up_write(&iinfo->i_data_sem);
 	}
 	put_page(page);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index fc552da905b3..7972aac9264c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2206,6 +2206,7 @@ struct packet_type {
 					 struct net_device *);
 	bool			(*id_match)(struct packet_type *ptype,
 					    struct sock *sk);
+	struct net		*af_packet_net;
 	void			*af_packet_priv;
 	struct list_head	list;
 };
diff --git a/include/net/ip.h b/include/net/ip.h
index 20a92cdb1e35..4aff48d6ba91 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -399,19 +399,18 @@ static inline void ip_select_ident_segs(struct net *net, struct sk_buff *skb,
 {
 	struct iphdr *iph = ip_hdr(skb);
 
+	/* We had many attacks based on IPID, use the private
+	 * generator as much as we can.
+	 */
+	if (sk && inet_sk(sk)->inet_daddr) {
+		iph->id = htons(inet_sk(sk)->inet_id);
+		inet_sk(sk)->inet_id += segs;
+		return;
+	}
 	if ((iph->frag_off & htons(IP_DF)) && !skb->ignore_df) {
-		/* This is only to work around buggy Windows95/2000
-		 * VJ compression implementations.  If the ID field
-		 * does not change, they drop every other packet in
-		 * a TCP stream using header compression.
-		 */
-		if (sk && inet_sk(sk)->inet_daddr) {
-			iph->id = htons(inet_sk(sk)->inet_id);
-			inet_sk(sk)->inet_id += segs;
-		} else {
-			iph->id = 0;
-		}
+		iph->id = 0;
 	} else {
+		/* Unfortunately we need the big hammer to get a suitable IPID */
 		__ip_select_ident(net, iph, segs);
 	}
 }
diff --git a/include/net/netfilter/nf_nat_l4proto.h b/include/net/netfilter/nf_nat_l4proto.h
index 67835ff8a2d9..103ecea6afdb 100644
--- a/include/net/netfilter/nf_nat_l4proto.h
+++ b/include/net/netfilter/nf_nat_l4proto.h
@@ -74,7 +74,7 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 				 struct nf_conntrack_tuple *tuple,
 				 const struct nf_nat_range *range,
 				 enum nf_nat_manip_type maniptype,
-				 const struct nf_conn *ct, u16 *rover);
+				 const struct nf_conn *ct);
 
 int nf_nat_l4proto_nlattr_to_range(struct nlattr *tb[],
 				   struct nf_nat_range *range);
diff --git a/kernel/audit.c b/kernel/audit.c
index 2b82316b844b..0ad61f5da661 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -509,20 +509,22 @@ static void kauditd_printk_skb(struct sk_buff *skb)
 /**
  * kauditd_rehold_skb - Handle a audit record send failure in the hold queue
  * @skb: audit record
+ * @error: error code (unused)
  *
  * Description:
  * This should only be used by the kauditd_thread when it fails to flush the
  * hold queue.
  */
-static void kauditd_rehold_skb(struct sk_buff *skb)
+static void kauditd_rehold_skb(struct sk_buff *skb, __always_unused int error)
 {
-	/* put the record back in the queue at the same place */
-	skb_queue_head(&audit_hold_queue, skb);
+	/* put the record back in the queue */
+	skb_queue_tail(&audit_hold_queue, skb);
 }
 
 /**
  * kauditd_hold_skb - Queue an audit record, waiting for auditd
  * @skb: audit record
+ * @error: error code
  *
  * Description:
  * Queue the audit record, waiting for an instance of auditd.  When this
@@ -532,19 +534,31 @@ static void kauditd_rehold_skb(struct sk_buff *skb)
  * and queue it, if we have room.  If we want to hold on to the record, but we
  * don't have room, record a record lost message.
  */
-static void kauditd_hold_skb(struct sk_buff *skb)
+static void kauditd_hold_skb(struct sk_buff *skb, int error)
 {
 	/* at this point it is uncertain if we will ever send this to auditd so
 	 * try to send the message via printk before we go any further */
 	kauditd_printk_skb(skb);
 
 	/* can we just silently drop the message? */
-	if (!audit_default) {
-		kfree_skb(skb);
-		return;
+	if (!audit_default)
+		goto drop;
+
+	/* the hold queue is only for when the daemon goes away completely,
+	 * not -EAGAIN failures; if we are in a -EAGAIN state requeue the
+	 * record on the retry queue unless it's full, in which case drop it
+	 */
+	if (error == -EAGAIN) {
+		if (!audit_backlog_limit ||
+		    skb_queue_len(&audit_retry_queue) < audit_backlog_limit) {
+			skb_queue_tail(&audit_retry_queue, skb);
+			return;
+		}
+		audit_log_lost("kauditd retry queue overflow");
+		goto drop;
 	}
 
-	/* if we have room, queue the message */
+	/* if we have room in the hold queue, queue the message */
 	if (!audit_backlog_limit ||
 	    skb_queue_len(&audit_hold_queue) < audit_backlog_limit) {
 		skb_queue_tail(&audit_hold_queue, skb);
@@ -553,24 +567,32 @@ static void kauditd_hold_skb(struct sk_buff *skb)
 
 	/* we have no other options - drop the message */
 	audit_log_lost("kauditd hold queue overflow");
+drop:
 	kfree_skb(skb);
 }
 
 /**
  * kauditd_retry_skb - Queue an audit record, attempt to send again to auditd
  * @skb: audit record
+ * @error: error code (unused)
  *
  * Description:
  * Not as serious as kauditd_hold_skb() as we still have a connected auditd,
  * but for some reason we are having problems sending it audit records so
  * queue the given record and attempt to resend.
  */
-static void kauditd_retry_skb(struct sk_buff *skb)
+static void kauditd_retry_skb(struct sk_buff *skb, __always_unused int error)
 {
-	/* NOTE: because records should only live in the retry queue for a
-	 * short period of time, before either being sent or moved to the hold
-	 * queue, we don't currently enforce a limit on this queue */
-	skb_queue_tail(&audit_retry_queue, skb);
+	if (!audit_backlog_limit ||
+	    skb_queue_len(&audit_retry_queue) < audit_backlog_limit) {
+		skb_queue_tail(&audit_retry_queue, skb);
+		return;
+	}
+
+	/* we have to drop the record, send it via printk as a last effort */
+	kauditd_printk_skb(skb);
+	audit_log_lost("kauditd retry queue overflow");
+	kfree_skb(skb);
 }
 
 /**
@@ -608,7 +630,7 @@ static void auditd_reset(const struct auditd_connection *ac)
 	/* flush the retry queue to the hold queue, but don't touch the main
 	 * queue since we need to process that normally for multicast */
 	while ((skb = skb_dequeue(&audit_retry_queue)))
-		kauditd_hold_skb(skb);
+		kauditd_hold_skb(skb, -ECONNREFUSED);
 }
 
 /**
@@ -682,16 +704,18 @@ static int kauditd_send_queue(struct sock *sk, u32 portid,
 			      struct sk_buff_head *queue,
 			      unsigned int retry_limit,
 			      void (*skb_hook)(struct sk_buff *skb),
-			      void (*err_hook)(struct sk_buff *skb))
+			      void (*err_hook)(struct sk_buff *skb, int error))
 {
 	int rc = 0;
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
+	struct sk_buff *skb_tail;
 	unsigned int failed = 0;
 
 	/* NOTE: kauditd_thread takes care of all our locking, we just use
 	 *       the netlink info passed to us (e.g. sk and portid) */
 
-	while ((skb = skb_dequeue(queue))) {
+	skb_tail = skb_peek_tail(queue);
+	while ((skb != skb_tail) && (skb = skb_dequeue(queue))) {
 		/* call the skb_hook for each skb we touch */
 		if (skb_hook)
 			(*skb_hook)(skb);
@@ -699,7 +723,7 @@ static int kauditd_send_queue(struct sock *sk, u32 portid,
 		/* can we send to anyone via unicast? */
 		if (!sk) {
 			if (err_hook)
-				(*err_hook)(skb);
+				(*err_hook)(skb, -ECONNREFUSED);
 			continue;
 		}
 
@@ -713,7 +737,7 @@ static int kauditd_send_queue(struct sock *sk, u32 portid,
 			    rc == -ECONNREFUSED || rc == -EPERM) {
 				sk = NULL;
 				if (err_hook)
-					(*err_hook)(skb);
+					(*err_hook)(skb, rc);
 				if (rc == -EAGAIN)
 					rc = 0;
 				/* continue to drain the queue */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 485e319ba742..220c43a085e4 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -228,27 +228,57 @@ static bool bpf_is_jmp_and_has_target(const struct bpf_insn *insn)
 	       BPF_OP(insn->code) != BPF_EXIT;
 }
 
-static void bpf_adj_branches(struct bpf_prog *prog, u32 pos, u32 delta)
+static int bpf_adj_delta_to_off(struct bpf_insn *insn, u32 pos, u32 delta,
+				u32 curr, const bool probe_pass)
 {
+	const s32 off_min = S16_MIN, off_max = S16_MAX;
+	s32 off = insn->off;
+
+	if (curr < pos && curr + off + 1 > pos)
+		off += delta;
+	else if (curr > pos + delta && curr + off + 1 <= pos + delta)
+		off -= delta;
+	if (off < off_min || off > off_max)
+		return -ERANGE;
+	if (!probe_pass)
+		insn->off = off;
+	return 0;
+}
+
+static int bpf_adj_branches(struct bpf_prog *prog, u32 pos, u32 delta,
+			    const bool probe_pass)
+{
+	u32 i, insn_cnt = prog->len + (probe_pass ? delta : 0);
 	struct bpf_insn *insn = prog->insnsi;
-	u32 i, insn_cnt = prog->len;
+	int ret = 0;
 
 	for (i = 0; i < insn_cnt; i++, insn++) {
+		/* In the probing pass we still operate on the original,
+		 * unpatched image in order to check overflows before we
+		 * do any other adjustments. Therefore skip the patchlet.
+		 */
+		if (probe_pass && i == pos) {
+			i += delta + 1;
+			insn++;
+		}
+
 		if (!bpf_is_jmp_and_has_target(insn))
 			continue;
 
-		/* Adjust offset of jmps if we cross boundaries. */
-		if (i < pos && i + insn->off + 1 > pos)
-			insn->off += delta;
-		else if (i > pos + delta && i + insn->off + 1 <= pos + delta)
-			insn->off -= delta;
+		/* Adjust offset of jmps if we cross patch boundaries. */
+		ret = bpf_adj_delta_to_off(insn, pos, delta, i, probe_pass);
+		if (ret)
+			break;
 	}
+
+	return ret;
 }
 
 struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
 				       const struct bpf_insn *patch, u32 len)
 {
 	u32 insn_adj_cnt, insn_rest, insn_delta = len - 1;
+	const u32 cnt_max = S16_MAX;
 	struct bpf_prog *prog_adj;
 
 	/* Since our patchlet doesn't expand the image, we're done. */
@@ -259,6 +289,15 @@ struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
 
 	insn_adj_cnt = prog->len + insn_delta;
 
+	/* Reject anything that would potentially let the insn->off
+	 * target overflow when we have excessive program expansions.
+	 * We need to probe here before we do any reallocation where
+	 * we afterwards may not fail anymore.
+	 */
+	if (insn_adj_cnt > cnt_max &&
+	    bpf_adj_branches(prog, off, insn_delta, true))
+		return NULL;
+
 	/* Several new instructions need to be inserted. Make room
 	 * for them. Likely, there's no need for a new allocation as
 	 * last page could have large enough tailroom.
@@ -284,7 +323,11 @@ struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
 		sizeof(*patch) * insn_rest);
 	memcpy(prog_adj->insnsi + off, patch, sizeof(*patch) * len);
 
-	bpf_adj_branches(prog_adj, off, insn_delta);
+	/* We are guaranteed to not fail at this point, otherwise
+	 * the ship has sailed to reverse to the original state. An
+	 * overflow cannot happen at this point.
+	 */
+	BUG_ON(bpf_adj_branches(prog_adj, off, insn_delta, false));
 
 	return prog_adj;
 }
diff --git a/kernel/power/wakelock.c b/kernel/power/wakelock.c
index dfba59be190b..b929b3963383 100644
--- a/kernel/power/wakelock.c
+++ b/kernel/power/wakelock.c
@@ -39,23 +39,19 @@ ssize_t pm_show_wakelocks(char *buf, bool show_active)
 {
 	struct rb_node *node;
 	struct wakelock *wl;
-	char *str = buf;
-	char *end = buf + PAGE_SIZE;
+	int len = 0;
 
 	mutex_lock(&wakelocks_lock);
 
 	for (node = rb_first(&wakelocks_tree); node; node = rb_next(node)) {
 		wl = rb_entry(node, struct wakelock, node);
 		if (wl->ws.active == show_active)
-			str += scnprintf(str, end - str, "%s ", wl->name);
+			len += sysfs_emit_at(buf, len, "%s ", wl->name);
 	}
-	if (str > buf)
-		str--;
-
-	str += scnprintf(str, end - str, "\n");
+	len += sysfs_emit_at(buf, len, "\n");
 
 	mutex_unlock(&wakelocks_lock);
-	return (str - buf);
+	return len;
 }
 
 #if CONFIG_PM_WAKELOCKS_LIMIT > 0
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index eca596a56f46..39e222fb3004 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4967,6 +4967,11 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		struct hci_ev_le_advertising_info *ev = ptr;
 		s8 rssi;
 
+		if (ptr > (void *)skb_tail_pointer(skb) - sizeof(*ev)) {
+			bt_dev_err(hdev, "Malicious advertising data.");
+			break;
+		}
+
 		if (ev->length <= HCI_MAX_AD_LENGTH &&
 		    ev->data + ev->length <= skb_tail_pointer(skb)) {
 			rssi = ev->data[ev->length];
@@ -4978,11 +4983,6 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		}
 
 		ptr += sizeof(*ev) + ev->length + 1;
-
-		if (ptr > (void *) skb_tail_pointer(skb) - sizeof(*ev)) {
-			bt_dev_err(hdev, "Malicious advertising data. Stopping processing");
-			break;
-		}
 	}
 
 	hci_dev_unlock(hdev);
diff --git a/net/core/filter.c b/net/core/filter.c
index 729e302bba6e..9b934767a1d8 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -472,11 +472,18 @@ static int bpf_convert_filter(struct sock_filter *prog, int len,
 
 #define BPF_EMIT_JMP							\
 	do {								\
+		const s32 off_min = S16_MIN, off_max = S16_MAX;		\
+		s32 off;						\
+									\
 		if (target >= len || target < 0)			\
 			goto err;					\
-		insn->off = addrs ? addrs[target] - addrs[i] - 1 : 0;	\
+		off = addrs ? addrs[target] - addrs[i] - 1 : 0;		\
 		/* Adjust pc relative offset for 2nd or 3rd insn. */	\
-		insn->off -= insn - tmp_insns;				\
+		off -= insn - tmp_insns;				\
+		/* Reject anything not fitting into insn->off. */	\
+		if (off < off_min || off > off_max)			\
+			goto err;					\
+		insn->off = off;					\
 	} while (0)
 
 		case BPF_JMP | BPF_JA:
diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 615ccab55f38..120015d23ec8 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -209,12 +209,23 @@ static const struct file_operations softnet_seq_fops = {
 	.release = seq_release,
 };
 
-static void *ptype_get_idx(loff_t pos)
+static void *ptype_get_idx(struct seq_file *seq, loff_t pos)
 {
+	struct list_head *ptype_list = NULL;
 	struct packet_type *pt = NULL;
+	struct net_device *dev;
 	loff_t i = 0;
 	int t;
 
+	for_each_netdev_rcu(seq_file_net(seq), dev) {
+		ptype_list = &dev->ptype_all;
+		list_for_each_entry_rcu(pt, ptype_list, list) {
+			if (i == pos)
+				return pt;
+			++i;
+		}
+	}
+
 	list_for_each_entry_rcu(pt, &ptype_all, list) {
 		if (i == pos)
 			return pt;
@@ -235,22 +246,40 @@ static void *ptype_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(RCU)
 {
 	rcu_read_lock();
-	return *pos ? ptype_get_idx(*pos - 1) : SEQ_START_TOKEN;
+	return *pos ? ptype_get_idx(seq, *pos - 1) : SEQ_START_TOKEN;
 }
 
 static void *ptype_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
+	struct net_device *dev;
 	struct packet_type *pt;
 	struct list_head *nxt;
 	int hash;
 
 	++*pos;
 	if (v == SEQ_START_TOKEN)
-		return ptype_get_idx(0);
+		return ptype_get_idx(seq, 0);
 
 	pt = v;
 	nxt = pt->list.next;
+	if (pt->dev) {
+		if (nxt != &pt->dev->ptype_all)
+			goto found;
+
+		dev = pt->dev;
+		for_each_netdev_continue_rcu(seq_file_net(seq), dev) {
+			if (!list_empty(&dev->ptype_all)) {
+				nxt = dev->ptype_all.next;
+				goto found;
+			}
+		}
+
+		nxt = ptype_all.next;
+		goto ptype_all;
+	}
+
 	if (pt->type == htons(ETH_P_ALL)) {
+ptype_all:
 		if (nxt != &ptype_all)
 			goto found;
 		hash = 0;
@@ -279,7 +308,8 @@ static int ptype_seq_show(struct seq_file *seq, void *v)
 
 	if (v == SEQ_START_TOKEN)
 		seq_puts(seq, "Type Device      Function\n");
-	else if (pt->dev == NULL || dev_net(pt->dev) == seq_file_net(seq)) {
+	else if ((!pt->af_packet_net || net_eq(pt->af_packet_net, seq_file_net(seq))) &&
+		 (!pt->dev || net_eq(dev_net(pt->dev), seq_file_net(seq)))) {
 		if (pt->type == htons(ETH_P_ALL))
 			seq_puts(seq, "ALL ");
 		else
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index d7e2cb7ae1fa..738514e5c8ba 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2523,9 +2523,9 @@ static int rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 {
 	struct net *net = sock_net(skb->sk);
 	const struct rtnl_link_ops *ops;
-	const struct rtnl_link_ops *m_ops = NULL;
+	const struct rtnl_link_ops *m_ops;
 	struct net_device *dev;
-	struct net_device *master_dev = NULL;
+	struct net_device *master_dev;
 	struct ifinfomsg *ifm;
 	char kind[MODULE_NAME_LEN];
 	char ifname[IFNAMSIZ];
@@ -2556,6 +2556,8 @@ static int rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			dev = NULL;
 	}
 
+	master_dev = NULL;
+	m_ops = NULL;
 	if (dev) {
 		master_dev = netdev_master_upper_dev_get(dev);
 		if (master_dev)
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 6d4c71a52b6b..3407ee1159f7 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1459,7 +1459,7 @@ static int nl802154_send_key(struct sk_buff *msg, u32 cmd, u32 portid,
 
 	hdr = nl802154hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
-		return -1;
+		return -ENOBUFS;
 
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
@@ -1650,7 +1650,7 @@ static int nl802154_send_device(struct sk_buff *msg, u32 cmd, u32 portid,
 
 	hdr = nl802154hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
-		return -1;
+		return -ENOBUFS;
 
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
@@ -1828,7 +1828,7 @@ static int nl802154_send_devkey(struct sk_buff *msg, u32 cmd, u32 portid,
 
 	hdr = nl802154hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
-		return -1;
+		return -ENOBUFS;
 
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
@@ -2005,7 +2005,7 @@ static int nl802154_send_seclevel(struct sk_buff *msg, u32 cmd, u32 portid,
 
 	hdr = nl802154hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
-		return -1;
+		return -ENOBUFS;
 
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index c9f82525bfa4..aab18ab49e3b 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -160,12 +160,19 @@ int ip_build_and_send_pkt(struct sk_buff *skb, const struct sock *sk,
 	iph->daddr    = (opt && opt->opt.srr ? opt->opt.faddr : daddr);
 	iph->saddr    = saddr;
 	iph->protocol = sk->sk_protocol;
-	if (ip_dont_fragment(sk, &rt->dst)) {
+	/* Do not bother generating IPID for small packets (eg SYNACK) */
+	if (skb->len <= IPV4_MIN_MTU || ip_dont_fragment(sk, &rt->dst)) {
 		iph->frag_off = htons(IP_DF);
 		iph->id = 0;
 	} else {
 		iph->frag_off = 0;
-		__ip_select_ident(net, iph, 1);
+		/* TCP packets here are SYNACK with fat IPv4/TCP options.
+		 * Avoid using the hashed IP ident generator.
+		 */
+		if (sk->sk_protocol == IPPROTO_TCP)
+			iph->id = (__force __be16)prandom_u32();
+		else
+			__ip_select_ident(net, iph, 1);
 	}
 
 	if (opt && opt->opt.optlen) {
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index aab141c4a389..bfd0ab9d3b57 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -225,7 +225,8 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 			continue;
 		}
 
-		if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif)
+		if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif &&
+		    sk->sk_bound_dev_if != inet_sdif(skb))
 			continue;
 
 		sock_hold(sk);
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 261a9813b88c..9c4b2c0dc68a 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -721,6 +721,7 @@ static int raw_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	int ret = -EINVAL;
 	int chk_addr_ret;
 
+	lock_sock(sk);
 	if (sk->sk_state != TCP_CLOSE || addr_len < sizeof(struct sockaddr_in))
 		goto out;
 
@@ -740,7 +741,9 @@ static int raw_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 		inet->inet_saddr = 0;  /* Use device */
 	sk_dst_reset(sk);
 	ret = 0;
-out:	return ret;
+out:
+	release_sock(sk);
+	return ret;
 }
 
 /*
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index aa9638febdd8..9458a0dfa820 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1008,12 +1008,12 @@ int ip6_tnl_xmit_ctl(struct ip6_tnl *t,
 			ldev = dev_get_by_index_rcu(net, p->link);
 
 		if (unlikely(!ipv6_chk_addr(net, laddr, ldev, 0)))
-			pr_warn("%s xmit: Local address not yet configured!\n",
-				p->name);
+			pr_warn_ratelimited("%s xmit: Local address not yet configured!\n",
+					    p->name);
 		else if (!ipv6_addr_is_multicast(raddr) &&
 			 unlikely(ipv6_chk_addr(net, raddr, NULL, 0)))
-			pr_warn("%s xmit: Routing loop! Remote address found on this node!\n",
-				p->name);
+			pr_warn_ratelimited("%s xmit: Routing loop! Remote address found on this node!\n",
+					    p->name);
 		else
 			ret = 1;
 		rcu_read_unlock();
diff --git a/net/netfilter/nf_nat_proto_common.c b/net/netfilter/nf_nat_proto_common.c
index 7d7466dbf663..a4f709a3cbac 100644
--- a/net/netfilter/nf_nat_proto_common.c
+++ b/net/netfilter/nf_nat_proto_common.c
@@ -38,12 +38,12 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 				 struct nf_conntrack_tuple *tuple,
 				 const struct nf_nat_range *range,
 				 enum nf_nat_manip_type maniptype,
-				 const struct nf_conn *ct,
-				 u16 *rover)
+				 const struct nf_conn *ct)
 {
-	unsigned int range_size, min, max, i;
+	unsigned int range_size, min, max, i, attempts;
 	__be16 *portptr;
-	u_int16_t off;
+	u16 off;
+	static const unsigned int max_attempts = 128;
 
 	if (maniptype == NF_NAT_MANIP_SRC)
 		portptr = &tuple->src.u.all;
@@ -84,17 +84,31 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 	} else if (range->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY) {
 		off = prandom_u32();
 	} else {
-		off = *rover;
+		off = prandom_u32();
 	}
 
-	for (i = 0; ; ++off) {
+	attempts = range_size;
+	if (attempts > max_attempts)
+		attempts = max_attempts;
+
+	/* We are in softirq; doing a search of the entire range risks
+	 * soft lockup when all tuples are already used.
+	 *
+	 * If we can't find any free port from first offset, pick a new
+	 * one and try again, with ever smaller search window.
+	 */
+another_round:
+	for (i = 0; i < attempts; i++, off++) {
 		*portptr = htons(min + off % range_size);
-		if (++i != range_size && nf_nat_used_tuple(tuple, ct))
-			continue;
-		if (!(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL))
-			*rover = off;
-		return;
+		if (!nf_nat_used_tuple(tuple, ct))
+			return;
 	}
+
+	if (attempts >= range_size || attempts < 16)
+		return;
+	attempts /= 2;
+	off = prandom_u32();
+	goto another_round;
 }
 EXPORT_SYMBOL_GPL(nf_nat_l4proto_unique_tuple);
 
diff --git a/net/netfilter/nf_nat_proto_dccp.c b/net/netfilter/nf_nat_proto_dccp.c
index 269fcd5dc34c..04c671300a14 100644
--- a/net/netfilter/nf_nat_proto_dccp.c
+++ b/net/netfilter/nf_nat_proto_dccp.c
@@ -18,8 +18,6 @@
 #include <net/netfilter/nf_nat_l3proto.h>
 #include <net/netfilter/nf_nat_l4proto.h>
 
-static u_int16_t dccp_port_rover;
-
 static void
 dccp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		  struct nf_conntrack_tuple *tuple,
@@ -27,8 +25,7 @@ dccp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		  enum nf_nat_manip_type maniptype,
 		  const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &dccp_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 static bool
diff --git a/net/netfilter/nf_nat_proto_sctp.c b/net/netfilter/nf_nat_proto_sctp.c
index c57ee3240b1d..7329c9b1dc1e 100644
--- a/net/netfilter/nf_nat_proto_sctp.c
+++ b/net/netfilter/nf_nat_proto_sctp.c
@@ -12,8 +12,6 @@
 
 #include <net/netfilter/nf_nat_l4proto.h>
 
-static u_int16_t nf_sctp_port_rover;
-
 static void
 sctp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		  struct nf_conntrack_tuple *tuple,
@@ -21,8 +19,7 @@ sctp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		  enum nf_nat_manip_type maniptype,
 		  const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &nf_sctp_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 static bool
diff --git a/net/netfilter/nf_nat_proto_tcp.c b/net/netfilter/nf_nat_proto_tcp.c
index 4f8820fc5148..882e79c6df73 100644
--- a/net/netfilter/nf_nat_proto_tcp.c
+++ b/net/netfilter/nf_nat_proto_tcp.c
@@ -18,8 +18,6 @@
 #include <net/netfilter/nf_nat_l4proto.h>
 #include <net/netfilter/nf_nat_core.h>
 
-static u16 tcp_port_rover;
-
 static void
 tcp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		 struct nf_conntrack_tuple *tuple,
@@ -27,8 +25,7 @@ tcp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		 enum nf_nat_manip_type maniptype,
 		 const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &tcp_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 static bool
diff --git a/net/netfilter/nf_nat_proto_udp.c b/net/netfilter/nf_nat_proto_udp.c
index 167ad0dd269c..f48bacd38d9d 100644
--- a/net/netfilter/nf_nat_proto_udp.c
+++ b/net/netfilter/nf_nat_proto_udp.c
@@ -17,8 +17,6 @@
 #include <net/netfilter/nf_nat_l3proto.h>
 #include <net/netfilter/nf_nat_l4proto.h>
 
-static u16 udp_port_rover;
-
 static void
 udp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		 struct nf_conntrack_tuple *tuple,
@@ -26,8 +24,7 @@ udp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		 enum nf_nat_manip_type maniptype,
 		 const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &udp_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 static void
@@ -78,8 +75,6 @@ static bool udp_manip_pkt(struct sk_buff *skb,
 }
 
 #ifdef CONFIG_NF_NAT_PROTO_UDPLITE
-static u16 udplite_port_rover;
-
 static bool udplite_manip_pkt(struct sk_buff *skb,
 			      const struct nf_nat_l3proto *l3proto,
 			      unsigned int iphdroff, unsigned int hdroff,
@@ -103,8 +98,7 @@ udplite_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		     enum nf_nat_manip_type maniptype,
 		     const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &udplite_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 const struct nf_nat_l4proto nf_nat_l4proto_udplite = {
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index b1a9f330a51f..fd87216bc0a9 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -194,6 +194,9 @@ static int nft_payload_l4csum_offset(const struct nft_pktinfo *pkt,
 				     struct sk_buff *skb,
 				     unsigned int *l4csum_offset)
 {
+	if (pkt->xt.fragoff)
+		return -1;
+
 	switch (pkt->tprot) {
 	case IPPROTO_TCP:
 		*l4csum_offset = offsetof(struct tcphdr, check);
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 3177b9320c62..1381bfcb3cf0 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1756,6 +1756,7 @@ static int fanout_add(struct sock *sk, u16 id, u16 type_flags)
 		match->prot_hook.dev = po->prot_hook.dev;
 		match->prot_hook.func = packet_rcv_fanout;
 		match->prot_hook.af_packet_priv = match;
+		match->prot_hook.af_packet_net = read_pnet(&match->net);
 		match->prot_hook.id_match = match_fanout_group;
 		list_add(&match->list, &fanout_list);
 	}
@@ -1769,7 +1770,10 @@ static int fanout_add(struct sock *sk, u16 id, u16 type_flags)
 		err = -ENOSPC;
 		if (refcount_read(&match->sk_ref) < PACKET_FANOUT_MAX) {
 			__dev_remove_pack(&po->prot_hook);
-			po->fanout = match;
+
+			/* Paired with packet_setsockopt(PACKET_FANOUT_DATA) */
+			WRITE_ONCE(po->fanout, match);
+
 			po->rollover = rollover;
 			rollover = NULL;
 			refcount_set(&match->sk_ref, refcount_read(&match->sk_ref) + 1);
@@ -3330,6 +3334,7 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
 		po->prot_hook.func = packet_rcv_spkt;
 
 	po->prot_hook.af_packet_priv = sk;
+	po->prot_hook.af_packet_net = sock_net(sk);
 
 	if (proto) {
 		po->prot_hook.type = proto;
@@ -3913,7 +3918,8 @@ packet_setsockopt(struct socket *sock, int level, int optname, char __user *optv
 	}
 	case PACKET_FANOUT_DATA:
 	{
-		if (!po->fanout)
+		/* Paired with the WRITE_ONCE() in fanout_add() */
+		if (!READ_ONCE(po->fanout))
 			return -EINVAL;
 
 		return fanout_set_data(po, optval, optlen);
diff --git a/sound/soc/fsl/pcm030-audio-fabric.c b/sound/soc/fsl/pcm030-audio-fabric.c
index ec731223cab3..72d454899484 100644
--- a/sound/soc/fsl/pcm030-audio-fabric.c
+++ b/sound/soc/fsl/pcm030-audio-fabric.c
@@ -90,16 +90,21 @@ static int pcm030_fabric_probe(struct platform_device *op)
 		dev_err(&op->dev, "platform_device_alloc() failed\n");
 
 	ret = platform_device_add(pdata->codec_device);
-	if (ret)
+	if (ret) {
 		dev_err(&op->dev, "platform_device_add() failed: %d\n", ret);
+		platform_device_put(pdata->codec_device);
+	}
 
 	ret = snd_soc_register_card(card);
-	if (ret)
+	if (ret) {
 		dev_err(&op->dev, "snd_soc_register_card() failed: %d\n", ret);
+		platform_device_del(pdata->codec_device);
+		platform_device_put(pdata->codec_device);
+	}
 
 	platform_set_drvdata(op, pdata);
-
 	return ret;
+
 }
 
 static int pcm030_fabric_remove(struct platform_device *op)
diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index d5ef627e93be..e1c897ad0fe5 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -327,13 +327,27 @@ int snd_soc_put_volsw(struct snd_kcontrol *kcontrol,
 	if (sign_bit)
 		mask = BIT(sign_bit + 1) - 1;
 
-	val = ((ucontrol->value.integer.value[0] + min) & mask);
+	val = ucontrol->value.integer.value[0];
+	if (mc->platform_max && val > mc->platform_max)
+		return -EINVAL;
+	if (val > max - min)
+		return -EINVAL;
+	if (val < 0)
+		return -EINVAL;
+	val = (val + min) & mask;
 	if (invert)
 		val = max - val;
 	val_mask = mask << shift;
 	val = val << shift;
 	if (snd_soc_volsw_is_stereo(mc)) {
-		val2 = ((ucontrol->value.integer.value[1] + min) & mask);
+		val2 = ucontrol->value.integer.value[1];
+		if (mc->platform_max && val2 > mc->platform_max)
+			return -EINVAL;
+		if (val2 > max - min)
+			return -EINVAL;
+		if (val2 < 0)
+			return -EINVAL;
+		val2 = (val2 + min) & mask;
 		if (invert)
 			val2 = max - val2;
 		if (reg == reg2) {
@@ -427,8 +441,15 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 	int err = 0;
 	unsigned int val, val_mask, val2 = 0;
 
+	val = ucontrol->value.integer.value[0];
+	if (mc->platform_max && val > mc->platform_max)
+		return -EINVAL;
+	if (val > max - min)
+		return -EINVAL;
+	if (val < 0)
+		return -EINVAL;
 	val_mask = mask << shift;
-	val = (ucontrol->value.integer.value[0] + min) & mask;
+	val = (val + min) & mask;
 	val = val << shift;
 
 	err = snd_soc_component_update_bits(component, reg, val_mask, val);
@@ -894,6 +915,8 @@ int snd_soc_put_xr_sx(struct snd_kcontrol *kcontrol,
 	unsigned int i, regval, regmask;
 	int err;
 
+	if (val < mc->min || val > mc->max)
+		return -EINVAL;
 	if (invert)
 		val = max - val;
 	val &= mask;
diff --git a/tools/testing/selftests/futex/Makefile b/tools/testing/selftests/futex/Makefile
index a63e8453984d..cacf7671427a 100644
--- a/tools/testing/selftests/futex/Makefile
+++ b/tools/testing/selftests/futex/Makefile
@@ -11,7 +11,7 @@ all:
 	@for DIR in $(SUBDIRS); do		\
 		BUILD_TARGET=$(OUTPUT)/$$DIR;	\
 		mkdir $$BUILD_TARGET  -p;	\
-		make OUTPUT=$$BUILD_TARGET -C $$DIR $@;\
+		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$DIR $@;\
 		if [ -e $$DIR/$(TEST_PROGS) ]; then \
 			rsync -a $$DIR/$(TEST_PROGS) $$BUILD_TARGET/; \
 		fi \
@@ -40,6 +40,6 @@ override define CLEAN
 	@for DIR in $(SUBDIRS); do		\
 		BUILD_TARGET=$(OUTPUT)/$$DIR;	\
 		mkdir $$BUILD_TARGET  -p;	\
-		make OUTPUT=$$BUILD_TARGET -C $$DIR $@;\
+		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$DIR $@;\
 	done
 endef
