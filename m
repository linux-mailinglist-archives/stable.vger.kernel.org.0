Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046802B9E68
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgKSXfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgKSXfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:35:36 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9445C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:35:36 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id w4so5649185pgg.13
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=le6bfl2MFnr+y+rh+hRNzSCQkeZEnm3XPO8gVGY5TaU=;
        b=nwJ7JRnQrQ25jM97SMK/MFcLGkhcO6teD0PumxqMl5PIXOa5TZab6jYUW3QFXaYJ9z
         dG8rZTI+CE73mRn3ZDjSs+N5nbSXOUIPfvDDOOEe7JCGpwgD+H3I+xPWlWYmdZ+IYsVf
         vDkEEp9WZzdsJLwYvq0I1szPnnu25He6NVKPI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=le6bfl2MFnr+y+rh+hRNzSCQkeZEnm3XPO8gVGY5TaU=;
        b=FNs2BvqQYU35b8h6wt5Q+zY2rjrfoilbB0qO4SD+4rQJSa2C2Xc3Or5jydJciYdatC
         /HNSirGmr0/x4oCjSGbeLKzeSWIt6DnGNWcKEDE2sL7eeNYrLBdBhqWvuWajFdysWsjn
         gWyJkKRQCxqPjWdu+eBmHQ3JkjVij2ntC0XOqRJFZN2wSFAtfP9BuMhqL/n4ZSZ6f5h1
         x8qccUDpQnYMM//NSxtlhOFFaCQ7EcLO3lVt+p0cUvI7zI20N/uiVaMKgsiUa/fv9VYc
         MQTT2HHlUMI6ElqFXENxwws6hOwEwjHizJanZP3vj4QOYNGv2XY3uCI5GP3EQjwDpzem
         KbNg==
X-Gm-Message-State: AOAM533XF7uyyRQyAqMkxtp8V+BNlxo3wtUWZN5/c5SqBEM0lJVWJKuf
        z/DfypMkuTld+aTeOGFx8K3Lp4gdx8z9Gw==
X-Google-Smtp-Source: ABdhPJwDF8biK9zytPZeE8/+k9AvD2N/ven8bxV0/Nu5a8wHdTOG++KAAswNKlZ5nkZzgQSASkthgA==
X-Received: by 2002:a17:90a:1b41:: with SMTP id q59mr6871286pjq.17.1605828936135;
        Thu, 19 Nov 2020 15:35:36 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id fz5sm890456pjb.49.2020.11.19.15.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:35:35 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 5.4 4/5] powerpc: Only include kup-radix.h for 64-bit Book3S
Date:   Fri, 20 Nov 2020 10:35:15 +1100
Message-Id: <20201119233516.368194-5-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119233516.368194-1-dja@axtens.net>
References: <20201119233516.368194-1-dja@axtens.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 178d52c6e89c38d0553b0ac8b99927b11eb995b0 upstream.

In kup.h we currently include kup-radix.h for all 64-bit builds, which
includes Book3S and Book3E. The latter doesn't make sense, Book3E
never uses the Radix MMU.

This has worked up until now, but almost by accident, and the recent
uaccess flush changes introduced a build breakage on Book3E because of
the bad structure of the code.

So disentangle things so that we only use kup-radix.h for Book3S. This
requires some more stubs in kup.h.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 arch/powerpc/include/asm/book3s/64/kup-radix.h |  5 +++--
 arch/powerpc/include/asm/kup.h                 | 14 +++++++++++---
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/kup-radix.h b/arch/powerpc/include/asm/book3s/64/kup-radix.h
index 394931798550..c1e45f510591 100644
--- a/arch/powerpc/include/asm/book3s/64/kup-radix.h
+++ b/arch/powerpc/include/asm/book3s/64/kup-radix.h
@@ -11,13 +11,12 @@
 
 #ifdef __ASSEMBLY__
 
-.macro kuap_restore_amr	gpr
 #ifdef CONFIG_PPC_KUAP
+.macro kuap_restore_amr	gpr
 	BEGIN_MMU_FTR_SECTION_NESTED(67)
 	ld	\gpr, STACK_REGS_KUAP(r1)
 	mtspr	SPRN_AMR, \gpr
 	END_MMU_FTR_SECTION_NESTED_IFSET(MMU_FTR_RADIX_KUAP, 67)
-#endif
 .endm
 
 .macro kuap_check_amr gpr1, gpr2
@@ -31,6 +30,7 @@
 	END_MMU_FTR_SECTION_NESTED_IFSET(MMU_FTR_RADIX_KUAP, 67)
 #endif
 .endm
+#endif
 
 .macro kuap_save_amr_and_lock gpr1, gpr2, use_cr, msr_pr_cr
 #ifdef CONFIG_PPC_KUAP
@@ -87,6 +87,7 @@ bad_kuap_fault(struct pt_regs *regs, unsigned long address, bool is_write)
 		    "Bug: %s fault blocked by AMR!", is_write ? "Write" : "Read");
 }
 #else /* CONFIG_PPC_KUAP */
+static inline void kuap_restore_amr(struct pt_regs *regs, unsigned long amr) { }
 static inline void set_kuap(unsigned long value) { }
 #endif /* !CONFIG_PPC_KUAP */
 
diff --git a/arch/powerpc/include/asm/kup.h b/arch/powerpc/include/asm/kup.h
index 8f4d27980003..ed4f5f536fc1 100644
--- a/arch/powerpc/include/asm/kup.h
+++ b/arch/powerpc/include/asm/kup.h
@@ -6,7 +6,7 @@
 #define KUAP_WRITE	2
 #define KUAP_READ_WRITE	(KUAP_READ | KUAP_WRITE)
 
-#ifdef CONFIG_PPC64
+#ifdef CONFIG_PPC_BOOK3S_64
 #include <asm/book3s/64/kup-radix.h>
 #endif
 #ifdef CONFIG_PPC_8xx
@@ -24,9 +24,15 @@
 .macro kuap_restore	sp, current, gpr1, gpr2, gpr3
 .endm
 
+.macro kuap_restore_amr gpr
+.endm
+
 .macro kuap_check	current, gpr
 .endm
 
+.macro kuap_check_amr	gpr1, gpr2
+.endm
+
 #endif
 
 #else /* !__ASSEMBLY__ */
@@ -52,17 +58,19 @@ bad_kuap_fault(struct pt_regs *regs, unsigned long address, bool is_write)
 	return false;
 }
 
+static inline void kuap_check_amr(void) { }
+
 /*
  * book3s/64/kup-radix.h defines these functions for the !KUAP case to flush
  * the L1D cache after user accesses. Only include the empty stubs for other
  * platforms.
  */
-#ifndef CONFIG_PPC64
+#ifndef CONFIG_PPC_BOOK3S_64
 static inline void allow_user_access(void __user *to, const void __user *from,
 				     unsigned long size, unsigned long dir) { }
 static inline void prevent_user_access(void __user *to, const void __user *from,
 				       unsigned long size, unsigned long dir) { }
-#endif /* CONFIG_PPC64 */
+#endif /* CONFIG_PPC_BOOK3S_64 */
 #endif /* CONFIG_PPC_KUAP */
 
 static inline void allow_read_from_user(const void __user *from, unsigned long size)
-- 
2.25.1

