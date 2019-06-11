Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A61AC41913
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 01:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408242AbfFKXk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 19:40:28 -0400
Received: from mga06.intel.com ([134.134.136.31]:35765 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408263AbfFKXk2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 19:40:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jun 2019 16:40:27 -0700
X-ExtLoop1: 1
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga007.fm.intel.com with ESMTP; 11 Jun 2019 16:40:26 -0700
Subject: [PATCH 5/6] libnvdimm/bus: Fix wait_nvdimm_bus_probe_idle() ABBA
 deadlock
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-nvdimm@lists.01.org
Cc:     stable@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 11 Jun 2019 16:26:10 -0700
Message-ID: <156029557026.419799.1378625476581339382.stgit@dwillia2-desk3.amr.corp.intel.com>
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

A multithreaded namespace creation/destruction stress test currently
deadlocks with the following lockup signature:

    INFO: task ndctl:2924 blocked for more than 122 seconds.
          Tainted: G           OE     5.2.0-rc4+ #3382
    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    ndctl           D    0  2924   1176 0x00000000
    Call Trace:
     ? __schedule+0x27e/0x780
     schedule+0x30/0xb0
     wait_nvdimm_bus_probe_idle+0x8a/0xd0 [libnvdimm]
     ? finish_wait+0x80/0x80
     uuid_store+0xe6/0x2e0 [libnvdimm]
     kernfs_fop_write+0xf0/0x1a0
     vfs_write+0xb7/0x1b0
     ksys_write+0x5c/0xd0
     do_syscall_64+0x60/0x240

     INFO: task ndctl:2923 blocked for more than 122 seconds.
           Tainted: G           OE     5.2.0-rc4+ #3382
     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
     ndctl           D    0  2923   1175 0x00000000
     Call Trace:
      ? __schedule+0x27e/0x780
      ? __mutex_lock+0x489/0x910
      schedule+0x30/0xb0
      schedule_preempt_disabled+0x11/0x20
      __mutex_lock+0x48e/0x910
      ? nvdimm_namespace_common_probe+0x95/0x4d0 [libnvdimm]
      ? __lock_acquire+0x23f/0x1710
      ? nvdimm_namespace_common_probe+0x95/0x4d0 [libnvdimm]
      nvdimm_namespace_common_probe+0x95/0x4d0 [libnvdimm]
      __dax_pmem_probe+0x5e/0x210 [dax_pmem_core]
      ? nvdimm_bus_probe+0x1d0/0x2c0 [libnvdimm]
      dax_pmem_probe+0xc/0x20 [dax_pmem]
      nvdimm_bus_probe+0x90/0x2c0 [libnvdimm]
      really_probe+0xef/0x390
      driver_probe_device+0xb4/0x100

In this sequence an 'nd_dax' device is being probed and trying to take
the lock on its backing namespace to validate that the 'nd_dax' device
indeed has exclusive access to the backing namespace. Meanwhile, another
thread is trying to update the uuid property of that same backing
namespace. So one thread is in the probe path trying to acquire the
lock, and the other thread has acquired the lock and tries to flush the
probe path.

Fix this deadlock by not holding the namespace device_lock over the
wait_nvdimm_bus_probe_idle() synchronization step. In turn this requires
the device_lock to be held on entry to wait_nvdimm_bus_probe_idle() and
subsequently dropped internally to wait_nvdimm_bus_probe_idle().

Cc: <stable@vger.kernel.org>
Fixes: bf9bccc14c05 ("libnvdimm: pmem label sets and namespace instantiation")
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c         |   17 +++++++++++------
 drivers/nvdimm/region_devs.c |    4 ++++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index dfb93228d6a7..c1d26fca9c4c 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -887,10 +887,12 @@ void wait_nvdimm_bus_probe_idle(struct device *dev)
 	do {
 		if (nvdimm_bus->probe_active == 0)
 			break;
-		nvdimm_bus_unlock(&nvdimm_bus->dev);
+		nvdimm_bus_unlock(dev);
+		device_unlock(dev);
 		wait_event(nvdimm_bus->wait,
 				nvdimm_bus->probe_active == 0);
-		nvdimm_bus_lock(&nvdimm_bus->dev);
+		device_lock(dev);
+		nvdimm_bus_lock(dev);
 	} while (true);
 }
 
@@ -1017,7 +1019,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		case ND_CMD_ARS_START:
 		case ND_CMD_CLEAR_ERROR:
 		case ND_CMD_CALL:
-			dev_dbg(&nvdimm_bus->dev, "'%s' command while read-only.\n",
+			dev_dbg(dev, "'%s' command while read-only.\n",
 					nvdimm ? nvdimm_cmd_name(cmd)
 					: nvdimm_bus_cmd_name(cmd));
 			return -EPERM;
@@ -1088,7 +1090,8 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		goto out;
 	}
 
-	nvdimm_bus_lock(&nvdimm_bus->dev);
+	device_lock(dev);
+	nvdimm_bus_lock(dev);
 	rc = nd_cmd_clear_to_send(nvdimm_bus, nvdimm, func, buf);
 	if (rc)
 		goto out_unlock;
@@ -1103,7 +1106,8 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		nvdimm_account_cleared_poison(nvdimm_bus, clear_err->address,
 				clear_err->cleared);
 	}
-	nvdimm_bus_unlock(&nvdimm_bus->dev);
+	nvdimm_bus_unlock(dev);
+	device_unlock(dev);
 
 	if (copy_to_user(p, buf, buf_len))
 		rc = -EFAULT;
@@ -1112,7 +1116,8 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	return rc;
 
  out_unlock:
-	nvdimm_bus_unlock(&nvdimm_bus->dev);
+	nvdimm_bus_unlock(dev);
+	device_unlock(dev);
  out:
 	vfree(buf);
 	return rc;
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 4fed9ce9c2fe..a15276cdec7d 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -422,10 +422,12 @@ static ssize_t available_size_show(struct device *dev,
 	 * memory nvdimm_bus_lock() is dropped, but that's userspace's
 	 * problem to not race itself.
 	 */
+	device_lock(dev);
 	nvdimm_bus_lock(dev);
 	wait_nvdimm_bus_probe_idle(dev);
 	available = nd_region_available_dpa(nd_region);
 	nvdimm_bus_unlock(dev);
+	device_unlock(dev);
 
 	return sprintf(buf, "%llu\n", available);
 }
@@ -437,10 +439,12 @@ static ssize_t max_available_extent_show(struct device *dev,
 	struct nd_region *nd_region = to_nd_region(dev);
 	unsigned long long available = 0;
 
+	device_lock(dev);
 	nvdimm_bus_lock(dev);
 	wait_nvdimm_bus_probe_idle(dev);
 	available = nd_region_allocatable_dpa(nd_region);
 	nvdimm_bus_unlock(dev);
+	device_unlock(dev);
 
 	return sprintf(buf, "%llu\n", available);
 }

