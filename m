Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04B60A18D8
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfH2LgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:36:08 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46132 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbfH2LgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:36:08 -0400
Received: by mail-pl1-f195.google.com with SMTP id o3so1429115plb.13
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kL4bvpTkIxzXH8Y5LirqPgKQFts/fgCJz2Uk/H1BBsA=;
        b=uQR2nK9Abh6tvSTERRD5xBq9uwIxsZobXq4VEfEob3EK6BxdIufTOc5Wx3Y/FVU4uc
         JWR1NrqBH7lUEVzldljV3kwsB+S09nQFWAzzaR3VX9uxPnRn8IXDKjrv2CwTLnMaYHYb
         /Oz0Ek425YEemXc/7qOYG6eSOdf2MaBTXINhNAnGlqFpjO/CPx6xeW4x0phOm4w4AAnU
         MhjlHro4CJmTRlEKwdlqXVEI9OZZvBTPuJbLamLy9gPjCo8VToC1yGgADlXvtZjfOZ+b
         io0G7yJ1Xb4O27IQJpP/v2qJpHKzTFev0xrvzTrIGNbhswhr+mNOJcu8WS95sQRWCZb8
         blkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kL4bvpTkIxzXH8Y5LirqPgKQFts/fgCJz2Uk/H1BBsA=;
        b=ejLIbnrZ3SpNp5XEkKPad4u/MsSfEfDsBflVpKhDH1jX+jg3/edNIkR0ljz1I46WoM
         NsVKsBBmVX8L8NIJiaSQudyvisHMcdL2xXE6mJhaDD3s2pW3D4CGqqEUnz7BCuUvFVqQ
         MSKzPerptVcksG4ll2UTxQpTIVU4P/q8ORmltrC+T2h7xRxxlTKXmDAt8n0gaWhq7NdL
         pTlzeO3iViXw/sjYpUGQK3KEAWFIBzJSm9RdD1Mjdp8D4qav/Aqc7BppEbY78HOacVxO
         ouuDmvF1X9Kvu69w9Rd0Tzt0RSlE2ZjA7JMHHcMj6Wnzbfd5vZ1e08If01iglrm+2wsg
         LHuQ==
X-Gm-Message-State: APjAAAWJRkpMTysuVz7W2CyjMhU6SIWSk48HdmIbVANQ7W4zvGgWbTex
        qeW9es8aDK9lhGgzCSwypd2EA3d04Gs=
X-Google-Smtp-Source: APXvYqy8YFh1mdMBf+OANfN4ae8Bqd8t4rFFIx82JCvQqRVm6LVGN3pK+l2vSa6Ykosu0quhrTgqxg==
X-Received: by 2002:a17:902:7c8b:: with SMTP id y11mr9687584pll.259.1567078567353;
        Thu, 29 Aug 2019 04:36:07 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id g14sm2587953pfo.41.2019.08.29.04.36.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:36:06 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 28/44] arm64: entry: Apply BP hardening for suspicious interrupts from EL0
Date:   Thu, 29 Aug 2019 17:04:13 +0530
Message-Id: <16be0cb9c5bbcff5cfe74cf8d47c5a4084e45b5e.1567077734.git.viresh.kumar@linaro.org>
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

