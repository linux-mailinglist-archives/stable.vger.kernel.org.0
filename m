Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B751AA42A
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370789AbgDONSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:18:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48265 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S370777AbgDONS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 09:18:29 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 2D12A5C0148;
        Wed, 15 Apr 2020 09:18:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 09:18:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ss8qC0
        UWsq9GJZJ+o/+9s62IncDY2t7igUL9RddQwzY=; b=xSy7mGSpKrsWFERMM8h3Q/
        wmL22XdianL7CauTcsZOHT/9BSvSV0yToR69TSyZaQjiRbh6pDCPdwtijrL/k1zi
        VEdGD5anYC6NkEGHKcOkRSFbEVQ833DAQR8etyrzQ5id/SOhW+88AOYG9rn21IKc
        eEsisLG/frM7GRe7gaqAvpwRHE6K5Y45CWKTuRlPUH6f/Or3bz1AUR94vftENZiM
        ZCoUSJ0bTofKk/1+2Twr51/KVbUFcGTA4KayowChi9my8Hr9kuSdFeoohSqGbSQc
        DBirjfo3fZ9fp4ufVOilzIK/ObOqEAY9eBQXflKkQ9wAEjkT8GkWnKBGgOqevK0w
        ==
X-ME-Sender: <xms:pAmXXrrV7aQ-XPhRSl1P1qoCrF_V3nESK3LEJLJYOlsKWwf77vnVVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:pAmXXlNb39gx7xcVcdZiwAWjJV7g6hpvtHMEdidCu6ijDDu5Qg1blw>
    <xmx:pAmXXsgHJhCtf3sbzjAwU6ID9kuwdh8UAMr7SIWTJw1GkDJxmuyQug>
    <xmx:pAmXXhaAb-jpx6zuCY5T8nnlae5jRwh-Zyv0AkDzwkUvoC-MLS28Dg>
    <xmx:pAmXXrCJP-zXx4IY5nXRgIUAVkN474n_sSUr3XWBLl37iYC6I9rHsA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BDF70328005A;
        Wed, 15 Apr 2020 09:18:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/kasan: Fix kasan_remap_early_shadow_ro()" failed to apply to 5.4-stable tree
To:     christophe.leroy@c-s.fr, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 15:18:25 +0200
Message-ID: <1586956705226232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From af92bad615be75c6c0d1b1c5b48178360250a187 Mon Sep 17 00:00:00 2001
From: Christophe Leroy <christophe.leroy@c-s.fr>
Date: Fri, 6 Mar 2020 15:09:40 +0000
Subject: [PATCH] powerpc/kasan: Fix kasan_remap_early_shadow_ro()

At the moment kasan_remap_early_shadow_ro() does nothing, because
k_end is 0 and k_cur < 0 is always true.

Change the test to k_cur != k_end, as done in
kasan_init_shadow_page_tables()

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: cbd18991e24f ("powerpc/mm: Fix an Oops in kasan_mmu_init()")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/4e7b56865e01569058914c991143f5961b5d4719.1583507333.git.christophe.leroy@c-s.fr

diff --git a/arch/powerpc/mm/kasan/kasan_init_32.c b/arch/powerpc/mm/kasan/kasan_init_32.c
index f19526e7d3dc..1a29cf469903 100644
--- a/arch/powerpc/mm/kasan/kasan_init_32.c
+++ b/arch/powerpc/mm/kasan/kasan_init_32.c
@@ -101,7 +101,7 @@ static void __init kasan_remap_early_shadow_ro(void)
 
 	kasan_populate_pte(kasan_early_shadow_pte, prot);
 
-	for (k_cur = k_start & PAGE_MASK; k_cur < k_end; k_cur += PAGE_SIZE) {
+	for (k_cur = k_start & PAGE_MASK; k_cur != k_end; k_cur += PAGE_SIZE) {
 		pmd_t *pmd = pmd_ptr_k(k_cur);
 		pte_t *ptep = pte_offset_kernel(pmd, k_cur);
 

