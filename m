Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7693746B936
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 11:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhLGKiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 05:38:06 -0500
Received: from ns.iliad.fr ([212.27.33.1]:34688 "EHLO ns.iliad.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229449AbhLGKiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 05:38:05 -0500
Received: from ns.iliad.fr (localhost [127.0.0.1])
        by ns.iliad.fr (Postfix) with ESMTP id CCE651FFD9;
        Tue,  7 Dec 2021 11:34:34 +0100 (CET)
Received: from sakura (freebox.vlq16.iliad.fr [213.36.7.13])
        by ns.iliad.fr (Postfix) with ESMTP id BF3101FF88;
        Tue,  7 Dec 2021 11:34:34 +0100 (CET)
Message-ID: <12988dafdf7e14ba6db69ab483a2eb53e411fc0d.camel@freebox.fr>
Subject: Re: [PATCH] powerpc/603: Fix boot failure with DEBUG_PAGEALLOC and
 KFENCE
From:   Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Tue, 07 Dec 2021 11:34:34 +0100
In-Reply-To: <aea33b4813a26bdb9378b5f273f00bd5d4abe240.1638857364.git.christophe.leroy@csgroup.eu>
References: <aea33b4813a26bdb9378b5f273f00bd5d4abe240.1638857364.git.christophe.leroy@csgroup.eu>
Organization: Freebox
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: ClamAV using ClamSMTP ; ns.iliad.fr ; Tue Dec  7 11:34:34 2021 +0100 (CET)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Tue, 2021-12-07 at 06:10 +0000, Christophe Leroy wrote:

Hello,

With the patch applied and

CONFIG_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT=y
CONFIG_DEBUG_VM=y

I get tons of this during boot:

[    0.000000] Dentry cache hash table entries: 262144 (order: 8, 1048576 bytes, linear)
[    0.000000] Inode-cache hash table entries: 131072 (order: 7, 524288 bytes, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at arch/powerpc/mm/pgtable.c:194 set_pte_at+0x18/0x160
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.15.0+ #442
[    0.000000] NIP:  80015ebc LR: 80016728 CTR: 800166e4
[    0.000000] REGS: 80751dd0 TRAP: 0700   Not tainted  (5.15.0+)
[    0.000000] MSR:  00021032 <ME,IR,DR,RI>  CR: 42228882  XER: 20000000
[    0.000000] 
[    0.000000] GPR00: 800b8dc8 80751e80 806c6300 807311d8 807a1000 8ffffe84 80751ea8 00000000 
[    0.000000] GPR08: 007a1591 00000001 007a1180 00000000 42224882 00000000 3ff9c608 3fffd79c 
[    0.000000] GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 800166e4 807a2000 
[    0.000000] GPR24: 807a1fff 807311d8 807311d8 807a2000 80768804 00000000 807a1000 007a1180 
[    0.000000] NIP [80015ebc] set_pte_at+0x18/0x160
[    0.000000] LR [80016728] set_page_attr+0x44/0xc0
[    0.000000] Call Trace:
[    0.000000] [80751e80] [80058570] console_unlock+0x340/0x428 (unreliable)
[    0.000000] [80751ea0] [00000000] 0x0
[    0.000000] [80751ec0] [800b8dc8] __apply_to_page_range+0x144/0x2a8
[    0.000000] [80751f00] [80016918] __kernel_map_pages+0x54/0x64
[    0.000000] [80751f10] [800cfeb0] __free_pages_ok+0x1b0/0x440
[    0.000000] [80751f50] [805cfc8c] memblock_free_all+0x1d8/0x274
[    0.000000] [80751f90] [805c5e0c] mem_init+0x3c/0xd0
[    0.000000] [80751fb0] [805c0bdc] start_kernel+0x404/0x5c4
[    0.000000] [80751ff0] [000033f0] 0x33f0
[    0.000000] Instruction dump:
[    0.000000] 7c630034 83e1000c 5463d97e 7c0803a6 38210010 4e800020 9421ffe0 93e1001c 
[    0.000000] 83e60000 81250000 71290001 41820014 <0fe00000> 7c0802a6 93c10018 90010024 


-- 
Maxime



