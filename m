Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B517B34415E
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhCVMdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:33:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231461AbhCVMcJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:32:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BB58619AC;
        Mon, 22 Mar 2021 12:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416325;
        bh=B3PPLBDMOBIwY84Bxhkm1yXvgoUED/+sozaxtpbearc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2FGRodiiVKMnQZYLUtrgBPNE3iUgg5/d6jj1rKTvo3QpsqBYtbh40v3UytD2Ieec
         XpAFZW18x86+kW6FDjlIK5ddZ0XGMkSL9LZDrFO4mxd3w3jwCh/B+96+asIfbhQLuH
         cVwOMaUOveCF35HuNk63M9Hqx9oeipAg/IAJdy3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.11 062/120] RISC-V: Fix out-of-bounds accesses in init_resources()
Date:   Mon, 22 Mar 2021 13:27:25 +0100
Message-Id: <20210322121931.759944628@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit ce989f1472ae350e844b10c880b22543168fbc92 upstream.

init_resources() allocates an array of resources, based on the current
total number of memory regions and reserved memory regions.  However,
allocating this array using memblock_alloc() might increase the number
of reserved memory regions.  If that happens, populating the array later
based on the new number of regions will cause out-of-bounds writes
beyond the end of the allocated array.

Fix this by allocating one more entry, which may or may not be used.

Fixes: 797f0375dd2ef5cd ("RISC-V: Do not allocate memblock while iterating reserved memblocks")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Atish Patra <atish.patra@wdc.com>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/setup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -147,7 +147,8 @@ static void __init init_resources(void)
 	bss_res.end = __pa_symbol(__bss_stop) - 1;
 	bss_res.flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
 
-	mem_res_sz = (memblock.memory.cnt + memblock.reserved.cnt) * sizeof(*mem_res);
+	/* + 1 as memblock_alloc() might increase memblock.reserved.cnt */
+	mem_res_sz = (memblock.memory.cnt + memblock.reserved.cnt + 1) * sizeof(*mem_res);
 	mem_res = memblock_alloc(mem_res_sz, SMP_CACHE_BYTES);
 	if (!mem_res)
 		panic("%s: Failed to allocate %zu bytes\n", __func__, mem_res_sz);


