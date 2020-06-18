Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B72C1FE860
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgFRBKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:10:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728369AbgFRBKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E519D21D90;
        Thu, 18 Jun 2020 01:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442601;
        bh=7OFBYehAghyI03+0CzcorCPm2clfgBnBM6lz8Cfhh80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0PCTUWZg8pWwPZ5JyN6eGg5nzI/izcDQpfozJ7+8n2qoNTo6sdqiPmxogThRmLor0
         pr0GyTHnp3/LuTVbea7chB6WLBCaEG77lccBbaFzcKLT1gMx/zk9HiuXdyVTP7Q3Te
         9/g/01Xe4h90vZTvAGT0IckAvuJPeotz4mp9fPV4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Sasha Levin <sashal@kernel.org>, sparclinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 088/388] sparc32: mm: Don't try to free page-table pages if ctor() fails
Date:   Wed, 17 Jun 2020 21:03:05 -0400
Message-Id: <20200618010805.600873-88-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a8c2f2615fc6..ecc9e8786d57 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -383,7 +383,6 @@ pgtable_t pte_alloc_one(struct mm_struct *mm)
 		return NULL;
 	page = pfn_to_page(__nocache_pa(pte) >> PAGE_SHIFT);
 	if (!pgtable_pte_page_ctor(page)) {
-		__free_page(page);
 		return NULL;
 	}
 	return page;
-- 
2.25.1

