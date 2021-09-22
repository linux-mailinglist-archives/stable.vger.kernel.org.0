Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3277F413F9A
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 04:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhIVCmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 22:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbhIVCmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 22:42:10 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8951C061575;
        Tue, 21 Sep 2021 19:40:41 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id t20so969036pju.5;
        Tue, 21 Sep 2021 19:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MOhptkmv9edXrdiqH8+39RmWkP/z/b8cujzYFZjvDes=;
        b=dYRkMxw8VsTBrDNnXbEbfFq3Ors/ZJ8TZV1sKUQ9IORzXOG3HDFaWA0ggYISF9idWO
         AQCuoFyfu5IwXNprEqg0CjUmSbmEZzD+3YA6lMDZ5Z9f3OV65gQIoI6pW1BavsWGS6mZ
         +vKB1nHK81Fw9j9q91onwQMZYntcd6Ir06Hjvoni47SivvvC87KC2cdJ4IanzUCloR9N
         zvMxSdSZAT6YaVi84JiDVsAIcbS/6Q9QeJLaojgEpzAbdNpxL8U1L7xuUDwX65xjP2je
         lgoDZsKEeAq75WWXKLmUXSiGC0fFQkcRKf5yJBiYNXEdTgXMdYfHdC71svkVCXBQNrJf
         XBbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MOhptkmv9edXrdiqH8+39RmWkP/z/b8cujzYFZjvDes=;
        b=ORhoau78a+7JlNpq+rIvW8ZXDixwaKIWrUHMc3y0sG/HzuIl4n1hkfOR7eJ+jc9NUn
         MZl4lNL62VABNvikRQ9jDNdIKIjkAWQYV8f0zsQDYnETB8bW1iym/48p7XGsu08AyzDp
         Z+KLVNTlK4dkOS1gzKXrJBSPK8lkBoipUcVk2j2f50m4fReV2fDXsStGXdyBeVj7VO++
         vbvYLaQJdA1K4BfA5Fm8gXyf5TsagkVMskYYEeUh6npasaE6FINrC8eUFg1e+mCFQy0o
         3NZepQp5G/NptewoZZmN9T0AFEb66ZH1aPvo8bTLsD8leZTVtEu9spXw0R9l+6BOLpQ5
         GHkA==
X-Gm-Message-State: AOAM532eWsrEWfbQmvinz83YRZTiWXThrynxuwLFV+zbgLvchCKenwoC
        XLfsmOgIBeiprtOG0g1DEXjUVu0Gy/8=
X-Google-Smtp-Source: ABdhPJzEM3p/5z6pteEWX5z0owUEyfuwagsysXJx5Rk4XVsKovDIBoMP9NWfMmOOV4QLXJkiMNkn7Q==
X-Received: by 2002:a17:90b:a4a:: with SMTP id gw10mr8674656pjb.245.1632278440943;
        Tue, 21 Sep 2021 19:40:40 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b85sm438328pfb.0.2021.09.21.19.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 19:40:40 -0700 (PDT)
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
Subject: [PATCH stable 5.4 2/3] ARM: 9078/1: Add warn suppress parameter to arm_gen_branch_link()
Date:   Tue, 21 Sep 2021 19:40:18 -0700
Message-Id: <20210922024019.59726-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922024019.59726-1-f.fainelli@gmail.com>
References: <20210922024019.59726-1-f.fainelli@gmail.com>
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
index f20e08ac85ae..5475cbf9fb6b 100644
--- a/arch/arm/include/asm/insn.h
+++ b/arch/arm/include/asm/insn.h
@@ -13,18 +13,18 @@ arm_gen_nop(void)
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
index bda949fd84e8..f2073cee4102 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -73,7 +73,7 @@ int ftrace_arch_code_modify_post_process(void)
 
 static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
 {
-	return arm_gen_branch_link(pc, addr);
+	return arm_gen_branch_link(pc, addr, true);
 }
 
 static int ftrace_modify_code(unsigned long pc, unsigned long old,
diff --git a/arch/arm/kernel/insn.c b/arch/arm/kernel/insn.c
index 2e844b70386b..db0acbb7d7a0 100644
--- a/arch/arm/kernel/insn.c
+++ b/arch/arm/kernel/insn.c
@@ -3,8 +3,9 @@
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
@@ -12,7 +13,7 @@ __arm_gen_branch_thumb2(unsigned long pc, unsigned long addr, bool link)
 
 	offset = (long)addr - (long)(pc + 4);
 	if (offset < -16777216 || offset > 16777214) {
-		WARN_ON_ONCE(1);
+		WARN_ON_ONCE(warn);
 		return 0;
 	}
 
@@ -33,8 +34,8 @@ __arm_gen_branch_thumb2(unsigned long pc, unsigned long addr, bool link)
 	return __opcode_thumb32_compose(first, second);
 }
 
-static unsigned long
-__arm_gen_branch_arm(unsigned long pc, unsigned long addr, bool link)
+static unsigned long __arm_gen_branch_arm(unsigned long pc, unsigned long addr,
+					  bool link, bool warn)
 {
 	unsigned long opcode = 0xea000000;
 	long offset;
@@ -44,7 +45,7 @@ __arm_gen_branch_arm(unsigned long pc, unsigned long addr, bool link)
 
 	offset = (long)addr - (long)(pc + 8);
 	if (unlikely(offset < -33554432 || offset > 33554428)) {
-		WARN_ON_ONCE(1);
+		WARN_ON_ONCE(warn);
 		return 0;
 	}
 
@@ -54,10 +55,10 @@ __arm_gen_branch_arm(unsigned long pc, unsigned long addr, bool link)
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

