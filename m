Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506326AB041
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjCENyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjCENyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:54:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD8F16AD8;
        Sun,  5 Mar 2023 05:53:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1202B60B06;
        Sun,  5 Mar 2023 13:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAA7C433D2;
        Sun,  5 Mar 2023 13:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024396;
        bh=kq3BrUowsgV/gXng+qdT32gnUa2E/oaKHyxWEtfLW2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kj7B+s/bei47N+Xps5FoFhjzL+2+320yOWDvuCqCi0UdaESZ2XwPHBs7kqnKOg/kT
         /Dc9DfCTsGXHqMhbN34TsrcUdQ4qGCF1blgoF05n59FMvrhnLJDn5mU9g7ZFw55bMG
         Fy7my9JOyuILvQk7nZRTxMSMWegL56TzZPVh6e6PJdV73lYCaL4NKmNFxWqg7QECbA
         MpHI9q/NFtqMk8sUiau23OMVchkkeHgLIij9s5+Y7s5RRSNAn1ia0yRMvtOPcgh/ck
         mORdfO/rahh72umzQtXSanuiwsyxAuyNARHEUNfadlaEIBxHwNw4GKjUnuJIkFiUaZ
         5x31afcSWjn2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.1 03/15] powerpc: Check !irq instead of irq == NO_IRQ and remove NO_IRQ
Date:   Sun,  5 Mar 2023 08:52:54 -0500
Message-Id: <20230305135306.1793564-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135306.1793564-1-sashal@kernel.org>
References: <20230305135306.1793564-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit bab537805a10bdbf55b31324ba4a9599e0651e5e ]

NO_IRQ is a relic from the old days. It is not used anymore in core
functions. By the way, function irq_of_parse_and_map() returns value 0
on error.

In some drivers, NO_IRQ is erroneously used to check the return of
irq_of_parse_and_map().

It is not a real bug today because the only architectures using the
drivers being fixed by this patch define NO_IRQ as 0, but there are
architectures which define NO_IRQ as -1. If one day those
architectures start using the non fixed drivers, there will be a
problem.

Long time ago Linus advocated for not using NO_IRQ, see
https://lore.kernel.org/all/Pine.LNX.4.64.0511211150040.13959@g5.osdl.org

He re-iterated the same view recently in
https://lore.kernel.org/all/CAHk-=wg2Pkb9kbfbstbB91AJA2SF6cySbsgHG-iQMq56j3VTcA@mail.gmail.com

So test !irq instead of tesing irq == NO_IRQ.

All other usage of NO_IRQ for powerpc were removed in previous cycles so
the time has come to remove NO_IRQ completely for powerpc.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/4b8d4f96140af01dec3a3330924dda8b2451c316.1674476798.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/irq.h    | 3 ---
 arch/powerpc/platforms/44x/fsp2.c | 2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
index 5c1516a5ba8f6..deadd2149426a 100644
--- a/arch/powerpc/include/asm/irq.h
+++ b/arch/powerpc/include/asm/irq.h
@@ -16,9 +16,6 @@
 
 extern atomic_t ppc_n_lost_interrupts;
 
-/* This number is used when no interrupt has been assigned */
-#define NO_IRQ			(0)
-
 /* Total number of virq in the platform */
 #define NR_IRQS		CONFIG_NR_IRQS
 
diff --git a/arch/powerpc/platforms/44x/fsp2.c b/arch/powerpc/platforms/44x/fsp2.c
index e2e4f6d8150d6..56d91dbef5770 100644
--- a/arch/powerpc/platforms/44x/fsp2.c
+++ b/arch/powerpc/platforms/44x/fsp2.c
@@ -205,7 +205,7 @@ static void __init node_irq_request(const char *compat, irq_handler_t errirq_han
 
 	for_each_compatible_node(np, NULL, compat) {
 		irq = irq_of_parse_and_map(np, 0);
-		if (irq == NO_IRQ) {
+		if (!irq) {
 			pr_err("device tree node %pOFn is missing a interrupt",
 			      np);
 			of_node_put(np);
-- 
2.39.2

