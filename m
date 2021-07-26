Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE14D3D5F2B
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235872AbhGZPRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236767AbhGZPPZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7002660F9E;
        Mon, 26 Jul 2021 15:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314783;
        bh=WJPswiVWL6sJFtQ+jGV2vIj33WC0X8ofGVMXQ0HRpUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wdcdwnLrM0gNxUR+hy9gpNqXiwQvMQLFYKzUrdfz7+jAgOK8febKsY1DLcRFdnBcl
         FMcRBhhQdJGbMZrkHFXSTN57OrWbOjok/nNwMelXr0anaoysbv8YlKYbIFFQyAa7EN
         ImvFzwvx+UklwwSa66c4spbm9j3mtIpjf6CBzKx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Pei <huangpei@loongson.cn>
Subject: [PATCH 4.19 090/120] [PATCH] Revert "MIPS: add PMD table accounting into MIPSpmd_alloc_one"
Date:   Mon, 26 Jul 2021 17:39:02 +0200
Message-Id: <20210726153835.272293632@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Pei <huangpei@loongson.cn>

This reverts commit 68046cc531577b8f0ebe67ccf18b9c70106d7937 which is
commit ed914d48b6a1040d1039d371b56273d422c0081e upstream.

Commit b2b29d6d011944 (mm: account PMD tables like PTE tables) is
introduced between v5.9 and v5.10, so this fix (commit 002d8b395fa1)
should NOT apply to any pre-5.10 branch.

Signed-off-by: Huang Pei <huangpei@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/pgalloc.h |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/arch/mips/include/asm/pgalloc.h
+++ b/arch/mips/include/asm/pgalloc.h
@@ -93,15 +93,11 @@ do {							\
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	pmd_t *pmd = NULL;
-	struct page *pg;
+	pmd_t *pmd;
 
-	pg = alloc_pages(GFP_KERNEL | __GFP_ACCOUNT, PMD_ORDER);
-	if (pg) {
-		pgtable_pmd_page_ctor(pg);
-		pmd = (pmd_t *)page_address(pg);
+	pmd = (pmd_t *) __get_free_pages(GFP_KERNEL, PMD_ORDER);
+	if (pmd)
 		pmd_init((unsigned long)pmd, (unsigned long)invalid_pte_table);
-	}
 	return pmd;
 }
 


