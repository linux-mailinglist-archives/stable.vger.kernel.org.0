Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B2266CB41
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbjAPRMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234294AbjAPRLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:11:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767DB49020
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:52:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1641F61037
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E466C433D2;
        Mon, 16 Jan 2023 16:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887921;
        bh=NJ/FJEQYHJST8jPE9NG67Xf+jbNGQoWczd++8y2sdbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vpdZX6hk9EMQJVQWnvMVs06q7srQFK9uqJzFcd2cbslEm3BvgSyT8eiiqiCYsvbg6
         t+EeQbTPVAOiE7iQA0LHPDXuX2tZ7mHgVE6udzK/4tFGAkhEploIB4gRwyMaMvppN3
         SZKsM0NPM6KGtVWLF8DNGzNs9oLSyKtajNRZ6LMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Oliver OHalloran <oohall@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 293/521] powerpc/pseries: Stop using eeh_ops->init()
Date:   Mon, 16 Jan 2023 16:49:15 +0100
Message-Id: <20230116154900.230346628@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Oliver O'Halloran <oohall@gmail.com>

[ Upstream commit 1f8fa0cd6a848ff072bffe0ee776554387128f60 ]

Fold pseries_eeh_init() into eeh_pseries_init() rather than having
eeh_init() call it via eeh_ops->init(). It's simpler and it'll let us
delete eeh_ops.init.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200918093050.37344-3-oohall@gmail.com
Stable-dep-of: 9aafbfa5f57a ("powerpc/pseries/eeh: use correct API for error log size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/eeh_pseries.c | 155 +++++++++----------
 1 file changed, 71 insertions(+), 84 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
index 560d7401496c..7a0b9aa09d10 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -250,88 +250,6 @@ static unsigned char slot_errbuf[RTAS_ERROR_LOG_MAX];
 static DEFINE_SPINLOCK(slot_errbuf_lock);
 static int eeh_error_buf_size;
 
-/**
- * pseries_eeh_init - EEH platform dependent initialization
- *
- * EEH platform dependent initialization on pseries.
- */
-static int pseries_eeh_init(void)
-{
-	struct pci_controller *phb;
-	struct pci_dn *pdn;
-	int addr, config_addr;
-
-	/* figure out EEH RTAS function call tokens */
-	ibm_set_eeh_option		= rtas_token("ibm,set-eeh-option");
-	ibm_set_slot_reset		= rtas_token("ibm,set-slot-reset");
-	ibm_read_slot_reset_state2	= rtas_token("ibm,read-slot-reset-state2");
-	ibm_read_slot_reset_state	= rtas_token("ibm,read-slot-reset-state");
-	ibm_slot_error_detail		= rtas_token("ibm,slot-error-detail");
-	ibm_get_config_addr_info2	= rtas_token("ibm,get-config-addr-info2");
-	ibm_get_config_addr_info	= rtas_token("ibm,get-config-addr-info");
-	ibm_configure_pe		= rtas_token("ibm,configure-pe");
-
-	/*
-	 * ibm,configure-pe and ibm,configure-bridge have the same semantics,
-	 * however ibm,configure-pe can be faster.  If we can't find
-	 * ibm,configure-pe then fall back to using ibm,configure-bridge.
-	 */
-	if (ibm_configure_pe == RTAS_UNKNOWN_SERVICE)
-		ibm_configure_pe 	= rtas_token("ibm,configure-bridge");
-
-	/*
-	 * Necessary sanity check. We needn't check "get-config-addr-info"
-	 * and its variant since the old firmware probably support address
-	 * of domain/bus/slot/function for EEH RTAS operations.
-	 */
-	if (ibm_set_eeh_option == RTAS_UNKNOWN_SERVICE		||
-	    ibm_set_slot_reset == RTAS_UNKNOWN_SERVICE		||
-	    (ibm_read_slot_reset_state2 == RTAS_UNKNOWN_SERVICE &&
-	     ibm_read_slot_reset_state == RTAS_UNKNOWN_SERVICE)	||
-	    ibm_slot_error_detail == RTAS_UNKNOWN_SERVICE	||
-	    ibm_configure_pe == RTAS_UNKNOWN_SERVICE) {
-		pr_info("EEH functionality not supported\n");
-		return -EINVAL;
-	}
-
-	/* Initialize error log lock and size */
-	spin_lock_init(&slot_errbuf_lock);
-	eeh_error_buf_size = rtas_token("rtas-error-log-max");
-	if (eeh_error_buf_size == RTAS_UNKNOWN_SERVICE) {
-		pr_info("%s: unknown EEH error log size\n",
-			__func__);
-		eeh_error_buf_size = 1024;
-	} else if (eeh_error_buf_size > RTAS_ERROR_LOG_MAX) {
-		pr_info("%s: EEH error log size %d exceeds the maximal %d\n",
-			__func__, eeh_error_buf_size, RTAS_ERROR_LOG_MAX);
-		eeh_error_buf_size = RTAS_ERROR_LOG_MAX;
-	}
-
-	/* Set EEH probe mode */
-	eeh_add_flag(EEH_PROBE_MODE_DEVTREE | EEH_ENABLE_IO_FOR_LOG);
-
-	/* Set EEH machine dependent code */
-	ppc_md.pcibios_bus_add_device = pseries_pcibios_bus_add_device;
-
-	if (is_kdump_kernel() || reset_devices) {
-		pr_info("Issue PHB reset ...\n");
-		list_for_each_entry(phb, &hose_list, list_node) {
-			pdn = list_first_entry(&PCI_DN(phb->dn)->child_list, struct pci_dn, list);
-			addr = (pdn->busno << 16) | (pdn->devfn << 8);
-			config_addr = pseries_eeh_get_config_addr(phb, addr);
-			/* invalid PE config addr */
-			if (config_addr == 0)
-				continue;
-
-			pseries_eeh_phb_reset(phb, config_addr, EEH_RESET_FUNDAMENTAL);
-			pseries_eeh_phb_reset(phb, config_addr, EEH_RESET_DEACTIVATE);
-			pseries_eeh_phb_configure_bridge(phb, config_addr);
-		}
-	}
-
-	return 0;
-}
-
 static int pseries_eeh_cap_start(struct pci_dn *pdn)
 {
 	u32 status;
@@ -964,7 +882,6 @@ static int pseries_notify_resume(struct pci_dn *pdn)
 
 static struct eeh_ops pseries_eeh_ops = {
 	.name			= "pseries",
-	.init			= pseries_eeh_init,
 	.probe			= pseries_eeh_probe,
 	.set_option		= pseries_eeh_set_option,
 	.get_pe_addr		= pseries_eeh_get_pe_addr,
@@ -991,7 +908,77 @@ static struct eeh_ops pseries_eeh_ops = {
  */
 static int __init eeh_pseries_init(void)
 {
-	int ret;
+	struct pci_controller *phb;
+	struct pci_dn *pdn;
+	int ret, addr, config_addr;
+
+	/* figure out EEH RTAS function call tokens */
+	ibm_set_eeh_option		= rtas_token("ibm,set-eeh-option");
+	ibm_set_slot_reset		= rtas_token("ibm,set-slot-reset");
+	ibm_read_slot_reset_state2	= rtas_token("ibm,read-slot-reset-state2");
+	ibm_read_slot_reset_state	= rtas_token("ibm,read-slot-reset-state");
+	ibm_slot_error_detail		= rtas_token("ibm,slot-error-detail");
+	ibm_get_config_addr_info2	= rtas_token("ibm,get-config-addr-info2");
+	ibm_get_config_addr_info	= rtas_token("ibm,get-config-addr-info");
+	ibm_configure_pe		= rtas_token("ibm,configure-pe");
+
+	/*
+	 * ibm,configure-pe and ibm,configure-bridge have the same semantics,
+	 * however ibm,configure-pe can be faster.  If we can't find
+	 * ibm,configure-pe then fall back to using ibm,configure-bridge.
+	 */
+	if (ibm_configure_pe == RTAS_UNKNOWN_SERVICE)
+		ibm_configure_pe	= rtas_token("ibm,configure-bridge");
+
+	/*
+	 * Necessary sanity check. We needn't check "get-config-addr-info"
+	 * and its variant since the old firmware probably support address
+	 * of domain/bus/slot/function for EEH RTAS operations.
+	 */
+	if (ibm_set_eeh_option == RTAS_UNKNOWN_SERVICE		||
+	    ibm_set_slot_reset == RTAS_UNKNOWN_SERVICE		||
+	    (ibm_read_slot_reset_state2 == RTAS_UNKNOWN_SERVICE &&
+	     ibm_read_slot_reset_state == RTAS_UNKNOWN_SERVICE)	||
+	    ibm_slot_error_detail == RTAS_UNKNOWN_SERVICE	||
+	    ibm_configure_pe == RTAS_UNKNOWN_SERVICE) {
+		pr_info("EEH functionality not supported\n");
+		return -EINVAL;
+	}
+
+	/* Initialize error log lock and size */
+	spin_lock_init(&slot_errbuf_lock);
+	eeh_error_buf_size = rtas_token("rtas-error-log-max");
+	if (eeh_error_buf_size == RTAS_UNKNOWN_SERVICE) {
+		pr_info("%s: unknown EEH error log size\n",
+			__func__);
+		eeh_error_buf_size = 1024;
+	} else if (eeh_error_buf_size > RTAS_ERROR_LOG_MAX) {
+		pr_info("%s: EEH error log size %d exceeds the maximal %d\n",
+			__func__, eeh_error_buf_size, RTAS_ERROR_LOG_MAX);
+		eeh_error_buf_size = RTAS_ERROR_LOG_MAX;
+	}
+
+	/* Set EEH probe mode */
+	eeh_add_flag(EEH_PROBE_MODE_DEVTREE | EEH_ENABLE_IO_FOR_LOG);
+
+	/* Set EEH machine dependent code */
+	ppc_md.pcibios_bus_add_device = pseries_pcibios_bus_add_device;
+
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
 
 	ret = eeh_ops_register(&pseries_eeh_ops);
 	if (!ret)
-- 
2.35.1



