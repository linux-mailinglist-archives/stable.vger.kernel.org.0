Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE191E2C8E
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404315AbgEZTP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:15:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404596AbgEZTP5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:15:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DFF0208B3;
        Tue, 26 May 2020 19:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520556;
        bh=8EHIuE6iYwokYmh63YQ56iTYoT3GD4uGo80Ycpl/vbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNWetRJgnzAwhULPOOHFxPXjsB36ZkuOBOIQ/4B2TQUATDZ3Pniftk6ibgvDMBYNU
         VnyZHD6JPiI5hvLddsjgsCIcwkOvEvFxVkg2o5iqiMAYwqUMELSJutMeD9UHS7uoPu
         iHSx8aPgyGEq9jpUiadCSr3LIsgBA7H4A8DS8V9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Anatoly Pugachev <matorola@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.6 112/126] sparc32: fix page table traversal in srmmu_nocache_init()
Date:   Tue, 26 May 2020 20:54:09 +0200
Message-Id: <20200526183946.948924707@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit 0cfc8a8d70dcd51db783e8e87917e02149c71458 upstream.

The srmmu_nocache_init() uses __nocache_fix() macro to add an offset to
page table entry to access srmmu_nocache_pool.

But since sparc32 has only three actual page table levels, pgd, p4d and
pud are essentially the same thing and pgd_offset() and p4d_offset() are
no-ops, the __nocache_fix() should be done only at PUD level.

Remove __nocache_fix() for p4d_offset() and pud_offset() and keep it
only for PUD and lower levels.

Fixes: c2bc26f7ca1f ("sparc32: use PUD rather than PGD to get PMD in srmmu_nocache_init()")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Anatoly Pugachev <matorola@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sparc/mm/srmmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -331,8 +331,8 @@ static void __init srmmu_nocache_init(vo
 
 	while (vaddr < srmmu_nocache_end) {
 		pgd = pgd_offset_k(vaddr);
-		p4d = p4d_offset(__nocache_fix(pgd), vaddr);
-		pud = pud_offset(__nocache_fix(p4d), vaddr);
+		p4d = p4d_offset(pgd, vaddr);
+		pud = pud_offset(p4d, vaddr);
 		pmd = pmd_offset(__nocache_fix(pud), vaddr);
 		pte = pte_offset_kernel(__nocache_fix(pmd), vaddr);
 


