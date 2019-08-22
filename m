Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E15B499B15
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731626AbfHVRTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:19:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390298AbfHVRIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:24 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A65823407;
        Thu, 22 Aug 2019 17:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493703;
        bh=RuOsYf5TN5Hw5cPbpR48OEF6lAqy3ny4adgENjVkcnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1hW+KQy4i5J/W/IpXHN4VBtriUHVCdnEc97faN+aGMJK2tsFtZt8qYZnM8cQJddPg
         zNt7i45Go6ZmqlHIxgSR7mTxZyHtpzCHg7nE4w+P9jWPBtA+U3D+fXYJck530yOBLT
         n9RuAUYoUsqc0loY0AikrnKkkbTdSBP9yjcvilOw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 016/135] arm64: ftrace: Ensure module ftrace trampoline is coherent with I-side
Date:   Thu, 22 Aug 2019 13:06:12 -0400
Message-Id: <20190822170811.13303-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 arch/arm64/kernel/ftrace.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
index 1285c7b2947fa..1717732579742 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -73,7 +73,7 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 
 	if (offset < -SZ_128M || offset >= SZ_128M) {
 #ifdef CONFIG_ARM64_MODULE_PLTS
-		struct plt_entry trampoline;
+		struct plt_entry trampoline, *dst;
 		struct module *mod;
 
 		/*
@@ -106,23 +106,27 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 		 * to check if the actual opcodes are in fact identical,
 		 * regardless of the offset in memory so use memcmp() instead.
 		 */
-		trampoline = get_plt_entry(addr, mod->arch.ftrace_trampoline);
-		if (memcmp(mod->arch.ftrace_trampoline, &trampoline,
-			   sizeof(trampoline))) {
-			if (plt_entry_is_initialized(mod->arch.ftrace_trampoline)) {
+		dst = mod->arch.ftrace_trampoline;
+		trampoline = get_plt_entry(addr, dst);
+		if (memcmp(dst, &trampoline, sizeof(trampoline))) {
+			if (plt_entry_is_initialized(dst)) {
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
2.20.1

