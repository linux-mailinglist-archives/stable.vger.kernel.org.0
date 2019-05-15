Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF1E1F0A8
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbfEOLqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731995AbfEOLZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:25:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCB812084F;
        Wed, 15 May 2019 11:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919525;
        bh=EA6NedQph8PMX3qsnEJopeDYubZLnPwmefdEEmbJ5RY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2m/3vszLu1F1BTj0CtRo8Dny7Yct94igUq97KSK6xOKWo0RzcmTqXkssW6xWtGxG
         ZrXi2RGqwabCPlGNQmF9iNB40abPSNOeOmBc+eddgkRpGgN6gDaCZJgQvIINwoIP1g
         2C3XeiJFBsIKv5H7shFgBGBK4m//y2h+fHEKQZV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rick Lindsley <ricklind@vnet.linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 108/113] powerpc/book3s/64: check for NULL pointer in pgd_alloc()
Date:   Wed, 15 May 2019 12:56:39 +0200
Message-Id: <20190515090701.876183332@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rick Lindsley <ricklind@linux.vnet.ibm.com>

commit f39356261c265a0689d7ee568132d516e8b6cecc upstream.

When the memset code was added to pgd_alloc(), it failed to consider
that kmem_cache_alloc() can return NULL. It's uncommon, but not
impossible under heavy memory contention. Example oops:

  Unable to handle kernel paging request for data at address 0x00000000
  Faulting instruction address: 0xc0000000000a4000
  Oops: Kernel access of bad area, sig: 11 [#1]
  LE SMP NR_CPUS=2048 NUMA pSeries
  CPU: 70 PID: 48471 Comm: entrypoint.sh Kdump: loaded Not tainted 4.14.0-115.6.1.el7a.ppc64le #1
  task: c000000334a00000 task.stack: c000000331c00000
  NIP:  c0000000000a4000 LR: c00000000012f43c CTR: 0000000000000020
  REGS: c000000331c039c0 TRAP: 0300   Not tainted  (4.14.0-115.6.1.el7a.ppc64le)
  MSR:  800000010280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE,TM[E]>  CR: 44022840  XER: 20040000
  CFAR: c000000000008874 DAR: 0000000000000000 DSISR: 42000000 SOFTE: 1
  ...
  NIP [c0000000000a4000] memset+0x68/0x104
  LR [c00000000012f43c] mm_init+0x27c/0x2f0
  Call Trace:
    mm_init+0x260/0x2f0 (unreliable)
    copy_mm+0x11c/0x638
    copy_process.isra.28.part.29+0x6fc/0x1080
    _do_fork+0xdc/0x4c0
    ppc_clone+0x8/0xc
  Instruction dump:
  409e000c b0860000 38c60002 409d000c 90860000 38c60004 78a0d183 78a506a0
  7c0903a6 41820034 60000000 60420000 <f8860000> f8860008 f8860010 f8860018

Fixes: fc5c2f4a55a2 ("powerpc/mm/hash64: Zero PGD pages on allocation")
Cc: stable@vger.kernel.org # v4.16+
Signed-off-by: Rick Lindsley <ricklind@vnet.linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/book3s/64/pgalloc.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/include/asm/book3s/64/pgalloc.h
+++ b/arch/powerpc/include/asm/book3s/64/pgalloc.h
@@ -83,6 +83,9 @@ static inline pgd_t *pgd_alloc(struct mm
 
 	pgd = kmem_cache_alloc(PGT_CACHE(PGD_INDEX_SIZE),
 			       pgtable_gfp_flags(mm, GFP_KERNEL));
+	if (unlikely(!pgd))
+		return pgd;
+
 	/*
 	 * Don't scan the PGD for pointers, it contains references to PUDs but
 	 * those references are not full pointers and so can't be recognised by


