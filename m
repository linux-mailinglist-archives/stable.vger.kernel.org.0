Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCEB66C819
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbjAPQg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233510AbjAPQgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:36:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5457C2A9BD
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:24:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5CC96104E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072CCC433D2;
        Mon, 16 Jan 2023 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886261;
        bh=dvPZVfhaFuQreziJ7zxigfIqX6zQjjz0Po5/8LClTz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R5uTUz/D+qdDXOF8q0vQoXmc3J+0pgMkyCgDo4XlQCt0QBVCU9vurXXT6/ogiMTCS
         +ZpHRX2rRUl7ITIvfecR6+hIc2H1YMQKOfulOWLpLghxF/yjyk4O3+LFRwArKFn84Z
         3rZeA6NA0kVphLAt4g7K9a5CVbGIU7zGrc8HuiyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wen Xiong <wenxiong@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 364/658] powerpc/pseries: PCIE PHB reset
Date:   Mon, 16 Jan 2023 16:47:32 +0100
Message-Id: <20230116154926.233750781@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Xiong <wenxiong@linux.vnet.ibm.com>

[ Upstream commit 5a090f7c363fdc09b99222eae679506a58e7cc68 ]

Several device drivers hit EEH(Extended Error handling) when
triggering kdump on Pseries PowerVM. This patch implemented a reset of
the PHBs in pci general code when triggering kdump. PHB reset stop all
PCI transactions from normal kernel. We have tested the patch in
several enviroments:
  - direct slot adapters
  - adapters under the switch
  - a VF adapter in PowerVM
  - a VF adapter/adapter in KVM guest.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
[mpe: Fix broken whitespace, subject & SOB formatting]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1594651173-32166-1-git-send-email-wenxiong@linux.vnet.ibm.com
Stable-dep-of: 9aafbfa5f57a ("powerpc/pseries/eeh: use correct API for error log size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/eeh_pseries.c | 232 ++++++++++++++-----
 1 file changed, 169 insertions(+), 63 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
index 04c1ed79bc6e..bb34ce56312a 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -24,6 +24,7 @@
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/spinlock.h>
+#include <linux/crash_dump.h>
 
 #include <asm/eeh.h>
 #include <asm/eeh_event.h>
@@ -81,6 +82,152 @@ void pseries_pcibios_bus_add_device(struct pci_dev *pdev)
 	eeh_sysfs_add_device(pdev);
 }
 
