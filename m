Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3681B4F170E
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 16:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377467AbiDDOgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 10:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354302AbiDDOgx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 10:36:53 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0734E3EB89;
        Mon,  4 Apr 2022 07:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649082895; x=1680618895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OoEYWCKCrLz8SGhfdYGyDQbaneQ6HRtGgb2G02L69vE=;
  b=lChkupIgyCWUXC56jH5+QdNm0c3pfPaUzNbIVO21vh4A0ccPh6/BmSr9
   UyLMmlZgAephSQ6ONqCvQP8Wyb3cG6pt7h+5t94trLEB46TDY+Dxu+KCg
   GqCXPwh+caJhVQmiq8wz9fxzWq13BcY/0v2NLWo6BUSl1vMxIXz03ClAa
   zEJVNIrCeM8il/EhNWASRCbNvz1l3Rabsunw5XBPX5qXA7u+uvHaPxEun
   OVdZtSxbKp+G51Eptxv/sdMOUA3lmh0qxldimSuvGuf3xszWrTbK5iBze
   RHpfkF7b77g2ccw8OLwq6MyTHmlxGWfBAcANcwxYrqLPlkzR4Oycu9RIX
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="260704496"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="260704496"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 07:34:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="657521449"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga004.jf.intel.com with ESMTP; 04 Apr 2022 07:34:52 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 4/8] crypto: qat - rework the VF2PF interrupt handling logic
Date:   Mon,  4 Apr 2022 15:38:25 +0100
Message-Id: <20220404143829.147404-5-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220404143829.147404-1-marco.chiappero@intel.com>
References: <20220404143829.147404-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Change the VF2PF interrupt handler in the PF ISR and the definition of
the internal PFVF API to correct the current implementation, which can
result in missed interrupts.

More specifically, current HW generations consider a write to the mask
register, regardless of the value, as an acknowledge of any pending
VF2PF interrupt. Therefore, if there is an interrupt between the source
register read and the mask register write, such interrupt will not be
delivered and silently acknowledged, resulting in a lost VF2PF message.

To work around the problem, rather than disabling specific interrupts,
disable all the interrupts and re-enable only the ones that we are not
serving (excluding the already disabled ones too). This will force any
other pending interrupt to be triggered and be serviced by a subsequent
ISR.

This new approach requires, however, changes to the interrupt related
pfvf_ops functions. In particular, get_vf2pf_sources() has now been
removed in favor of disable_pending_vf2pf_interrupts(), which not only
retrieves and returns the pending (and enabled) sources, but also
disables them.
As a consequence, introduce the adf_disable_pending_vf2pf_interrupts()
utility in place of adf_disable_vf2pf_interrupts_irq(), which is no
longer needed.

