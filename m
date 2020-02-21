Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C86A916750E
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388315AbgBUIWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:22:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388317AbgBUIWc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:22:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 246ED24672;
        Fri, 21 Feb 2020 08:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273351;
        bh=3TZXsTWy+GWOyXb49qV/Qbo9WyB4oDNA5l7odcnIJfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVVl8XBXZ+rr7q61qBQYW3BYn/zVPxuKiRdh6Fl8ei5w+sQ6bMPDLF1ZhGC1uVagu
         xF7TI7tRmi/NgA839KcR8RNG9/HRuks1ztU7XC3yklkU4oDOeQqAUGUH8jTboEm/TK
         v8Dpc+gcZJpan6QdaeGOXraJ6b17aMdGK+mhAF9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 139/191] x86/mm: Fix NX bit clearing issue in kernel_map_pages_in_pgd
Date:   Fri, 21 Feb 2020 08:41:52 +0100
Message-Id: <20200221072307.386508422@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 75fbef0a8b6b4bb19b9a91b5214f846c2dc5139e ]

The following commit:

  15f003d20782 ("x86/mm/pat: Don't implicitly allow _PAGE_RW in kernel_map_pages_in_pgd()")

modified kernel_map_pages_in_pgd() to manage writable permissions
of memory mappings in the EFI page table in a different way, but
in the process, it removed the ability to clear NX attributes from
read-only mappings, by clobbering the clear mask if _PAGE_RW is not
being requested.

Failure to remove the NX attribute from read-only mappings is
unlikely to be a security issue, but it does prevent us from
tightening the permissions in the EFI page tables going forward,
so let's fix it now.

Fixes: 15f003d20782 ("x86/mm/pat: Don't implicitly allow _PAGE_RW in kernel_map_pages_in_pgd()
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20200113172245.27925-5-ardb@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pageattr.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index e2d4b25c7aa44..101f3ad0d6ad1 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -2126,19 +2126,13 @@ int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 		.pgd = pgd,
 		.numpages = numpages,
 		.mask_set = __pgprot(0),
-		.mask_clr = __pgprot(0),
+		.mask_clr = __pgprot(~page_flags & (_PAGE_NX|_PAGE_RW)),
 		.flags = 0,
 	};
 
 	if (!(__supported_pte_mask & _PAGE_NX))
 		goto out;
 
-	if (!(page_flags & _PAGE_NX))
-		cpa.mask_clr = __pgprot(_PAGE_NX);
-
-	if (!(page_flags & _PAGE_RW))
-		cpa.mask_clr = __pgprot(_PAGE_RW);
-
 	if (!(page_flags & _PAGE_ENC))
 		cpa.mask_clr = pgprot_encrypted(cpa.mask_clr);
 
-- 
2.20.1



