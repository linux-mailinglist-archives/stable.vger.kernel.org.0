Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4806DA7E0
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 05:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjDGDHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 23:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjDGDHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 23:07:49 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10C87EEF
        for <stable@vger.kernel.org>; Thu,  6 Apr 2023 20:07:46 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-62d9366a6ddso214326b3a.1
        for <stable@vger.kernel.org>; Thu, 06 Apr 2023 20:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680836866;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RlwT6WOu5XTXWEIn3tXtm8KNEAZlQ8mBDPlk08yrJQ4=;
        b=CleWTJk30gYg+Vg/N6P0011m/fbSb10IS8m46LDmc7GMwsRkVHs7rB6OwO65eTeozX
         kOJaiyjSMKqD2KxY0Fc18Nys/qWC+p7p75mKrjR+ymEQdcoGQZT2qzi25g9UXn6UtyJ7
         KicIJx75l3NlfT13rE4IDqJel4HsiV3QFK/og/81C65Ik4sv/BaA5+c0enAG7W7HE84H
         RLBQY6bDtOgEKGp/1d02OWtA1cbKPuvZrt1XtN8GKtqZ96/yFCvpBF0bWRe5TwBF3Ddg
         fxAvGmC68fagDsz9Va0wYlJ5aiBU7UordLgeNNKSP3UTpu3bxT8iWlpMDchQzVbiMOBG
         SWMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680836866;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RlwT6WOu5XTXWEIn3tXtm8KNEAZlQ8mBDPlk08yrJQ4=;
        b=ca/cCsKtPzMryvLC/J8PjO4Oif8Xe9YAg+JnildwEVJahQVJDFh83//UbMhJKckJdp
         B31ZwNvvpDVynweKENzHoE3Q8hoPVVSGWPngnbh3nKT29h1FxHE3B+BUrZ/vinwrcZ5w
         aSCGCfK/SpE5e0pUzu38by0AQBBsuK8aKGVF2AH6ujS5synzytxqqXBdEwGouJBYAwE8
         OFpriK/MLkJtjl5GFkkepKL7ySn+9yNH0FHSewZu1DX5I1R/KOSPip/WnoHiJ7Nmuv1Q
         pbvdg0mcL05jqDsYEHQbR4jFveYQVoeexlEiuGOM69+n51LW0LfL/1Ok5QlBHfPV+Fjo
         SHCw==
X-Gm-Message-State: AAQBX9dJ1PWY+118FJ+vO5jPyTdSG/v4yTRHBWZ6fbGqnI94AjiL417e
        yWU1vlxwJA57Ex0sQmUiVv77F9UeSfs=
X-Google-Smtp-Source: AKy350bjJiCCKXb+9bbx10WPJvUkV6ODO/wcUWapXauVpLfaAmatfldAS1c9d9B4AyiD76rq+ftXlFVEgQg=
X-Received: from badhri.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:6442])
 (user=badhri job=sendgmr) by 2002:a05:6a00:2d17:b0:625:cf6d:b26b with SMTP id
 fa23-20020a056a002d1700b00625cf6db26bmr316735pfb.1.1680836865942; Thu, 06 Apr
 2023 20:07:45 -0700 (PDT)
Date:   Fri,  7 Apr 2023 03:07:40 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230407030741.3163220-1-badhri@google.com>
Subject: [PATCH v4 1/2] usb: gadget: udc: core: Invoke usb_gadget_connect only
 when started
From:   Badhri Jagan Sridharan <badhri@google.com>
To:     gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        colin.i.king@gmail.com, xuetao09@huawei.com,
        quic_eserrao@quicinc.com, water.zhangjiantao@huawei.com,
        peter.chen@freescale.com, balbi@ti.com
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Badhri Jagan Sridharan <badhri@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

usb_udc_connect_control does not check to see if the udc has already
been started. This causes gadget->ops->pullup to be called through
usb_gadget_connect when invoked from usb_udc_vbus_handler even before
usb_gadget_udc_start is called. Guard this by checking for udc->started
in usb_udc_connect_control before invoking usb_gadget_connect.

Guarding udc->vbus, udc->started, gadget->connect, gadget->deactivate
related functions with connect_lock. usb_gadget_connect_locked,
usb_gadget_disconnect_locked, usb_udc_connect_control_locked,
usb_gadget_udc_start_locked, usb_gadget_udc_stop_locked are called with
this lock held as they can be simulataneously invoked from different code
paths.

Adding an additional check to make sure udc is started(udc->started)
before pullup callback is invoked.

