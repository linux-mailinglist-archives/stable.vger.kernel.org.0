Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B20595059
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbiHPEl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbiHPEkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:40:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0558A4078;
        Mon, 15 Aug 2022 13:31:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79A48B81197;
        Mon, 15 Aug 2022 20:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB29C433D6;
        Mon, 15 Aug 2022 20:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595482;
        bh=wMvYhanpmZYhLOsgVvIO9Nyn2W1vK8FF8/vdctYLWPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSVfjWWL2TrHxQhdGVTJfeFD1t3K6DM7SYtwTLH1oUPrVlCOtAqwaouX7Pf3FAOWP
         HvMoFDTir0yNHtAzkBFKjXnEiy0bWo0AnRWwnR0MxQhVUg74mHDXB/nUUW+UP/6kIf
         USvbjkbdlrwQ5HFR1aZSvS8gIQWHiTEvHxt8HI64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0778/1157] soundwire: revisit driver bind/unbind and callbacks
Date:   Mon, 15 Aug 2022 20:02:14 +0200
Message-Id: <20220815180510.609850272@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit bd29c00edd0a5dac8b6e7332bb470cd50f92e893 ]

In the SoundWire probe, we store a pointer from the driver ops into
the 'slave' structure. This can lead to kernel oopses when unbinding
codec drivers, e.g. with the following sequence to remove machine
driver and codec driver.

/sbin/modprobe -r snd_soc_sof_sdw
/sbin/modprobe -r snd_soc_rt711

The full details can be found in the BugLink below, for reference the
two following examples show different cases of driver ops/callbacks
being invoked after the driver .remove().

kernel: BUG: kernel NULL pointer dereference, address: 0000000000000150
kernel: Workqueue: events cdns_update_slave_status_work [soundwire_cadence]
kernel: RIP: 0010:mutex_lock+0x19/0x30
kernel: Call Trace:
kernel:  ? sdw_handle_slave_status+0x426/0xe00 [soundwire_bus 94ff184bf398570c3f8ff7efe9e32529f532e4ae]
kernel:  ? newidle_balance+0x26a/0x400
kernel:  ? cdns_update_slave_status_work+0x1e9/0x200 [soundwire_cadence 1bcf98eebe5ba9833cd433323769ac923c9c6f82]

kernel: BUG: unable to handle page fault for address: ffffffffc07654c8
kernel: Workqueue: pm pm_runtime_work
kernel: RIP: 0010:sdw_bus_prep_clk_stop+0x6f/0x160 [soundwire_bus]
kernel: Call Trace:
kernel:  <TASK>
kernel:  sdw_cdns_clock_stop+0xb5/0x1b0 [soundwire_cadence 1bcf98eebe5ba9833cd433323769ac923c9c6f82]
kernel:  intel_suspend_runtime+0x5f/0x120 [soundwire_intel aca858f7c87048d3152a4a41bb68abb9b663a1dd]
kernel:  ? dpm_sysfs_remove+0x60/0x60

This was not detected earlier in Intel tests since the tests first
remove the parent PCI device and shut down the bus. The sequence
above is a corner case which keeps the bus operational but without a
driver bound.

While trying to solve this kernel oopses, it became clear that the
existing SoundWire bus does not deal well with the unbind case.

Commit 528be501b7d4a ("soundwire: sdw_slave: add probe_complete structure and new fields")
added a 'probed' status variable and a 'probe_complete'
struct completion. This status is however not reset on remove and
likewise the 'probe complete' is not re-initialized, so the
bind/unbind/bind test cases would fail. The timeout used before the
'update_status' callback was also a bad idea in hindsight, there
should really be no timing assumption as to if and when a driver is
bound to a device.

An initial draft was based on device_lock() and device_unlock() was
tested. This proved too complicated, with deadlocks created during the
suspend-resume sequences, which also use the same device_lock/unlock()
as the bind/unbind sequences. On a CometLake device, a bad DSDT/BIOS
caused spurious resumes and the use of device_lock() caused hangs
during suspend. After multiple weeks or testing and painful
reverse-engineering of deadlocks on different devices, we looked for
alternatives that did not interfere with the device core.

A bus notifier was used successfully to keep track of DRIVER_BOUND and
DRIVER_UNBIND events. This solved the bind-unbind-bind case in tests,
but it can still be defeated with a theoretical corner case where the
memory is freed by a .remove while the callback is in use. The
notifier only helps make sure the driver callbacks are valid, but not
that the memory allocated in probe remains valid while the callbacks
are invoked.

