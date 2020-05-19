Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8221D91C6
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 10:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgESILX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 04:11:23 -0400
Received: from o1.dev.nutanix.com ([198.21.4.205]:2588 "EHLO
        o1.dev.nutanix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgESILX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 04:11:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sendgrid.net;
        h=from:subject:mime-version:to:cc:content-transfer-encoding:
        content-type;
        s=smtpapi; bh=FyetZpafM/v6XIJbkIYr2RB7YlhXywPDsBHNjztNYEU=;
        b=jV9LilP4hIzcawYH20i8HqWNol8X/nZtdQwfcS/oscSi3owPPnqwiKr49kkuzPaKCyAl
        Qt7tHLBnVADXBEpCwTdw6+jr8o3pU0IaUDhw1IYxojxhwivOl/vA2yAjZQL81tDKzs9/Fk
        4CBYBxId495E61VR5bR7TsK71zYELPfAA=
Received: by filterdrecv-p3iad2-8ddf98858-lwgxm with SMTP id filterdrecv-p3iad2-8ddf98858-lwgxm-19-5EC394AA-1D
        2020-05-19 08:11:22.408630125 +0000 UTC m=+4691031.646325677
Received: from debian.localdomain (unknown)
        by ismtpd0008p1lon1.sendgrid.net (SG) with ESMTP
        id 6UUgXTmQRF-ABD9SVFhCQg
        Tue, 19 May 2020 08:11:22.067 +0000 (UTC)
From:   Felipe Franciosi <felipe@nutanix.com>
Subject: [PATCH v2] KVM: x86: respect singlestep when emulating instruction
Date:   Tue, 19 May 2020 08:11:22 +0000 (UTC)
Message-Id: <20200519081048.8204-1-felipe@nutanix.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?W9goRmNI2M6BaZDnSanVWLdj2DuGbkuGfTWZsqFIAk59ONbkkaLXMDCghpkcaI?=
 =?us-ascii?Q?PehS=2FLuf7=2F3t083SnZbMEjV=2FhVoVQYNCU8if+b2?=
 =?us-ascii?Q?hfP+MkdnLaAkF5irJPrTFAwszS9YEc5FrwmrAte?=
 =?us-ascii?Q?U06=2F=2FITgah6myXAmbMmxM6C+3EkrrrNN8umvDrK?=
 =?us-ascii?Q?pUsgqrf8itVNQq83Nd5VUYXubrIZC4nnnpo7zFk?=
 =?us-ascii?Q?eL6aTlMiki1gl1BrCxWsmdQtlcSAOJvjHXzRexk?=
 =?us-ascii?Q?us34OK=2FBJ5k+Fgs20BJag=3D=3D?=
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, stable@vger.kernel.org,
        Felipe Franciosi <felipe@nutanix.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When userspace configures KVM_GUESTDBG_SINGLESTEP, KVM will manage the
presence of X86_EFLAGS_TF via kvm_set/get_rflags on vcpus. The actual
rflag bit is therefore hidden from callers.

That includes init_emulate_ctxt() which uses the value returned from
kvm_get_flags() to set ctxt->tf. As a result, x86_emulate_instruction()
will skip a single step, leaving singlestep_rip stale and not returning
to userspace.

This resolves the issue by observing the vcpu guest_debug configuration
alongside ctxt->tf in x86_emulate_instruction(), performing the single
step if set.

Signed-off-by: Felipe Franciosi <felipe@nutanix.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c17e6eb9ad43..64cb183636da 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6919,7 +6919,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		if (!ctxt->have_exception ||
 		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
 			kvm_rip_write(vcpu, ctxt->eip);
-			if (r && ctxt->tf)
+			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
 				r = kvm_vcpu_do_singlestep(vcpu);
 			if (kvm_x86_ops.update_emulated_instruction)
 				kvm_x86_ops.update_emulated_instruction(vcpu);
-- 
2.20.1

