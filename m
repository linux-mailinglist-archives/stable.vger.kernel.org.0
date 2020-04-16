Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26571AC30B
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897413AbgDPNhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:37:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896190AbgDPNhE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:37:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E28A7208E4;
        Thu, 16 Apr 2020 13:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044222;
        bh=wttoton6TEU7iHeRKVPjij7bCAVwDWT6iBkWVBDZgs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zCdGBgxRhPo17UVo9PmKgFCjwkgOJpZUaHylt4pzbfEJr1GCXr2oi/pdcCZS6qSwO
         4uLQWr31yzYCoMgMY8bgL1+jpJfdRY6b9PmLLarxD3j3OBSC0JAWgsr6wFpyj2p9Oj
         VP7DVNrer8vOEZw/ZcPavXCmfbHk8nDqArkqhFE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pei Huang <huangpei@loongson.cn>,
        Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.5 131/257] MIPS/tlbex: Fix LDDIR usage in setup_pw() for Loongson-3
Date:   Thu, 16 Apr 2020 15:23:02 +0200
Message-Id: <20200416131342.796318254@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

commit d191aaffe3687d1e73e644c185f5f0550ec242b5 upstream.

LDDIR/LDPTE is Loongson-3's acceleration for Page Table Walking. If BD
(Base Directory, the 4th page directory) is not enabled, then GDOffset
is biased by BadVAddr[63:62]. So, if GDOffset (aka. BadVAddr[47:36] for
Loongson-3) is big enough, "0b11(BadVAddr[63:62])|BadVAddr[47:36]|...."
can far beyond pg_swapper_dir. This means the pg_swapper_dir may NOT be
accessed by LDDIR correctly, so fix it by set PWDirExt in CP0_PWCtl.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pei Huang <huangpei@loongson.cn>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/mm/tlbex.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -1480,6 +1480,7 @@ static void build_r4000_tlb_refill_handl
 
 static void setup_pw(void)
 {
+	unsigned int pwctl;
 	unsigned long pgd_i, pgd_w;
 #ifndef __PAGETABLE_PMD_FOLDED
 	unsigned long pmd_i, pmd_w;
@@ -1506,6 +1507,7 @@ static void setup_pw(void)
 
 	pte_i = ilog2(_PAGE_GLOBAL);
 	pte_w = 0;
+	pwctl = 1 << 30; /* Set PWDirExt */
 
 #ifndef __PAGETABLE_PMD_FOLDED
 	write_c0_pwfield(pgd_i << 24 | pmd_i << 12 | pt_i << 6 | pte_i);
@@ -1516,8 +1518,9 @@ static void setup_pw(void)
 #endif
 
 #ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
-	write_c0_pwctl(1 << 6 | psn);
+	pwctl |= (1 << 6 | psn);
 #endif
+	write_c0_pwctl(pwctl);
 	write_c0_kpgd((long)swapper_pg_dir);
 	kscratch_used_mask |= (1 << 7); /* KScratch6 is used for KPGD */
 }


