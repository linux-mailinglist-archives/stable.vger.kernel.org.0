Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1752C6673B7
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 14:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbjALN46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 08:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbjALN4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 08:56:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC0251335
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 05:56:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1011462028
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 13:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EFBC433F1;
        Thu, 12 Jan 2023 13:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673531811;
        bh=XouAg2s8QhvLGOZ4yfc+t6LDkh27XCDj622NrYl6mUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d3mkBTr15rTTPQPoz8LvcDKPBZabeulf5k3FPhKIZP4l/3/Gkr5kVjIF9+uCTbscf
         NKHi14YFP6O6ohQv5hmAi+oypbVi8VpCsDZ4Kv5ekQ0n0kdWvxnboKYB17eQOrhbXa
         Vt+DJkKGl83d3IZdUCc1ynkeavy3P8JilPIyhAmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kyle Huey <me@kylehuey.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.1 05/10] x86/fpu: Allow PKRU to be (once again) written by ptrace.
Date:   Thu, 12 Jan 2023 14:56:26 +0100
Message-Id: <20230112135327.204089106@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>
References: <20230112135326.981869724@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Huey <me@kylehuey.com>

commit 4a804c4f8356393d6b5eff7600f07615d7869c13 upstream.

Move KVM's PKRU handling code in fpu_copy_uabi_to_guest_fpstate() to
copy_uabi_to_xstate() so that it is shared with other APIs that write the
XSTATE such as PTRACE_SETREGSET with NT_X86_XSTATE.

This restores the pre-5.14 behavior of ptrace. The regression can be seen
by running gdb and executing `p $pkru`, `set $pkru = 42`, and `p $pkru`.
On affected kernels (5.14+) the write to the PKRU register (which gdb
performs through ptrace) is ignored.

[ dhansen: removed stable@ tag for now.  The ABI was broken for long
	   enough that this is not urgent material.  Let's let it stew
	   in tip for a few weeks before it's submitted to stable
	   because there are so many ABIs potentially affected. ]

Fixes: e84ba47e313d ("x86/fpu: Hook up PKRU into ptrace()")
Signed-off-by: Kyle Huey <me@kylehuey.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20221115230932.7126-5-khuey%40kylehuey.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/core.c   |   13 +------------
 arch/x86/kernel/fpu/xstate.c |   21 ++++++++++++++++++++-
 2 files changed, 21 insertions(+), 13 deletions(-)

--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -391,8 +391,6 @@ int fpu_copy_uabi_to_guest_fpstate(struc
 {
 	struct fpstate *kstate = gfpu->fpstate;
 	const union fpregs_state *ustate = buf;
-	struct pkru_state *xpkru;
-	int ret;
 
 	if (!cpu_feature_enabled(X86_FEATURE_XSAVE)) {
 		if (ustate->xsave.header.xfeatures & ~XFEATURE_MASK_FPSSE)
@@ -406,16 +404,7 @@ int fpu_copy_uabi_to_guest_fpstate(struc
 	if (ustate->xsave.header.xfeatures & ~xcr0)
 		return -EINVAL;
 
-	ret = copy_uabi_from_kernel_to_xstate(kstate, ustate, vpkru);
-	if (ret)
-		return ret;
-
-	/* Retrieve PKRU if not in init state */
-	if (kstate->regs.xsave.header.xfeatures & XFEATURE_MASK_PKRU) {
-		xpkru = get_xsave_addr(&kstate->regs.xsave, XFEATURE_PKRU);
-		*vpkru = xpkru->pkru;
-	}
-	return 0;
+	return copy_uabi_from_kernel_to_xstate(kstate, ustate, vpkru);
 }
 EXPORT_SYMBOL_GPL(fpu_copy_uabi_to_guest_fpstate);
 #endif /* CONFIG_KVM */
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1205,10 +1205,22 @@ static int copy_from_buffer(void *dst, u
  * @fpstate:	The fpstate buffer to copy to
  * @kbuf:	The UABI format buffer, if it comes from the kernel
  * @ubuf:	The UABI format buffer, if it comes from userspace
- * @pkru:	unused
+ * @pkru:	The location to write the PKRU value to
  *
  * Converts from the UABI format into the kernel internal hardware
  * dependent format.
+ *
+ * This function ultimately has three different callers with distinct PKRU
+ * behavior.
+ * 1.	When called from sigreturn the PKRU register will be restored from
+ *	@fpstate via an XRSTOR. Correctly copying the UABI format buffer to
+ *	@fpstate is sufficient to cover this case, but the caller will also
+ *	pass a pointer to the thread_struct's pkru field in @pkru and updating
+ *	it is harmless.
+ * 2.	When called from ptrace the PKRU register will be restored from the
+ *	thread_struct's pkru field. A pointer to that is passed in @pkru.
+ * 3.	When called from KVM the PKRU register will be restored from the vcpu's
+ *	pkru field. A pointer to that is passed in @pkru.
  */
 static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
 			       const void __user *ubuf, u32 *pkru)
@@ -1260,6 +1272,13 @@ static int copy_uabi_to_xstate(struct fp
 		}
 	}
 
+	if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
+		struct pkru_state *xpkru;
+
+		xpkru = __raw_xsave_addr(xsave, XFEATURE_PKRU);
+		*pkru = xpkru->pkru;
+	}
+
 	/*
 	 * The state that came in from userspace was user-state only.
 	 * Mask all the user states out of 'xfeatures':


