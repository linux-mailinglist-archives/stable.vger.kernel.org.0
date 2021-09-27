Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9A141A114
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 23:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237425AbhI0VFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 17:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237203AbhI0VFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 17:05:01 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FF7C061575;
        Mon, 27 Sep 2021 14:03:23 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id b22so1872275pls.1;
        Mon, 27 Sep 2021 14:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fx3CrEPWbTBsdv7Fz/Y72SC7soyMpdM/flXeUOHk7Co=;
        b=XJbgw7UkEF7s3JguBn6NkX9KNS5QjzXleVYxhSlS1VwFFXf6mhaWyiRc/gG6HBpNZv
         o+VkqjNnAResAHQXEzOl5yHHOu310BZxqB9NVvt7wsVOJXYiYnDGejjKmYQjPywqmHhr
         uyHFJmUSTmW5H/0zumsOL1jzfsLFqbbShbf12axdg+CkpPnXG6nu32DOhEgSwp69fgFM
         jtETQKuH44eVidq0FqHevfqvkKUTzq9NuZthbh7yIHJIXbjrGLApV/rF+7jg2Fnx4sa8
         oHgpWy92Y1j4fdNSM/pJ4+yNnSMecC/8oDBlOvaB9c1/z40Zf1GfBfjKiVa3i2ehfAmV
         MXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fx3CrEPWbTBsdv7Fz/Y72SC7soyMpdM/flXeUOHk7Co=;
        b=6AQlk2PVRbMaaUZivIXj/osPnbhh2J/0g9VW7ylDISnG8GN56wBP790DrWhlYMnxAf
         2nrzFSA1wfVNOPtYoaS98VAWtt/9Rw4B6QmKkHyW6aTXQKsR2f42zUsu3EVxGCAjRyWr
         R4YDFyp3Td6g5+RxwF9zYpWxiw4SDPCbm/C5PKFKUij7HyY08o/UBgjOPzzOUzEV+TSr
         J6msVHg8cQUkQOlcVsMv/vtgSS3JHhj5QRf7PiYQT+YqboHBFQs+ynYi6g8ZrMK8wF1r
         mMkV+PmQCkCs8NW10VT/fHjcSpR9OylGY38m78SmEPzTzfpYapLpvMWJU0cBdizBuGp5
         zg5g==
X-Gm-Message-State: AOAM532gVw6g1OX5rA4B2jKOkbqIu3m4AipWZMOVPhF3s3VDpln4KxV9
        0t9qWXCeq5WTyKJoMeJNql8hqFXKAWc=
X-Google-Smtp-Source: ABdhPJzyBHlnSeRzNHO0WALa9j+NLwyJEx/T9JF4ia5gx7AS+fUj8jYjvNeh2+23xpREFhtx0Tq5WQ==
X-Received: by 2002:a17:90a:2944:: with SMTP id x4mr1236586pjf.131.1632776602501;
        Mon, 27 Sep 2021 14:03:22 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e12sm16444086pgv.82.2021.09.27.14.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 14:03:22 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Alex Sverdlin <alexander.sverdlin@nokia.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT)
Subject: [PATCH stable 4.9 v3 2/4] ARM: 9078/1: Add warn suppress parameter to arm_gen_branch_link()
Date:   Mon, 27 Sep 2021 14:03:14 -0700
Message-Id: <20210927210316.3217044-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927210316.3217044-1-f.fainelli@gmail.com>
References: <20210927210316.3217044-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Sverdlin <alexander.sverdlin@nokia.com>

commit 890cb057a46d323fd8c77ebecb6485476614cd21 upstream

Will be used in the following patch. No functional change.

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/include/asm/insn.h |  8 ++++----
 arch/arm/kernel/ftrace.c    |  2 +-
 arch/arm/kernel/insn.c      | 19 ++++++++++---------
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/arm/include/asm/insn.h b/arch/arm/include/asm/insn.h
index e96065da4dae..0043bf609f27 100644
--- a/arch/arm/include/asm/insn.h
+++ b/arch/arm/include/asm/insn.h
@@ -12,18 +12,18 @@ arm_gen_nop(void)
 }
 
 unsigned long
