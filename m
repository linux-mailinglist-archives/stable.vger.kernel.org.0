Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9BE63AFAF
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbiK1RoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbiK1Rnj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:43:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4272B615;
        Mon, 28 Nov 2022 09:40:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D00EB80EA0;
        Mon, 28 Nov 2022 17:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5894BC4347C;
        Mon, 28 Nov 2022 17:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657244;
        bh=3dvlsZ0crK7vigTaS1T23MKHxpBSClQQPfxLSsv+Jmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVJigLq4i2A0zU2dCC0J943U0ClBB1jncmik9TVSsVjq3h3tv7zeALdCDo4xIiSzD
         nkT5sKzYuSpyD8/gNiXAqjHLTmuMJEaY+xfWZNma1/ivbqiI1H/H4xLdzlLsAoQaWR
         nnev6/Y37TIlGXqbwOZIxItW5uNK0LPQzyWoaFRE3mkG9dIdHO6CDdU+7Ljrz8ZsbR
         o9zYlFw1dg7MI3Unjf7Ia/sHZmMXPJ3o6JZi+kr/98KTItj73RQUM081XQy1zWCuqg
         U+z7fZ/DB8CBeetZaZIT3+QCeIErz2hjKLLZ5wjreK6cTllfL0P/Ok4tzytvUWX7pC
         MZJKQgZsOA5ug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomislav Novak <tnovak@fb.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org, will@kernel.org,
        mark.rutland@arm.com, linux@armlinux.org.uk,
        linux-perf-users@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 08/24] ARM: 9251/1: perf: Fix stacktraces for tracepoint events in THUMB2 kernels
Date:   Mon, 28 Nov 2022 12:40:08 -0500
Message-Id: <20221128174027.1441921-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174027.1441921-1-sashal@kernel.org>
References: <20221128174027.1441921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomislav Novak <tnovak@fb.com>

[ Upstream commit 612695bccfdbd52004551308a55bae410e7cd22f ]

Store the frame address where arm_get_current_stackframe() looks for it
(ARM_r7 instead of ARM_fp if CONFIG_THUMB2_KERNEL=y). Otherwise frame->fp
gets set to 0, causing unwind_frame() to fail.

  # bpftrace -e 't:sched:sched_switch { @[kstack] = count(); exit(); }'
  Attaching 1 probe...
  @[
      __schedule+1059
  ]: 1

A typical first unwind instruction is 0x97 (SP = R7), so after executing
it SP ends up being 0 and -URC_FAILURE is returned.

  unwind_frame(pc = ac9da7d7 lr = 00000000 sp = c69bdda0 fp = 00000000)
  unwind_find_idx(ac9da7d7)
  unwind_exec_insn: insn = 00000097
  unwind_exec_insn: fp = 00000000 sp = 00000000 lr = 00000000 pc = 00000000

With this patch:

  # bpftrace -e 't:sched:sched_switch { @[kstack] = count(); exit(); }'
  Attaching 1 probe...
  @[
      __schedule+1059
      __schedule+1059
      schedule+79
      schedule_hrtimeout_range_clock+163
      schedule_hrtimeout_range+17
      ep_poll+471
      SyS_epoll_wait+111
      sys_epoll_pwait+231
      __ret_fast_syscall+1
  ]: 1

Link: https://lore.kernel.org/r/20220920230728.2617421-1-tnovak@fb.com/

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Tomislav Novak <tnovak@fb.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/perf_event.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/perf_event.h b/arch/arm/include/asm/perf_event.h
index fe87397c3d8c..bdbc1e590891 100644
--- a/arch/arm/include/asm/perf_event.h
+++ b/arch/arm/include/asm/perf_event.h
@@ -17,7 +17,7 @@ extern unsigned long perf_misc_flags(struct pt_regs *regs);
 
 #define perf_arch_fetch_caller_regs(regs, __ip) { \
 	(regs)->ARM_pc = (__ip); \
-	(regs)->ARM_fp = (unsigned long) __builtin_frame_address(0); \
+	frame_pointer((regs)) = (unsigned long) __builtin_frame_address(0); \
 	(regs)->ARM_sp = current_stack_pointer; \
 	(regs)->ARM_cpsr = SVC_MODE; \
 }
-- 
2.35.1

