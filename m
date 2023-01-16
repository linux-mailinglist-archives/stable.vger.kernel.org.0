Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9F966C92A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbjAPQqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbjAPQqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:46:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65DA20072
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:34:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C1AEB81059
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDA5C433F1;
        Mon, 16 Jan 2023 16:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886841;
        bh=PM38UjOKKpOEm2DbdrMdYf+3cqOvcVm91RTVTgHpOzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0QRRSLKnZIsQ4S4ZbOOtPw1jNOUX+uVKkYXVmMc0roDMeGF/Ll1p4IYM3iL+Pikj4
         7ailwSJQEJcM8iCTs0bCykEAkXPNJobOzlEZ2QYxceP/Oey0i45y5nozLwFVGP6Ua6
         DwdFmuYw0xKJIB8FJeBAJ4J3OG09FsnqqtkAEVQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Huang <chenhuang5@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 553/658] riscv/stacktrace: Fix stack output without ra on the stack top
Date:   Mon, 16 Jan 2023 16:50:41 +0100
Message-Id: <20230116154934.813121238@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Huang <chenhuang5@huawei.com>

[ Upstream commit f766f77a74f5784d8d4d3c36b1900731f97d08d0 ]

When a function doesn't have a callee, then it will not
push ra into the stack, such as lkdtm_BUG() function,

addi	sp,sp,-16
sd	s0,8(sp)
addi	s0,sp,16
ebreak

The struct stackframe use {fp,ra} to get information from
stack, if walk_stackframe() with pr_regs, we will obtain
wrong value and bad stacktrace,

[<ffffffe00066c56c>] lkdtm_BUG+0x6/0x8
---[ end trace 18da3fbdf08e25d5 ]---

Correct the next fp and pc, after that, full stacktrace
shown as expects,

[<ffffffe00066c56c>] lkdtm_BUG+0x6/0x8
[<ffffffe0008b24a4>] lkdtm_do_action+0x14/0x1c
[<ffffffe00066c372>] direct_entry+0xc0/0x10a
[<ffffffe000439f86>] full_proxy_write+0x42/0x6a
[<ffffffe000309626>] vfs_write+0x7e/0x214
[<ffffffe00030992a>] ksys_write+0x98/0xc0
[<ffffffe000309960>] sys_write+0xe/0x16
[<ffffffe0002014bc>] ret_from_syscall+0x0/0x2
---[ end trace 61917f3d9a9fadcd ]---

Signed-off-by: Chen Huang <chenhuang5@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Stable-dep-of: 5c3022e4a616 ("riscv: stacktrace: Fixup ftrace_graph_ret_addr retp argument")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/stacktrace.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 19e46f4160cc..1a512a24879e 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -55,9 +55,15 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 		/* Unwind stack frame */
 		frame = (struct stackframe *)fp - 1;
 		sp = fp;
-		fp = frame->fp;
-		pc = ftrace_graph_ret_addr(current, NULL, frame->ra,
-					   (unsigned long *)(fp - 8));
+		if (regs && (regs->epc == pc) && (frame->fp & 0x7)) {
+			fp = frame->ra;
+			pc = regs->ra;
+		} else {
+			fp = frame->fp;
+			pc = ftrace_graph_ret_addr(current, NULL, frame->ra,
+						   (unsigned long *)(fp - 8));
+		}
+
 	}
 }
 
-- 
2.35.1



