Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAD92010CD
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404622AbgFSPeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:34:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404763AbgFSPdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:33:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A817C20786;
        Fri, 19 Jun 2020 15:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580779;
        bh=52hVFjVhLh2OoAw3LAR/P2MpsdMw6E97K8yE7KBRUrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7cwfrHukGXiS+VpD0wZRwG1g+KlR3uxu44kAeKQF8rFpOf31qI0eitsG+yA1UV6v
         1AHqy3t7Wpigngwh5hfVE/etWTZNBxUqpFbilYKeil8d9zFJUwgvflTFWV7wbEpurr
         DKRR/AC4aPgI+DzEfR+LUtowMJdaR8XNyisYl1Lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anup Patel <anup.patel@wdc.com>,
        Zong Li <zong.li@sifive.com>,
        Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.7 349/376] RISC-V: Dont mark init section as non-executable
Date:   Fri, 19 Jun 2020 16:34:27 +0200
Message-Id: <20200619141726.847148265@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anup Patel <anup.patel@wdc.com>

commit 4e0f9e3a6104261f25b16fcab02fc96f5666ba11 upstream.

The head text section (i.e. _start, secondary_start_sbi, etc) and the
init section fall under same page table level-1 mapping.

Currently, the runtime CPU hotplug is broken because we are marking
init section as non-executable which in-turn marks head text section
as non-executable.

Further investigating other architectures, it seems marking the init
section as non-executable is redundant because the init section pages
are anyway poisoned and freed.

To fix broken runtime CPU hotplug, we simply remove the code marking
the init section as non-executable.

Fixes: d27c3c90817e ("riscv: add STRICT_KERNEL_RWX support")
Cc: stable@vger.kernel.org
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/riscv/mm/init.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -479,17 +479,6 @@ static void __init setup_vm_final(void)
 	csr_write(CSR_SATP, PFN_DOWN(__pa_symbol(swapper_pg_dir)) | SATP_MODE);
 	local_flush_tlb_all();
 }
-
-void free_initmem(void)
-{
-	unsigned long init_begin = (unsigned long)__init_begin;
-	unsigned long init_end = (unsigned long)__init_end;
-
-	/* Make the region as non-execuatble. */
-	set_memory_nx(init_begin, (init_end - init_begin) >> PAGE_SHIFT);
-	free_initmem_default(POISON_FREE_INITMEM);
-}
-
 #else
 asmlinkage void __init setup_vm(uintptr_t dtb_pa)
 {


