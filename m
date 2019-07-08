Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D396C624E8
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388073AbfGHPWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729493AbfGHPWw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:22:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 053B1216E3;
        Mon,  8 Jul 2019 15:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599372;
        bh=RYOBTpTrNjHCdpFk/eqreEmSwKZHskeo9MtL8o1Q9yE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kg3k7zI+m+Ix2C5BAir51JmPWH8kzy1NHBL68UtNaW0YCPnDjtV+QIztqz2UqLDmo
         b20WldLZb3dPFDI3X6emCo6EKSLGPwtrlaFMzFmuXqVVZHSmV2IoJl56wfLxkDqmAU
         CRX5z2oMzAvlOHnah7G7BrQamoR3hmoCH3aXWS24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jisheng Zhang <jszhang@marvell.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Kees Cook <keescook@chromium.org>,
        Will Deacon <will.deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 097/102] arm64, vdso: Define vdso_{start,end} as array
Date:   Mon,  8 Jul 2019 17:13:30 +0200
Message-Id: <20190708150531.499551020@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit dbbb08f500d6146398b794fdc68a8e811366b451 upstream.

Adjust vdso_{start|end} to be char arrays to avoid compile-time analysis
that flags "too large" memcmp() calls with CONFIG_FORTIFY_SOURCE.

Cc: Jisheng Zhang <jszhang@marvell.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/vdso.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index c9b9a5a322eb..c0f315ecfa7c 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -37,7 +37,7 @@
 #include <asm/vdso.h>
 #include <asm/vdso_datapage.h>
 
-extern char vdso_start, vdso_end;
+extern char vdso_start[], vdso_end[];
 static unsigned long vdso_pages __ro_after_init;
 
 /*
@@ -124,14 +124,14 @@ static int __init vdso_init(void)
 	int i;
 	struct page **vdso_pagelist;
 
-	if (memcmp(&vdso_start, "\177ELF", 4)) {
+	if (memcmp(vdso_start, "\177ELF", 4)) {
 		pr_err("vDSO is not a valid ELF object!\n");
 		return -EINVAL;
 	}
 
-	vdso_pages = (&vdso_end - &vdso_start) >> PAGE_SHIFT;
+	vdso_pages = (vdso_end - vdso_start) >> PAGE_SHIFT;
 	pr_info("vdso: %ld pages (%ld code @ %p, %ld data @ %p)\n",
-		vdso_pages + 1, vdso_pages, &vdso_start, 1L, vdso_data);
+		vdso_pages + 1, vdso_pages, vdso_start, 1L, vdso_data);
 
 	/* Allocate the vDSO pagelist, plus a page for the data. */
 	vdso_pagelist = kcalloc(vdso_pages + 1, sizeof(struct page *),
@@ -144,7 +144,7 @@ static int __init vdso_init(void)
 
 	/* Grab the vDSO code pages. */
 	for (i = 0; i < vdso_pages; i++)
-		vdso_pagelist[i + 1] = pfn_to_page(PHYS_PFN(__pa(&vdso_start)) + i);
+		vdso_pagelist[i + 1] = pfn_to_page(PHYS_PFN(__pa(vdso_start)) + i);
 
 	vdso_spec[0].pages = &vdso_pagelist[0];
 	vdso_spec[1].pages = &vdso_pagelist[1];
-- 
2.20.1



