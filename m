Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139581B3F26
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731087AbgDVKey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:34:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730387AbgDVKX5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:23:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5F6820784;
        Wed, 22 Apr 2020 10:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551037;
        bh=sByr9sNSa2X3ngNDdrYK6UPMYpAcHLw7TEu1niD7Wpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DSL8vQuSLwNgjcaLUpUC1nBDqcqVTZD7Ky5hSo+2gSGqbj+mg7X8FYlgfAV+U85xj
         dvDQGOv5eF8i0wefh7hZk9VPJRaImSkcFaeJwiyyvy30qB0GRiWmr/4Bgz+J4NoLea
         jbO1gJXVFcnuvLCm8NupxcGs+LR56oHidGrj/p5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linuxppc-dev@ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 076/166] KVM: PPC: Book3S HV: Fix H_CEDE return code for nested guests
Date:   Wed, 22 Apr 2020 11:56:43 +0200
Message-Id: <20200422095057.006842072@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Roth <mdroth@linux.vnet.ibm.com>

[ Upstream commit 1f50cc1705350a4697923203fedd7d8fb1087fe2 ]

The h_cede_tm kvm-unit-test currently fails when run inside an L1 guest
via the guest/nested hypervisor.

  ./run-tests.sh -v
  ...
  TESTNAME=h_cede_tm TIMEOUT=90s ACCEL= ./powerpc/run powerpc/tm.elf -smp 2,threads=2 -machine cap-htm=on -append "h_cede_tm"
  FAIL h_cede_tm (2 tests, 1 unexpected failures)

While the test relates to transactional memory instructions, the actual
failure is due to the return code of the H_CEDE hypercall, which is
reported as 224 instead of 0. This happens even when no TM instructions
are issued.

224 is the value placed in r3 to execute a hypercall for H_CEDE, and r3
is where the caller expects the return code to be placed upon return.

In the case of guest running under a nested hypervisor, issuing H_CEDE
causes a return from H_ENTER_NESTED. In this case H_CEDE is
specially-handled immediately rather than later in
kvmppc_pseries_do_hcall() as with most other hcalls, but we forget to
set the return code for the caller, hence why kvm-unit-test sees the
224 return code and reports an error.

Guest kernels generally don't check the return value of H_CEDE, so
that likely explains why this hasn't caused issues outside of
kvm-unit-tests so far.

Fix this by setting r3 to 0 after we finish processing the H_CEDE.

RHBZ: 1778556

Fixes: 4bad77799fed ("KVM: PPC: Book3S HV: Handle hypercalls correctly when nested")
Cc: linuxppc-dev@ozlabs.org
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Michael Roth <mdroth@linux.vnet.ibm.com>
Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 2cefd071b8483..c0c43a7338304 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3616,6 +3616,7 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		if (trap == BOOK3S_INTERRUPT_SYSCALL && !vcpu->arch.nested &&
 		    kvmppc_get_gpr(vcpu, 3) == H_CEDE) {
 			kvmppc_nested_cede(vcpu);
+			kvmppc_set_gpr(vcpu, 3, 0);
 			trap = 0;
 		}
 	} else {
-- 
2.20.1



