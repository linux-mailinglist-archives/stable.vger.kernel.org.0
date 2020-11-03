Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A030A2A511A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgKCUiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:38:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729854AbgKCUiA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D1C422277;
        Tue,  3 Nov 2020 20:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435879;
        bh=9rAlsZzFgLFTFXkm/5yGO/oklm8kx78dNoBl1qoPoaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9I/o+yd8J3kDVM7XkzQXXlbG9rDVdAgK7jQy7+arRvi+jL1T/yiQrSwEhx/AWfpB
         ZMXh+ieOBNpuqdUVullauz865Plc0BH2+nEhK7hxKl3HMfWe1ngcWoM9niR2clZ2Qg
         haxCC3nHor2Qz8PpQ3BBJf7ZC1VJQmunPDx/1Ux0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>, Wei Liu <wl@xen.org>
Subject: [PATCH 5.9 009/391] xen/pciback: use lateeoi irq binding
Date:   Tue,  3 Nov 2020 21:31:00 +0100
Message-Id: <20201103203348.685761854@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit c2711441bc961b37bba0615dd7135857d189035f upstream.

In order to reduce the chance for the system becoming unresponsive due
to event storms triggered by a misbehaving pcifront use the lateeoi irq
binding for pciback and unmask the event channel only just before
leaving the event handling function.

Restructure the handling to support that scheme. Basically an event can
come in for two reasons: either a normal request for a pciback action,
which is handled in a worker, or in case the guest has finished an AER
request which was requested by pciback.

When an AER request is issued to the guest and a normal pciback action
is currently active issue an EOI early in order to be able to receive
another event when the AER request has been finished by the guest.

Let the worker processing the normal requests run until no further
request is pending, instead of starting a new worker ion that case.
Issue the EOI only just before leaving the worker.

This scheme allows to drop calling the generic function
xen_pcibk_test_and_schedule_op() after processing of any request as
the handling of both request types is now separated more cleanly.

This is part of XSA-332.

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Wei Liu <wl@xen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/xen-pciback/pci_stub.c    |   13 ++++-----
 drivers/xen/xen-pciback/pciback.h     |   12 +++++++-
 drivers/xen/xen-pciback/pciback_ops.c |   48 ++++++++++++++++++++++++++--------
 drivers/xen/xen-pciback/xenbus.c      |    2 -
 4 files changed, 56 insertions(+), 19 deletions(-)

