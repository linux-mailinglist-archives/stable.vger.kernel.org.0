Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD953C55BF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344546AbhGLILv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353905AbhGLIDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1EFF619C6;
        Mon, 12 Jul 2021 07:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076710;
        bh=dMg6KAf+oT4T/aAm9bAjPnt6VcNj+RntmRJ1eJwzwLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LLXj36bqFEXM4R/+Zp3UcrlhQMwJmoaIOSRjNEaWlBWb3HqsuJb8NNonB8oKATGf/
         RQZZG4D6bOv2B+s9eJrQF+zXTBAdhodQhuH2tyKjGlXx+pFs5EzVQ11bJxK8kcVD8e
         56Ex3YcrvW0Pi+wH43QhRnbsRt9xM+zeB3oLgrnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachin Sant <sachinp@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 761/800] powerpc/64s: fix hash page fault interrupt handler
Date:   Mon, 12 Jul 2021 08:13:04 +0200
Message-Id: <20210712061047.766762337@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 5567b1ee29b7a83e8c01d99d34b5bbd306ce0bcf ]

The early bad fault or key fault test in do_hash_fault() ends up calling
into ___do_page_fault without having gone through an interrupt handler
wrapper (except the initial _RAW one). This can end up calling local irq
functions while the interrupt has not been reconciled, which will likely
cause crashes and it trips up on a later patch that adds more assertions.

pkey_exec_prot from selftests causes this path to be executed.

There is no real reason to run the in_nmi() test should be performed
before the key fault check. In fact if a perf interrupt in the hash
fault code did a stack walk that was made to take a key fault somehow
then running ___do_page_fault could possibly cause another hash fault
causing problems. Move the in_nmi() test first, and then do everything
else inside the regular interrupt handler function.

Fixes: 3a96570ffceb ("powerpc: convert interrupt handlers to use wrappers")
Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Tested-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210630074621.2109197-2-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s64/hash_utils.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
index 96d9aa164007..ac5720371c0d 100644
--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -1522,8 +1522,8 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap,
 }
 EXPORT_SYMBOL_GPL(hash_page);
 
-DECLARE_INTERRUPT_HANDLER_RET(__do_hash_fault);
-DEFINE_INTERRUPT_HANDLER_RET(__do_hash_fault)
+DECLARE_INTERRUPT_HANDLER(__do_hash_fault);
+DEFINE_INTERRUPT_HANDLER(__do_hash_fault)
 {
 	unsigned long ea = regs->dar;
 	unsigned long dsisr = regs->dsisr;
@@ -1533,6 +1533,11 @@ DEFINE_INTERRUPT_HANDLER_RET(__do_hash_fault)
 	unsigned int region_id;
 	long err;
 
+	if (unlikely(dsisr & (DSISR_BAD_FAULT_64S | DSISR_KEYFAULT))) {
+		hash__do_page_fault(regs);
+		return;
+	}
+
 	region_id = get_region_id(ea);
 	if ((region_id == VMALLOC_REGION_ID) || (region_id == IO_REGION_ID))
 		mm = &init_mm;
@@ -1571,9 +1576,10 @@ DEFINE_INTERRUPT_HANDLER_RET(__do_hash_fault)
 			bad_page_fault(regs, SIGBUS);
 		}
 		err = 0;
-	}
 
-	return err;
+	} else if (err) {
+		hash__do_page_fault(regs);
+	}
 }
 
 /*
@@ -1582,13 +1588,6 @@ DEFINE_INTERRUPT_HANDLER_RET(__do_hash_fault)
  */
 DEFINE_INTERRUPT_HANDLER_RAW(do_hash_fault)
 {
-	unsigned long dsisr = regs->dsisr;
-
-	if (unlikely(dsisr & (DSISR_BAD_FAULT_64S | DSISR_KEYFAULT))) {
-		hash__do_page_fault(regs);
-		return 0;
-	}
-
 	/*
 	 * If we are in an "NMI" (e.g., an interrupt when soft-disabled), then
 	 * don't call hash_page, just fail the fault. This is required to
@@ -1607,8 +1606,7 @@ DEFINE_INTERRUPT_HANDLER_RAW(do_hash_fault)
 		return 0;
 	}
 
-	if (__do_hash_fault(regs))
-		hash__do_page_fault(regs);
+	__do_hash_fault(regs);
 
 	return 0;
 }
-- 
2.30.2



