Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA267D738
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731086AbfHAIUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:34 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:32779 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730473AbfHAIUe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:34 -0400
Received: by mail-pg1-f194.google.com with SMTP id n190so2294045pgn.0
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8Q63Doa+cYNUasTyoI6bAijjzbaGR6LEUpU/vkgXczo=;
        b=OnsdO7izQSNVnwcP+XktL4K50wNOnqx0WIs3j/4fZwBlbC1vL8Vgb2fIiI3F0DZ352
         hDXCHjiY36jcTMB5mAKJuG2ykd6K+l269e6V9AuhxQJ+QwNN46c9FcYNT2PRs7Ux8dyw
         dawW6e6Gip/Dh+pab1P/lzDYfZeOBGdM9VDiD9nFqowBMCClAN46ML417pHVVHLcAImZ
         Jj1R+5+//GzwB447sGneYtYUYUM0RaREDKbuGh9+mZWdlnt3ILrFgEszu/ioySwcYlul
         hEMRvjyIbc7eIJdA/WwhNrZjD3lSGwnOGnRPtMo3p3ayQkKuAkwMog4XZK9aT4zdelH4
         k/LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Q63Doa+cYNUasTyoI6bAijjzbaGR6LEUpU/vkgXczo=;
        b=PDl+Wtfa63HajK8cZXzaKED6/3UE8xfN2SYSY7HiITjZuuJyQJ3fJ5VpJ8U0HgsC6V
         O673GX/OyzRS55rNwVw9tKMpySskdK9bgUYlSJeHp5Ly+R01WAXqKOsYtpXFkD/YR4UW
         apkoC00eeBdBuEv9igYFtwVOk6ctyRoduAo+uDfPePtNhE+vNQj2KVK5enTdF4bu5x5Z
         XJ6emQzBgUlHN5Ye9JJWUdR7vkWEcMxbpvvL9NYPvXv3poxINbSa60WUs782MpxaYkh4
         O6pLwjrB0q8HxTA6IkjTu4dPrAHrWJKhxSi3hazr4PPXx1bF0hi9UOcjy6mHJkqMdY4s
         QEeg==
X-Gm-Message-State: APjAAAWdZ03Z/roNNZMz0rBLrUapjVNrmcYJyWe6MeaLeeGvEmsCJQBX
        PS1DjfYRvkyghaqe5amPB4yBH++pHws=
X-Google-Smtp-Source: APXvYqwvOhOWgRG5Ry6TKP2Km/uijYOKs0rlPuA0mCCWOxKbLEYDS5Z6VWPpRcaMDl4E8jVLeWoZuQ==
X-Received: by 2002:a63:ee08:: with SMTP id e8mr64308403pgi.70.1564647633016;
        Thu, 01 Aug 2019 01:20:33 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id o24sm135619457pfp.135.2019.08.01.01.20.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:32 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 22/47] ARM: signal: copy registers using __copy_from_user()
Date:   Thu,  1 Aug 2019 13:46:06 +0530
Message-Id: <cd300105252ac227310a4f700bec67745ec1ef46.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit c32cd419d6650e42b9cdebb83c672ec945e6bd7e upstream.

__get_user_error() is used as a fast accessor to make copying structure
members in the signal handling path as efficient as possible.  However,
with software PAN and the recent Spectre variant 1, the efficiency is
reduced as these are no longer fast accessors.

In the case of software PAN, it has to switch the domain register around
each access, and with Spectre variant 1, it would have to repeat the
access_ok() check for each access.

It becomes much more efficient to use __copy_from_user() instead, so
let's use this for the ARM integer registers.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/kernel/signal.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 7b8f2141427b..a592bc0287f8 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -141,6 +141,7 @@ struct rt_sigframe {
 
 static int restore_sigframe(struct pt_regs *regs, struct sigframe __user *sf)
 {
+	struct sigcontext context;
 	struct aux_sigframe __user *aux;
 	sigset_t set;
 	int err;
@@ -149,23 +150,26 @@ static int restore_sigframe(struct pt_regs *regs, struct sigframe __user *sf)
 	if (err == 0)
 		set_current_blocked(&set);
 
-	__get_user_error(regs->ARM_r0, &sf->uc.uc_mcontext.arm_r0, err);
-	__get_user_error(regs->ARM_r1, &sf->uc.uc_mcontext.arm_r1, err);
-	__get_user_error(regs->ARM_r2, &sf->uc.uc_mcontext.arm_r2, err);
-	__get_user_error(regs->ARM_r3, &sf->uc.uc_mcontext.arm_r3, err);
-	__get_user_error(regs->ARM_r4, &sf->uc.uc_mcontext.arm_r4, err);
-	__get_user_error(regs->ARM_r5, &sf->uc.uc_mcontext.arm_r5, err);
-	__get_user_error(regs->ARM_r6, &sf->uc.uc_mcontext.arm_r6, err);
-	__get_user_error(regs->ARM_r7, &sf->uc.uc_mcontext.arm_r7, err);
-	__get_user_error(regs->ARM_r8, &sf->uc.uc_mcontext.arm_r8, err);
-	__get_user_error(regs->ARM_r9, &sf->uc.uc_mcontext.arm_r9, err);
-	__get_user_error(regs->ARM_r10, &sf->uc.uc_mcontext.arm_r10, err);
-	__get_user_error(regs->ARM_fp, &sf->uc.uc_mcontext.arm_fp, err);
-	__get_user_error(regs->ARM_ip, &sf->uc.uc_mcontext.arm_ip, err);
-	__get_user_error(regs->ARM_sp, &sf->uc.uc_mcontext.arm_sp, err);
-	__get_user_error(regs->ARM_lr, &sf->uc.uc_mcontext.arm_lr, err);
-	__get_user_error(regs->ARM_pc, &sf->uc.uc_mcontext.arm_pc, err);
-	__get_user_error(regs->ARM_cpsr, &sf->uc.uc_mcontext.arm_cpsr, err);
+	err |= __copy_from_user(&context, &sf->uc.uc_mcontext, sizeof(context));
+	if (err == 0) {
+		regs->ARM_r0 = context.arm_r0;
+		regs->ARM_r1 = context.arm_r1;
+		regs->ARM_r2 = context.arm_r2;
+		regs->ARM_r3 = context.arm_r3;
+		regs->ARM_r4 = context.arm_r4;
+		regs->ARM_r5 = context.arm_r5;
+		regs->ARM_r6 = context.arm_r6;
+		regs->ARM_r7 = context.arm_r7;
+		regs->ARM_r8 = context.arm_r8;
+		regs->ARM_r9 = context.arm_r9;
+		regs->ARM_r10 = context.arm_r10;
+		regs->ARM_fp = context.arm_fp;
+		regs->ARM_ip = context.arm_ip;
+		regs->ARM_sp = context.arm_sp;
+		regs->ARM_lr = context.arm_lr;
+		regs->ARM_pc = context.arm_pc;
+		regs->ARM_cpsr = context.arm_cpsr;
+	}
 
 	err |= !valid_user_regs(regs);
 
-- 
2.21.0.rc0.269.g1a574e7a288b

