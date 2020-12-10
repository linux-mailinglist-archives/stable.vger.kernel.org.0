Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF512D6090
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391159AbgLJOi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:38:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732589AbgLJOiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:38:25 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.9 40/75] KVM: PPC: Book3S HV: XIVE: Fix vCPU id sanity check
Date:   Thu, 10 Dec 2020 15:27:05 +0100
Message-Id: <20201210142608.044106525@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kurz <groug@kaod.org>

commit f54db39fbe40731c40aefdd3bc26e7d56d668c64 upstream.

Commit 062cfab7069f ("KVM: PPC: Book3S HV: XIVE: Make VP block size
configurable") updated kvmppc_xive_vcpu_id_valid() in a way that
allows userspace to trigger an assertion in skiboot and crash the host:

[  696.186248988,3] XIVE[ IC 08  ] eq_blk != vp_blk (0 vs. 1) for target 0x4300008c/0
[  696.186314757,0] Assert fail: hw/xive.c:2370:0
[  696.186342458,0] Aborting!
xive-kvCPU 0043 Backtrace:
 S: 0000000031e2b8f0 R: 0000000030013840   .backtrace+0x48
 S: 0000000031e2b990 R: 000000003001b2d0   ._abort+0x4c
 S: 0000000031e2ba10 R: 000000003001b34c   .assert_fail+0x34
 S: 0000000031e2ba90 R: 0000000030058984   .xive_eq_for_target.part.20+0xb0
 S: 0000000031e2bb40 R: 0000000030059fdc   .xive_setup_silent_gather+0x2c
 S: 0000000031e2bc20 R: 000000003005a334   .opal_xive_set_vp_info+0x124
 S: 0000000031e2bd20 R: 00000000300051a4   opal_entry+0x134
 --- OPAL call token: 0x8a caller R1: 0xc000001f28563850 ---

XIVE maintains the interrupt context state of non-dispatched vCPUs in
an internal VP structure. We allocate a bunch of those on startup to
accommodate all possible vCPUs. Each VP has an id, that we derive from
the vCPU id for efficiency:

static inline u32 kvmppc_xive_vp(struct kvmppc_xive *xive, u32 server)
{
	return xive->vp_base + kvmppc_pack_vcpu_id(xive->kvm, server);
}

The KVM XIVE device used to allocate KVM_MAX_VCPUS VPs. This was
limitting the number of concurrent VMs because the VP space is
limited on the HW. Since most of the time, VMs run with a lot less
vCPUs, commit 062cfab7069f ("KVM: PPC: Book3S HV: XIVE: Make VP
block size configurable") gave the possibility for userspace to
tune the size of the VP block through the KVM_DEV_XIVE_NR_SERVERS
attribute.

The check in kvmppc_pack_vcpu_id() was changed from

	cpu < KVM_MAX_VCPUS * xive->kvm->arch.emul_smt_mode

to

	cpu < xive->nr_servers * xive->kvm->arch.emul_smt_mode

The previous check was based on the fact that the VP block had
KVM_MAX_VCPUS entries and that kvmppc_pack_vcpu_id() guarantees
that packed vCPU ids are below KVM_MAX_VCPUS. We've changed the
size of the VP block, but kvmppc_pack_vcpu_id() has nothing to
do with it and it certainly doesn't ensure that the packed vCPU
ids are below xive->nr_servers. kvmppc_xive_vcpu_id_valid() might
thus return true when the VM was configured with a non-standard
VSMT mode, even if the packed vCPU id is higher than what we
expect. We end up using an unallocated VP id, which confuses
OPAL. The assert in OPAL is probably abusive and should be
converted to a regular error that the kernel can handle, but
we shouldn't really use broken VP ids in the first place.

Fix kvmppc_xive_vcpu_id_valid() so that it checks the packed
vCPU id is below xive->nr_servers, which is explicitly what we
want.

Fixes: 062cfab7069f ("KVM: PPC: Book3S HV: XIVE: Make VP block size configurable")
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/160673876747.695514.1809676603724514920.stgit@bahia.lan
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_xive.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -1214,12 +1214,9 @@ void kvmppc_xive_cleanup_vcpu(struct kvm
 static bool kvmppc_xive_vcpu_id_valid(struct kvmppc_xive *xive, u32 cpu)
 {
 	/* We have a block of xive->nr_servers VPs. We just need to check
-	 * raw vCPU ids are below the expected limit for this guest's
-	 * core stride ; kvmppc_pack_vcpu_id() will pack them down to an
-	 * index that can be safely used to compute a VP id that belongs
-	 * to the VP block.
+	 * packed vCPU ids are below that.
 	 */
-	return cpu < xive->nr_servers * xive->kvm->arch.emul_smt_mode;
+	return kvmppc_pack_vcpu_id(xive->kvm, cpu) < xive->nr_servers;
 }
 
 int kvmppc_xive_compute_vp_id(struct kvmppc_xive *xive, u32 cpu, u32 *vp)


