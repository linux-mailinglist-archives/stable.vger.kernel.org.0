Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED870450EE1
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241522AbhKOSVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:21:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241165AbhKOSSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:18:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80A3B633F6;
        Mon, 15 Nov 2021 17:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998673;
        bh=9KTEY2DSYPcZCVckqyP5Q3mnxm2Fb1tQzwkEICwZsgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZjmfN7ncj5rxfNHobOsyxJvLd5tv/HgswR/k3HhVk9gOnvhcO0lot3Hhvaz0gr3kE
         5WvQw8qIr5jSn9CDodxpg5h0ae9lax8SAdKFwhxPfzKniQT4ETgzX9ANITnSTjUd0n
         yGWCJWgKkWoYyFPUyb4AoORhOJYZv/a+DN1PeLbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.14 019/849] parisc: Fix set_fixmap() on PA1.x CPUs
Date:   Mon, 15 Nov 2021 17:51:42 +0100
Message-Id: <20211115165420.649569979@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
@@ -20,12 +20,9 @@ void notrace set_fixmap(enum fixed_addre
 	pte_t *pte;
 
 	if (pmd_none(*pmd))
-		pmd = pmd_alloc(NULL, pud, vaddr);
-
-	pte = pte_offset_kernel(pmd, vaddr);
-	if (pte_none(*pte))
 		pte = pte_alloc_kernel(pmd, vaddr);
 
+	pte = pte_offset_kernel(pmd, vaddr);
 	set_pte_at(&init_mm, vaddr, pte, __mk_pte(phys, PAGE_KERNEL_RWX));
 	flush_tlb_kernel_range(vaddr, vaddr + PAGE_SIZE);
 }


