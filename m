Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38203C4562
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhGLGZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235146AbhGLGYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B11A61159;
        Mon, 12 Jul 2021 06:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070875;
        bh=6NpNqYM0A0jmAs0TOR6yjFfWo4hDb22If3lczqFtfKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VW9nJ85ksbg83uK6u9jvzCllW0IOs/B5+6O1uZkBXsSeu12PWJoN28+c4TML/dRts
         FQxQ8ksDXPYkgngMoVDn1IgcMyQ26k3bUUApaUi2godm+ecmAkT8VDL5sCO3wh+InO
         6ckw5ncLW4VUKwUXOhdbe+nbG9KwRWhDhBKx9JTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dwaipayan Ray <dwaipayanray1@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 179/348] ACPI: Use DEVICE_ATTR_<RW|RO|WO> macros
Date:   Mon, 12 Jul 2021 08:09:23 +0200
Message-Id: <20210712060724.643646738@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dwaipayan Ray <dwaipayanray1@gmail.com>

[ Upstream commit 0f39ee8324e75c9d370e84a61323ceb194641a18 ]

Instead of open coding DEVICE_ATTR(), use the
DEVICE_ATTR_RW(), DEVICE_ATTR_RO() and DEVICE_ATTR_WO()
macros wherever possible.

This required a few functions to be renamed but the
functionality itself is unchanged.

Signed-off-by: Dwaipayan Ray <dwaipayanray1@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_pad.c     | 24 ++++++++------------
 drivers/acpi/acpi_tad.c     | 14 ++++++------
 drivers/acpi/bgrt.c         | 20 ++++++++---------
 drivers/acpi/device_sysfs.c | 44 ++++++++++++++++++-------------------
 drivers/acpi/dock.c         | 26 +++++++++++-----------
 drivers/acpi/power.c        |  9 ++++----
 6 files changed, 66 insertions(+), 71 deletions(-)

diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index e7dc0133f817..c11d736a8db7 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -262,7 +262,7 @@ static uint32_t acpi_pad_idle_cpus_num(void)
 	return ps_tsk_num;
 }
 
