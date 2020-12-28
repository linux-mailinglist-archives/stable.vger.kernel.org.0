Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2B82E4024
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438109AbgL1OV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:21:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441455AbgL1OV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4B272245C;
        Mon, 28 Dec 2020 14:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165297;
        bh=MEIaGCsYs120eQxJ23SWsWAAtreazA3Z5+j9wP3P9sQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fOoNPEPv9odb7x1WuGbRVfjp1hMN024nke8ewYe+BJcPjpZmWNnkkI/DEuKUxSO2K
         mjb1XhGBrP/sPPxU3X6DGp0B4pLgsF1YPWO3VycroDk/Gjox4XkNjg67asdur7BDa0
         r/CBhuQfTRVTNT+WG2Pj7wdnfRiyaS5Labp7gYz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 475/717] powerpc/32s: Fix cleanup_cpu_mmu_context() compile bug
Date:   Mon, 28 Dec 2020 13:47:53 +0100
Message-Id: <20201228125043.723873815@linuxfoundation.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit c1bea0a840ac75dca19bc6aa05575a33eb9fd058 ]

Currently pmac32_defconfig with SMP=y doesn't build:

  arch/powerpc/platforms/powermac/smp.c:
  error: implicit declaration of function 'cleanup_cpu_mmu_context'

It would be nice for consistency if all platforms clear mm_cpumask and
flush TLBs on unplug, but the TLB invalidation bug described in commit
01b0f0eae081 ("powerpc/64s: Trim offlined CPUs from mm_cpumasks") only
applies to 64s and for now we only have the TLB flush code for that
platform.

So just add an empty version for 32-bit Book3S.

Fixes: 01b0f0eae081 ("powerpc/64s: Trim offlined CPUs from mm_cpumasks")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
[mpe: Change log based on comments from Nick]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/book3s/32/mmu-hash.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/include/asm/book3s/32/mmu-hash.h b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
index 2e277ca0170fb..a8982d52f6b1d 100644
--- a/arch/powerpc/include/asm/book3s/32/mmu-hash.h
+++ b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
@@ -94,6 +94,7 @@ typedef struct {
 } mm_context_t;
 
 void update_bats(void);
+static inline void cleanup_cpu_mmu_context(void) { };
 
 /* patch sites */
 extern s32 patch__hash_page_A0, patch__hash_page_A1, patch__hash_page_A2;
-- 
2.27.0



