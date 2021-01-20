Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D642FC986
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbhATC2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:28:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729899AbhATB1w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:27:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C33D2313F;
        Wed, 20 Jan 2021 01:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105994;
        bh=TvoxUaYKyTJSm4C6R/yNO1CK4InwfvxfRJEgKERmIds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iw1942wQpAYEMwLB3v+CfKaT6lDldWdKdDUkvvDJ74+WHow1jsHLccmRzpwsrTLGN
         b0ORMMZCq+fbxUQEZ2lrx11KSN7ilYU2pPhjOpURU6ByMZmVAtjzdIjDUEbhEa/QWF
         GeJkrOHlkDhPMhy0+994wwARQQKwxWHjRqDGzDevUH89vF7MHvjHBcG4M+fx6ZoziL
         aH58FLXib9ikWVwE9h/bVks5N4srqorAW000+2qzHNh4Fn58927NxRcTI2fNFAwYSC
         JvnLbITQgOOI3+X9DZaoJi3kFO7pjXBNgwCsgcNFfpmlQDFWTvzvRx8Urg5CQo2TaL
         nfO79yGp0pLag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Woodhouse <dwmw@amazon.co.uk>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>,
        xen-devel@lists.xenproject.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 24/45] xen: Fix event channel callback via INTX/GSI
Date:   Tue, 19 Jan 2021 20:25:41 -0500
Message-Id: <20210120012602.769683-24-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

[ Upstream commit 3499ba8198cad47b731792e5e56b9ec2a78a83a2 ]

For a while, event channel notification via the PCI platform device
has been broken, because we attempt to communicate with xenstore before
we even have notifications working, with the xs_reset_watches() call
in xs_init().

We tend to get away with this on Xen versions below 4.0 because we avoid
calling xs_reset_watches() anyway, because xenstore might not cope with
reading a non-existent key. And newer Xen *does* have the vector
callback support, so we rarely fall back to INTX/GSI delivery.

To fix it, clean up a bit of the mess of xs_init() and xenbus_probe()
startup. Call xs_init() directly from xenbus_init() only in the !XS_HVM
case, deferring it to be called from xenbus_probe() in the XS_HVM case
instead.

Then fix up the invocation of xenbus_probe() to happen either from its
device_initcall if the callback is available early enough, or when the
callback is finally set up. This means that the hack of calling
xenbus_probe() from a workqueue after the first interrupt, or directly
from the PCI platform device setup, is no longer needed.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20210113132606.422794-2-dwmw2@infradead.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/xen/enlighten.c          |  2 +-
 drivers/xen/events/events_base.c  | 10 ----
 drivers/xen/platform-pci.c        |  1 -
 drivers/xen/xenbus/xenbus.h       |  1 +
 drivers/xen/xenbus/xenbus_comms.c |  8 ---
 drivers/xen/xenbus/xenbus_probe.c | 81 +++++++++++++++++++++++++------
 include/xen/xenbus.h              |  2 +-
 7 files changed, 70 insertions(+), 35 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 60e901cd0de6a..5a957a9a09843 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -371,7 +371,7 @@ static int __init xen_guest_init(void)
 	}
 	gnttab_init();
 	if (!xen_initial_domain())
-		xenbus_probe(NULL);
+		xenbus_probe();
 
 	/*
 	 * Making sure board specific code will not set up ops for
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 6038c4c35db5a..bbebe248b7264 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -2010,16 +2010,6 @@ static struct irq_chip xen_percpu_chip __read_mostly = {
 	.irq_ack		= ack_dynirq,
 };
 
-int xen_set_callback_via(uint64_t via)
-{
-	struct xen_hvm_param a;
-	a.domid = DOMID_SELF;
-	a.index = HVM_PARAM_CALLBACK_IRQ;
-	a.value = via;
-	return HYPERVISOR_hvm_op(HVMOP_set_param, &a);
-}
-EXPORT_SYMBOL_GPL(xen_set_callback_via);
-
 #ifdef CONFIG_XEN_PVHVM
 /* Vector callbacks are better than PCI interrupts to receive event
  * channel notifications because we can receive vector callbacks on any
diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index dd911e1ff782c..9db557b76511b 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -149,7 +149,6 @@ static int platform_pci_probe(struct pci_dev *pdev,
 	ret = gnttab_init();
 	if (ret)
 		goto grant_out;
-	xenbus_probe(NULL);
 	return 0;
 grant_out:
 	gnttab_free_auto_xlat_frames();
diff --git a/drivers/xen/xenbus/xenbus.h b/drivers/xen/xenbus/xenbus.h
index 2a93b7c9c1599..dc15373354144 100644
--- a/drivers/xen/xenbus/xenbus.h
+++ b/drivers/xen/xenbus/xenbus.h
@@ -115,6 +115,7 @@ int xenbus_probe_node(struct xen_bus_type *bus,
 		      const char *type,
 		      const char *nodename);
 int xenbus_probe_devices(struct xen_bus_type *bus);
+void xenbus_probe(void);
 
 void xenbus_dev_changed(const char *node, struct xen_bus_type *bus);
 
diff --git a/drivers/xen/xenbus/xenbus_comms.c b/drivers/xen/xenbus/xenbus_comms.c
index eb5151fc8efab..e5fda0256feb3 100644
--- a/drivers/xen/xenbus/xenbus_comms.c
+++ b/drivers/xen/xenbus/xenbus_comms.c
@@ -57,16 +57,8 @@ DEFINE_MUTEX(xs_response_mutex);
 static int xenbus_irq;
 static struct task_struct *xenbus_task;
 
-static DECLARE_WORK(probe_work, xenbus_probe);
-
-
 static irqreturn_t wake_waiting(int irq, void *unused)
 {
-	if (unlikely(xenstored_ready == 0)) {
-		xenstored_ready = 1;
-		schedule_work(&probe_work);
-	}
-
 	wake_up(&xb_waitq);
 	return IRQ_HANDLED;
 }
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 44634d970a5ca..c8f0282bb6497 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -683,29 +683,76 @@ void unregister_xenstore_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(unregister_xenstore_notifier);
 
-void xenbus_probe(struct work_struct *unused)
+void xenbus_probe(void)
 {
 	xenstored_ready = 1;
 
+	/*
+	 * In the HVM case, xenbus_init() deferred its call to
+	 * xs_init() in case callbacks were not operational yet.
+	 * So do it now.
+	 */
+	if (xen_store_domain_type == XS_HVM)
+		xs_init();
+
 	/* Notify others that xenstore is up */
 	blocking_notifier_call_chain(&xenstore_chain, 0, NULL);
 }
