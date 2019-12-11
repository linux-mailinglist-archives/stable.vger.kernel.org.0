Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63D2511B822
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730320AbfLKQMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:12:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:57516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730595AbfLKPJa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:09:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A84D92173E;
        Wed, 11 Dec 2019 15:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076969;
        bh=QZ0cs6rH6n1Q7qsmq1TmRkgiIWevSyuM7/uNSv/U0Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdeDd2y8u2UwVlGd91+1KxrhIFqygg/ninhi+TeYrYbU3YhTFUbJkGkKQiKFPvq65
         VlDuuj7nO9SmbQR2jlsJpMBSAcAdwqnXWfZf+abji3h5K2Or9y3M9c3t5fZzfmFku5
         jCxk2XaLxbGk54DyViwtnRN4lSYljZT60CY+KbUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>, Lijun Pan <ljp@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH 5.4 59/92] KVM: PPC: Book3S HV: XIVE: Free previous EQ page when setting up a new one
Date:   Wed, 11 Dec 2019 16:05:50 +0100
Message-Id: <20191211150248.297201833@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kurz <groug@kaod.org>

commit 31a88c82b466d2f31a44e21c479f45b4732ccfd0 upstream.

The EQ page is allocated by the guest and then passed to the hypervisor
with the H_INT_SET_QUEUE_CONFIG hcall. A reference is taken on the page
before handing it over to the HW. This reference is dropped either when
the guest issues the H_INT_RESET hcall or when the KVM device is released.
But, the guest can legitimately call H_INT_SET_QUEUE_CONFIG several times,
either to reset the EQ (vCPU hot unplug) or to set a new EQ (guest reboot).
In both cases the existing EQ page reference is leaked because we simply
overwrite it in the XIVE queue structure without calling put_page().

This is especially visible when the guest memory is backed with huge pages:
start a VM up to the guest userspace, either reboot it or unplug a vCPU,
quit QEMU. The leak is observed by comparing the value of HugePages_Free in
/proc/meminfo before and after the VM is run.

Ideally we'd want the XIVE code to handle the EQ page de-allocation at the
platform level. This isn't the case right now because the various XIVE
drivers have different allocation needs. It could maybe worth introducing
hooks for this purpose instead of exposing XIVE internals to the drivers,
but this is certainly a huge work to be done later.

In the meantime, for easier backport, fix both vCPU unplug and guest reboot
leaks by introducing a wrapper around xive_native_configure_queue() that
does the necessary cleanup.

Reported-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org # v5.2
Fixes: 13ce3297c576 ("KVM: PPC: Book3S HV: XIVE: Add controls for the EQ configuration")
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Greg Kurz <groug@kaod.org>
Tested-by: Lijun Pan <ljp@linux.ibm.com>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_xive_native.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -50,6 +50,24 @@ static void kvmppc_xive_native_cleanup_q
 	}
 }
 
+static int kvmppc_xive_native_configure_queue(u32 vp_id, struct xive_q *q,
+					      u8 prio, __be32 *qpage,
+					      u32 order, bool can_escalate)
+{
+	int rc;
+	__be32 *qpage_prev = q->qpage;
+
+	rc = xive_native_configure_queue(vp_id, q, prio, qpage, order,
+					 can_escalate);
+	if (rc)
+		return rc;
+
+	if (qpage_prev)
+		put_page(virt_to_page(qpage_prev));
+
+	return rc;
+}
+
 void kvmppc_xive_native_cleanup_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct kvmppc_xive_vcpu *xc = vcpu->arch.xive_vcpu;
@@ -582,19 +600,14 @@ static int kvmppc_xive_native_set_queue_
 		q->guest_qaddr  = 0;
 		q->guest_qshift = 0;
 
-		rc = xive_native_configure_queue(xc->vp_id, q, priority,
-						 NULL, 0, true);
+		rc = kvmppc_xive_native_configure_queue(xc->vp_id, q, priority,
+							NULL, 0, true);
 		if (rc) {
 			pr_err("Failed to reset queue %d for VCPU %d: %d\n",
 			       priority, xc->server_num, rc);
 			return rc;
 		}
 
-		if (q->qpage) {
-			put_page(virt_to_page(q->qpage));
-			q->qpage = NULL;
-		}
-
 		return 0;
 	}
 
@@ -653,8 +666,8 @@ static int kvmppc_xive_native_set_queue_
 	  * OPAL level because the use of END ESBs is not supported by
 	  * Linux.
 	  */
-	rc = xive_native_configure_queue(xc->vp_id, q, priority,
-					 (__be32 *) qaddr, kvm_eq.qshift, true);
+	rc = kvmppc_xive_native_configure_queue(xc->vp_id, q, priority,
+					(__be32 *) qaddr, kvm_eq.qshift, true);
 	if (rc) {
 		pr_err("Failed to configure queue %d for VCPU %d: %d\n",
 		       priority, xc->server_num, rc);


