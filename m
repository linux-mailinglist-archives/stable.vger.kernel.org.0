Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BC82B9E20
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgKSXXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbgKSXXK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:23:10 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D5CC0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:23:10 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id y7so5999925pfq.11
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bWcrbRU/HbDDlHLo1Ta7Xw/sbAYdfyto9pMsbv7Sjvo=;
        b=SPTMdpCGDnY0vrebt9WYBWY8giwQpezS3rJoxVDxjDY1TFhfCpI2tso1QUCtMIsNWb
         khxrC9yh1/6nPXVEOsIIGwzM3izDqZfPrfyuPnCCO0VERSMInUs1JjW+kXceXz9RUN2H
         fjLeU/TkkSAE7xfKMUtMZEbqaKm2wq+HA1Grg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bWcrbRU/HbDDlHLo1Ta7Xw/sbAYdfyto9pMsbv7Sjvo=;
        b=GOPDSNFMZBUilljyvdgaDHuXdL60ZEVX3JyWKR2Xl9RcpashZNHRtFuwDJGHuvoSjV
         Vo1wU5MHmsT9d91nwOYhejcwMEvflNiNqHBc1p1X6WIkMoxPBhaFJxNuFocaRMzj8z3v
         aC3tSvSwhbK09vhunbdikHuCy+ILASjtk1DAfPDj5ha0wHC3rXtKLGaL/x/WuiaJ24t1
         kIxfiFCaeoLaEnIqCCdDjOFqB3DFxZViKSU2QSoakST/Lsa8Vp91FTEYa5O5UAF6TG1O
         YPSEMDWDTrwAzFIaHvdsimfcz/5zRG/m7m+MeB93emclP/Qnmqf1iEY5K7fPCjSNJRQy
         JF7w==
X-Gm-Message-State: AOAM5339AQDan1z8b/8QixS67uDPFExmPIOPb9jhfVmMzdwjq5o7f9/1
        x8Tw5sgoxsjxm1uvUk864F14w3FQHTGRIQ==
X-Google-Smtp-Source: ABdhPJyPnWA6z2irdFOjFPiTdW41u3H9B1lN7fD1TYsPFncgpf32ZUfsLi23mfpMS2wKEw8rKsOCPg==
X-Received: by 2002:a17:90a:c254:: with SMTP id d20mr6896855pjx.112.1605828189500;
        Thu, 19 Nov 2020 15:23:09 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id n127sm1126805pfd.143.2020.11.19.15.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:23:09 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 5.9 4/5] powerpc: Only include kup-radix.h for 64-bit Book3S
Date:   Fri, 20 Nov 2020 10:22:49 +1100
Message-Id: <20201119232250.365304-5-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119232250.365304-1-dja@axtens.net>
References: <20201119232250.365304-1-dja@axtens.net>
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
requires some more stubs in kup.h and fixing an include in
syscall_64.c.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/include/asm/book3s/64/kup-radix.h |  4 ++--
 arch/powerpc/include/asm/kup.h                 | 11 ++++++++---
 arch/powerpc/kernel/syscall_64.c               |  2 +-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/kup-radix.h b/arch/powerpc/include/asm/book3s/64/kup-radix.h
index 97c2394e7dea..28716e2f13e3 100644
--- a/arch/powerpc/include/asm/book3s/64/kup-radix.h
+++ b/arch/powerpc/include/asm/book3s/64/kup-radix.h
@@ -27,6 +27,7 @@
 #endif
 .endm
 
+#ifdef CONFIG_PPC_KUAP
 .macro kuap_check_amr gpr1, gpr2
 #ifdef CONFIG_PPC_KUAP_DEBUG
 	BEGIN_MMU_FTR_SECTION_NESTED(67)
@@ -38,6 +39,7 @@
 	END_MMU_FTR_SECTION_NESTED_IFSET(MMU_FTR_RADIX_KUAP, 67)
 #endif
 .endm
+#endif
 
 .macro kuap_save_amr_and_lock gpr1, gpr2, use_cr, msr_pr_cr
 #ifdef CONFIG_PPC_KUAP
@@ -148,8 +150,6 @@ static inline unsigned long kuap_get_and_check_amr(void)
 	return 0UL;
 }
 
-static inline void kuap_check_amr(void) { }
-
 static inline unsigned long get_kuap(void)
 {
 	return AMR_KUAP_BLOCKED;
diff --git a/arch/powerpc/include/asm/kup.h b/arch/powerpc/include/asm/kup.h
index 0f5c606ae057..0d93331d0fab 100644
--- a/arch/powerpc/include/asm/kup.h
+++ b/arch/powerpc/include/asm/kup.h
@@ -14,7 +14,7 @@
 #define KUAP_CURRENT_WRITE	8
 #define KUAP_CURRENT		(KUAP_CURRENT_READ | KUAP_CURRENT_WRITE)
 
-#ifdef CONFIG_PPC64
+#ifdef CONFIG_PPC_BOOK3S_64
 #include <asm/book3s/64/kup-radix.h>
 #endif
 #ifdef CONFIG_PPC_8xx
@@ -35,6 +35,9 @@
 .macro kuap_check	current, gpr
 .endm
 
+.macro kuap_check_amr	gpr1, gpr2
+.endm
+
 #endif
 
 #else /* !__ASSEMBLY__ */
@@ -60,19 +63,21 @@ bad_kuap_fault(struct pt_regs *regs, unsigned long address, bool is_write)
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
 static inline unsigned long prevent_user_access_return(void) { return 0UL; }
 static inline void restore_user_access(unsigned long flags) { }
-#endif /* CONFIG_PPC64 */
+#endif /* CONFIG_PPC_BOOK3S_64 */
 #endif /* CONFIG_PPC_KUAP */
 
 static inline void allow_read_from_user(const void __user *from, unsigned long size)
diff --git a/arch/powerpc/kernel/syscall_64.c b/arch/powerpc/kernel/syscall_64.c
index 8e50818aa50b..310bcd768cd5 100644
--- a/arch/powerpc/kernel/syscall_64.c
+++ b/arch/powerpc/kernel/syscall_64.c
@@ -2,7 +2,7 @@
 
 #include <linux/err.h>
 #include <asm/asm-prototypes.h>
-#include <asm/book3s/64/kup-radix.h>
+#include <asm/kup.h>
 #include <asm/cputime.h>
 #include <asm/hw_irq.h>
 #include <asm/kprobes.h>
-- 
2.25.1