Cc: stable@vger.kernel.org
Fixes: 993161d ("crypto: qat - fix handling of VF to PF interrupts")
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_common/adf_accel_devices.h |  2 +-
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c | 58 +++++++++-----
 drivers/crypto/qat/qat_common/adf_gen4_pfvf.c | 44 ++++++++---
 drivers/crypto/qat/qat_common/adf_isr.c       | 17 ++---
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 76 +++++++++++++------
 5 files changed, 132 insertions(+), 65 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index a03c6cf72331..dfa7ee41c5e9 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -152,9 +152,9 @@ struct adf_pfvf_ops {
 	int (*enable_comms)(struct adf_accel_dev *accel_dev);
 	u32 (*get_pf2vf_offset)(u32 i);
 	u32 (*get_vf2pf_offset)(u32 i);
-	u32 (*get_vf2pf_sources)(void __iomem *pmisc_addr);
 	void (*enable_vf2pf_interrupts)(void __iomem *pmisc_addr, u32 vf_mask);
 	void (*disable_vf2pf_interrupts)(void __iomem *pmisc_addr, u32 vf_mask);
+	u32 (*disable_pending_vf2pf_interrupts)(void __iomem *pmisc_addr);
 	int (*send_msg)(struct adf_accel_dev *accel_dev, struct pfvf_message msg,
 			u32 pfvf_offset, struct mutex *csr_lock);
 	struct pfvf_message (*recv_msg)(struct adf_accel_dev *accel_dev,
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
index 1a9072aac2ca..def4cc8e1039 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
@@ -13,6 +13,7 @@
 #include "adf_pfvf_utils.h"
 
  /* VF2PF interrupts */
+#define ADF_GEN2_VF_MSK			0xFFFF
 #define ADF_GEN2_ERR_REG_VF2PF(vf_src)	(((vf_src) & 0x01FFFE00) >> 9)
 #define ADF_GEN2_ERR_MSK_VF2PF(vf_mask)	(((vf_mask) & 0xFFFF) << 9)
 
@@ -50,23 +51,6 @@ static u32 adf_gen2_vf_get_pfvf_offset(u32 i)
 	return ADF_GEN2_VF_PF2VF_OFFSET;
 }
 
-static u32 adf_gen2_get_vf2pf_sources(void __iomem *pmisc_addr)
-{
-	u32 errsou3, errmsk3, vf_int_mask;
-
-	/* Get the interrupt sources triggered by VFs */
-	errsou3 = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRSOU3);
-	vf_int_mask = ADF_GEN2_ERR_REG_VF2PF(errsou3);
-
-	/* To avoid adding duplicate entries to work queue, clear
-	 * vf_int_mask_sets bits that are already masked in ERRMSK register.
-	 */
-	errmsk3 = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3);
-	vf_int_mask &= ~ADF_GEN2_ERR_REG_VF2PF(errmsk3);
-
-	return vf_int_mask;
-}
-
 static void adf_gen2_enable_vf2pf_interrupts(void __iomem *pmisc_addr,
 					     u32 vf_mask)
 {
@@ -89,6 +73,44 @@ static void adf_gen2_disable_vf2pf_interrupts(void __iomem *pmisc_addr,
 	}
 }
 
+static u32 adf_gen2_disable_pending_vf2pf_interrupts(void __iomem *pmisc_addr)
+{
+	u32 sources, disabled, pending;
+	u32 errsou3, errmsk3;
+
+	/* Get the interrupt sources triggered by VFs */
+	errsou3 = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRSOU3);
+	sources = ADF_GEN2_ERR_REG_VF2PF(errsou3);
+
+	if (!sources)
+		return 0;
+
+	/* Get the already disabled interrupts */
+	errmsk3 = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3);
+	disabled = ADF_GEN2_ERR_REG_VF2PF(errmsk3);
+
+	pending = sources & ~disabled;
+	if (!pending)
+		return 0;
+
+	/* Due to HW limitations, when disabling the interrupts, we can't
+	 * just disable the requested sources, as this would lead to missed
+	 * interrupts if ERRSOU3 changes just before writing to ERRMSK3.
+	 * To work around it, disable all and re-enable only the sources that
+	 * are not in vf_mask and were not already disabled. Re-enabling will
+	 * trigger a new interrupt for the sources that have changed in the
+	 * meantime, if any.
+	 */
+	errmsk3 |= ADF_GEN2_ERR_MSK_VF2PF(ADF_GEN2_VF_MSK);
+	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, errmsk3);
+
+	errmsk3 &= ADF_GEN2_ERR_MSK_VF2PF(sources | disabled);
+	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, errmsk3);
+
+	/* Return the sources of the (new) interrupt(s) */
+	return pending;
+}
+
 static u32 gen2_csr_get_int_bit(enum gen2_csr_pos offset)
 {
 	return ADF_PFVF_INT << offset;
@@ -362,9 +384,9 @@ void adf_gen2_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
 	pfvf_ops->enable_comms = adf_enable_pf2vf_comms;
 	pfvf_ops->get_pf2vf_offset = adf_gen2_pf_get_pfvf_offset;
 	pfvf_ops->get_vf2pf_offset = adf_gen2_pf_get_pfvf_offset;
-	pfvf_ops->get_vf2pf_sources = adf_gen2_get_vf2pf_sources;
 	pfvf_ops->enable_vf2pf_interrupts = adf_gen2_enable_vf2pf_interrupts;
 	pfvf_ops->disable_vf2pf_interrupts = adf_gen2_disable_vf2pf_interrupts;
+	pfvf_ops->disable_pending_vf2pf_interrupts = adf_gen2_disable_pending_vf2pf_interrupts;
 	pfvf_ops->send_msg = adf_gen2_pf2vf_send;
 	pfvf_ops->recv_msg = adf_gen2_vf2pf_recv;
 }
