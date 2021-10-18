Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A239A431D87
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbhJRNwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:52:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234049AbhJRNuX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:50:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4D4D619E2;
        Mon, 18 Oct 2021 13:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564272;
        bh=1clZC4+6scj+EWeoxEBLwVl8HlbEHeWyoiYZ54CDi00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xvuQ1x4Ivi3BdJIY960uMDDq7dil4k0MkJk5HGKtssutivOJuBYhwNU0KXXZTSVWH
         eA2H93vKEtMe4OfuTLBTy7nqlR/jtn981YMgSsye2RWJzftVxzY1W+Oa/BcTud7H5b
         /5/qIaxXhP8zz1zpI740UOM5I2ji1FmlOdYItsWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Kravetz <mike.kravetz@oracle.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.14 026/151] arm64/hugetlb: fix CMA gigantic page order for non-4K PAGE_SIZE
Date:   Mon, 18 Oct 2021 15:23:25 +0200
Message-Id: <20211018132341.530225688@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

commit 2e5809a4ddb15969503e43b06662a9a725f613ea upstream.

For non-4K PAGE_SIZE configs, the largest gigantic huge page size is
CONT_PMD_SHIFT order. On arm64 with 64K PAGE_SIZE, the gigantic page is
16G. Therefore, one should be able to specify 'hugetlb_cma=16G' on the
kernel command line so that one gigantic page can be allocated from CMA.
However, when adding such an option the following message is produced:

hugetlb_cma: cma area should be at least 8796093022208 MiB

This is because the calculation for non-4K gigantic page order is
incorrect in the arm64 specific routine arm64_hugetlb_cma_reserve().

Fixes: abb7962adc80 ("arm64/hugetlb: Reserve CMA areas for gigantic pages on 16K and 64K configs")
Cc: <stable@vger.kernel.org> # 5.9.x
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20211005202529.213812-1-mike.kravetz@oracle.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -43,7 +43,7 @@ void __init arm64_hugetlb_cma_reserve(vo
 #ifdef CONFIG_ARM64_4K_PAGES
 	order = PUD_SHIFT - PAGE_SHIFT;
 #else
-	order = CONT_PMD_SHIFT + PMD_SHIFT - PAGE_SHIFT;
+	order = CONT_PMD_SHIFT - PAGE_SHIFT;
 #endif
 	/*
 	 * HugeTLB CMA reservation is required for gigantic


