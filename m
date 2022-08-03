Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349DD588A98
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 12:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237822AbiHCKcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 06:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237999AbiHCKbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 06:31:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F169526CB;
        Wed,  3 Aug 2022 03:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25B6EB8223F;
        Wed,  3 Aug 2022 10:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B9EC433D6;
        Wed,  3 Aug 2022 10:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659522612;
        bh=+SIQpUt1hq4IQxpOTShqTNlUOzc+osU9mEXoVNIEHa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QPE9nYxI8jqGKqAy9eav3oHnLkBLyaeLl+zgFkvqddjhAgquaq9QBMQ0VL3D1neNc
         HWaiGzoywyIN4BcYReTk3+5gKClpF7gLG6gIy4lE9oFs7HIxzqeo+QvjVb4iS3yOpY
         Q/XyPM7bQGnT7LDx0Oj0VBdJ95ieqzt+XWnai8pE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.59
Date:   Wed,  3 Aug 2022 12:30:03 +0200
Message-Id: <16595226034652@kroah.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <1659522603151223@kroah.com>
References: <1659522603151223@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 2c556a127979..b47905c4a92f 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3020,6 +3020,7 @@
 					       no_entry_flush [PPC]
 					       no_uaccess_flush [PPC]
 					       mmio_stale_data=off [X86]
+					       retbleed=off [X86]
 
 				Exceptions:
 					       This does not have any effect on
@@ -3042,6 +3043,7 @@
 					       mds=full,nosmt [X86]
 					       tsx_async_abort=full,nosmt [X86]
 					       mmio_stale_data=full,nosmt [X86]
+					       retbleed=auto,nosmt [X86]
 
 	mminit_loglevel=
 			[KNL] When CONFIG_DEBUG_MEMORY_INIT is set, this
diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index b8b67041f955..ba0e8e6337c0 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2808,7 +2808,14 @@ sctp_rmem - vector of 3 INTEGERs: min, default, max
 	Default: 4K
 
 sctp_wmem  - vector of 3 INTEGERs: min, default, max
-	Currently this tunable has no effect.
+	Only the first value ("min") is used, "default" and "max" are
+	ignored.
+
+	min: Minimum size of send buffer that can be used by SCTP sockets.
+	It is guaranteed to each SCTP socket (but not association) even
+	under moderate memory pressure.
+
+	Default: 4K
 
 addr_scope_policy - INTEGER
 	Control IPv4 address scoping - draft-stewart-tsvwg-sctp-ipv4-00
diff --git a/Makefile b/Makefile
index d7ba0de250cb..22bca3948306 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 58
+SUBLEVEL = 59
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/include/asm/dma.h b/arch/arm/include/asm/dma.h
index a81dda65c576..45180a2cc47c 100644
--- a/arch/arm/include/asm/dma.h
+++ b/arch/arm/include/asm/dma.h
@@ -10,7 +10,7 @@
 #else
 #define MAX_DMA_ADDRESS	({ \
 	extern phys_addr_t arm_dma_zone_size; \
-	arm_dma_zone_size && arm_dma_zone_size < (0x10000000 - PAGE_OFFSET) ? \
+	arm_dma_zone_size && arm_dma_zone_size < (0x100000000ULL - PAGE_OFFSET) ? \
 		(PAGE_OFFSET + arm_dma_zone_size) : 0xffffffffUL; })
 #endif
 
diff --git a/arch/arm/lib/xor-neon.c b/arch/arm/lib/xor-neon.c
index b99dd8e1c93f..7ba6cf826162 100644
--- a/arch/arm/lib/xor-neon.c
+++ b/arch/arm/lib/xor-neon.c
@@ -26,8 +26,9 @@ MODULE_LICENSE("GPL");
  * While older versions of GCC do not generate incorrect code, they fail to
  * recognize the parallel nature of these functions, and emit plain ARM code,
  * which is known to be slower than the optimized ARM code in asm-arm/xor.h.
+ *
+ * #warning This code requires at least version 4.6 of GCC
  */
-#warning This code requires at least version 4.6 of GCC
 #endif
 
 #pragma GCC diagnostic ignored "-Wunused-variable"
diff --git a/arch/s390/include/asm/archrandom.h b/arch/s390/include/asm/archrandom.h
index 2c6e1c6ecbe7..4120c428dc37 100644
--- a/arch/s390/include/asm/archrandom.h
+++ b/arch/s390/include/asm/archrandom.h
@@ -2,7 +2,7 @@
 /*
  * Kernel interface for the s390 arch_random_* functions
  *
- * Copyright IBM Corp. 2017, 2020
+ * Copyright IBM Corp. 2017, 2022
  *
  * Author: Harald Freudenberger <freude@de.ibm.com>
  *
@@ -14,6 +14,7 @@
 #ifdef CONFIG_ARCH_RANDOM
 
 #include <linux/static_key.h>
+#include <linux/preempt.h>
 #include <linux/atomic.h>
 #include <asm/cpacf.h>
 
@@ -32,7 +33,8 @@ static inline bool __must_check arch_get_random_int(unsigned int *v)
 
 static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 {
-	if (static_branch_likely(&s390_arch_random_available)) {
+	if (static_branch_likely(&s390_arch_random_available) &&
+	    in_task()) {
 		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
 		atomic64_add(sizeof(*v), &s390_arch_random_counter);
 		return true;
@@ -42,7 +44,8 @@ static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 
 static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
 {
-	if (static_branch_likely(&s390_arch_random_available)) {
+	if (static_branch_likely(&s390_arch_random_available) &&
+	    in_task()) {
 		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
 		atomic64_add(sizeof(*v), &s390_arch_random_counter);
 		return true;
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 18a7ea1cffda..a37814c8547e 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1513,6 +1513,7 @@ static void __init spectre_v2_select_mitigation(void)
 	 * enable IBRS around firmware calls.
 	 */
 	if (boot_cpu_has_bug(X86_BUG_RETBLEED) &&
+	    boot_cpu_has(X86_FEATURE_IBPB) &&
 	    (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
 	     boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)) {
 
diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index 6d1ddecbf0da..d0a9ccf640c4 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -101,9 +101,14 @@ static void dimm_setup_label(struct dimm_info *dimm, u16 handle)
 
 	dmi_memdev_name(handle, &bank, &device);
 
-	/* both strings must be non-zero */
-	if (bank && *bank && device && *device)
-		snprintf(dimm->label, sizeof(dimm->label), "%s %s", bank, device);
+	/*
+	 * Set to a NULL string when both bank and device are zero. In this case,
+	 * the label assigned by default will be preserved.
+	 */
+	snprintf(dimm->label, sizeof(dimm->label), "%s%s%s",
+		 (bank && *bank) ? bank : "",
+		 (bank && *bank && device && *device) ? " " : "",
+		 (device && *device) ? device : "");
 }
 
 static void assign_dmi_dimm_info(struct dimm_info *dimm, struct memdev_dmi_entry *entry)
diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index 92987daa5e17..5e72e6cb2f84 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -679,7 +679,11 @@ nouveau_dmem_migrate_vma(struct nouveau_drm *drm,
 		goto out_free_dma;
 
 	for (i = 0; i < npages; i += max) {
-		args.end = start + (max << PAGE_SHIFT);
+		if (args.start + (max << PAGE_SHIFT) > end)
+			args.end = end;
+		else
+			args.end = args.start + (max << PAGE_SHIFT);
+
 		ret = migrate_vma_setup(&args);
 		if (ret)
 			goto out_free_pfns;
diff --git a/drivers/gpu/drm/tiny/simpledrm.c b/drivers/gpu/drm/tiny/simpledrm.c
index 3e3f9ba1e885..f3c2c173ca4b 100644
--- a/drivers/gpu/drm/tiny/simpledrm.c
+++ b/drivers/gpu/drm/tiny/simpledrm.c
@@ -614,7 +614,7 @@ static const struct drm_connector_funcs simpledrm_connector_funcs = {
 	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
 };
 
-static int
+static enum drm_mode_status
 simpledrm_simple_display_pipe_mode_valid(struct drm_simple_display_pipe *pipe,
 				    const struct drm_display_mode *mode)
 {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index c801b128e5b2..b07d55c99317 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -1908,11 +1908,15 @@ static void i40e_vsi_setup_queue_map(struct i40e_vsi *vsi,
 		 * non-zero req_queue_pairs says that user requested a new
 		 * queue count via ethtool's set_channels, so use this
 		 * value for queues distribution across traffic classes
+		 * We need at least one queue pair for the interface
+		 * to be usable as we see in else statement.
 		 */
 		if (vsi->req_queue_pairs > 0)
 			vsi->num_queue_pairs = vsi->req_queue_pairs;
 		else if (pf->flags & I40E_FLAG_MSIX_ENABLED)
 			vsi->num_queue_pairs = pf->num_lan_msix;
+		else
+			vsi->num_queue_pairs = 1;
 	}
 
 	/* Number of queues per enabled TC */
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 982db894754f..9b9c2b885486 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -651,7 +651,8 @@ static int ice_lbtest_receive_frames(struct ice_ring *rx_ring)
 		rx_desc = ICE_RX_DESC(rx_ring, i);
 
 		if (!(rx_desc->wb.status_error0 &
-		    cpu_to_le16(ICE_TX_DESC_CMD_EOP | ICE_TX_DESC_CMD_RS)))
+		    (cpu_to_le16(BIT(ICE_RX_FLEX_DESC_STATUS0_DD_S)) |
+		     cpu_to_le16(BIT(ICE_RX_FLEX_DESC_STATUS0_EOF_S)))))
 			continue;
 
 		rx_buf = &rx_ring->rx_buf[i];
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 188abf36a5b2..b9d45c7dbef1 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5481,10 +5481,12 @@ int ice_vsi_cfg(struct ice_vsi *vsi)
 	if (vsi->netdev) {
 		ice_set_rx_mode(vsi->netdev);
 
-		err = ice_vsi_vlan_setup(vsi);
+		if (vsi->type != ICE_VSI_LB) {
+			err = ice_vsi_vlan_setup(vsi);
 
-		if (err)
-			return err;
+			if (err)
+				return err;
+		}
 	}
 	ice_vsi_cfg_dcb_rings(vsi);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 626961a41089..75388a65f349 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -28,6 +28,9 @@
 #define MAX_RATE_EXPONENT		0x0FULL
 #define MAX_RATE_MANTISSA		0xFFULL
 
+#define CN10K_MAX_BURST_MANTISSA	0x7FFFULL
+#define CN10K_MAX_BURST_SIZE		8453888ULL
+
 /* Bitfields in NIX_TLX_PIR register */
 #define TLX_RATE_MANTISSA		GENMASK_ULL(8, 1)
 #define TLX_RATE_EXPONENT		GENMASK_ULL(12, 9)
@@ -35,6 +38,9 @@
 #define TLX_BURST_MANTISSA		GENMASK_ULL(36, 29)
 #define TLX_BURST_EXPONENT		GENMASK_ULL(40, 37)
 
+#define CN10K_TLX_BURST_MANTISSA	GENMASK_ULL(43, 29)
+#define CN10K_TLX_BURST_EXPONENT	GENMASK_ULL(47, 44)
+
 struct otx2_tc_flow_stats {
 	u64 bytes;
 	u64 pkts;
@@ -77,33 +83,42 @@ int otx2_tc_alloc_ent_bitmap(struct otx2_nic *nic)
 }
 EXPORT_SYMBOL(otx2_tc_alloc_ent_bitmap);
 
-static void otx2_get_egress_burst_cfg(u32 burst, u32 *burst_exp,
-				      u32 *burst_mantissa)
+static void otx2_get_egress_burst_cfg(struct otx2_nic *nic, u32 burst,
+				      u32 *burst_exp, u32 *burst_mantissa)
 {
+	int max_burst, max_mantissa;
 	unsigned int tmp;
 
+	if (is_dev_otx2(nic->pdev)) {
+		max_burst = MAX_BURST_SIZE;
+		max_mantissa = MAX_BURST_MANTISSA;
+	} else {
+		max_burst = CN10K_MAX_BURST_SIZE;
+		max_mantissa = CN10K_MAX_BURST_MANTISSA;
+	}
+
 	/* Burst is calculated as
 	 * ((256 + BURST_MANTISSA) << (1 + BURST_EXPONENT)) / 256
 	 * Max supported burst size is 130,816 bytes.
 	 */
-	burst = min_t(u32, burst, MAX_BURST_SIZE);
+	burst = min_t(u32, burst, max_burst);
 	if (burst) {
 		*burst_exp = ilog2(burst) ? ilog2(burst) - 1 : 0;
 		tmp = burst - rounddown_pow_of_two(burst);
-		if (burst < MAX_BURST_MANTISSA)
+		if (burst < max_mantissa)
 			*burst_mantissa = tmp * 2;
 		else
 			*burst_mantissa = tmp / (1ULL << (*burst_exp - 7));
 	} else {
 		*burst_exp = MAX_BURST_EXPONENT;
-		*burst_mantissa = MAX_BURST_MANTISSA;
+		*burst_mantissa = max_mantissa;
 	}
 }
 
-static void otx2_get_egress_rate_cfg(u32 maxrate, u32 *exp,
+static void otx2_get_egress_rate_cfg(u64 maxrate, u32 *exp,
 				     u32 *mantissa, u32 *div_exp)
 {
-	unsigned int tmp;
+	u64 tmp;
 
 	/* Rate calculation by hardware
 	 *
@@ -132,21 +147,44 @@ static void otx2_get_egress_rate_cfg(u32 maxrate, u32 *exp,
 	}
 }
 
-static int otx2_set_matchall_egress_rate(struct otx2_nic *nic, u32 burst, u32 maxrate)
+static u64 otx2_get_txschq_rate_regval(struct otx2_nic *nic,
+				       u64 maxrate, u32 burst)
 {
-	struct otx2_hw *hw = &nic->hw;
-	struct nix_txschq_config *req;
 	u32 burst_exp, burst_mantissa;
 	u32 exp, mantissa, div_exp;
+	u64 regval = 0;
+
+	/* Get exponent and mantissa values from the desired rate */
+	otx2_get_egress_burst_cfg(nic, burst, &burst_exp, &burst_mantissa);
+	otx2_get_egress_rate_cfg(maxrate, &exp, &mantissa, &div_exp);
+
+	if (is_dev_otx2(nic->pdev)) {
+		regval = FIELD_PREP(TLX_BURST_EXPONENT, (u64)burst_exp) |
+				FIELD_PREP(TLX_BURST_MANTISSA, (u64)burst_mantissa) |
+				FIELD_PREP(TLX_RATE_DIVIDER_EXPONENT, div_exp) |
+				FIELD_PREP(TLX_RATE_EXPONENT, exp) |
+				FIELD_PREP(TLX_RATE_MANTISSA, mantissa) | BIT_ULL(0);
+	} else {
+		regval = FIELD_PREP(CN10K_TLX_BURST_EXPONENT, (u64)burst_exp) |
+				FIELD_PREP(CN10K_TLX_BURST_MANTISSA, (u64)burst_mantissa) |
+				FIELD_PREP(TLX_RATE_DIVIDER_EXPONENT, div_exp) |
+				FIELD_PREP(TLX_RATE_EXPONENT, exp) |
+				FIELD_PREP(TLX_RATE_MANTISSA, mantissa) | BIT_ULL(0);
+	}
+
+	return regval;
+}
+
+static int otx2_set_matchall_egress_rate(struct otx2_nic *nic,
+					 u32 burst, u64 maxrate)
+{
+	struct otx2_hw *hw = &nic->hw;
+	struct nix_txschq_config *req;
 	int txschq, err;
 
 	/* All SQs share the same TL4, so pick the first scheduler */
 	txschq = hw->txschq_list[NIX_TXSCH_LVL_TL4][0];
 
-	/* Get exponent and mantissa values from the desired rate */
-	otx2_get_egress_burst_cfg(burst, &burst_exp, &burst_mantissa);
-	otx2_get_egress_rate_cfg(maxrate, &exp, &mantissa, &div_exp);
-
 	mutex_lock(&nic->mbox.lock);
 	req = otx2_mbox_alloc_msg_nix_txschq_cfg(&nic->mbox);
 	if (!req) {
@@ -157,11 +195,7 @@ static int otx2_set_matchall_egress_rate(struct otx2_nic *nic, u32 burst, u32 ma
 	req->lvl = NIX_TXSCH_LVL_TL4;
 	req->num_regs = 1;
 	req->reg[0] = NIX_AF_TL4X_PIR(txschq);
-	req->regval[0] = FIELD_PREP(TLX_BURST_EXPONENT, burst_exp) |
-			 FIELD_PREP(TLX_BURST_MANTISSA, burst_mantissa) |
-			 FIELD_PREP(TLX_RATE_DIVIDER_EXPONENT, div_exp) |
-			 FIELD_PREP(TLX_RATE_EXPONENT, exp) |
-			 FIELD_PREP(TLX_RATE_MANTISSA, mantissa) | BIT_ULL(0);
+	req->regval[0] = otx2_get_txschq_rate_regval(nic, maxrate, burst);
 
 	err = otx2_sync_mbox_msg(&nic->mbox);
 	mutex_unlock(&nic->mbox.lock);
@@ -196,7 +230,7 @@ static int otx2_tc_egress_matchall_install(struct otx2_nic *nic,
 	struct netlink_ext_ack *extack = cls->common.extack;
 	struct flow_action *actions = &cls->rule->action;
 	struct flow_action_entry *entry;
-	u32 rate;
+	u64 rate;
 	int err;
 
 	err = otx2_tc_validate_flow(nic, actions, extack);
@@ -218,7 +252,7 @@ static int otx2_tc_egress_matchall_install(struct otx2_nic *nic,
 		}
 		/* Convert bytes per second to Mbps */
 		rate = entry->police.rate_bytes_ps * 8;
-		rate = max_t(u32, rate / 1000000, 1);
+		rate = max_t(u64, rate / 1000000, 1);
 		err = otx2_set_matchall_egress_rate(nic, entry->police.burst, rate);
 		if (err)
 			return err;
@@ -571,21 +605,27 @@ static int otx2_tc_prepare_flow(struct otx2_nic *nic, struct otx2_tc_flow *node,
 
 		flow_spec->dport = match.key->dst;
 		flow_mask->dport = match.mask->dst;
-		if (ip_proto == IPPROTO_UDP)
-			req->features |= BIT_ULL(NPC_DPORT_UDP);
-		else if (ip_proto == IPPROTO_TCP)
-			req->features |= BIT_ULL(NPC_DPORT_TCP);
-		else if (ip_proto == IPPROTO_SCTP)
-			req->features |= BIT_ULL(NPC_DPORT_SCTP);
+
+		if (flow_mask->dport) {
+			if (ip_proto == IPPROTO_UDP)
+				req->features |= BIT_ULL(NPC_DPORT_UDP);
+			else if (ip_proto == IPPROTO_TCP)
+				req->features |= BIT_ULL(NPC_DPORT_TCP);
+			else if (ip_proto == IPPROTO_SCTP)
+				req->features |= BIT_ULL(NPC_DPORT_SCTP);
+		}
 
 		flow_spec->sport = match.key->src;
 		flow_mask->sport = match.mask->src;
-		if (ip_proto == IPPROTO_UDP)
-			req->features |= BIT_ULL(NPC_SPORT_UDP);
-		else if (ip_proto == IPPROTO_TCP)
-			req->features |= BIT_ULL(NPC_SPORT_TCP);
-		else if (ip_proto == IPPROTO_SCTP)
-			req->features |= BIT_ULL(NPC_SPORT_SCTP);
+
+		if (flow_mask->sport) {
+			if (ip_proto == IPPROTO_UDP)
+				req->features |= BIT_ULL(NPC_SPORT_UDP);
+			else if (ip_proto == IPPROTO_TCP)
+				req->features |= BIT_ULL(NPC_SPORT_TCP);
+			else if (ip_proto == IPPROTO_SCTP)
+				req->features |= BIT_ULL(NPC_SPORT_SCTP);
+		}
 	}
 
 	return otx2_tc_parse_actions(nic, &rule->action, req, f, node);
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 725b0f38813a..a2b4e3befa59 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1100,7 +1100,29 @@ static void efx_ptp_xmit_skb_queue(struct efx_nic *efx, struct sk_buff *skb)
 
 	tx_queue = efx_channel_get_tx_queue(ptp_data->channel, type);
 	if (tx_queue && tx_queue->timestamping) {
+		/* This code invokes normal driver TX code which is always
+		 * protected from softirqs when called from generic TX code,
+		 * which in turn disables preemption. Look at __dev_queue_xmit
+		 * which uses rcu_read_lock_bh disabling preemption for RCU
+		 * plus disabling softirqs. We do not need RCU reader
+		 * protection here.
+		 *
+		 * Although it is theoretically safe for current PTP TX/RX code
+		 * running without disabling softirqs, there are three good
+		 * reasond for doing so:
+		 *
+		 *      1) The code invoked is mainly implemented for non-PTP
+		 *         packets and it is always executed with softirqs
+		 *         disabled.
+		 *      2) This being a single PTP packet, better to not
+		 *         interrupt its processing by softirqs which can lead
+		 *         to high latencies.
+		 *      3) netdev_xmit_more checks preemption is disabled and
+		 *         triggers a BUG_ON if not.
+		 */
+		local_bh_disable();
 		efx_enqueue_skb(tx_queue, skb);
+		local_bh_enable();
 	} else {
 		WARN_ONCE(1, "PTP channel has no timestamped tx queue\n");
 		dev_kfree_skb_any(skb);
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index e53b40359fd1..354890948f8a 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -241,6 +241,7 @@ static struct macsec_cb *macsec_skb_cb(struct sk_buff *skb)
 #define DEFAULT_SEND_SCI true
 #define DEFAULT_ENCRYPT false
 #define DEFAULT_ENCODING_SA 0
+#define MACSEC_XPN_MAX_REPLAY_WINDOW (((1 << 30) - 1))
 
 static bool send_sci(const struct macsec_secy *secy)
 {
@@ -1695,7 +1696,7 @@ static bool validate_add_rxsa(struct nlattr **attrs)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_PN] &&
-	    *(u64 *)nla_data(attrs[MACSEC_SA_ATTR_PN]) == 0)
+	    nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
@@ -1751,7 +1752,8 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	pn_len = secy->xpn ? MACSEC_XPN_PN_LEN : MACSEC_DEFAULT_PN_LEN;
-	if (nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
+	if (tb_sa[MACSEC_SA_ATTR_PN] &&
+	    nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
 		pr_notice("macsec: nl: add_rxsa: bad pn length: %d != %d\n",
 			  nla_len(tb_sa[MACSEC_SA_ATTR_PN]), pn_len);
 		rtnl_unlock();
@@ -1767,7 +1769,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 		if (nla_len(tb_sa[MACSEC_SA_ATTR_SALT]) != MACSEC_SALT_LEN) {
 			pr_notice("macsec: nl: add_rxsa: bad salt length: %d != %d\n",
 				  nla_len(tb_sa[MACSEC_SA_ATTR_SALT]),
-				  MACSEC_SA_ATTR_SALT);
+				  MACSEC_SALT_LEN);
 			rtnl_unlock();
 			return -EINVAL;
 		}
@@ -1840,7 +1842,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 
 cleanup:
-	kfree(rx_sa);
+	macsec_rxsa_put(rx_sa);
 	rtnl_unlock();
 	return err;
 }
@@ -1937,7 +1939,7 @@ static bool validate_add_txsa(struct nlattr **attrs)
 	if (nla_get_u8(attrs[MACSEC_SA_ATTR_AN]) >= MACSEC_NUM_AN)
 		return false;
 
-	if (nla_get_u32(attrs[MACSEC_SA_ATTR_PN]) == 0)
+	if (nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
@@ -2009,7 +2011,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 		if (nla_len(tb_sa[MACSEC_SA_ATTR_SALT]) != MACSEC_SALT_LEN) {
 			pr_notice("macsec: nl: add_txsa: bad salt length: %d != %d\n",
 				  nla_len(tb_sa[MACSEC_SA_ATTR_SALT]),
-				  MACSEC_SA_ATTR_SALT);
+				  MACSEC_SALT_LEN);
 			rtnl_unlock();
 			return -EINVAL;
 		}
@@ -2083,7 +2085,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 
 cleanup:
 	secy->operational = was_operational;
-	kfree(tx_sa);
+	macsec_txsa_put(tx_sa);
 	rtnl_unlock();
 	return err;
 }
@@ -2291,7 +2293,7 @@ static bool validate_upd_sa(struct nlattr **attrs)
 	if (nla_get_u8(attrs[MACSEC_SA_ATTR_AN]) >= MACSEC_NUM_AN)
 		return false;
 
-	if (attrs[MACSEC_SA_ATTR_PN] && nla_get_u32(attrs[MACSEC_SA_ATTR_PN]) == 0)
+	if (attrs[MACSEC_SA_ATTR_PN] && nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
@@ -3738,9 +3740,6 @@ static int macsec_changelink_common(struct net_device *dev,
 		secy->operational = tx_sa && tx_sa->active;
 	}
 
-	if (data[IFLA_MACSEC_WINDOW])
-		secy->replay_window = nla_get_u32(data[IFLA_MACSEC_WINDOW]);
-
 	if (data[IFLA_MACSEC_ENCRYPT])
 		tx_sc->encrypt = !!nla_get_u8(data[IFLA_MACSEC_ENCRYPT]);
 
@@ -3786,6 +3785,16 @@ static int macsec_changelink_common(struct net_device *dev,
 		}
 	}
 
+	if (data[IFLA_MACSEC_WINDOW]) {
+		secy->replay_window = nla_get_u32(data[IFLA_MACSEC_WINDOW]);
+
+		/* IEEE 802.1AEbw-2013 10.7.8 - maximum replay window
+		 * for XPN cipher suites */
+		if (secy->xpn &&
+		    secy->replay_window > MACSEC_XPN_MAX_REPLAY_WINDOW)
+			return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -3815,7 +3824,7 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 
 	ret = macsec_changelink_common(dev, data);
 	if (ret)
-		return ret;
+		goto cleanup;
 
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(macsec)) {
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 7de631f5356f..fd4cbf8a55ad 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -890,7 +890,7 @@ static int xpcs_get_state_c37_sgmii(struct dw_xpcs *xpcs,
 	 */
 	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_INTR_STS);
 	if (ret < 0)
-		return false;
+		return ret;
 
 	if (ret & DW_VR_MII_C37_ANSGM_SP_LNKSTS) {
 		int speed_value;
diff --git a/drivers/net/sungem_phy.c b/drivers/net/sungem_phy.c
index 291fa449993f..45f295403cb5 100644
--- a/drivers/net/sungem_phy.c
+++ b/drivers/net/sungem_phy.c
@@ -454,6 +454,7 @@ static int bcm5421_init(struct mii_phy* phy)
 		int can_low_power = 1;
 		if (np == NULL || of_get_property(np, "no-autolowpower", NULL))
 			can_low_power = 0;
+		of_node_put(np);
 		if (can_low_power) {
 			/* Enable automatic low-power */
 			sungem_phy_write(phy, 0x1c, 0x9002);
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 318c681ad63e..53cefad2a79d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -213,9 +213,15 @@ struct virtnet_info {
 	/* Packet virtio header size */
 	u8 hdr_len;
 
-	/* Work struct for refilling if we run low on memory. */
+	/* Work struct for delayed refilling if we run low on memory. */
 	struct delayed_work refill;
 
+	/* Is delayed refill enabled? */
+	bool refill_enabled;
+
+	/* The lock to synchronize the access to refill_enabled */
+	spinlock_t refill_lock;
+
 	/* Work struct for config space updates */
 	struct work_struct config_work;
 
@@ -319,6 +325,20 @@ static struct page *get_a_page(struct receive_queue *rq, gfp_t gfp_mask)
 	return p;
 }
 
+static void enable_delayed_refill(struct virtnet_info *vi)
+{
+	spin_lock_bh(&vi->refill_lock);
+	vi->refill_enabled = true;
+	spin_unlock_bh(&vi->refill_lock);
+}
+
+static void disable_delayed_refill(struct virtnet_info *vi)
+{
+	spin_lock_bh(&vi->refill_lock);
+	vi->refill_enabled = false;
+	spin_unlock_bh(&vi->refill_lock);
+}
+
 static void virtqueue_napi_schedule(struct napi_struct *napi,
 				    struct virtqueue *vq)
 {
@@ -1454,8 +1474,12 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
 	}
 
 	if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get_vring_size(rq->vq)) / 2) {
-		if (!try_fill_recv(vi, rq, GFP_ATOMIC))
-			schedule_delayed_work(&vi->refill, 0);
+		if (!try_fill_recv(vi, rq, GFP_ATOMIC)) {
+			spin_lock(&vi->refill_lock);
+			if (vi->refill_enabled)
+				schedule_delayed_work(&vi->refill, 0);
+			spin_unlock(&vi->refill_lock);
+		}
 	}
 
 	u64_stats_update_begin(&rq->stats.syncp);
@@ -1578,6 +1602,8 @@ static int virtnet_open(struct net_device *dev)
 	struct virtnet_info *vi = netdev_priv(dev);
 	int i, err;
 
+	enable_delayed_refill(vi);
+
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		if (i < vi->curr_queue_pairs)
 			/* Make sure we have some buffers: if oom use wq. */
@@ -1958,6 +1984,8 @@ static int virtnet_close(struct net_device *dev)
 	struct virtnet_info *vi = netdev_priv(dev);
 	int i;
 
+	/* Make sure NAPI doesn't schedule refill work */
+	disable_delayed_refill(vi);
 	/* Make sure refill_work doesn't re-enable napi! */
 	cancel_delayed_work_sync(&vi->refill);
 
@@ -2455,6 +2483,8 @@ static int virtnet_restore_up(struct virtio_device *vdev)
 
 	virtio_device_ready(vdev);
 
+	enable_delayed_refill(vi);
+
 	if (netif_running(vi->dev)) {
 		err = virtnet_open(vi->dev);
 		if (err)
@@ -3162,6 +3192,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 	vdev->priv = vi;
 
 	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
+	spin_lock_init(&vi->refill_lock);
 
 	/* If we can receive ANY GSO packets, we must allocate large ones. */
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index af275ac42795..5351959fbaba 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11386,6 +11386,7 @@ scsih_shutdown(struct pci_dev *pdev)
 	_scsih_ir_shutdown(ioc);
 	_scsih_nvme_shutdown(ioc);
 	mpt3sas_base_mask_interrupts(ioc);
+	mpt3sas_base_stop_watchdog(ioc);
 	ioc->shost_recovery = 1;
 	mpt3sas_base_make_ioc_ready(ioc, SOFT_RESET);
 	ioc->shost_recovery = 0;
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index a06c61f22742..6e2f82152b4a 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -457,7 +457,7 @@ static int sg_io(struct scsi_device *sdev, struct gendisk *disk,
 		goto out_free_cdb;
 
 	ret = 0;
-	if (hdr->iovec_count) {
+	if (hdr->iovec_count && hdr->dxfer_len) {
 		struct iov_iter i;
 		struct iovec *iov = NULL;
 
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 87975d1a21c8..adc302b1a57a 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -107,9 +107,20 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 	return ret;
 }
 
+static bool phandle_exists(const struct device_node *np,
+			   const char *phandle_name, int index)
+{
+	struct device_node *parse_np = of_parse_phandle(np, phandle_name, index);
+
+	if (parse_np)
+		of_node_put(parse_np);
+
+	return parse_np != NULL;
+}
+
 #define MAX_PROP_SIZE 32
 static int ufshcd_populate_vreg(struct device *dev, const char *name,
-		struct ufs_vreg **out_vreg)
+				struct ufs_vreg **out_vreg)
 {
 	char prop_name[MAX_PROP_SIZE];
 	struct ufs_vreg *vreg = NULL;
@@ -121,7 +132,7 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 	}
 
 	snprintf(prop_name, MAX_PROP_SIZE, "%s-supply", name);
-	if (!of_parse_phandle(np, prop_name, 0)) {
+	if (!phandle_exists(np, prop_name, 0)) {
 		dev_info(dev, "%s: Unable to find %s regulator, assuming enabled\n",
 				__func__, prop_name);
 		goto out;
diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index d563abc3e136..914e99173130 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -592,8 +592,12 @@ static int ntfs_attr_find(const ATTR_TYPE type, const ntfschar *name,
 		a = (ATTR_RECORD*)((u8*)ctx->attr +
 				le32_to_cpu(ctx->attr->length));
 	for (;;	a = (ATTR_RECORD*)((u8*)a + le32_to_cpu(a->length))) {
-		if ((u8*)a < (u8*)ctx->mrec || (u8*)a > (u8*)ctx->mrec +
-				le32_to_cpu(ctx->mrec->bytes_allocated))
+		u8 *mrec_end = (u8 *)ctx->mrec +
+		               le32_to_cpu(ctx->mrec->bytes_allocated);
+		u8 *name_end = (u8 *)a + le16_to_cpu(a->name_offset) +
+			       a->name_length * sizeof(ntfschar);
+		if ((u8*)a < (u8*)ctx->mrec || (u8*)a > mrec_end ||
+		    name_end > mrec_end)
 			break;
 		ctx->attr = a;
 		if (unlikely(le32_to_cpu(a->type) > le32_to_cpu(type) ||
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index bb62cc2e0211..cf21aecdf547 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -277,7 +277,6 @@ enum ocfs2_mount_options
 	OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT = 1 << 15,  /* Journal Async Commit */
 	OCFS2_MOUNT_ERRORS_CONT = 1 << 16, /* Return EIO to the calling process on error */
 	OCFS2_MOUNT_ERRORS_ROFS = 1 << 17, /* Change filesystem to read-only on error */
-	OCFS2_MOUNT_NOCLUSTER = 1 << 18, /* No cluster aware filesystem mount */
 };
 
 #define OCFS2_OSB_SOFT_RO	0x0001
@@ -673,8 +672,7 @@ static inline int ocfs2_cluster_o2cb_global_heartbeat(struct ocfs2_super *osb)
 
 static inline int ocfs2_mount_local(struct ocfs2_super *osb)
 {
-	return ((osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT)
-		|| (osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER));
+	return (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT);
 }
 
 static inline int ocfs2_uses_extended_slot_map(struct ocfs2_super *osb)
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index 0b0ae3ebb0cf..da7718cef735 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -252,16 +252,14 @@ static int __ocfs2_find_empty_slot(struct ocfs2_slot_info *si,
 	int i, ret = -ENOSPC;
 
 	if ((preferred >= 0) && (preferred < si->si_num_slots)) {
-		if (!si->si_slots[preferred].sl_valid ||
-		    !si->si_slots[preferred].sl_node_num) {
+		if (!si->si_slots[preferred].sl_valid) {
 			ret = preferred;
 			goto out;
 		}
 	}
 
 	for(i = 0; i < si->si_num_slots; i++) {
-		if (!si->si_slots[i].sl_valid ||
-		    !si->si_slots[i].sl_node_num) {
+		if (!si->si_slots[i].sl_valid) {
 			ret = i;
 			break;
 		}
@@ -456,30 +454,24 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 	spin_lock(&osb->osb_lock);
 	ocfs2_update_slot_info(si);
 
-	if (ocfs2_mount_local(osb))
-		/* use slot 0 directly in local mode */
-		slot = 0;
-	else {
-		/* search for ourselves first and take the slot if it already
-		 * exists. Perhaps we need to mark this in a variable for our
-		 * own journal recovery? Possibly not, though we certainly
-		 * need to warn to the user */
-		slot = __ocfs2_node_num_to_slot(si, osb->node_num);
+	/* search for ourselves first and take the slot if it already
+	 * exists. Perhaps we need to mark this in a variable for our
+	 * own journal recovery? Possibly not, though we certainly
+	 * need to warn to the user */
+	slot = __ocfs2_node_num_to_slot(si, osb->node_num);
+	if (slot < 0) {
+		/* if no slot yet, then just take 1st available
+		 * one. */
+		slot = __ocfs2_find_empty_slot(si, osb->preferred_slot);
 		if (slot < 0) {
-			/* if no slot yet, then just take 1st available
-			 * one. */
-			slot = __ocfs2_find_empty_slot(si, osb->preferred_slot);
-			if (slot < 0) {
-				spin_unlock(&osb->osb_lock);
-				mlog(ML_ERROR, "no free slots available!\n");
-				status = -EINVAL;
-				goto bail;
-			}
-		} else
-			printk(KERN_INFO "ocfs2: Slot %d on device (%s) was "
-			       "already allocated to this node!\n",
-			       slot, osb->dev_str);
-	}
+			spin_unlock(&osb->osb_lock);
+			mlog(ML_ERROR, "no free slots available!\n");
+			status = -EINVAL;
+			goto bail;
+		}
+	} else
+		printk(KERN_INFO "ocfs2: Slot %d on device (%s) was already "
+		       "allocated to this node!\n", slot, osb->dev_str);
 
 	ocfs2_set_slot(si, slot, osb->node_num);
 	osb->slot_num = slot;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 7ba3dabe16f0..a03f0cabff0b 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -173,7 +173,6 @@ enum {
 	Opt_dir_resv_level,
 	Opt_journal_async_commit,
 	Opt_err_cont,
-	Opt_nocluster,
 	Opt_err,
 };
 
@@ -207,7 +206,6 @@ static const match_table_t tokens = {
 	{Opt_dir_resv_level, "dir_resv_level=%u"},
 	{Opt_journal_async_commit, "journal_async_commit"},
 	{Opt_err_cont, "errors=continue"},
-	{Opt_nocluster, "nocluster"},
 	{Opt_err, NULL}
 };
 
@@ -619,13 +617,6 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 		goto out;
 	}
 
-	tmp = OCFS2_MOUNT_NOCLUSTER;
-	if ((osb->s_mount_opt & tmp) != (parsed_options.mount_opt & tmp)) {
-		ret = -EINVAL;
-		mlog(ML_ERROR, "Cannot change nocluster option on remount\n");
-		goto out;
-	}
-
 	tmp = OCFS2_MOUNT_HB_LOCAL | OCFS2_MOUNT_HB_GLOBAL |
 		OCFS2_MOUNT_HB_NONE;
 	if ((osb->s_mount_opt & tmp) != (parsed_options.mount_opt & tmp)) {
@@ -866,7 +857,6 @@ static int ocfs2_verify_userspace_stack(struct ocfs2_super *osb,
 	}
 
 	if (ocfs2_userspace_stack(osb) &&
-	    !(osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER) &&
 	    strncmp(osb->osb_cluster_stack, mopt->cluster_stack,
 		    OCFS2_STACK_LABEL_LEN)) {
 		mlog(ML_ERROR,
@@ -1145,11 +1135,6 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	       osb->s_mount_opt & OCFS2_MOUNT_DATA_WRITEBACK ? "writeback" :
 	       "ordered");
 
-	if ((osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER) &&
-	   !(osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT))
-		printk(KERN_NOTICE "ocfs2: The shared device (%s) is mounted "
-		       "without cluster aware mode.\n", osb->dev_str);
-
 	atomic_set(&osb->vol_state, VOLUME_MOUNTED);
 	wake_up(&osb->osb_mount_event);
 
@@ -1456,9 +1441,6 @@ static int ocfs2_parse_options(struct super_block *sb,
 		case Opt_journal_async_commit:
 			mopt->mount_opt |= OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT;
 			break;
-		case Opt_nocluster:
-			mopt->mount_opt |= OCFS2_MOUNT_NOCLUSTER;
-			break;
 		default:
 			mlog(ML_ERROR,
 			     "Unrecognized mount option \"%s\" "
@@ -1570,9 +1552,6 @@ static int ocfs2_show_options(struct seq_file *s, struct dentry *root)
 	if (opts & OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT)
 		seq_printf(s, ",journal_async_commit");
 
-	if (opts & OCFS2_MOUNT_NOCLUSTER)
-		seq_printf(s, ",nocluster");
-
 	return 0;
 }
 
diff --git a/fs/read_write.c b/fs/read_write.c
index c6db1a0762fa..8d3ec975514d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1250,6 +1250,9 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 					  count, fl);
 		file_end_write(out.file);
 	} else {
+		if (out.file->f_flags & O_NONBLOCK)
+			fl |= SPLICE_F_NONBLOCK;
+
 		retval = splice_file_to_pipe(in.file, opipe, &pos, count, fl);
 	}
 
diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 7ce93aaf69f8..98954dda5734 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -1125,9 +1125,7 @@ static inline void memcpy_toio(volatile void __iomem *addr, const void *buffer,
 }
 #endif
 
-#ifndef CONFIG_GENERIC_DEVMEM_IS_ALLOWED
 extern int devmem_is_allowed(unsigned long pfn);
-#endif
 
 #endif /* __KERNEL__ */
 
diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 59940e230b78..53627afab104 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -403,6 +403,9 @@ static inline bool ip6_ignore_linkdown(const struct net_device *dev)
 {
 	const struct inet6_dev *idev = __in6_dev_get(dev);
 
+	if (unlikely(!idev))
+		return true;
+
 	return !!idev->cnf.ignore_routes_with_linkdown;
 }
 
diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 3c4f550e5a8b..2f766e3437ce 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -847,6 +847,7 @@ enum {
 };
 
 void l2cap_chan_hold(struct l2cap_chan *c);
+struct l2cap_chan *l2cap_chan_hold_unless_zero(struct l2cap_chan *c);
 void l2cap_chan_put(struct l2cap_chan *c);
 
 static inline void l2cap_chan_lock(struct l2cap_chan *chan)
diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index fa6a87246a7b..695ed45841f0 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -315,7 +315,7 @@ void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
 
 struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
 
-#define TCP_PINGPONG_THRESH	3
+#define TCP_PINGPONG_THRESH	1
 
 static inline void inet_csk_enter_pingpong_mode(struct sock *sk)
 {
@@ -332,14 +332,6 @@ static inline bool inet_csk_in_pingpong_mode(struct sock *sk)
 	return inet_csk(sk)->icsk_ack.pingpong >= TCP_PINGPONG_THRESH;
 }
 
-static inline void inet_csk_inc_pingpong_cnt(struct sock *sk)
-{
-	struct inet_connection_sock *icsk = inet_csk(sk);
-
-	if (icsk->icsk_ack.pingpong < U8_MAX)
-		icsk->icsk_ack.pingpong++;
-}
-
 static inline bool inet_csk_has_ulp(struct sock *sk)
 {
 	return inet_sk(sk)->is_icsk && !!inet_csk(sk)->icsk_ulp_ops;
diff --git a/include/net/sock.h b/include/net/sock.h
index 96f51d4b1649..819c53965ef3 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2765,18 +2765,18 @@ static inline int sk_get_wmem0(const struct sock *sk, const struct proto *proto)
 {
 	/* Does this proto have per netns sysctl_wmem ? */
 	if (proto->sysctl_wmem_offset)
-		return *(int *)((void *)sock_net(sk) + proto->sysctl_wmem_offset);
+		return READ_ONCE(*(int *)((void *)sock_net(sk) + proto->sysctl_wmem_offset));
 
-	return *proto->sysctl_wmem;
+	return READ_ONCE(*proto->sysctl_wmem);
 }
 
 static inline int sk_get_rmem0(const struct sock *sk, const struct proto *proto)
 {
 	/* Does this proto have per netns sysctl_rmem ? */
 	if (proto->sysctl_rmem_offset)
-		return *(int *)((void *)sock_net(sk) + proto->sysctl_rmem_offset);
+		return READ_ONCE(*(int *)((void *)sock_net(sk) + proto->sysctl_rmem_offset));
 
-	return *proto->sysctl_rmem;
+	return READ_ONCE(*proto->sysctl_rmem);
 }
 
 /* Default TCP Small queue budget is ~1 ms of data (1sec >> 10)
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 8ce8aafeef0f..76b0d7f2b967 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1406,7 +1406,7 @@ void tcp_select_initial_window(const struct sock *sk, int __space,
 
 static inline int tcp_win_from_space(const struct sock *sk, int space)
 {
-	int tcp_adv_win_scale = sock_net(sk)->ipv4.sysctl_tcp_adv_win_scale;
+	int tcp_adv_win_scale = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_adv_win_scale);
 
 	return tcp_adv_win_scale <= 0 ?
 		(space>>(-tcp_adv_win_scale)) :
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index e63f740c2cc8..4cc73e6f8974 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -335,8 +335,6 @@ struct rwsem_waiter {
 	struct task_struct *task;
 	enum rwsem_waiter_type type;
 	unsigned long timeout;
-
-	/* Writer only, not initialized in reader */
 	bool handoff_set;
 };
 #define rwsem_first_waiter(sem) \
@@ -456,10 +454,12 @@ static void rwsem_mark_wake(struct rw_semaphore *sem,
 			 * to give up the lock), request a HANDOFF to
 			 * force the issue.
 			 */
-			if (!(oldcount & RWSEM_FLAG_HANDOFF) &&
-			    time_after(jiffies, waiter->timeout)) {
-				adjustment -= RWSEM_FLAG_HANDOFF;
-				lockevent_inc(rwsem_rlock_handoff);
+			if (time_after(jiffies, waiter->timeout)) {
+				if (!(oldcount & RWSEM_FLAG_HANDOFF)) {
+					adjustment -= RWSEM_FLAG_HANDOFF;
+					lockevent_inc(rwsem_rlock_handoff);
+				}
+				waiter->handoff_set = true;
 			}
 
 			atomic_long_add(-adjustment, &sem->count);
@@ -569,7 +569,7 @@ static void rwsem_mark_wake(struct rw_semaphore *sem,
 static inline bool rwsem_try_write_lock(struct rw_semaphore *sem,
 					struct rwsem_waiter *waiter)
 {
-	bool first = rwsem_first_waiter(sem) == waiter;
+	struct rwsem_waiter *first = rwsem_first_waiter(sem);
 	long count, new;
 
 	lockdep_assert_held(&sem->wait_lock);
@@ -579,11 +579,20 @@ static inline bool rwsem_try_write_lock(struct rw_semaphore *sem,
 		bool has_handoff = !!(count & RWSEM_FLAG_HANDOFF);
 
 		if (has_handoff) {
-			if (!first)
+			/*
+			 * Honor handoff bit and yield only when the first
+			 * waiter is the one that set it. Otherwisee, we
+			 * still try to acquire the rwsem.
+			 */
+			if (first->handoff_set && (waiter != first))
 				return false;
 
-			/* First waiter inherits a previously set handoff bit */
-			waiter->handoff_set = true;
+			/*
+			 * First waiter can inherit a previously set handoff
+			 * bit and spin on rwsem if lock acquisition fails.
+			 */
+			if (waiter == first)
+				waiter->handoff_set = true;
 		}
 
 		new = count;
@@ -978,6 +987,7 @@ rwsem_down_read_slowpath(struct rw_semaphore *sem, long count, unsigned int stat
 	waiter.task = current;
 	waiter.type = RWSEM_WAITING_FOR_READ;
 	waiter.timeout = jiffies + RWSEM_WAIT_TIMEOUT;
+	waiter.handoff_set = false;
 
 	raw_spin_lock_irq(&sem->wait_lock);
 	if (list_empty(&sem->wait_list)) {
diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index debebcd2664e..1059ef6c3711 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -457,6 +457,33 @@ void init_watch(struct watch *watch, struct watch_queue *wqueue)
 	rcu_assign_pointer(watch->queue, wqueue);
 }
 
+static int add_one_watch(struct watch *watch, struct watch_list *wlist, struct watch_queue *wqueue)
+{
+	const struct cred *cred;
+	struct watch *w;
+
+	hlist_for_each_entry(w, &wlist->watchers, list_node) {
+		struct watch_queue *wq = rcu_access_pointer(w->queue);
+		if (wqueue == wq && watch->id == w->id)
+			return -EBUSY;
+	}
+
+	cred = current_cred();
+	if (atomic_inc_return(&cred->user->nr_watches) > task_rlimit(current, RLIMIT_NOFILE)) {
+		atomic_dec(&cred->user->nr_watches);
+		return -EAGAIN;
+	}
+
+	watch->cred = get_cred(cred);
+	rcu_assign_pointer(watch->watch_list, wlist);
+
+	kref_get(&wqueue->usage);
+	kref_get(&watch->usage);
+	hlist_add_head(&watch->queue_node, &wqueue->watches);
+	hlist_add_head_rcu(&watch->list_node, &wlist->watchers);
+	return 0;
+}
+
 /**
  * add_watch_to_object - Add a watch on an object to a watch list
  * @watch: The watch to add
@@ -471,34 +498,21 @@ void init_watch(struct watch *watch, struct watch_queue *wqueue)
  */
 int add_watch_to_object(struct watch *watch, struct watch_list *wlist)
 {
-	struct watch_queue *wqueue = rcu_access_pointer(watch->queue);
-	struct watch *w;
-
-	hlist_for_each_entry(w, &wlist->watchers, list_node) {
-		struct watch_queue *wq = rcu_access_pointer(w->queue);
-		if (wqueue == wq && watch->id == w->id)
-			return -EBUSY;
-	}
-
-	watch->cred = get_current_cred();
-	rcu_assign_pointer(watch->watch_list, wlist);
+	struct watch_queue *wqueue;
+	int ret = -ENOENT;
 
-	if (atomic_inc_return(&watch->cred->user->nr_watches) >
-	    task_rlimit(current, RLIMIT_NOFILE)) {
-		atomic_dec(&watch->cred->user->nr_watches);
-		put_cred(watch->cred);
-		return -EAGAIN;
-	}
+	rcu_read_lock();
 
+	wqueue = rcu_access_pointer(watch->queue);
 	if (lock_wqueue(wqueue)) {
-		kref_get(&wqueue->usage);
-		kref_get(&watch->usage);
-		hlist_add_head(&watch->queue_node, &wqueue->watches);
+		spin_lock(&wlist->lock);
+		ret = add_one_watch(watch, wlist, wqueue);
+		spin_unlock(&wlist->lock);
 		unlock_wqueue(wqueue);
 	}
 
-	hlist_add_head(&watch->list_node, &wlist->watchers);
-	return 0;
+	rcu_read_unlock();
+	return ret;
 }
 EXPORT_SYMBOL(add_watch_to_object);
 
diff --git a/mm/hmm.c b/mm/hmm.c
index bd56641c79d4..3af995c814a6 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -212,14 +212,6 @@ int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 		unsigned long end, unsigned long hmm_pfns[], pmd_t pmd);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static inline bool hmm_is_device_private_entry(struct hmm_range *range,
-		swp_entry_t entry)
-{
-	return is_device_private_entry(entry) &&
-		pfn_swap_entry_to_page(entry)->pgmap->owner ==
-		range->dev_private_owner;
-}
-
 static inline unsigned long pte_to_hmm_pfn_flags(struct hmm_range *range,
 						 pte_t pte)
 {
@@ -252,10 +244,12 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		swp_entry_t entry = pte_to_swp_entry(pte);
 
 		/*
-		 * Never fault in device private pages, but just report
-		 * the PFN even if not present.
+		 * Don't fault in device private pages owned by the caller,
+		 * just report the PFN.
 		 */
-		if (hmm_is_device_private_entry(range, entry)) {
+		if (is_device_private_entry(entry) &&
+		    pfn_swap_entry_to_page(entry)->pgmap->owner ==
+		    range->dev_private_owner) {
 			cpu_flags = HMM_PFN_VALID;
 			if (is_writable_device_private_entry(entry))
 				cpu_flags |= HMM_PFN_WRITE;
@@ -273,6 +267,9 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		if (!non_swap_entry(entry))
 			goto fault;
 
+		if (is_device_private_entry(entry))
+			goto fault;
+
 		if (is_device_exclusive_entry(entry))
 			goto fault;
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index eed96302897a..405793b8cf0d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5314,6 +5314,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 
 		page = alloc_huge_page(dst_vma, dst_addr, 0);
 		if (IS_ERR(page)) {
+			put_page(*pagep);
 			ret = -ENOMEM;
 			*pagep = NULL;
 			goto out;
diff --git a/mm/memory.c b/mm/memory.c
index 036eb765c4e8..a4d0f744a458 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4071,9 +4071,12 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 		}
 	}
 
-	/* See comment in handle_pte_fault() */
+	/*
+	 * See comment in handle_pte_fault() for how this scenario happens, we
+	 * need to return NOPAGE so that we drop this page.
+	 */
 	if (pmd_devmap_trans_unstable(vmf->pmd))
-		return 0;
+		return VM_FAULT_NOPAGE;
 
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 				      vmf->address, &vmf->ptl);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a0b7afae59e9..61d7967897ce 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3928,11 +3928,15 @@ static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
 	 * need to be calculated.
 	 */
 	if (!order) {
-		long fast_free;
+		long usable_free;
+		long reserved;
 
-		fast_free = free_pages;
-		fast_free -= __zone_watermark_unusable_free(z, 0, alloc_flags);
-		if (fast_free > mark + z->lowmem_reserve[highest_zoneidx])
+		usable_free = free_pages;
+		reserved = __zone_watermark_unusable_free(z, 0, alloc_flags);
+
+		/* reserved may over estimate high-atomic reserves. */
+		usable_free -= min(usable_free, reserved);
+		if (usable_free > mark + z->lowmem_reserve[highest_zoneidx])
 			return true;
 	}
 
diff --git a/mm/secretmem.c b/mm/secretmem.c
index 5a62ef3bcfcf..14f49c0aa66e 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -55,22 +55,28 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 	gfp_t gfp = vmf->gfp_mask;
 	unsigned long addr;
 	struct page *page;
+	vm_fault_t ret;
 	int err;
 
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
 		return vmf_error(-EINVAL);
 
+	filemap_invalidate_lock_shared(mapping);
+
 retry:
 	page = find_lock_page(mapping, offset);
 	if (!page) {
 		page = alloc_page(gfp | __GFP_ZERO);
-		if (!page)
-			return VM_FAULT_OOM;
+		if (!page) {
+			ret = VM_FAULT_OOM;
+			goto out;
+		}
 
 		err = set_direct_map_invalid_noflush(page);
 		if (err) {
 			put_page(page);
-			return vmf_error(err);
+			ret = vmf_error(err);
+			goto out;
 		}
 
 		__SetPageUptodate(page);
@@ -86,7 +92,8 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 			if (err == -EEXIST)
 				goto retry;
 
-			return vmf_error(err);
+			ret = vmf_error(err);
+			goto out;
 		}
 
 		addr = (unsigned long)page_address(page);
@@ -94,7 +101,11 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 	}
 
 	vmf->page = page;
-	return VM_FAULT_LOCKED;
+	ret = VM_FAULT_LOCKED;
+
+out:
+	filemap_invalidate_unlock_shared(mapping);
+	return ret;
 }
 
 static const struct vm_operations_struct secretmem_vm_ops = {
@@ -162,12 +173,20 @@ static int secretmem_setattr(struct user_namespace *mnt_userns,
 			     struct dentry *dentry, struct iattr *iattr)
 {
 	struct inode *inode = d_inode(dentry);
+	struct address_space *mapping = inode->i_mapping;
 	unsigned int ia_valid = iattr->ia_valid;
+	int ret;
+
+	filemap_invalidate_lock(mapping);
 
 	if ((ia_valid & ATTR_SIZE) && inode->i_size)
-		return -EINVAL;
+		ret = -EINVAL;
+	else
+		ret = simple_setattr(mnt_userns, dentry, iattr);
 
-	return simple_setattr(mnt_userns, dentry, iattr);
+	filemap_invalidate_unlock(mapping);
+
+	return ret;
 }
 
 static const struct inode_operations secretmem_iops = {
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index c57a45df7a26..780073f6affc 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -111,7 +111,8 @@ static struct l2cap_chan *__l2cap_get_chan_by_scid(struct l2cap_conn *conn,
 }
 
 /* Find channel with given SCID.
- * Returns locked channel. */
+ * Returns a reference locked channel.
+ */
 static struct l2cap_chan *l2cap_get_chan_by_scid(struct l2cap_conn *conn,
 						 u16 cid)
 {
@@ -119,15 +120,19 @@ static struct l2cap_chan *l2cap_get_chan_by_scid(struct l2cap_conn *conn,
 
 	mutex_lock(&conn->chan_lock);
 	c = __l2cap_get_chan_by_scid(conn, cid);
-	if (c)
-		l2cap_chan_lock(c);
+	if (c) {
+		/* Only lock if chan reference is not 0 */
+		c = l2cap_chan_hold_unless_zero(c);
+		if (c)
+			l2cap_chan_lock(c);
+	}
 	mutex_unlock(&conn->chan_lock);
 
 	return c;
 }
 
 /* Find channel with given DCID.
- * Returns locked channel.
+ * Returns a reference locked channel.
  */
 static struct l2cap_chan *l2cap_get_chan_by_dcid(struct l2cap_conn *conn,
 						 u16 cid)
@@ -136,8 +141,12 @@ static struct l2cap_chan *l2cap_get_chan_by_dcid(struct l2cap_conn *conn,
 
 	mutex_lock(&conn->chan_lock);
 	c = __l2cap_get_chan_by_dcid(conn, cid);
-	if (c)
-		l2cap_chan_lock(c);
+	if (c) {
+		/* Only lock if chan reference is not 0 */
+		c = l2cap_chan_hold_unless_zero(c);
+		if (c)
+			l2cap_chan_lock(c);
+	}
 	mutex_unlock(&conn->chan_lock);
 
 	return c;
@@ -162,8 +171,12 @@ static struct l2cap_chan *l2cap_get_chan_by_ident(struct l2cap_conn *conn,
 
 	mutex_lock(&conn->chan_lock);
 	c = __l2cap_get_chan_by_ident(conn, ident);
-	if (c)
-		l2cap_chan_lock(c);
+	if (c) {
+		/* Only lock if chan reference is not 0 */
+		c = l2cap_chan_hold_unless_zero(c);
+		if (c)
+			l2cap_chan_lock(c);
+	}
 	mutex_unlock(&conn->chan_lock);
 
 	return c;
@@ -497,6 +510,16 @@ void l2cap_chan_hold(struct l2cap_chan *c)
 	kref_get(&c->kref);
 }
 
+struct l2cap_chan *l2cap_chan_hold_unless_zero(struct l2cap_chan *c)
+{
+	BT_DBG("chan %p orig refcnt %u", c, kref_read(&c->kref));
+
+	if (!kref_get_unless_zero(&c->kref))
+		return NULL;
+
+	return c;
+}
+
 void l2cap_chan_put(struct l2cap_chan *c)
 {
 	BT_DBG("chan %p orig refcnt %u", c, kref_read(&c->kref));
@@ -1969,7 +1992,10 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
 			src_match = !bacmp(&c->src, src);
 			dst_match = !bacmp(&c->dst, dst);
 			if (src_match && dst_match) {
-				l2cap_chan_hold(c);
+				c = l2cap_chan_hold_unless_zero(c);
+				if (!c)
+					continue;
+
 				read_unlock(&chan_list_lock);
 				return c;
 			}
@@ -1984,7 +2010,7 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
 	}
 
 	if (c1)
-		l2cap_chan_hold(c1);
+		c1 = l2cap_chan_hold_unless_zero(c1);
 
 	read_unlock(&chan_list_lock);
 
@@ -4464,6 +4490,7 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
 
 unlock:
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 	return err;
 }
 
@@ -4578,6 +4605,7 @@ static inline int l2cap_config_rsp(struct l2cap_conn *conn,
 
 done:
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 	return err;
 }
 
@@ -5305,6 +5333,7 @@ static inline int l2cap_move_channel_req(struct l2cap_conn *conn,
 	l2cap_send_move_chan_rsp(chan, result);
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return 0;
 }
@@ -5397,6 +5426,7 @@ static void l2cap_move_continue(struct l2cap_conn *conn, u16 icid, u16 result)
 	}
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 }
 
 static void l2cap_move_fail(struct l2cap_conn *conn, u8 ident, u16 icid,
@@ -5426,6 +5456,7 @@ static void l2cap_move_fail(struct l2cap_conn *conn, u8 ident, u16 icid,
 	l2cap_send_move_chan_cfm(chan, L2CAP_MC_UNCONFIRMED);
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 }
 
 static int l2cap_move_channel_rsp(struct l2cap_conn *conn,
@@ -5489,6 +5520,7 @@ static int l2cap_move_channel_confirm(struct l2cap_conn *conn,
 	l2cap_send_move_chan_cfm_rsp(conn, cmd->ident, icid);
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return 0;
 }
@@ -5524,6 +5556,7 @@ static inline int l2cap_move_channel_confirm_rsp(struct l2cap_conn *conn,
 	}
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return 0;
 }
@@ -5896,12 +5929,11 @@ static inline int l2cap_le_credits(struct l2cap_conn *conn,
 	if (credits > max_credits) {
 		BT_ERR("LE credits overflow");
 		l2cap_send_disconn_req(chan, ECONNRESET);
-		l2cap_chan_unlock(chan);
 
 		/* Return 0 so that we don't trigger an unnecessary
 		 * command reject packet.
 		 */
-		return 0;
+		goto unlock;
 	}
 
 	chan->tx_credits += credits;
@@ -5912,7 +5944,9 @@ static inline int l2cap_le_credits(struct l2cap_conn *conn,
 	if (chan->tx_credits)
 		chan->ops->resume(chan);
 
+unlock:
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return 0;
 }
@@ -7598,6 +7632,7 @@ static void l2cap_data_channel(struct l2cap_conn *conn, u16 cid,
 
 done:
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 }
 
 static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
@@ -8086,7 +8121,7 @@ static struct l2cap_chan *l2cap_global_fixed_chan(struct l2cap_chan *c,
 		if (src_type != c->src_type)
 			continue;
 
-		l2cap_chan_hold(c);
+		c = l2cap_chan_hold_unless_zero(c);
 		read_unlock(&chan_list_lock);
 		return c;
 	}
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index dc92a67baea3..7d542eb46172 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -480,8 +480,8 @@ static struct sock *dn_alloc_sock(struct net *net, struct socket *sock, gfp_t gf
 	sk->sk_family      = PF_DECnet;
 	sk->sk_protocol    = 0;
 	sk->sk_allocation  = gfp;
-	sk->sk_sndbuf	   = sysctl_decnet_wmem[1];
-	sk->sk_rcvbuf	   = sysctl_decnet_rmem[1];
+	sk->sk_sndbuf	   = READ_ONCE(sysctl_decnet_wmem[1]);
+	sk->sk_rcvbuf	   = READ_ONCE(sysctl_decnet_rmem[1]);
 
 	/* Initialization of DECnet Session Control Port		*/
 	scp = DN_SK(sk);
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index a9cd9c2bd84e..19c6e7b93d3d 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1037,6 +1037,7 @@ fib_find_matching_alias(struct net *net, const struct fib_rt_info *fri)
 
 void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri)
 {
+	u8 fib_notify_on_flag_change;
 	struct fib_alias *fa_match;
 	struct sk_buff *skb;
 	int err;
@@ -1058,14 +1059,16 @@ void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri)
 	WRITE_ONCE(fa_match->offload, fri->offload);
 	WRITE_ONCE(fa_match->trap, fri->trap);
 
+	fib_notify_on_flag_change = READ_ONCE(net->ipv4.sysctl_fib_notify_on_flag_change);
+
 	/* 2 means send notifications only if offload_failed was changed. */
-	if (net->ipv4.sysctl_fib_notify_on_flag_change == 2 &&
+	if (fib_notify_on_flag_change == 2 &&
 	    READ_ONCE(fa_match->offload_failed) == fri->offload_failed)
 		goto out;
 
 	WRITE_ONCE(fa_match->offload_failed, fri->offload_failed);
 
-	if (!net->ipv4.sysctl_fib_notify_on_flag_change)
+	if (!fib_notify_on_flag_change)
 		goto out;
 
 	skb = nlmsg_new(fib_nlmsg_size(fa_match->fa_info), GFP_ATOMIC);
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 9f4674244aff..e07d10b2c486 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -827,7 +827,7 @@ static void igmp_ifc_event(struct in_device *in_dev)
 	struct net *net = dev_net(in_dev->dev);
 	if (IGMP_V1_SEEN(in_dev) || IGMP_V2_SEEN(in_dev))
 		return;
-	WRITE_ONCE(in_dev->mr_ifc_count, in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv);
+	WRITE_ONCE(in_dev->mr_ifc_count, in_dev->mr_qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv));
 	igmp_ifc_start_timer(in_dev, 1);
 }
 
@@ -1009,7 +1009,7 @@ static bool igmp_heard_query(struct in_device *in_dev, struct sk_buff *skb,
 		 * received value was zero, use the default or statically
 		 * configured value.
 		 */
-		in_dev->mr_qrv = ih3->qrv ?: net->ipv4.sysctl_igmp_qrv;
+		in_dev->mr_qrv = ih3->qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 		in_dev->mr_qi = IGMPV3_QQIC(ih3->qqic)*HZ ?: IGMP_QUERY_INTERVAL;
 
 		/* RFC3376, 8.3. Query Response Interval:
@@ -1189,7 +1189,7 @@ static void igmpv3_add_delrec(struct in_device *in_dev, struct ip_mc_list *im,
 	pmc->interface = im->interface;
 	in_dev_hold(in_dev);
 	pmc->multiaddr = im->multiaddr;
-	pmc->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+	pmc->crcount = in_dev->mr_qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 	pmc->sfmode = im->sfmode;
 	if (pmc->sfmode == MCAST_INCLUDE) {
 		struct ip_sf_list *psf;
@@ -1240,9 +1240,11 @@ static void igmpv3_del_delrec(struct in_device *in_dev, struct ip_mc_list *im)
 			swap(im->tomb, pmc->tomb);
 			swap(im->sources, pmc->sources);
 			for (psf = im->sources; psf; psf = psf->sf_next)
-				psf->sf_crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+				psf->sf_crcount = in_dev->mr_qrv ?:
+					READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 		} else {
-			im->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+			im->crcount = in_dev->mr_qrv ?:
+				READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 		}
 		in_dev_put(pmc->interface);
 		kfree_pmc(pmc);
@@ -1349,7 +1351,7 @@ static void igmp_group_added(struct ip_mc_list *im)
 	if (in_dev->dead)
 		return;
 
-	im->unsolicit_count = net->ipv4.sysctl_igmp_qrv;
+	im->unsolicit_count = READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 	if (IGMP_V1_SEEN(in_dev) || IGMP_V2_SEEN(in_dev)) {
 		spin_lock_bh(&im->lock);
 		igmp_start_timer(im, IGMP_INITIAL_REPORT_DELAY);
@@ -1363,7 +1365,7 @@ static void igmp_group_added(struct ip_mc_list *im)
 	 * IN() to IN(A).
 	 */
 	if (im->sfmode == MCAST_EXCLUDE)
-		im->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+		im->crcount = in_dev->mr_qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 
 	igmp_ifc_event(in_dev);
 #endif
@@ -1754,7 +1756,7 @@ static void ip_mc_reset(struct in_device *in_dev)
 
 	in_dev->mr_qi = IGMP_QUERY_INTERVAL;
 	in_dev->mr_qri = IGMP_QUERY_RESPONSE_INTERVAL;
-	in_dev->mr_qrv = net->ipv4.sysctl_igmp_qrv;
+	in_dev->mr_qrv = READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 }
 #else
 static void ip_mc_reset(struct in_device *in_dev)
@@ -1888,7 +1890,7 @@ static int ip_mc_del1_src(struct ip_mc_list *pmc, int sfmode,
 #ifdef CONFIG_IP_MULTICAST
 		if (psf->sf_oldin &&
 		    !IGMP_V1_SEEN(in_dev) && !IGMP_V2_SEEN(in_dev)) {
-			psf->sf_crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+			psf->sf_crcount = in_dev->mr_qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 			psf->sf_next = pmc->tomb;
 			pmc->tomb = psf;
 			rv = 1;
@@ -1952,7 +1954,7 @@ static int ip_mc_del_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
 		/* filter mode change */
 		pmc->sfmode = MCAST_INCLUDE;
 #ifdef CONFIG_IP_MULTICAST
-		pmc->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+		pmc->crcount = in_dev->mr_qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 		WRITE_ONCE(in_dev->mr_ifc_count, pmc->crcount);
 		for (psf = pmc->sources; psf; psf = psf->sf_next)
 			psf->sf_crcount = 0;
@@ -2131,7 +2133,7 @@ static int ip_mc_add_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
 #ifdef CONFIG_IP_MULTICAST
 		/* else no filters; keep old mode for reports */
 
-		pmc->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+		pmc->crcount = in_dev->mr_qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 		WRITE_ONCE(in_dev->mr_ifc_count, pmc->crcount);
 		for (psf = pmc->sources; psf; psf = psf->sf_next)
 			psf->sf_crcount = 0;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 1abdb8712655..2097eeaf30a6 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -458,8 +458,8 @@ void tcp_init_sock(struct sock *sk)
 
 	icsk->icsk_sync_mss = tcp_sync_mss;
 
-	WRITE_ONCE(sk->sk_sndbuf, sock_net(sk)->ipv4.sysctl_tcp_wmem[1]);
-	WRITE_ONCE(sk->sk_rcvbuf, sock_net(sk)->ipv4.sysctl_tcp_rmem[1]);
+	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[1]));
+	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[1]));
 
 	sk_sockets_allocated_inc(sk);
 	sk->sk_route_forced_caps = NETIF_F_GSO;
@@ -694,7 +694,7 @@ static bool tcp_should_autocork(struct sock *sk, struct sk_buff *skb,
 				int size_goal)
 {
 	return skb->len < size_goal &&
-	       sock_net(sk)->ipv4.sysctl_tcp_autocorking &&
+	       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_autocorking) &&
 	       !tcp_rtx_queue_empty(sk) &&
 	       refcount_read(&sk->sk_wmem_alloc) > skb->truesize;
 }
@@ -1722,7 +1722,7 @@ int tcp_set_rcvlowat(struct sock *sk, int val)
 	if (sk->sk_userlocks & SOCK_RCVBUF_LOCK)
 		cap = sk->sk_rcvbuf >> 1;
 	else
-		cap = sock_net(sk)->ipv4.sysctl_tcp_rmem[2] >> 1;
+		cap = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]) >> 1;
 	val = min(val, cap);
 	WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2d21d8bf3b8c..a33e6aa42a4c 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -426,7 +426,7 @@ static void tcp_sndbuf_expand(struct sock *sk)
 
 	if (sk->sk_sndbuf < sndmem)
 		WRITE_ONCE(sk->sk_sndbuf,
-			   min(sndmem, sock_net(sk)->ipv4.sysctl_tcp_wmem[2]));
+			   min(sndmem, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[2])));
 }
 
 /* 2. Tuning advertised window (window_clamp, rcv_ssthresh)
@@ -461,7 +461,7 @@ static int __tcp_grow_window(const struct sock *sk, const struct sk_buff *skb,
 	struct tcp_sock *tp = tcp_sk(sk);
 	/* Optimize this! */
 	int truesize = tcp_win_from_space(sk, skbtruesize) >> 1;
-	int window = tcp_win_from_space(sk, sock_net(sk)->ipv4.sysctl_tcp_rmem[2]) >> 1;
+	int window = tcp_win_from_space(sk, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2])) >> 1;
 
 	while (tp->rcv_ssthresh <= window) {
 		if (truesize <= skb->len)
@@ -526,7 +526,7 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb,
  */
 static void tcp_init_buffer_space(struct sock *sk)
 {
-	int tcp_app_win = sock_net(sk)->ipv4.sysctl_tcp_app_win;
+	int tcp_app_win = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_app_win);
 	struct tcp_sock *tp = tcp_sk(sk);
 	int maxwin;
 
@@ -566,16 +566,17 @@ static void tcp_clamp_window(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct net *net = sock_net(sk);
+	int rmem2;
 
 	icsk->icsk_ack.quick = 0;
+	rmem2 = READ_ONCE(net->ipv4.sysctl_tcp_rmem[2]);
 
-	if (sk->sk_rcvbuf < net->ipv4.sysctl_tcp_rmem[2] &&
+	if (sk->sk_rcvbuf < rmem2 &&
 	    !(sk->sk_userlocks & SOCK_RCVBUF_LOCK) &&
 	    !tcp_under_memory_pressure(sk) &&
 	    sk_memory_allocated(sk) < sk_prot_mem_limits(sk, 0)) {
 		WRITE_ONCE(sk->sk_rcvbuf,
-			   min(atomic_read(&sk->sk_rmem_alloc),
-			       net->ipv4.sysctl_tcp_rmem[2]));
+			   min(atomic_read(&sk->sk_rmem_alloc), rmem2));
 	}
 	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
 		tp->rcv_ssthresh = min(tp->window_clamp, 2U * tp->advmss);
@@ -716,7 +717,7 @@ void tcp_rcv_space_adjust(struct sock *sk)
 	 * <prev RTT . ><current RTT .. ><next RTT .... >
 	 */
 
-	if (sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf &&
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf) &&
 	    !(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
 		int rcvmem, rcvbuf;
 		u64 rcvwin, grow;
@@ -737,7 +738,7 @@ void tcp_rcv_space_adjust(struct sock *sk)
 
 		do_div(rcvwin, tp->advmss);
 		rcvbuf = min_t(u64, rcvwin * rcvmem,
-			       sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
+			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
 		if (rcvbuf > sk->sk_rcvbuf) {
 			WRITE_ONCE(sk->sk_rcvbuf, rcvbuf);
 
@@ -902,9 +903,9 @@ static void tcp_update_pacing_rate(struct sock *sk)
 	 *	 end of slow start and should slow down.
 	 */
 	if (tcp_snd_cwnd(tp) < tp->snd_ssthresh / 2)
-		rate *= sock_net(sk)->ipv4.sysctl_tcp_pacing_ss_ratio;
+		rate *= READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_pacing_ss_ratio);
 	else
-		rate *= sock_net(sk)->ipv4.sysctl_tcp_pacing_ca_ratio;
+		rate *= READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_pacing_ca_ratio);
 
 	rate *= max(tcp_snd_cwnd(tp), tp->packets_out);
 
@@ -2167,7 +2168,7 @@ void tcp_enter_loss(struct sock *sk)
 	 * loss recovery is underway except recurring timeout(s) on
 	 * the same SND.UNA (sec 3.2). Disable F-RTO on path MTU probing
 	 */
-	tp->frto = net->ipv4.sysctl_tcp_frto &&
+	tp->frto = READ_ONCE(net->ipv4.sysctl_tcp_frto) &&
 		   (new_recovery || icsk->icsk_retransmits) &&
 		   !inet_csk(sk)->icsk_mtup.probe_size;
 }
@@ -3050,7 +3051,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 
 static void tcp_update_rtt_min(struct sock *sk, u32 rtt_us, const int flag)
 {
-	u32 wlen = sock_net(sk)->ipv4.sysctl_tcp_min_rtt_wlen * HZ;
+	u32 wlen = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_min_rtt_wlen) * HZ;
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	if ((flag & FLAG_ACK_MAYBE_DELAYED) && rtt_us > tcp_min_rtt(tp)) {
@@ -3574,7 +3575,8 @@ static bool __tcp_oow_rate_limited(struct net *net, int mib_idx,
 	if (*last_oow_ack_time) {
 		s32 elapsed = (s32)(tcp_jiffies32 - *last_oow_ack_time);
 
-		if (0 <= elapsed && elapsed < net->ipv4.sysctl_tcp_invalid_ratelimit) {
+		if (0 <= elapsed &&
+		    elapsed < READ_ONCE(net->ipv4.sysctl_tcp_invalid_ratelimit)) {
 			NET_INC_STATS(net, mib_idx);
 			return true;	/* rate-limited: don't send yet! */
 		}
@@ -3622,7 +3624,7 @@ static void tcp_send_challenge_ack(struct sock *sk, const struct sk_buff *skb)
 	/* Then check host-wide RFC 5961 rate limit. */
 	now = jiffies / HZ;
 	if (now != challenge_timestamp) {
-		u32 ack_limit = net->ipv4.sysctl_tcp_challenge_ack_limit;
+		u32 ack_limit = READ_ONCE(net->ipv4.sysctl_tcp_challenge_ack_limit);
 		u32 half = (ack_limit + 1) >> 1;
 
 		challenge_timestamp = now;
@@ -4419,7 +4421,7 @@ static void tcp_dsack_set(struct sock *sk, u32 seq, u32 end_seq)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	if (tcp_is_sack(tp) && sock_net(sk)->ipv4.sysctl_tcp_dsack) {
+	if (tcp_is_sack(tp) && READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_dsack)) {
 		int mib_idx;
 
 		if (before(seq, tp->rcv_nxt))
@@ -4466,7 +4468,7 @@ static void tcp_send_dupack(struct sock *sk, const struct sk_buff *skb)
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_DELAYEDACKLOST);
 		tcp_enter_quickack_mode(sk, TCP_MAX_QUICKACKS);
 
-		if (tcp_is_sack(tp) && sock_net(sk)->ipv4.sysctl_tcp_dsack) {
+		if (tcp_is_sack(tp) && READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_dsack)) {
 			u32 end_seq = TCP_SKB_CB(skb)->end_seq;
 
 			tcp_rcv_spurious_retrans(sk, skb);
@@ -5489,7 +5491,7 @@ static void __tcp_ack_snd_check(struct sock *sk, int ofo_possible)
 	}
 
 	if (!tcp_is_sack(tp) ||
-	    tp->compressed_ack >= sock_net(sk)->ipv4.sysctl_tcp_comp_sack_nr)
+	    tp->compressed_ack >= READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_nr))
 		goto send_now;
 
 	if (tp->compressed_ack_rcv_nxt != tp->rcv_nxt) {
@@ -5510,11 +5512,12 @@ static void __tcp_ack_snd_check(struct sock *sk, int ofo_possible)
 	if (tp->srtt_us && tp->srtt_us < rtt)
 		rtt = tp->srtt_us;
 
-	delay = min_t(unsigned long, sock_net(sk)->ipv4.sysctl_tcp_comp_sack_delay_ns,
+	delay = min_t(unsigned long,
+		      READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_delay_ns),
 		      rtt * (NSEC_PER_USEC >> 3)/20);
 	sock_hold(sk);
 	hrtimer_start_range_ns(&tp->compressed_ack_timer, ns_to_ktime(delay),
-			       sock_net(sk)->ipv4.sysctl_tcp_comp_sack_slack_ns,
+			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_slack_ns),
 			       HRTIMER_MODE_REL_PINNED_SOFT);
 }
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index fba02cf6b468..dae0776c4948 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1004,7 +1004,7 @@ static int tcp_v4_send_synack(const struct sock *sk, struct dst_entry *dst,
 	if (skb) {
 		__tcp_v4_send_check(skb, ireq->ir_loc_addr, ireq->ir_rmt_addr);
 
-		tos = sock_net(sk)->ipv4.sysctl_tcp_reflect_tos ?
+		tos = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reflect_tos) ?
 				(tcp_rsk(req)->syn_tos & ~INET_ECN_MASK) |
 				(inet_sk(sk)->tos & INET_ECN_MASK) :
 				inet_sk(sk)->tos;
@@ -1590,7 +1590,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	/* Set ToS of the new socket based upon the value of incoming SYN.
 	 * ECT bits are set later in tcp_init_transfer().
 	 */
-	if (sock_net(sk)->ipv4.sysctl_tcp_reflect_tos)
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reflect_tos))
 		newinet->tos = tcp_rsk(req)->syn_tos & ~INET_ECN_MASK;
 
 	if (!dst) {
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index a501150deaa3..d58e672be31c 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -329,7 +329,7 @@ void tcp_update_metrics(struct sock *sk)
 	int m;
 
 	sk_dst_confirm(sk);
-	if (net->ipv4.sysctl_tcp_nometrics_save || !dst)
+	if (READ_ONCE(net->ipv4.sysctl_tcp_nometrics_save) || !dst)
 		return;
 
 	rcu_read_lock();
@@ -385,7 +385,7 @@ void tcp_update_metrics(struct sock *sk)
 
 	if (tcp_in_initial_slowstart(tp)) {
 		/* Slow start still did not finish. */
-		if (!net->ipv4.sysctl_tcp_no_ssthresh_metrics_save &&
+		if (!READ_ONCE(net->ipv4.sysctl_tcp_no_ssthresh_metrics_save) &&
 		    !tcp_metric_locked(tm, TCP_METRIC_SSTHRESH)) {
 			val = tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
 			if (val && (tcp_snd_cwnd(tp) >> 1) > val)
@@ -401,7 +401,7 @@ void tcp_update_metrics(struct sock *sk)
 	} else if (!tcp_in_slow_start(tp) &&
 		   icsk->icsk_ca_state == TCP_CA_Open) {
 		/* Cong. avoidance phase, cwnd is reliable. */
-		if (!net->ipv4.sysctl_tcp_no_ssthresh_metrics_save &&
+		if (!READ_ONCE(net->ipv4.sysctl_tcp_no_ssthresh_metrics_save) &&
 		    !tcp_metric_locked(tm, TCP_METRIC_SSTHRESH))
 			tcp_metric_set(tm, TCP_METRIC_SSTHRESH,
 				       max(tcp_snd_cwnd(tp) >> 1, tp->snd_ssthresh));
@@ -418,7 +418,7 @@ void tcp_update_metrics(struct sock *sk)
 			tcp_metric_set(tm, TCP_METRIC_CWND,
 				       (val + tp->snd_ssthresh) >> 1);
 		}
-		if (!net->ipv4.sysctl_tcp_no_ssthresh_metrics_save &&
+		if (!READ_ONCE(net->ipv4.sysctl_tcp_no_ssthresh_metrics_save) &&
 		    !tcp_metric_locked(tm, TCP_METRIC_SSTHRESH)) {
 			val = tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
 			if (val && tp->snd_ssthresh > val)
@@ -463,7 +463,7 @@ void tcp_init_metrics(struct sock *sk)
 	if (tcp_metric_locked(tm, TCP_METRIC_CWND))
 		tp->snd_cwnd_clamp = tcp_metric_get(tm, TCP_METRIC_CWND);
 
-	val = net->ipv4.sysctl_tcp_no_ssthresh_metrics_save ?
+	val = READ_ONCE(net->ipv4.sysctl_tcp_no_ssthresh_metrics_save) ?
 	      0 : tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
 	if (val) {
 		tp->snd_ssthresh = val;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index caf9283f9b0f..9c9a0f7a3dee 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -167,16 +167,13 @@ static void tcp_event_data_sent(struct tcp_sock *tp,
 	if (tcp_packets_in_flight(tp) == 0)
 		tcp_ca_event(sk, CA_EVENT_TX_START);
 
-	/* If this is the first data packet sent in response to the
-	 * previous received data,
-	 * and it is a reply for ato after last received packet,
-	 * increase pingpong count.
-	 */
-	if (before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
-	    (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
-		inet_csk_inc_pingpong_cnt(sk);
-
 	tp->lsndtime = now;
+
+	/* If it is a reply for ato after last received
+	 * packet, enter pingpong mode.
+	 */
+	if ((u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
+		inet_csk_enter_pingpong_mode(sk);
 }
 
 /* Account for an ACK we sent. */
@@ -241,7 +238,7 @@ void tcp_select_initial_window(const struct sock *sk, int __space, __u32 mss,
 	*rcv_wscale = 0;
 	if (wscale_ok) {
 		/* Set window scaling on max possible window */
-		space = max_t(u32, space, sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
+		space = max_t(u32, space, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
 		space = max_t(u32, space, sysctl_rmem_max);
 		space = min_t(u32, space, *window_clamp);
 		*rcv_wscale = clamp_t(int, ilog2(space) - 15,
@@ -1989,7 +1986,7 @@ static u32 tcp_tso_segs(struct sock *sk, unsigned int mss_now)
 
 	min_tso = ca_ops->min_tso_segs ?
 			ca_ops->min_tso_segs(sk) :
-			sock_net(sk)->ipv4.sysctl_tcp_min_tso_segs;
+			READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_min_tso_segs);
 
 	tso_segs = tcp_tso_autosize(sk, mss_now, min_tso);
 	return min_t(u32, tso_segs, sk->sk_gso_max_segs);
@@ -2506,7 +2503,7 @@ static bool tcp_small_queue_check(struct sock *sk, const struct sk_buff *skb,
 		      sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift));
 	if (sk->sk_pacing_status == SK_PACING_NONE)
 		limit = min_t(unsigned long, limit,
-			      sock_net(sk)->ipv4.sysctl_tcp_limit_output_bytes);
+			      READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_limit_output_bytes));
 	limit <<= factor;
 
 	if (static_branch_unlikely(&tcp_tx_delay_enabled) &&
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 7f695c39d9a8..87c699d57b36 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1522,7 +1522,6 @@ static void mld_query_work(struct work_struct *work)
 
 		if (++cnt >= MLD_MAX_QUEUE) {
 			rework = true;
-			schedule_delayed_work(&idev->mc_query_work, 0);
 			break;
 		}
 	}
@@ -1533,8 +1532,10 @@ static void mld_query_work(struct work_struct *work)
 		__mld_query_work(skb);
 	mutex_unlock(&idev->mc_lock);
 
-	if (!rework)
-		in6_dev_put(idev);
+	if (rework && queue_delayed_work(mld_wq, &idev->mc_query_work, 0))
+		return;
+
+	in6_dev_put(idev);
 }
 
 /* called with rcu_read_lock() */
@@ -1624,7 +1625,6 @@ static void mld_report_work(struct work_struct *work)
 
 		if (++cnt >= MLD_MAX_QUEUE) {
 			rework = true;
-			schedule_delayed_work(&idev->mc_report_work, 0);
 			break;
 		}
 	}
@@ -1635,8 +1635,10 @@ static void mld_report_work(struct work_struct *work)
 		__mld_report_work(skb);
 	mutex_unlock(&idev->mc_lock);
 
-	if (!rework)
-		in6_dev_put(idev);
+	if (rework && queue_delayed_work(mld_wq, &idev->mc_report_work, 0))
+		return;
+
+	in6_dev_put(idev);
 }
 
 static bool is_in(struct ifmcaddr6 *pmc, struct ip6_sf_list *psf, int type,
diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 6ac88fe24a8e..135e3a060caa 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -22,6 +22,11 @@
 #include <linux/proc_fs.h>
 #include <net/ping.h>
 
+static void ping_v6_destroy(struct sock *sk)
+{
+	inet6_destroy_sock(sk);
+}
+
 /* Compatibility glue so we can support IPv6 when it's compiled as a module */
 static int dummy_ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len,
 				 int *addr_len)
@@ -166,6 +171,7 @@ struct proto pingv6_prot = {
 	.owner =	THIS_MODULE,
 	.init =		ping_init_sock,
 	.close =	ping_close,
+	.destroy =	ping_v6_destroy,
 	.connect =	ip6_datagram_connect_v6_only,
 	.disconnect =	__udp_disconnect,
 	.setsockopt =	ipv6_setsockopt,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index beaa0c2ada23..8ab39cf57d43 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -542,7 +542,7 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 		if (np->repflow && ireq->pktopts)
 			fl6->flowlabel = ip6_flowlabel(ipv6_hdr(ireq->pktopts));
 
-		tclass = sock_net(sk)->ipv4.sysctl_tcp_reflect_tos ?
+		tclass = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reflect_tos) ?
 				(tcp_rsk(req)->syn_tos & ~INET_ECN_MASK) |
 				(np->tclass & INET_ECN_MASK) :
 				np->tclass;
@@ -1364,7 +1364,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	/* Set ToS of the new socket based upon the value of incoming SYN.
 	 * ECT bits are set later in tcp_init_transfer().
 	 */
-	if (sock_net(sk)->ipv4.sysctl_tcp_reflect_tos)
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reflect_tos))
 		newnp->tclass = tcp_rsk(req)->syn_tos & ~INET_ECN_MASK;
 
 	/* Clone native IPv6 options from listening socket (if any)
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index d6def23b8cba..7f96e0c42a09 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1881,7 +1881,7 @@ static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied)
 	if (msk->rcvq_space.copied <= msk->rcvq_space.space)
 		goto new_measure;
 
-	if (sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf &&
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf) &&
 	    !(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
 		int rcvmem, rcvbuf;
 		u64 rcvwin, grow;
@@ -1899,7 +1899,7 @@ static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied)
 
 		do_div(rcvwin, advmss);
 		rcvbuf = min_t(u64, rcvwin * rcvmem,
-			       sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
+			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
 
 		if (rcvbuf > sk->sk_rcvbuf) {
 			u32 window_clamp;
@@ -2532,8 +2532,8 @@ static int mptcp_init_sock(struct sock *sk)
 	icsk->icsk_ca_ops = NULL;
 
 	sk_sockets_allocated_inc(sk);
-	sk->sk_rcvbuf = sock_net(sk)->ipv4.sysctl_tcp_rmem[1];
-	sk->sk_sndbuf = sock_net(sk)->ipv4.sysctl_tcp_wmem[1];
+	sk->sk_rcvbuf = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[1]);
+	sk->sk_sndbuf = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[1]);
 
 	return 0;
 }
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 8787d0613ad8..5329ebf19a18 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -836,11 +836,16 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 }
 
 static int
-nfqnl_mangle(void *data, int data_len, struct nf_queue_entry *e, int diff)
+nfqnl_mangle(void *data, unsigned int data_len, struct nf_queue_entry *e, int diff)
 {
 	struct sk_buff *nskb;
 
 	if (diff < 0) {
+		unsigned int min_len = skb_transport_offset(e->skb);
+
+		if (data_len < min_len)
+			return -EINVAL;
+
 		if (pskb_trim(e->skb, data_len))
 			return -ENOMEM;
 	} else if (diff > 0) {
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index be29da09cc7a..3460abceba44 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -229,9 +229,8 @@ static struct sctp_association *sctp_association_init(
 	if (!sctp_ulpq_init(&asoc->ulpq, asoc))
 		goto fail_init;
 
-	if (sctp_stream_init(&asoc->stream, asoc->c.sinit_num_ostreams,
-			     0, gfp))
-		goto fail_init;
+	if (sctp_stream_init(&asoc->stream, asoc->c.sinit_num_ostreams, 0, gfp))
+		goto stream_free;
 
 	/* Initialize default path MTU. */
 	asoc->pathmtu = sp->pathmtu;
diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 6dc95dcc0ff4..ef9fceadef8d 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -137,7 +137,7 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 
 	ret = sctp_stream_alloc_out(stream, outcnt, gfp);
 	if (ret)
-		goto out_err;
+		return ret;
 
 	for (i = 0; i < stream->outcnt; i++)
 		SCTP_SO(stream, i)->state = SCTP_STREAM_OPEN;
@@ -145,22 +145,9 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 handle_in:
 	sctp_stream_interleave_init(stream);
 	if (!incnt)
-		goto out;
-
-	ret = sctp_stream_alloc_in(stream, incnt, gfp);
-	if (ret)
-		goto in_err;
-
-	goto out;
+		return 0;
 
-in_err:
-	sched->free(stream);
-	genradix_free(&stream->in);
-out_err:
-	genradix_free(&stream->out);
-	stream->outcnt = 0;
-out:
-	return ret;
+	return sctp_stream_alloc_in(stream, incnt, gfp);
 }
 
 int sctp_stream_init_ext(struct sctp_stream *stream, __u16 sid)
diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index 99e5f69fbb74..a2e1d34f52c5 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -163,7 +163,7 @@ int sctp_sched_set_sched(struct sctp_association *asoc,
 		if (!SCTP_SO(&asoc->stream, i)->ext)
 			continue;
 
-		ret = n->init_sid(&asoc->stream, i, GFP_KERNEL);
+		ret = n->init_sid(&asoc->stream, i, GFP_ATOMIC);
 		if (ret)
 			goto err;
 	}
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 43509c7e90fc..f1c3b8eb4b3d 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -517,7 +517,7 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
 	timer_setup(&sk->sk_timer, tipc_sk_timeout, 0);
 	sk->sk_shutdown = 0;
 	sk->sk_backlog_rcv = tipc_sk_backlog_rcv;
-	sk->sk_rcvbuf = sysctl_tipc_rmem[1];
+	sk->sk_rcvbuf = READ_ONCE(sysctl_tipc_rmem[1]);
 	sk->sk_data_ready = tipc_data_ready;
 	sk->sk_write_space = tipc_write_space;
 	sk->sk_destruct = tipc_sock_destruct;
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 4e33150cfb9e..cf75969375cf 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1351,8 +1351,13 @@ static int tls_device_down(struct net_device *netdev)
 		 * by tls_device_free_ctx. rx_conf and tx_conf stay in TLS_HW.
 		 * Now release the ref taken above.
 		 */
-		if (refcount_dec_and_test(&ctx->refcount))
+		if (refcount_dec_and_test(&ctx->refcount)) {
+			/* sk_destruct ran after tls_device_down took a ref, and
+			 * it returned early. Complete the destruction here.
+			 */
+			list_del(&ctx->list);
 			tls_device_free_ctx(ctx);
+		}
 	}
 
 	up_write(&device_offload_lock);
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index ecd377938eea..ef6ced5c5746 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -233,6 +233,33 @@ Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 	return NULL;
 }
 
+static int elf_read_program_header(Elf *elf, u64 vaddr, GElf_Phdr *phdr)
+{
+	size_t i, phdrnum;
+	u64 sz;
+
+	if (elf_getphdrnum(elf, &phdrnum))
+		return -1;
+
+	for (i = 0; i < phdrnum; i++) {
+		if (gelf_getphdr(elf, i, phdr) == NULL)
+			return -1;
+
+		if (phdr->p_type != PT_LOAD)
+			continue;
+
+		sz = max(phdr->p_memsz, phdr->p_filesz);
+		if (!sz)
+			continue;
+
+		if (vaddr >= phdr->p_vaddr && (vaddr < phdr->p_vaddr + sz))
+			return 0;
+	}
+
+	/* Not found any valid program header */
+	return -1;
+}
+
 static bool want_demangle(bool is_kernel_sym)
 {
 	return is_kernel_sym ? symbol_conf.demangle_kernel : symbol_conf.demangle;
@@ -1209,6 +1236,7 @@ dso__load_sym_internal(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 					sym.st_value);
 			used_opd = true;
 		}
+
 		/*
 		 * When loading symbols in a data mapping, ABS symbols (which
 		 * has a value of SHN_ABS in its st_shndx) failed at
@@ -1262,11 +1290,20 @@ dso__load_sym_internal(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 				goto out_elf_end;
 		} else if ((used_opd && runtime_ss->adjust_symbols) ||
 			   (!used_opd && syms_ss->adjust_symbols)) {
+			GElf_Phdr phdr;
+
+			if (elf_read_program_header(syms_ss->elf,
+						    (u64)sym.st_value, &phdr)) {
+				pr_warning("%s: failed to find program header for "
+					   "symbol: %s st_value: %#" PRIx64 "\n",
+					   __func__, elf_name, (u64)sym.st_value);
+				continue;
+			}
 			pr_debug4("%s: adjusting symbol: st_value: %#" PRIx64 " "
-				  "sh_addr: %#" PRIx64 " sh_offset: %#" PRIx64 "\n", __func__,
-				  (u64)sym.st_value, (u64)shdr.sh_addr,
-				  (u64)shdr.sh_offset);
-			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
+				  "p_vaddr: %#" PRIx64 " p_offset: %#" PRIx64 "\n",
+				  __func__, (u64)sym.st_value, (u64)phdr.p_vaddr,
+				  (u64)phdr.p_offset);
+			sym.st_value -= phdr.p_vaddr - phdr.p_offset;
 		}
 
 		demangled = demangle_sym(dso, kmodule, elf_name);
