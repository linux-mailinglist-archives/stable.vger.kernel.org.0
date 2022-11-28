Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87EC63B08B
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbiK1RxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbiK1RuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:50:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27172ED69;
        Mon, 28 Nov 2022 09:43:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6652DB80E9F;
        Mon, 28 Nov 2022 17:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2AEC4347C;
        Mon, 28 Nov 2022 17:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657410;
        bh=+5GGC/8eufWXSVnOGBvw3X8yB+l1PO1V+/FGgW8gFtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SWJHqDSw4erVSA9QC2FTkfU83IR79QQmph+qwIzyMpmSYuox4oTp/6LX9nv7T9NuI
         uyooqkDnBzeA5gmAX+iANVfz7nc5+LQBBkGzcbrAJDXcc95cyFMht9Gcoc++8NxLg7
         2jSxSrYNlGmxbQ/wYREpkbLk4hfaZ2YQJggaMYGX2+hej2nnkku0kldXMebRcEc3sW
         Y4V8iNIZczpgKOIvpjn0BLmafrHKxObtWFmpYd1kmqqwjex0tIie3cXGrEkza7Lt/D
         DAF96Yc9gGZOSvjyXORRX9N5h9J8XzCRUDzW0J1G03ZXzRoySmRJm/F9msrY/Lvn9G
         N7c13aDtTDSTg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomislav Novak <tnovak@fb.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>, will@kernel.org,
        mark.rutland@arm.com, peterz@infradead.org, mingo@redhat.com,
        acme@kernel.org, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/5] ARM: 9251/1: perf: Fix stacktraces for tracepoint events in THUMB2 kernels
Date:   Mon, 28 Nov 2022 12:43:21 -0500
Message-Id: <20221128174324.1443132-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174324.1443132-1-sashal@kernel.org>
References: <20221128174324.1443132-1-sashal@kernel.org>
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
index 4f9dec489931..c5d27140834e 100644
--- a/arch/arm/include/asm/perf_event.h
+++ b/arch/arm/include/asm/perf_event.h
@@ -21,7 +21,7 @@ extern unsigned long perf_misc_flags(struct pt_regs *regs);
 
 #define perf_arch_fetch_caller_regs(regs, __ip) { \
 	(regs)->ARM_pc = (__ip); \
-	(regs)->ARM_fp = (unsigned long) __builtin_frame_address(0); \
+	frame_pointer((regs)) = (unsigned long) __builtin_frame_address(0); \
 	(regs)->ARM_sp = current_stack_pointer; \
 	(regs)->ARM_cpsr = SVC_MODE; \
 }
-- 
2.35.1

