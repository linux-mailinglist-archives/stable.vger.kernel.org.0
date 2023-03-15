Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D466BB1C4
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbjCOMab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbjCOMaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:30:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AF49E308
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:29:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C245761D49
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7B1C433D2;
        Wed, 15 Mar 2023 12:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883348;
        bh=VDa2iA3x3gNL9r38PYyLXv+PQ/lB4NBYySWQrxKgyFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXfhW4Emml5Y5JZT2paO/kp36Jxoi+KhMXS7Yw/nSvlwR+2jd/fUlPnkj83JUxfTN
         ptM6K7FVgwWM89VlR7+JQdhPV/zO1Eg4zJ9JlaxGNBswrwn0C8nXJojYyTWxPkcmCb
         sEGXiZP8NLjj2D0Fb5vvEbkPj+I2wTp2zUgTUSkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Chathura Rajapaksha <chathura.abeyrathne.lk@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexandre Ghiti <alexghiti@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/145] riscv: Use READ_ONCE_NOCHECK in imprecise unwinding stack mode
Date:   Wed, 15 Mar 2023 13:12:25 +0100
Message-Id: <20230315115741.610150978@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit 76950340cf03b149412fe0d5f0810e52ac1df8cb ]

When CONFIG_FRAME_POINTER is unset, the stack unwinding function
walk_stackframe randomly reads the stack and then, when KASAN is enabled,
it can lead to the following backtrace:

[    0.000000] ==================================================================
[    0.000000] BUG: KASAN: stack-out-of-bounds in walk_stackframe+0xa6/0x11a
[    0.000000] Read of size 8 at addr ffffffff81807c40 by task swapper/0
[    0.000000]
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 6.2.0-12919-g24203e6db61f #43
[    0.000000] Hardware name: riscv-virtio,qemu (DT)
[    0.000000] Call Trace:
[    0.000000] [<ffffffff80007ba8>] walk_stackframe+0x0/0x11a
[    0.000000] [<ffffffff80099ecc>] init_param_lock+0x26/0x2a
[    0.000000] [<ffffffff80007c4a>] walk_stackframe+0xa2/0x11a
[    0.000000] [<ffffffff80c49c80>] dump_stack_lvl+0x22/0x36
[    0.000000] [<ffffffff80c3783e>] print_report+0x198/0x4a8
[    0.000000] [<ffffffff80099ecc>] init_param_lock+0x26/0x2a
[    0.000000] [<ffffffff80007c4a>] walk_stackframe+0xa2/0x11a
[    0.000000] [<ffffffff8015f68a>] kasan_report+0x9a/0xc8
[    0.000000] [<ffffffff80007c4a>] walk_stackframe+0xa2/0x11a
[    0.000000] [<ffffffff80007c4a>] walk_stackframe+0xa2/0x11a
[    0.000000] [<ffffffff8006e99c>] desc_make_final+0x80/0x84
[    0.000000] [<ffffffff8009a04e>] stack_trace_save+0x88/0xa6
[    0.000000] [<ffffffff80099fc2>] filter_irq_stacks+0x72/0x76
[    0.000000] [<ffffffff8006b95e>] devkmsg_read+0x32a/0x32e
[    0.000000] [<ffffffff8015ec16>] kasan_save_stack+0x28/0x52
[    0.000000] [<ffffffff8006e998>] desc_make_final+0x7c/0x84
[    0.000000] [<ffffffff8009a04a>] stack_trace_save+0x84/0xa6
[    0.000000] [<ffffffff8015ec52>] kasan_set_track+0x12/0x20
[    0.000000] [<ffffffff8015f22e>] __kasan_slab_alloc+0x58/0x5e
[    0.000000] [<ffffffff8015e7ea>] __kmem_cache_create+0x21e/0x39a
[    0.000000] [<ffffffff80e133ac>] create_boot_cache+0x70/0x9c
[    0.000000] [<ffffffff80e17ab2>] kmem_cache_init+0x6c/0x11e
[    0.000000] [<ffffffff80e00fd6>] mm_init+0xd8/0xfe
[    0.000000] [<ffffffff80e011d8>] start_kernel+0x190/0x3ca
[    0.000000]
[    0.000000] The buggy address belongs to stack of task swapper/0
[    0.000000]  and is located at offset 0 in frame:
[    0.000000]  stack_trace_save+0x0/0xa6
[    0.000000]
[    0.000000] This frame has 1 object:
[    0.000000]  [32, 56) 'c'
[    0.000000]
[    0.000000] The buggy address belongs to the physical page:
[    0.000000] page:(____ptrval____) refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x81a07
[    0.000000] flags: 0x1000(reserved|zone=0)
[    0.000000] raw: 0000000000001000 ff600003f1e3d150 ff600003f1e3d150 0000000000000000
[    0.000000] raw: 0000000000000000 0000000000000000 00000001ffffffff
[    0.000000] page dumped because: kasan: bad access detected
[    0.000000]
[    0.000000] Memory state around the buggy address:
[    0.000000]  ffffffff81807b00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]  ffffffff81807b80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000] >ffffffff81807c00: 00 00 00 00 00 00 00 00 f1 f1 f1 f1 00 00 00 f3
[    0.000000]                                            ^
[    0.000000]  ffffffff81807c80: f3 f3 f3 f3 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]  ffffffff81807d00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000] ==================================================================

Fix that by using READ_ONCE_NOCHECK when reading the stack in imprecise
mode.

Fixes: 5d8544e2d007 ("RISC-V: Generic library routines and assembly")
Reported-by: Chathura Rajapaksha <chathura.abeyrathne.lk@gmail.com>
Link: https://lore.kernel.org/all/CAD7mqryDQCYyJ1gAmtMm8SASMWAQ4i103ptTb0f6Oda=tPY2=A@mail.gmail.com/
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20230308091639.602024-1-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/stacktrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index ee8ef91c8aaf4..894ae66421a76 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -94,7 +94,7 @@ void notrace walk_stackframe(struct task_struct *task,
 	while (!kstack_end(ksp)) {
 		if (__kernel_text_address(pc) && unlikely(!fn(arg, pc)))
 			break;
-		pc = (*ksp++) - 0x4;
+		pc = READ_ONCE_NOCHECK(*ksp++) - 0x4;
 	}
 }
 
-- 
2.39.2



