Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF9E59492D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243583AbiHOX2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245481AbiHOXZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:25:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA8DBA168;
        Mon, 15 Aug 2022 13:06:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4F3FB81135;
        Mon, 15 Aug 2022 20:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2CAC433D6;
        Mon, 15 Aug 2022 20:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593962;
        bh=1XOe91fxNjGIb2u9g3lgu/kzddDaw0ZvQ1Xl6XRc3yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evaDNqB9QF9C/jNwSjmm/FNDqg3wMpTnZwbnSXTvfERcQHx2E0uDQwCqTww+CbvWu
         BV5KBhriCOD26Dvp81jfrcON9T6JwCgHfAkguHNkatvZTathJqSHJ55nIUwCllxmje
         KZBm6RLVfbLrMGNJDyF/YLQxIK3lzz69F9fNi1ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1035/1095] powerpc/powernv/kvm: Use darn for H_RANDOM on Power9
Date:   Mon, 15 Aug 2022 20:07:14 +0200
Message-Id: <20220815180511.894527899@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit 7ef3d06f1bc4a5e62273726f3dc2bd258ae1c71f ]

The existing logic in KVM to support guests calling H_RANDOM only works
on Power8, because it looks for an RNG in the device tree, but on Power9
we just use darn.

In addition the existing code needs to work in real mode, so we have the
special cased powernv_get_random_real_mode() to deal with that.

Instead just have KVM call ppc_md.get_random_seed(), and do the real
mode check inside of there, that way we use whatever RNG is available,
including darn on Power9.

Fixes: e928e9cb3601 ("KVM: PPC: Book3S HV: Add fast real-mode H_RANDOM implementation.")
Cc: stable@vger.kernel.org # v4.1+
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Tested-by: Sachin Sant <sachinp@linux.ibm.com>
[mpe: Rebase on previous commit, update change log appropriately]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220727143219.2684192-2-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/archrandom.h |  5 ----
 arch/powerpc/kvm/book3s_hv_builtin.c  |  7 +++---
 arch/powerpc/platforms/powernv/rng.c  | 36 ++++++---------------------
 3 files changed, 12 insertions(+), 36 deletions(-)

diff --git a/arch/powerpc/include/asm/archrandom.h b/arch/powerpc/include/asm/archrandom.h
index 9a53e29680f4..258174304904 100644
--- a/arch/powerpc/include/asm/archrandom.h
+++ b/arch/powerpc/include/asm/archrandom.h
@@ -38,12 +38,7 @@ static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
 #endif /* CONFIG_ARCH_RANDOM */
 
 #ifdef CONFIG_PPC_POWERNV
-int powernv_hwrng_present(void);
 int powernv_get_random_long(unsigned long *v);
-int powernv_get_random_real_mode(unsigned long *v);
-#else
-static inline int powernv_hwrng_present(void) { return 0; }
-static inline int powernv_get_random_real_mode(unsigned long *v) { return 0; }
 #endif
 
 #endif /* _ASM_POWERPC_ARCHRANDOM_H */
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 7e52d0beee77..5e4251b76e75 100644
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
-	return powernv_hwrng_present();
+	return ppc_md.get_random_seed != NULL;
 }
 EXPORT_SYMBOL_GPL(kvmppc_hwrng_present);
 
 long kvmppc_rm_h_random(struct kvm_vcpu *vcpu)
 {
-	if (powernv_get_random_real_mode(&vcpu->arch.regs.gpr[4]))
+	if (ppc_md.get_random_seed &&
+	    ppc_md.get_random_seed(&vcpu->arch.regs.gpr[4]))
 		return H_SUCCESS;
 
 	return H_HARDWARE;
diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/powernv/rng.c
index 2287c9cd0cd5..d19305292e1e 100644
--- a/arch/powerpc/platforms/powernv/rng.c
+++ b/arch/powerpc/platforms/powernv/rng.c
@@ -29,15 +29,6 @@ struct powernv_rng {
 
 static DEFINE_PER_CPU(struct powernv_rng *, powernv_rng);
 
-int powernv_hwrng_present(void)
-{
-	struct powernv_rng *rng;
-
-	rng = get_cpu_var(powernv_rng);
-	put_cpu_var(rng);
-	return rng != NULL;
-}
-
 static unsigned long rng_whiten(struct powernv_rng *rng, unsigned long val)
 {
 	unsigned long parity;
@@ -58,19 +49,6 @@ static unsigned long rng_whiten(struct powernv_rng *rng, unsigned long val)
 	return val;
 }
 
-int powernv_get_random_real_mode(unsigned long *v)
-{
-	struct powernv_rng *rng;
-
-	rng = raw_cpu_read(powernv_rng);
-	if (!rng)
-		return 0;
-
-	*v = rng_whiten(rng, __raw_rm_readq(rng->regs_real));
-
-	return 1;
-}
-
 static int powernv_get_random_darn(unsigned long *v)
 {
 	unsigned long val;
@@ -107,12 +85,14 @@ int powernv_get_random_long(unsigned long *v)
 {
 	struct powernv_rng *rng;
 
-	rng = get_cpu_var(powernv_rng);
-
-	*v = rng_whiten(rng, in_be64(rng->regs));
-
-	put_cpu_var(rng);
-
+	if (mfmsr() & MSR_DR) {
+		rng = get_cpu_var(powernv_rng);
+		*v = rng_whiten(rng, in_be64(rng->regs));
+		put_cpu_var(rng);
+	} else {
+		rng = raw_cpu_read(powernv_rng);
+		*v = rng_whiten(rng, __raw_rm_readq(rng->regs_real));
+	}
 	return 1;
 }
 EXPORT_SYMBOL_GPL(powernv_get_random_long);
-- 
2.35.1



