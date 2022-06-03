Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BB253D040
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346087AbiFCSBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346702AbiFCSAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:00:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAD41EEC5;
        Fri,  3 Jun 2022 10:56:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B970615DA;
        Fri,  3 Jun 2022 17:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEDCC385A9;
        Fri,  3 Jun 2022 17:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654279009;
        bh=DLAtzt7prpBftpea8sCEQp4LJHuBMCHTk6VeyQOw2DI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCNBmnUf2wnxPHF4WvHHHodEeXTvtVejL1ALWV//XizIYjLtCfW+Ief8eyNfKLcTV
         nzbe2R9JXSdDCeVrllCPeEEGYD+W6Ywm+pgrU4relO/mTgHLQZbUeig6832CE66Tf0
         1ysj/0lq5bnIZGZqyiSl3W0y8SLNvx6DXaM8fgFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiuhao Li <qiuhao@sysec.org>,
        Gaoning Pan <pgn@zju.edu.cn>, Yongkang Jia <kangel@zju.edu.cn>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.18 23/67] KVM: x86: avoid calling x86 emulator without a decoded instruction
Date:   Fri,  3 Jun 2022 19:43:24 +0200
Message-Id: <20220603173821.393616220@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
References: <20220603173820.731531504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit fee060cd52d69c114b62d1a2948ea9648b5131f9 upstream.

Whenever x86_decode_emulated_instruction() detects a breakpoint, it
returns the value that kvm_vcpu_check_breakpoint() writes into its
pass-by-reference second argument.  Unfortunately this is completely
bogus because the expected outcome of x86_decode_emulated_instruction
is an EMULATION_* value.

Then, if kvm_vcpu_check_breakpoint() does "*r = 0" (corresponding to
a KVM_EXIT_DEBUG userspace exit), it is misunderstood as EMULATION_OK
and x86_emulate_instruction() is called without having decoded the
instruction.  This causes various havoc from running with a stale
emulation context.

The fix is to move the call to kvm_vcpu_check_breakpoint() where it was
before commit 4aa2691dcbd3 ("KVM: x86: Factor out x86 instruction
emulation with decoding") introduced x86_decode_emulated_instruction().
The other caller of the function does not need breakpoint checks,
because it is invoked as part of a vmexit and the processor has already
checked those before executing the instruction that #GP'd.

This fixes CVE-2022-1852.

Reported-by: Qiuhao Li <qiuhao@sysec.org>
Reported-by: Gaoning Pan <pgn@zju.edu.cn>
Reported-by: Yongkang Jia <kangel@zju.edu.cn>
Fixes: 4aa2691dcbd3 ("KVM: x86: Factor out x86 instruction emulation with decoding")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220311032801.3467418-2-seanjc@google.com>
[Rewrote commit message according to Qiuhao's report, since a patch
 already existed to fix the bug. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8244,7 +8244,7 @@ int kvm_skip_emulated_instruction(struct
 }
 EXPORT_SYMBOL_GPL(kvm_skip_emulated_instruction);
 
-static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
+static bool kvm_vcpu_check_code_breakpoint(struct kvm_vcpu *vcpu, int *r)
 {
 	if (unlikely(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) &&
 	    (vcpu->arch.guest_debug_dr7 & DR7_BP_EN_MASK)) {
@@ -8313,25 +8313,23 @@ static bool is_vmware_backdoor_opcode(st
 }
 
 /*
- * Decode to be emulated instruction. Return EMULATION_OK if success.
+ * Decode an instruction for emulation.  The caller is responsible for handling
+ * code breakpoints.  Note, manually detecting code breakpoints is unnecessary
+ * (and wrong) when emulating on an intercepted fault-like exception[*], as
+ * code breakpoints have higher priority and thus have already been done by
+ * hardware.
+ *
+ * [*] Except #MC, which is higher priority, but KVM should never emulate in
+ *     response to a machine check.
  */
 int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 				    void *insn, int insn_len)
 {
-	int r = EMULATION_OK;
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+	int r;
 
 	init_emulate_ctxt(vcpu);
 
-	/*
-	 * We will reenter on the same instruction since we do not set
-	 * complete_userspace_io. This does not handle watchpoints yet,
-	 * those would be handled in the emulate_ops.
-	 */
-	if (!(emulation_type & EMULTYPE_SKIP) &&
-	    kvm_vcpu_check_breakpoint(vcpu, &r))
-		return r;
-
 	r = x86_decode_insn(ctxt, insn, insn_len, emulation_type);
 
 	trace_kvm_emulate_insn_start(vcpu);
@@ -8364,6 +8362,15 @@ int x86_emulate_instruction(struct kvm_v
 	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
 		kvm_clear_exception_queue(vcpu);
 
+		/*
+		 * Return immediately if RIP hits a code breakpoint, such #DBs
+		 * are fault-like and are higher priority than any faults on
+		 * the code fetch itself.
+		 */
+		if (!(emulation_type & EMULTYPE_SKIP) &&
+		    kvm_vcpu_check_code_breakpoint(vcpu, &r))
+			return r;
+
 		r = x86_decode_emulated_instruction(vcpu, emulation_type,
 						    insn, insn_len);
 		if (r != EMULATION_OK)  {


