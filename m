Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 079602F5A8
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbfE3EtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:49:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727669AbfE3DLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:14 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 271ED244A0;
        Thu, 30 May 2019 03:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185874;
        bh=ZnKmzH2d36q/ebULNOmESAOuV8j+Oxu0N0V/yWvpEL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pw53CBt9YKPtL/I56ZGfztDLl22s3oQyQADqgveaq+ETDbdMRaUHdxUm1wmu3m9aF
         W0JD7TdmWy9E0OtIe6x9R5svlNC1UO1VJaPOqrlkAoXbWhRKFFruF21F/WhGlEo6jN
         5AVozNzwLH420vvAppClBlVwHIGPbppucZ/tQFZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 218/405] s390/mm: silence compiler warning when compiling without CONFIG_PGSTE
Date:   Wed, 29 May 2019 20:03:36 -0700
Message-Id: <20190530030552.107241744@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 81a8f2beb32a5951ecf04385301f50879abc092b ]

If CONFIG_PGSTE is not set (e.g. when compiling without KVM), GCC complains:

  CC      arch/s390/mm/pgtable.o
arch/s390/mm/pgtable.c:413:15: warning: ‘pmd_alloc_map’ defined but not
 used [-Wunused-function]
 static pmd_t *pmd_alloc_map(struct mm_struct *mm, unsigned long addr)
               ^~~~~~~~~~~~~

Wrap the function with "#ifdef CONFIG_PGSTE" to silence the warning.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/pgtable.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 8485d6dc27549..9ebd01219812c 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -410,6 +410,7 @@ static inline pmd_t pmdp_flush_lazy(struct mm_struct *mm,
 	return old;
 }
 
+#ifdef CONFIG_PGSTE
 static pmd_t *pmd_alloc_map(struct mm_struct *mm, unsigned long addr)
 {
 	pgd_t *pgd;
@@ -427,6 +428,7 @@ static pmd_t *pmd_alloc_map(struct mm_struct *mm, unsigned long addr)
 	pmd = pmd_alloc(mm, pud, addr);
 	return pmd;
 }
+#endif
 
 pmd_t pmdp_xchg_direct(struct mm_struct *mm, unsigned long addr,
 		       pmd_t *pmdp, pmd_t new)
-- 
2.20.1



