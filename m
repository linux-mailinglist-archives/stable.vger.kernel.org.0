Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADA1F712C
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 10:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKKJtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 04:49:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1252 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726958AbfKKJtf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 04:49:35 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAB9lW4E191337
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 04:49:34 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w74dmt66b-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 04:49:33 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <groug@kaod.org>;
        Mon, 11 Nov 2019 09:49:32 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 11 Nov 2019 09:49:28 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAB9nRvh35520728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 09:49:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 777474C059;
        Mon, 11 Nov 2019 09:49:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 181CF4C044;
        Mon, 11 Nov 2019 09:49:27 +0000 (GMT)
Received: from bahia.lan (unknown [9.145.184.11])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Nov 2019 09:49:27 +0000 (GMT)
Subject: [PATCH] KVM: PPC: Book3S HV: XIVE: Free previous EQ page when
 setting up a new one
From:   Greg Kurz <groug@kaod.org>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?utf-8?q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Lijun Pan <ljp@linux.ibm.com>,
        Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 11 Nov 2019 10:49:26 +0100
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19111109-4275-0000-0000-0000037CAF98
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111109-4276-0000-0000-00003890081E
Message-Id: <157346576671.818016.10401178701091199969.stgit@bahia.lan>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-11_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911110097
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The EQ page is allocated by the guest and then passed to the hypervisor
with the H_INT_SET_QUEUE_CONFIG hcall. A reference is taken on the page
before handing it over to the HW. This reference is dropped either when
the guest issues the H_INT_RESET hcall or when the KVM device is released.
But, the guest can legitimately call H_INT_SET_QUEUE_CONFIG several times
to reset the EQ (vCPU hot unplug) or set a new EQ (guest reboot). In both
cases the EQ page reference is leaked. This is especially visible when
the guest memory is backed with huge pages: start a VM up to the guest
userspace, either reboot it or unplug a vCPU, quit QEMU. The leak is
observed by comparing the value of HugePages_Free in /proc/meminfo before
and after the VM is run.

Note that the EQ reset path seems to be calling put_page() but this is
done after xive_native_configure_queue() which clears the qpage field
in the XIVE queue structure, ie. the put_page() block is a nop and the
previous page pointer was just overwritten anyway. In the other case of
configuring a new EQ page, nothing seems to be done to release the old
one.

Fix both cases by always calling put_page() on the existing EQ page in
kvmppc_xive_native_set_queue_config(). This is a seemless change for the
EQ reset case. However this causes xive_native_configure_queue() to be
called twice for the new EQ page case: one time to reset the EQ and another
time to configure the new page. This is needed because we cannot release
the EQ page before calling xive_native_configure_queue() since it may still
be used by the HW. We cannot modify xive_native_configure_queue() to drop
the reference either because this function is also used by the XICS-on-XIVE
device which requires free_pages() instead of put_page(). This isn't a big
deal anyway since H_INT_SET_QUEUE_CONFIG isn't a hot path.

Reported-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org # v5.2
Fixes: 13ce3297c576 ("KVM: PPC: Book3S HV: XIVE: Add controls for the EQ configuration")
Signed-off-by: Greg Kurz <groug@kaod.org>
---
 arch/powerpc/kvm/book3s_xive_native.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 34bd123fa024..8ab908d23dc2 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -570,10 +570,12 @@ static int kvmppc_xive_native_set_queue_config(struct kvmppc_xive *xive,
 		 __func__, server, priority, kvm_eq.flags,
 		 kvm_eq.qshift, kvm_eq.qaddr, kvm_eq.qtoggle, kvm_eq.qindex);
 
-	/* reset queue and disable queueing */
-	if (!kvm_eq.qshift) {
-		q->guest_qaddr  = 0;
-		q->guest_qshift = 0;
+	/*
+	 * Reset queue and disable queueing. It will be re-enabled
+	 * later on if the guest is configuring a new EQ page.
+	 */
+	if (q->guest_qshift) {
+		page = virt_to_page(q->qpage);
 
 		rc = xive_native_configure_queue(xc->vp_id, q, priority,
 						 NULL, 0, true);
@@ -583,12 +585,13 @@ static int kvmppc_xive_native_set_queue_config(struct kvmppc_xive *xive,
 			return rc;
 		}
 
-		if (q->qpage) {
-			put_page(virt_to_page(q->qpage));
-			q->qpage = NULL;
-		}
+		put_page(page);
 
-		return 0;
+		if (!kvm_eq.qshift) {
+			q->guest_qaddr  = 0;
+			q->guest_qshift = 0;
+			return 0;
+		}
 	}
 
 	/*

