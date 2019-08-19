Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D92189212C
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 12:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfHSKST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 06:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbfHSKSS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 06:18:18 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F502205F4;
        Mon, 19 Aug 2019 10:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566209897;
        bh=EuGO5/YFhcXi4XkupmrHnxRbGMPPIRyvMKQ5Q8AUvhs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mViy/huc5TAS6T5hvJ6pm7+hk4U+QFVMpdwdPVgiVDv1TxnXHKGWD5rg9hCQRC90k
         yX8ganFmOhYvaKezzOs5ovw7ly/4VJFlz2Zs/1PIi/9IHxORIRmDiBbTTB1Qp96cm2
         pVIrgZYFYKsH4gpro8dTADpmSmA5Xo0bidnYA++k=
Date:   Mon, 19 Aug 2019 11:18:13 +0100
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     ard.biesheuvel@linaro.org, catalin.marinas@arm.com,
        james.morse@arm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: ftrace: Ensure module ftrace
 trampoline is coherent" failed to apply to 4.19-stable tree
Message-ID: <20190819101812.mjsxapifzzvhrxv5@willie-the-truck>
References: <1566104151209237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566104151209237@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 18, 2019 at 06:55:51AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Backport to 4.19 below. Thanks,

Will

--->8

From db621425c314916815fd9a25d4d1213f80b7f2ef Mon Sep 17 00:00:00 2001
From: Will Deacon <will@kernel.org>
Date: Fri, 16 Aug 2019 14:57:43 +0100
Subject: [PATCH] arm64: ftrace: Ensure module ftrace trampoline is coherent
 with I-side

commit b6143d10d23ebb4a77af311e8b8b7f019d0163e6 upstream.

The initial support for dynamic ftrace trampolines in modules made use
of an indirect branch which loaded its target from the beginning of
a special section (e71a4e1bebaf7 ("arm64: ftrace: add support for far
branches to dynamic ftrace")). Since no instructions were being patched,
no cache maintenance was needed. However, later in be0f272bfc83 ("arm64:
ftrace: emit ftrace-mod.o contents through code") this code was reworked
to output the trampoline instructions directly into the PLT entry but,
unfortunately, the necessary cache maintenance was overlooked.

Add a call to __flush_icache_range() after writing the new trampoline
instructions but before patching in the branch to the trampoline.

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: James Morse <james.morse@arm.com>
Cc: <stable@vger.kernel.org> # 4.19.y only
Fixes: be0f272bfc83 ("arm64: ftrace: emit ftrace-mod.o contents through code")
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/kernel/ftrace.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
index 57e962290df3..7eff8afa035f 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -76,7 +76,7 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 
 	if (offset < -SZ_128M || offset >= SZ_128M) {
 #ifdef CONFIG_ARM64_MODULE_PLTS
-		struct plt_entry trampoline;
+		struct plt_entry trampoline, *dst;
 		struct module *mod;
 
 		/*
@@ -104,24 +104,27 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 		 * is added in the future, but for now, the pr_err() below
 		 * deals with a theoretical issue only.
 		 */
+		dst = mod->arch.ftrace_trampoline;
 		trampoline = get_plt_entry(addr);
-		if (!plt_entries_equal(mod->arch.ftrace_trampoline,
-				       &trampoline)) {
-			if (!plt_entries_equal(mod->arch.ftrace_trampoline,
-					       &(struct plt_entry){})) {
+		if (!plt_entries_equal(dst, &trampoline)) {
+			if (!plt_entries_equal(dst, &(struct plt_entry){})) {
 				pr_err("ftrace: far branches to multiple entry points unsupported inside a single module\n");
 				return -EINVAL;
 			}
 
 			/* point the trampoline to our ftrace entry point */
 			module_disable_ro(mod);
-			*mod->arch.ftrace_trampoline = trampoline;
+			*dst = trampoline;
 			module_enable_ro(mod, true);
 
-			/* update trampoline before patching in the branch */
-			smp_wmb();
+			/*
+			 * Ensure updated trampoline is visible to instruction
+			 * fetch before we patch in the branch.
+			 */
+			__flush_icache_range((unsigned long)&dst[0],
+					     (unsigned long)&dst[1]);
 		}
-		addr = (unsigned long)(void *)mod->arch.ftrace_trampoline;
+		addr = (unsigned long)dst;
 #else /* CONFIG_ARM64_MODULE_PLTS */
 		return -EINVAL;
 #endif /* CONFIG_ARM64_MODULE_PLTS */
-- 
2.11.0

