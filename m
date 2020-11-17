Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B5D2B5FE8
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgKQM7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:59:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728577AbgKQM5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:57:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D81F2151B;
        Tue, 17 Nov 2020 12:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617835;
        bh=w7VnWskPvaV6tzVCHJZWzM2nqZnQFY5pXxE3yIS/zU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Imay0JLK23QK72zKUkvfJQbPqI5+grkFxmpdRE04xRKX5WP1dYZ5cszII666KlS2J
         ixXIl0xbASGv+PmT56kKizE2sA/nQQ6EKqWkNsmiyWNwOEy2tFwSPGCRVE1i0hx7hi
         bJgxfWpLYL0sH3q7VszUPfRkKoBz2NyiGAGpGorI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christopher Obbard <chris.obbard@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 14/21] um: Call pgtable_pmd_page_dtor() in __pmd_free_tlb()
Date:   Tue, 17 Nov 2020 07:56:45 -0500
Message-Id: <20201117125652.599614-14-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117125652.599614-1-sashal@kernel.org>
References: <20201117125652.599614-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

[ Upstream commit 9a5085b3fad5d5d6019a3d160cdd70357d35c8b1 ]

Commit b2b29d6d0119 ("mm: account PMD tables like PTE tables") uncovered
a bug in uml, we forgot to call the destructor.
While we are here, give x a sane name.

Reported-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Co-developed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Tested-by: Christopher Obbard <chris.obbard@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/include/asm/pgalloc.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/um/include/asm/pgalloc.h b/arch/um/include/asm/pgalloc.h
index 5393e13e07e0a..2bbf28cf3aa92 100644
--- a/arch/um/include/asm/pgalloc.h
+++ b/arch/um/include/asm/pgalloc.h
@@ -33,7 +33,13 @@ do {							\
 } while (0)
 
 #ifdef CONFIG_3_LEVEL_PGTABLES
-#define __pmd_free_tlb(tlb,x, address)   tlb_remove_page((tlb),virt_to_page(x))
+
+#define __pmd_free_tlb(tlb, pmd, address)		\
+do {							\
+	pgtable_pmd_page_dtor(virt_to_page(pmd));	\
+	tlb_remove_page((tlb),virt_to_page(pmd));	\
+} while (0)						\
+
 #endif
 
 #endif
-- 
2.27.0

