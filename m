Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4B32011B9
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405058AbgFSPoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404520AbgFSP2H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:28:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4655820734;
        Fri, 19 Jun 2020 15:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580486;
        bh=1W7ciwKT7nhl3Rm86JXIph25pepyuP35MTQS4sBnLTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IlBOH74hBAHCgJUNZ8CRXhTXHoWEGcW+WMV+phc0Oip17It4qK1KKsH2f6dTaSTlE
         iIz+Kt1mtcYa4jPkmXaHdYwcWPkPpYEP1/bcur0eWJfRNt5jxRQjmW8yOViULjva2W
         Dqnr8NWDkqaAIPQoAgu+v8f6x42MHTWb9Z2jjAdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.7 267/376] powerpc/mm: Fix conditions to perform MMU specific management by blocks on PPC32.
Date:   Fri, 19 Jun 2020 16:33:05 +0200
Message-Id: <20200619141722.972828083@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 4e3319c23a66dabfd6c35f4d2633d64d99b68096 upstream.

Setting init mem to NX shall depend on sinittext being mapped by
block, not on stext being mapped by block.

Setting text and rodata to RO shall depend on stext being mapped by
block, not on sinittext being mapped by block.

Fixes: 63b2bc619565 ("powerpc/mm/32s: Use BATs for STRICT_KERNEL_RWX")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/7d565fb8f51b18a3d98445a830b2f6548cb2da2a.1589866984.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/pgtable_32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -169,7 +169,7 @@ void mark_initmem_nx(void)
 	unsigned long numpages = PFN_UP((unsigned long)_einittext) -
 				 PFN_DOWN((unsigned long)_sinittext);
 
-	if (v_block_mapped((unsigned long)_stext + 1))
+	if (v_block_mapped((unsigned long)_sinittext))
 		mmu_mark_initmem_nx();
 	else
 		change_page_attr(page, numpages, PAGE_KERNEL);
@@ -181,7 +181,7 @@ void mark_rodata_ro(void)
 	struct page *page;
 	unsigned long numpages;
 
-	if (v_block_mapped((unsigned long)_sinittext)) {
+	if (v_block_mapped((unsigned long)_stext + 1)) {
 		mmu_mark_rodata_ro();
 		ptdump_check_wx();
 		return;


