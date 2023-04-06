Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0206D8F55
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 08:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235226AbjDFGZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 02:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbjDFGZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 02:25:55 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F408593F4
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 23:25:52 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x15-20020a25accf000000b00b3b4535c48dso37842101ybd.7
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 23:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680762352;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=u+o6UbbIZ6ErhQB2+SnlMmYYofVv8hcZdeJvJBWxzf0=;
        b=cENzFAwuL2IWFpSnJP42yRihUokeQbA9hrvvg3ysoPIX3t5uX9G+4wCFPlsAec4L3y
         6vNsZ8oVX3ASXzjxlHOcjvCZiti9pEO6ycgZ3JgNai5v7DJPhnZvP2GwQW6ZAUnA+u/4
         Ufbq+vg8z4iGPpU7TgtXDVqV/doAo9ebISpEFpGxD1+gpffRh9TKJvPsdmavdMZzWBeb
         fMk0MU5Jf/f2NCkMHNwnIuMXd6+oC0Mt9sVs+A5vUA6/4hIzTgsKFMAVBDYGwTdBaxdF
         1hdfWMNVGk6NwNbczFc3udQPr+vP/LZrvdLuL1cGFlAP3Ymt32rNONgsURzgjYYI2BUk
         adKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680762352;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u+o6UbbIZ6ErhQB2+SnlMmYYofVv8hcZdeJvJBWxzf0=;
        b=rcD55L+txa4QSXHhZlom3Ol0KMgXsEwPUDfPr1M/l8JuDxeUsfg4R1+QG4cTFlWW9c
         zfJ32s2Hy9VS87jyKISg3BpwOBLuPkc3vgTZunhqKClnsvf8CcXnL6wkQa17ZTE0NI0y
         y+wmWeWnUWir4q1xJWjdiyukr1Esqpih9vBP5WQo86plMwU+9sJZi0XOdAgs2G0kkF0w
         c2uQ49Sy7eQePn2jJSdyfTWougEIbjeMVyzGHK1kBuZOUEwHEp8xddqXx3ZG3UWkrPik
         1Flo0ZhbPbd0LZUmPELBTpPSIcYP8OcSuf3LfujzpAN62Y1gInM8BrkogxdddCxMw7XD
         lRxA==
X-Gm-Message-State: AAQBX9e0UH+nSOAIPZZoyDvKGKs6zgZ5sRuK+v6yqhkzu4yNYiDgChaD
        tySDWXLtoCTHuJYZkgTxjktXklryqMU=
X-Google-Smtp-Source: AKy350bCz5wM3gCn9mo/1E1WNIFlVu9KLPKKbeGHjtsd+fEsIbvcY2Hwl4knRxEHxrlGrfdQHxcA0+h7ZIs=
X-Received: from badhri.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:6442])
 (user=badhri job=sendgmr) by 2002:a81:431f:0:b0:54c:bf7:5210 with SMTP id
 q31-20020a81431f000000b0054c0bf75210mr822600ywa.4.1680762352010; Wed, 05 Apr
 2023 23:25:52 -0700 (PDT)
