Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D958B3D60E6
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237661AbhGZPZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237948AbhGZPY1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:24:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BAE160E09;
        Mon, 26 Jul 2021 16:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315495;
        bh=CiyjggJLEm02OcpWPb83n/7Z396qwl7jU7KikMNpZS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QwNSUfSaXW+VqOT/bbPzHIpIOkQjvGUdE5PdXcCe13tH/cE1l2rmwmW8Zj/iBPExl
         0MAsxPeifKpvq1fp0Fb43UQgK0SA+yaZ/GzYln8faiOeMGIdxP1vcuK7iCbbUmRPJj
         J5P+pI35FnljgU+T5RFK2GstHJ3G165fPioXgqII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Neuling <mikey@neuling.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 120/167] KVM: PPC: Book3S HV Nested: Sanitise H_ENTER_NESTED TM state
Date:   Mon, 26 Jul 2021 17:39:13 +0200
Message-Id: <20210726153843.429351440@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit d9c57d3ed52a92536f5fa59dc5ccdd58b4875076 upstream.

The H_ENTER_NESTED hypercall is handled by the L0, and it is a request
by the L1 to switch the context of the vCPU over to that of its L2
guest, and return with an interrupt indication. The L1 is responsible
for switching some registers to guest context, and the L0 switches
others (including all the hypervisor privileged state).

If the L2 MSR has TM active, then the L1 is responsible for
recheckpointing the L2 TM state. Then the L1 exits to L0 via the
H_ENTER_NESTED hcall, and the L0 saves the TM state as part of the exit,
and then it recheckpoints the TM state as part of the nested entry and
finally HRFIDs into the L2 with TM active MSR. Not efficient, but about
the simplest approach for something that's horrendously complicated.

Problems arise if the L1 exits to the L0 with a TM state which does not
match the L2 TM state being requested. For example if the L1 is
transactional but the L2 MSR is non-transactional, or vice versa. The
L0's HRFID can take a TM Bad Thing interrupt and crash.

Fix this by disallowing H_ENTER_NESTED in TM[T] state entirely, and then
ensuring that if the L1 is suspended then the L2 must have TM active,
and if the L1 is not suspended then the L2 must not have TM active.

Fixes: 360cae313702 ("KVM: PPC: Book3S HV: Nested guest entry via hypercall")
Cc: stable@vger.kernel.org # v4.20+
Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Acked-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_hv_nested.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -232,6 +232,9 @@ long kvmhv_enter_nested_guest(struct kvm
 	if (vcpu->kvm->arch.l1_ptcr == 0)
 		return H_NOT_AVAILABLE;
 
+	if (MSR_TM_TRANSACTIONAL(vcpu->arch.shregs.msr))
+		return H_BAD_MODE;
+
 	/* copy parameters in */
 	hv_ptr = kvmppc_get_gpr(vcpu, 4);
 	regs_ptr = kvmppc_get_gpr(vcpu, 5);
@@ -254,6 +257,23 @@ long kvmhv_enter_nested_guest(struct kvm
 	if (l2_hv.vcpu_token >= NR_CPUS)
 		return H_PARAMETER;
 
+	/*
+	 * L1 must have set up a suspended state to enter the L2 in a
+	 * transactional state, and only in that case. These have to be
+	 * filtered out here to prevent causing a TM Bad Thing in the
+	 * host HRFID. We could synthesize a TM Bad Thing back to the L1
+	 * here but there doesn't seem like much point.
+	 */
+	if (MSR_TM_SUSPENDED(vcpu->arch.shregs.msr)) {
+		if (!MSR_TM_ACTIVE(l2_regs.msr))
+			return H_BAD_MODE;
+	} else {
+		if (l2_regs.msr & MSR_TS_MASK)
+			return H_BAD_MODE;
+		if (WARN_ON_ONCE(vcpu->arch.shregs.msr & MSR_TS_MASK))
+			return H_BAD_MODE;
+	}
+
 	/* translate lpid */
 	l2 = kvmhv_get_nested(vcpu->kvm, l2_hv.lpid, true);
 	if (!l2)


