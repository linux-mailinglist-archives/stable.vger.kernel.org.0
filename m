Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DC92C0A08
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733147AbgKWMny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:43:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:57036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732615AbgKWMnx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:43:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 590632078E;
        Mon, 23 Nov 2020 12:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135433;
        bh=w7VnWskPvaV6tzVCHJZWzM2nqZnQFY5pXxE3yIS/zU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=svaqK08sPGUdF27y07K3kRJgV9TBZwwstjQampC+HT0MBGfRVZXCjABH0tNivMtWI
         mX49Euf8ijm/yurpBMzzI53ygCyB0biyCt4W8VJMjeOuNHgOGyMYm803fmp19Ljk4Q
         mNPMVxfg8HgsoWS0hMZGSKk6yax59iZ4SOrwq7Ho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Christopher Obbard <chris.obbard@collabora.com>,
        Sasha Levin <sashal@kernel.org>,
        Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 5.9 066/252] um: Call pgtable_pmd_page_dtor() in __pmd_free_tlb()
Date:   Mon, 23 Nov 2020 13:20:16 +0100
Message-Id: <20201123121838.775181156@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



