Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA38E32FD
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502146AbfJXMuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:50:02 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50856 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502139AbfJXMuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:50:02 -0400
Received: by mail-wm1-f65.google.com with SMTP id q13so2708499wmj.0
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SUWSamHXQkQdCDGVETSveVvsUczyUjeOGzRV9FfWi1Y=;
        b=B8RnpKz2nK/aSU6+oIk4WFSrsezkLkLPx/2Ro7MypdXHd9YPdlsrvq8EikTUjTgwYz
         FczY8FiXesqebr7kTKLOPTtTNOJWKGJB7fqid0oH+fHth00gWKB85I9g/cEs/vxWiuvX
         hz/67AXL0d/UyelwfPO1JooxOEJ0jeBCzhYVNFwGxOfGCOsAsvDPxhUXrc7BB2yLcwJZ
         8InGwwuYdZ/wS1C4HTigF+7E9JnDVTSR9ChKeL7BZnv6wv8ywHKOsauclLZ2Q80d4azO
         PIpgSErBbv+2XSdI3rBLpLFYmYSw0gZFeUEIfGtaP3vFnvntXfApwq5hpABiR8jTQRz/
         YDnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SUWSamHXQkQdCDGVETSveVvsUczyUjeOGzRV9FfWi1Y=;
        b=oyJs7nGZUlp5pLBKvsWPZZKU84NFUFpWSg+9X3nERzYE6hOrfZGS1Io9AOJgbbU3cb
         Ir8WPE02aNM6tmfeV5eP3BWwO4tgLv6Axk+2Cha7UIzy8PvFVmlfWRKqQg0t842a1SAC
         rGwdxyyB1CIpHfuniQzqFUySUuUE4fRn6AKBJGfk+I64QNtdEFISnWg0DIBf0mAjbdG2
         fgsGGrYahm33fcB3eb7Yr47OcwIXESdQuLN0ifbVhc7l3GGfX/ofPmL4ULIKSIIm9n0U
         T7QYDVReyqEL01inbukicBdiz0ihH0yKBhQVkpYOuUz6BvSo+tJtEgtUHXtfjTp/t/p9
         XBdg==
X-Gm-Message-State: APjAAAWn4LxYj0XmqQh4QUh3s1iUscCWwi5yBBWFtrbRAYkM11tXu1Md
        z+WBOPxHUfs+l6vJNryFjJI6lexRgkixL1vh
X-Google-Smtp-Source: APXvYqxVvBsQDgpqWxyd7Sl43SHhmKm33aqLJg2kjGjJkbjtjqMZaoBU2bInIUEjtqs1H8zPQ/eumA==
X-Received: by 2002:a1c:f20e:: with SMTP id s14mr4581910wmc.118.1571921400142;
        Thu, 24 Oct 2019 05:50:00 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:59 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH for-stable-4.14 46/48] arm64: Force SSBS on context switch
Date:   Thu, 24 Oct 2019 14:48:31 +0200
Message-Id: <20191024124833.4158-47-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
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
index ec1725c6df21..9eb95ab19924 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -148,6 +148,16 @@ static inline void start_thread_common(struct pt_regs *regs, unsigned long pc)
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
@@ -155,7 +165,7 @@ static inline void start_thread(struct pt_regs *regs, unsigned long pc,
 	regs->pstate = PSR_MODE_EL0t;
 
 	if (arm64_get_ssbd_state() != ARM64_SSBD_FORCE_ENABLE)
-		regs->pstate |= PSR_SSBS_BIT;
+		set_ssbs_bit(regs);
 
 	regs->sp = sp;
 }
@@ -174,7 +184,7 @@ static inline void compat_start_thread(struct pt_regs *regs, unsigned long pc,
 #endif
 
 	if (arm64_get_ssbd_state() != ARM64_SSBD_FORCE_ENABLE)
-		regs->pstate |= PSR_AA32_SSBS_BIT;
+		set_compat_ssbs_bit(regs);
 
 	regs->compat_sp = sp;
 }
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 532ad6be9c2b..243fd247d04e 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -298,7 +298,7 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 			childregs->pstate |= PSR_UAO_BIT;
 
 		if (arm64_get_ssbd_state() == ARM64_SSBD_FORCE_DISABLE)
-			childregs->pstate |= PSR_SSBS_BIT;
+			set_ssbs_bit(childregs);
 
 		p->thread.cpu_context.x19 = stack_start;
 		p->thread.cpu_context.x20 = stk_sz;
@@ -339,6 +339,32 @@ void uao_thread_switch(struct task_struct *next)
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
@@ -367,6 +393,7 @@ __notrace_funcgraph struct task_struct *__switch_to(struct task_struct *prev,
 	contextidr_thread_switch(next);
 	entry_task_switch(next);
 	uao_thread_switch(next);
+	ssbs_thread_switch(next);
 
 	/*
 	 * Complete any pending TLB or cache maintenance on this CPU in case
-- 
2.20.1

