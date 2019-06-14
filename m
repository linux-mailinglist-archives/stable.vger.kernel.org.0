Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E7045276
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfFNDMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:12:53 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41544 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:12:53 -0400
Received: by mail-pl1-f196.google.com with SMTP id s24so372475plr.8
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kL4bvpTkIxzXH8Y5LirqPgKQFts/fgCJz2Uk/H1BBsA=;
        b=u+88Jdi7Q2EeMON1v99eEjm9+dO5INKlFqJHoLqKGVOyh3nEcQXjS35XfEJ5A2VEHA
         2I2MGN7Qk32wlEFIVDoAvNMIWA2oa2fapQk441nt2HlgF5Glw/iQBurHguBosW2Lc7kE
         OinAbfXHPRwyDF0uukWdCxCAtavKB6z0DAEZljHgQyVFJeU9ZPuJKcRFdlQ9xL7pNS6f
         r7RJoFG4+NLPymu0kCH6ak1l0U9tGg6Jgo0Ftbtpkpt83EZ62NHHyZiQxxn+IBMOjsXz
         1fQJd8ESeOJ1gaJV/g9qWIQ8aivYfHWco/LFd+4P2r1Ainssb/eNVPTAZkXVvG1HmXYi
         QRog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kL4bvpTkIxzXH8Y5LirqPgKQFts/fgCJz2Uk/H1BBsA=;
        b=lq2Oj1x6XlwxnSE3g3j/gCB/LpNVOGClw2q+kFBsy/+UMK/XiK6PbEh/17HALEBd1e
         VoXdAMniyh8pHaLRSwEPMc2KNa7NaXTpZFMpfLLFT57ctL42Yj1GMeMHNKW0O2kPuOmi
         6x2Wt+o/59cS01fAU4TCC3PLsZgCL9P+DtFjMY5E+AaubmBeWGg65X+J++2livMDreP6
         gAtXBe50RuSMTGdC8AUG0K6xlGpjHJE2yHpje/s0Tosruc21UrO6N7uKIJrCV9iHmu5x
         7VMmE88JmU8MtP6yHAkGyEUxjkqyYOpKbtEDku/m3jJ925WoagcqlkVPf/tlyW5sgTPb
         DJxQ==
X-Gm-Message-State: APjAAAUd9YD16WT+qOeY1pAiMPPLiQVtBOy0UJCG0o55sddtD6H8t+VC
        MaJmUwHeb78Z4tlq6VjtqisFEg==
X-Google-Smtp-Source: APXvYqzdS+h3nTBe4+ah+h47lCx5qzIMvTC/Buyw8qV9hj5xEcJCPdt4F090HB7zRNgWQjs9BbQgsQ==
X-Received: by 2002:a17:902:8a94:: with SMTP id p20mr71883806plo.312.1560481972488;
        Thu, 13 Jun 2019 20:12:52 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id b6sm1044511pjo.25.2019.06.13.20.12.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:12:52 -0700 (PDT)
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
Subject: [PATCH v4.4 22/45] arm64: entry: Apply BP hardening for suspicious interrupts from EL0
Date:   Fri, 14 Jun 2019 08:38:05 +0530
Message-Id: <f63b1037760ac07b1dab75685d20e32c3c5b8396.1560480942.git.viresh.kumar@linaro.org>
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

commit 30d88c0e3ace625a92eead9ca0ad94093a8f59fe upstream.

It is possible to take an IRQ from EL0 following a branch to a kernel
address in such a way that the IRQ is prioritised over the instruction
abort. Whilst an attacker would need to get the stars to align here,
it might be sufficient with enough calibration so perform BP hardening
in the rare case that we see a kernel address in the ELR when handling
an IRQ from EL0.

Reported-by: Dan Hettena <dhettena@nvidia.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/kernel/entry.S | 5 +++++
 arch/arm64/mm/fault.c     | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 42a141f01f3b..1548be9732ce 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -582,6 +582,11 @@ ENDPROC(el0_sync)
 #endif
 
 	ct_user_exit
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+	tbz	x22, #55, 1f
+	bl	do_el0_irq_bp_hardening
+1:
+#endif
 	irq_handler
 
 #ifdef CONFIG_TRACE_IRQFLAGS
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 082f385b6592..9ff48d083c4c 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -535,6 +535,12 @@ asmlinkage void __exception do_mem_abort(unsigned long addr, unsigned int esr,
 	arm64_notify_die("", regs, &info, esr);
 }
 
+asmlinkage void __exception do_el0_irq_bp_hardening(void)
+{
+	/* PC has already been checked in entry.S */
+	arm64_apply_bp_hardening();
+}
+
 asmlinkage void __exception do_el0_ia_bp_hardening(unsigned long addr,
 						   unsigned int esr,
 						   struct pt_regs *regs)
-- 
2.21.0.rc0.269.g1a574e7a288b

