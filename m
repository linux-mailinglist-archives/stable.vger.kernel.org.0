Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756A932859B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235305AbhCAQzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:55:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235760AbhCAQti (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:49:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6D8964F17;
        Mon,  1 Mar 2021 16:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616346;
        bh=8KetaY3jJxH96ZE64Is+hsCF0fw8fPzVg9/TFD8GjgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2jkFD/joZcRYjAJi81DrRRrbP4clCrHpycnjdgdIHjSgGuLM9/M6cCbsZg/WKID0
         NKR6O4idEWfYtCaf/IhwxAtK1OYmWM1j4dWnLq3Bb7Y7Ypn0Nna5sZfkE6Yg/ZCqTV
         VlxkRFLb6PlZwTOhZkBrqtm7p+jp7LakiwMJ6GVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hongxiang Lou <louhongxiang@huawei.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michel Lespinasse <walken@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Wei Yang <richard.weiyang@linux.alibaba.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Brian Geffon <bgeffon@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 119/176] mm/rmap: fix potential pte_unmap on an not mapped pte
Date:   Mon,  1 Mar 2021 17:13:12 +0100
Message-Id: <20210301161026.894166436@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 5d5d19eda6b0ee790af89c45e3f678345be6f50f ]

For PMD-mapped page (usually THP), pvmw->pte is NULL.  For PTE-mapped THP,
pvmw->pte is mapped.  But for HugeTLB pages, pvmw->pte is not mapped and
set to the relevant page table entry.  So in page_vma_mapped_walk_done(),
we may do pte_unmap() for HugeTLB pte which is not mapped.  Fix this by
checking pvmw->page against PageHuge before trying to do pte_unmap().

Link: https://lkml.kernel.org/r/20210127093349.39081-1-linmiaohe@huawei.com
Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
Signed-off-by: Hongxiang Lou <louhongxiang@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michel Lespinasse <walken@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rmap.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 988d176472df7..d7d6d4eb17949 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -214,7 +214,8 @@ struct page_vma_mapped_walk {
 
 static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
 {
-	if (pvmw->pte)
+	/* HugeTLB pte is set to the relevant page table entry without pte_mapped. */
+	if (pvmw->pte && !PageHuge(pvmw->page))
 		pte_unmap(pvmw->pte);
 	if (pvmw->ptl)
 		spin_unlock(pvmw->ptl);
-- 
2.27.0