-__arm_gen_branch(unsigned long pc, unsigned long addr, bool link);
+__arm_gen_branch(unsigned long pc, unsigned long addr, bool link, bool warn);
 
 static inline unsigned long
 arm_gen_branch(unsigned long pc, unsigned long addr)
 {
-	return __arm_gen_branch(pc, addr, false);
+	return __arm_gen_branch(pc, addr, false, true);
 }
 
 static inline unsigned long
-arm_gen_branch_link(unsigned long pc, unsigned long addr)
+arm_gen_branch_link(unsigned long pc, unsigned long addr, bool warn)
 {
-	return __arm_gen_branch(pc, addr, true);
+	return __arm_gen_branch(pc, addr, true, warn);
 }
 
 #endif
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index 414e60ed0257..a95bc0a02fd8 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -97,7 +97,7 @@ int ftrace_arch_code_modify_post_process(void)
 
 static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
 {
-	return arm_gen_branch_link(pc, addr);
+	return arm_gen_branch_link(pc, addr, true);
 }
 
 static int ftrace_modify_code(unsigned long pc, unsigned long old,
diff --git a/arch/arm/kernel/insn.c b/arch/arm/kernel/insn.c
index b760340b7014..eaded01b7edf 100644
--- a/arch/arm/kernel/insn.c
+++ b/arch/arm/kernel/insn.c
@@ -2,8 +2,9 @@
 #include <linux/kernel.h>
 #include <asm/opcodes.h>
 
-static unsigned long
-__arm_gen_branch_thumb2(unsigned long pc, unsigned long addr, bool link)
+static unsigned long __arm_gen_branch_thumb2(unsigned long pc,
+					     unsigned long addr, bool link,
+					     bool warn)
 {
 	unsigned long s, j1, j2, i1, i2, imm10, imm11;
 	unsigned long first, second;
@@ -11,7 +12,7 @@ __arm_gen_branch_thumb2(unsigned long pc, unsigned long addr, bool link)
 
 	offset = (long)addr - (long)(pc + 4);
 	if (offset < -16777216 || offset > 16777214) {
-		WARN_ON_ONCE(1);
+		WARN_ON_ONCE(warn);
 		return 0;
 	}
 
@@ -32,8 +33,8 @@ __arm_gen_branch_thumb2(unsigned long pc, unsigned long addr, bool link)
 	return __opcode_thumb32_compose(first, second);
 }
 
-static unsigned long
-__arm_gen_branch_arm(unsigned long pc, unsigned long addr, bool link)
+static unsigned long __arm_gen_branch_arm(unsigned long pc, unsigned long addr,
+					  bool link, bool warn)
 {
 	unsigned long opcode = 0xea000000;
 	long offset;
@@ -43,7 +44,7 @@ __arm_gen_branch_arm(unsigned long pc, unsigned long addr, bool link)
 
 	offset = (long)addr - (long)(pc + 8);
 	if (unlikely(offset < -33554432 || offset > 33554428)) {
-		WARN_ON_ONCE(1);
+		WARN_ON_ONCE(warn);
 		return 0;
 	}
 
@@ -53,10 +54,10 @@ __arm_gen_branch_arm(unsigned long pc, unsigned long addr, bool link)
 }
 
 unsigned long
-__arm_gen_branch(unsigned long pc, unsigned long addr, bool link)
+__arm_gen_branch(unsigned long pc, unsigned long addr, bool link, bool warn)
 {
 	if (IS_ENABLED(CONFIG_THUMB2_KERNEL))
-		return __arm_gen_branch_thumb2(pc, addr, link);
+		return __arm_gen_branch_thumb2(pc, addr, link, warn);
 	else
-		return __arm_gen_branch_arm(pc, addr, link);
+		return __arm_gen_branch_arm(pc, addr, link, warn);
 }
-- 
2.25.1

