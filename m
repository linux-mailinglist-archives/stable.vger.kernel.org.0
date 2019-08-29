Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F213EA18D7
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfH2LgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:36:06 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34935 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727421AbfH2LgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:36:05 -0400
Received: by mail-pl1-f194.google.com with SMTP id gn20so1458748plb.2
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y6GazOWQm4IOOc6xrMbLHqM6mIdOvxmzg2BIOtMFGqg=;
        b=LyNvyEL50rTrdkIjipcrLCUtIh4hp0sPiDDZNm2ss9LdOgbQO2Z5KQJOoEpkvAXgJp
         2QpodfuPyGGaNRQadqdv3j4PfCLK26hknY1obYrHuUurdxwNueTidXsjcit+3hLKtwUU
         YJlmFFKYU1L5PDFxZLaGsjkMsWjdNOHI9EBneFPah8x5LtE4AejBca8qWlYGVNSlThKx
         ni6xB0phzYbDpMgrCZkMABWszq7FpzhMhJTOv8FHHzGtpsLIE82jHJ+YifCYESWcpIRk
         l6ayd71M7UMDayZrv68qBPQeQtbsYENCskRHqqVefLjRudwLeNUS4vpNxFHaYW0av0Wo
         zolQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y6GazOWQm4IOOc6xrMbLHqM6mIdOvxmzg2BIOtMFGqg=;
        b=kRtPlZ2Aa6PfAr8CU4Z1D9/+yIvA6XecVDp4iPP5pl6QAy0ZoA6ZomIvh1e0ypLXjC
         ScDRH0zMesd4UacAQGf9Y6EeGpyoTsF2wRJGjMb0Gl2TYVb6Sbpuv4GBPXx69guaXGZQ
         ZDbermqOGww+x9CHPJjkg2yF1xwY+0UViVJ/TXgrm2GoAwtkSuxolq7K0AZT+A3HAjwF
         9yypXFyb95MqPSMxmFguCZMjCJVBl/5HY4faRythqYUOzT7ruOsh1gSdQhWryBFGnTw6
         w+uPiLFhm/Tzjbv3L1ShnDZlEzLhhXspicW5zzj9xx+gvJjLfFmx6EE0VyP5lpwSJvU7
         hniw==
X-Gm-Message-State: APjAAAVbAPEYTxAjtzXc50yXn7Mqw+MPXBJCDQQl2mxgu8DiVdc/n5YC
        /bX+ycrduNDJYshnYGQdVrq10oOPnDo=
X-Google-Smtp-Source: APXvYqylU6VlJeIPHMWviGMFk9YcyO6Wnq/64uLquncZiKttj/4gMdRzMRgHYQuDzEEIjF7963d3Tw==
X-Received: by 2002:a17:902:fa5:: with SMTP id 34mr9509568plz.285.1567078564877;
        Thu, 29 Aug 2019 04:36:04 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id 4sm3138639pfe.76.2019.08.29.04.36.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:36:04 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH ARM64 v4.4 V3 27/44] arm64: entry: Apply BP hardening for high-priority synchronous exceptions
Date:   Thu, 29 Aug 2019 17:04:12 +0530
Message-Id: <711165f3d8dce609dfb777b3705fe1b58ca237cf.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 5dfc6ed27710c42cbc15db5c0d4475699991da0a upstream.

Software-step and PC alignment fault exceptions have higher priority than
instruction abort exceptions, so apply the BP hardening hooks there too
if the user PC appears to reside in kernel space.

Reported-by: Dan Hettena <dhettena@nvidia.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: Resolved rebase conflicts ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/kernel/entry.S | 6 ++++--
 arch/arm64/mm/fault.c     | 9 +++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 05bfc71639fc..42a141f01f3b 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -530,8 +530,10 @@ ENDPROC(el1_irq)
 	 * Stack or PC alignment exception handling
 	 */
 	mrs	x26, far_el1
-	// enable interrupts before calling the main handler
-	enable_dbg_and_irq
+	enable_dbg
+#ifdef CONFIG_TRACE_IRQFLAGS
+	bl	trace_hardirqs_off
+#endif
 	ct_user_exit
 	mov	x0, x26
 	mov	x1, x25
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 1878c881a247..082f385b6592 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -561,6 +561,12 @@ asmlinkage void __exception do_sp_pc_abort(unsigned long addr,
 	struct siginfo info;
 	struct task_struct *tsk = current;
 
+	if (user_mode(regs)) {
+		if (instruction_pointer(regs) > TASK_SIZE)
+			arm64_apply_bp_hardening();
+		local_irq_enable();
+	}
+
 	if (show_unhandled_signals && unhandled_signal(tsk, SIGBUS))
 		pr_info_ratelimited("%s[%d]: %s exception: pc=%p sp=%p\n",
 				    tsk->comm, task_pid_nr(tsk),
@@ -621,6 +627,9 @@ asmlinkage int __exception do_debug_exception(unsigned long addr_if_watchpoint,
 	if (interrupts_enabled(regs))
 		trace_hardirqs_off();
 
+	if (user_mode(regs) && instruction_pointer(regs) > TASK_SIZE)
+		arm64_apply_bp_hardening();
+
 	if (!inf->fn(addr_if_watchpoint, esr, regs)) {
 		rv = 1;
 	} else {
-- 
2.21.0.rc0.269.g1a574e7a288b