Date:   Thu,  6 Apr 2023 06:25:48 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230406062549.2461917-1-badhri@google.com>
Subject: [PATCH v2 1/2] usb: gadget: udc: core: Invoke usb_gadget_connect only
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
* Fixed commit message comments.
* Renamed udc_connect_control_lock to connect_lock and made it per
device.
* udc->vbus, udc->started, gadget->connect, gadget->deactivate are all
now guarded by connect_lock.
* Code now checks for udc->started to be set before invoking pullup
callback.
---
 drivers/usb/gadget/udc/core.c | 140 +++++++++++++++++++++++-----------
 1 file changed, 96 insertions(+), 44 deletions(-)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 3dcbba739db6..41d3a1998cff 100644
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
@@ -687,17 +692,8 @@ int usb_gadget_vbus_disconnect(struct usb_gadget *gadget)
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
+/* Internal version of usb_gadget_connect needs to be called with udc_connect_control_lock held. */
+int usb_gadget_connect_locked(struct usb_gadget *gadget)
 {
 	int ret = 0;
 
@@ -706,10 +702,12 @@ int usb_gadget_connect(struct usb_gadget *gadget)
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
@@ -724,22 +722,31 @@ int usb_gadget_connect(struct usb_gadget *gadget)
 
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
+/* Internal version of usb_gadget_disconnect needs to be called with udc->connect_lock held. */
+int usb_gadget_disconnect_locked(struct usb_gadget *gadget)
 {
 	int ret = 0;
 
@@ -751,10 +758,12 @@ int usb_gadget_disconnect(struct usb_gadget *gadget)
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
@@ -774,6 +783,30 @@ int usb_gadget_disconnect(struct usb_gadget *gadget)
 
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
@@ -794,10 +827,11 @@ int usb_gadget_deactivate(struct usb_gadget *gadget)
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
@@ -807,6 +841,8 @@ int usb_gadget_deactivate(struct usb_gadget *gadget)
 	}
 	gadget->deactivated = true;
 
+unlock:
+	mutex_unlock(&gadget->udc->connect_lock);
 out:
 	trace_usb_gadget_deactivate(gadget, ret);
 
@@ -830,6 +866,7 @@ int usb_gadget_activate(struct usb_gadget *gadget)
 	if (!gadget->deactivated)
 		goto out;
 
+	mutex_lock(&gadget->udc->connect_lock);
 	gadget->deactivated = false;
 
 	/*
@@ -837,7 +874,8 @@ int usb_gadget_activate(struct usb_gadget *gadget)
 	 * while it was being deactivated, we call usb_gadget_connect().
 	 */
 	if (gadget->connected)
-		ret = usb_gadget_connect(gadget);
+		ret = usb_gadget_connect_locked(gadget);
+	mutex_unlock(&gadget->udc->connect_lock);
 
 out:
 	trace_usb_gadget_activate(gadget, ret);
@@ -1078,12 +1116,13 @@ EXPORT_SYMBOL_GPL(usb_gadget_set_state);
 
 /* ------------------------------------------------------------------------- */
 
-static void usb_udc_connect_control(struct usb_udc *udc)
+/* Acquire udc_connect_control_lock before calling this function. */
+static void usb_udc_connect_control_locked(struct usb_udc *udc)
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
@@ -1099,10 +1138,12 @@ void usb_udc_vbus_handler(struct usb_gadget *gadget, bool status)
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
 
@@ -1124,7 +1165,7 @@ void usb_gadget_udc_reset(struct usb_gadget *gadget,
 EXPORT_SYMBOL_GPL(usb_gadget_udc_reset);
 
 /**
- * usb_gadget_udc_start - tells usb device controller to start up
+ * usb_gadget_udc_start_locked - tells usb device controller to start up
  * @udc: The UDC to be started
  *
  * This call is issued by the UDC Class driver when it's about
@@ -1136,7 +1177,7 @@ EXPORT_SYMBOL_GPL(usb_gadget_udc_reset);
  *
  * Returns zero on success, else negative errno.
  */
-static inline int usb_gadget_udc_start(struct usb_udc *udc)
+static inline int usb_gadget_udc_start_locked(struct usb_udc *udc)
 {
 	int ret;
 
@@ -1153,7 +1194,7 @@ static inline int usb_gadget_udc_start(struct usb_udc *udc)
 }
 
 /**
- * usb_gadget_udc_stop - tells usb device controller we don't need it anymore
+ * usb_gadget_udc_stop_locked - tells usb device controller we don't need it anymore
  * @udc: The UDC to be stopped
  *
  * This call is issued by the UDC Class driver after calling
@@ -1163,7 +1204,7 @@ static inline int usb_gadget_udc_start(struct usb_udc *udc)
  * far as powering off UDC completely and disable its data
  * line pullups.
  */
-static inline void usb_gadget_udc_stop(struct usb_udc *udc)
+static inline void usb_gadget_udc_stop_locked(struct usb_udc *udc)
 {
 	if (!udc->started) {
 		dev_err(&udc->dev, "UDC had already stopped\n");
@@ -1322,6 +1363,7 @@ int usb_add_gadget(struct usb_gadget *gadget)
 
 	udc->gadget = gadget;
 	gadget->udc = udc;
+	mutex_init(&udc->connect_lock);
 
 	udc->started = false;
 
@@ -1523,11 +1565,15 @@ static int gadget_bind_driver(struct device *dev)
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
@@ -1558,12 +1604,14 @@ static void gadget_unbind_driver(struct device *dev)
 
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
@@ -1649,11 +1697,15 @@ static ssize_t soft_connect_store(struct device *dev,
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
2.40.0.348.gf938b09366-goog

