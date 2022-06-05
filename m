Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEA153DC03
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 15:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347374AbiFEN53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 09:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350712AbiFEN4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 09:56:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE79BE08D;
        Sun,  5 Jun 2022 06:55:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46E1460FC0;
        Sun,  5 Jun 2022 13:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9000DC3411E;
        Sun,  5 Jun 2022 13:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654437313;
        bh=aUep4enDS2rEm1cqYLVP0bI+LmbTqMVDSvrpQnmDAJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eIX7lBm9tXBBYjmYq1jEW8fP2kTPaWuIyNBD0mKaMLfDlnS5sM4xhFwbKBlYiFjzw
         lCu1/6SNiXNJC3kNOaEugNGpAor97rTf4RXWigN9NgGCRj2ujFT80VFzQ/5moTVu8q
         exBvkscsEvL3CSbjZS4RnUEgxf2wyrIeLd0R8HuWSffW9G6XLy8FXjbYaoQRZSLJqY
         yaF57bvWGq4J9KV+rsC+qmGzLSm7+3lnAzmYgRuI8AFBvCgMepdcGfh07b8eX7j0zf
         EIR/BtwQRhAOpHH/47spLEuxEgXkiDX3kvMJ7SmtUKqt2lVYqSOtHcvQZjv/zkmPs8
         8icoNnslkFGqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, bhelgaas@google.com,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH MANUALSEL 5.4 4/4] x86/PCI: Add PIRQ routing table range checks
Date:   Sun,  5 Jun 2022 09:55:00 -0400
Message-Id: <20220605135503.61690-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220605135503.61690-1-sashal@kernel.org>
References: <20220605135503.61690-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: "Maciej W. Rozycki" <macro@orcam.me.uk>

[ Upstream commit 5d64089aa4a5bd3d7e00e3d6ddf4943dd34627b3 ]

Verify that the PCI IRQ Routing Table header as well as individual slot
entries are all wholly contained within the BIOS memory area.  Do not
even call the checksum calculator if the header would overrun the area
and then bail out early if any slot would.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2203301735510.22465@angie.orcam.me.uk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/pci/irq.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index d3a73f9335e1..2bf6d2c4874b 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -62,7 +62,8 @@ void (*pcibios_disable_irq)(struct pci_dev *dev) = pirq_disable_irq;
  *  and perform checksum verification.
  */
 
-static inline struct irq_routing_table *pirq_check_routing_table(u8 *addr)
+static inline struct irq_routing_table *pirq_check_routing_table(u8 *addr,
+								 u8 *limit)
 {
 	struct irq_routing_table *rt;
 	int i;
@@ -72,7 +73,8 @@ static inline struct irq_routing_table *pirq_check_routing_table(u8 *addr)
 	if (rt->signature != PIRQ_SIGNATURE ||
 	    rt->version != PIRQ_VERSION ||
 	    rt->size % 16 ||
-	    rt->size < sizeof(struct irq_routing_table))
+	    rt->size < sizeof(struct irq_routing_table) ||
+	    (limit && rt->size > limit - addr))
 		return NULL;
 	sum = 0;
 	for (i = 0; i < rt->size; i++)
@@ -93,17 +95,22 @@ static inline struct irq_routing_table *pirq_check_routing_table(u8 *addr)
 
 static struct irq_routing_table * __init pirq_find_routing_table(void)
 {
+	u8 * const bios_start = (u8 *)__va(0xf0000);
+	u8 * const bios_end = (u8 *)__va(0x100000);
 	u8 *addr;
 	struct irq_routing_table *rt;
 
 	if (pirq_table_addr) {
-		rt = pirq_check_routing_table((u8 *) __va(pirq_table_addr));
+		rt = pirq_check_routing_table((u8 *)__va(pirq_table_addr),
+					      NULL);
 		if (rt)
 			return rt;
 		printk(KERN_WARNING "PCI: PIRQ table NOT found at pirqaddr\n");
 	}
-	for (addr = (u8 *) __va(0xf0000); addr < (u8 *) __va(0x100000); addr += 16) {
-		rt = pirq_check_routing_table(addr);
+	for (addr = bios_start;
+	     addr < bios_end - sizeof(struct irq_routing_table);
+	     addr += 16) {
+		rt = pirq_check_routing_table(addr, bios_end);
 		if (rt)
 			return rt;
 	}
-- 
2.35.1

