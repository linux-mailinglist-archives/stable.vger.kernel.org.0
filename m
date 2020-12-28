Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440352E6408
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406896AbgL1Ppx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:45:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404637AbgL1Nol (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:44:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1837720738;
        Mon, 28 Dec 2020 13:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163040;
        bh=tw0e43QpVeMlHeB4V0Mukm4z0BoW8F0ABVJvnt6wqWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=glYUe/FdxISe48fL9YWl/lutg66IqzlC6RV/gPF93ORK9mKf8SR/WRCYnuJi2E+wo
         rB0zIJOxVcBCJOfQD3fYNeNgh9TbnrzMu3cQn5rEzPwF4PeJyK/UoPZsb3B2fjCWC8
         Sh65bDLfXSyMxuiQp84Tzf4omauzqYqVBYmCTv8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 149/453] powerpc/feature: Fix CPU_FTRS_ALWAYS by removing CPU_FTRS_GENERIC_32
Date:   Mon, 28 Dec 2020 13:46:25 +0100
Message-Id: <20201228124944.375872734@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 78665179e569c7e1fe102fb6c21d0f5b6951f084 ]

On 8xx, we get the following features:

[    0.000000] cpu_features      = 0x0000000000000100
[    0.000000]   possible        = 0x0000000000000120
[    0.000000]   always          = 0x0000000000000000

This is not correct. As CONFIG_PPC_8xx is mutually exclusive with all
other configurations, the three lines should be equal.

The problem is due to CPU_FTRS_GENERIC_32 which is taken when
CONFIG_BOOK3S_32 is NOT selected. This CPU_FTRS_GENERIC_32 is
pointless because there is no generic configuration supporting
all 32 bits but book3s/32.

Remove this pointless generic features definition to unbreak the
calculation of 'possible' features and 'always' features.

Fixes: 76bc080ef5a3 ("[POWERPC] Make default cputable entries reflect selected CPU family")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/76a85f30bf981d1aeaae00df99321235494da254.1604426550.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/cputable.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/powerpc/include/asm/cputable.h b/arch/powerpc/include/asm/cputable.h
index cf00ff0d121de..dc8e8552bd487 100644
--- a/arch/powerpc/include/asm/cputable.h
+++ b/arch/powerpc/include/asm/cputable.h
@@ -407,7 +407,6 @@ static inline void cpu_feature_keys_init(void) { }
 	    CPU_FTR_DBELL | CPU_FTR_POPCNTB | CPU_FTR_POPCNTD | \
 	    CPU_FTR_DEBUG_LVL_EXC | CPU_FTR_EMB_HV | CPU_FTR_ALTIVEC_COMP | \
 	    CPU_FTR_CELL_TB_BUG | CPU_FTR_SMT)
-#define CPU_FTRS_GENERIC_32	(CPU_FTR_COMMON | CPU_FTR_NODSISRALIGN)
 
 /* 64-bit CPUs */
 #define CPU_FTRS_PPC970	(CPU_FTR_LWSYNC | \
@@ -507,8 +506,6 @@ enum {
 	    CPU_FTRS_7447 | CPU_FTRS_7447A | CPU_FTRS_82XX |
 	    CPU_FTRS_G2_LE | CPU_FTRS_E300 | CPU_FTRS_E300C2 |
 	    CPU_FTRS_CLASSIC32 |
-#else
-	    CPU_FTRS_GENERIC_32 |
 #endif
 #ifdef CONFIG_PPC_8xx
 	    CPU_FTRS_8XX |
@@ -585,8 +582,6 @@ enum {
 	    CPU_FTRS_7447 & CPU_FTRS_7447A & CPU_FTRS_82XX &
 	    CPU_FTRS_G2_LE & CPU_FTRS_E300 & CPU_FTRS_E300C2 &
 	    CPU_FTRS_CLASSIC32 &
-#else
-	    CPU_FTRS_GENERIC_32 &
 #endif
 #ifdef CONFIG_PPC_8xx
 	    CPU_FTRS_8XX &
-- 
2.27.0



