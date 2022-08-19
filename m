Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E0059A3B8
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353795AbiHSQvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354513AbiHSQvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:51:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5261D59A1;
        Fri, 19 Aug 2022 09:14:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12289B8282B;
        Fri, 19 Aug 2022 16:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B6AC433D6;
        Fri, 19 Aug 2022 16:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925599;
        bh=ZK4XsUzX22wfa6rcCGm1wxBymDkwuNezaRqvry0UXgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2PuhC3JuK5bThWgbudSFBRU6XuHI6Orw0YdVUxo6i3jkQ6XJBBLU1XHL5LOfSTrf
         8KumDMIQaVAEJEAW4/oFD7b/WjCaaMoZWSbxvy7WeOk2tqRbShIjdfVtHaUFh9d4qd
         2zu7d3qWF2M6chq0xw1lmoHSuUCR8NZ1yZcxoBgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 503/545] KVM: nVMX: Inject #UD if VMXON is attempted with incompatible CR0/CR4
Date:   Fri, 19 Aug 2022 17:44:33 +0200
Message-Id: <20220819153851.986665676@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit c7d855c2aff2d511fd60ee2e356134c4fb394799 ]

Inject a #UD if L1 attempts VMXON with a CR0 or CR4 that is disallowed
per the associated nested VMX MSRs' fixed0/1 settings.  KVM cannot rely
on hardware to perform the checks, even for the few checks that have
higher priority than VM-Exit, as (a) KVM may have forced CR0/CR4 bits in
hardware while running the guest, (b) there may incompatible CR0/CR4 bits
that have lower priority than VM-Exit, e.g. CR0.NE, and (c) userspace may
have further restricted the allowed CR0/CR4 values by manipulating the
guest's nested VMX MSRs.

Note, despite a very strong desire to throw shade at Jim, commit
70f3aac964ae ("kvm: nVMX: Remove superfluous VMX instruction fault checks")
is not to blame for the buggy behavior (though the comment...).  That
commit only removed the CR0.PE, EFLAGS.VM, and COMPATIBILITY mode checks
(though it did erroneously drop the CPL check, but that has already been
remedied).  KVM may force CR0.PE=1, but will do so only when also
forcing EFLAGS.VM=1 to emulate Real Mode, i.e. hardware will still #UD.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216033
Fixes: ec378aeef9df ("KVM: nVMX: Implement VMXON and VMXOFF")
Reported-by: Eric Li <ercli@ucdavis.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220607213604.3346000-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3228db4db5df..6c4277e99d58 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4877,20 +4877,25 @@ static int handle_vmon(struct kvm_vcpu *vcpu)
 		| FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
 
 	/*
-	 * The Intel VMX Instruction Reference lists a bunch of bits that are
-	 * prerequisite to running VMXON, most notably cr4.VMXE must be set to
-	 * 1 (see vmx_is_valid_cr4() for when we allow the guest to set this).
-	 * Otherwise, we should fail with #UD.  But most faulting conditions
-	 * have already been checked by hardware, prior to the VM-exit for
-	 * VMXON.  We do test guest cr4.VMXE because processor CR4 always has
-	 * that bit set to 1 in non-root mode.
+	 * Note, KVM cannot rely on hardware to perform the CR0/CR4 #UD checks
+	 * that have higher priority than VM-Exit (see Intel SDM's pseudocode
+	 * for VMXON), as KVM must load valid CR0/CR4 values into hardware while
+	 * running the guest, i.e. KVM needs to check the _guest_ values.
+	 *
+	 * Rely on hardware for the other two pre-VM-Exit checks, !VM86 and
+	 * !COMPATIBILITY modes.  KVM may run the guest in VM86 to emulate Real
+	 * Mode, but KVM will never take the guest out of those modes.
 	 */
-	if (!kvm_read_cr4_bits(vcpu, X86_CR4_VMXE)) {
+	if (!nested_host_cr0_valid(vcpu, kvm_read_cr0(vcpu)) ||
+	    !nested_host_cr4_valid(vcpu, kvm_read_cr4(vcpu))) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
 
-	/* CPL=0 must be checked manually. */
+	/*
+	 * CPL=0 and all other checks that are lower priority than VM-Exit must
+	 * be checked manually.
+	 */
 	if (vmx_get_cpl(vcpu)) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
-- 
2.35.1



