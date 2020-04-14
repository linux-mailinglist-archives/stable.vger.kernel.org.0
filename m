Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A67C1A789F
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 12:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438527AbgDNKnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 06:43:11 -0400
Received: from foss.arm.com ([217.140.110.172]:52816 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438506AbgDNKnA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 06:43:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D463331B;
        Tue, 14 Apr 2020 03:42:59 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id ED6E73F6C4;
        Tue, 14 Apr 2020 03:42:58 -0700 (PDT)
From:   Mark Rutland <mark.rutland@arm.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     catalin.marinas@arm.com, mark.rutland@arm.com,
        vincenzo.frascino@arm.com, will@kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/5] arm64: vdso: don't free unallocated pages
Date:   Tue, 14 Apr 2020 11:42:48 +0100
Message-Id: <20200414104252.16061-2-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200414104252.16061-1-mark.rutland@arm.com>
References: <20200414104252.16061-1-mark.rutland@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The aarch32_vdso_pages[] array never has entries allocated in the C_VVAR
or C_VDSO slots, and as the array is zero initialized these contain
NULL.

However in __aarch32_alloc_vdso_pages() when
aarch32_alloc_kuser_vdso_page() fails we attempt to free the page whose
struct page is at NULL, which is obviously nonsensical.

This patch removes the erroneous page freeing.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kernel/vdso.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index 354b11e27c07..033a48f30dbb 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -260,18 +260,7 @@ static int __aarch32_alloc_vdso_pages(void)
 	if (ret)
 		return ret;
 
-	ret = aarch32_alloc_kuser_vdso_page();
-	if (ret) {
-		unsigned long c_vvar =
-			(unsigned long)page_to_virt(aarch32_vdso_pages[C_VVAR]);
-		unsigned long c_vdso =
-			(unsigned long)page_to_virt(aarch32_vdso_pages[C_VDSO]);
-
-		free_page(c_vvar);
-		free_page(c_vdso);
-	}
-
-	return ret;
+	return aarch32_alloc_kuser_vdso_page();
 }
 #else
 static int __aarch32_alloc_vdso_pages(void)
-- 
2.11.0

