Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCFBD259F
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387929AbfJJJBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 05:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388296AbfJJIlT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:41:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A28F521D7A;
        Thu, 10 Oct 2019 08:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696879;
        bh=CGfWLHfDS5/I7M2lr6cE4KD8mzrZscQTZT50x3qj0yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1WhQgIj/1bwX9FidizXpkT1B9+DAsRsQXdhu1RoGzF50eUyxcUecdGvnbkv7o5Jc/
         iNBJ78IPEL02VDzIIN8BhHAOPx5xDbuuA9US3fm/Dycyn+JNk00Pc+2p4eYsbF2OUo
         uCpa2yYXB+mFQ+6u4NPUaoDPi1uhTX2OtGZYWM/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Erhard F." <erhard_f@mailbox.org>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.3 031/148] powerpc/kasan: Fix shadow area set up for modules.
Date:   Thu, 10 Oct 2019 10:34:52 +0200
Message-Id: <20191010083613.034078157@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 663c0c9496a69f80011205ba3194049bcafd681d upstream.

When loading modules, from time to time an Oops is encountered during
the init of shadow area for globals. This is due to the last page not
always being mapped depending on the exact distance between the start
and the end of the shadow area and the alignment with the page
addresses.

Fix this by aligning the starting address with the page address.

Fixes: 2edb16efc899 ("powerpc/32: Add KASAN support")
Cc: stable@vger.kernel.org # v5.2+
Reported-by: Erhard F. <erhard_f@mailbox.org>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/4f887e9b77d0d725cbb52035c7ece485c1c5fc14.1565361881.git.christophe.leroy@c-s.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/kasan/kasan_init_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/kasan/kasan_init_32.c
+++ b/arch/powerpc/mm/kasan/kasan_init_32.c
@@ -87,7 +87,7 @@ static int __ref kasan_init_region(void
 	if (!slab_is_available())
 		block = memblock_alloc(k_end - k_start, PAGE_SIZE);
 
-	for (k_cur = k_start; k_cur < k_end; k_cur += PAGE_SIZE) {
+	for (k_cur = k_start & PAGE_MASK; k_cur < k_end; k_cur += PAGE_SIZE) {
 		pmd_t *pmd = pmd_offset(pud_offset(pgd_offset_k(k_cur), k_cur), k_cur);
 		void *va = block ? block + k_cur - k_start : kasan_get_one_page();
 		pte_t pte = pfn_pte(PHYS_PFN(__pa(va)), PAGE_KERNEL);


