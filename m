Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92E348AFF0
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 15:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242765AbiAKOzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 09:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242983AbiAKOzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 09:55:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9F5C06173F;
        Tue, 11 Jan 2022 06:55:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5294616A7;
        Tue, 11 Jan 2022 14:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8D1C36AED;
        Tue, 11 Jan 2022 14:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641912904;
        bh=rdtKFzk5rkjL2CZWYI4wv3pYeOQVX9D847F/Fb8v8Iw=;
        h=From:To:Cc:Subject:Date:From;
        b=MPn0zXl+8gwVJwRSd0q+l1incPABWS8960L8naJ1GcZ0OnU8/3pwzqiA/BiS94w+u
         vlB5WlIzAOwSBzazOYqjbBmHKSsh7Jrhqe6oyxPMgIs0uk9OvTIRwR5T4995DlivgQ
         z/wCEGanaHI8Jw4ipUa9+FhTTwQuIQR/oTGvKVPCqmdFfntOMeP2uoCTYOHii5La0v
         wVdxa4cS9OWkrKJzJEHTp0Lfg8j8D0CPRYGfAUuiHyrhmsqPFRM8BKXhRRgeLsd37s
         WJ0ag9giM8uGDpqxuQOmwqw7EBvlKG4D74628aVOHVKkwLf9vqkTw1LkFEfkroLJOG
         hP6XrSpXPZ90g==
From:   Mike Rapoport <rppt@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Christian Dietrich <stettberger@dokucode.de>,
        Mike Rapoport <rppt@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] mm/pgtable: define pte_index so that preprocessor could recognize it
Date:   Tue, 11 Jan 2022 16:54:57 +0200
Message-Id: <20220111145457.20748-1-rppt@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

Since commit 974b9b2c68f3 ("mm: consolidate pte_index() and pte_offset_*()
definitions") pte_index is a static inline and there is no define for it
that can be recognized by the preprocessor. As the result,
vm_insert_pages() uses slower loop over vm_insert_page() instead of
insert_pages() that amortizes the cost of spinlock operations when
inserting multiple pages.

Fixes: 974b9b2c68f3 ("mm: consolidate pte_index() and pte_offset_*() definitions")
Reported-by: Christian Dietrich <stettberger@dokucode.de>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: stable@vger.kernel.org
---
 include/linux/pgtable.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index e24d2c992b11..d468efcf48f4 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -62,6 +62,7 @@ static inline unsigned long pte_index(unsigned long address)
 {
 	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
 }
+#define pte_index pte_index
 
 #ifndef pmd_index
 static inline unsigned long pmd_index(unsigned long address)

base-commit: 2585cf9dfaaddf00b069673f27bb3f8530e2039c
-- 
2.28.0

