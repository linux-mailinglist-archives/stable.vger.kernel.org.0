Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2BEA440D4
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfFMQJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:09:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731258AbfFMIoP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:44:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D125E20851;
        Thu, 13 Jun 2019 08:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415455;
        bh=TjV3RwwWRZ1gCM6lQIitVpUg75zrgZi1QDrGyCoKdYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PrgboXWFGLYiUwFY5Lq4DlrXrez9aTbtHxmv8F6CpFcXOdWBSMGl1A9Q5C3aYKdBq
         LJiGOtAxdfKRYIlVA3bRHzwLM/BGGSRMMKNNo7ORPq+pdWlQiIlK+9zpf2w52PmxNy
         GQum0uKukqBHWyEQ0ee4JgkxYXFO3zvb5VJ4xfGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Song Liu <liu.song.a23@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 010/155] mm/mprotect.c: fix compilation warning because of unused mm variable
Date:   Thu, 13 Jun 2019 10:32:02 +0200
Message-Id: <20190613075653.320914667@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 94393c78964c432917014e3a456fa15c3e78f741 ]

Since 0cbe3e26abe0 ("mm: update ptep_modify_prot_start/commit to take
vm_area_struct as arg") the only place that uses the local 'mm' variable
in change_pte_range() is the call to set_pte_at().

Many architectures define set_pte_at() as macro that does not use the 'mm'
parameter, which generates the following compilation warning:

 CC      mm/mprotect.o
mm/mprotect.c: In function 'change_pte_range':
mm/mprotect.c:42:20: warning: unused variable 'mm' [-Wunused-variable]
  struct mm_struct *mm = vma->vm_mm;
                    ^~

Fix it by passing vma->mm to set_pte_at() and dropping the local 'mm'
variable in change_pte_range().

[liu.song.a23@gmail.com: fix missed conversions]
  Link: http://lkml.kernel.org/r/CAPhsuW6wcQgYLHNdBdw6m0YiR4RWsS4XzfpSKU7wBLLeOCTbpw@mail.gmail.comLink: http://lkml.kernel.org/r/1557305432-4940-1-git-send-email-rppt@linux.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Song Liu <liu.song.a23@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mprotect.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 028c724dcb1a..ab40f3d04aa3 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -39,7 +39,6 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		int dirty_accountable, int prot_numa)
 {
-	struct mm_struct *mm = vma->vm_mm;
 	pte_t *pte, oldpte;
 	spinlock_t *ptl;
 	unsigned long pages = 0;
@@ -136,7 +135,7 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 				newpte = swp_entry_to_pte(entry);
 				if (pte_swp_soft_dirty(oldpte))
 					newpte = pte_swp_mksoft_dirty(newpte);
-				set_pte_at(mm, addr, pte, newpte);
+				set_pte_at(vma->vm_mm, addr, pte, newpte);
 
 				pages++;
 			}
@@ -150,7 +149,7 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 				 */
 				make_device_private_entry_read(&entry);
 				newpte = swp_entry_to_pte(entry);
-				set_pte_at(mm, addr, pte, newpte);
+				set_pte_at(vma->vm_mm, addr, pte, newpte);
 
 				pages++;
 			}
-- 
2.20.1



