Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B9B2A4B2C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgKCQWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:22:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:58854 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727923AbgKCQWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 11:22:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604420560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7jLkVKjpNB4J2F4Ku3d8Zi6XIvPtkFRZAd0/gLZgDX4=;
        b=rW/Yp64x4Gnts14JhSi4/WJDpl8BIs8ikyDCNthFDLO5v3juLg6itl+EDlquhIYmBd+nwi
        ZS5OzCSfI1fs9MAUayIcZ2vK1MjfL5GRK/n/dND+rQxIyPnneY1WHxnIFkn+3edxjj3nDS
        BVArda7LRtfxvxve9xmKJ8S60OvysV4=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 298A9ADA8
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 16:22:40 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH 09/13] xen/pciback: use lateeoi irq binding
Date:   Tue,  3 Nov 2020 17:22:34 +0100
Message-Id: <20201103162238.30264-10-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103162238.30264-1-jgross@suse.com>
References: <20201103162238.30264-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

This is upstream commit c2711441bc961b37bba0615dd7135857d189035f

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Wei Liu <wl@xen.org>
---
 drivers/xen/xen-pciback/pci_stub.c    | 14 ++++----
 drivers/xen/xen-pciback/pciback.h     | 12 +++++--
 drivers/xen/xen-pciback/pciback_ops.c | 48 +++++++++++++++++++++------
 drivers/xen/xen-pciback/xenbus.c      |  2 +-
 4 files changed, 56 insertions(+), 20 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 47c6df53cabf..e21b82921c33 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -681,10 +681,17 @@ static pci_ers_result_t common_process(struct pcistub_device *psdev,
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
@@ -698,13 +705,6 @@ static pci_ers_result_t common_process(struct pcistub_device *psdev,
 	}
 	clear_bit(_PCIB_op_pending, (unsigned long *)&pdev->flags);
 
-	if (test_bit(_XEN_PCIF_active,
-		(unsigned long *)&sh_info->flags)) {
-		dev_dbg(&psdev->dev->dev,
-			"schedule pci_conf service in " DRV_NAME "\n");
-		xen_pcibk_test_and_schedule_op(psdev->pdev);
-	}
-
 	res = (pci_ers_result_t)aer_op->err;
 	return res;
 }
diff --git a/drivers/xen/xen-pciback/pciback.h b/drivers/xen/xen-pciback/pciback.h
index 4d529f3e40df..f44a425d1a5a 100644
--- a/drivers/xen/xen-pciback/pciback.h
+++ b/drivers/xen/xen-pciback/pciback.h
@@ -13,6 +13,7 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/atomic.h>
+#include <xen/events.h>
 #include <xen/interface/io/pciif.h>
 
 #define DRV_NAME	"xen-pciback"
@@ -26,6 +27,8 @@ struct pci_dev_entry {
 #define PDEVF_op_active		(1<<(_PDEVF_op_active))
 #define _PCIB_op_pending	(1)
 #define PCIB_op_pending		(1<<(_PCIB_op_pending))
+#define _EOI_pending		(2)
+#define EOI_pending		(1<<(_EOI_pending))
 
 struct xen_pcibk_device {
 	void *pci_dev_data;
@@ -182,12 +185,17 @@ static inline void xen_pcibk_release_devices(struct xen_pcibk_device *pdev)
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
 
 extern int verbose_request;
-
-void xen_pcibk_test_and_schedule_op(struct xen_pcibk_device *pdev);
 #endif
 
 /* Handles shared IRQs that can to device domain and control domain. */
diff --git a/drivers/xen/xen-pciback/pciback_ops.c b/drivers/xen/xen-pciback/pciback_ops.c
index 49c5f0e9600a..232db7fcc523 100644
--- a/drivers/xen/xen-pciback/pciback_ops.c
+++ b/drivers/xen/xen-pciback/pciback_ops.c
@@ -296,26 +296,41 @@ int xen_pcibk_disable_msix(struct xen_pcibk_device *pdev,
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
 		queue_work(xen_pcibk_wq, &pdev->op_work);
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
@@ -323,10 +338,8 @@ void xen_pcibk_test_and_schedule_op(struct xen_pcibk_device *pdev)
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
@@ -399,16 +412,31 @@ void xen_pcibk_do_op(struct work_struct *data)
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
 
diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index 4843741e703a..48196347f2f9 100644
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -124,7 +124,7 @@ static int xen_pcibk_do_attach(struct xen_pcibk_device *pdev, int gnt_ref,
 
 	pdev->sh_info = vaddr;
 
-	err = bind_interdomain_evtchn_to_irqhandler(
+	err = bind_interdomain_evtchn_to_irqhandler_lateeoi(
 		pdev->xdev->otherend_id, remote_evtchn, xen_pcibk_handle_event,
 		0, DRV_NAME, pdev);
 	if (err < 0) {
-- 
2.26.2

