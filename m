Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151C7562EF5
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 10:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbiGAIvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 04:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbiGAIvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 04:51:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD9C79686
        for <stable@vger.kernel.org>; Fri,  1 Jul 2022 01:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 51DAECE3294
        for <stable@vger.kernel.org>; Fri,  1 Jul 2022 08:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD48C3411E;
        Fri,  1 Jul 2022 08:50:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FwdFjxTl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656665406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jt0DBwx9fZMl77SqxscdIWBwpxLzf0kPqaNMNFd7NKA=;
        b=FwdFjxTlUirSrZlViur7stwpWIvQ1NXqK7nPpU+lXQc0pW3yIIy+FyTGoirRATfRqvESXC
        8MvQACYImfunswe2TeOjGAfPad77A0yuEDI9RNxoEGuTXxAojxzzQWGPMnlq5bdn8/+b/E
        B/3zhI2x8K0V6ww2+m6N7GU6KhDKa0M=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e1a9a9ec (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 1 Jul 2022 08:50:06 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sachin Sant <sachinp@linux.ibm.com>,
        christophe.leroy@csgroup.eu
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH v4 2/2] powerpc/kvm: don't crash on missing rng, and use darn
Date:   Fri,  1 Jul 2022 10:49:46 +0200
Message-Id: <20220701084946.225357-3-Jason@zx2c4.com>
In-Reply-To: <20220701084946.225357-1-Jason@zx2c4.com>
References: <20220701084946.225357-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On POWER8 systems that don't have ibm,power-rng available, a guest that
ignores the KVM_CAP_PPC_HWRNG flag and calls H_RANDOM anyway will
dereference a NULL pointer. And on machines with darn instead of
ibm,power-rng, H_RANDOM won't work at all.

This patch kills two birds with one stone, by routing H_RANDOM calls to
ppc_md.get_random_seed, and doing the real mode check inside of it.

Cc: stable@vger.kernel.org # v4.1+
Cc: Michael Ellerman <mpe@ellerman.id.au>
Fixes: e928e9cb3601 ("KVM: PPC: Book3S HV: Add fast real-mode H_RANDOM implementation.")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/powerpc/include/asm/archrandom.h |  5 ----
 arch/powerpc/kvm/book3s_hv_builtin.c  |  7 +++---
 arch/powerpc/platforms/powernv/rng.c  | 34 +++++++--------------------
 3 files changed, 12 insertions(+), 34 deletions(-)

diff --git a/arch/powerpc/include/asm/archrandom.h b/arch/powerpc/include/asm/archrandom.h
index 11d4815841ab..3af27bb84a3d 100644
--- a/arch/powerpc/include/asm/archrandom.h
+++ b/arch/powerpc/include/asm/archrandom.h
@@ -38,12 +38,7 @@ static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
 #endif /* CONFIG_ARCH_RANDOM */
 
 #ifdef CONFIG_PPC_POWERNV
-int pnv_hwrng_present(void);
 int pnv_get_random_long(unsigned long *v);
-int pnv_get_random_real_mode(unsigned long *v);
-#else
-static inline int pnv_hwrng_present(void) { return 0; }
-static inline int pnv_get_random_real_mode(unsigned long *v) { return 0; }
 #endif
 
 #endif /* _ASM_POWERPC_ARCHRANDOM_H */
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 799d40c2ab4f..3abaef5f9ac2 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -19,7 +19,7 @@
 #include <asm/interrupt.h>
 #include <asm/kvm_ppc.h>
 #include <asm/kvm_book3s.h>
-#include <asm/archrandom.h>
+#include <asm/machdep.h>
 #include <asm/xics.h>
 #include <asm/xive.h>
 #include <asm/dbell.h>
@@ -176,13 +176,14 @@ EXPORT_SYMBOL_GPL(kvmppc_hcall_impl_hv_realmode);
 
 int kvmppc_hwrng_present(void)
 {
-	return pnv_hwrng_present();
+	return ppc_md.get_random_seed != NULL;
 }
 EXPORT_SYMBOL_GPL(kvmppc_hwrng_present);
 
 long kvmppc_rm_h_random(struct kvm_vcpu *vcpu)
 {
-	if (pnv_get_random_real_mode(&vcpu->arch.regs.gpr[4]))
+	if (ppc_md.get_random_seed &&
+	    ppc_md.get_random_seed(&vcpu->arch.regs.gpr[4]))
 		return H_SUCCESS;
 
 	return H_HARDWARE;
diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/powernv/rng.c
index 386b44660e76..985e200183eb 100644
--- a/arch/powerpc/platforms/powernv/rng.c
+++ b/arch/powerpc/platforms/powernv/rng.c
@@ -29,15 +29,6 @@ struct pnv_rng {
 
 static DEFINE_PER_CPU(struct pnv_rng *, pnv_rng);
 
-int pnv_hwrng_present(void)
-{
-	struct pnv_rng *rng;
-
-	rng = get_cpu_var(pnv_rng);
-	put_cpu_var(rng);
-	return rng != NULL;
-}
-
 static unsigned long rng_whiten(struct pnv_rng *rng, unsigned long val)
 {
 	unsigned long parity;
@@ -58,17 +49,6 @@ static unsigned long rng_whiten(struct pnv_rng *rng, unsigned long val)
 	return val;
 }
 
-int pnv_get_random_real_mode(unsigned long *v)
-{
-	struct pnv_rng *rng;
-
-	rng = raw_cpu_read(pnv_rng);
-
-	*v = rng_whiten(rng, __raw_rm_readq(rng->regs_real));
-
-	return 1;
-}
-
 static int pnv_get_random_darn(unsigned long *v)
 {
 	unsigned long val;
@@ -105,12 +85,14 @@ int pnv_get_random_long(unsigned long *v)
 {
 	struct pnv_rng *rng;
 
-	rng = get_cpu_var(pnv_rng);
-
-	*v = rng_whiten(rng, in_be64(rng->regs));
-
-	put_cpu_var(rng);
-
+	if (mfmsr() & MSR_DR) {
+		rng = get_cpu_var(pnv_rng);
+		*v = rng_whiten(rng, in_be64(rng->regs));
+		put_cpu_var(rng);
+	} else {
+		rng = raw_cpu_read(pnv_rng);
+		*v = rng_whiten(rng, __raw_rm_readq(rng->regs_real));
+	}
 	return 1;
 }
 EXPORT_SYMBOL_GPL(pnv_get_random_long);
-- 
2.35.1

