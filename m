Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558372E37DF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbgL1NCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:02:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:58392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730022AbgL1NCP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:02:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDB2822AAD;
        Mon, 28 Dec 2020 13:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160494;
        bh=2fmLW/om088uHuhHIqZBpB1c8Ng6+o4iSQVawsMcQtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zVnO5+ty3hD9RwyJHKnJH5lUU9KD4JhahjEy9F7R8/7ffY2UVjG/IXX3/TwSvFIbk
         tkzcCOFNsWtNE+5BvFyHW8J6zLoZR/9wHCD1FaRzAuqlYZntpHqTrQQnhOWKEwHQTn
         j0iqdr05HrJt/e4BG5kIrViq/CH/m182sf5mU73U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 071/175] powerpc/feature: Fix CPU_FTRS_ALWAYS by removing CPU_FTRS_GENERIC_32
Date:   Mon, 28 Dec 2020 13:48:44 +0100
Message-Id: <20201228124856.685423061@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
index cf51aea47510c..090edefe125da 100644
--- a/arch/powerpc/include/asm/cputable.h
+++ b/arch/powerpc/include/asm/cputable.h
@@ -419,7 +419,6 @@ enum {
 	    CPU_FTR_DBELL | CPU_FTR_POPCNTB | CPU_FTR_POPCNTD | \
 	    CPU_FTR_DEBUG_LVL_EXC | CPU_FTR_EMB_HV | CPU_FTR_ALTIVEC_COMP | \
 	    CPU_FTR_CELL_TB_BUG | CPU_FTR_SMT)
-#define CPU_FTRS_GENERIC_32	(CPU_FTR_COMMON | CPU_FTR_NODSISRALIGN)
 
 /* 64-bit CPUs */
 #define CPU_FTRS_POWER4	(CPU_FTR_USE_TB | CPU_FTR_LWSYNC | \
@@ -510,8 +509,6 @@ enum {
 	    CPU_FTRS_7447 | CPU_FTRS_7447A | CPU_FTRS_82XX |
 	    CPU_FTRS_G2_LE | CPU_FTRS_E300 | CPU_FTRS_E300C2 |
 	    CPU_FTRS_CLASSIC32 |
-#else
-	    CPU_FTRS_GENERIC_32 |
 #endif
 #ifdef CONFIG_8xx
 	    CPU_FTRS_8XX |
@@ -562,8 +559,6 @@ enum {
 	    CPU_FTRS_7447 & CPU_FTRS_7447A & CPU_FTRS_82XX &
 	    CPU_FTRS_G2_LE & CPU_FTRS_E300 & CPU_FTRS_E300C2 &
 	    CPU_FTRS_CLASSIC32 &
-#else
-	    CPU_FTRS_GENERIC_32 &
 #endif
 #ifdef CONFIG_8xx
 	    CPU_FTRS_8XX &
-- 
2.27.0



