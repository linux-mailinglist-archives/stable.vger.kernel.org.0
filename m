Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934E36673B6
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 14:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjALN4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 08:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbjALN4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 08:56:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC6D52764
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 05:56:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01C41B81E69
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 13:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3607AC433EF;
        Thu, 12 Jan 2023 13:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673531805;
        bh=AGAo3AR0flrq6xcytno6h8cvDIIgb0Zh3s5d693NTFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zhqnNnQRqFJ9QCGwTwhvOXNsg2iu0USgotYSZ1YoSEcrcn/zrHoTdeSxnHZ3O92dq
         zBfhv85rtm6K9AJ06n3EOLOn/rT0aQNh+ZbxYL6bj9a4fMxkOR20DAAiPvbqcrnVmr
         j7QGKV51x7abDg+Hwxc4b4vl97nb+F4UUUTGZBA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kyle Huey <me@kylehuey.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.1 03/10] x86/fpu: Add a pkru argument to copy_uabi_from_kernel_to_xstate().
Date:   Thu, 12 Jan 2023 14:56:24 +0100
Message-Id: <20230112135327.105135466@linuxfoundation.org>
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

commit 1c813ce0305571e1b2e4cc4acca451da9e6ad18f upstream.

Both KVM (through KVM_SET_XSTATE) and ptrace (through PTRACE_SETREGSET
with NT_X86_XSTATE) ultimately call copy_uabi_from_kernel_to_xstate(),
but the canonical locations for the current PKRU value for KVM guests
and processes in a ptrace stop are different (in the kvm_vcpu_arch and
the thread_state structs respectively).

In preparation for eventually handling PKRU in
copy_uabi_to_xstate, pass in a pointer to the PKRU location.

Signed-off-by: Kyle Huey <me@kylehuey.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20221115230932.7126-3-khuey%40kylehuey.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/core.c   |    2 +-
 arch/x86/kernel/fpu/regset.c |    2 +-
 arch/x86/kernel/fpu/xstate.c |    2 +-
 arch/x86/kernel/fpu/xstate.h |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -406,7 +406,7 @@ int fpu_copy_uabi_to_guest_fpstate(struc
 	if (ustate->xsave.header.xfeatures & ~xcr0)
 		return -EINVAL;
 
-	ret = copy_uabi_from_kernel_to_xstate(kstate, ustate);
+	ret = copy_uabi_from_kernel_to_xstate(kstate, ustate, vpkru);
 	if (ret)
 		return ret;
 
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -167,7 +167,7 @@ int xstateregs_set(struct task_struct *t
 	}
 
 	fpu_force_restore(fpu);
-	ret = copy_uabi_from_kernel_to_xstate(fpu->fpstate, kbuf ?: tmpbuf);
+	ret = copy_uabi_from_kernel_to_xstate(fpu->fpstate, kbuf ?: tmpbuf, &target->thread.pkru);
 
 out:
 	vfree(tmpbuf);
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1268,7 +1268,7 @@ static int copy_uabi_to_xstate(struct fp
  * Convert from a ptrace standard-format kernel buffer to kernel XSAVE[S]
  * format and copy to the target thread. Used by ptrace and KVM.
  */
-int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf)
+int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf, u32 *pkru)
 {
 	return copy_uabi_to_xstate(fpstate, kbuf, NULL);
 }
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -46,7 +46,7 @@ extern void __copy_xstate_to_uabi_buf(st
 				      u32 pkru_val, enum xstate_copy_mode copy_mode);
 extern void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
 				    enum xstate_copy_mode mode);
-extern int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf);
+extern int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf, u32 *pkru);
 extern int copy_sigframe_from_user_to_xstate(struct task_struct *tsk, const void __user *ubuf);
 
 


