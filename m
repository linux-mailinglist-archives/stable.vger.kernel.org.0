Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103F94626A8
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbhK2Wzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236133AbhK2WzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:55:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627BAC19AC31;
        Mon, 29 Nov 2021 10:36:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7B749CE13D8;
        Mon, 29 Nov 2021 18:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26328C53FC7;
        Mon, 29 Nov 2021 18:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210959;
        bh=Dup6iQh7H/8J7hcor2h12608adT7iYKvafRSfNhTgW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=snakdTtVmdRip3JpOTRxbtXBgNN5sAU1uvI/uC3GsRVYmRUyBKKct/WpZYD4nzURM
         mFqDinaS2+FN7EIik4cCay0d/FYuuMhiiPjXFnXAjipInOz3IzK01kVNY+8Hhkfww3
         wFemb+dZJ0dbC4IrOLahVsDxHE3Wjm/PTkX20Zv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pingfan Liu <kernelfans@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        James Morse <james.morse@arm.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.15 053/179] arm64: mm: Fix VM_BUG_ON(mm != &init_mm) for trans_pgd
Date:   Mon, 29 Nov 2021 19:17:27 +0100
Message-Id: <20211129181720.719044173@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pingfan Liu <kernelfans@gmail.com>

commit d3eb70ead6474ec16f976fcacf10a7a890a95bd3 upstream.

trans_pgd_create_copy() can hit "VM_BUG_ON(mm != &init_mm)" in the
function pmd_populate_kernel().

This is the combined consequence of commit 5de59884ac0e ("arm64:
trans_pgd: pass NULL instead of init_mm to *_populate functions"), which
replaced &init_mm with NULL and commit 59511cfd08f3 ("arm64: mm: use XN
table mapping attributes for user/kernel mappings"), which introduced
the VM_BUG_ON.

Since the former sounds reasonable, it is better to work on the later.
>From the perspective of trans_pgd, two groups of functions are
considered in the later one:

  pmd_populate_kernel()
    mm == NULL should be fixed, else it hits VM_BUG_ON()
  p?d_populate()
    mm == NULL means PXN, that is OK, since trans_pgd only copies a
    linear map, no execution will happen on the map.

So it is good enough to just relax VM_BUG_ON() to disregard mm == NULL

Fixes: 59511cfd08f3 ("arm64: mm: use XN table mapping attributes for user/kernel mappings")
Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Cc: <stable@vger.kernel.org> # 5.13.x
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Matthias Brugger <mbrugger@suse.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/r/20211112052214.9086-1-kernelfans@gmail.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/pgalloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/pgalloc.h
+++ b/arch/arm64/include/asm/pgalloc.h
@@ -76,7 +76,7 @@ static inline void __pmd_populate(pmd_t
 static inline void
 pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmdp, pte_t *ptep)
 {
-	VM_BUG_ON(mm != &init_mm);
+	VM_BUG_ON(mm && mm != &init_mm);
 	__pmd_populate(pmdp, __pa(ptep), PMD_TYPE_TABLE | PMD_TABLE_UXN);
 }
 


