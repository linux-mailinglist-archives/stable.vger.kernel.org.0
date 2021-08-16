Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FFC3ED571
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239556AbhHPNL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239199AbhHPNJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:09:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5741E610A1;
        Mon, 16 Aug 2021 13:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119346;
        bh=cmouDnjztEyz9OYzaUb+gAvvGR/ElZXxMDAvkLgME+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lpVirunSCZQs6SKvIo3tzCa2jZ4eNw7JW8t6vW7U33W7UAIZ61e5x1t05Z1tjqhxM
         /cBoHrJloaWQHOU9DNZsXZOvPSmerInlAFrk2zLS9d19s66uJlmuL3EmBWTvO6plZ2
         0K4d/QU1mJBsKwquRBmCiTDI/Hiy9jSM+qu9pGho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 87/96] powerpc/smp: Fix OOPS in topology_init()
Date:   Mon, 16 Aug 2021 15:02:37 +0200
Message-Id: <20210816125437.889387283@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 8241461536f21bbe51308a6916d1c9fb2e6b75a7 upstream.

Running an SMP kernel on an UP platform not prepared for it,
I encountered the following OOPS:

	BUG: Kernel NULL pointer dereference on read at 0x00000034
	Faulting instruction address: 0xc0a04110
	Oops: Kernel access of bad area, sig: 11 [#1]
	BE PAGE_SIZE=4K SMP NR_CPUS=2 CMPCPRO
	Modules linked in:
	CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-pmac-00001-g230fedfaad21 #5234
	NIP:  c0a04110 LR: c0a040d8 CTR: c0a04084
	REGS: e100dda0 TRAP: 0300   Not tainted  (5.13.0-pmac-00001-g230fedfaad21)
	MSR:  00009032 <EE,ME,IR,DR,RI>  CR: 84000284  XER: 00000000
	DAR: 00000034 DSISR: 20000000
	GPR00: c0006bd4 e100de60 c1033320 00000000 00000000 c0942274 00000000 00000000
	GPR08: 00000000 00000000 00000001 00000063 00000007 00000000 c0006f30 00000000
	GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000005
	GPR24: c0c67d74 c0c67f1c c0c60000 c0c67d70 c0c0c558 1efdf000 c0c00020 00000000
	NIP [c0a04110] topology_init+0x8c/0x138
	LR [c0a040d8] topology_init+0x54/0x138
	Call Trace:
	[e100de60] [80808080] 0x80808080 (unreliable)
	[e100de90] [c0006bd4] do_one_initcall+0x48/0x1bc
	[e100def0] [c0a0150c] kernel_init_freeable+0x1c8/0x278
	[e100df20] [c0006f44] kernel_init+0x14/0x10c
	[e100df30] [c00190fc] ret_from_kernel_thread+0x14/0x1c
	Instruction dump:
	7c692e70 7d290194 7c035040 7c7f1b78 5529103a 546706fe 5468103a 39400001
	7c641b78 40800054 80c690b4 7fb9402e <81060034> 7fbeea14 2c080000 7fa3eb78
	---[ end trace b246ffbc6bbbb6fb ]---

Fix it by checking smp_ops before using it, as already done in
several other places in the arch/powerpc/kernel/smp.c

Fixes: 39f87561454d ("powerpc/smp: Move ppc_md.cpu_die() to smp_ops.cpu_offline_self()")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/75287841cbb8740edd44880fe60be66d489160d9.1628097995.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -1167,7 +1167,7 @@ static int __init topology_init(void)
 		 * CPU.  For instance, the boot cpu might never be valid
 		 * for hotplugging.
 		 */
-		if (smp_ops->cpu_offline_self)
+		if (smp_ops && smp_ops->cpu_offline_self)
 			c->hotpluggable = 1;
 #endif
 


