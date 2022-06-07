Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B867D540E64
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244116AbiFGSyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354273AbiFGSqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD58119939;
        Tue,  7 Jun 2022 11:00:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE021B82182;
        Tue,  7 Jun 2022 18:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F5BC385A5;
        Tue,  7 Jun 2022 18:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624828;
        bh=kbOoBDzp3COFExOxK+0ldbz+C6vncqh4vcYv+bx7Ixg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OPfvL6PWfCZIwoQlON/ZAgNaX8xqbBOO+iE5YZdoHPhmSuqHNHOYksWPQEm2TjVKi
         B6QB1CY9TDvHdgEMWqM8NNA9G4MtHV0tcXuFLpGdKPY5qTGqT0+4M70flAdq27NSui
         YEQnY8l6jnOGpsL3E+0tU5XZqTmaJy9r+lH83SYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 467/667] powerpc/xive: Add some error handling code to xive_spapr_init()
Date:   Tue,  7 Jun 2022 19:02:12 +0200
Message-Id: <20220607164948.714451475@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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
index 1179632560b8..905dd40bd5cd 100644
--- a/arch/powerpc/sysdev/xive/spapr.c
+++ b/arch/powerpc/sysdev/xive/spapr.c
@@ -67,6 +67,17 @@ static int xive_irq_bitmap_add(int base, int count)
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



