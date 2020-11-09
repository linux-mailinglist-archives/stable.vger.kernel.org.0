Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4B62ABA9C
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387980AbgKINUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:20:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:48526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387988AbgKINUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:20:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C0EA2076E;
        Mon,  9 Nov 2020 13:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928051;
        bh=GSlhinP0ajG89SWkjKT8XVTuEdeiZOeCztjRjQ9zIfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rVtjKaUUO329E/LiHarrXjUJUSzGWUrJpUlMoa4KxRYTLdQ8q2QvLnm481F1j9pX9
         Td+cfj9NbjLxz22+9evtGX3RqE4V2m7anRIFKUr1u/1qkXfMqNKw0DjKGs/eZaZWQc
         YguYSPVhDm0v2jS4YFBCBqhk+G9SM1U4VvaGKT4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.9 111/133] s390/mm: make pmd/pud_deref() large page aware
Date:   Mon,  9 Nov 2020 13:56:13 +0100
Message-Id: <20201109125036.029459109@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit b0e98aa9c411585eb586b2fa98873c936735008e upstream.

pmd/pud_deref() assume that they will never operate on large pmd/pud
entries, and therefore only use the non-large _xxx_ENTRY_ORIGIN mask.
With commit 9ec8fa8dc331b ("s390/vmemmap: extend modify_pagetable()
to handle vmemmap"), that assumption is no longer true, at least for
pmd_deref().

In theory, we could end up with wrong addresses because some of the
non-address bits of a large entry would not be masked out.
In practice, this does not (yet) show any impact, because vmemmap_free()
is currently never used for s390.

Fix pmd/pud_deref() to check for the entry type and use the
_xxx_ENTRY_ORIGIN_LARGE mask for large entries.

While at it, also move pmd/pud_pfn() around, in order to avoid code
duplication, because they do the same thing.

Fixes: 9ec8fa8dc331b ("s390/vmemmap: extend modify_pagetable() to handle vmemmap")
Cc: <stable@vger.kernel.org> # 5.9
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/pgtable.h |   52 +++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 22 deletions(-)

--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -691,16 +691,6 @@ static inline int pud_large(pud_t pud)
 	return !!(pud_val(pud) & _REGION3_ENTRY_LARGE);
 }
 
-static inline unsigned long pud_pfn(pud_t pud)
-{
-	unsigned long origin_mask;
-
-	origin_mask = _REGION_ENTRY_ORIGIN;
-	if (pud_large(pud))
-		origin_mask = _REGION3_ENTRY_ORIGIN_LARGE;
-	return (pud_val(pud) & origin_mask) >> PAGE_SHIFT;
-}
-
 #define pmd_leaf	pmd_large
 static inline int pmd_large(pmd_t pmd)
 {
@@ -746,16 +736,6 @@ static inline int pmd_none(pmd_t pmd)
 	return pmd_val(pmd) == _SEGMENT_ENTRY_EMPTY;
 }
 
-static inline unsigned long pmd_pfn(pmd_t pmd)
-{
-	unsigned long origin_mask;
-
-	origin_mask = _SEGMENT_ENTRY_ORIGIN;
-	if (pmd_large(pmd))
-		origin_mask = _SEGMENT_ENTRY_ORIGIN_LARGE;
-	return (pmd_val(pmd) & origin_mask) >> PAGE_SHIFT;
-}
-
 #define pmd_write pmd_write
 static inline int pmd_write(pmd_t pmd)
 {
@@ -1230,11 +1210,39 @@ static inline pte_t mk_pte(struct page *
 #define pud_index(address) (((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
 #define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
 
-#define pmd_deref(pmd) (pmd_val(pmd) & _SEGMENT_ENTRY_ORIGIN)
-#define pud_deref(pud) (pud_val(pud) & _REGION_ENTRY_ORIGIN)
 #define p4d_deref(pud) (p4d_val(pud) & _REGION_ENTRY_ORIGIN)
 #define pgd_deref(pgd) (pgd_val(pgd) & _REGION_ENTRY_ORIGIN)
 
+static inline unsigned long pmd_deref(pmd_t pmd)
+{
+	unsigned long origin_mask;
+
+	origin_mask = _SEGMENT_ENTRY_ORIGIN;
+	if (pmd_large(pmd))
+		origin_mask = _SEGMENT_ENTRY_ORIGIN_LARGE;
+	return pmd_val(pmd) & origin_mask;
+}
+
+static inline unsigned long pmd_pfn(pmd_t pmd)
+{
+	return pmd_deref(pmd) >> PAGE_SHIFT;
+}
+
+static inline unsigned long pud_deref(pud_t pud)
+{
+	unsigned long origin_mask;
+
+	origin_mask = _REGION_ENTRY_ORIGIN;
+	if (pud_large(pud))
+		origin_mask = _REGION3_ENTRY_ORIGIN_LARGE;
+	return pud_val(pud) & origin_mask;
+}
+
+static inline unsigned long pud_pfn(pud_t pud)
+{
+	return pud_deref(pud) >> PAGE_SHIFT;
+}
+
 /*
  * The pgd_offset function *always* adds the index for the top-level
  * region/segment table. This is done to get a sequence like the