This patch suggests the introduction of a new 'sdw_dev_lock' mutex
protecting probe/remove and all driver callbacks. Since this mutex is
'local' to SoundWire only, it does not interfere with existing locks
and does not create deadlocks. In addition, this patch removes the
'probe_complete' completion, instead we directly invoke the
'update_status' from the probe routine. That removes any sort of
timing dependency and a much better support for the device/driver
model, the driver could be bound before the bus started, or eons after
the bus started and the hardware would be properly initialized in all
cases.

BugLink: https://github.com/thesofproject/linux/issues/3531
Fixes: 56d4fe31af77 ("soundwire: Add MIPI DisCo property helpers")
Fixes: 528be501b7d4a ("soundwire: sdw_slave: add probe_complete structure and new fields")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220621225641.221170-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c       | 75 ++++++++++++++++++++---------------
 drivers/soundwire/bus_type.c  | 30 +++++++++++---
 drivers/soundwire/slave.c     |  3 +-
 drivers/soundwire/stream.c    | 53 ++++++++++++++++---------
 include/linux/soundwire/sdw.h |  6 +--
 5 files changed, 106 insertions(+), 61 deletions(-)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index a2bfb0434a67..8d4000664fa3 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -7,6 +7,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/soundwire/sdw_registers.h>
 #include <linux/soundwire/sdw.h>
+#include <linux/soundwire/sdw_type.h>
 #include "bus.h"
 #include "sysfs_local.h"
 
