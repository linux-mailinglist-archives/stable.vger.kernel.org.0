Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC94BDEA9
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 11:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfD2JIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 05:08:13 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:26295 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727072AbfD2JIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 05:08:12 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 44szMn4n1dz9v17r;
        Mon, 29 Apr 2019 11:08:05 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=j6+5GTXY; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id LqzIKKeKLX-I; Mon, 29 Apr 2019 11:08:05 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 44szMn3kNLz9v16q;
        Mon, 29 Apr 2019 11:08:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1556528885; bh=wPADqUqD8mDw+pQQQH/8169RzAM7f9xUN6V+5LlCT/c=;
        h=From:Subject:To:Cc:Date:From;
        b=j6+5GTXYdzVYlCc188ch1qPmnKg0dOewpFavjxZMtB0PIYE6jCLcEZ9S3H4fnyy7I
         CZKgdb3VZ4lAnPpPuJP5EUiHvyoUjdZ0GQOmEJX06ALEjLzDRHD4a6BWV/RE7tH3nq
         r9BLTXQpsqeGBDvVKupP1k3NLZvSg5tr8RCGcLDU=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 32A958B8AA;
        Mon, 29 Apr 2019 11:08:10 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id JDSUbMBhw-PR; Mon, 29 Apr 2019 11:08:10 +0200 (CEST)
Received: from po16846vm.idsi0.si.c-s.fr (po15451.idsi0.si.c-s.fr [172.25.231.6])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 0DE4D8B8A8;
        Mon, 29 Apr 2019 11:08:10 +0200 (CEST)
Received: by po16846vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id A1F7C666FE; Mon, 29 Apr 2019 09:08:09 +0000 (UTC)
Message-Id: <3a21c6f19637847e6ed080186a834ede619f3849.1556528569.git.christophe.leroy@c-s.fr>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH] powerpc/32s: fix BATs setting with CONFIG_STRICT_KERNEL_RWX
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org
Date:   Mon, 29 Apr 2019 09:08:09 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Serge reported some crashes with CONFIG_STRICT_KERNEL_RWX enabled
on a book3s32 machine.

Analysis shows two issues:
- BATs addresses and sizes are not properly aligned.
- There is a gap between the last address covered by BATs and the
first address covered by pages.

Memory mapped with DBATs:
0: 0xc0000000-0xc07fffff 0x00000000 Kernel RO coherent
1: 0xc0800000-0xc0bfffff 0x00800000 Kernel RO coherent
2: 0xc0c00000-0xc13fffff 0x00c00000 Kernel RW coherent
3: 0xc1400000-0xc23fffff 0x01400000 Kernel RW coherent
4: 0xc2400000-0xc43fffff 0x02400000 Kernel RW coherent
5: 0xc4400000-0xc83fffff 0x04400000 Kernel RW coherent
6: 0xc8400000-0xd03fffff 0x08400000 Kernel RW coherent
7: 0xd0400000-0xe03fffff 0x10400000 Kernel RW coherent

Memory mapped with pages:
0xe1000000-0xefffffff  0x21000000       240M        rw       present           dirty  accessed

This patch fixes both issues. With the patch, we get the following
which is as expected:

Memory mapped with DBATs:
0: 0xc0000000-0xc07fffff 0x00000000 Kernel RO coherent
1: 0xc0800000-0xc0bfffff 0x00800000 Kernel RO coherent
2: 0xc0c00000-0xc0ffffff 0x00c00000 Kernel RW coherent
3: 0xc1000000-0xc1ffffff 0x01000000 Kernel RW coherent
4: 0xc2000000-0xc3ffffff 0x02000000 Kernel RW coherent
5: 0xc4000000-0xc7ffffff 0x04000000 Kernel RW coherent
6: 0xc8000000-0xcfffffff 0x08000000 Kernel RW coherent
7: 0xd0000000-0xdfffffff 0x10000000 Kernel RW coherent

Memory mapped with pages:
0xe0000000-0xefffffff  0x20000000       256M        rw       present           dirty  accessed

Reported-by: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Fixes: 63b2bc619565 ("powerpc/mm/32s: Use BATs for STRICT_KERNEL_RWX")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 arch/powerpc/mm/ppc_mmu_32.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/mm/ppc_mmu_32.c b/arch/powerpc/mm/ppc_mmu_32.c
index bf1de3ca39bc..37cf2af98f6a 100644
--- a/arch/powerpc/mm/ppc_mmu_32.c
+++ b/arch/powerpc/mm/ppc_mmu_32.c
@@ -101,7 +101,7 @@ static int find_free_bat(void)
 static unsigned int block_size(unsigned long base, unsigned long top)
 {
 	unsigned int max_size = (cpu_has_feature(CPU_FTR_601) ? 8 : 256) << 20;
-	unsigned int base_shift = (fls(base) - 1) & 31;
+	unsigned int base_shift = (ffs(base) - 1) & 31;
 	unsigned int block_shift = (fls(top - base) - 1) & 31;
 
 	return min3(max_size, 1U << base_shift, 1U << block_shift);
@@ -157,7 +157,7 @@ static unsigned long __init __mmu_mapin_ram(unsigned long base, unsigned long to
 
 unsigned long __init mmu_mapin_ram(unsigned long base, unsigned long top)
 {
-	int done;
+	unsigned long done;
 	unsigned long border = (unsigned long)__init_begin - PAGE_OFFSET;
 
 	if (__map_without_bats) {
@@ -169,10 +169,10 @@ unsigned long __init mmu_mapin_ram(unsigned long base, unsigned long top)
 		return __mmu_mapin_ram(base, top);
 
 	done = __mmu_mapin_ram(base, border);
-	if (done != border - base)
+	if (done != border)
 		return done;
 
-	return done + __mmu_mapin_ram(border, top);
+	return __mmu_mapin_ram(border, top);
 }
 
 void mmu_mark_initmem_nx(void)
-- 
2.13.3

