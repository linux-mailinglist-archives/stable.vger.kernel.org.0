Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0826414E8B
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhIVRCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236786AbhIVRCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:02:47 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D904DC061766;
        Wed, 22 Sep 2021 10:01:16 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y4so3264376pfe.5;
        Wed, 22 Sep 2021 10:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MOhptkmv9edXrdiqH8+39RmWkP/z/b8cujzYFZjvDes=;
        b=pRveiJE6+GlxFGqLrBzhDKFMNX5sz+mbMWSxVNFvPgfMwJBTIK/rJr/hwTFSfgjKgX
         DYL9EMUSGVh1mEBTrV12XztrrWthkClPA93oJzR5i72Wt5q8DuN5Qf94TJnEcKWVRhoA
         Wdca4/wqbwDh3vTpB9D28mOPE5NyphgP8LmTBGytmJoY3pBHdV/MZJzQSl8ZXiCbSspL
         JaPGPeNWnHaVm8h8n7fvmYr4ChwNpFmCH+QVq9j3DOEq4kkmGsFP+zJzpBy1gRrNXx/o
         4eSXnUZU4rAjB5ZkpAsgB66c2aQPW1vB9UQ8pgutTR8Z0GwkwaMeQ4scZDVAcMF9vn+/
         Y5kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MOhptkmv9edXrdiqH8+39RmWkP/z/b8cujzYFZjvDes=;
        b=WXyuAfxqLoBNljVSB0UY7uQZSqMZO5ywNZY/fgpMcFMtByRVVWibp+o0iHwC9LWG8H
         BkMkJDbRHfqxhtcW7NwBFN8+jwLo/DJ5l56yzt55ZoJ3YqugvWogv2RiWwZTTflUjphY
         +V0Hwgg7VK40X1UNZrrkVhdgFgiVJcjlIuAgCB0FeDrrFRdgFz+4mClhhuLjZ/imDQHB
         +OFeSie3D3mEMocZ8qHhhHRdWucybnIqTIYUdOHTiM3gZesEt/0Y0NloLTXf2xIQOhmI
         lzH7yyxlJsgNYaYBiqUymxJwi+yTUj6gaA1dw9RLPocjR9jXEGBZQibNrSQolyNYIxVk
         QeIQ==
X-Gm-Message-State: AOAM531t4yoWvVABDf39VVlIdr5bG4QhqKRJ+n3IFEIZyTuc9nrTww1q
        VGPYlVJiz/DNPuk5ORFKx4uSLRUGCAk=
X-Google-Smtp-Source: ABdhPJy32RDbVZqoIviKU57hmX8WtQFtqQ2sU2bAwUY+mYMWKBAh1LVEoDJl7KOyYNaYjRGXfYhJZw==
X-Received: by 2002:a63:1902:: with SMTP id z2mr643615pgl.312.1632330076033;
        Wed, 22 Sep 2021 10:01:16 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i27sm3041404pfq.184.2021.09.22.10.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:01:15 -0700 (PDT)
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
Subject: [PATCH stable 5.4 v2 2/4] ARM: 9078/1: Add warn suppress parameter to arm_gen_branch_link()
Date:   Wed, 22 Sep 2021 10:00:32 -0700
Message-Id: <20210922170034.190023-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922170034.190023-1-f.fainelli@gmail.com>
References: <20210922170034.190023-1-f.fainelli@gmail.com>
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

