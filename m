Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1086E4F70BE
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239039AbiDGBW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240538AbiDGBUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:20:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F124818004E;
        Wed,  6 Apr 2022 18:18:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8707161DA4;
        Thu,  7 Apr 2022 01:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D615C385A3;
        Thu,  7 Apr 2022 01:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649294286;
        bh=ysIqWVHbnrXLFB5Xh0t302S4eTBVDG6PTJHJP26q2Po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loWJ6ay0faeVtZeeifjvBnw8PECJDCjHyxPon83H6GoLqqXvLDqIPbfwZhQmVT0CG
         Y5NNMiuN06En6ouLc+CoXSJGVOavdazHZmuKdjU4VLma6bhhwjSRvpcXXrZzodQ69M
         tykyF0SVanBMGM6INhhdbkOzMWoTWIRM+OJ4OssVaUnSthkm2gCl11HDtdxJqKC+y9
         hX5ZW6fiuqElvIH1xbOCRg03p7N1DqNkzE/DMnjIBXp230tofs9vwo8GDs58iXwqOl
         dlyogCpyt405VZE0FY1jYmgFzh1Bj8UtQ9qenCvbCLbd9URN0Ah1rwrvo4743bWi6d
         /Xbn/feRN8CsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linyujun <linyujun809@huawei.com>, He Ying <heying24@huawei.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        mhiramat@kernel.org, rostedt@goodmis.org, ast@kernel.org,
        ndesaulniers@google.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 7/7] ARM: 9191/1: arm/stacktrace, kasan: Silence KASAN warnings in unwind_frame()
Date:   Wed,  6 Apr 2022 21:17:40 -0400
Message-Id: <20220407011740.115717-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011740.115717-1-sashal@kernel.org>
References: <20220407011740.115717-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: linyujun <linyujun809@huawei.com>

[ Upstream commit 9be4c88bb7924f68f88cfd47d925c2d046f51a73 ]

The following KASAN warning is detected by QEMU.

==================================================================
BUG: KASAN: stack-out-of-bounds in unwind_frame+0x508/0x870
Read of size 4 at addr c36bba90 by task cat/163

CPU: 1 PID: 163 Comm: cat Not tainted 5.10.0-rc1 #40
Hardware name: ARM-Versatile Express
[<c0113fac>] (unwind_backtrace) from [<c010e71c>] (show_stack+0x10/0x14)
[<c010e71c>] (show_stack) from [<c0b805b4>] (dump_stack+0x98/0xb0)
[<c0b805b4>] (dump_stack) from [<c0b7d658>] (print_address_description.constprop.0+0x58/0x4bc)
[<c0b7d658>] (print_address_description.constprop.0) from [<c031435c>] (kasan_report+0x154/0x170)
[<c031435c>] (kasan_report) from [<c0113c44>] (unwind_frame+0x508/0x870)
[<c0113c44>] (unwind_frame) from [<c010e298>] (__save_stack_trace+0x110/0x134)
[<c010e298>] (__save_stack_trace) from [<c01ce0d8>] (stack_trace_save+0x8c/0xb4)
[<c01ce0d8>] (stack_trace_save) from [<c0313520>] (kasan_set_track+0x38/0x60)
[<c0313520>] (kasan_set_track) from [<c0314cb8>] (kasan_set_free_info+0x20/0x2c)
[<c0314cb8>] (kasan_set_free_info) from [<c0313474>] (__kasan_slab_free+0xec/0x120)
[<c0313474>] (__kasan_slab_free) from [<c0311e20>] (kmem_cache_free+0x7c/0x334)
[<c0311e20>] (kmem_cache_free) from [<c01c35dc>] (rcu_core+0x390/0xccc)
[<c01c35dc>] (rcu_core) from [<c01013a8>] (__do_softirq+0x180/0x518)
[<c01013a8>] (__do_softirq) from [<c0135214>] (irq_exit+0x9c/0xe0)
[<c0135214>] (irq_exit) from [<c01a40e4>] (__handle_domain_irq+0xb0/0x110)
[<c01a40e4>] (__handle_domain_irq) from [<c0691248>] (gic_handle_irq+0xa0/0xb8)
[<c0691248>] (gic_handle_irq) from [<c0100b0c>] (__irq_svc+0x6c/0x94)
Exception stack(0xc36bb928 to 0xc36bb970)
b920:                   c36bb9c0 00000000 c0126919 c0101228 c36bb9c0 b76d7730
b940: c36b8000 c36bb9a0 c3335b00 c01ce0d8 00000003 c36bba3c c36bb940 c36bb978
b960: c010e298 c011373c 60000013 ffffffff
[<c0100b0c>] (__irq_svc) from [<c011373c>] (unwind_frame+0x0/0x870)
[<c011373c>] (unwind_frame) from [<00000000>] (0x0)

The buggy address belongs to the page:
page:(ptrval) refcount:0 mapcount:0 mapping:00000000 index:0x0 pfn:0x636bb
flags: 0x0()
raw: 00000000 00000000 ef867764 00000000 00000000 00000000 ffffffff 00000000
page dumped because: kasan: bad access detected

addr c36bba90 is located in stack of task cat/163 at offset 48 in frame:
 stack_trace_save+0x0/0xb4

this frame has 1 object:
 [32, 48) 'trace'

Memory state around the buggy address:
 c36bb980: f1 f1 f1 f1 00 04 f2 f2 00 00 f3 f3 00 00 00 00
 c36bba00: 00 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1
>c36bba80: 00 00 f3 f3 00 00 00 00 00 00 00 00 00 00 00 00
                 ^
 c36bbb00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 c36bbb80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================

There is a same issue on x86 and has been resolved by the commit f7d27c35ddff
("x86/mm, kasan: Silence KASAN warnings in get_wchan()").
The solution could be applied to arm architecture too.

Signed-off-by: Lin Yujun <linyujun809@huawei.com>
Reported-by: He Ying <heying24@huawei.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/stacktrace.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index c10c1de244eb..83d0aa217bb2 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -50,17 +50,17 @@ int notrace unwind_frame(struct stackframe *frame)
 		return -EINVAL;
 
 	frame->sp = frame->fp;
-	frame->fp = *(unsigned long *)(fp);
-	frame->pc = *(unsigned long *)(fp + 4);
+	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
+	frame->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp + 4));
 #else
 	/* check current frame pointer is within bounds */
 	if (fp < low + 12 || fp > high - 4)
 		return -EINVAL;
 
 	/* restore the registers from the stack frame */
-	frame->fp = *(unsigned long *)(fp - 12);
-	frame->sp = *(unsigned long *)(fp - 8);
-	frame->pc = *(unsigned long *)(fp - 4);
+	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp - 12));
+	frame->sp = READ_ONCE_NOCHECK(*(unsigned long *)(fp - 8));
+	frame->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp - 4));
 #endif
 
 	return 0;
-- 
2.35.1

