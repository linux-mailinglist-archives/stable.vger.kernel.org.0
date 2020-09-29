Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED9827C4A5
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbgI2LPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:15:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729503AbgI2LPc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:15:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C430208B8;
        Tue, 29 Sep 2020 11:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378132;
        bh=rQFtd9uni2xSkSA6SU4oZxNBYTMLlSBY9ce/IGPpjiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/7XYUd4yEdNQpS3L+t+0e1gUH5J7AqKiGeagMmSfNSPIrMXMNdb9YdOaz547NNK8
         6mOuY6MjTUd6ZxLDz42qU530EchXJQ/1PirXDJmM0ZspzroLaPszVhDv+sMqviPZwj
         66sxR44bd81l2AT1BIOfWH7sJJeUu7Pgq11dSrFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        James Hogan <jhogan@kernel.org>,
        James Morse <james.morse@arm.com>,
        Jerome Glisse <jglisse@redhat.com>,
        "Liang, Kan" <kan.liang@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Burton <paul.burton@mips.com>,
        Paul Mackerras <paulus@samba.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Will Deacon <will@kernel.org>, Zong Li <zong.li@sifive.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 055/166] mm: pagewalk: fix termination condition in walk_pte_range()
Date:   Tue, 29 Sep 2020 12:59:27 +0200
Message-Id: <20200929105937.961778440@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Price <steven.price@arm.com>

[ Upstream commit c02a98753e0a36ba65a05818626fa6adeb4e7c97 ]

If walk_pte_range() is called with a 'end' argument that is beyond the
last page of memory (e.g.  ~0UL) then the comparison between 'addr' and
'end' will always fail and the loop will be infinite.  Instead change the
comparison to >= while accounting for overflow.

Link: http://lkml.kernel.org/r/20191218162402.45610-15-steven.price@arm.com
Signed-off-by: Steven Price <steven.price@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Hogan <jhogan@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Liang, Kan" <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zong Li <zong.li@sifive.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/pagewalk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 23a3e415ac2ce..84bdb2bac3dc6 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -15,9 +15,9 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 		err = walk->pte_entry(pte, addr, addr + PAGE_SIZE, walk);
 		if (err)
 		       break;
-		addr += PAGE_SIZE;
-		if (addr == end)
+		if (addr >= end - PAGE_SIZE)
 			break;
+		addr += PAGE_SIZE;
 		pte++;
 	}
 
-- 
2.25.1