-static ssize_t acpi_pad_rrtime_store(struct device *dev,
+static ssize_t rrtime_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
 	unsigned long num;
@@ -276,16 +276,14 @@ static ssize_t acpi_pad_rrtime_store(struct device *dev,
 	return count;
 }
 
-static ssize_t acpi_pad_rrtime_show(struct device *dev,
+static ssize_t rrtime_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
 	return scnprintf(buf, PAGE_SIZE, "%d\n", round_robin_time);
 }
-static DEVICE_ATTR(rrtime, S_IRUGO|S_IWUSR,
-	acpi_pad_rrtime_show,
-	acpi_pad_rrtime_store);
+static DEVICE_ATTR_RW(rrtime);
 
-static ssize_t acpi_pad_idlepct_store(struct device *dev,
+static ssize_t idlepct_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
 	unsigned long num;
@@ -299,16 +297,14 @@ static ssize_t acpi_pad_idlepct_store(struct device *dev,
 	return count;
 }
 
-static ssize_t acpi_pad_idlepct_show(struct device *dev,
+static ssize_t idlepct_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
 	return scnprintf(buf, PAGE_SIZE, "%d\n", idle_pct);
 }
-static DEVICE_ATTR(idlepct, S_IRUGO|S_IWUSR,
-	acpi_pad_idlepct_show,
-	acpi_pad_idlepct_store);
+static DEVICE_ATTR_RW(idlepct);
 
-static ssize_t acpi_pad_idlecpus_store(struct device *dev,
+static ssize_t idlecpus_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
 	unsigned long num;
@@ -320,16 +316,14 @@ static ssize_t acpi_pad_idlecpus_store(struct device *dev,
 	return count;
 }
 
-static ssize_t acpi_pad_idlecpus_show(struct device *dev,
+static ssize_t idlecpus_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
 	return cpumap_print_to_pagebuf(false, buf,
 				       to_cpumask(pad_busy_cpus_bits));
 }
 
-static DEVICE_ATTR(idlecpus, S_IRUGO|S_IWUSR,
-	acpi_pad_idlecpus_show,
-	acpi_pad_idlecpus_store);
+static DEVICE_ATTR_RW(idlecpus);
 
 static int acpi_pad_add_sysfs(struct acpi_device *device)
 {
diff --git a/drivers/acpi/acpi_tad.c b/drivers/acpi/acpi_tad.c
index 33a4bcdaa4d7..bab8583443a6 100644
--- a/drivers/acpi/acpi_tad.c
+++ b/drivers/acpi/acpi_tad.c
@@ -237,7 +237,7 @@ static ssize_t time_show(struct device *dev, struct device_attribute *attr,
 		       rt.tz, rt.daylight);
 }
 
-static DEVICE_ATTR(time, S_IRUSR | S_IWUSR, time_show, time_store);
+static DEVICE_ATTR_RW(time);
 
 static struct attribute *acpi_tad_time_attrs[] = {
 	&dev_attr_time.attr,
@@ -446,7 +446,7 @@ static ssize_t ac_alarm_show(struct device *dev, struct device_attribute *attr,
 	return acpi_tad_alarm_read(dev, buf, ACPI_TAD_AC_TIMER);
 }
 
-static DEVICE_ATTR(ac_alarm, S_IRUSR | S_IWUSR, ac_alarm_show, ac_alarm_store);
+static DEVICE_ATTR_RW(ac_alarm);
 
 static ssize_t ac_policy_store(struct device *dev, struct device_attribute *attr,
 			       const char *buf, size_t count)
@@ -462,7 +462,7 @@ static ssize_t ac_policy_show(struct device *dev, struct device_attribute *attr,
 	return acpi_tad_policy_read(dev, buf, ACPI_TAD_AC_TIMER);
 }
 
-static DEVICE_ATTR(ac_policy, S_IRUSR | S_IWUSR, ac_policy_show, ac_policy_store);
+static DEVICE_ATTR_RW(ac_policy);
 
 static ssize_t ac_status_store(struct device *dev, struct device_attribute *attr,
 			       const char *buf, size_t count)
@@ -478,7 +478,7 @@ static ssize_t ac_status_show(struct device *dev, struct device_attribute *attr,
 	return acpi_tad_status_read(dev, buf, ACPI_TAD_AC_TIMER);
 }
 
-static DEVICE_ATTR(ac_status, S_IRUSR | S_IWUSR, ac_status_show, ac_status_store);
+static DEVICE_ATTR_RW(ac_status);
 
 static struct attribute *acpi_tad_attrs[] = {
 	&dev_attr_caps.attr,
@@ -505,7 +505,7 @@ static ssize_t dc_alarm_show(struct device *dev, struct device_attribute *attr,
 	return acpi_tad_alarm_read(dev, buf, ACPI_TAD_DC_TIMER);
 }
 
-static DEVICE_ATTR(dc_alarm, S_IRUSR | S_IWUSR, dc_alarm_show, dc_alarm_store);
+static DEVICE_ATTR_RW(dc_alarm);
 
 static ssize_t dc_policy_store(struct device *dev, struct device_attribute *attr,
 			       const char *buf, size_t count)
@@ -521,7 +521,7 @@ static ssize_t dc_policy_show(struct device *dev, struct device_attribute *attr,
 	return acpi_tad_policy_read(dev, buf, ACPI_TAD_DC_TIMER);
 }
 
-static DEVICE_ATTR(dc_policy, S_IRUSR | S_IWUSR, dc_policy_show, dc_policy_store);
+static DEVICE_ATTR_RW(dc_policy);
 
 static ssize_t dc_status_store(struct device *dev, struct device_attribute *attr,
 			       const char *buf, size_t count)
@@ -537,7 +537,7 @@ static ssize_t dc_status_show(struct device *dev, struct device_attribute *attr,
 	return acpi_tad_status_read(dev, buf, ACPI_TAD_DC_TIMER);
 }
 
-static DEVICE_ATTR(dc_status, S_IRUSR | S_IWUSR, dc_status_show, dc_status_store);
+static DEVICE_ATTR_RW(dc_status);
 
 static struct attribute *acpi_tad_dc_attrs[] = {
 	&dev_attr_dc_alarm.attr,
diff --git a/drivers/acpi/bgrt.c b/drivers/acpi/bgrt.c
index 251f961c28cc..19bb7f870204 100644
--- a/drivers/acpi/bgrt.c
+++ b/drivers/acpi/bgrt.c
@@ -15,40 +15,40 @@
 static void *bgrt_image;
 static struct kobject *bgrt_kobj;
 
-static ssize_t show_version(struct device *dev,
+static ssize_t version_show(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.version);
 }
-static DEVICE_ATTR(version, S_IRUGO, show_version, NULL);
+static DEVICE_ATTR_RO(version);
 
-static ssize_t show_status(struct device *dev,
+static ssize_t status_show(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.status);
 }
-static DEVICE_ATTR(status, S_IRUGO, show_status, NULL);
+static DEVICE_ATTR_RO(status);
 
-static ssize_t show_type(struct device *dev,
+static ssize_t type_show(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.image_type);
 }
-static DEVICE_ATTR(type, S_IRUGO, show_type, NULL);
+static DEVICE_ATTR_RO(type);
 
-static ssize_t show_xoffset(struct device *dev,
+static ssize_t xoffset_show(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.image_offset_x);
 }
-static DEVICE_ATTR(xoffset, S_IRUGO, show_xoffset, NULL);
+static DEVICE_ATTR_RO(xoffset);
 
-static ssize_t show_yoffset(struct device *dev,
+static ssize_t yoffset_show(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.image_offset_y);
 }
-static DEVICE_ATTR(yoffset, S_IRUGO, show_yoffset, NULL);
+static DEVICE_ATTR_RO(yoffset);
 
 static ssize_t image_read(struct file *file, struct kobject *kobj,
 	       struct bin_attribute *attr, char *buf, loff_t off, size_t count)
diff --git a/drivers/acpi/device_sysfs.c b/drivers/acpi/device_sysfs.c
index 75e412b2b660..fe8c7e79f472 100644
--- a/drivers/acpi/device_sysfs.c
+++ b/drivers/acpi/device_sysfs.c
@@ -325,11 +325,11 @@ int acpi_device_modalias(struct device *dev, char *buf, int size)
 EXPORT_SYMBOL_GPL(acpi_device_modalias);
 
 static ssize_t
-acpi_device_modalias_show(struct device *dev, struct device_attribute *attr, char *buf)
+modalias_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	return __acpi_device_modalias(to_acpi_device(dev), buf, 1024);
 }
-static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
+static DEVICE_ATTR_RO(modalias);
 
 static ssize_t real_power_state_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
@@ -358,8 +358,8 @@ static ssize_t power_state_show(struct device *dev,
 static DEVICE_ATTR_RO(power_state);
 
 static ssize_t
-acpi_eject_store(struct device *d, struct device_attribute *attr,
-		const char *buf, size_t count)
+eject_store(struct device *d, struct device_attribute *attr,
+	    const char *buf, size_t count)
 {
 	struct acpi_device *acpi_device = to_acpi_device(d);
 	acpi_object_type not_used;
@@ -387,28 +387,28 @@ acpi_eject_store(struct device *d, struct device_attribute *attr,
 	return status == AE_NO_MEMORY ? -ENOMEM : -EAGAIN;
 }
 
-static DEVICE_ATTR(eject, 0200, NULL, acpi_eject_store);
+static DEVICE_ATTR_WO(eject);
 
 static ssize_t
-acpi_device_hid_show(struct device *dev, struct device_attribute *attr, char *buf)
+hid_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 
 	return sprintf(buf, "%s\n", acpi_device_hid(acpi_dev));
 }
-static DEVICE_ATTR(hid, 0444, acpi_device_hid_show, NULL);
+static DEVICE_ATTR_RO(hid);
 
-static ssize_t acpi_device_uid_show(struct device *dev,
-				    struct device_attribute *attr, char *buf)
+static ssize_t uid_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
 {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 
 	return sprintf(buf, "%s\n", acpi_dev->pnp.unique_id);
 }
-static DEVICE_ATTR(uid, 0444, acpi_device_uid_show, NULL);
+static DEVICE_ATTR_RO(uid);
 
-static ssize_t acpi_device_adr_show(struct device *dev,
-				    struct device_attribute *attr, char *buf)
+static ssize_t adr_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
 {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 
@@ -417,16 +417,16 @@ static ssize_t acpi_device_adr_show(struct device *dev,
 	else
 		return sprintf(buf, "0x%08llx\n", acpi_dev->pnp.bus_address);
 }
-static DEVICE_ATTR(adr, 0444, acpi_device_adr_show, NULL);
+static DEVICE_ATTR_RO(adr);
 
-static ssize_t acpi_device_path_show(struct device *dev,
-				     struct device_attribute *attr, char *buf)
+static ssize_t path_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
 {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 
 	return acpi_object_path(acpi_dev->handle, buf);
 }
-static DEVICE_ATTR(path, 0444, acpi_device_path_show, NULL);
+static DEVICE_ATTR_RO(path);
 
 /* sysfs file that shows description text from the ACPI _STR method */
 static ssize_t description_show(struct device *dev,
@@ -455,8 +455,8 @@ static ssize_t description_show(struct device *dev,
 static DEVICE_ATTR_RO(description);
 
 static ssize_t
-acpi_device_sun_show(struct device *dev, struct device_attribute *attr,
-		     char *buf) {
+sun_show(struct device *dev, struct device_attribute *attr,
+	 char *buf) {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 	acpi_status status;
 	unsigned long long sun;
@@ -467,11 +467,11 @@ acpi_device_sun_show(struct device *dev, struct device_attribute *attr,
 
 	return sprintf(buf, "%llu\n", sun);
 }
-static DEVICE_ATTR(sun, 0444, acpi_device_sun_show, NULL);
+static DEVICE_ATTR_RO(sun);
 
 static ssize_t
-acpi_device_hrv_show(struct device *dev, struct device_attribute *attr,
-		     char *buf) {
+hrv_show(struct device *dev, struct device_attribute *attr,
+	 char *buf) {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 	acpi_status status;
 	unsigned long long hrv;
@@ -482,7 +482,7 @@ acpi_device_hrv_show(struct device *dev, struct device_attribute *attr,
 
 	return sprintf(buf, "%llu\n", hrv);
 }
-static DEVICE_ATTR(hrv, 0444, acpi_device_hrv_show, NULL);
+static DEVICE_ATTR_RO(hrv);
 
 static ssize_t status_show(struct device *dev, struct device_attribute *attr,
 				char *buf) {
diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index e3414131bfca..9bb42a772bee 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -485,7 +485,7 @@ int dock_notify(struct acpi_device *adev, u32 event)
 /*
  * show_docked - read method for "docked" file in sysfs
  */
-static ssize_t show_docked(struct device *dev,
+static ssize_t docked_show(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
 	struct dock_station *dock_station = dev->platform_data;
@@ -494,25 +494,25 @@ static ssize_t show_docked(struct device *dev,
 	acpi_bus_get_device(dock_station->handle, &adev);
 	return snprintf(buf, PAGE_SIZE, "%u\n", acpi_device_enumerated(adev));
 }
-static DEVICE_ATTR(docked, S_IRUGO, show_docked, NULL);
+static DEVICE_ATTR_RO(docked);
 
 /*
  * show_flags - read method for flags file in sysfs
  */
-static ssize_t show_flags(struct device *dev,
+static ssize_t flags_show(struct device *dev,
 			  struct device_attribute *attr, char *buf)
 {
 	struct dock_station *dock_station = dev->platform_data;
 	return snprintf(buf, PAGE_SIZE, "%d\n", dock_station->flags);
 
 }
-static DEVICE_ATTR(flags, S_IRUGO, show_flags, NULL);
+static DEVICE_ATTR_RO(flags);
 
 /*
  * write_undock - write method for "undock" file in sysfs
  */
-static ssize_t write_undock(struct device *dev, struct device_attribute *attr,
-			   const char *buf, size_t count)
+static ssize_t undock_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
 {
 	int ret;
 	struct dock_station *dock_station = dev->platform_data;
@@ -526,13 +526,13 @@ static ssize_t write_undock(struct device *dev, struct device_attribute *attr,
 	acpi_scan_lock_release();
 	return ret ? ret: count;
 }
-static DEVICE_ATTR(undock, S_IWUSR, NULL, write_undock);
+static DEVICE_ATTR_WO(undock);
 
 /*
  * show_dock_uid - read method for "uid" file in sysfs
  */
-static ssize_t show_dock_uid(struct device *dev,
-			     struct device_attribute *attr, char *buf)
+static ssize_t uid_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
 {
 	unsigned long long lbuf;
 	struct dock_station *dock_station = dev->platform_data;
@@ -543,10 +543,10 @@ static ssize_t show_dock_uid(struct device *dev,
 
 	return snprintf(buf, PAGE_SIZE, "%llx\n", lbuf);
 }
-static DEVICE_ATTR(uid, S_IRUGO, show_dock_uid, NULL);
+static DEVICE_ATTR_RO(uid);
 
-static ssize_t show_dock_type(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static ssize_t type_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
 {
 	struct dock_station *dock_station = dev->platform_data;
 	char *type;
@@ -562,7 +562,7 @@ static ssize_t show_dock_type(struct device *dev,
 
 	return snprintf(buf, PAGE_SIZE, "%s\n", type);
 }
-static DEVICE_ATTR(type, S_IRUGO, show_dock_type, NULL);
+static DEVICE_ATTR_RO(type);
 
 static struct attribute *dock_attributes[] = {
 	&dev_attr_docked.attr,
diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index fe1e7bc91a5e..3261cffdd5e0 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -888,15 +888,16 @@ static void acpi_release_power_resource(struct device *dev)
 	kfree(resource);
 }
 
-static ssize_t acpi_power_in_use_show(struct device *dev,
-				      struct device_attribute *attr,
-				      char *buf) {
+static ssize_t resource_in_use_show(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
 	struct acpi_power_resource *resource;
 
 	resource = to_power_resource(to_acpi_device(dev));
 	return sprintf(buf, "%u\n", !!resource->ref_count);
 }
-static DEVICE_ATTR(resource_in_use, 0444, acpi_power_in_use_show, NULL);
+static DEVICE_ATTR_RO(resource_in_use);
 
 static void acpi_power_sysfs_remove(struct acpi_device *device)
 {
-- 
2.30.2



