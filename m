Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 666D1C04B4
	for <lists+stable@lfdr.de>; Fri, 27 Sep 2019 13:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfI0LyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Sep 2019 07:54:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41416 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727366AbfI0LyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Sep 2019 07:54:10 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8RBkhJX116092
        for <stable@vger.kernel.org>; Fri, 27 Sep 2019 07:54:08 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v9gjfav9t-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 27 Sep 2019 07:54:08 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <groug@kaod.org>;
        Fri, 27 Sep 2019 12:54:06 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 27 Sep 2019 12:54:02 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8RBs27J29819046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Sep 2019 11:54:02 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE7A04203F;
        Fri, 27 Sep 2019 11:54:01 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 773D54204C;
        Fri, 27 Sep 2019 11:54:01 +0000 (GMT)
Received: from bahia.lan (unknown [9.145.172.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Sep 2019 11:54:01 +0000 (GMT)
Subject: [PATCH v2 5/6] KVM: PPC: Book3S HV: XIVE: Make VP block size
 configurable
From:   Greg Kurz <groug@kaod.org>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?utf-8?q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?b?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Date:   Fri, 27 Sep 2019 13:54:01 +0200
In-Reply-To: <156958521220.1503771.2119482814236775333.stgit@bahia.lan>
References: <156958521220.1503771.2119482814236775333.stgit@bahia.lan>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19092711-0008-0000-0000-0000031BA648
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092711-0009-0000-0000-00004A3A457B
Message-Id: <156958524112.1503771.8635811810707913977.stgit@bahia.lan>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-27_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909270112
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The XIVE VP is an internal structure which allow the XIVE interrupt
controller to maintain the interrupt context state of vCPUs non
dispatched on HW threads.

When a guest is started, the XIVE KVM device allocates a block of
XIVE VPs in OPAL, enough to accommodate the highest possible vCPU
id KVM_MAX_VCPU_ID (16384) packed down to KVM_MAX_VCPUS (2048).
With a guest's core stride of 8 and a threading mode of 1 (QEMU's
default), a VM must run at least 256 vCPUs to actually need such a
range of VPs.

A POWER9 system has a limited XIVE VP space : 512k and KVM is
currently wasting this HW resource with large VP allocations,
especially since a typical VM likely runs with a lot less vCPUs.

Make the size of the VP block configurable. Add an nr_servers
field to the XIVE structure and a function to set it for this
purpose.

Split VP allocation out of the device create function. Since the
VP block isn't used before the first vCPU connects to the XIVE KVM
device, allocation is now performed by kvmppc_xive_connect_vcpu().
This gives the opportunity to set nr_servers in between:

          kvmppc_xive_create() / kvmppc_xive_native_create()
                               .
                               .
                     kvmppc_xive_set_nr_servers()
                               .
                               .
    kvmppc_xive_connect_vcpu() / kvmppc_xive_native_connect_vcpu()

The connect_vcpu() functions check that the vCPU id is below nr_servers
and if it is the first vCPU they allocate the VP block. This is protected
against a concurrent update of nr_servers by kvmppc_xive_set_nr_servers()
with the xive->lock mutex.

Also, the block is allocated once for the device lifetime: nr_servers
should stay constant otherwise connect_vcpu() could generate a boggus
VP id and likely crash OPAL. It is thus forbidden to update nr_servers
once the block is allocated.

If the VP allocation fail, return ENOSPC which seems more appropriate to
report the depletion of system wide HW resource than ENOMEM or ENXIO.

A VM using a stride of 8 and 1 thread per core with 32 vCPUs would hence
only need 256 VPs instead of 2048. If the stride is set to match the number
of threads per core, this goes further down to 32.

This will be exposed to userspace by a subsequent patch.

Signed-off-by: Greg Kurz <groug@kaod.org>
---
v2: - update nr_server check and clip down to KVM_MAX_VCPUS
      in kvmppc_xive_set_nr_servers()
---
 arch/powerpc/kvm/book3s_xive.c        |   65 +++++++++++++++++++++++++++------
 arch/powerpc/kvm/book3s_xive.h        |    4 ++
 arch/powerpc/kvm/book3s_xive_native.c |   18 +++------
 3 files changed, 62 insertions(+), 25 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index d84da9f6ee88..6c35b3d95986 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -1213,13 +1213,13 @@ void kvmppc_xive_cleanup_vcpu(struct kvm_vcpu *vcpu)
 
 static bool kvmppc_xive_vcpu_id_valid(struct kvmppc_xive *xive, u32 cpu)
 {
-	/* We have a block of KVM_MAX_VCPUS VPs. We just need to check
+	/* We have a block of xive->nr_servers VPs. We just need to check
 	 * raw vCPU ids are below the expected limit for this guest's
 	 * core stride ; kvmppc_pack_vcpu_id() will pack them down to an
 	 * index that can be safely used to compute a VP id that belongs
 	 * to the VP block.
 	 */
-	return cpu < KVM_MAX_VCPUS * xive->kvm->arch.emul_smt_mode;
+	return cpu < xive->nr_servers * xive->kvm->arch.emul_smt_mode;
 }
 
 int kvmppc_xive_compute_vp_id(struct kvmppc_xive *xive, u32 cpu, u32 *vp)
@@ -1231,6 +1231,14 @@ int kvmppc_xive_compute_vp_id(struct kvmppc_xive *xive, u32 cpu, u32 *vp)
 		return -EINVAL;
 	}
 