Cc: stable@vger.kernel.org
Fixes: 628ef0d273a6 ("usb: udc: add usb_udc_vbus_handler")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
---
Changes since v3:
* Make internal gadget_connect/disconnect functions static
Changes since v2:
* Added __must_hold marking for connect_lock
Changes since v1:
* Fixed commit message comments.
* Renamed udc_connect_control_lock to connect_lock and made it per
device.
* udc->vbus, udc->started, gadget->connect, gadget->deactivate are all
now guarded by connect_lock.
* Code now checks for udc->started to be set before invoking pullup
callback.
---
 drivers/usb/gadget/udc/core.c | 148 ++++++++++++++++++++++++----------
 1 file changed, 104 insertions(+), 44 deletions(-)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 3dcbba739db6..af92c2e8e10c 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -37,6 +37,10 @@ static struct bus_type gadget_bus_type;
  * @vbus: for udcs who care about vbus status, this value is real vbus status;
  * for udcs who do not care about vbus status, this value is always true
  * @started: the UDC's started state. True if the UDC had started.
+ * @connect_lock: protects udc->vbus, udc->started, gadget->connect, gadget->deactivate related
+ * functions. usb_gadget_connect_locked, usb_gadget_disconnect_locked,
+ * usb_udc_connect_control_locked, usb_gadget_udc_start_locked, usb_gadget_udc_stop_locked are
+ * called with this lock held.
  *
  * This represents the internal data structure which is used by the UDC-class
  * to hold information about udc driver and gadget together.
@@ -48,6 +52,7 @@ struct usb_udc {
 	struct list_head		list;
 	bool				vbus;
 	bool				started;
+	struct mutex			connect_lock;
 };
 
 static struct class *udc_class;
@@ -687,17 +692,9 @@ int usb_gadget_vbus_disconnect(struct usb_gadget *gadget)
 }
 EXPORT_SYMBOL_GPL(usb_gadget_vbus_disconnect);
 
-/**
- * usb_gadget_connect - software-controlled connect to USB host
- * @gadget:the peripheral being connected
- *
- * Enables the D+ (or potentially D-) pullup.  The host will start
- * enumerating this gadget when the pullup is active and a VBUS session
- * is active (the link is powered).
- *
- * Returns zero on success, else negative errno.
- */
-int usb_gadget_connect(struct usb_gadget *gadget)
+/* Internal version of usb_gadget_connect needs to be called with connect_lock held. */
+static int usb_gadget_connect_locked(struct usb_gadget *gadget)
+	__must_hold(&gadget->udc->connect_lock)
 {
 	int ret = 0;
 
@@ -706,10 +703,12 @@ int usb_gadget_connect(struct usb_gadget *gadget)
 		goto out;
 	}
 