-EXPORT_SYMBOL_GPL(xenbus_probe);
 
-static int __init xenbus_probe_initcall(void)
+/*
+ * Returns true when XenStore init must be deferred in order to
+ * allow the PCI platform device to be initialised, before we
+ * can actually have event channel interrupts working.
+ */
+static bool xs_hvm_defer_init_for_callback(void)
 {
-	if (!xen_domain())
-		return -ENODEV;
+#ifdef CONFIG_XEN_PVHVM
+	return xen_store_domain_type == XS_HVM &&
+		!xen_have_vector_callback;
+#else
+	return false;
+#endif
+}
 
-	if (xen_initial_domain() || xen_hvm_domain())
-		return 0;
+static int __init xenbus_probe_initcall(void)
+{
+	/*
+	 * Probe XenBus here in the XS_PV case, and also XS_HVM unless we
+	 * need to wait for the platform PCI device to come up.
+	 */
+	if (xen_store_domain_type == XS_PV ||
+	    (xen_store_domain_type == XS_HVM &&
+	     !xs_hvm_defer_init_for_callback()))
+		xenbus_probe();
 
-	xenbus_probe(NULL);
 	return 0;
 }
-
 device_initcall(xenbus_probe_initcall);
 
+int xen_set_callback_via(uint64_t via)
+{
+	struct xen_hvm_param a;
+	int ret;
+
+	a.domid = DOMID_SELF;
+	a.index = HVM_PARAM_CALLBACK_IRQ;
+	a.value = via;
+
+	ret = HYPERVISOR_hvm_op(HVMOP_set_param, &a);
+	if (ret)
+		return ret;
+
+	/*
+	 * If xenbus_probe_initcall() deferred the xenbus_probe()
+	 * due to the callback not functioning yet, we can do it now.
+	 */
+	if (!xenstored_ready && xs_hvm_defer_init_for_callback())
+		xenbus_probe();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(xen_set_callback_via);
+
 /* Set up event channel for xenstored which is run as a local process
  * (this is normally used only in dom0)
  */
@@ -818,11 +865,17 @@ static int __init xenbus_init(void)
 		break;
 	}
 
-	/* Initialize the interface to xenstore. */
-	err = xs_init();
-	if (err) {
-		pr_warn("Error initializing xenstore comms: %i\n", err);
-		goto out_error;
+	/*
+	 * HVM domains may not have a functional callback yet. In that
+	 * case let xs_init() be called from xenbus_probe(), which will
+	 * get invoked at an appropriate time.
+	 */
+	if (xen_store_domain_type != XS_HVM) {
+		err = xs_init();
+		if (err) {
+			pr_warn("Error initializing xenstore comms: %i\n", err);
+			goto out_error;
+		}
 	}
 
 	if ((xen_store_domain_type != XS_LOCAL) &&
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index 00c7235ae93e7..2c43b0ef1e4d5 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -192,7 +192,7 @@ void xs_suspend_cancel(void);
 
 struct work_struct;
 
-void xenbus_probe(struct work_struct *);
+void xenbus_probe(void);
 
 #define XENBUS_IS_ERR_READ(str) ({			\
 	if (!IS_ERR(str) && strlen(str) == 0) {		\
-- 
2.27.0