diff --git a/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
index d80d493a7756..40fdab857f95 100644
--- a/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
@@ -15,6 +15,7 @@
 /* VF2PF interrupt source registers */
 #define ADF_4XXX_VM2PF_SOU		0x41A180
 #define ADF_4XXX_VM2PF_MSK		0x41A1C0
+#define ADF_GEN4_VF_MSK			0xFFFF
 
 #define ADF_PFVF_GEN4_MSGTYPE_SHIFT	2
 #define ADF_PFVF_GEN4_MSGTYPE_MASK	0x3F
@@ -36,16 +37,6 @@ static u32 adf_gen4_pf_get_vf2pf_offset(u32 i)
 	return ADF_4XXX_VM2PF_OFFSET(i);
 }
 
-static u32 adf_gen4_get_vf2pf_sources(void __iomem *pmisc_addr)
-{
-	u32 sou, mask;
-
-	sou = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_SOU);
-	mask = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_MSK);
-
-	return sou & ~mask;
-}
-
 static void adf_gen4_enable_vf2pf_interrupts(void __iomem *pmisc_addr,
 					     u32 vf_mask)
 {
@@ -64,6 +55,37 @@ static void adf_gen4_disable_vf2pf_interrupts(void __iomem *pmisc_addr,
 	ADF_CSR_WR(pmisc_addr, ADF_4XXX_VM2PF_MSK, val);
 }
 
+static u32 adf_gen4_disable_pending_vf2pf_interrupts(void __iomem *pmisc_addr)
+{
+	u32 sources, disabled, pending;
+
+	/* Get the interrupt sources triggered by VFs */
+	sources = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_SOU);
+	if (!sources)
+		return 0;
+
+	/* Get the already disabled interrupts */
+	disabled = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_MSK);
+
+	pending = sources & ~disabled;
+	if (!pending)
+		return 0;
+
+	/* Due to HW limitations, when disabling the interrupts, we can't
+	 * just disable the requested sources, as this would lead to missed
+	 * interrupts if VM2PF_SOU changes just before writing to VM2PF_MSK.
+	 * To work around it, disable all and re-enable only the sources that
+	 * are not in vf_mask and were not already disabled. Re-enabling will
+	 * trigger a new interrupt for the sources that have changed in the
+	 * meantime, if any.
+	 */
+	ADF_CSR_WR(pmisc_addr, ADF_4XXX_VM2PF_MSK, ADF_GEN4_VF_MSK);
+	ADF_CSR_WR(pmisc_addr, ADF_4XXX_VM2PF_MSK, disabled | sources);
+
+	/* Return the sources of the (new) interrupt(s) */
+	return pending;
+}
+
 static int adf_gen4_pfvf_send(struct adf_accel_dev *accel_dev,
 			      struct pfvf_message msg, u32 pfvf_offset,
 			      struct mutex *csr_lock)
@@ -115,9 +137,9 @@ void adf_gen4_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
 	pfvf_ops->enable_comms = adf_enable_pf2vf_comms;
 	pfvf_ops->get_pf2vf_offset = adf_gen4_pf_get_pf2vf_offset;
 	pfvf_ops->get_vf2pf_offset = adf_gen4_pf_get_vf2pf_offset;
