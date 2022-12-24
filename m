Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6179765573E
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236623AbiLXBd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:33:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236626AbiLXBc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:32:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131B4B870;
        Fri, 23 Dec 2022 17:30:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBE1261FAD;
        Sat, 24 Dec 2022 01:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57441C433EF;
        Sat, 24 Dec 2022 01:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845452;
        bh=Ur0Axn7Nd7A0DBrX+5qd4SeAYEYwdYo/EbiPefPXJXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VX3Izahfs0qFHBhzrJX3r3IDXjFN7UVK4QsAb2k/aOjuPSvGYtbUqMU6K6WEQUldX
         4RL6jbvI6F7tsyqVDeYc+ZbDcGkvsL5HeY4vCmYaf2rRsi7KIm6BEcOIMoTKm9ERDi
         QG0Ei4QQ+K4lpNDhd8awoRbdFaCeGgAEB1Z5Xo0YqrypSvlytV0wULp1/JGN5hbiLS
         Who4FwL9HIExHkAt9xaWjJpd13VbloST/GcC+8oeH0ks41yICSE+uhB0XoDkx9GjR+
         dECO0lGzLk8s+NFE9CPvPNRwRzR2CKsC+5GIYjggtZOEgBmB1lm9pvJ3tbOGkLCemf
         Sed6qs1+x8FWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ray Chi <raychi@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        heikki.krogerus@linux.intel.com, rafael.j.wysocki@intel.com,
        andriy.shevchenko@linux.intel.com, m.grzeschik@pengutronix.de,
        mathias.nyman@linux.intel.com, dianders@chromium.org,
        mailhol.vincent@wanadoo.fr, mka@chromium.org,
        Bhuvanesh_Surachari@mentor.com, fmdefrancesco@gmail.com,
        christophe.jaillet@wanadoo.fr, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 03/18] usb: core: stop USB enumeration if too many retries
Date:   Fri, 23 Dec 2022 20:30:19 -0500
Message-Id: <20221224013034.392810-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224013034.392810-1-sashal@kernel.org>
References: <20221224013034.392810-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ray Chi <raychi@google.com>

[ Upstream commit 430d57f53eb1cdbf9ba9bbd397317912b3cd2de5 ]

When a broken USB accessory connects to a USB host, usbcore might
keep doing enumeration retries. If the host has a watchdog mechanism,
the kernel panic will happen on the host.

This patch provides an attribute early_stop to limit the numbers of retries
for each port of a hub. If a port was marked with early_stop attribute,
unsuccessful connection attempts will fail quickly. In addition, if an
early_stop port has failed to initialize, it will ignore all future
connection events until early_stop attribute is clear.

Signed-off-by: Ray Chi <raychi@google.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20221107072754.3336357-1-raychi@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-bus-usb | 11 +++++
 drivers/usb/core/hub.c                  | 60 +++++++++++++++++++++++++
 drivers/usb/core/hub.h                  |  4 ++
 drivers/usb/core/port.c                 | 27 +++++++++++
 4 files changed, 102 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-usb b/Documentation/ABI/testing/sysfs-bus-usb
index 568103d3376e..545c2dd97ed0 100644
--- a/Documentation/ABI/testing/sysfs-bus-usb
+++ b/Documentation/ABI/testing/sysfs-bus-usb
@@ -264,6 +264,17 @@ Description:
 		attached to the port will not be detected, initialized,
 		or enumerated.
 
+What:		/sys/bus/usb/devices/.../<hub_interface>/port<X>/early_stop
+Date:		Sep 2022
+Contact:	Ray Chi <raychi@google.com>
+Description:
+		Some USB hosts have some watchdog mechanisms so that the device
+		may enter ramdump if it takes a long time during port initialization.
+		This attribute allows each port just has two attempts so that the
+		port initialization will be failed quickly. In addition, if a port
+		which is marked with early_stop has failed to initialize, it will ignore
+		all future connections until this attribute is clear.
+
 What:		/sys/bus/usb/devices/.../power/usb2_lpm_l1_timeout
 Date:		May 2013
 Contact:	Mathias Nyman <mathias.nyman@linux.intel.com>
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index bbab424b0d55..77e73fc8d673 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3081,6 +3081,48 @@ static int hub_port_reset(struct usb_hub *hub, int port1,
 	return status;
 }
 
