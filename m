Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78D9C6235A
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390567AbfGHPeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:34:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390559AbfGHPee (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:34:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E499204EC;
        Mon,  8 Jul 2019 15:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562600072;
        bh=3EPltH+TyhoVKGWzWdhMhsROLu5l28k94QXdN0XPeBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pXCFZoTlok0V7OaPCpY7WW5LbsWbOqSwo5d9N1qPyQKyTjfekI6eapuGXrCbtFsAp
         Frk/W8atq/cikWAwIztnFeWPTQQypAF9cFOL0dNzCZ9iGi5EbWCRRh90Dr1Lqg3E+V
         KVHzaFz5pkXFVBDPgHS1754OKvzW2zDt5NIIbi+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 84/96] s390/mm: fix pxd_bad with folded page tables
Date:   Mon,  8 Jul 2019 17:13:56 +0200
Message-Id: <20190708150530.986967549@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c9f621524e70774688db3cec60d85fa4c7de52e3 ]

With git commit d1874a0c2805fcfa9162c972d6b7541e57adb542
"s390/mm: make the pxd_offset functions more robust" and a 2-level page
table it can now happen that pgd_bad() gets asked to verify a large
segment table entry. If the entry is marked as dirty pgd_bad() will
incorrectly return true.

Change the pgd_bad(), p4d_bad(), pud_bad() and pmd_bad() functions to
first verify the table type, return false if the table level is lower
than what the function is suppossed to check, return true if the table
level is too high, and otherwise check the relevant region and segment
table bits. pmd_bad() has to check against ~SEGMENT_ENTRY_BITS for
normal page table pointers or ~SEGMENT_ENTRY_BITS_LARGE for large
segment table entries. Same for pud_bad() which has to check against
~_REGION_ENTRY_BITS or ~_REGION_ENTRY_BITS_LARGE.

Fixes: d1874a0c2805 ("s390/mm: make the pxd_offset functions more robust")
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/pgtable.h | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 394bec31cb97..9f0195d5fa16 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -238,7 +238,7 @@ static inline int is_module_addr(void *addr)
 #define _REGION_ENTRY_NOEXEC	0x100	/* region no-execute bit	    */
 #define _REGION_ENTRY_OFFSET	0xc0	/* region table offset		    */
 #define _REGION_ENTRY_INVALID	0x20	/* invalid region table entry	    */
-#define _REGION_ENTRY_TYPE_MASK	0x0c	/* region/segment table type mask   */
+#define _REGION_ENTRY_TYPE_MASK	0x0c	/* region table type mask	    */
 #define _REGION_ENTRY_TYPE_R1	0x0c	/* region first table type	    */
 #define _REGION_ENTRY_TYPE_R2	0x08	/* region second table type	    */
 #define _REGION_ENTRY_TYPE_R3	0x04	/* region third table type	    */
@@ -277,6 +277,7 @@ static inline int is_module_addr(void *addr)
 #define _SEGMENT_ENTRY_PROTECT	0x200	/* segment protection bit	    */
 #define _SEGMENT_ENTRY_NOEXEC	0x100	/* segment no-execute bit	    */
 #define _SEGMENT_ENTRY_INVALID	0x20	/* invalid segment table entry	    */
+#define _SEGMENT_ENTRY_TYPE_MASK 0x0c	/* segment table type mask	    */
 
 #define _SEGMENT_ENTRY		(0)
 #define _SEGMENT_ENTRY_EMPTY	(_SEGMENT_ENTRY_INVALID)
@@ -614,15 +615,9 @@ static inline int pgd_none(pgd_t pgd)
 
 static inline int pgd_bad(pgd_t pgd)
 {
-	/*
-	 * With dynamic page table levels the pgd can be a region table
-	 * entry or a segment table entry. Check for the bit that are
-	 * invalid for either table entry.
-	 */
-	unsigned long mask =
-		~_SEGMENT_ENTRY_ORIGIN & ~_REGION_ENTRY_INVALID &
-		~_REGION_ENTRY_TYPE_MASK & ~_REGION_ENTRY_LENGTH;
-	return (pgd_val(pgd) & mask) != 0;
+	if ((pgd_val(pgd) & _REGION_ENTRY_TYPE_MASK) < _REGION_ENTRY_TYPE_R1)
+		return 0;
+	return (pgd_val(pgd) & ~_REGION_ENTRY_BITS) != 0;
 }
 
 static inline unsigned long pgd_pfn(pgd_t pgd)
@@ -703,6 +698,8 @@ static inline int pmd_large(pmd_t pmd)
 
 static inline int pmd_bad(pmd_t pmd)
 {
+	if ((pmd_val(pmd) & _SEGMENT_ENTRY_TYPE_MASK) > 0)
+		return 1;
 	if (pmd_large(pmd))
 		return (pmd_val(pmd) & ~_SEGMENT_ENTRY_BITS_LARGE) != 0;
 	return (pmd_val(pmd) & ~_SEGMENT_ENTRY_BITS) != 0;
@@ -710,8 +707,12 @@ static inline int pmd_bad(pmd_t pmd)
 
 static inline int pud_bad(pud_t pud)
 {
-	if ((pud_val(pud) & _REGION_ENTRY_TYPE_MASK) < _REGION_ENTRY_TYPE_R3)
-		return pmd_bad(__pmd(pud_val(pud)));
+	unsigned long type = pud_val(pud) & _REGION_ENTRY_TYPE_MASK;
+
+	if (type > _REGION_ENTRY_TYPE_R3)
+		return 1;
+	if (type < _REGION_ENTRY_TYPE_R3)
+		return 0;
 	if (pud_large(pud))
 		return (pud_val(pud) & ~_REGION_ENTRY_BITS_LARGE) != 0;
 	return (pud_val(pud) & ~_REGION_ENTRY_BITS) != 0;
@@ -719,8 +720,12 @@ static inline int pud_bad(pud_t pud)
 
 static inline int p4d_bad(p4d_t p4d)
 {
-	if ((p4d_val(p4d) & _REGION_ENTRY_TYPE_MASK) < _REGION_ENTRY_TYPE_R2)
-		return pud_bad(__pud(p4d_val(p4d)));
+	unsigned long type = p4d_val(p4d) & _REGION_ENTRY_TYPE_MASK;
+
+	if (type > _REGION_ENTRY_TYPE_R2)
+		return 1;
+	if (type < _REGION_ENTRY_TYPE_R2)
+		return 0;
 	return (p4d_val(p4d) & ~_REGION_ENTRY_BITS) != 0;
 }
 
-- 
2.20.1



