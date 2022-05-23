Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD22A531808
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239637AbiEWRJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239653AbiEWRJO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:09:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB2D4E3AB;
        Mon, 23 May 2022 10:08:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD13A614DF;
        Mon, 23 May 2022 17:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F58C385A9;
        Mon, 23 May 2022 17:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325698;
        bh=SeSmQ+uLUyNgWxEtfTN/t7TMP/onjGdHY1SS7jcAxtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQrMDBfw93o3iuv/trYk1pS6QEw7ELapGed5PAgvSDxO0lSPEZ2UzymKL+N/7a8Gh
         f4sG4x1XtxVZ/+E2WD9EpANm/e4AdaCv41tFzLkT7ZxVreUfQaDyY2Yh69Bp3LBhAF
         XBLnd7c81S8D6kj/ex/TrDIQOLh0fFSgJyPM7lFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Yujun <linyujun809@huawei.com>,
        He Ying <heying24@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/33] ARM: 9191/1: arm/stacktrace, kasan: Silence KASAN warnings in unwind_frame()
Date:   Mon, 23 May 2022 19:04:56 +0200
Message-Id: <20220523165748.407749252@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165746.957506211@linuxfoundation.org>
References: <20220523165746.957506211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 31af81d46aae..21c49d3559db 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -51,17 +51,17 @@ int notrace unwind_frame(struct stackframe *frame)
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



