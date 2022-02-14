Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762E14B4B06
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344721AbiBNKH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:07:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345322AbiBNKGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:06:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4679174630;
        Mon, 14 Feb 2022 01:49:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C148761284;
        Mon, 14 Feb 2022 09:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996D8C340E9;
        Mon, 14 Feb 2022 09:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832168;
        bh=3epFaGK+vhe/wOw2uqSsd6GvhL9Cvq9qJdaq6ifWC2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6WOvrnq3jkKNnPSHQEmKHYz+LebrnnDY6Afx5Uh8NYA51NwLb1oDEjJX3nBGPSlU
         Udy3+cRvDu2t1CAGFosUfq3ZehN6iasoUcl0H1yWle3GDzh2xPc6AAWTZXiac7w2Oq
         sMslRlLYzchA/H8Z33c+iqqlWvFiwHvLa6OKxLtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changbin Du <changbin.du@gmail.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 068/172] riscv: eliminate unreliable __builtin_frame_address(1)
Date:   Mon, 14 Feb 2022 10:25:26 +0100
Message-Id: <20220214092508.750772172@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changbin Du <changbin.du@gmail.com>

commit 6a00ef4493706a23120057fafbc62379bcde11ec upstream.

I tried different pieces of code which uses __builtin_frame_address(1)
(with both gcc version 7.5.0 and 10.3.0) to verify whether it works as
expected on riscv64. The result is negative.

What the compiler had generated is as below:
31                      fp = (unsigned long)__builtin_frame_address(1);
   0xffffffff80006024 <+200>:   ld      s1,0(s0)

It takes '0(s0)' as the address of frame 1 (caller), but the actual address
should be '-16(s0)'.

          |       ...       | <-+
          +-----------------+   |
          | return address  |   |
          | previous fp     |   |
          | saved registers |   |
          | local variables |   |
  $fp --> |       ...       |   |
          +-----------------+   |
          | return address  |   |
          | previous fp --------+
          | saved registers |
  $sp --> | local variables |
          +-----------------+

This leads the kernel can not dump the full stack trace on riscv.

[    7.222126][    T1] Call Trace:
[    7.222804][    T1] [<ffffffff80006058>] dump_backtrace+0x2c/0x3a

This problem is not exposed on most riscv builds just because the '0(s0)'
occasionally is the address frame 2 (caller's caller), if only ra and fp
are stored in frame 1 (caller).

          |       ...       | <-+
          +-----------------+   |
          | return address  |   |
  $fp --> | previous fp     |   |
          +-----------------+   |
          | return address  |   |
          | previous fp --------+
          | saved registers |
  $sp --> | local variables |
          +-----------------+

This could be a *bug* of gcc that should be fixed. But as noted in gcc
manual "Calling this function with a nonzero argument can have
unpredictable effects, including crashing the calling program.", let's
remove the '__builtin_frame_address(1)' in backtrace code.

With this fix now it can show full stack trace:
[   10.444838][    T1] Call Trace:
[   10.446199][    T1] [<ffffffff8000606c>] dump_backtrace+0x2c/0x3a
[   10.447711][    T1] [<ffffffff800060ac>] show_stack+0x32/0x3e
[   10.448710][    T1] [<ffffffff80a005c0>] dump_stack_lvl+0x58/0x7a
[   10.449941][    T1] [<ffffffff80a005f6>] dump_stack+0x14/0x1c
[   10.450929][    T1] [<ffffffff804c04ee>] ubsan_epilogue+0x10/0x5a
[   10.451869][    T1] [<ffffffff804c092e>] __ubsan_handle_load_invalid_value+0x6c/0x78
[   10.453049][    T1] [<ffffffff8018f834>] __pagevec_release+0x62/0x64
[   10.455476][    T1] [<ffffffff80190830>] truncate_inode_pages_range+0x132/0x5be
[   10.456798][    T1] [<ffffffff80190ce0>] truncate_inode_pages+0x24/0x30
[   10.457853][    T1] [<ffffffff8045bb04>] kill_bdev+0x32/0x3c
...

Signed-off-by: Changbin Du <changbin.du@gmail.com>
Fixes: eac2f3059e02 ("riscv: stacktrace: fix the riscv stacktrace when CONFIG_FRAME_POINTER enabled")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/stacktrace.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -22,15 +22,16 @@ void notrace walk_stackframe(struct task
 			     bool (*fn)(void *, unsigned long), void *arg)
 {
 	unsigned long fp, sp, pc;
+	int level = 0;
 
 	if (regs) {
 		fp = frame_pointer(regs);
 		sp = user_stack_pointer(regs);
 		pc = instruction_pointer(regs);
 	} else if (task == NULL || task == current) {
-		fp = (unsigned long)__builtin_frame_address(1);
-		sp = (unsigned long)__builtin_frame_address(0);
-		pc = (unsigned long)__builtin_return_address(0);
+		fp = (unsigned long)__builtin_frame_address(0);
+		sp = sp_in_global;
+		pc = (unsigned long)walk_stackframe;
 	} else {
 		/* task blocked in __switch_to */
 		fp = task->thread.s[0];
@@ -42,7 +43,7 @@ void notrace walk_stackframe(struct task
 		unsigned long low, high;
 		struct stackframe *frame;
 
-		if (unlikely(!__kernel_text_address(pc) || !fn(arg, pc)))
+		if (unlikely(!__kernel_text_address(pc) || (level++ >= 1 && !fn(arg, pc))))
 			break;
 
 		/* Validate frame pointer */


