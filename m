Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3AE5415AD
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357852AbiFGUhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377545AbiFGUdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:33:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D731E4BD6;
        Tue,  7 Jun 2022 11:35:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AA0361564;
        Tue,  7 Jun 2022 18:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FE1C385A2;
        Tue,  7 Jun 2022 18:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626920;
        bh=DQbIueL18va2zuS1vVdIlSrZFWRd4l681P+YldGzJqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Am2M7WSodnoSZ8jgoEEgCrlNzFHCRnCBGf6U7WCEKngXU9nR7IofU3zBWIPmPMK4k
         +tAV0SNKykU2cdppG4RNpbqk9gAi/MsnDqnn1y1GDRqnuFtPYUHmpT8LDZy/qyKeiN
         oIBhqIIHhZEHigl5wgQ/8cVjcxTdA5J8CdHWlTSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 551/772] powerpc/xive: Add some error handling code to xive_spapr_init()
Date:   Tue,  7 Jun 2022 19:02:23 +0200
Message-Id: <20220607165005.199648017@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e414e2938ee26e734f19e92a60cd090ebaff37e6 ]

'xive_irq_bitmap_add()' can return -ENOMEM.
In this case, we should free the memory already allocated and return
'false' to the caller.

Also add an error path which undoes the 'tima = ioremap(...)'

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/564998101804886b151235c8a9f93020923bfd2c.1643718324.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xive/spapr.c | 36 +++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/sysdev/xive/spapr.c b/arch/powerpc/sysdev/xive/spapr.c
index 928f95004501..29456c255f9f 100644
--- a/arch/powerpc/sysdev/xive/spapr.c
+++ b/arch/powerpc/sysdev/xive/spapr.c
@@ -67,6 +67,17 @@ static int __init xive_irq_bitmap_add(int base, int count)
 	return 0;
 }
 
+static void xive_irq_bitmap_remove_all(void)
+{
+	struct xive_irq_bitmap *xibm, *tmp;
+
+	list_for_each_entry_safe(xibm, tmp, &xive_irq_bitmaps, list) {
+		list_del(&xibm->list);
+		kfree(xibm->bitmap);
+		kfree(xibm);
+	}
+}
+
 static int __xive_irq_bitmap_alloc(struct xive_irq_bitmap *xibm)
 {
 	int irq;
@@ -803,7 +814,7 @@ bool __init xive_spapr_init(void)
 	u32 val;
 	u32 len;
 	const __be32 *reg;
-	int i;
+	int i, err;
 
 	if (xive_spapr_disabled())
 		return false;
@@ -828,23 +839,26 @@ bool __init xive_spapr_init(void)
 	}
 
 	if (!xive_get_max_prio(&max_prio))
-		return false;
+		goto err_unmap;
 
 	/* Feed the IRQ number allocator with the ranges given in the DT */
 	reg = of_get_property(np, "ibm,xive-lisn-ranges", &len);
 	if (!reg) {
 		pr_err("Failed to read 'ibm,xive-lisn-ranges' property\n");
-		return false;
+		goto err_unmap;
 	}
 
 	if (len % (2 * sizeof(u32)) != 0) {
 		pr_err("invalid 'ibm,xive-lisn-ranges' property\n");
-		return false;
+		goto err_unmap;
 	}
 
-	for (i = 0; i < len / (2 * sizeof(u32)); i++, reg += 2)
-		xive_irq_bitmap_add(be32_to_cpu(reg[0]),
-				    be32_to_cpu(reg[1]));
+	for (i = 0; i < len / (2 * sizeof(u32)); i++, reg += 2) {
+		err = xive_irq_bitmap_add(be32_to_cpu(reg[0]),
+					  be32_to_cpu(reg[1]));
+		if (err < 0)
+			goto err_mem_free;
+	}
 
 	/* Iterate the EQ sizes and pick one */
 	of_property_for_each_u32(np, "ibm,xive-eq-sizes", prop, reg, val) {
@@ -855,10 +869,16 @@ bool __init xive_spapr_init(void)
 
 	/* Initialize XIVE core with our backend */
 	if (!xive_core_init(np, &xive_spapr_ops, tima, TM_QW1_OS, max_prio))
-		return false;
+		goto err_mem_free;
 
 	pr_info("Using %dkB queues\n", 1 << (xive_queue_shift - 10));
 	return true;
+
+err_mem_free:
+	xive_irq_bitmap_remove_all();
+err_unmap:
+	iounmap(tima);
+	return false;
 }
 
 machine_arch_initcall(pseries, xive_core_debug_init);
-- 
2.35.1