-	pfvf_ops->get_vf2pf_sources = adf_gen4_get_vf2pf_sources;
 	pfvf_ops->enable_vf2pf_interrupts = adf_gen4_enable_vf2pf_interrupts;
 	pfvf_ops->disable_vf2pf_interrupts = adf_gen4_disable_vf2pf_interrupts;
+	pfvf_ops->disable_pending_vf2pf_interrupts = adf_gen4_disable_pending_vf2pf_interrupts;
 	pfvf_ops->send_msg = adf_gen4_pfvf_send;
 	pfvf_ops->recv_msg = adf_gen4_pfvf_recv;
 }
diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index a35149f8bf1e..23f7fff32c64 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -76,32 +76,29 @@ void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
 	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
 }
 
-static void adf_disable_vf2pf_interrupts_irq(struct adf_accel_dev *accel_dev,
-					     u32 vf_mask)
+static u32 adf_disable_pending_vf2pf_interrupts(struct adf_accel_dev *accel_dev)
 {
 	void __iomem *pmisc_addr = adf_get_pmisc_base(accel_dev);
+	u32 pending;
 
 	spin_lock(&accel_dev->pf.vf2pf_ints_lock);
-	GET_PFVF_OPS(accel_dev)->disable_vf2pf_interrupts(pmisc_addr, vf_mask);
+	pending = GET_PFVF_OPS(accel_dev)->disable_pending_vf2pf_interrupts(pmisc_addr);
 	spin_unlock(&accel_dev->pf.vf2pf_ints_lock);
+
+	return pending;
 }
 
 static bool adf_handle_vf2pf_int(struct adf_accel_dev *accel_dev)
 {
-	void __iomem *pmisc_addr = adf_get_pmisc_base(accel_dev);
 	bool irq_handled = false;
 	unsigned long vf_mask;
 
-	/* Get the interrupt sources triggered by VFs */
-	vf_mask = GET_PFVF_OPS(accel_dev)->get_vf2pf_sources(pmisc_addr);
-
+	/* Get the interrupt sources triggered by VFs, except for those already disabled */
+	vf_mask = adf_disable_pending_vf2pf_interrupts(accel_dev);
 	if (vf_mask) {
 		struct adf_accel_vf_info *vf_info;
 		int i;
 
-		/* Disable VF2PF interrupts for VFs with pending ints */
-		adf_disable_vf2pf_interrupts_irq(accel_dev, vf_mask);
-
 		/*
 		 * Handle VF2PF interrupt unless the VF is malicious and
 		 * is attempting to flood the host OS with VF2PF interrupts.
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 61d5467e0d92..91095ad479dc 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -7,6 +7,8 @@
 #include "adf_dh895xcc_hw_data.h"
 #include "icp_qat_hw.h"
 
+#define ADF_DH895XCC_VF_MSK	0xFFFFFFFF
+
 /* Worker thread to service arbiter mappings */
 static const u32 thrd_to_arb_map[ADF_DH895XCC_MAX_ACCELENGINES] = {
 	0x12222AAA, 0x11666666, 0x12222AAA, 0x11666666,
@@ -121,29 +123,6 @@ static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 		   ADF_DH895XCC_SMIA1_MASK);
 }
 
-static u32 get_vf2pf_sources(void __iomem *pmisc_bar)
-{
-	u32 errsou3, errmsk3, errsou5, errmsk5, vf_int_mask;
-
-	/* Get the interrupt sources triggered by VFs */
-	errsou3 = ADF_CSR_RD(pmisc_bar, ADF_GEN2_ERRSOU3);
-	vf_int_mask = ADF_DH895XCC_ERR_REG_VF2PF_L(errsou3);
-
-	/* To avoid adding duplicate entries to work queue, clear
-	 * vf_int_mask_sets bits that are already masked in ERRMSK register.
-	 */
-	errmsk3 = ADF_CSR_RD(pmisc_bar, ADF_GEN2_ERRMSK3);
-	vf_int_mask &= ~ADF_DH895XCC_ERR_REG_VF2PF_L(errmsk3);
-
-	/* Do the same for ERRSOU5 */
-	errsou5 = ADF_CSR_RD(pmisc_bar, ADF_GEN2_ERRSOU5);
-	errmsk5 = ADF_CSR_RD(pmisc_bar, ADF_GEN2_ERRMSK5);
-	vf_int_mask |= ADF_DH895XCC_ERR_REG_VF2PF_U(errsou5);
-	vf_int_mask &= ~ADF_DH895XCC_ERR_REG_VF2PF_U(errmsk5);
-
-	return vf_int_mask;
-}
-
 static void enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
 {
 	/* Enable VF2PF Messaging Ints - VFs 0 through 15 per vf_mask[15:0] */
@@ -157,7 +136,6 @@ static void enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
 	if (vf_mask >> 16) {
 		u32 val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK5)
 			  & ~ADF_DH895XCC_ERR_MSK_VF2PF_U(vf_mask);
-
 		ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK5, val);
 	}
 }