+	if (xive->vp_base == XIVE_INVALID_VP) {
+		xive->vp_base = xive_native_alloc_vp_block(xive->nr_servers);
+		pr_devel("VP_Base=%x nr_servers=%d\n", xive->vp_base, xive->nr_servers);
+
+		if (xive->vp_base == XIVE_INVALID_VP)
+			return -ENOSPC;
+	}
+
 	vp_id = kvmppc_xive_vp(xive, cpu);
 	if (kvmppc_xive_vp_in_use(xive->kvm, vp_id)) {
 		pr_devel("Duplicate !\n");
@@ -1858,6 +1866,43 @@ int kvmppc_xive_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
 	return 0;
 }
 
+int kvmppc_xive_set_nr_servers(struct kvmppc_xive *xive, u64 addr)
+{
+	u32 __user *ubufp = (u32 __user *) addr;
+	u32 nr_servers;
+	int rc = 0;
+
+	if (get_user(nr_servers, ubufp))
+		return -EFAULT;
+
+	pr_devel("%s nr_servers=%u\n", __func__, nr_servers);
+
+	if (!nr_servers || nr_servers > KVM_MAX_VCPU_ID)
+		return -EINVAL;
+
+	mutex_lock(&xive->lock);
+	if (xive->vp_base != XIVE_INVALID_VP)
+		/* The VP block is allocated once and freed when the device
+		 * is released. Better not allow to change its size since its
+		 * used by connect_vcpu to validate vCPU ids are valid (eg,
+		 * setting it back to a higher value could allow connect_vcpu
+		 * to come up with a VP id that goes beyond the VP block, which
+		 * is likely to cause a crash in OPAL).
+		 */
+		rc = -EBUSY;
+	else if (nr_servers > KVM_MAX_VCPUS)
+		/* We don't need more servers. Higher vCPU ids get packed
+		 * down below KVM_MAX_VCPUS by kvmppc_pack_vcpu_id().
+		 */
+		xive->nr_servers = KVM_MAX_VCPUS;
+	else
+		xive->nr_servers = nr_servers;
+
+	mutex_unlock(&xive->lock);
+
+	return rc;
+}
+
 static int xive_set_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 {
 	struct kvmppc_xive *xive = dev->private;
@@ -2025,7 +2070,6 @@ static int kvmppc_xive_create(struct kvm_device *dev, u32 type)
 {
 	struct kvmppc_xive *xive;
 	struct kvm *kvm = dev->kvm;
-	int ret = 0;
 
 	pr_devel("Creating xive for partition\n");
 
@@ -2049,18 +2093,15 @@ static int kvmppc_xive_create(struct kvm_device *dev, u32 type)
 	else
 		xive->q_page_order = xive->q_order - PAGE_SHIFT;
 
-	/* Allocate a bunch of VPs */
-	xive->vp_base = xive_native_alloc_vp_block(KVM_MAX_VCPUS);
-	pr_devel("VP_Base=%x\n", xive->vp_base);
-
-	if (xive->vp_base == XIVE_INVALID_VP)
-		ret = -ENOMEM;
+	/* VP allocation is delayed to the first call to connect_vcpu */
+	xive->vp_base = XIVE_INVALID_VP;
+	/* KVM_MAX_VCPUS limits the number of VMs to roughly 64 per sockets
+	 * on a POWER9 system.
+	 */
+	xive->nr_servers = KVM_MAX_VCPUS;
 
 	xive->single_escalation = xive_native_has_single_escalation();
 
-	if (ret)
-		return ret;
-
 	kvm->arch.xive = xive;
 	return 0;
 }
diff --git a/arch/powerpc/kvm/book3s_xive.h b/arch/powerpc/kvm/book3s_xive.h
index 90cf6ec35a68..382e3a56e789 100644
--- a/arch/powerpc/kvm/book3s_xive.h
+++ b/arch/powerpc/kvm/book3s_xive.h
@@ -135,6 +135,9 @@ struct kvmppc_xive {
 	/* Flags */
 	u8	single_escalation;
 
+	/* Number of entries in the VP block */
+	u32	nr_servers;
+
 	struct kvmppc_xive_ops *ops;
 	struct address_space   *mapping;
 	struct mutex mapping_lock;
@@ -297,6 +300,7 @@ struct kvmppc_xive *kvmppc_xive_get_device(struct kvm *kvm, u32 type);
 void xive_cleanup_single_escalation(struct kvm_vcpu *vcpu,
 				    struct kvmppc_xive_vcpu *xc, int irq);
 int kvmppc_xive_compute_vp_id(struct kvmppc_xive *xive, u32 cpu, u32 *vp);
+int kvmppc_xive_set_nr_servers(struct kvmppc_xive *xive, u64 addr);
 
 #endif /* CONFIG_KVM_XICS */
 #endif /* _KVM_PPC_BOOK3S_XICS_H */
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 5bb480b2aafd..8ab333eabeef 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -1060,7 +1060,6 @@ static int kvmppc_xive_native_create(struct kvm_device *dev, u32 type)
 {
 	struct kvmppc_xive *xive;
 	struct kvm *kvm = dev->kvm;
-	int ret = 0;
 
 	pr_devel("Creating xive native device\n");
 
@@ -1077,23 +1076,16 @@ static int kvmppc_xive_native_create(struct kvm_device *dev, u32 type)
 	mutex_init(&xive->mapping_lock);
 	mutex_init(&xive->lock);
 
-	/*
-	 * Allocate a bunch of VPs. KVM_MAX_VCPUS is a large value for
-	 * a default. Getting the max number of CPUs the VM was
-	 * configured with would improve our usage of the XIVE VP space.
+	/* VP allocation is delayed to the first call to connect_vcpu */
+	xive->vp_base = XIVE_INVALID_VP;
+	/* KVM_MAX_VCPUS limits the number of VMs to roughly 64 per sockets
+	 * on a POWER9 system.
 	 */
-	xive->vp_base = xive_native_alloc_vp_block(KVM_MAX_VCPUS);
-	pr_devel("VP_Base=%x\n", xive->vp_base);
-
-	if (xive->vp_base == XIVE_INVALID_VP)
-		ret = -ENXIO;
+	xive->nr_servers = KVM_MAX_VCPUS;
 
 	xive->single_escalation = xive_native_has_single_escalation();
 	xive->ops = &kvmppc_xive_native_ops;
 
-	if (ret)
-		return ret;
-
 	kvm->arch.xive = xive;
 	return 0;
 }

