Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7FC9E123
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731143AbfH0IDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:03:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730013AbfH0IDW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:03:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3319F206BA;
        Tue, 27 Aug 2019 08:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893001;
        bh=QNmRNzZmyi9W7wx0iZIIn90kNrAJVSPD2Uik0FqlGRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xh5yw2f67XobJzGR4nafUeMPOwzIwOLRcn0vqJMHafatMAOXMPNgaSepb20cWbIUH
         tzF54zUocwqlDOieqdsFpBhLq/gMRytLJfOhyXSPa1yAWn5+CYwBtcj1a4PyzUSstb
         JM9nSgiDQsiGmu0uc7XvmkEgQVFuT7xcZLTzm4rU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 086/162] s390/mm: fix dump_pagetables top level page table walking
Date:   Tue, 27 Aug 2019 09:50:14 +0200
Message-Id: <20190827072741.134664210@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8024b5a9fc2bed9a00f0bdba60b443fa3cc4bb5d ]

Since commit d1874a0c2805 ("s390/mm: make the pxd_offset functions more
robust") behaviour of p4d_offset, pud_offset and pmd_offset has been
changed so that they cannot be used to iterate through top level page
table, because the index for the top level page table is now calculated
in pgd_offset. To avoid dumping the very first region/segment top level
table entry 2048 times simply iterate entry pointer like it is already
done in other page walking cases.

Fixes: d1874a0c2805 ("s390/mm: make the pxd_offset functions more robust")
Reported-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/dump_pagetables.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/s390/mm/dump_pagetables.c b/arch/s390/mm/dump_pagetables.c
index 3b93ba0b5d8d6..5d67b81c704a4 100644
--- a/arch/s390/mm/dump_pagetables.c
+++ b/arch/s390/mm/dump_pagetables.c
@@ -161,9 +161,9 @@ static void walk_pmd_level(struct seq_file *m, struct pg_state *st,
 	}
 #endif
 
-	for (i = 0; i < PTRS_PER_PMD && addr < max_addr; i++) {
+	pmd = pmd_offset(pud, addr);
+	for (i = 0; i < PTRS_PER_PMD && addr < max_addr; i++, pmd++) {
 		st->current_address = addr;
-		pmd = pmd_offset(pud, addr);
 		if (!pmd_none(*pmd)) {
 			if (pmd_large(*pmd)) {
 				prot = pmd_val(*pmd) &
@@ -192,9 +192,9 @@ static void walk_pud_level(struct seq_file *m, struct pg_state *st,
 	}
 #endif
 
-	for (i = 0; i < PTRS_PER_PUD && addr < max_addr; i++) {
+	pud = pud_offset(p4d, addr);
+	for (i = 0; i < PTRS_PER_PUD && addr < max_addr; i++, pud++) {
 		st->current_address = addr;
-		pud = pud_offset(p4d, addr);
 		if (!pud_none(*pud))
 			if (pud_large(*pud)) {
 				prot = pud_val(*pud) &
@@ -222,9 +222,9 @@ static void walk_p4d_level(struct seq_file *m, struct pg_state *st,
 	}
 #endif
 
-	for (i = 0; i < PTRS_PER_P4D && addr < max_addr; i++) {
+	p4d = p4d_offset(pgd, addr);
+	for (i = 0; i < PTRS_PER_P4D && addr < max_addr; i++, p4d++) {
 		st->current_address = addr;
-		p4d = p4d_offset(pgd, addr);
 		if (!p4d_none(*p4d))
 			walk_pud_level(m, st, p4d, addr);
 		else
-- 
2.20.1