@@ -842,15 +843,21 @@ static int sdw_slave_clk_stop_callback(struct sdw_slave *slave,
 				       enum sdw_clk_stop_mode mode,
 				       enum sdw_clk_stop_type type)
 {
-	int ret;
+	int ret = 0;
 
-	if (slave->ops && slave->ops->clk_stop) {
-		ret = slave->ops->clk_stop(slave, mode, type);
-		if (ret < 0)
-			return ret;
+	mutex_lock(&slave->sdw_dev_lock);
+
+	if (slave->probed)  {
+		struct device *dev = &slave->dev;
+		struct sdw_driver *drv = drv_to_sdw_driver(dev->driver);
+
+		if (drv->ops && drv->ops->clk_stop)
+			ret = drv->ops->clk_stop(slave, mode, type);
 	}
 
-	return 0;
+	mutex_unlock(&slave->sdw_dev_lock);
+
+	return ret;
 }
 
 static int sdw_slave_clk_stop_prepare(struct sdw_slave *slave,
@@ -1611,14 +1618,24 @@ static int sdw_handle_slave_alerts(struct sdw_slave *slave)
 		}
 
 		/* Update the Slave driver */
-		if (slave_notify && slave->ops &&
-		    slave->ops->interrupt_callback) {
-			slave_intr.sdca_cascade = sdca_cascade;
-			slave_intr.control_port = clear;
-			memcpy(slave_intr.port, &port_status,
-			       sizeof(slave_intr.port));
-
-			slave->ops->interrupt_callback(slave, &slave_intr);
+		if (slave_notify) {
+			mutex_lock(&slave->sdw_dev_lock);
+
+			if (slave->probed) {
+				struct device *dev = &slave->dev;
+				struct sdw_driver *drv = drv_to_sdw_driver(dev->driver);
+
+				if (drv->ops && drv->ops->interrupt_callback) {
+					slave_intr.sdca_cascade = sdca_cascade;
+					slave_intr.control_port = clear;
+					memcpy(slave_intr.port, &port_status,
+					       sizeof(slave_intr.port));
+
+					drv->ops->interrupt_callback(slave, &slave_intr);
+				}
+			}
+
+			mutex_unlock(&slave->sdw_dev_lock);
 		}
 
 		/* Ack interrupt */
@@ -1692,29 +1709,21 @@ static int sdw_handle_slave_alerts(struct sdw_slave *slave)
 static int sdw_update_slave_status(struct sdw_slave *slave,
 				   enum sdw_slave_status status)
 {
-	unsigned long time;
+	int ret = 0;
 
-	if (!slave->probed) {
-		/*
-		 * the slave status update is typically handled in an
-		 * interrupt thread, which can race with the driver
-		 * probe, e.g. when a module needs to be loaded.
-		 *
-		 * make sure the probe is complete before updating
-		 * status.
-		 */
-		time = wait_for_completion_timeout(&slave->probe_complete,
-				msecs_to_jiffies(DEFAULT_PROBE_TIMEOUT));
-		if (!time) {
-			dev_err(&slave->dev, "Probe not complete, timed out\n");
-			return -ETIMEDOUT;
-		}
+	mutex_lock(&slave->sdw_dev_lock);
+
+	if (slave->probed) {
+		struct device *dev = &slave->dev;
+		struct sdw_driver *drv = drv_to_sdw_driver(dev->driver);
+
+		if (drv->ops && drv->ops->update_status)
+			ret = drv->ops->update_status(slave, status);
 	}
 
-	if (!slave->ops || !slave->ops->update_status)
-		return 0;
+	mutex_unlock(&slave->sdw_dev_lock);
 
-	return slave->ops->update_status(slave, status);
+	return ret;
 }
 
 /**
diff --git a/drivers/soundwire/bus_type.c b/drivers/soundwire/bus_type.c
index b81e04dd3a9f..04b3529f8929 100644
--- a/drivers/soundwire/bus_type.c
+++ b/drivers/soundwire/bus_type.c
@@ -98,8 +98,6 @@ static int sdw_drv_probe(struct device *dev)
 	if (!id)
 		return -ENODEV;
 
-	slave->ops = drv->ops;
-
 	/*
 	 * attach to power domain but don't turn on (last arg)
 	 */
@@ -107,19 +105,23 @@ static int sdw_drv_probe(struct device *dev)
 	if (ret)
 		return ret;
 
+	mutex_lock(&slave->sdw_dev_lock);
+
 	ret = drv->probe(slave, id);
 	if (ret) {
 		name = drv->name;
 		if (!name)
 			name = drv->driver.name;
+		mutex_unlock(&slave->sdw_dev_lock);
+
 		dev_err(dev, "Probe of %s failed: %d\n", name, ret);
 		dev_pm_domain_detach(dev, false);
 		return ret;
 	}
 
 	/* device is probed so let's read the properties now */
-	if (slave->ops && slave->ops->read_prop)
-		slave->ops->read_prop(slave);
+	if (drv->ops && drv->ops->read_prop)
+		drv->ops->read_prop(slave);
 
 	/* init the sysfs as we have properties now */
 	ret = sdw_slave_sysfs_init(slave);
@@ -139,7 +141,19 @@ static int sdw_drv_probe(struct device *dev)
 					     slave->prop.clk_stop_timeout);
 
 	slave->probed = true;
-	complete(&slave->probe_complete);
+
+	/*
+	 * if the probe happened after the bus was started, notify the codec driver
+	 * of the current hardware status to e.g. start the initialization.
+	 * Errors are only logged as warnings to avoid failing the probe.
+	 */
+	if (drv->ops && drv->ops->update_status) {
+		ret = drv->ops->update_status(slave, slave->status);
+		if (ret < 0)
+			dev_warn(dev, "%s: update_status failed with status %d\n", __func__, ret);
+	}
+
+	mutex_unlock(&slave->sdw_dev_lock);
 
 	dev_dbg(dev, "probe complete\n");
 
@@ -152,9 +166,15 @@ static int sdw_drv_remove(struct device *dev)
 	struct sdw_driver *drv = drv_to_sdw_driver(dev->driver);
 	int ret = 0;
 
+	mutex_lock(&slave->sdw_dev_lock);
+
+	slave->probed = false;
+
 	if (drv->remove)
 		ret = drv->remove(slave);
 
+	mutex_unlock(&slave->sdw_dev_lock);
+
 	dev_pm_domain_detach(dev, false);
 
 	return ret;
diff --git a/drivers/soundwire/slave.c b/drivers/soundwire/slave.c
index 669d7573320b..25e76b5d4a1a 100644
--- a/drivers/soundwire/slave.c
+++ b/drivers/soundwire/slave.c
@@ -12,6 +12,7 @@ static void sdw_slave_release(struct device *dev)
 {
 	struct sdw_slave *slave = dev_to_sdw_dev(dev);
 
+	mutex_destroy(&slave->sdw_dev_lock);
 	kfree(slave);
 }
 
@@ -58,9 +59,9 @@ int sdw_slave_add(struct sdw_bus *bus,
 	init_completion(&slave->enumeration_complete);
 	init_completion(&slave->initialization_complete);
 	slave->dev_num = 0;
-	init_completion(&slave->probe_complete);
 	slave->probed = false;
 	slave->first_interrupt_done = false;
+	mutex_init(&slave->sdw_dev_lock);
 
 	for (i = 0; i < SDW_MAX_PORTS; i++)
 		init_completion(&slave->port_ready[i]);
diff --git a/drivers/soundwire/stream.c b/drivers/soundwire/stream.c
index d34150559142..bd502368339e 100644
--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/soundwire/sdw_registers.h>
 #include <linux/soundwire/sdw.h>
+#include <linux/soundwire/sdw_type.h>
 #include <sound/soc.h>
 #include "bus.h"
 
@@ -401,20 +402,26 @@ static int sdw_do_port_prep(struct sdw_slave_runtime *s_rt,
 			    struct sdw_prepare_ch prep_ch,
 			    enum sdw_port_prep_ops cmd)
 {
-	const struct sdw_slave_ops *ops = s_rt->slave->ops;
-	int ret;
+	int ret = 0;
+	struct sdw_slave *slave = s_rt->slave;
 
-	if (ops->port_prep) {
-		ret = ops->port_prep(s_rt->slave, &prep_ch, cmd);
-		if (ret < 0) {
-			dev_err(&s_rt->slave->dev,
-				"Slave Port Prep cmd %d failed: %d\n",
-				cmd, ret);
-			return ret;
+	mutex_lock(&slave->sdw_dev_lock);
+
+	if (slave->probed) {
+		struct device *dev = &slave->dev;
+		struct sdw_driver *drv = drv_to_sdw_driver(dev->driver);
+
+		if (drv->ops && drv->ops->port_prep) {
+			ret = drv->ops->port_prep(slave, &prep_ch, cmd);
+			if (ret < 0)
+				dev_err(dev, "Slave Port Prep cmd %d failed: %d\n",
+					cmd, ret);
 		}
 	}
 
-	return 0;
+	mutex_unlock(&slave->sdw_dev_lock);
+
+	return ret;
 }
 
 static int sdw_prep_deprep_slave_ports(struct sdw_bus *bus,
@@ -578,7 +585,7 @@ static int sdw_notify_config(struct sdw_master_runtime *m_rt)
 	struct sdw_slave_runtime *s_rt;
 	struct sdw_bus *bus = m_rt->bus;
 	struct sdw_slave *slave;
-	int ret = 0;
+	int ret;
 
 	if (bus->ops->set_bus_conf) {
 		ret = bus->ops->set_bus_conf(bus, &bus->params);
@@ -589,17 +596,27 @@ static int sdw_notify_config(struct sdw_master_runtime *m_rt)
 	list_for_each_entry(s_rt, &m_rt->slave_rt_list, m_rt_node) {
 		slave = s_rt->slave;
 
-		if (slave->ops->bus_config) {
-			ret = slave->ops->bus_config(slave, &bus->params);
-			if (ret < 0) {
-				dev_err(bus->dev, "Notify Slave: %d failed\n",
-					slave->dev_num);
-				return ret;
+		mutex_lock(&slave->sdw_dev_lock);
+
+		if (slave->probed) {
+			struct device *dev = &slave->dev;
+			struct sdw_driver *drv = drv_to_sdw_driver(dev->driver);
+
+			if (drv->ops && drv->ops->bus_config) {
+				ret = drv->ops->bus_config(slave, &bus->params);
+				if (ret < 0) {
+					dev_err(dev, "Notify Slave: %d failed\n",
+						slave->dev_num);
+					mutex_unlock(&slave->sdw_dev_lock);
+					return ret;
+				}
 			}
 		}
+
+		mutex_unlock(&slave->sdw_dev_lock);
 	}
 
-	return ret;
+	return 0;
 }
 
 /**
diff --git a/include/linux/soundwire/sdw.h b/include/linux/soundwire/sdw.h
index 76ce3f3ac0f2..bf6f0decb3f6 100644
--- a/include/linux/soundwire/sdw.h
+++ b/include/linux/soundwire/sdw.h
@@ -646,9 +646,6 @@ struct sdw_slave_ops {
  * @dev_num: Current Device Number, values can be 0 or dev_num_sticky
  * @dev_num_sticky: one-time static Device Number assigned by Bus
  * @probed: boolean tracking driver state
- * @probe_complete: completion utility to control potential races
- * on startup between driver probe/initialization and SoundWire
- * Slave state changes/implementation-defined interrupts
  * @enumeration_complete: completion utility to control potential races
  * on startup between device enumeration and read/write access to the
  * Slave device
@@ -663,6 +660,7 @@ struct sdw_slave_ops {
  * for a Slave happens for the first time after enumeration
  * @is_mockup_device: status flag used to squelch errors in the command/control
  * protocol for SoundWire mockup devices
+ * @sdw_dev_lock: mutex used to protect callbacks/remove races
  */
 struct sdw_slave {
 	struct sdw_slave_id id;
@@ -680,12 +678,12 @@ struct sdw_slave {
 	u16 dev_num;
 	u16 dev_num_sticky;
 	bool probed;
-	struct completion probe_complete;
 	struct completion enumeration_complete;
 	struct completion initialization_complete;
 	u32 unattach_request;
 	bool first_interrupt_done;
 	bool is_mockup_device;
+	struct mutex sdw_dev_lock; /* protect callbacks/remove races */
 };
 
 #define dev_to_sdw_dev(_dev) container_of(_dev, struct sdw_slave, dev)
-- 
2.35.1



