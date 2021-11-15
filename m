Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5B7450C47
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237736AbhKORhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:37:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:47376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238289AbhKOReT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:34:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CA6763282;
        Mon, 15 Nov 2021 17:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996975;
        bh=gruabU3qmChnesd0zG01NJcgxh5RerhN2OQ5ib37KMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GMDVxoEI54QlbRDVkoP9lWtnxJjPhVo4mjpZk1w55C5JhAhJdHb7AK8+tGryPAbS0
         BXwCsfCGLn54O9IuPDkH42yzTptH3PsJ/o62pjMnNBAM980sXAnI0482R1W8XDdwC0
         1EyHGR+3tEz+PeRSMLNXdItB6J+uTsAdeOWljZho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 336/355] parisc: Fix set_fixmap() on PA1.x CPUs
Date:   Mon, 15 Nov 2021 18:04:20 +0100
Message-Id: <20211115165324.608541703@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 6e866a462867b60841202e900f10936a0478608c upstream.

Fix a kernel crash which happens on PA1.x CPUs while initializing the
FTRACE/KPROBE breakpoints.  The PTE table entries for the fixmap area
were not created correctly.

Signed-off-by: Helge Deller <deller@gmx.de>
Fixes: ccfbc68d41c2 ("parisc: add set_fixmap()/clear_fixmap()")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/mm/fixmap.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/parisc/mm/fixmap.c
+++ b/arch/parisc/mm/fixmap.c
@@ -18,12 +18,9 @@ void notrace set_fixmap(enum fixed_addre
 	pte_t *pte;
 
 	if (pmd_none(*pmd))
-		pmd = pmd_alloc(NULL, pgd, vaddr);
-
-	pte = pte_offset_kernel(pmd, vaddr);
-	if (pte_none(*pte))
 		pte = pte_alloc_kernel(pmd, vaddr);
 
+	pte = pte_offset_kernel(pmd, vaddr);
 	set_pte_at(&init_mm, vaddr, pte, __mk_pte(phys, PAGE_KERNEL_RWX));
 	flush_tlb_kernel_range(vaddr, vaddr + PAGE_SIZE);
 }


