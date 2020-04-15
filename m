Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80421AA1F9
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370282AbgDOMsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:48:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408952AbgDOLnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:43:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBB9220737;
        Wed, 15 Apr 2020 11:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950983;
        bh=HJVDu28gY1/bAP0E/D5bAYl4WxLMLzNvno4dmyQIw/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GUsjGYYSA7PFGrQ71q4iLSe54PdeSDF8/M8IJaL+MdnB02mwJRw6D5aCdGuDc3WAJ
         pSKizkrG/QhSOFguE2tSN8ktLArPpM/fV9Q9XHgHe19s6WE4f4KjjlH9tAJowSQ08j
         fRXEnVCW5abwRDqNPEf2FoVnbgbWweNpBmLFBavU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Roth <mdroth@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.5 031/106] KVM: PPC: Book3S HV: Fix H_CEDE return code for nested guests
Date:   Wed, 15 Apr 2020 07:41:11 -0400
Message-Id: <20200415114226.13103-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ef6aa63b071b3..a1d793b96d2b7 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3628,6 +3628,7 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		if (trap == BOOK3S_INTERRUPT_SYSCALL && !vcpu->arch.nested &&
 		    kvmppc_get_gpr(vcpu, 3) == H_CEDE) {
 			kvmppc_nested_cede(vcpu);
+			kvmppc_set_gpr(vcpu, 3, 0);
 			trap = 0;
 		}
 	} else {
-- 
2.20.1

