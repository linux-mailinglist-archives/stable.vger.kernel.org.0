Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D23C1CD687
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731375AbfJFRml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728607AbfJFRml (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:42:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A54D2087E;
        Sun,  6 Oct 2019 17:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383760;
        bh=krP95kJpB0a0xTJ3F8JGhh+MB+OwJOuNWiIa/d8ubwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZIux8tvqDxGTtVhy+UXj5wMkivSySMB26HDTEet+f0nAq6aS1bgWaMGTln4MROX/
         58JlPNF+SOYSgxWxGJmVqHeeZngkS2QGp0a5dSVJPKOOpHD3pF0yIX3ACNV/f9Olyi
         kwd5SKmM5nMmVRN9UVIpNZumcklA9lZzX5Nnx9ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 041/166] powerpc/ptdump: fix walk_pagetables() address mismatch
Date:   Sun,  6 Oct 2019 19:20:07 +0200
Message-Id: <20191006171216.397435417@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit e033829d2aaad85cb7cf46986c3be0bcc72f791e ]

walk_pagetables() always walk the entire pgdir from address 0
but considers PAGE_OFFSET or KERN_VIRT_START as the starting
address of the walk, resulting in a possible mismatch in the
displayed addresses.

Ex: on PPC32, when KERN_VIRT_START was locally defined as
PAGE_OFFSET, ptdump displayed 0x80000000
instead of 0xc0000000 for the first kernel page,
because 0xc0000000 + 0xc0000000 = 0x80000000

Start the walk at st->start_address instead of starting at 0.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/5aa2ac513295f594cce8ddb1c649f61947bd063d.1565786091.git.christophe.leroy@c-s.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/ptdump/ptdump.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/mm/ptdump/ptdump.c b/arch/powerpc/mm/ptdump/ptdump.c
index 6a88a9f585d4f..5d6111a9ee0e7 100644
--- a/arch/powerpc/mm/ptdump/ptdump.c
+++ b/arch/powerpc/mm/ptdump/ptdump.c
@@ -299,17 +299,15 @@ static void walk_pud(struct pg_state *st, pgd_t *pgd, unsigned long start)
 
 static void walk_pagetables(struct pg_state *st)
 {
-	pgd_t *pgd = pgd_offset_k(0UL);
 	unsigned int i;
-	unsigned long addr;
-
-	addr = st->start_address;
+	unsigned long addr = st->start_address & PGDIR_MASK;
+	pgd_t *pgd = pgd_offset_k(addr);
 
 	/*
 	 * Traverse the linux pagetable structure and dump pages that are in
 	 * the hash pagetable.
 	 */
-	for (i = 0; i < PTRS_PER_PGD; i++, pgd++, addr += PGDIR_SIZE) {
+	for (i = pgd_index(addr); i < PTRS_PER_PGD; i++, pgd++, addr += PGDIR_SIZE) {
 		if (!pgd_none(*pgd) && !pgd_is_leaf(*pgd))
 			/* pgd exists */
 			walk_pud(st, pgd, addr);
-- 
2.20.1



