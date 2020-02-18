Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E156716358E
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 22:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgBRVyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 16:54:38 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59947 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726482AbgBRVyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 16:54:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582062876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hSIrsuhMn6wCetCiY/DKdOoRaL41AGcFVQwEBXtI+So=;
        b=b+3JPI0kY3vnZB3D02ubMUNfvxuck/aX9acextBX+VNBfcSO8Ny4pjeLeZpqV8cpyO9ixK
        kxYQdS/WKgca/aQVbaP4uwhCewyI/QGNoOSov4Nku97HsfEjrNdrq6uC0Cbq4ZuLLfEt1n
        Jr9w1fbqTPxGqMPWBy7ynydrLaawHxU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-TMgnPCsrPJ6pEuOsId_O8w-1; Tue, 18 Feb 2020 16:54:30 -0500
X-MC-Unique: TMgnPCsrPJ6pEuOsId_O8w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48888800D53;
        Tue, 18 Feb 2020 21:54:29 +0000 (UTC)
Received: from dhcp16-201-240.khw1.lab.eng.bos.redhat.com (dhcp16-201-240.khw1.lab.eng.bos.redhat.com [10.16.201.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D0FF19756;
        Tue, 18 Feb 2020 21:54:28 +0000 (UTC)
From:   Daniel Henrique Barboza <dbarboza@redhat.com>
To:     sbest@redhat.com
Cc:     Greg Kurz <groug@kaod.org>, stable@vger.kernel.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Daniel Henrique Barboza <dbarboza@redhat.com>
Subject: [RHEL 8.2 PATCH] KVM: PPC: Book3S HV: XIVE: Ensure VP isn't already in use
Date:   Tue, 18 Feb 2020 16:54:24 -0500
Message-Id: <20200218215424.28761-1-dbarboza@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kurz <groug@kaod.org>

Bugzilla: 804424
Brew: 26599344
Upstream: Yes
Tested: sanity tests in a Power 8 host
Conflicts: none

Connecting a vCPU to a XIVE KVM device means establishing a 1:1
association between a vCPU id and the offset (VP id) of a VP
structure within a fixed size block of VPs. We currently try to
enforce the 1:1 relationship by checking that a vCPU with the
same id isn't already connected. This is good but unfortunately
not enough because we don't map VP ids to raw vCPU ids but to
packed vCPU ids, and the packing function kvmppc_pack_vcpu_id()
isn't bijective by design. We got away with it because QEMU passes
vCPU ids that fit well in the packing pattern. But nothing prevents
userspace to come up with a forged vCPU id resulting in a packed id
collision which causes the KVM device to associate two vCPUs to the
same VP. This greatly confuses the irq layer and ultimately crashes
the kernel, as shown below.

Example: a guest with 1 guest thread per core, a core stride of
8 and 300 vCPUs has vCPU ids 0,8,16...2392. If QEMU is patched to
inject at some point an invalid vCPU id 348, which is the packed
version of itself and 2392, we get:

genirq: Flags mismatch irq 199. 00010000 (kvm-2-2392) vs. 00010000 (kvm-2=
-348)
CPU: 24 PID: 88176 Comm: qemu-system-ppc Not tainted 5.3.0-xive-nr-server=
s-5.3-gku+ #38
Call Trace:
[c000003f7f9937e0] [c000000000c0110c] dump_stack+0xb0/0xf4 (unreliable)
[c000003f7f993820] [c0000000001cb480] __setup_irq+0xa70/0xad0
[c000003f7f9938d0] [c0000000001cb75c] request_threaded_irq+0x13c/0x260
[c000003f7f993940] [c00800000d44e7ac] kvmppc_xive_attach_escalation+0x104=
/0x270 [kvm]
[c000003f7f9939d0] [c00800000d45013c] kvmppc_xive_connect_vcpu+0x424/0x62=
0 [kvm]
[c000003f7f993ac0] [c00800000d444428] kvm_arch_vcpu_ioctl+0x260/0x448 [kv=
m]
[c000003f7f993b90] [c00800000d43593c] kvm_vcpu_ioctl+0x154/0x7c8 [kvm]
[c000003f7f993d00] [c0000000004840f0] do_vfs_ioctl+0xe0/0xc30
[c000003f7f993db0] [c000000000484d44] ksys_ioctl+0x104/0x120
[c000003f7f993e00] [c000000000484d88] sys_ioctl+0x28/0x80
[c000003f7f993e20] [c00000000000b278] system_call+0x5c/0x68
xive-kvm: Failed to request escalation interrupt for queue 0 of VCPU 2392
------------[ cut here ]------------
remove_proc_entry: removing non-empty directory 'irq/199', leaking at lea=
st 'kvm-2-348'
WARNING: CPU: 24 PID: 88176 at /home/greg/Work/linux/kernel-kvm-ppc/fs/pr=
oc/generic.c:684 remove_proc_entry+0x1ec/0x200
Modules linked in: kvm_hv kvm dm_mod vhost_net vhost tap xt_CHECKSUM ipta=
ble_mangle xt_MASQUERADE iptable_nat nf_nat xt_conntrack nf_conntrack nf_=
defrag_ipv6 nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 tun bridge stp llc e=
btable_filter ebtables ip6table_filter ip6_tables iptable_filter squashfs=
 loop fuse i2c_dev sg ofpart ocxl powernv_flash at24 xts mtd uio_pdrv_gen=
irq vmx_crypto opal_prd ipmi_powernv uio ipmi_devintf ipmi_msghandler ibm=
powernv ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libisc=
si scsi_transport_iscsi ip_tables ext4 mbcache jbd2 raid10 raid456 async_=
raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq libcrc3=
2c raid1 raid0 linear sd_mod ast i2c_algo_bit drm_vram_helper ttm drm_kms=
_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm ahci libahci li=
bata tg3 drm_panel_orientation_quirks [last unloaded: kvm]
CPU: 24 PID: 88176 Comm: qemu-system-ppc Not tainted 5.3.0-xive-nr-server=
s-5.3-gku+ #38
NIP:  c00000000053b0cc LR: c00000000053b0c8 CTR: c0000000000ba3b0
REGS: c000003f7f9934b0 TRAP: 0700   Not tainted  (5.3.0-xive-nr-servers-5=
.3-gku+)
MSR:  9000000000029033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 48228222  XER: 2004=
0000
CFAR: c000000000131a50 IRQMASK: 0
GPR00: c00000000053b0c8 c000003f7f993740 c0000000015ec500 000000000000005=
7
GPR04: 0000000000000001 0000000000000000 000049fb98484262 0000000000001bc=
f
GPR08: 0000000000000007 0000000000000007 0000000000000001 900000000000103=
3
GPR12: 0000000000008000 c000003ffffeb800 0000000000000000 000000012f4ce5a=
1
GPR16: 000000012ef5a0c8 0000000000000000 000000012f113bb0 000000000000000=
0
GPR20: 000000012f45d918 c000003f863758b0 c000003f86375870 000000000000000=
6
GPR24: c000003f86375a30 0000000000000007 c0002039373d9020 c0000000014c4a4=
8
GPR28: 0000000000000001 c000003fe62a4f6b c00020394b2e9fab c000003fe62a4ec=
0
NIP [c00000000053b0cc] remove_proc_entry+0x1ec/0x200
LR [c00000000053b0c8] remove_proc_entry+0x1e8/0x200
Call Trace:
[c000003f7f993740] [c00000000053b0c8] remove_proc_entry+0x1e8/0x200 (unre=
liable)
[c000003f7f9937e0] [c0000000001d3654] unregister_irq_proc+0x114/0x150
[c000003f7f993880] [c0000000001c6284] free_desc+0x54/0xb0
[c000003f7f9938c0] [c0000000001c65ec] irq_free_descs+0xac/0x100
[c000003f7f993910] [c0000000001d1ff8] irq_dispose_mapping+0x68/0x80
[c000003f7f993940] [c00800000d44e8a4] kvmppc_xive_attach_escalation+0x1fc=
/0x270 [kvm]
[c000003f7f9939d0] [c00800000d45013c] kvmppc_xive_connect_vcpu+0x424/0x62=
0 [kvm]
[c000003f7f993ac0] [c00800000d444428] kvm_arch_vcpu_ioctl+0x260/0x448 [kv=
m]
[c000003f7f993b90] [c00800000d43593c] kvm_vcpu_ioctl+0x154/0x7c8 [kvm]
[c000003f7f993d00] [c0000000004840f0] do_vfs_ioctl+0xe0/0xc30
[c000003f7f993db0] [c000000000484d44] ksys_ioctl+0x104/0x120
[c000003f7f993e00] [c000000000484d88] sys_ioctl+0x28/0x80
[c000003f7f993e20] [c00000000000b278] system_call+0x5c/0x68
Instruction dump:
2c230000 41820008 3923ff78 e8e900a0 3c82ff69 3c62ff8d 7fa6eb78 7fc5f378
3884f080 3863b948 4bbf6925 60000000 <0fe00000> 4bffff7c fba10088 4bbf6e41
---[ end trace b925b67a74a1d8d1 ]---
BUG: Kernel NULL pointer dereference at 0x00000010
Faulting instruction address: 0xc00800000d44fc04
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=3D64K MMU=3DRadix MMU=3DHash SMP NR_CPUS=3D2048 NUMA PowerNV
Modules linked in: kvm_hv kvm dm_mod vhost_net vhost tap xt_CHECKSUM ipta=
ble_mangle xt_MASQUERADE iptable_nat nf_nat xt_conntrack nf_conntrack nf_=
defrag_ipv6 nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 tun bridge stp llc e=
btable_filter ebtables ip6table_filter ip6_tables iptable_filter squashfs=
 loop fuse i2c_dev sg ofpart ocxl powernv_flash at24 xts mtd uio_pdrv_gen=
irq vmx_crypto opal_prd ipmi_powernv uio ipmi_devintf ipmi_msghandler ibm=
powernv ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libisc=
si scsi_transport_iscsi ip_tables ext4 mbcache jbd2 raid10 raid456 async_=
raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq libcrc3=
2c raid1 raid0 linear sd_mod ast i2c_algo_bit drm_vram_helper ttm drm_kms=
_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm ahci libahci li=
bata tg3 drm_panel_orientation_quirks [last unloaded: kvm]
CPU: 24 PID: 88176 Comm: qemu-system-ppc Tainted: G        W         5.3.=
0-xive-nr-servers-5.3-gku+ #38
NIP:  c00800000d44fc04 LR: c00800000d44fc00 CTR: c0000000001cd970
REGS: c000003f7f9938e0 TRAP: 0300   Tainted: G        W          (5.3.0-x=
ive-nr-servers-5.3-gku+)
MSR:  9000000000009033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 24228882  XER: 2004=
0000
CFAR: c0000000001cd9ac DAR: 0000000000000010 DSISR: 40000000 IRQMASK: 0
GPR00: c00800000d44fc00 c000003f7f993b70 c00800000d468300 000000000000000=
0
GPR04: 00000000000000c7 0000000000000000 0000000000000000 c000003ffacd06d=
8
GPR08: 0000000000000000 c000003ffacd0738 0000000000000000 fffffffffffffff=
d
GPR12: 0000000000000040 c000003ffffeb800 0000000000000000 000000012f4ce5a=
1
GPR16: 000000012ef5a0c8 0000000000000000 000000012f113bb0 000000000000000=
0
GPR20: 000000012f45d918 00007ffffe0d9a80 000000012f4f5df0 000000012ef8c9f=
8
GPR24: 0000000000000001 0000000000000000 c000003fe4501ed0 c000003f8b1d000=
0
GPR28: c0000033314689c0 c000003fe4501c00 c000003fe4501e70 c000003fe4501e9=
0
NIP [c00800000d44fc04] kvmppc_xive_cleanup_vcpu+0xfc/0x210 [kvm]
LR [c00800000d44fc00] kvmppc_xive_cleanup_vcpu+0xf8/0x210 [kvm]
Call Trace:
[c000003f7f993b70] [c00800000d44fc00] kvmppc_xive_cleanup_vcpu+0xf8/0x210=
 [kvm] (unreliable)
[c000003f7f993bd0] [c00800000d450bd4] kvmppc_xive_release+0xdc/0x1b0 [kvm=
]
[c000003f7f993c30] [c00800000d436a98] kvm_device_release+0xb0/0x110 [kvm]
[c000003f7f993c70] [c00000000046730c] __fput+0xec/0x320
[c000003f7f993cd0] [c000000000164ae0] task_work_run+0x150/0x1c0
[c000003f7f993d30] [c000000000025034] do_notify_resume+0x304/0x440
[c000003f7f993e20] [c00000000000dcc4] ret_from_except_lite+0x70/0x74
Instruction dump:
3bff0008 7fbfd040 419e0054 847e0004 2fa30000 419effec e93d0000 8929203c
2f890000 419effb8 4800821d e8410018 <e9230010> e9490008 9b2a0039 7c0004ac
---[ end trace b925b67a74a1d8d2 ]---

Kernel panic - not syncing: Fatal exception

This affects both XIVE and XICS-on-XIVE devices since the beginning.

Check the VP id instead of the vCPU id when a new vCPU is connected.
The allocation of the XIVE CPU structure in kvmppc_xive_connect_vcpu()
is moved after the check to avoid the need for rollback.

Cc: stable@vger.kernel.org # v4.12+
(cherry-picked from )
Signed-off-by: Greg Kurz <groug@kaod.org>
Reviewed-by: C=C3=A9dric Le Goater <clg@kaod.org>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
(cherry picked from commit 12ade69c1eb9958b13374edf5ef742ea20ccffde)
Signed-off-by: Daniel Henrique Barboza <dbarboza@redhat.com>
---
 arch/powerpc/kvm/book3s_xive.c        | 24 ++++++++++++++++--------
 arch/powerpc/kvm/book3s_xive.h        | 12 ++++++++++++
 arch/powerpc/kvm/book3s_xive_native.c |  6 ++++--
 3 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xiv=
e.c
index 42c4d9c2d39a..b33e9246c49f 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -1178,6 +1178,7 @@ int kvmppc_xive_connect_vcpu(struct kvm_device *dev=
,
 	struct kvmppc_xive *xive =3D dev->private;
 	struct kvmppc_xive_vcpu *xc;
 	int i, r =3D -EBUSY;
+	u32 vp_id;
=20
 	pr_devel("connect_vcpu(cpu=3D%d)\n", cpu);
=20
@@ -1189,25 +1190,32 @@ int kvmppc_xive_connect_vcpu(struct kvm_device *d=
ev,
 		return -EPERM;
 	if (vcpu->arch.irq_type !=3D KVMPPC_IRQ_DEFAULT)
 		return -EBUSY;
-	if (kvmppc_xive_find_server(vcpu->kvm, cpu)) {
-		pr_devel("Duplicate !\n");
-		return -EEXIST;
-	}
 	if (cpu >=3D (KVM_MAX_VCPUS * vcpu->kvm->arch.emul_smt_mode)) {
 		pr_devel("Out of bounds !\n");
 		return -EINVAL;
 	}
-	xc =3D kzalloc(sizeof(*xc), GFP_KERNEL);
-	if (!xc)
-		return -ENOMEM;
=20
 	/* We need to synchronize with queue provisioning */
 	mutex_lock(&xive->lock);
+
+	vp_id =3D kvmppc_xive_vp(xive, cpu);
+	if (kvmppc_xive_vp_in_use(xive->kvm, vp_id)) {
+		pr_devel("Duplicate !\n");
+		r =3D -EEXIST;
+		goto bail;
+	}
+
+	xc =3D kzalloc(sizeof(*xc), GFP_KERNEL);
+	if (!xc) {
+		r =3D -ENOMEM;
+		goto bail;
+	}
+
 	vcpu->arch.xive_vcpu =3D xc;
 	xc->xive =3D xive;
 	xc->vcpu =3D vcpu;
 	xc->server_num =3D cpu;
-	xc->vp_id =3D kvmppc_xive_vp(xive, cpu);
+	xc->vp_id =3D vp_id;
 	xc->mfrr =3D 0xff;
 	xc->valid =3D true;
=20
diff --git a/arch/powerpc/kvm/book3s_xive.h b/arch/powerpc/kvm/book3s_xiv=
e.h
index 862c2c9650ae..fbad38d3523c 100644
--- a/arch/powerpc/kvm/book3s_xive.h
+++ b/arch/powerpc/kvm/book3s_xive.h
@@ -223,6 +223,18 @@ static inline u32 kvmppc_xive_vp(struct kvmppc_xive =
*xive, u32 server)
 	return xive->vp_base + kvmppc_pack_vcpu_id(xive->kvm, server);
 }
=20
+static inline bool kvmppc_xive_vp_in_use(struct kvm *kvm, u32 vp_id)
+{
+	struct kvm_vcpu *vcpu =3D NULL;
+	int i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu->arch.xive_vcpu && vp_id =3D=3D vcpu->arch.xive_vcpu->vp_id)
+			return true;
+	}
+	return false;
+}
+
 /*
  * Mapping between guest priorities and host priorities
  * is as follow.
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/boo=
k3s_xive_native.c
index 74a3a1c8ee47..8a5b9e61092e 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -116,6 +116,7 @@ int kvmppc_xive_native_connect_vcpu(struct kvm_device=
 *dev,
 	struct kvmppc_xive *xive =3D dev->private;
 	struct kvmppc_xive_vcpu *xc =3D NULL;
 	int rc;
+	u32 vp_id;
=20
 	pr_devel("native_connect_vcpu(server=3D%d)\n", server_num);
=20
@@ -134,7 +135,8 @@ int kvmppc_xive_native_connect_vcpu(struct kvm_device=
 *dev,
=20
 	mutex_lock(&xive->lock);
=20
-	if (kvmppc_xive_find_server(vcpu->kvm, server_num)) {
+	vp_id =3D kvmppc_xive_vp(xive, server_num);
+	if (kvmppc_xive_vp_in_use(xive->kvm, vp_id)) {
 		pr_devel("Duplicate !\n");
 		rc =3D -EEXIST;
 		goto bail;
@@ -151,7 +153,7 @@ int kvmppc_xive_native_connect_vcpu(struct kvm_device=
 *dev,
 	xc->vcpu =3D vcpu;
 	xc->server_num =3D server_num;
=20
-	xc->vp_id =3D kvmppc_xive_vp(xive, server_num);
+	xc->vp_id =3D vp_id;
 	xc->valid =3D true;
 	vcpu->arch.irq_type =3D KVMPPC_IRQ_XIVE;
=20
--=20
2.18.2