@@ -180,6 +158,54 @@ static void disable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
 	}
 }
 
+static u32 disable_pending_vf2pf_interrupts(void __iomem *pmisc_addr)
+{
+	u32 sources, pending, disabled;
+	u32 errsou3, errmsk3;
+	u32 errsou5, errmsk5;
+
+	/* Get the interrupt sources triggered by VFs */
+	errsou3 = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRSOU3);
+	errsou5 = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRSOU5);
+	sources = ADF_DH895XCC_ERR_REG_VF2PF_L(errsou3)
+		  | ADF_DH895XCC_ERR_REG_VF2PF_U(errsou5);
+
+	if (!sources)
+		return 0;
+
+	/* Get the already disabled interrupts */
+	errmsk3 = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3);
+	errmsk5 = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK5);
+	disabled = ADF_DH895XCC_ERR_REG_VF2PF_L(errmsk3)
+		   | ADF_DH895XCC_ERR_REG_VF2PF_U(errmsk5);
+
+	pending = sources & ~disabled;
+	if (!pending)
+		return 0;
+
+	/* Due to HW limitations, when disabling the interrupts, we can't
+	 * just disable the requested sources, as this would lead to missed
+	 * interrupts if sources changes just before writing to ERRMSK3 and
+	 * ERRMSK5.
+	 * To work around it, disable all and re-enable only the sources that
+	 * are not in vf_mask and were not already disabled. Re-enabling will
+	 * trigger a new interrupt for the sources that have changed in the
+	 * meantime, if any.
+	 */
+	errmsk3 |= ADF_DH895XCC_ERR_MSK_VF2PF_L(ADF_DH895XCC_VF_MSK);
+	errmsk5 |= ADF_DH895XCC_ERR_MSK_VF2PF_U(ADF_DH895XCC_VF_MSK);
+	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, errmsk3);
+	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK5, errmsk5);
+
+	errmsk3 &= ADF_DH895XCC_ERR_MSK_VF2PF_L(sources | disabled);
+	errmsk5 &= ADF_DH895XCC_ERR_MSK_VF2PF_U(sources | disabled);
+	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, errmsk3);
+	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK5, errmsk5);
+
+	/* Return the sources of the (new) interrupt(s) */
+	return pending;
+}
+
 static void configure_iov_threads(struct adf_accel_dev *accel_dev, bool enable)
 {
 	adf_gen2_cfg_iov_thds(accel_dev, enable,
@@ -227,9 +253,9 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->disable_iov = adf_disable_sriov;
 
 	adf_gen2_init_pf_pfvf_ops(&hw_data->pfvf_ops);
-	hw_data->pfvf_ops.get_vf2pf_sources = get_vf2pf_sources;
 	hw_data->pfvf_ops.enable_vf2pf_interrupts = enable_vf2pf_interrupts;
 	hw_data->pfvf_ops.disable_vf2pf_interrupts = disable_vf2pf_interrupts;
+	hw_data->pfvf_ops.disable_pending_vf2pf_interrupts = disable_pending_vf2pf_interrupts;
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
 }
 
-- 
2.34.1

