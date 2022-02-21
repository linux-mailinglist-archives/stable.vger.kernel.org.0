Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0434BDE1A
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347048AbiBUJDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:03:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347639AbiBUJBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:01:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2B424F15;
        Mon, 21 Feb 2022 00:56:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6827B60FB6;
        Mon, 21 Feb 2022 08:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A95C340E9;
        Mon, 21 Feb 2022 08:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433805;
        bh=4bCALXzMb4x6My4RnPf0joY/XMA1aoBXPL+MZSmCTgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0awx9HvIEDSNsndI9N28el94luz8yInxVShVeHhmAa5eiRvAKY7/Ct0dbxsX39Qg
         6wcRgoNnEHKWV3TjCqKjDHtfAy11scHedHTStDzjCQjy27sWKMhc/rhYntD4RnP8sQ
         7VeHbTLINJcGz2ffJ9mymuJMGOjWuuv1Axo7l9q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kimberly Brown <kimbrownkd@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/58] Drivers: hv: vmbus: Expose monitor data only when monitor pages are used
Date:   Mon, 21 Feb 2022 09:49:40 +0100
Message-Id: <20220221084913.394725946@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kimberly Brown <kimbrownkd@gmail.com>

[ Upstream commit 46fc15487d02451448c11b83c4d086d87a6ad588 ]

There are two methods for signaling the host: the monitor page mechanism
and hypercalls. The monitor page mechanism is used by performance
critical channels (storage, networking, etc.) because it provides
improved throughput. However, latency is increased. Monitor pages are
allocated to these channels.

Monitor pages are not allocated to channels that do not use the monitor
page mechanism. Therefore, these channels do not have a valid monitor id
or valid monitor page data. In these cases, some of the "_show"
functions return incorrect data. They return an invalid monitor id and
data that is beyond the bounds of the hv_monitor_page array fields.

The "channel->offermsg.monitor_allocated" value can be used to determine
whether monitor pages have been allocated to a channel.

Add "is_visible()" callback functions for the device-level and
channel-level attribute groups. These functions will hide the monitor
sysfs files when the monitor mechanism is not used.

Remove ".default_attributes" from "vmbus_chan_attrs" and create a
channel-level attribute group. These changes allow the new
"is_visible()" callback function to be applied to the channel-level
attributes.

Call "sysfs_create_group()" in "vmbus_add_channel_kobj()" to create the
channel's sysfs files. Add a new function,
“vmbus_remove_channel_attr_group()”, and call it in "free_channel()" to
remove the channel's sysfs files when the channel is closed.

Signed-off-by: Kimberly Brown <kimbrownkd@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/stable/sysfs-bus-vmbus | 12 +++-
 drivers/hv/channel_mgmt.c                |  1 +
 drivers/hv/hyperv_vmbus.h                |  2 +
 drivers/hv/vmbus_drv.c                   | 77 +++++++++++++++++++++++-
 4 files changed, 87 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-bus-vmbus b/Documentation/ABI/stable/sysfs-bus-vmbus
index 3fed8fdb873d7..c4ffdfc324b41 100644
--- a/Documentation/ABI/stable/sysfs-bus-vmbus
+++ b/Documentation/ABI/stable/sysfs-bus-vmbus
@@ -81,7 +81,9 @@ What:		/sys/bus/vmbus/devices/<UUID>/channels/<N>/latency
 Date:		September. 2017
 KernelVersion:	4.14
 Contact:	Stephen Hemminger <sthemmin@microsoft.com>
-Description:	Channel signaling latency
+Description:	Channel signaling latency. This file is available only for
+		performance critical channels (storage, network, etc.) that use
+		the monitor page mechanism.
 Users:		Debugging tools
 
 What:		/sys/bus/vmbus/devices/<UUID>/channels/<N>/out_mask
@@ -95,7 +97,9 @@ What:		/sys/bus/vmbus/devices/<UUID>/channels/<N>/pending
 Date:		September. 2017
 KernelVersion:	4.14
 Contact:	Stephen Hemminger <sthemmin@microsoft.com>
-Description:	Channel interrupt pending state
+Description:	Channel interrupt pending state. This file is available only for
+		performance critical channels (storage, network, etc.) that use
+		the monitor page mechanism.
 Users:		Debugging tools
 
 What:		/sys/bus/vmbus/devices/<UUID>/channels/<N>/read_avail
@@ -137,7 +141,9 @@ What:		/sys/bus/vmbus/devices/<UUID>/channels/<N>/monitor_id
 Date:		January. 2018
 KernelVersion:	4.16
 Contact:	Stephen Hemminger <sthemmin@microsoft.com>
-Description:	Monitor bit associated with channel
+Description:	Monitor bit associated with channel. This file is available only
+		for performance critical channels (storage, network, etc.) that
+		use the monitor page mechanism.
 Users:		Debugging tools and userspace drivers
 
 What:		/sys/bus/vmbus/devices/<UUID>/channels/<N>/ring
diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index cdd4392c589d3..a3f6933f94e30 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -350,6 +350,7 @@ static struct vmbus_channel *alloc_channel(void)
 static void free_channel(struct vmbus_channel *channel)
 {
 	tasklet_kill(&channel->callback_event);
+	vmbus_remove_channel_attr_group(channel);
 
 	kobject_put(&channel->kobj);
 }
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 7e7c8debbd285..c4ad518890243 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -392,6 +392,8 @@ void vmbus_device_unregister(struct hv_device *device_obj);
 int vmbus_add_channel_kobj(struct hv_device *device_obj,
 			   struct vmbus_channel *channel);
 
+void vmbus_remove_channel_attr_group(struct vmbus_channel *channel);
+
 struct vmbus_channel *relid2channel(u32 relid);
 
 void vmbus_free_channels(void);
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 0699c60188895..aab21c1534a10 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -609,7 +609,36 @@ static struct attribute *vmbus_dev_attrs[] = {
 	&dev_attr_device.attr,
 	NULL,
 };
-ATTRIBUTE_GROUPS(vmbus_dev);
+
+/*
+ * Device-level attribute_group callback function. Returns the permission for
+ * each attribute, and returns 0 if an attribute is not visible.
+ */
+static umode_t vmbus_dev_attr_is_visible(struct kobject *kobj,
+					 struct attribute *attr, int idx)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	const struct hv_device *hv_dev = device_to_hv_device(dev);
+
+	/* Hide the monitor attributes if the monitor mechanism is not used. */
+	if (!hv_dev->channel->offermsg.monitor_allocated &&
+	    (attr == &dev_attr_monitor_id.attr ||
+	     attr == &dev_attr_server_monitor_pending.attr ||
+	     attr == &dev_attr_client_monitor_pending.attr ||
+	     attr == &dev_attr_server_monitor_latency.attr ||
+	     attr == &dev_attr_client_monitor_latency.attr ||
+	     attr == &dev_attr_server_monitor_conn_id.attr ||
+	     attr == &dev_attr_client_monitor_conn_id.attr))
+		return 0;
+
+	return attr->mode;
+}
+
+static const struct attribute_group vmbus_dev_group = {
+	.attrs = vmbus_dev_attrs,
+	.is_visible = vmbus_dev_attr_is_visible
+};
+__ATTRIBUTE_GROUPS(vmbus_dev);
 
 /*
  * vmbus_uevent - add uevent for our device
@@ -1484,10 +1513,34 @@ static struct attribute *vmbus_chan_attrs[] = {
 	NULL
 };
 
+/*
+ * Channel-level attribute_group callback function. Returns the permission for
+ * each attribute, and returns 0 if an attribute is not visible.
+ */
+static umode_t vmbus_chan_attr_is_visible(struct kobject *kobj,
+					  struct attribute *attr, int idx)
+{
+	const struct vmbus_channel *channel =
+		container_of(kobj, struct vmbus_channel, kobj);
+
+	/* Hide the monitor attributes if the monitor mechanism is not used. */
+	if (!channel->offermsg.monitor_allocated &&
+	    (attr == &chan_attr_pending.attr ||
+	     attr == &chan_attr_latency.attr ||
+	     attr == &chan_attr_monitor_id.attr))
+		return 0;
+
+	return attr->mode;
+}
+
+static struct attribute_group vmbus_chan_group = {
+	.attrs = vmbus_chan_attrs,
+	.is_visible = vmbus_chan_attr_is_visible
+};
+
 static struct kobj_type vmbus_chan_ktype = {
 	.sysfs_ops = &vmbus_chan_sysfs_ops,
 	.release = vmbus_chan_release,
-	.default_attrs = vmbus_chan_attrs,
 };
 
 /*
@@ -1495,6 +1548,7 @@ static struct kobj_type vmbus_chan_ktype = {
  */
 int vmbus_add_channel_kobj(struct hv_device *dev, struct vmbus_channel *channel)
 {
+	const struct device *device = &dev->device;
 	struct kobject *kobj = &channel->kobj;
 	u32 relid = channel->offermsg.child_relid;
 	int ret;
@@ -1505,11 +1559,30 @@ int vmbus_add_channel_kobj(struct hv_device *dev, struct vmbus_channel *channel)
 	if (ret)
 		return ret;
 
+	ret = sysfs_create_group(kobj, &vmbus_chan_group);
+
+	if (ret) {
+		/*
+		 * The calling functions' error handling paths will cleanup the
+		 * empty channel directory.
+		 */
+		dev_err(device, "Unable to set up channel sysfs files\n");
+		return ret;
+	}
+
 	kobject_uevent(kobj, KOBJ_ADD);
 
 	return 0;
 }
 
+/*
+ * vmbus_remove_channel_attr_group - remove the channel's attribute group
+ */
+void vmbus_remove_channel_attr_group(struct vmbus_channel *channel)
+{
+	sysfs_remove_group(&channel->kobj, &vmbus_chan_group);
+}
+
 /*
  * vmbus_device_create - Creates and registers a new child device
  * on the vmbus.
-- 
2.34.1



