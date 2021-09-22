Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02129413FB3
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 04:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhIVCnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 22:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbhIVCnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 22:43:49 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E10C061575;
        Tue, 21 Sep 2021 19:42:20 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id r7so428095pjo.3;
        Tue, 21 Sep 2021 19:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lc10hB4P9xr8/xIggSp1h5sP3uOsJL6L6jU0Z4Y8DLY=;
        b=hZy9GtN2s0YgIvczD1JfZS7KkqVn5EIi425BgcV0lliPDik8DOMQSqrS7e2TO4eZgQ
         9nkUuSUgt3c0CBaxFP31RYfT/psZXtXwoJtH9cB2AN9xGOJkLq1LEusxgiRp5FfifaoO
         VJ72et/JxJUNj9YbEC/hOVufKBsSEwUlw/I+ZV2K8wT4h5eSppCKtBSD7Gvz2BtS7Syz
         xBdAjdWm/rQw/XxJdsI2icNW7lNBEoSp5422IymSo3PkWPmelqYIuNwOrSFmVG43G2oB
         /5P85K1vt0ReeLZ3kpa8jmrjSU5LyneYhc0j7y6t+9ySTzCWl2qGPOyGzxUOuSAneuQb
         erhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lc10hB4P9xr8/xIggSp1h5sP3uOsJL6L6jU0Z4Y8DLY=;
        b=UhO1ClKwU8u25yvYnCeWum9z/Dy1HHRE1weE66/qzNGXhkuwRz7N7tHRAt7BxRQK2K
         ZU5w8CXkKZ9VC167B7StmG38Vl87Olq4phh60Xc+zky0bzoUX5IRz+oN7neyidajWVIY
         b9t3ZPeIBfSdKX4eqJr7yeNaEwoPsTGGjsFK2s4uQi4eJhICXHlu7SACBB5+4BxUrnzv
         OuHOxAZ+VD9pBA68UVILqNzbUQnoSJyDSpos4QQql7OI4GxyrPpnqeq51Sy3/hkF+Nnj
         JkzOsIQfcXgJHjAd6hn1A9BEfha4lqqNwybiF0IUQHB8A9NFOZ1WQs1C+wq27jLT9Gz0
         tKVQ==
X-Gm-Message-State: AOAM5322z5p2aqrn1LKUVgPRghSu4aTvZ2GySwzS9e/KoRXfTRivE5CN
        Uz47efhUtpKlJAn31pTtfnAjcK5vS6Y=
X-Google-Smtp-Source: ABdhPJyLRRsoKDG8T9iwLiAF59HZUa8yZQn22Q98Rx7ouzT7bCrz9mtxn4SaPkhqqtiKRjLm/kXG3A==
X-Received: by 2002:a17:90a:428f:: with SMTP id p15mr8781572pjg.75.1632278539289;
        Tue, 21 Sep 2021 19:42:19 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 23sm445798pfw.97.2021.09.21.19.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 19:42:18 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT)
Subject: [PATCH stable 4.9 2/3] ARM: 9078/1: Add warn suppress parameter to arm_gen_branch_link()
Date:   Tue, 21 Sep 2021 19:41:56 -0700
Message-Id: <20210922024157.60001-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922024157.60001-1-f.fainelli@gmail.com>
References: <20210922024157.60001-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

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

