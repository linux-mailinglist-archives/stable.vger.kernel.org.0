Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A5345275
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfFNDMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:12:50 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46585 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:12:50 -0400
Received: by mail-pg1-f196.google.com with SMTP id v9so654172pgr.13
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y6GazOWQm4IOOc6xrMbLHqM6mIdOvxmzg2BIOtMFGqg=;
        b=QEkL+VfUuFHaUPoZrhk6ZT7Pxpl8boNF2CaYbIXPqGr11CT0iqDp494FCeQ9FYUKy0
         k0ubcLU/OTtf72r0prvbE+Pdx5ECXxAEt8TO0W+6j10IaET7QsRQF7sgH6R/FLUnxZxW
         uG1aw0NYax+CHYI1AxUrR+v5etyy29g+yZJe0VgZ/t4zvTsQjLp33CRoLuMo0n3C1zk5
         O4oE8SuXkXi/ufe9/gZVe98tHnfBcXIOQIBlQaSAIvZrdxv0NJFhcKl/Wu/nmZyHU9sH
         U6OblEjWNokjRmkhk3t0y+3HeyI66oGIKcdBgZSypchbQ97DwMOm54PQqRX+uYwxEi4l
         JyNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y6GazOWQm4IOOc6xrMbLHqM6mIdOvxmzg2BIOtMFGqg=;
        b=EerC5hCjKiDXxcSEWi12Rc7Q738CmPP/Ur1eUMOeMQf9ypFAAk/rXmSWUs6OsA1oA9
         FZbpY9NVCD9IpPWy9ISLV3okOKvNO9ATCNZ45a1RD7OZeCpXw1chaWFBK7V4ZXC5afUr
         NXP5ubIR2MYhqRxid4LnoEUFl2zkyaXT9t4rm/EWiQjo+Kt6RDRi6IRKs/xQP8qQSYDQ
         4fMgbvBmK6AMTo2FskM10OlpHx68b1fSqNIpmd0xVAJ/AUcm1jbxf8IMuF1/6tbeJiRQ
         jA1BOWhQrB5alZff5DIQwBzfdX5dr8yG2NuBqKNbZESFkRVJJ24AXpEH6NLXnpooTqgG
         1B/Q==
X-Gm-Message-State: APjAAAXhmM6DP4Xutw0LYyiylx7HPQIhUfygQjp9l2PQHeJ6SSuIobxq
        K9V4qpak6hvMlIklShq3BFoG5w==
X-Google-Smtp-Source: APXvYqxgOUsWsAd7mcooKIc7Hwy2xtxuJhMAqB8tg9mPnQ/kvSAoroLa3roQCVI6rhoA9Gz4GxJ/Zg==
X-Received: by 2002:a65:42ca:: with SMTP id l10mr33032835pgp.181.1560481969628;
        Thu, 13 Jun 2019 20:12:49 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id s9sm1131106pjp.7.2019.06.13.20.12.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:12:49 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 21/45] arm64: entry: Apply BP hardening for high-priority synchronous exceptions
Date:   Fri, 14 Jun 2019 08:38:04 +0530
Message-Id: <342eec766d9748b0c9fb4a5da48220052a5426e6.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
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

