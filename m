Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E11074190F
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 01:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408235AbfFKXkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 19:40:22 -0400
Received: from mga07.intel.com ([134.134.136.100]:19161 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405380AbfFKXkW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 19:40:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jun 2019 16:40:21 -0700
X-ExtLoop1: 1
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Jun 2019 16:40:21 -0700
Subject: [PATCH 4/6] libnvdimm/bus: Stop holding nvdimm_bus_list_mutex over
 __nd_ioctl()
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-nvdimm@lists.01.org
Cc:     stable@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 11 Jun 2019 16:26:04 -0700
Message-ID: <156029556467.419799.3133315211346023544.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156029554317.419799.1324389595953183385.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156029554317.419799.1324389595953183385.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-2-gc94f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In preparation for fixing a deadlock between wait_for_bus_probe_idle()
and the nvdimm_bus_list_mutex arrange for __nd_ioctl() without
nvdimm_bus_list_mutex held. This also unifies the 'dimm' and 'bus' level
ioctls into a common nd_ioctl() preamble implementation.

Marked for -stable as it is a pre-requisite for a follow-on fix.

Cc: <stable@vger.kernel.org>
Fixes: bf9bccc14c05 ("libnvdimm: pmem label sets and namespace instantiation")
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c     |   96 ++++++++++++++++++++++++++++------------------
 drivers/nvdimm/nd-core.h |    3 +
 2 files changed, 60 insertions(+), 39 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 42713b210f51..dfb93228d6a7 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -73,7 +73,7 @@ static void nvdimm_bus_probe_end(struct nvdimm_bus *nvdimm_bus)
 {
 	nvdimm_bus_lock(&nvdimm_bus->dev);
 	if (--nvdimm_bus->probe_active == 0)
-		wake_up(&nvdimm_bus->probe_wait);
+		wake_up(&nvdimm_bus->wait);
 	nvdimm_bus_unlock(&nvdimm_bus->dev);
 }
 
@@ -341,7 +341,7 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 		return NULL;
 	INIT_LIST_HEAD(&nvdimm_bus->list);
 	INIT_LIST_HEAD(&nvdimm_bus->mapping_list);
-	init_waitqueue_head(&nvdimm_bus->probe_wait);
+	init_waitqueue_head(&nvdimm_bus->wait);
 	nvdimm_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
 	if (nvdimm_bus->id < 0) {
 		kfree(nvdimm_bus);
@@ -426,6 +426,9 @@ static int nd_bus_remove(struct device *dev)
 	list_del_init(&nvdimm_bus->list);
 	mutex_unlock(&nvdimm_bus_list_mutex);
 
+	wait_event(nvdimm_bus->wait,
+			atomic_read(&nvdimm_bus->ioctl_active) == 0);
+
 	nd_synchronize();
 	device_for_each_child(&nvdimm_bus->dev, NULL, child_unregister);
 
@@ -885,7 +888,7 @@ void wait_nvdimm_bus_probe_idle(struct device *dev)
 		if (nvdimm_bus->probe_active == 0)
 			break;
 		nvdimm_bus_unlock(&nvdimm_bus->dev);
-		wait_event(nvdimm_bus->probe_wait,
+		wait_event(nvdimm_bus->wait,
 				nvdimm_bus->probe_active == 0);
 		nvdimm_bus_lock(&nvdimm_bus->dev);
 	} while (true);
@@ -1115,24 +1118,10 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	return rc;
 }
 
-static long nd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	long id = (long) file->private_data;
-	int rc = -ENXIO, ro;
-	struct nvdimm_bus *nvdimm_bus;
-
-	ro = ((file->f_flags & O_ACCMODE) == O_RDONLY);
-	mutex_lock(&nvdimm_bus_list_mutex);
-	list_for_each_entry(nvdimm_bus, &nvdimm_bus_list, list) {
-		if (nvdimm_bus->id == id) {
-			rc = __nd_ioctl(nvdimm_bus, NULL, ro, cmd, arg);
-			break;
-		}
-	}
-	mutex_unlock(&nvdimm_bus_list_mutex);
-
-	return rc;
-}
+enum nd_ioctl_mode {
+	BUS_IOCTL,
+	DIMM_IOCTL,
+};
 
 static int match_dimm(struct device *dev, void *data)
 {
@@ -1147,31 +1136,62 @@ static int match_dimm(struct device *dev, void *data)
 	return 0;
 }
 
