Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46217C04B6
	for <lists+stable@lfdr.de>; Fri, 27 Sep 2019 13:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfI0LyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Sep 2019 07:54:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55236 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727378AbfI0LyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Sep 2019 07:54:17 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8RBkjtu085147
        for <stable@vger.kernel.org>; Fri, 27 Sep 2019 07:54:15 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v9g6wbnxa-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 27 Sep 2019 07:54:15 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <groug@kaod.org>;
        Fri, 27 Sep 2019 12:54:13 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 27 Sep 2019 12:54:08 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8RBs7CE59506738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Sep 2019 11:54:07 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B12AB11C058;
        Fri, 27 Sep 2019 11:54:07 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BEA211C052;
        Fri, 27 Sep 2019 11:54:07 +0000 (GMT)
Received: from bahia.lan (unknown [9.145.172.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Sep 2019 11:54:07 +0000 (GMT)
Subject: [PATCH v2 6/6] KVM: PPC: Book3S HV: XIVE: Allow userspace to set
 the # of VPs
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
Date:   Fri, 27 Sep 2019 13:54:07 +0200
In-Reply-To: <156958521220.1503771.2119482814236775333.stgit@bahia.lan>
References: <156958521220.1503771.2119482814236775333.stgit@bahia.lan>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19092711-0012-0000-0000-000003514B8B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092711-0013-0000-0000-0000218BE6CA
Message-Id: <156958524691.1503771.2453080873820103723.stgit@bahia.lan>
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

Add a new attribute to both XIVE and XICS-on-XIVE KVM devices so that
userspace can tell how many interrupt servers it needs. If a VM needs
less than the current default of KVM_MAX_VCPUS (2048), we can allocate
less VPs in OPAL. Combined with a core stride (VSMT) that matches the
number of guest threads per core, this may substantially increases the
number of VMs that can run concurrently with an in-kernel XIVE device.

Since the legacy XIVE KVM device is exposed to userspace through the
XICS KVM API, a new attribute group is added to it for this purpose.
While here, fix the syntax of the existing KVM_DEV_XICS_GRP_SOURCES
in the XICS documentation.

Signed-off-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
---
v2: - changelog update
---
 Documentation/virt/kvm/devices/xics.txt |   14 ++++++++++++--
 Documentation/virt/kvm/devices/xive.txt |    8 ++++++++
 arch/powerpc/include/uapi/asm/kvm.h     |    3 +++
 arch/powerpc/kvm/book3s_xive.c          |   10 ++++++++++
 arch/powerpc/kvm/book3s_xive_native.c   |    3 +++
 5 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/devices/xics.txt b/Documentation/virt/kvm/devices/xics.txt
index 42864935ac5d..423332dda7bc 100644
--- a/Documentation/virt/kvm/devices/xics.txt
+++ b/Documentation/virt/kvm/devices/xics.txt
@@ -3,9 +3,19 @@ XICS interrupt controller
 Device type supported: KVM_DEV_TYPE_XICS
 
 Groups:
-  KVM_DEV_XICS_SOURCES
+  1. KVM_DEV_XICS_GRP_SOURCES
   Attributes: One per interrupt source, indexed by the source number.
 
+  2. KVM_DEV_XICS_GRP_CTRL
+  Attributes:
+    2.1 KVM_DEV_XICS_NR_SERVERS (write only)
+  The kvm_device_attr.addr points to a __u32 value which is the number of
+  interrupt server numbers (ie, highest possible vcpu id plus one).
+  Errors:
+    -EINVAL: Value greater than KVM_MAX_VCPU_ID.
+    -EFAULT: Invalid user pointer for attr->addr.
+    -EBUSY:  A vcpu is already connected to the device.
+
 This device emulates the XICS (eXternal Interrupt Controller
 Specification) defined in PAPR.  The XICS has a set of interrupt
 sources, each identified by a 20-bit source number, and a set of
@@ -38,7 +48,7 @@ least-significant end of the word:
 
 Each source has 64 bits of state that can be read and written using
 the KVM_GET_DEVICE_ATTR and KVM_SET_DEVICE_ATTR ioctls, specifying the
-KVM_DEV_XICS_SOURCES attribute group, with the attribute number being
+KVM_DEV_XICS_GRP_SOURCES attribute group, with the attribute number being
 the interrupt source number.  The 64 bit state word has the following
 bitfields, starting from the least-significant end of the word:
 
diff --git a/Documentation/virt/kvm/devices/xive.txt b/Documentation/virt/kvm/devices/xive.txt
index 9a24a4525253..f5d1d6b5af61 100644
--- a/Documentation/virt/kvm/devices/xive.txt
+++ b/Documentation/virt/kvm/devices/xive.txt
@@ -78,6 +78,14 @@ the legacy interrupt mode, referred as XICS (POWER7/8).
     migrating the VM.
     Errors: none
 
+    1.3 KVM_DEV_XIVE_NR_SERVERS (write only)
+    The kvm_device_attr.addr points to a __u32 value which is the number of
+    interrupt server numbers (ie, highest possible vcpu id plus one).
+    Errors:
+      -EINVAL: Value greater than KVM_MAX_VCPU_ID.
+      -EFAULT: Invalid user pointer for attr->addr.
+      -EBUSY:  A vCPU is already connected to the device.
+
   2. KVM_DEV_XIVE_GRP_SOURCE (write only)
   Initializes a new source in the XIVE device and mask it.
   Attributes:
diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
index b0f72dea8b11..264e266a85bf 100644
--- a/arch/powerpc/include/uapi/asm/kvm.h
+++ b/arch/powerpc/include/uapi/asm/kvm.h
@@ -667,6 +667,8 @@ struct kvm_ppc_cpu_char {
 
 /* PPC64 eXternal Interrupt Controller Specification */
 #define KVM_DEV_XICS_GRP_SOURCES	1	/* 64-bit source attributes */
+#define KVM_DEV_XICS_GRP_CTRL		2
+#define   KVM_DEV_XICS_NR_SERVERS	1
 
 /* Layout of 64-bit source attribute values */
 #define  KVM_XICS_DESTINATION_SHIFT	0
@@ -683,6 +685,7 @@ struct kvm_ppc_cpu_char {
 #define KVM_DEV_XIVE_GRP_CTRL		1
 #define   KVM_DEV_XIVE_RESET		1
 #define   KVM_DEV_XIVE_EQ_SYNC		2
+#define   KVM_DEV_XIVE_NR_SERVERS	3
 #define KVM_DEV_XIVE_GRP_SOURCE		2	/* 64-bit source identifier */
 #define KVM_DEV_XIVE_GRP_SOURCE_CONFIG	3	/* 64-bit source identifier */
 #define KVM_DEV_XIVE_GRP_EQ_CONFIG	4	/* 64-bit EQ identifier */
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 6c35b3d95986..66858b7d3c6b 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -1911,6 +1911,11 @@ static int xive_set_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 	switch (attr->group) {
 	case KVM_DEV_XICS_GRP_SOURCES:
 		return xive_set_source(xive, attr->attr, attr->addr);
+	case KVM_DEV_XICS_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_XICS_NR_SERVERS:
+			return kvmppc_xive_set_nr_servers(xive, attr->addr);
+		}
 	}
 	return -ENXIO;
 }
@@ -1936,6 +1941,11 @@ static int xive_has_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 		    attr->attr < KVMPPC_XICS_NR_IRQS)
 			return 0;
 		break;
+	case KVM_DEV_XICS_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_XICS_NR_SERVERS:
+			return 0;
+		}
 	}
 	return -ENXIO;
 }
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 8ab333eabeef..34bd123fa024 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -921,6 +921,8 @@ static int kvmppc_xive_native_set_attr(struct kvm_device *dev,
 			return kvmppc_xive_reset(xive);
 		case KVM_DEV_XIVE_EQ_SYNC:
 			return kvmppc_xive_native_eq_sync(xive);
+		case KVM_DEV_XIVE_NR_SERVERS:
+			return kvmppc_xive_set_nr_servers(xive, attr->addr);
 		}
 		break;
 	case KVM_DEV_XIVE_GRP_SOURCE:
@@ -960,6 +962,7 @@ static int kvmppc_xive_native_has_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_XIVE_RESET:
 		case KVM_DEV_XIVE_EQ_SYNC:
+		case KVM_DEV_XIVE_NR_SERVERS:
 			return 0;
 		}
 		break;