--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -734,10 +734,17 @@ static pci_ers_result_t common_process(s
 	wmb();
 	notify_remote_via_irq(pdev->evtchn_irq);
 
+	/* Enable IRQ to signal "request done". */
+	xen_pcibk_lateeoi(pdev, 0);
+
 	ret = wait_event_timeout(xen_pcibk_aer_wait_queue,
 				 !(test_bit(_XEN_PCIB_active, (unsigned long *)
 				 &sh_info->flags)), 300*HZ);
 
+	/* Enable IRQ for pcifront request if not already active. */
+	if (!test_bit(_PDEVF_op_active, &pdev->flags))
+		xen_pcibk_lateeoi(pdev, 0);
+
 	if (!ret) {
 		if (test_bit(_XEN_PCIB_active,
 			(unsigned long *)&sh_info->flags)) {
@@ -751,12 +758,6 @@ static pci_ers_result_t common_process(s
 	}
 	clear_bit(_PCIB_op_pending, (unsigned long *)&pdev->flags);
 
-	if (test_bit(_XEN_PCIF_active,
-		(unsigned long *)&sh_info->flags)) {
-		dev_dbg(&psdev->dev->dev, "schedule pci_conf service\n");
-		xen_pcibk_test_and_schedule_op(psdev->pdev);
-	}
-
 	res = (pci_ers_result_t)aer_op->err;
 	return res;
 }
--- a/drivers/xen/xen-pciback/pciback.h
+++ b/drivers/xen/xen-pciback/pciback.h
@@ -14,6 +14,7 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/atomic.h>
+#include <xen/events.h>
 #include <xen/interface/io/pciif.h>
 
 #define DRV_NAME	"xen-pciback"
@@ -27,6 +28,8 @@ struct pci_dev_entry {
 #define PDEVF_op_active		(1<<(_PDEVF_op_active))
 #define _PCIB_op_pending	(1)
 #define PCIB_op_pending		(1<<(_PCIB_op_pending))
+#define _EOI_pending		(2)
+#define EOI_pending		(1<<(_EOI_pending))
 
 struct xen_pcibk_device {
 	void *pci_dev_data;
@@ -183,10 +186,15 @@ static inline void xen_pcibk_release_dev
 irqreturn_t xen_pcibk_handle_event(int irq, void *dev_id);
 void xen_pcibk_do_op(struct work_struct *data);
 
+static inline void xen_pcibk_lateeoi(struct xen_pcibk_device *pdev,
+				     unsigned int eoi_flag)
+{
+	if (test_and_clear_bit(_EOI_pending, &pdev->flags))
+		xen_irq_lateeoi(pdev->evtchn_irq, eoi_flag);
+}
+
 int xen_pcibk_xenbus_register(void);
 void xen_pcibk_xenbus_unregister(void);
-
-void xen_pcibk_test_and_schedule_op(struct xen_pcibk_device *pdev);
 #endif
 
 /* Handles shared IRQs that can to device domain and control domain. */
--- a/drivers/xen/xen-pciback/pciback_ops.c
+++ b/drivers/xen/xen-pciback/pciback_ops.c
@@ -276,26 +276,41 @@ int xen_pcibk_disable_msix(struct xen_pc
 	return 0;
 }
 #endif
+
+static inline bool xen_pcibk_test_op_pending(struct xen_pcibk_device *pdev)
+{
+	return test_bit(_XEN_PCIF_active,
+			(unsigned long *)&pdev->sh_info->flags) &&
+	       !test_and_set_bit(_PDEVF_op_active, &pdev->flags);
+}
+
 /*
 * Now the same evtchn is used for both pcifront conf_read_write request
 * as well as pcie aer front end ack. We use a new work_queue to schedule
 * xen_pcibk conf_read_write service for avoiding confict with aer_core
 * do_recovery job which also use the system default work_queue
 */
-void xen_pcibk_test_and_schedule_op(struct xen_pcibk_device *pdev)
+static void xen_pcibk_test_and_schedule_op(struct xen_pcibk_device *pdev)
 {
+	bool eoi = true;
+
 	/* Check that frontend is requesting an operation and that we are not
 	 * already processing a request */
-	if (test_bit(_XEN_PCIF_active, (unsigned long *)&pdev->sh_info->flags)
-	    && !test_and_set_bit(_PDEVF_op_active, &pdev->flags)) {
+	if (xen_pcibk_test_op_pending(pdev)) {
 		schedule_work(&pdev->op_work);
+		eoi = false;
 	}
 	/*_XEN_PCIB_active should have been cleared by pcifront. And also make
 	sure xen_pcibk is waiting for ack by checking _PCIB_op_pending*/
 	if (!test_bit(_XEN_PCIB_active, (unsigned long *)&pdev->sh_info->flags)
 	    && test_bit(_PCIB_op_pending, &pdev->flags)) {
 		wake_up(&xen_pcibk_aer_wait_queue);
+		eoi = false;
 	}
+
+	/* EOI if there was nothing to do. */
+	if (eoi)
+		xen_pcibk_lateeoi(pdev, XEN_EOI_FLAG_SPURIOUS);
 }
 
 /* Performing the configuration space reads/writes must not be done in atomic
@@ -303,10 +318,8 @@ void xen_pcibk_test_and_schedule_op(stru
  * use of semaphores). This function is intended to be called from a work
  * queue in process context taking a struct xen_pcibk_device as a parameter */
 
-void xen_pcibk_do_op(struct work_struct *data)
+static void xen_pcibk_do_one_op(struct xen_pcibk_device *pdev)
 {
-	struct xen_pcibk_device *pdev =
-		container_of(data, struct xen_pcibk_device, op_work);
 	struct pci_dev *dev;
 	struct xen_pcibk_dev_data *dev_data = NULL;
 	struct xen_pci_op *op = &pdev->op;
@@ -379,16 +392,31 @@ void xen_pcibk_do_op(struct work_struct
 	smp_mb__before_atomic(); /* /after/ clearing PCIF_active */
 	clear_bit(_PDEVF_op_active, &pdev->flags);
 	smp_mb__after_atomic(); /* /before/ final check for work */
+}
 
-	/* Check to see if the driver domain tried to start another request in
-	 * between clearing _XEN_PCIF_active and clearing _PDEVF_op_active.
-	*/
-	xen_pcibk_test_and_schedule_op(pdev);
+void xen_pcibk_do_op(struct work_struct *data)
+{
+	struct xen_pcibk_device *pdev =
+		container_of(data, struct xen_pcibk_device, op_work);
+
+	do {
+		xen_pcibk_do_one_op(pdev);
+	} while (xen_pcibk_test_op_pending(pdev));
+
+	xen_pcibk_lateeoi(pdev, 0);
 }
 
 irqreturn_t xen_pcibk_handle_event(int irq, void *dev_id)
 {
 	struct xen_pcibk_device *pdev = dev_id;
+	bool eoi;
+
+	/* IRQs might come in before pdev->evtchn_irq is written. */
+	if (unlikely(pdev->evtchn_irq != irq))
+		pdev->evtchn_irq = irq;
+
+	eoi = test_and_set_bit(_EOI_pending, &pdev->flags);
+	WARN(eoi, "IRQ while EOI pending\n");
 
 	xen_pcibk_test_and_schedule_op(pdev);
 
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -123,7 +123,7 @@ static int xen_pcibk_do_attach(struct xe
 
 	pdev->sh_info = vaddr;
 
-	err = bind_interdomain_evtchn_to_irqhandler(
+	err = bind_interdomain_evtchn_to_irqhandler_lateeoi(
 		pdev->xdev->otherend_id, remote_evtchn, xen_pcibk_handle_event,
 		0, DRV_NAME, pdev);
 	if (err < 0) {


