Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8F61AC3ED
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392428AbgDPNvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392420AbgDPNvk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:51:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D20020786;
        Thu, 16 Apr 2020 13:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045099;
        bh=OGZkcncoHPVJmL7cRIy9th8i3wkYCksTTNGUQW77P4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+wHn/SJ2rwgaZYmW9mpjkobMx3vD/Ev4MsXfme2osRx3wwCXp8FMGC3LM2DYeADz
         C1AI71nvnYLU0td1ymT8qo9NSbhBA6wHO/eZ9h8hM8SbyPVkRJzRbzrDIAzsq1/gBQ
         hfWQyy5L5PupqJ9yTLx91kPRY+Sk7qmgO5fAhO7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 230/232] powerpc/kasan: Fix kasan_remap_early_shadow_ro()
Date:   Thu, 16 Apr 2020 15:25:24 +0200
Message-Id: <20200416131344.321623895@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit af92bad615be75c6c0d1b1c5b48178360250a187 ]

At the moment kasan_remap_early_shadow_ro() does nothing, because
k_end is 0 and k_cur < 0 is always true.

Change the test to k_cur != k_end, as done in
kasan_init_shadow_page_tables()

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: cbd18991e24f ("powerpc/mm: Fix an Oops in kasan_mmu_init()")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/4e7b56865e01569058914c991143f5961b5d4719.1583507333.git.christophe.leroy@c-s.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/kasan/kasan_init_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/kasan/kasan_init_32.c b/arch/powerpc/mm/kasan/kasan_init_32.c
index 0e6ed4413eeac..1cfe57b51d7e3 100644
--- a/arch/powerpc/mm/kasan/kasan_init_32.c
+++ b/arch/powerpc/mm/kasan/kasan_init_32.c
@@ -117,7 +117,7 @@ static void __init kasan_remap_early_shadow_ro(void)
 
 	kasan_populate_pte(kasan_early_shadow_pte, prot);
 
-	for (k_cur = k_start & PAGE_MASK; k_cur < k_end; k_cur += PAGE_SIZE) {
+	for (k_cur = k_start & PAGE_MASK; k_cur != k_end; k_cur += PAGE_SIZE) {
 		pmd_t *pmd = pmd_offset(pud_offset(pgd_offset_k(k_cur), k_cur), k_cur);
 		pte_t *ptep = pte_offset_kernel(pmd, k_cur);
 
-- 
2.20.1



