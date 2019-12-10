Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7986F11962C
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbfLJVZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:25:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728544AbfLJVKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75431246A3;
        Tue, 10 Dec 2019 21:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012235;
        bh=vS8aMU79NzeSQmkyeMPXtxzGfCOBO5VOntSCYux0bfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j5PI2NYW31A4bp+bSV6GmldLs6MLuNM3ib014J/oN1Z0wbqVDHd2Y2VVyvQvKzBIN
         fYYcD5sKjSsWvXhz9rX037ldSTopGCeCMSPt/Bt2tmGZDBNpidxvUGgbCbWnOg2TqI
         o4qwbhTs7vBvDLPya5HlNEBRIqSUooA3ivCU+g3k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 184/350] s390/mm: add mm_pxd_folded() checks to pxd_free()
Date:   Tue, 10 Dec 2019 16:04:49 -0500
Message-Id: <20191210210735.9077-145-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

[ Upstream commit 2416cefc504ba8ae9b17e3e6b40afc72708f96be ]

Unlike pxd_free_tlb(), the pxd_free() functions do not check for folded
page tables. This is not an issue so far, as those functions will actually
never be called, since no code will reach them when page tables are folded.

In order to avoid future issues, and to make the s390 code more similar to
other architectures, add mm_pxd_folded() checks, similar to how it is done
in pxd_free_tlb().

This was found by testing a patch from from Anshuman Khandual, which is
currently discussed on LKML ("mm/debug: Add tests validating architecture
page table helpers").

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/pgalloc.h | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/pgalloc.h b/arch/s390/include/asm/pgalloc.h
index bccb8f4a63e20..77606c4acd58d 100644
--- a/arch/s390/include/asm/pgalloc.h
+++ b/arch/s390/include/asm/pgalloc.h
@@ -56,7 +56,12 @@ static inline p4d_t *p4d_alloc_one(struct mm_struct *mm, unsigned long address)
 		crst_table_init(table, _REGION2_ENTRY_EMPTY);
 	return (p4d_t *) table;
 }
-#define p4d_free(mm, p4d) crst_table_free(mm, (unsigned long *) p4d)
+
+static inline void p4d_free(struct mm_struct *mm, p4d_t *p4d)
+{
+	if (!mm_p4d_folded(mm))
+		crst_table_free(mm, (unsigned long *) p4d);
+}
 
 static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long address)
 {
@@ -65,7 +70,12 @@ static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long address)
 		crst_table_init(table, _REGION3_ENTRY_EMPTY);
 	return (pud_t *) table;
 }
-#define pud_free(mm, pud) crst_table_free(mm, (unsigned long *) pud)
+
+static inline void pud_free(struct mm_struct *mm, pud_t *pud)
+{
+	if (!mm_pud_folded(mm))
+		crst_table_free(mm, (unsigned long *) pud);
+}
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long vmaddr)
 {
@@ -83,6 +93,8 @@ static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long vmaddr)
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
+	if (mm_pmd_folded(mm))
+		return;
 	pgtable_pmd_page_dtor(virt_to_page(pmd));
 	crst_table_free(mm, (unsigned long *) pmd);
 }
-- 
2.20.1

