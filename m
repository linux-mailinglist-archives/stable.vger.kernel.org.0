Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25934413FA3
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 04:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhIVCmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 22:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbhIVCmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 22:42:50 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62355C061574;
        Tue, 21 Sep 2021 19:41:21 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id a7so797326plm.1;
        Tue, 21 Sep 2021 19:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xCDJzp7o//FBYvMVwfext1aA4OICggdeJGjPIrVfglU=;
        b=QtM4CaAyj8uDsx8mZA43x0q0e4jcmYj8upMtqdhW9zTpYS5cJTdT8TK5WGKbzn2yU/
         lrPkSfwEwx0cIUUuvwv8t4d6PI8QhVNi/YPumoxrgoQXIrCkxR11+uYvMfG2SPjhsUMh
         pVyq/x5+I/Ht+OBo7iqJSF/4+MVzlznLdn6NjNzaAsdNfL1tKLXpbcPNrm/QXLLToPUr
         DQOI9o9WrmAKAHx6gtVI0Df7p3sYVKbvu0bH3OMTKjhuWxH34A7wnrmFS52jfhdQooFD
         zG3S6Fam2irN8/ELuPWGkbRC2ud1soah4JAn3nFuDiDEd7AWoB9SOJaT10CwZlGB0oRo
         BqMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xCDJzp7o//FBYvMVwfext1aA4OICggdeJGjPIrVfglU=;
        b=GMBtr6S55MND951mmMpBUErxvJ3Tm3P2kH75YIAMbPy+jaH0vmAXr/ZyCFSHnfnns6
         bhuP5I/Pls5IT1nEEfjT0UvMprvoloZ13fvqVm4pkzMgmdPP2Vo07x8A8U97+hbar2k7
         rtprcNlJCAEmvMLUM/2SKYGpNEhF5g4vbVkEl8+k9ZTBP3qWP60hXx4AWlQrdB/LNxb8
         9OF1vn8Bl6hpvWtjZGn6VKRmhQSi18cS7zQOhEOFu+Loygt21Xv9qk15Btg5ynU1Z1+h
         t+ggwkmVo1yk7+K/zb5GCtYfkQKU+p7siW2vBncV4KhYAVetvpmyQ4BxaCElPI4cmOfY
         5MVg==
X-Gm-Message-State: AOAM532Txkv8ErCko7WosgmCgVOSF0RxHRtHxgwMp9a5zJsj3+WzNr59
        puQIWEEgFc4F2VxeI8LAVczqjaR7weA=
X-Google-Smtp-Source: ABdhPJwzYkUnxy3hI4AFywtHN9UgautumQOxpAXwahQaCu75Rc9QLCxle/WVcZdhbQfUcVmZ3HSywQ==
X-Received: by 2002:a17:90a:cc6:: with SMTP id 6mr8810446pjt.233.1632278480610;
        Tue, 21 Sep 2021 19:41:20 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f24sm426309pfk.198.2021.09.21.19.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 19:41:20 -0700 (PDT)
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
Subject: [PATCH stable 4.19 2/3] ARM: 9078/1: Add warn suppress parameter to arm_gen_branch_link()
Date:   Tue, 21 Sep 2021 19:40:47 -0700
Message-Id: <20210922024048.59818-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922024048.59818-1-f.fainelli@gmail.com>
References: <20210922024048.59818-1-f.fainelli@gmail.com>
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
index ee673c09aa6c..05bf124ae324 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -98,7 +98,7 @@ int ftrace_arch_code_modify_post_process(void)
 
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

