Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E487287EA
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390420AbfEWTZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:25:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390658AbfEWTZB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:25:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8DB62184E;
        Thu, 23 May 2019 19:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639500;
        bh=kCwI7fij1tPgTRlkmNRfUNwBryNuncmVVpP1yx5LDCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sS8dyMe1WtBjQTmf4iEN55qFC0pVwHmcdHAh/AqmuEcnHHwrvhKUcx65n+AJaHREr
         B6oytpHUyIfqEI61MhANwFxg/EoGqr9aplRW63Nn0GZM+SePVJXQEagAPdqm9kAu1V
         35BPxbAOFQNV+Dn13wOmgoHBLPfXHozlrPTJycZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 111/139] KVM: PPC: Book3S: Protect memslots while validating user address
Date:   Thu, 23 May 2019 21:06:39 +0200
Message-Id: <20190523181734.500651047@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 345077c8e172c255ea0707214303ccd099e5656b ]

Guest physical to user address translation uses KVM memslots and reading
these requires holding the kvm->srcu lock. However recently introduced
kvmppc_tce_validate() broke the rule (see the lockdep warning below).

This moves srcu_read_lock(&vcpu->kvm->srcu) earlier to protect
kvmppc_tce_validate() as well.

=============================
WARNING: suspicious RCU usage
5.1.0-rc2-le_nv2_aikATfstn1-p1 #380 Not tainted
-----------------------------
include/linux/kvm_host.h:605 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by qemu-system-ppc/8020:
 #0: 0000000094972fe9 (&vcpu->mutex){+.+.}, at: kvm_vcpu_ioctl+0xdc/0x850 [kvm]

stack backtrace:
CPU: 44 PID: 8020 Comm: qemu-system-ppc Not tainted 5.1.0-rc2-le_nv2_aikATfstn1-p1 #380
Call Trace:
[c000003fece8f740] [c000000000bcc134] dump_stack+0xe8/0x164 (unreliable)
[c000003fece8f790] [c000000000181be0] lockdep_rcu_suspicious+0x130/0x170
[c000003fece8f810] [c0000000000d5f50] kvmppc_tce_to_ua+0x280/0x290
[c000003fece8f870] [c00800001a7e2c78] kvmppc_tce_validate+0x80/0x1b0 [kvm]
[c000003fece8f8e0] [c00800001a7e3fac] kvmppc_h_put_tce+0x94/0x3e4 [kvm]
[c000003fece8f9a0] [c00800001a8baac4] kvmppc_pseries_do_hcall+0x30c/0xce0 [kvm_hv]
[c000003fece8fa10] [c00800001a8bd89c] kvmppc_vcpu_run_hv+0x694/0xec0 [kvm_hv]
[c000003fece8fae0] [c00800001a7d95dc] kvmppc_vcpu_run+0x34/0x48 [kvm]
[c000003fece8fb00] [c00800001a7d56bc] kvm_arch_vcpu_ioctl_run+0x2f4/0x400 [kvm]
[c000003fece8fb90] [c00800001a7c3618] kvm_vcpu_ioctl+0x460/0x850 [kvm]
[c000003fece8fd00] [c00000000041c4f4] do_vfs_ioctl+0xe4/0x930
[c000003fece8fdb0] [c00000000041ce04] ksys_ioctl+0xc4/0x110
[c000003fece8fe00] [c00000000041ce78] sys_ioctl+0x28/0x80
[c000003fece8fe20] [c00000000000b5a4] system_call+0x5c/0x70

Fixes: 42de7b9e2167 ("KVM: PPC: Validate TCEs against preregistered memory page sizes", 2018-09-10)
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_64_vio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 532ab79734c7a..d43e8fe6d4241 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -543,14 +543,14 @@ long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 	if (ret != H_SUCCESS)
 		return ret;
 
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+
 	ret = kvmppc_tce_validate(stt, tce);
 	if (ret != H_SUCCESS)
-		return ret;
+		goto unlock_exit;
 
 	dir = iommu_tce_direction(tce);
 
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
-
 	if ((dir != DMA_NONE) && kvmppc_tce_to_ua(vcpu->kvm, tce, &ua, NULL)) {
 		ret = H_PARAMETER;
 		goto unlock_exit;
-- 
2.20.1