+
+/**
+ * pseries_eeh_get_config_addr - Retrieve config address
+ *
+ * Retrieve the assocated config address. Actually, there're 2 RTAS
+ * function calls dedicated for the purpose. We need implement
+ * it through the new function and then the old one. Besides,
+ * you should make sure the config address is figured out from
+ * FDT node before calling the function.
+ *
+ * It's notable that zero'ed return value means invalid PE config
+ * address.
+ */
+static int pseries_eeh_get_config_addr(struct pci_controller *phb, int config_addr)
+{
+	int ret = 0;
+	int rets[3];
+
+	if (ibm_get_config_addr_info2 != RTAS_UNKNOWN_SERVICE) {
+		/*
+		 * First of all, we need to make sure there has one PE
+		 * associated with the device. Otherwise, PE address is
+		 * meaningless.
+		 */
+		ret = rtas_call(ibm_get_config_addr_info2, 4, 2, rets,
+				config_addr, BUID_HI(phb->buid),
+				BUID_LO(phb->buid), 1);
+		if (ret || (rets[0] == 0))
+			return 0;
+
+		/* Retrieve the associated PE config address */
+		ret = rtas_call(ibm_get_config_addr_info2, 4, 2, rets,
+				config_addr, BUID_HI(phb->buid),
+				BUID_LO(phb->buid), 0);
+		if (ret) {
+			pr_warn("%s: Failed to get address for PHB#%x-PE#%x\n",
+				__func__, phb->global_number, config_addr);
+			return 0;
+		}
+
+		return rets[0];
+	}
+
+	if (ibm_get_config_addr_info != RTAS_UNKNOWN_SERVICE) {
+		ret = rtas_call(ibm_get_config_addr_info, 4, 2, rets,
+				config_addr, BUID_HI(phb->buid),
+				BUID_LO(phb->buid), 0);
+		if (ret) {
+			pr_warn("%s: Failed to get address for PHB#%x-PE#%x\n",
+				__func__, phb->global_number, config_addr);
+			return 0;
+		}
+
+		return rets[0];
+	}
+
+	return ret;
+}
+
+/**
+ * pseries_eeh_phb_reset - Reset the specified PHB
+ * @phb: PCI controller
+ * @config_adddr: the associated config address
+ * @option: reset option
+ *
+ * Reset the specified PHB/PE
+ */
+static int pseries_eeh_phb_reset(struct pci_controller *phb, int config_addr, int option)
+{
+	int ret;
+
+	/* Reset PE through RTAS call */
+	ret = rtas_call(ibm_set_slot_reset, 4, 1, NULL,
+			config_addr, BUID_HI(phb->buid),
+			BUID_LO(phb->buid), option);
+
+	/* If fundamental-reset not supported, try hot-reset */
+	if (option == EEH_RESET_FUNDAMENTAL &&
+	    ret == -8) {
+		option = EEH_RESET_HOT;
+		ret = rtas_call(ibm_set_slot_reset, 4, 1, NULL,
+				config_addr, BUID_HI(phb->buid),
+				BUID_LO(phb->buid), option);
+	}
+
+	/* We need reset hold or settlement delay */
+	if (option == EEH_RESET_FUNDAMENTAL ||
+	    option == EEH_RESET_HOT)
+		msleep(EEH_PE_RST_HOLD_TIME);
+	else
+		msleep(EEH_PE_RST_SETTLE_TIME);
+
+	return ret;
+}
+
+/**
+ * pseries_eeh_phb_configure_bridge - Configure PCI bridges in the indicated PE
+ * @phb: PCI controller
+ * @config_adddr: the associated config address
+ *
+ * The function will be called to reconfigure the bridges included
+ * in the specified PE so that the mulfunctional PE would be recovered
+ * again.
+ */
+static int pseries_eeh_phb_configure_bridge(struct pci_controller *phb, int config_addr)
+{
+	int ret;
+	/* Waiting 0.2s maximum before skipping configuration */
+	int max_wait = 200;
+
+	while (max_wait > 0) {
+		ret = rtas_call(ibm_configure_pe, 3, 1, NULL,
+				config_addr, BUID_HI(phb->buid),
+				BUID_LO(phb->buid));
+
+		if (!ret)
+			return ret;
+		if (ret < 0)
+			break;
+
+		/*
+		 * If RTAS returns a delay value that's above 100ms, cut it
+		 * down to 100ms in case firmware made a mistake.  For more
+		 * on how these delay values work see rtas_busy_delay_time
+		 */
+		if (ret > RTAS_EXTENDED_DELAY_MIN+2 &&
+		    ret <= RTAS_EXTENDED_DELAY_MAX)
+			ret = RTAS_EXTENDED_DELAY_MIN+2;
+
+		max_wait -= rtas_busy_delay_time(ret);
+
+		if (max_wait < 0)
+			break;
+
+		rtas_busy_delay(ret);
+	}
+
+	pr_warn("%s: Unable to configure bridge PHB#%x-PE#%x (%d)\n",
+		__func__, phb->global_number, config_addr, ret);
+	/* PAPR defines -3 as "Parameter Error" for this function: */
+	if (ret == -3)
+		return -EINVAL;
+	else
+		return -EIO;
+}
+
 /*
  * Buffer for reporting slot-error-detail rtas calls. Its here
  * in BSS, and not dynamically alloced, so that it ends up in
@@ -97,6 +244,10 @@ static int eeh_error_buf_size;
  */
 static int pseries_eeh_init(void)
 {
+	struct pci_controller *phb;
+	struct pci_dn *pdn;
+	int addr, config_addr;
+
 	/* figure out EEH RTAS function call tokens */
 	ibm_set_eeh_option		= rtas_token("ibm,set-eeh-option");
 	ibm_set_slot_reset		= rtas_token("ibm,set-slot-reset");
@@ -149,6 +300,22 @@ static int pseries_eeh_init(void)
 	/* Set EEH machine dependent code */
 	ppc_md.pcibios_bus_add_device = pseries_pcibios_bus_add_device;
 
+	if (is_kdump_kernel() || reset_devices) {
+		pr_info("Issue PHB reset ...\n");
+		list_for_each_entry(phb, &hose_list, list_node) {
+			pdn = list_first_entry(&PCI_DN(phb->dn)->child_list, struct pci_dn, list);
+			addr = (pdn->busno << 16) | (pdn->devfn << 8);
+			config_addr = pseries_eeh_get_config_addr(phb, addr);
+			/* invalid PE config addr */
+			if (config_addr == 0)
+				continue;
+
+			pseries_eeh_phb_reset(phb, config_addr, EEH_RESET_FUNDAMENTAL);
+			pseries_eeh_phb_reset(phb, config_addr, EEH_RESET_DEACTIVATE);
+			pseries_eeh_phb_configure_bridge(phb, config_addr);
+		}
+	}
+
 	return 0;
 }
 