-	if (gadget->deactivated) {
+	if (gadget->deactivated || !gadget->udc->started) {
 		/*
 		 * If gadget is deactivated we only save new state.
 		 * Gadget will be connected automatically after activation.
+		 *
+		 * udc first needs to be started before gadget can be pulled up.
 		 */
 		gadget->connected = true;
 		goto out;
@@ -724,22 +723,32 @@ int usb_gadget_connect(struct usb_gadget *gadget)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(usb_gadget_connect);
 
 /**
- * usb_gadget_disconnect - software-controlled disconnect from USB host
- * @gadget:the peripheral being disconnected
- *
- * Disables the D+ (or potentially D-) pullup, which the host may see
- * as a disconnect (when a VBUS session is active).  Not all systems
- * support software pullup controls.
+ * usb_gadget_connect - software-controlled connect to USB host
+ * @gadget:the peripheral being connected
  *
- * Following a successful disconnect, invoke the ->disconnect() callback
- * for the current gadget driver so that UDC drivers don't need to.
+ * Enables the D+ (or potentially D-) pullup.  The host will start
+ * enumerating this gadget when the pullup is active and a VBUS session
+ * is active (the link is powered).
  *
  * Returns zero on success, else negative errno.
  */
-int usb_gadget_disconnect(struct usb_gadget *gadget)
+int usb_gadget_connect(struct usb_gadget *gadget)
+{
+	int ret;
+
+	mutex_lock(&gadget->udc->connect_lock);
+	ret = usb_gadget_connect_locked(gadget);
+	mutex_unlock(&gadget->udc->connect_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(usb_gadget_connect);
+
+/* Internal version of usb_gadget_disconnect needs to be called with connect_lock held. */
+static int usb_gadget_disconnect_locked(struct usb_gadget *gadget)
+	__must_hold(&gadget->udc->connect_lock)
 {
 	int ret = 0;
 
@@ -751,10 +760,12 @@ int usb_gadget_disconnect(struct usb_gadget *gadget)
 	if (!gadget->connected)
 		goto out;
 
-	if (gadget->deactivated) {
+	if (gadget->deactivated || !gadget->udc->started) {
 		/*
 		 * If gadget is deactivated we only save new state.
 		 * Gadget will stay disconnected after activation.
+		 *
+		 * udc should have been started before gadget being pulled down.
 		 */
 		gadget->connected = false;
 		goto out;
@@ -774,6 +785,30 @@ int usb_gadget_disconnect(struct usb_gadget *gadget)
 
 	return ret;
 }
+
+/**
+ * usb_gadget_disconnect - software-controlled disconnect from USB host
+ * @gadget:the peripheral being disconnected
+ *
+ * Disables the D+ (or potentially D-) pullup, which the host may see
+ * as a disconnect (when a VBUS session is active).  Not all systems
+ * support software pullup controls.
+ *
+ * Following a successful disconnect, invoke the ->disconnect() callback
+ * for the current gadget driver so that UDC drivers don't need to.
+ *
+ * Returns zero on success, else negative errno.
+ */
+int usb_gadget_disconnect(struct usb_gadget *gadget)
+{
+	int ret;
+
+	mutex_lock(&gadget->udc->connect_lock);
+	ret = usb_gadget_disconnect_locked(gadget);
+	mutex_unlock(&gadget->udc->connect_lock);
+
+	return ret;
+}
 EXPORT_SYMBOL_GPL(usb_gadget_disconnect);
 
 /**
@@ -794,10 +829,11 @@ int usb_gadget_deactivate(struct usb_gadget *gadget)
 	if (gadget->deactivated)
 		goto out;
 
+	mutex_lock(&gadget->udc->connect_lock);
 	if (gadget->connected) {
-		ret = usb_gadget_disconnect(gadget);
+		ret = usb_gadget_disconnect_locked(gadget);
 		if (ret)
-			goto out;
+			goto unlock;
 
 		/*
 		 * If gadget was being connected before deactivation, we want
@@ -807,6 +843,8 @@ int usb_gadget_deactivate(struct usb_gadget *gadget)
 	}
 	gadget->deactivated = true;
 
+unlock:
+	mutex_unlock(&gadget->udc->connect_lock);
 out:
 	trace_usb_gadget_deactivate(gadget, ret);
 
@@ -830,6 +868,7 @@ int usb_gadget_activate(struct usb_gadget *gadget)
 	if (!gadget->deactivated)
 		goto out;
 
+	mutex_lock(&gadget->udc->connect_lock);
 	gadget->deactivated = false;
 
 	/*
@@ -837,7 +876,8 @@ int usb_gadget_activate(struct usb_gadget *gadget)
 	 * while it was being deactivated, we call usb_gadget_connect().
 	 */
 	if (gadget->connected)
-		ret = usb_gadget_connect(gadget);
+		ret = usb_gadget_connect_locked(gadget);
+	mutex_unlock(&gadget->udc->connect_lock);
 
 out:
 	trace_usb_gadget_activate(gadget, ret);
@@ -1078,12 +1118,13 @@ EXPORT_SYMBOL_GPL(usb_gadget_set_state);
 
 /* ------------------------------------------------------------------------- */
 
-static void usb_udc_connect_control(struct usb_udc *udc)
+/* Acquire connect_lock before calling this function. */
+static void usb_udc_connect_control_locked(struct usb_udc *udc) __must_hold(&udc->connect_lock)
 {
-	if (udc->vbus)
-		usb_gadget_connect(udc->gadget);
+	if (udc->vbus && udc->started)
+		usb_gadget_connect_locked(udc->gadget);
 	else
-		usb_gadget_disconnect(udc->gadget);
+		usb_gadget_disconnect_locked(udc->gadget);
 }
 
 /**
@@ -1099,10 +1140,12 @@ void usb_udc_vbus_handler(struct usb_gadget *gadget, bool status)
 {
 	struct usb_udc *udc = gadget->udc;
 
+	mutex_lock(&udc->connect_lock);
 	if (udc) {
 		udc->vbus = status;
-		usb_udc_connect_control(udc);
+		usb_udc_connect_control_locked(udc);
 	}
+	mutex_unlock(&udc->connect_lock);
 }
 EXPORT_SYMBOL_GPL(usb_udc_vbus_handler);
 
@@ -1124,7 +1167,7 @@ void usb_gadget_udc_reset(struct usb_gadget *gadget,
 EXPORT_SYMBOL_GPL(usb_gadget_udc_reset);
 
 /**
- * usb_gadget_udc_start - tells usb device controller to start up
+ * usb_gadget_udc_start_locked - tells usb device controller to start up
  * @udc: The UDC to be started
  *
  * This call is issued by the UDC Class driver when it's about
@@ -1135,8 +1178,11 @@ EXPORT_SYMBOL_GPL(usb_gadget_udc_reset);
  * necessary to have it powered on.
  *
  * Returns zero on success, else negative errno.
+ *
+ * Caller should acquire connect_lock before invoking this function.
  */
-static inline int usb_gadget_udc_start(struct usb_udc *udc)
+static inline int usb_gadget_udc_start_locked(struct usb_udc *udc)
+	__must_hold(&udc->connect_lock)
 {
 	int ret;
 
@@ -1153,7 +1199,7 @@ static inline int usb_gadget_udc_start(struct usb_udc *udc)
 }
 
 /**
- * usb_gadget_udc_stop - tells usb device controller we don't need it anymore
+ * usb_gadget_udc_stop_locked - tells usb device controller we don't need it anymore
  * @udc: The UDC to be stopped
  *
  * This call is issued by the UDC Class driver after calling
@@ -1162,8 +1208,11 @@ static inline int usb_gadget_udc_start(struct usb_udc *udc)
  * The details are implementation specific, but it can go as
  * far as powering off UDC completely and disable its data
  * line pullups.
+ *
+ * Caller should acquire connect lock before invoking this function.
  */
-static inline void usb_gadget_udc_stop(struct usb_udc *udc)
+static inline void usb_gadget_udc_stop_locked(struct usb_udc *udc)
+	__must_hold(&udc->connect_lock)
 {
 	if (!udc->started) {
 		dev_err(&udc->dev, "UDC had already stopped\n");
@@ -1322,6 +1371,7 @@ int usb_add_gadget(struct usb_gadget *gadget)
 
 	udc->gadget = gadget;
 	gadget->udc = udc;
+	mutex_init(&udc->connect_lock);
 
 	udc->started = false;
 
@@ -1523,11 +1573,15 @@ static int gadget_bind_driver(struct device *dev)
 	if (ret)
 		goto err_bind;
 
-	ret = usb_gadget_udc_start(udc);
-	if (ret)
+	mutex_lock(&udc->connect_lock);
+	ret = usb_gadget_udc_start_locked(udc);
+	if (ret) {
+		mutex_unlock(&udc->connect_lock);
 		goto err_start;
+	}
 	usb_gadget_enable_async_callbacks(udc);
-	usb_udc_connect_control(udc);
+	usb_udc_connect_control_locked(udc);
+	mutex_unlock(&udc->connect_lock);
 
 	kobject_uevent(&udc->dev.kobj, KOBJ_CHANGE);
 	return 0;
@@ -1558,12 +1612,14 @@ static void gadget_unbind_driver(struct device *dev)
 
 	kobject_uevent(&udc->dev.kobj, KOBJ_CHANGE);
 
-	usb_gadget_disconnect(gadget);
+	mutex_lock(&udc->connect_lock);
+	usb_gadget_disconnect_locked(gadget);
 	usb_gadget_disable_async_callbacks(udc);
 	if (gadget->irq)
 		synchronize_irq(gadget->irq);
 	udc->driver->unbind(gadget);
-	usb_gadget_udc_stop(udc);
+	usb_gadget_udc_stop_locked(udc);
+	mutex_unlock(&udc->connect_lock);
 
 	mutex_lock(&udc_lock);
 	driver->is_bound = false;
@@ -1649,11 +1705,15 @@ static ssize_t soft_connect_store(struct device *dev,
 	}
 
 	if (sysfs_streq(buf, "connect")) {
-		usb_gadget_udc_start(udc);
-		usb_gadget_connect(udc->gadget);
+		mutex_lock(&udc->connect_lock);
+		usb_gadget_udc_start_locked(udc);
+		usb_gadget_connect_locked(udc->gadget);
+		mutex_unlock(&udc->connect_lock);
 	} else if (sysfs_streq(buf, "disconnect")) {
-		usb_gadget_disconnect(udc->gadget);
-		usb_gadget_udc_stop(udc);
+		mutex_lock(&udc->connect_lock);
+		usb_gadget_disconnect_locked(udc->gadget);
+		usb_gadget_udc_stop_locked(udc);
+		mutex_unlock(&udc->connect_lock);
 	} else {
 		dev_err(dev, "unsupported command '%s'\n", buf);
 		ret = -EINVAL;

base-commit: d629c0e221cd99198b843d8351a0a9bfec6c0423
-- 
2.40.0.577.gac1e443424-goog

