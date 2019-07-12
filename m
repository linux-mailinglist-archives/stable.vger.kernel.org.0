Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAC06663E
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfGLFaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:30:11 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35628 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLFaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:30:10 -0400
Received: by mail-pg1-f194.google.com with SMTP id s27so4015177pgl.2
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y6GazOWQm4IOOc6xrMbLHqM6mIdOvxmzg2BIOtMFGqg=;
        b=OLl7bCKkpQB7HHEvi5BkF9G+nxhlHneSx/wcuVyx88Sh/2izv53KLpprn3OrcBdfxf
         rNFg7nrxIOlioyjKCxApisfUbELSBwZr8FRiz6ewJdbT5hEqRNMDqiss40SoU3mVFwRE
         c7SHuTjanEBu6AvXHj5GaCr7Io8wfrkPSE4NMD+LYrslHYcbLWIxj33eLl1x2SHE9Rzg
         RspIACQBzsDAu1P66ipaqShi11/DUXGPE+snfgWs+qLy9xumg4gra08TS7YU5fmNVtyc
         /Hqz4YLE9XVKKW6iAj9x8RrphBBu5/8GHIGeo8zNwQswhWG/JdJGSfLa9kEfhisnk4g5
         sCIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y6GazOWQm4IOOc6xrMbLHqM6mIdOvxmzg2BIOtMFGqg=;
        b=cTunBfv/xazw1aG+Gy9lB/cQIm+xdx81SJArSDwpg0DqKTOAT4yhi12H0ImAvw72mj
         sAbAr6mMXfAzqvRUdXyk5Rka+ltMIKJHzZuKIL59NwwrmkqH8A/TbFihIT7Trny0oiGN
         EzF/ecIzgd+dbL1B/9DZ9gXp4VIcxh+E9wqueYn8ruP+yHxG+5rJfyNNvkO4L64avBu3
         yF0TswGZ2LSd8SZcmNcsoL+9IKuXXo8heLMqBHjPRBKxqQECdwRXvHbBYRGEt4z/1W38
         uZdVj6xRtxJKZvpLzQ3DrrgCSnLlAbkueU/aMDKcOYGdQlS1lG5zleA3/pg1DgOsYHwq
         dEyA==
X-Gm-Message-State: APjAAAWoNgf/wNlftf1wU7hB6u752D1mSklfqAtuzioTGeRxv/V+6XdM
        MOnjUedeMN2CEIrnCXjAMTZcmrL0x+A=
X-Google-Smtp-Source: APXvYqxojursbgsW2fF8uCH3rz1bfklhCeKLFXa/j5LLKnYLrY6bWEHrOrCcvAp4HzMnygSuWGZdaA==
X-Received: by 2002:a63:6fcf:: with SMTP id k198mr8542676pgc.276.1562909409883;
        Thu, 11 Jul 2019 22:30:09 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id o14sm6910270pjp.29.2019.07.11.22.30.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:30:09 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 V2 26/43] arm64: entry: Apply BP hardening for high-priority synchronous exceptions
Date:   Fri, 12 Jul 2019 10:58:14 +0530
Message-Id: <3ce1670e749b99ec2ce2fcee330b06c65bf71474.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
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

