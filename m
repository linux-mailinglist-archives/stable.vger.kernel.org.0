Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289C6593510
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbiHOSTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233479AbiHOSSZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:18:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947282B279;
        Mon, 15 Aug 2022 11:16:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E676B8106C;
        Mon, 15 Aug 2022 18:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9093EC433C1;
        Mon, 15 Aug 2022 18:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587360;
        bh=h2a++vB7rUxdHLPrp5od/YYDptU4FG5vuzzKULCmoS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUln6dXNOR3sp6RKvoLLBPcX9/8ufaNcNi7VvniOExxqI/G3x7nKsJV4Fnd92mjz+
         OV7x8MhgDJjKcCKb2Ny556rWrwet1B3hh2Vj+YUdGBe7/hBAwIOac3xZoJIud6MxSf
         DYpsed7RGjuVh513iVe7uNr8EoPx6NA/uJhGdz0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yipeng Zou <zouyipeng@huawei.com>,
        Guo Ren <guoren@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 053/779] riscv:uprobe fix SR_SPIE set/clear handling
Date:   Mon, 15 Aug 2022 19:54:57 +0200
Message-Id: <20220815180339.528971437@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Yipeng Zou <zouyipeng@huawei.com>

commit 3dbe5829408bc1586f75b4667ef60e5aab0209c7 upstream.

In riscv the process of uprobe going to clear spie before exec
the origin insn,and set spie after that.But When access the page
which origin insn has been placed a page fault may happen and
irq was disabled in arch_uprobe_pre_xol function,It cause a WARN
as follows.
There is no need to clear/set spie in arch_uprobe_pre/post/abort_xol.
We can just remove it.

[   31.684157] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1488
[   31.684677] in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 76, name: work
[   31.684929] preempt_count: 0, expected: 0
[   31.685969] CPU: 2 PID: 76 Comm: work Tainted: G
[   31.686542] Hardware name: riscv-virtio,qemu (DT)
[   31.686797] Call Trace:
[   31.687053] [<ffffffff80006442>] dump_backtrace+0x30/0x38
[   31.687699] [<ffffffff80812118>] show_stack+0x40/0x4c
[   31.688141] [<ffffffff8081817a>] dump_stack_lvl+0x44/0x5c
[   31.688396] [<ffffffff808181aa>] dump_stack+0x18/0x20
[   31.688653] [<ffffffff8003e454>] __might_resched+0x114/0x122
[   31.688948] [<ffffffff8003e4b2>] __might_sleep+0x50/0x7a
[   31.689435] [<ffffffff80822676>] down_read+0x30/0x130
[   31.689728] [<ffffffff8000b650>] do_page_fault+0x166/x446
[   31.689997] [<ffffffff80003c0c>] ret_from_exception+0x0/0xc

Fixes: 74784081aac8 ("riscv: Add uprobes supported")
Signed-off-by: Yipeng Zou <zouyipeng@huawei.com>
Reviewed-by: Guo Ren <guoren@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220721065820.245755-1-zouyipeng@huawei.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/probes/uprobes.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/arch/riscv/kernel/probes/uprobes.c
+++ b/arch/riscv/kernel/probes/uprobes.c
@@ -59,8 +59,6 @@ int arch_uprobe_pre_xol(struct arch_upro
 
 	instruction_pointer_set(regs, utask->xol_vaddr);
 
-	regs->status &= ~SR_SPIE;
-
 	return 0;
 }
 
@@ -72,8 +70,6 @@ int arch_uprobe_post_xol(struct arch_upr
 
 	instruction_pointer_set(regs, utask->vaddr + auprobe->insn_size);
 
-	regs->status |= SR_SPIE;
-
 	return 0;
 }
 
@@ -111,8 +107,6 @@ void arch_uprobe_abort_xol(struct arch_u
 	 * address.
 	 */
 	instruction_pointer_set(regs, utask->vaddr);
-
-	regs->status &= ~SR_SPIE;
 }
 
 bool arch_uretprobe_is_alive(struct return_instance *ret, enum rp_check ctx,


