Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E32B79248
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 19:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfG2Rmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 13:42:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38623 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726905AbfG2Rmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 13:42:46 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E2DF32224B;
        Mon, 29 Jul 2019 13:42:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 29 Jul 2019 13:42:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/1Ddmf
        CiFv4sm9WROutAv50xhTizFnUz6NX1MvDh9DM=; b=RkHEF2/hwv2W4V8fAT99M6
        FDHVzxJBleCJy9I2i9itNckoR7s/9qmo3rRFwK8FZPzEYZ+4a2tLtrV6xc9WsyNj
        isEiIkW//kCrNgZ0I4wQL52/yvZ+gAETUKGp0VMZQVLa4XcAWur3a6rV1tlS8Jia
        LSztDg6mNb7o9Db64lf50RHmF4VxBZ56H800x2saI7GBgFPwuhBDW3IibPnxcb8R
        GkGwndMcNlcB+h4grHJ6MPkbHfAQYWQHdu2BLQ6tFMubRCSUGRSrcoiH4w0SUBDO
        4o2oQAL7qah6i6gYW6Q9Nmdp3gU7HqxzjCk2Iv7SyelXC83Fl1FCwSbPETyt8R3w
        ==
X-ME-Sender: <xms:FDA_Xeh_3mm7-qyolal9QfkhCivfPonX_j6pRPDOLHG8zAeJ6GYr4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrledugdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:FDA_Xa1t2CgH4TngCtvtyBrP-SYZO5QEv7uflVRRG_IFiTcV-9vwfQ>
    <xmx:FDA_Xblestf9O6hhkPg5s4Kfg6GWMO7FF-O2yTxMp-sgCQ37gTtDMA>
    <xmx:FDA_XZumlE6Ef3fBEKyA2DhKJzaQUGci3LrNrxKyJYH3zV8al176Hw>
    <xmx:FDA_XXh2CZBSXnnWYZU8B7xJpVSJmhRTVdwZw_HExU6ZsPnG_DxztQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 03181380075;
        Mon, 29 Jul 2019 13:42:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drivers/base: Introduce kill_device()" failed to apply to 4.19-stable tree
To:     dan.j.williams@intel.com, gregkh@linuxfoundation.org,
        jane.chu@oracle.com, rafael@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jul 2019 19:42:42 +0200
Message-ID: <156442216215216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 00289cd87676e14913d2d8492d1ce05c4baafdae Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jul 2019 18:07:53 -0700
Subject: [PATCH] drivers/base: Introduce kill_device()

The libnvdimm subsystem arranges for devices to be destroyed as a result
of a sysfs operation. Since device_unregister() cannot be called from
an actively running sysfs attribute of the same device libnvdimm
arranges for device_unregister() to be performed in an out-of-line async
context.

The driver core maintains a 'dead' state for coordinating its own racing
async registration / de-registration requests. Rather than add local
'dead' state tracking infrastructure to libnvdimm device objects, export
the existing state tracking via a new kill_device() helper.

The kill_device() helper simply marks the device as dead, i.e. that it
is on its way to device_del(), or returns that the device was already
dead. This can be used in advance of calling device_unregister() for
subsystems like libnvdimm that might need to handle multiple user
threads racing to delete a device.

This refactoring does not change any behavior, but it is a pre-requisite
for follow-on fixes and therefore marked for -stable.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Fixes: 4d88a97aa9e8 ("libnvdimm, nvdimm: dimm driver and base libnvdimm device-driver...")
Cc: <stable@vger.kernel.org>
Tested-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/156341207332.292348.14959761496009347574.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/base/core.c b/drivers/base/core.c
index fd7511e04e62..eaf3aa0cb803 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2211,6 +2211,24 @@ void put_device(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(put_device);
 
+bool kill_device(struct device *dev)
+{
+	/*
+	 * Require the device lock and set the "dead" flag to guarantee that
+	 * the update behavior is consistent with the other bitfields near
+	 * it and that we cannot have an asynchronous probe routine trying
+	 * to run while we are tearing out the bus/class/sysfs from
+	 * underneath the device.
+	 */
+	lockdep_assert_held(&dev->mutex);
+
+	if (dev->p->dead)
+		return false;
+	dev->p->dead = true;
+	return true;
+}
+EXPORT_SYMBOL_GPL(kill_device);
+
 /**
  * device_del - delete device from system.
  * @dev: device.
@@ -2230,15 +2248,8 @@ void device_del(struct device *dev)
 	struct kobject *glue_dir = NULL;
 	struct class_interface *class_intf;
 
-	/*
-	 * Hold the device lock and set the "dead" flag to guarantee that
-	 * the update behavior is consistent with the other bitfields near
-	 * it and that we cannot have an asynchronous probe routine trying
-	 * to run while we are tearing out the bus/class/sysfs from
-	 * underneath the device.
-	 */
 	device_lock(dev);
-	dev->p->dead = true;
+	kill_device(dev);
 	device_unlock(dev);
 
 	/* Notify clients of device removal.  This call must come
diff --git a/include/linux/device.h b/include/linux/device.h
index e85264fb6616..0da5c67f6be1 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1373,6 +1373,7 @@ extern int (*platform_notify_remove)(struct device *dev);
  */
 extern struct device *get_device(struct device *dev);
 extern void put_device(struct device *dev);
+extern bool kill_device(struct device *dev);
 
 #ifdef CONFIG_DEVTMPFS
 extern int devtmpfs_create_node(struct device *dev);

