Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163BA4B4B90
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346680AbiBNK1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:27:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346954AbiBNKZb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:25:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8566E549;
        Mon, 14 Feb 2022 01:57:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C15B9B80DFE;
        Mon, 14 Feb 2022 09:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FFCC340E9;
        Mon, 14 Feb 2022 09:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832619;
        bh=CVQhcvGz3gaWyOeNO8xbOV8873Pig3FfX9SC9zBkiNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZTe16K0/LVRFtUM0P2j/AAG9VIUxciAgzx/GxkhqJgH3rqekcVG+Bh0Y+Z7FohKLA
         Ijp/wBPSsP9+QLslSLMx/qZqDim7AwB6LWHsQVzMXyzUNRMe9diAjWRNQmaflD6b1k
         fIX5R7tJb3JR9B4Oiw6FZEsbpsdPcFnNYHsZO2QQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Alexander Graf <graf@amazon.de>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 071/203] KVM: VMX: Set vmcs.PENDING_DBG.BS on #DB in STI/MOVSS blocking shadow
Date:   Mon, 14 Feb 2022 10:25:15 +0100
Message-Id: <20220214092512.687019550@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit b9bed78e2fa9571b7c983b20666efa0009030c71 ]

Set vmcs.GUEST_PENDING_DBG_EXCEPTIONS.BS, a.k.a. the pending single-step
breakpoint flag, when re-injecting a #DB with RFLAGS.TF=1, and STI or
MOVSS blocking is active.  Setting the flag is necessary to make VM-Entry
consistency checks happy, as VMX has an invariant that if RFLAGS.TF is
set and STI/MOVSS blocking is true, then the previous instruction must
have been STI or MOV/POP, and therefore a single-step #DB must be pending
since the RFLAGS.TF cannot have been set by the previous instruction,
i.e. the one instruction delay after setting RFLAGS.TF must have already
expired.

Normally, the CPU sets vmcs.GUEST_PENDING_DBG_EXCEPTIONS.BS appropriately
when recording guest state as part of a VM-Exit, but #DB VM-Exits
intentionally do not treat the #DB as "guest state" as interception of
the #DB effectively makes the #DB host-owned, thus KVM needs to manually
set PENDING_DBG.BS when forwarding/re-injecting the #DB to the guest.

Note, although this bug can be triggered by guest userspace, doing so
requires IOPL=3, and guest userspace running with IOPL=3 has full access
to all I/O ports (from the guest's perspective) and can crash/reboot the
guest any number of ways.  IOPL=3 is required because STI blocking kicks
in if and only if RFLAGS.IF is toggled 0=>1, and if CPL>IOPL, STI either
takes a #GP or modifies RFLAGS.VIF, not RFLAGS.IF.

MOVSS blocking can be initiated by userspace, but can be coincident with
a #DB if and only if DR7.GD=1 (General Detect enabled) and a MOV DR is
executed in the MOVSS shadow.  MOV DR #GPs at CPL>0, thus MOVSS blocking
is problematic only for CPL0 (and only if the guest is crazy enough to
access a DR in a MOVSS shadow).  All other sources of #DBs are either
suppressed by MOVSS blocking (single-step, code fetch, data, and I/O),
are mutually exclusive with MOVSS blocking (T-bit task switch), or are
already handled by KVM (ICEBP, a.k.a. INT1).

This bug was originally found by running tests[1] created for XSA-308[2].
Note that Xen's userspace test emits ICEBP in the MOVSS shadow, which is
presumably why the Xen bug was deemed to be an exploitable DOS from guest
userspace.  KVM already handles ICEBP by skipping the ICEBP instruction
and thus clears MOVSS blocking as a side effect of its "emulation".

[1] http://xenbits.xenproject.org/docs/xtf/xsa-308_2main_8c_source.html
[2] https://xenbits.xen.org/xsa/advisory-308.html

Reported-by: David Woodhouse <dwmw2@infradead.org>
Reported-by: Alexander Graf <graf@amazon.de>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220120000624.655815-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7f4e6f625abcf..fe4a36c984460 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4811,8 +4811,33 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		dr6 = vmx_get_exit_qual(vcpu);
 		if (!(vcpu->guest_debug &
 		      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))) {
+			/*
+			 * If the #DB was due to ICEBP, a.k.a. INT1, skip the
+			 * instruction.  ICEBP generates a trap-like #DB, but
+			 * despite its interception control being tied to #DB,
+			 * is an instruction intercept, i.e. the VM-Exit occurs
+			 * on the ICEBP itself.  Note, skipping ICEBP also
+			 * clears STI and MOVSS blocking.
+			 *
+			 * For all other #DBs, set vmcs.PENDING_DBG_EXCEPTIONS.BS
+			 * if single-step is enabled in RFLAGS and STI or MOVSS
+			 * blocking is active, as the CPU doesn't set the bit
+			 * on VM-Exit due to #DB interception.  VM-Entry has a
+			 * consistency check that a single-step #DB is pending
+			 * in this scenario as the previous instruction cannot
+			 * have toggled RFLAGS.TF 0=>1 (because STI and POP/MOV
+			 * don't modify RFLAGS), therefore the one instruction
+			 * delay when activating single-step breakpoints must
+			 * have already expired.  Note, the CPU sets/clears BS
+			 * as appropriate for all other VM-Exits types.
+			 */
 			if (is_icebp(intr_info))
 				WARN_ON(!skip_emulated_instruction(vcpu));
+			else if ((vmx_get_rflags(vcpu) & X86_EFLAGS_TF) &&
+				 (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
+				  (GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS)))
+				vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
+					    vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS) | DR6_BS);
 
 			kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
 			return 1;
-- 
2.34.1