-static long nvdimm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static long nd_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
+		enum nd_ioctl_mode mode)
+
 {
-	int rc = -ENXIO, ro;
-	struct nvdimm_bus *nvdimm_bus;
+	struct nvdimm_bus *nvdimm_bus, *found = NULL;
+	long id = (long) file->private_data;
+	struct nvdimm *nvdimm = NULL;
+	int rc, ro;
 
 	ro = ((file->f_flags & O_ACCMODE) == O_RDONLY);
 	mutex_lock(&nvdimm_bus_list_mutex);
 	list_for_each_entry(nvdimm_bus, &nvdimm_bus_list, list) {
-		struct device *dev = device_find_child(&nvdimm_bus->dev,
-				file->private_data, match_dimm);
-		struct nvdimm *nvdimm;
-
-		if (!dev)
-			continue;
+		if (mode == DIMM_IOCTL) {
+			struct device *dev;
+
+			dev = device_find_child(&nvdimm_bus->dev,
+					file->private_data, match_dimm);
+			if (!dev)
+				continue;
+			nvdimm = to_nvdimm(dev);
+			found = nvdimm_bus;
+		} else if (nvdimm_bus->id == id) {
+			found = nvdimm_bus;
+		}
 
-		nvdimm = to_nvdimm(dev);
-		rc = __nd_ioctl(nvdimm_bus, nvdimm, ro, cmd, arg);
-		put_device(dev);
-		break;
+		if (found) {
+			atomic_inc(&nvdimm_bus->ioctl_active);
+			break;
+		}
 	}
 	mutex_unlock(&nvdimm_bus_list_mutex);
 
+	if (!found)
+		return -ENXIO;
+
+	nvdimm_bus = found;
+	rc = __nd_ioctl(nvdimm_bus, nvdimm, ro, cmd, arg);
+
+	if (nvdimm)
+		put_device(&nvdimm->dev);
+	if (atomic_dec_and_test(&nvdimm_bus->ioctl_active))
+		wake_up(&nvdimm_bus->wait);
+
 	return rc;
 }
 
+static long bus_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	return nd_ioctl(file, cmd, arg, BUS_IOCTL);
+}
+
+static long dimm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	return nd_ioctl(file, cmd, arg, DIMM_IOCTL);
+}
+
 static int nd_open(struct inode *inode, struct file *file)
 {
 	long minor = iminor(inode);
@@ -1183,16 +1203,16 @@ static int nd_open(struct inode *inode, struct file *file)
 static const struct file_operations nvdimm_bus_fops = {
 	.owner = THIS_MODULE,
 	.open = nd_open,
-	.unlocked_ioctl = nd_ioctl,
-	.compat_ioctl = nd_ioctl,
+	.unlocked_ioctl = bus_ioctl,
+	.compat_ioctl = bus_ioctl,
 	.llseek = noop_llseek,
 };
 
 static const struct file_operations nvdimm_fops = {
 	.owner = THIS_MODULE,
 	.open = nd_open,
-	.unlocked_ioctl = nvdimm_ioctl,
-	.compat_ioctl = nvdimm_ioctl,
+	.unlocked_ioctl = dimm_ioctl,
+	.compat_ioctl = dimm_ioctl,
 	.llseek = noop_llseek,
 };
 
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 391e88de3a29..6cd470547106 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -17,10 +17,11 @@ extern struct workqueue_struct *nvdimm_wq;
 
 struct nvdimm_bus {
 	struct nvdimm_bus_descriptor *nd_desc;
-	wait_queue_head_t probe_wait;
+	wait_queue_head_t wait;
 	struct list_head list;
 	struct device dev;
 	int id, probe_active;
+	atomic_t ioctl_active;
 	struct list_head mapping_list;
 	struct mutex reconfig_mutex;
 	struct badrange badrange;