@@ -512,35 +679,13 @@ static int pseries_eeh_get_state(struct eeh_pe *pe, int *delay)
 static int pseries_eeh_reset(struct eeh_pe *pe, int option)
 {
 	int config_addr;
-	int ret;
 
 	/* Figure out PE address */
 	config_addr = pe->config_addr;
 	if (pe->addr)
 		config_addr = pe->addr;
 
-	/* Reset PE through RTAS call */
-	ret = rtas_call(ibm_set_slot_reset, 4, 1, NULL,
-			config_addr, BUID_HI(pe->phb->buid),
-			BUID_LO(pe->phb->buid), option);
-
-	/* If fundamental-reset not supported, try hot-reset */
-	if (option == EEH_RESET_FUNDAMENTAL &&
-	    ret == -8) {
-		option = EEH_RESET_HOT;
-		ret = rtas_call(ibm_set_slot_reset, 4, 1, NULL,
-				config_addr, BUID_HI(pe->phb->buid),
-				BUID_LO(pe->phb->buid), option);
-	}
-
-	/* We need reset hold or settlement delay */
-	if (option == EEH_RESET_FUNDAMENTAL ||
-	    option == EEH_RESET_HOT)
-		msleep(EEH_PE_RST_HOLD_TIME);
-	else
-		msleep(EEH_PE_RST_SETTLE_TIME);
-
-	return ret;
+	return pseries_eeh_phb_reset(pe->phb, config_addr, option);
 }
 
 /**
@@ -584,56 +729,17 @@ static int pseries_eeh_get_log(struct eeh_pe *pe, int severity, char *drv_log, u
  * pseries_eeh_configure_bridge - Configure PCI bridges in the indicated PE
  * @pe: EEH PE
  *
- * The function will be called to reconfigure the bridges included
- * in the specified PE so that the mulfunctional PE would be recovered
- * again.
  */
 static int pseries_eeh_configure_bridge(struct eeh_pe *pe)
 {
 	int config_addr;
-	int ret;
-	/* Waiting 0.2s maximum before skipping configuration */
-	int max_wait = 200;
 
 	/* Figure out the PE address */
 	config_addr = pe->config_addr;
 	if (pe->addr)
 		config_addr = pe->addr;
 
-	while (max_wait > 0) {
-		ret = rtas_call(ibm_configure_pe, 3, 1, NULL,
-				config_addr, BUID_HI(pe->phb->buid),
-				BUID_LO(pe->phb->buid));
-
-		if (!ret)
-			return ret;
-		if (ret < 0)
-			break;
-
-		/*
-		 * If RTAS returns a delay value that's above 100ms, cut it
-		 * down to 100ms in case firmware made a mistake.  For more
-		 * on how these delay values work see rtas_busy_delay_time
-		 */
-		if (ret > RTAS_EXTENDED_DELAY_MIN+2 &&
-		    ret <= RTAS_EXTENDED_DELAY_MAX)
-			ret = RTAS_EXTENDED_DELAY_MIN+2;
-
-		max_wait -= rtas_busy_delay_time(ret);
-
-		if (max_wait < 0)
-			break;
-
-		rtas_busy_delay(ret);
-	}
-
-	pr_warn("%s: Unable to configure bridge PHB#%x-PE#%x (%d)\n",
-		__func__, pe->phb->global_number, pe->addr, ret);
-	/* PAPR defines -3 as "Parameter Error" for this function: */
-	if (ret == -3)
-		return -EINVAL;
-	else
-		return -EIO;
+	return pseries_eeh_phb_configure_bridge(pe->phb, config_addr);
 }
 
 /**
-- 
2.35.1



