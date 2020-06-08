Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1CC1F2CFE
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbgFIA36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730152AbgFHXQC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5431220760;
        Mon,  8 Jun 2020 23:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658162;
        bh=qhYCEQfSq1AIL7uUJiMFmb/JrY9ncCLZK+5BK5+eA/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPMGQaK9hLE2ifWHlBeBy+BafvceQy12OMqkPdnZrI+m4z9ckl8ST05b1ikRboZNS
         K+f7uPC95MRLyav+vzVdrjltmluej+WlU40Siy7gnG2MwMNjQifJnMivYRmllp4VPn
         dIprpmNFyrM4bqohA77IUhgF2VvRG6P9Po/RW72k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Rapoport <rppt@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Anatoly Pugachev <matorola@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sparclinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 191/606] sparc32: fix page table traversal in srmmu_nocache_init()
Date:   Mon,  8 Jun 2020 19:05:16 -0400
Message-Id: <20200608231211.3363633-191-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit 0cfc8a8d70dcd51db783e8e87917e02149c71458 upstream.

The srmmu_nocache_init() uses __nocache_fix() macro to add an offset to
page table entry to access srmmu_nocache_pool.

But since sparc32 has only three actual page table levels, pgd, p4d and
pud are essentially the same thing and pgd_offset() and p4d_offset() are
no-ops, the __nocache_fix() should be done only at PUD level.

Remove __nocache_fix() for p4d_offset() and pud_offset() and keep it
only for PUD and lower levels.

Fixes: c2bc26f7ca1f ("sparc32: use PUD rather than PGD to get PMD in srmmu_nocache_init()")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Anatoly Pugachev <matorola@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/mm/srmmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index 083ba02c94e6..80061bc93bdc 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -331,8 +331,8 @@ static void __init srmmu_nocache_init(void)
 
 	while (vaddr < srmmu_nocache_end) {
 		pgd = pgd_offset_k(vaddr);
-		p4d = p4d_offset(__nocache_fix(pgd), vaddr);
-		pud = pud_offset(__nocache_fix(p4d), vaddr);
+		p4d = p4d_offset(pgd, vaddr);
+		pud = pud_offset(p4d, vaddr);
 		pmd = pmd_offset(__nocache_fix(pud), vaddr);
 		pte = pte_offset_kernel(__nocache_fix(pmd), vaddr);
 
-- 
2.25.1

