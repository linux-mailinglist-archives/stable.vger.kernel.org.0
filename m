Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA20D6663F
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfGLFaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:30:13 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43991 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLFaN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:30:13 -0400
Received: by mail-pl1-f195.google.com with SMTP id cl9so4184234plb.10
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kL4bvpTkIxzXH8Y5LirqPgKQFts/fgCJz2Uk/H1BBsA=;
        b=y9XIy3wTk60NXWrXhru0mUO9/FiIQPREsZdlokiU8JNb99L26GCt/yZIG2IBNB1WJg
         Kn89bWYn63fAPyCXVRrqjeEMRm+D73cSM1bBSF2Fpc+SGlMyBlN3M4u2xYr6pxEiIzLd
         6Gv2JiHmZ5cDQF2BNlHUn62gP7cXHnpLypPt9ePeql3gi7+CzsagsMbfy1H721NCE0KK
         e878J9lQ1hyCCnI1gCkFdRECRGv0ZYVS+qNN5zmgumqJ+IBujvctwv3tIikLMsI0cP3O
         luRcEbquQ0y/S7UTqt9xwzfWjyT42vXfWK8WpJcBNXChxvHVMfw3c9m+up/a1itGbWyc
         DlTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kL4bvpTkIxzXH8Y5LirqPgKQFts/fgCJz2Uk/H1BBsA=;
        b=Jolz1qROAhARztd4ZTFwdrTsMuIvPn9Bx38c1AgPK/pj3m1wXQLq0g/97K+NT3OQQx
         IZC3iId0b6UxJfNy+wMd7kzwFS9f2nyXUtREl6Ova5Qt4KZksVJSnc5EgYKpoet2PSn6
         TgwyU+D87cUWT+qokPvdXp6fNhoW7xKIOV0syUl0cbVlgzdzaiuuDrFXkdPjS6rX0AQR
         y3YL/z9my0qiU6jmBfgEOoIlLZT+zoNKtia1tE4U51X5tpP2VyeLyethT80OgglBsdN9
         8x5/ZvEkaAPBCwbm+Uot7VRrXMg4JX7Nj7Ug2sXYDx1jiOJbvS6l/G7DL7W0qJminNOc
         qHDg==
X-Gm-Message-State: APjAAAV3Yvk2d5hq8GOMy9cnUtKgHkuf/uS4T/o2I/lYbC3wL3I9yKOz
        9NhPQwNLYkA3v2t65mTam6JRZhpPrjM=
X-Google-Smtp-Source: APXvYqzy0Q8kC5lDn5f+LWPOQ3X16InC9Bmxkp9LXrYgrQcOEwOOR/Ct+HvmAvFdZA9kTRN4QO1GRg==
X-Received: by 2002:a17:902:4c88:: with SMTP id b8mr9462899ple.29.1562909412745;
        Thu, 11 Jul 2019 22:30:12 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id m9sm14607083pgr.24.2019.07.11.22.30.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:30:12 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 27/43] arm64: entry: Apply BP hardening for suspicious interrupts from EL0
Date:   Fri, 12 Jul 2019 10:58:15 +0530
Message-Id: <5de9501d4e24fe45bb5938c4eacad6ab56b1ae55.1562908075.git.viresh.kumar@linaro.org>
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

