Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4936F7928B
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 19:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbfG2RpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 13:45:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59893 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726627AbfG2RpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 13:45:24 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AA14D223CD;
        Mon, 29 Jul 2019 13:45:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 29 Jul 2019 13:45:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=o5Zz1F
        R5+qrrDuQZf3Km08updA9skheJAIVZTGGURC4=; b=QVxwaqVFbQDdIEGAssGz3t
        QGHJp1b7ErbCF1IHuv3jCoMQLY9nt0NhMh0f06E2M6RQ071By+r8UfxOw/aB1deN
        wBecwEzzWqECVuEH8ZPi2QTFZs1IENXwulZGgouAM7wBB6z/BLtwTrnfqGdPI4em
        trXtEwM5pWmn1bTNRTCPHgjTclODXheHwByXWRX6LWjd9QvvHwXO1o7BMTyh6aP+
        RtBHTQU/GOh0TfoLFPSi3RpN8g592XL8WYiITdiz4AQxoeRRvGwiTyIykQRzq0lO
        Tg5CteMPs4MjvSP1+j4V33wmjaBhVJKeiPv45mJtyE/HVmgkvXhHYmCREJRJVbJg
        ==
X-ME-Sender: <xms:szA_XX2kypdSUPsqp64tYWVjrFp2LXz9PKvwsrPc8rcePPafxewLJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrledugdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedutd
X-ME-Proxy: <xmx:szA_XQhl5YOkNrwStZh574tPQAnTEh1FBvYY4sV59hLwGPv_Jm4Gcg>
    <xmx:szA_XfayO6c8F9QqqFUcYRBnuLBRL_wFhDxMimicktjl-6HaBjqqkA>
    <xmx:szA_XUVY7KIUUn90O7maB4GWMphm2JGbReG3o27AJUP7OerU76Sdmg>
    <xmx:szA_XfP4m7javqa04SoAFwMx7D_vUSWRKeYZHZWY6beQaqQK5QUyCA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 226BB8005C;
        Mon, 29 Jul 2019 13:45:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] libnvdimm/bus: Fix wait_nvdimm_bus_probe_idle() ABBA deadlock" failed to apply to 4.4-stable tree
To:     dan.j.williams@intel.com, jane.chu@oracle.com,
        stable@vger.kernel.org, vishal.l.verma@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jul 2019 19:45:16 +0200
Message-ID: <1564422316225188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ca6bf264f6d856f959c4239cda1047b587745c67 Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jul 2019 18:08:21 -0700
Subject: [PATCH] libnvdimm/bus: Fix wait_nvdimm_bus_probe_idle() ABBA deadlock

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
Tested-by: Jane Chu <jane.chu@oracle.com>
Link: https://lore.kernel.org/r/156341210094.292348.2384694131126767789.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index a38572bf486b..df41f3571dc9 100644
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
 
@@ -1016,7 +1018,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		case ND_CMD_ARS_START:
 		case ND_CMD_CLEAR_ERROR:
 		case ND_CMD_CALL:
-			dev_dbg(&nvdimm_bus->dev, "'%s' command while read-only.\n",
+			dev_dbg(dev, "'%s' command while read-only.\n",
 					nvdimm ? nvdimm_cmd_name(cmd)
 					: nvdimm_bus_cmd_name(cmd));
 			return -EPERM;
@@ -1105,7 +1107,8 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		goto out;
 	}
 
-	nvdimm_bus_lock(&nvdimm_bus->dev);
+	device_lock(dev);
+	nvdimm_bus_lock(dev);
 	rc = nd_cmd_clear_to_send(nvdimm_bus, nvdimm, func, buf);
 	if (rc)
 		goto out_unlock;
@@ -1125,7 +1128,8 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		rc = -EFAULT;
 
 out_unlock:
-	nvdimm_bus_unlock(&nvdimm_bus->dev);
+	nvdimm_bus_unlock(dev);
+	device_unlock(dev);
 out:
 	kfree(in_env);
 	kfree(out_env);
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

