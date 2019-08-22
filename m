Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C62999B9D
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404610AbfHVR0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:26:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404603AbfHVR0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:26:06 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD1F9206DD;
        Thu, 22 Aug 2019 17:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494765;
        bh=sRrp4AB5ZZgmgXo65N7/Viju2DCUUVDpt6ASET+gznA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z17/3clyvxm5nlhXTRmEnMrpX0mXIrdvI8oZaumun4bsfiDmpSlSdEp7EQiqWC0xf
         W3+Ha0/qOP6XyV+evJc0fH+x8ZjtuPlJrZVsloUAD6+0Qum1H+p5/s/JBjZbLLWyWm
         zfZe9wnujRxCXEJVe75+PWsAjoJHRH0qtTecDU9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 4.19 69/85] arm64: ftrace: Ensure module ftrace trampoline is coherent with I-side
Date:   Thu, 22 Aug 2019 10:19:42 -0700
Message-Id: <20190822171734.175450632@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

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
Cc: <stable@vger.kernel.org>
Fixes: be0f272bfc83 ("arm64: ftrace: emit ftrace-mod.o contents through code")
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/ftrace.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -76,7 +76,7 @@ int ftrace_make_call(struct dyn_ftrace *
 
 	if (offset < -SZ_128M || offset >= SZ_128M) {
 #ifdef CONFIG_ARM64_MODULE_PLTS
-		struct plt_entry trampoline;
+		struct plt_entry trampoline, *dst;
 		struct module *mod;
 
 		/*
@@ -104,24 +104,27 @@ int ftrace_make_call(struct dyn_ftrace *
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


