Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DA5259810
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgIAQWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731442AbgIAQWJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 12:22:09 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F1BC061244;
        Tue,  1 Sep 2020 09:22:09 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u128so1070023pfb.6;
        Tue, 01 Sep 2020 09:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q6HC5jotdEa1iojupPydaZwGs0KBLlCSLSyqAXdojd8=;
        b=m4RbtglF9uLIh7ocOiqxiP1hhbwkhURBNmBPRqarrbp9KyWcTlph+PR4P3YqcMEfO3
         Lk/27pqo56IqcaGVByJ+jpxuswzeqO6eSEUMZR3f8LVq6nEKzV+7XNrfvE/kp3TVQfdA
         HJqK3LgECrC/PSyV1Dmu7aX7pwqu5edk/gfned4Ql2kxFZ8vQU2DM8NbyhCh75GjRM5s
         yYixT1Tm0k6A+OMcMIiCKc1dXt5qg9hCpktcWXverIrKWwO/20x/dRWfK26d4jiSgaZY
         9JJJXi1sg+EfK4vfI+1awrIkltscpAtIOOIY1ZGbI6HzU7yRqQtVDTeB8oJoOOTwZg41
         gB5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q6HC5jotdEa1iojupPydaZwGs0KBLlCSLSyqAXdojd8=;
        b=Qdh++YGQz6HMRUlLAiWe06OqaAu97Cv/XnIfCzc3mYDPOyATai0aDjoWzn0lDoAS2T
         bdVh+S2gPBWNGbTP8zInL8orW3UmSXyF5Mt9XImIw2TW/byCnVgE7hV0ZG5zQ+x7Gxbp
         L5aeTEEj+UTPPLFCNsWSLGay4XKm0KUEdsJ6cZOFq6/tmVH1ma7f83Fitr21NZlkakF3
         xqzHk8frlMQCgHRYh6XOsXlxmBkbZpMUFTTvlFSzQq1vS3dqQruZvHrcNHhcS2AVVVvr
         J3mjhVzQi1jh/0t5rO10Rq9VrQLB7u+JgwHLRBOoCfQu/KGrIuvecscF/2J3Gf78nGjE
         CAHg==
X-Gm-Message-State: AOAM531oJkJNwdIVTK0j/Bq9Vgo9t97Hb72n7MPiCTcvs2q5LhTFpbRD
        QeeQ/vbNuJfpRk1Z/IKaVTopEPbk6AaR3w==
X-Google-Smtp-Source: ABdhPJxLZyZ6+2Gfa6deVwSK85gh+Yh6bXrcPZypidDu7HnfiOlTdfxQ5SKtqW4OsxYrx89hhcUdNA==
X-Received: by 2002:a63:110c:: with SMTP id g12mr2052631pgl.91.1598977328199;
        Tue, 01 Sep 2020 09:22:08 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id mw8sm1901888pjb.47.2020.09.01.09.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 09:22:06 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Cc:     Nadav Amit <namit@vmware.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org
Subject: [PATCH] x86/special_insn: reverse __force_order logic
Date:   Tue,  1 Sep 2020 09:18:57 -0700
Message-Id: <20200901161857.566142-1-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

The __force_order logic seems to be inverted. __force_order is
supposedly used to manipulate the compiler to use its memory
dependencies analysis to enforce orders between CR writes and reads.
Therefore, the memory should behave as a "CR": when the CR is read, the
memory should be "read" by the inline assembly, and __force_order should
be an output. When the CR is written, the memory should be "written".

This change should allow to remove the "volatile" qualifier from CR
reads at a later patch.

While at it, remove the extra new-line from the inline assembly, as it
only confuses GCC when it estimates the cost of the inline assembly.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Signed-off-by: Nadav Amit <namit@vmware.com>

---

Unless I misunderstand the logic, __force_order should also be used by
rdpkru() and wrpkru() which do not have dependency on __force_order. I
also did not understand why native_write_cr0() has R/W dependency on
__force_order, and why native_write_cr4() no longer has any dependency
on __force_order.
---
 arch/x86/include/asm/special_insns.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 5999b0b3dd4a..dff5e5b01a3c 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -24,32 +24,32 @@ void native_write_cr0(unsigned long val);
 static inline unsigned long native_read_cr0(void)
 {
 	unsigned long val;
-	asm volatile("mov %%cr0,%0\n\t" : "=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr0,%0" : "=r" (val) : "m" (__force_order));
 	return val;
 }
 
 static __always_inline unsigned long native_read_cr2(void)
 {
 	unsigned long val;
-	asm volatile("mov %%cr2,%0\n\t" : "=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr2,%0" : "=r" (val) : "m" (__force_order));
 	return val;
 }
 
 static __always_inline void native_write_cr2(unsigned long val)
 {
-	asm volatile("mov %0,%%cr2": : "r" (val), "m" (__force_order));
+	asm volatile("mov %1,%%cr2" : "=m" (__force_order) : "r" (val));
 }
 
 static inline unsigned long __native_read_cr3(void)
 {
 	unsigned long val;
-	asm volatile("mov %%cr3,%0\n\t" : "=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr3,%0" : "=r" (val) : "m" (__force_order));
 	return val;
 }
 
 static inline void native_write_cr3(unsigned long val)
 {
-	asm volatile("mov %0,%%cr3": : "r" (val), "m" (__force_order));
+	asm volatile("mov %1,%%cr3" : "=m" (__force_order) : "r" (val));
 }
 
 static inline unsigned long native_read_cr4(void)
@@ -64,10 +64,10 @@ static inline unsigned long native_read_cr4(void)
 	asm volatile("1: mov %%cr4, %0\n"
 		     "2:\n"
 		     _ASM_EXTABLE(1b, 2b)
-		     : "=r" (val), "=m" (__force_order) : "0" (0));
+		     : "=r" (val) : "m" (__force_order), "0" (0));
 #else
 	/* CR4 always exists on x86_64. */
-	asm volatile("mov %%cr4,%0\n\t" : "=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr4,%0" : "=r" (val) : "m" (__force_order));
 #endif
 	return val;
 }
-- 
2.25.1

