Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF1A206374
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390479AbgFWUZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390489AbgFWUZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:25:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B04A920723;
        Tue, 23 Jun 2020 20:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943912;
        bh=meQbLYmN//tMPZmpwqNW5uUjQrbTyW/842tj/SRI8Yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HcAzIO+Yxf17Lo/F13b3wUx8xJpc7WbPqJjCcWvSgHtvq5QPbxWlpIIl/9ILix4dh
         HpuKhDqDmdGFmaiygK2C6sD8IZ6oj4sITIN883lllS5MjTRbSRuiXqS31fsde23zGN
         Z4ygKeuf6Wi06GvKBaddDGeRJCJs9SLD+OzHkgNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/314] sparc32: mm: Dont try to free page-table pages if ctor() fails
Date:   Tue, 23 Jun 2020 21:54:24 +0200
Message-Id: <20200623195342.135415674@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit 454b0289c6b5f2c66164654b80212d15fbef7a03 ]

The pages backing page-table allocations for SRMMU are allocated via
memblock as part of the "nocache" region initialisation during
srmmu_paging_init() and should not be freed even if a later call to
pgtable_pte_page_ctor() fails.

Remove the broken call to __free_page().

Cc: David S. Miller <davem@davemloft.net>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Fixes: 1ae9ae5f7df7 ("sparc: handle pgtable_page_ctor() fail")
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/mm/srmmu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index cc3ad64479ac3..9e256d4d1f4cf 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -379,7 +379,6 @@ pgtable_t pte_alloc_one(struct mm_struct *mm)
 		return NULL;
 	page = pfn_to_page(__nocache_pa(pte) >> PAGE_SHIFT);
 	if (!pgtable_pte_page_ctor(page)) {
-		__free_page(page);
 		return NULL;
 	}
 	return page;
-- 
2.25.1



