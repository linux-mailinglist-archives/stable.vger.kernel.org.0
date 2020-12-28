Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A1C2E3F4A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503491AbgL1O35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:29:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:38046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503479AbgL1O35 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:29:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F048920715;
        Mon, 28 Dec 2020 14:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165756;
        bh=LO60mf2UALiMu1xO/Jw4nMzD7JclZyMfE+EJXbiWE5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qp70y4bX67FBRl6x38xHtP0Tmj6d9VylOrUGcqwT5kqXRsyU/SgMXahTe+JZ+i1IS
         nCpBqsXzz8RK8iKvQN8AORCRpARfFN50WFCZY9Ei4DTF+bJH+DI48JEGWkg6Q8rQlp
         CiKuxe1dd5edain4lkmF35evJbY/atBGMiLLz1yE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 613/717] powerpc/8xx: Fix early debug when SMC1 is relocated
Date:   Mon, 28 Dec 2020 13:50:11 +0100
Message-Id: <20201228125050.286785483@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 1e78f723d6a52966bfe3804209dbf404fdc9d3bb upstream.

When SMC1 is relocated and early debug is selected, the
board hangs is ppc_md.setup_arch(). This is because ones
the microcode has been loaded and SMC1 relocated, early
debug writes in the weed.

To allow smooth continuation, the SMC1 parameter RAM set up
by the bootloader have to be copied into the new location.

Fixes: 43db76f41824 ("powerpc/8xx: Add microcode patch to move SMC parameter RAM.")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/b2f71f39eca543f1e4ec06596f09a8b12235c701.1607076683.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/cpm1.h         |    1 +
 arch/powerpc/platforms/8xx/micropatch.c |   11 +++++++++++
 2 files changed, 12 insertions(+)

--- a/arch/powerpc/include/asm/cpm1.h
+++ b/arch/powerpc/include/asm/cpm1.h
@@ -68,6 +68,7 @@ extern void cpm_reset(void);
 #define PROFF_SPI	((uint)0x0180)
 #define PROFF_SCC3	((uint)0x0200)
 #define PROFF_SMC1	((uint)0x0280)
+#define PROFF_DSP1	((uint)0x02c0)
 #define PROFF_SCC4	((uint)0x0300)
 #define PROFF_SMC2	((uint)0x0380)
 
--- a/arch/powerpc/platforms/8xx/micropatch.c
+++ b/arch/powerpc/platforms/8xx/micropatch.c
@@ -360,6 +360,17 @@ void __init cpm_load_patch(cpm8xx_t *cp)
 	if (IS_ENABLED(CONFIG_SMC_UCODE_PATCH)) {
 		smc_uart_t *smp;
 
+		if (IS_ENABLED(CONFIG_PPC_EARLY_DEBUG_CPM)) {
+			int i;
+
+			for (i = 0; i < sizeof(*smp); i += 4) {
+				u32 __iomem *src = (u32 __iomem *)&cp->cp_dparam[PROFF_SMC1 + i];
+				u32 __iomem *dst = (u32 __iomem *)&cp->cp_dparam[PROFF_DSP1 + i];
+
+				out_be32(dst, in_be32(src));
+			}
+		}
+
 		smp = (smc_uart_t *)&cp->cp_dparam[PROFF_SMC1];
 		out_be16(&smp->smc_rpbase, 0x1ec0);
 		smp = (smc_uart_t *)&cp->cp_dparam[PROFF_SMC2];


