Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB8F6673C5
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 14:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbjALN5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 08:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbjALN5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 08:57:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB26652C4A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 05:57:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26DAE62029
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 13:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABCCC433EF;
        Thu, 12 Jan 2023 13:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673531857;
        bh=vT/dtpDRQLmM5czaxIGgeUBTJ8Z0QAPzGzWDGlwa+UI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQtgIuNtwL6eD8NRwkRD09tMMFBSeb4BhXzoqigi5+gwG+kRe5IW/p2rX1DACErZX
         vhTmZi1ITnetdTzwQlbyLABIzx5VKs1USyijf1+BdtasyGLDjkYqFnmLzY4AJ+5x09
         WzCAXmlCiEGHzwk5KvTnk0xgfIIpadoNdeIqrH1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kyle Huey <me@kylehuey.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 5.15 05/10] x86/fpu: Allow PKRU to be (once again) written by ptrace.
Date:   Thu, 12 Jan 2023 14:56:42 +0100
Message-Id: <20230112135326.889112336@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
References: <20230112135326.689857506@linuxfoundation.org>
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

commit 4a804c4f8356393d6b5eff7600f07615d7869c13 upstream

Handle PKRU in copy_uabi_to_xstate() for the benefit of APIs that write
the XSTATE such as PTRACE_SETREGSET with NT_X86_XSTATE.

This restores the pre-5.14 behavior of ptrace. The regression can be seen
by running gdb and executing `p $pkru`, `set $pkru = 42`, and `p $pkru`.
On affected kernels (5.14+) the write to the PKRU register (which gdb
performs through ptrace) is ignored.

Fixes: e84ba47e313d ("x86/fpu: Hook up PKRU into ptrace()")
Signed-off-by: Kyle Huey <me@kylehuey.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20221115230932.7126-5-khuey%40kylehuey.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/xstate.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1091,6 +1091,29 @@ static int copy_from_buffer(void *dst, u
 }
 
 
+/**
+ * copy_uabi_to_xstate - Copy a UABI format buffer to the kernel xstate
+ * @fpstate:	The fpstate buffer to copy to
+ * @kbuf:	The UABI format buffer, if it comes from the kernel
+ * @ubuf:	The UABI format buffer, if it comes from userspace
+ * @pkru:	The location to write the PKRU value to
+ *
+ * Converts from the UABI format into the kernel internal hardware
+ * dependent format.
+ *
+ * This function ultimately has two different callers with distinct PKRU
+ * behavior.
+ * 1.	When called from sigreturn the PKRU register will be restored from
+ *	@fpstate via an XRSTOR. Correctly copying the UABI format buffer to
+ *	@fpstate is sufficient to cover this case, but the caller will also
+ *	pass a pointer to the thread_struct's pkru field in @pkru and updating
+ *	it is harmless.
+ * 2.	When called from ptrace the PKRU register will be restored from the
+ *	thread_struct's pkru field. A pointer to that is passed in @pkru.
+ *	The kernel will restore it manually, so the XRSTOR behavior that resets
+ *	the PKRU register to the hardware init value (0) if the corresponding
+ *	xfeatures bit is not set is emulated here.
+ */
 static int copy_uabi_to_xstate(struct xregs_state *xsave, const void *kbuf,
 			       const void __user *ubuf, u32 *pkru)
 {
@@ -1140,6 +1163,13 @@ static int copy_uabi_to_xstate(struct xr
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


