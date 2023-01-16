Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D052866C91F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbjAPQqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233835AbjAPQps (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:45:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D3912586
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:33:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB20C6105A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6388C43392;
        Mon, 16 Jan 2023 16:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886820;
        bh=J+1hrDXm2brenQHcYdtgG270aR28gzRUgcGRM7DNc74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FNYJEJ8sC/EoiwYOWNVZ4+fxKoChfYfNhxkE8+SJ9vP8xhtDiU1WJSP4JYU8TkHwT
         rTRBPPlSvVg7YzYf2zL8EphDb/2EaBP2Gfan6TyLcC6vUCk7wSSW8vMW+L0ryB5pUk
         aq0WKdORPwx16BAruhBOUEyN4SxCf02mUa5wMPQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 547/658] KVM: retpolines: x86: eliminate retpoline from vmx.c exit handlers
Date:   Mon, 16 Jan 2023 16:50:35 +0100
Message-Id: <20230116154934.559033359@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Andrea Arcangeli <aarcange@redhat.com>

[ Upstream commit 4289d2728664fc1fb49cfc76a6a7d96d913b921f ]

It's enough to check the exit value and issue a direct call to avoid
the retpoline for all the common vmexit reasons.

Of course CONFIG_RETPOLINE already forbids gcc to use indirect jumps
while compiling all switch() statements, however switch() would still
allow the compiler to bisect the case value. It's more efficient to
prioritize the most frequent vmexits instead.

The halt may be slow paths from the point of the guest, but not
necessarily so from the point of the host if the host runs at full CPU
capacity and no host CPU is ever left idle.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 31de69f4eea7 ("KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE control to L1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0fae9b448ab9..668505c6abe9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6015,9 +6015,23 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 	}
 
 	if (exit_reason < kvm_vmx_max_exit_handlers
-	    && kvm_vmx_exit_handlers[exit_reason])
+	    && kvm_vmx_exit_handlers[exit_reason]) {
+#ifdef CONFIG_RETPOLINE
+		if (exit_reason == EXIT_REASON_MSR_WRITE)
+			return kvm_emulate_wrmsr(vcpu);
+		else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
+			return handle_preemption_timer(vcpu);
+		else if (exit_reason == EXIT_REASON_PENDING_INTERRUPT)
+			return handle_interrupt_window(vcpu);
+		else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+			return handle_external_interrupt(vcpu);
+		else if (exit_reason == EXIT_REASON_HLT)
+			return kvm_emulate_halt(vcpu);
+		else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
+			return handle_ept_misconfig(vcpu);
+#endif
 		return kvm_vmx_exit_handlers[exit_reason](vcpu);
-	else {
+	} else {
 		vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
 				exit_reason);
 		dump_vmcs();
-- 
2.35.1



