Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E360CFDE0
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfJHPkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:40:32 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36584 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfJHPkc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:40:32 -0400
Received: by mail-wm1-f65.google.com with SMTP id m18so3633980wmc.1
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 08:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EvOKMd/OQko6enWWrnf5RTdaY5yC08L1IEeTVlfB1KE=;
        b=eAe1Nt3M59FCoKdNyg0/uPHL+NGZXHcXN7MIfxXpQDzCXGF1K9AagIcCW0BLviOjV/
         1dVitWM281Nq7nO6Ova3+aZ3rZAAhU91JAxi2YfQOETkBI4f9cTDAZa8E4lE2TI6seb6
         GWKGKJgdLbjv6IzR7MDktt+60cosWHE3d9UOxHdJtN0GIts7WVSD7eIGvNgA8HSbraRB
         zuh8rdNGzGqBgyacKSSFasxcGHoBjrc4Gu7eFV5UQM8CnrZnDGoQsivFdgyRvGGUu1ip
         1jzG2fOiw4FE5y1GdaiaGesCsLI8TuR/uCsKq+gvQjOidhHUyjFiT4UQQ+T7a7ZV/G6L
         K/yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EvOKMd/OQko6enWWrnf5RTdaY5yC08L1IEeTVlfB1KE=;
        b=C3QDBZNeglOGQH14PVTT+xQSI2SlFzAv+7Za46asmATgWiOlSu1l4hAo4EfhzNbpY3
         TGrS4vSNrDkQGf2Tm2oCPFrGTi51Epst9zaa5ZIU4dBbhEGWJOaUg5Ya3xH9+xhIG4M8
         l6uF0F+S5qZ5C3Fl0dF9Gbat2WhcATWfOPo8I0RXbTpKxY0meQAfzJreRe48FB3J2NNS
         rqLX2+SgxE09x1IaJ0+DnMQBZp0NlL4Zx9x1POG6xwYFqt3DZVloy8GiS6ePmLrObTET
         Jz50h5PUZc+TXUqslIuNEs2glKzjlTnVh7wkiWURZlJRwknTcGXXGFXdsVaLRXKRosa8
         pmZw==
X-Gm-Message-State: APjAAAUDNA/hwBgKlC1fdaZuJFPhJukq2NXvbLL1k8U2WZu2Lagsfhqv
        uuftCux0dC7+ddzuXSWAG0CA5g==
X-Google-Smtp-Source: APXvYqyAVp/yCC6CfDd/QlOcq/K7/o2Dn7ydbghMakGo11tAwkKAo1IxUtKF+K1UR9L3BnYmIH5eHw==
X-Received: by 2002:a7b:cc97:: with SMTP id p23mr4442634wma.111.1570549230029;
        Tue, 08 Oct 2019 08:40:30 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id x16sm16784723wrl.32.2019.10.08.08.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 08:40:28 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH for-stable-v4.19 16/16] arm64: Force SSBS on context switch
Date:   Tue,  8 Oct 2019 17:39:30 +0200
Message-Id: <20191008153930.15386-17-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
References: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

[ Upstream commit cbdf8a189a66001c36007bf0f5c975d0376c5c3a ]

On a CPU that doesn't support SSBS, PSTATE[12] is RES0.  In a system
where only some of the CPUs implement SSBS, we end-up losing track of
the SSBS bit across task migration.

To address this issue, let's force the SSBS bit on context switch.

Fixes: 8f04e8e6e29c ("arm64: ssbd: Add support for PSTATE.SSBS rather than trapping to EL3")
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
[will: inverted logic and added comments]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/processor.h | 14 ++++++++--
 arch/arm64/kernel/process.c        | 29 +++++++++++++++++++-
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index ad208bd402f7..773ea8e0e442 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -177,6 +177,16 @@ static inline void start_thread_common(struct pt_regs *regs, unsigned long pc)
 	regs->pc = pc;
 }
 
+static inline void set_ssbs_bit(struct pt_regs *regs)
+{
+	regs->pstate |= PSR_SSBS_BIT;
+}
+
+static inline void set_compat_ssbs_bit(struct pt_regs *regs)
+{
+	regs->pstate |= PSR_AA32_SSBS_BIT;
+}
+
 static inline void start_thread(struct pt_regs *regs, unsigned long pc,
 				unsigned long sp)
 {
@@ -184,7 +194,7 @@ static inline void start_thread(struct pt_regs *regs, unsigned long pc,
 	regs->pstate = PSR_MODE_EL0t;
 
 	if (arm64_get_ssbd_state() != ARM64_SSBD_FORCE_ENABLE)
-		regs->pstate |= PSR_SSBS_BIT;
+		set_ssbs_bit(regs);
 
 	regs->sp = sp;
 }
@@ -203,7 +213,7 @@ static inline void compat_start_thread(struct pt_regs *regs, unsigned long pc,
 #endif
 
 	if (arm64_get_ssbd_state() != ARM64_SSBD_FORCE_ENABLE)
-		regs->pstate |= PSR_AA32_SSBS_BIT;
+		set_compat_ssbs_bit(regs);
 
 	regs->compat_sp = sp;
 }
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index ce99c58cd1f1..bc2226608e13 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -360,7 +360,7 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 			childregs->pstate |= PSR_UAO_BIT;
 
 		if (arm64_get_ssbd_state() == ARM64_SSBD_FORCE_DISABLE)
-			childregs->pstate |= PSR_SSBS_BIT;
+			set_ssbs_bit(childregs);
 
 		p->thread.cpu_context.x19 = stack_start;
 		p->thread.cpu_context.x20 = stk_sz;
@@ -401,6 +401,32 @@ void uao_thread_switch(struct task_struct *next)
 	}
 }
 
+/*
+ * Force SSBS state on context-switch, since it may be lost after migrating
+ * from a CPU which treats the bit as RES0 in a heterogeneous system.
+ */
+static void ssbs_thread_switch(struct task_struct *next)
+{
+	struct pt_regs *regs = task_pt_regs(next);
+
+	/*
+	 * Nothing to do for kernel threads, but 'regs' may be junk
+	 * (e.g. idle task) so check the flags and bail early.
+	 */
+	if (unlikely(next->flags & PF_KTHREAD))
+		return;
+
+	/* If the mitigation is enabled, then we leave SSBS clear. */
+	if ((arm64_get_ssbd_state() == ARM64_SSBD_FORCE_ENABLE) ||
+	    test_tsk_thread_flag(next, TIF_SSBD))
+		return;
+
+	if (compat_user_mode(regs))
+		set_compat_ssbs_bit(regs);
+	else if (user_mode(regs))
+		set_ssbs_bit(regs);
+}
+
 /*
  * We store our current task in sp_el0, which is clobbered by userspace. Keep a
  * shadow copy so that we can restore this upon entry from userspace.
@@ -429,6 +455,7 @@ __notrace_funcgraph struct task_struct *__switch_to(struct task_struct *prev,
 	contextidr_thread_switch(next);
 	entry_task_switch(next);
 	uao_thread_switch(next);
+	ssbs_thread_switch(next);
 
 	/*
 	 * Complete any pending TLB or cache maintenance on this CPU in case
-- 
2.20.1

