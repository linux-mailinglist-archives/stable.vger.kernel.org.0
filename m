Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6123D5ED8
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236597AbhGZPLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236431AbhGZPJJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:09:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E13460FD7;
        Mon, 26 Jul 2021 15:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314556;
        bh=YEHp7ZrqZ9KoefIsiiCf+iPvjdNGEFxLvlxy/k2R/uA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THwapuJ1+inCxp2wPCx8BLZcpWBIzqawMM1Xy8qk9EsA32XZfJ37ik8O7YLpCvQzf
         JQeeVwkOaANG4nl+tHYwrE6k6lj1aUhDhDNsPLdeG8hqrhkvFlM4QhPKGptBXI1NAR
         WqkodMPy8CNGCxr/vKbURM6P0n5Vk3sE/vYUGD8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Pei <huangpei@loongson.cn>
Subject: [PATCH 4.14 59/82] [PATCH] Revert "MIPS: add PMD table accounting into MIPSpmd_alloc_one"
Date:   Mon, 26 Jul 2021 17:38:59 +0200
Message-Id: <20210726153830.090386424@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Pei <huangpei@loongson.cn>

This reverts commit 920a42d8b854b1f112aef97a21f0549918889442 which is
commit commit ed914d48b6a1040d1039d371b56273d422c0081e upstream.

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
 


