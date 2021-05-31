Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE253962CC
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbhEaPBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:01:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234415AbhEaO7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:59:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A05E61CCD;
        Mon, 31 May 2021 14:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469688;
        bh=4qXZ2einf5GN12tl0tqR1ye5qFWcOfPzB/Hy2JnwWQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i07xmE+5RwXrLO+luOk4+WsAq43jGxqK1AjvFBFCHnFe/VnKaRXJGOvOlHrgMgwE/
         TfiIkuSQv0+3LsKygw8EVgLwu/8oMmsSKljLdPBdKqJiOTUQvopO9fsMH18IDIK1qp
         6CRf3rq/QAewDP7VgobJWO4vB9z+y61YMzHPmI1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marco Elver <elver@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.12 294/296] arm64: mm: dont use CON and BLK mapping if KFENCE is enabled
Date:   Mon, 31 May 2021 15:15:49 +0200
Message-Id: <20210531130713.591611715@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

commit e69012400b0cb42b2070748322cb72f9effec00f upstream.

When we added KFENCE support for arm64, we intended that it would
force the entire linear map to be mapped at page granularity, but we
only enforced this in arch_add_memory() and not in map_mem(), so
memory mapped at boot time can be mapped at a larger granularity.

When booting a kernel with KFENCE=y and RODATA_FULL=n, this results in
the following WARNING at boot:

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at mm/memory.c:2462 apply_to_pmd_range+0xec/0x190
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.13.0-rc1+ #10
[    0.000000] Hardware name: linux,dummy-virt (DT)
[    0.000000] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO BTYPE=--)
[    0.000000] pc : apply_to_pmd_range+0xec/0x190
[    0.000000] lr : __apply_to_page_range+0x94/0x170
[    0.000000] sp : ffffffc010573e20
[    0.000000] x29: ffffffc010573e20 x28: ffffff801f400000 x27: ffffff801f401000
[    0.000000] x26: 0000000000000001 x25: ffffff801f400fff x24: ffffffc010573f28
[    0.000000] x23: ffffffc01002b710 x22: ffffffc0105fa450 x21: ffffffc010573ee4
[    0.000000] x20: ffffff801fffb7d0 x19: ffffff801f401000 x18: 00000000fffffffe
[    0.000000] x17: 000000000000003f x16: 000000000000000a x15: ffffffc01060b940
[    0.000000] x14: 0000000000000000 x13: 0098968000000000 x12: 0000000098968000
[    0.000000] x11: 0000000000000000 x10: 0000000098968000 x9 : 0000000000000001
[    0.000000] x8 : 0000000000000000 x7 : ffffffc010573ee4 x6 : 0000000000000001
[    0.000000] x5 : ffffffc010573f28 x4 : ffffffc01002b710 x3 : 0000000040000000
[    0.000000] x2 : ffffff801f5fffff x1 : 0000000000000001 x0 : 007800005f400705
[    0.000000] Call trace:
[    0.000000]  apply_to_pmd_range+0xec/0x190
[    0.000000]  __apply_to_page_range+0x94/0x170
[    0.000000]  apply_to_page_range+0x10/0x20
[    0.000000]  __change_memory_common+0x50/0xdc
[    0.000000]  set_memory_valid+0x30/0x40
[    0.000000]  kfence_init_pool+0x9c/0x16c
[    0.000000]  kfence_init+0x20/0x98
[    0.000000]  start_kernel+0x284/0x3f8

Fixes: 840b23986344 ("arm64, kfence: enable KFENCE for ARM64")
Cc: <stable@vger.kernel.org> # 5.12.x
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Marco Elver <elver@google.com>
Tested-by: Marco Elver <elver@google.com>
Link: https://lore.kernel.org/r/20210525104551.2ec37f77@xhacker.debian
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/mm/mmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -492,7 +492,8 @@ static void __init map_mem(pgd_t *pgdp)
 	int flags = 0;
 	u64 i;
 
-	if (rodata_full || crash_mem_map || debug_pagealloc_enabled())
+	if (rodata_full || crash_mem_map || debug_pagealloc_enabled() ||
+	    IS_ENABLED(CONFIG_KFENCE))
 		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	/*


