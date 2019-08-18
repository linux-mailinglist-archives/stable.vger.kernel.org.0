Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9A3914CC
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 06:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfHREz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 00:55:56 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41995 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725209AbfHREzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 00:55:55 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D1C7421C7A;
        Sun, 18 Aug 2019 00:55:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 18 Aug 2019 00:55:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=mZMbvQ
        okMHZShwwqyaiRTM9V6dKzBd+wXi/+uFAOQfo=; b=gCWSx88h8ED2Ce263EiDts
        JZzYXgvWNopSZwAC0rh1V1CXehbVf1/QJpsvBFd8N36dV9/IS/KRx2dH4xOBnMlq
        OvkubKpo0SNfnRgkp5PujLhGESnUou7WTzj0VVa8NJLI+fW/bSos6R4bdO1+EITj
        CNyciVKAdYufyTcEAmFlX7aPz8q8DVFUPM5ardOzZtQQJFXKRRKIRjlR5qBpj2WN
        89COiXkm0bcDnlqd7RFgt1tojyBFEebfbxPAKbMBzD9YvQJBEJb4xNeooelSHMNy
        AVU2icrEartUkMb59stkydQ502/gqNlgNa3w9pkoxQCEKhwRIySC6J+i8MbjOqBg
        ==
X-ME-Sender: <xms:WdpYXfNkdcHLa9dA7USofsAjnQkmScZsGakIYMoHWQC93DVIPGBECg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefiedgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:WdpYXVZf-6AbepoqgZ1pBAsIRQoz-wQqTl6IBzZvqhF3Xlt-PRq6mA>
    <xmx:WdpYXc8B6Ck6fXQoCl02MGzj-BfIG2BdSTGT-kTHlizh783Ggh7Nnw>
    <xmx:WdpYXQ3u3s4PHSWUsZXtbgPz9rIstL9xDOUaM3ZByTGqtDEITvtYMg>
    <xmx:WtpYXQJVuazyKc2eYdTkfsByvlVuRngrDGcMIksDizgpVHe_fiazCw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7E4FB8005C;
        Sun, 18 Aug 2019 00:55:53 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: ftrace: Ensure module ftrace trampoline is coherent" failed to apply to 4.19-stable tree
To:     will@kernel.org, ard.biesheuvel@linaro.org,
        catalin.marinas@arm.com, james.morse@arm.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Aug 2019 06:55:51 +0200
Message-ID: <1566104151209237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b6143d10d23ebb4a77af311e8b8b7f019d0163e6 Mon Sep 17 00:00:00 2001
From: Will Deacon <will@kernel.org>
Date: Fri, 16 Aug 2019 14:57:43 +0100
Subject: [PATCH] arm64: ftrace: Ensure module ftrace trampoline is coherent
 with I-side

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

diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
index 1285c7b2947f..171773257974 100644
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

