Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7612B29F3FF
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 19:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgJ2SUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 14:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgJ2SUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 14:20:00 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAC5C0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 11:19:58 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id n10so2595824plk.14
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 11:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=T3ma1Qme9sfSgFfmbVfimMuKf/8KN6t34PwJQ/OLZR4=;
        b=OIWq7obbwyuqQ56Q/ZI10sLGTFAImJtCMsZ7CpBcrSt+wQ/BHm0LUfEIQYS71gEO5+
         jr79EQdkIpfCxwZ0cYNzI3dcgFGoqfxqUyiFrLcGCW0hRGgaOfYUQ+IiU6ykOAfSglvu
         Z85Xev19pHYr7LJLAPjLmva5sl9zQN57K5VWB3+RxoZk/ukyaOzdXd/ysY0GYmyn0jJE
         /NM6qtGEUhT08T0M6XPmWDsXvZFv07X+kSbvl3B0PMuJTh7shC9gXsV9k9EE2wOaSSrq
         t6C3HBwggrixBsgop1oOUZa9zv6QN/9TJiigjMOGoj6RVwsk5LjAZpJ5GZiGacrjdVLg
         Q5LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=T3ma1Qme9sfSgFfmbVfimMuKf/8KN6t34PwJQ/OLZR4=;
        b=qSJiSfafvg7ybph3lxCD8cIWueAFRgRraxKaMb4MGUFl1ps7QCoTZQ/subdceTDb61
         pIYjVn+oNt/tzWI2b5/OhwUusHHKg97OZN3PsXtP3oxx/TmSl1ol5UIkwBEKmYLd4cK9
         Tks/1ukVWErC1TZMFTYwh5XOZnaqmg1wRTX7Yf/84tHzKIdnnVnhwlgtvUtD2Z8L+Vgh
         WNS2PHyUJ14usm0fsyIZtqr4LOeeVIqb/PBbpCEEoTnCcZRf37ON2HrittsPCaToKaoa
         JQEJbNvh/73tF2CK+2tVbn6O3Dj1nRSZ1muxrp+Xm9J5eSOpEvkBeeOla35KO5Puwme6
         am7Q==
X-Gm-Message-State: AOAM532z8m3GtpN7WKVpDm0AYcHEJeQ0KdaBcXfa4oyT2HM3X8mq8+Vg
        ZUlmyBGn6RJPdXIZ/Oaj7isqB6CHsS0e
X-Google-Smtp-Source: ABdhPJzbAxBUbWQjfF7B64iuL8b029PkHCk4plKT0cU6RIT583VAuy0/ZqhIswqU+5r5rHqPot5HAspJ3VBR
Sender: "maskray via sendgmr" <maskray@maskray1.svl.corp.google.com>
X-Received: from maskray1.svl.corp.google.com ([2620:15c:2ce:0:a6ae:11ff:fe11:4abb])
 (user=maskray job=sendgmr) by 2002:a62:1d10:0:b029:163:deb3:5df2 with SMTP id
 d16-20020a621d100000b0290163deb35df2mr5349788pfd.68.1603995598076; Thu, 29
 Oct 2020 11:19:58 -0700 (PDT)
Date:   Thu, 29 Oct 2020 11:19:51 -0700
Message-Id: <20201029181951.1866093-1-maskray@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [PATCH] arm64: Change .weak to SYM_FUNC_START_WEAK_PI for arch/arm64/lib/mem*.S
From:   Fangrui Song <maskray@google.com>
To:     linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     clang-built-linux@googlegroups.com, Jian Cai <jiancai@google.com>,
        Fangrui Song <maskray@google.com>,
        Sami Tolvanen <samitolvanen@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 39d114ddc682 ("arm64: add KASAN support") added .weak directives to
arch/arm64/lib/mem*.S instead of changing the existing SYM_FUNC_START_PI
macros. This can lead to the assembly snippet `.weak memcpy ... .globl
memcpy` which will produce a STB_WEAK memcpy with GNU as but STB_GLOBAL
memcpy with LLVM's integrated assembler before LLVM 12. LLVM 12 (since
https://reviews.llvm.org/D90108) will error on such an overridden symbol
binding.

Use the appropriate SYM_FUNC_START_WEAK_PI instead.

Fixes: 39d114ddc682 ("arm64: add KASAN support")
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Fangrui Song <maskray@google.com>
Cc: <stable@vger.kernel.org>
---
 arch/arm64/lib/memcpy.S  | 3 +--
 arch/arm64/lib/memmove.S | 3 +--
 arch/arm64/lib/memset.S  | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/lib/memcpy.S b/arch/arm64/lib/memcpy.S
index e0bf83d556f2..dc8d2a216a6e 100644
--- a/arch/arm64/lib/memcpy.S
+++ b/arch/arm64/lib/memcpy.S
@@ -56,9 +56,8 @@
 	stp \reg1, \reg2, [\ptr], \val
 	.endm
 
-	.weak memcpy
 SYM_FUNC_START_ALIAS(__memcpy)
-SYM_FUNC_START_PI(memcpy)
+SYM_FUNC_START_WEAK_PI(memcpy)
 #include "copy_template.S"
 	ret
 SYM_FUNC_END_PI(memcpy)
diff --git a/arch/arm64/lib/memmove.S b/arch/arm64/lib/memmove.S
index 02cda2e33bde..1035dce4bdaf 100644
--- a/arch/arm64/lib/memmove.S
+++ b/arch/arm64/lib/memmove.S
@@ -45,9 +45,8 @@ C_h	.req	x12
 D_l	.req	x13
 D_h	.req	x14
 
-	.weak memmove
 SYM_FUNC_START_ALIAS(__memmove)
-SYM_FUNC_START_PI(memmove)
+SYM_FUNC_START_WEAK_PI(memmove)
 	cmp	dstin, src
 	b.lo	__memcpy
 	add	tmp1, src, count
diff --git a/arch/arm64/lib/memset.S b/arch/arm64/lib/memset.S
index 77c3c7ba0084..a9c1c9a01ea9 100644
--- a/arch/arm64/lib/memset.S
+++ b/arch/arm64/lib/memset.S
@@ -42,9 +42,8 @@ dst		.req	x8
 tmp3w		.req	w9
 tmp3		.req	x9
 
-	.weak memset
 SYM_FUNC_START_ALIAS(__memset)
-SYM_FUNC_START_PI(memset)
+SYM_FUNC_START_WEAK_PI(memset)
 	mov	dst, dstin	/* Preserve return value.  */
 	and	A_lw, val, #255
 	orr	A_lw, A_lw, A_lw, lsl #8
-- 
2.29.1.341.ge80a0c044ae-goog