+/*
+ * hub_port_stop_enumerate - stop USB enumeration or ignore port events
+ * @hub: target hub
+ * @port1: port num of the port
+ * @retries: port retries number of hub_port_init()
+ *
+ * Return:
+ *    true: ignore port actions/events or give up connection attempts.
+ *    false: keep original behavior.
+ *
+ * This function will be based on retries to check whether the port which is
+ * marked with early_stop attribute would stop enumeration or ignore events.
+ *
+ * Note:
+ * This function didn't change anything if early_stop is not set, and it will
+ * prevent all connection attempts when early_stop is set and the attempts of
+ * the port are more than 1.
+ */
+static bool hub_port_stop_enumerate(struct usb_hub *hub, int port1, int retries)
+{
+	struct usb_port *port_dev = hub->ports[port1 - 1];
+
+	if (port_dev->early_stop) {
+		if (port_dev->ignore_event)
+			return true;
+
+		/*
+		 * We want unsuccessful attempts to fail quickly.
+		 * Since some devices may need one failure during
+		 * port initialization, we allow two tries but no
+		 * more.
+		 */
+		if (retries < 2)
+			return false;
+
+		port_dev->ignore_event = 1;
+	} else
+		port_dev->ignore_event = 0;
+
+	return port_dev->ignore_event;
+}
+
 /* Check if a port is power on */
 int usb_port_is_power_on(struct usb_hub *hub, unsigned int portstatus)
 {
@@ -4796,6 +4838,11 @@ hub_port_init(struct usb_hub *hub, struct usb_device *udev, int port1,
 	do_new_scheme = use_new_scheme(udev, retry_counter, port_dev);
 
 	for (retries = 0; retries < GET_DESCRIPTOR_TRIES; (++retries, msleep(100))) {
+		if (hub_port_stop_enumerate(hub, port1, retries)) {
+			retval = -ENODEV;
+			break;
+		}
+
 		if (do_new_scheme) {
 			struct usb_device_descriptor *buf;
 			int r = 0;
@@ -5246,6 +5293,11 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
 	status = 0;
 
 	for (i = 0; i < PORT_INIT_TRIES; i++) {
+		if (hub_port_stop_enumerate(hub, port1, i)) {
+			status = -ENODEV;
+			break;
+		}
+
 		usb_lock_port(port_dev);
 		mutex_lock(hcd->address0_mutex);
 		retry_locked = true;
@@ -5614,6 +5666,10 @@ static void port_event(struct usb_hub *hub, int port1)
 	if (!pm_runtime_active(&port_dev->dev))
 		return;
 
+	/* skip port actions if ignore_event and early_stop are true */
+	if (port_dev->ignore_event && port_dev->early_stop)
+		return;
+
 	if (hub_handle_remote_wakeup(hub, port1, portstatus, portchange))
 		connect_change = 1;
 
@@ -5927,6 +5983,10 @@ static int usb_reset_and_verify_device(struct usb_device *udev)
 	mutex_lock(hcd->address0_mutex);
 
 	for (i = 0; i < PORT_INIT_TRIES; ++i) {
+		if (hub_port_stop_enumerate(parent_hub, port1, i)) {
+			ret = -ENODEV;
+			break;
+		}
 
 		/* ep0 maxpacket size may change; let the HCD know about it.
 		 * Other endpoints will be handled by re-enumeration. */
diff --git a/drivers/usb/core/hub.h b/drivers/usb/core/hub.h
index b2925856b4cb..e23833562e4f 100644
--- a/drivers/usb/core/hub.h
+++ b/drivers/usb/core/hub.h
@@ -90,6 +90,8 @@ struct usb_hub {
  * @is_superspeed cache super-speed status
  * @usb3_lpm_u1_permit: whether USB3 U1 LPM is permitted.
  * @usb3_lpm_u2_permit: whether USB3 U2 LPM is permitted.
+ * @early_stop: whether port initialization will be stopped earlier.
+ * @ignore_event: whether events of the port are ignored.
  */
 struct usb_port {
 	struct usb_device *child;
@@ -103,6 +105,8 @@ struct usb_port {
 	u32 over_current_count;
 	u8 portnum;
 	u32 quirks;
+	unsigned int early_stop:1;
+	unsigned int ignore_event:1;
 	unsigned int is_superspeed:1;
 	unsigned int usb3_lpm_u1_permit:1;
 	unsigned int usb3_lpm_u2_permit:1;
diff --git a/drivers/usb/core/port.c b/drivers/usb/core/port.c
index 38c1a4f4fdea..126da9408359 100644
--- a/drivers/usb/core/port.c
+++ b/drivers/usb/core/port.c
@@ -17,6 +17,32 @@ static int usb_port_block_power_off;
 
 static const struct attribute_group *port_dev_group[];
 
+static ssize_t early_stop_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct usb_port *port_dev = to_usb_port(dev);
+
+	return sysfs_emit(buf, "%s\n", port_dev->early_stop ? "yes" : "no");
+}
+
+static ssize_t early_stop_store(struct device *dev, struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct usb_port *port_dev = to_usb_port(dev);
+	bool value;
+
+	if (kstrtobool(buf, &value))
+		return -EINVAL;
+
+	if (value)
+		port_dev->early_stop = 1;
+	else
+		port_dev->early_stop = 0;
+
+	return count;
+}
+static DEVICE_ATTR_RW(early_stop);
+
 static ssize_t disable_show(struct device *dev,
 			      struct device_attribute *attr, char *buf)
 {
@@ -236,6 +262,7 @@ static struct attribute *port_dev_attrs[] = {
 	&dev_attr_quirks.attr,
 	&dev_attr_over_current_count.attr,
 	&dev_attr_disable.attr,
+	&dev_attr_early_stop.attr,
 	NULL,
 };
 
-- 
2.35.1

