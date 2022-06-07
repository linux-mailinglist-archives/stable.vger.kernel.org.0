Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5695412EE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357333AbiFGTzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358638AbiFGTws (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:52:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8C136173;
        Tue,  7 Jun 2022 11:21:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2540560DDA;
        Tue,  7 Jun 2022 18:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3613FC385A2;
        Tue,  7 Jun 2022 18:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626104;
        bh=OfpDucA+meciRfZXXHe2/e6CRQkH5VCUTVwXmkHiZOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oOug5rrZHE69fyncveyoQGx2yOZygdCl3Yk6B3gLx69M9ecPXMqodBzfdeRdKTMzm
         092oKVS4HA4WU8z5IQLBhhSkT5fMBTjfBbJ3UQCAwJBD1oNewqcehgwWiXLcq3rhTU
         NFAGFuv3njcbzQ8fPq/TiG8l3YwNdtqzYzj6CGUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 252/772] x86/PCI: Fix ALi M1487 (IBC) PIRQ router link value interpretation
Date:   Tue,  7 Jun 2022 18:57:24 +0200
Message-Id: <20220607164956.451603819@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit 4969e223b109754c2340a26bba9b1cf44f0cba9b ]

Fix an issue with commit 1ce849c75534 ("x86/PCI: Add support for the ALi
M1487 (IBC) PIRQ router") and correct ALi M1487 (IBC) PIRQ router link
value (`pirq' cookie) interpretation according to findings in the BIOS.

Credit to Nikolai Zhubr for the detective work as to the bit layout.

Fixes: 1ce849c75534 ("x86/PCI: Add support for the ALi M1487 (IBC) PIRQ router")
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2203310013270.44113@angie.orcam.me.uk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/pci/irq.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 97b63e35e152..21c4bc41741f 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -253,6 +253,15 @@ static void write_pc_conf_nybble(u8 base, u8 index, u8 val)
 	pc_conf_set(reg, x);
 }
 
+/*
+ * FinALi pirq rules are as follows:
+ *
+ * - bit 0 selects between INTx Routing Table Mapping Registers,
+ *
+ * - bit 3 selects the nibble within the INTx Routing Table Mapping Register,
+ *
+ * - bits 7:4 map to bits 3:0 of the PCI INTx Sensitivity Register.
+ */
 static int pirq_finali_get(struct pci_dev *router, struct pci_dev *dev,
 			   int pirq)
 {
@@ -260,11 +269,13 @@ static int pirq_finali_get(struct pci_dev *router, struct pci_dev *dev,
 		0, 9, 3, 10, 4, 5, 7, 6, 0, 11, 0, 12, 0, 14, 0, 15
 	};
 	unsigned long flags;
+	u8 index;
 	u8 x;
 
+	index = (pirq & 1) << 1 | (pirq & 8) >> 3;
 	raw_spin_lock_irqsave(&pc_conf_lock, flags);
 	pc_conf_set(PC_CONF_FINALI_LOCK, PC_CONF_FINALI_LOCK_KEY);
-	x = irqmap[read_pc_conf_nybble(PC_CONF_FINALI_PCI_INTX_RT1, pirq - 1)];
+	x = irqmap[read_pc_conf_nybble(PC_CONF_FINALI_PCI_INTX_RT1, index)];
 	pc_conf_set(PC_CONF_FINALI_LOCK, 0);
 	raw_spin_unlock_irqrestore(&pc_conf_lock, flags);
 	return x;
@@ -278,13 +289,15 @@ static int pirq_finali_set(struct pci_dev *router, struct pci_dev *dev,
 	};
 	u8 val = irqmap[irq];
 	unsigned long flags;
+	u8 index;
 
 	if (!val)
 		return 0;
 
+	index = (pirq & 1) << 1 | (pirq & 8) >> 3;
 	raw_spin_lock_irqsave(&pc_conf_lock, flags);
 	pc_conf_set(PC_CONF_FINALI_LOCK, PC_CONF_FINALI_LOCK_KEY);
-	write_pc_conf_nybble(PC_CONF_FINALI_PCI_INTX_RT1, pirq - 1, val);
+	write_pc_conf_nybble(PC_CONF_FINALI_PCI_INTX_RT1, index, val);
 	pc_conf_set(PC_CONF_FINALI_LOCK, 0);
 	raw_spin_unlock_irqrestore(&pc_conf_lock, flags);
 	return 1;
@@ -293,7 +306,7 @@ static int pirq_finali_set(struct pci_dev *router, struct pci_dev *dev,
 static int pirq_finali_lvl(struct pci_dev *router, struct pci_dev *dev,
 			   int pirq, int irq)
 {
-	u8 mask = ~(1u << (pirq - 1));
+	u8 mask = ~((pirq & 0xf0u) >> 4);
 	unsigned long flags;
 	u8 trig;
 
-- 
2.35.1



