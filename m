Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34382395E43
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhEaN4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:56:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233036AbhEaNxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:53:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BD37613B9;
        Mon, 31 May 2021 13:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468014;
        bh=xrEWKhxaCPVId2lpwzHuxHSTMK0+Ftdkiztod5AgKfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FVghsB2tZ+Nl69xIdRrAqQ4dYTIWyYIJoZdVE2I+wYHZpRHZxG4Xjmg0ptBUrRsjO
         cyJzvW2nV0eRgMXyTrgLr5baTuq8ZKU+8X3flrxrCY89SKyV+YXCfKy9ccNk0oFlv6
         V+5ZZ7a3qz3QBMmFtdkGtRKSWiJVGYZVCnivmr68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 077/252] drivers: base: Fix device link removal
Date:   Mon, 31 May 2021 15:12:22 +0200
Message-Id: <20210531130700.609299143@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 80dd33cf72d1ab4f0af303f1fa242c6d6c8d328f upstream.

When device_link_free() drops references to the supplier and
consumer devices of the device link going away and the reference
being dropped turns out to be the last one for any of those
device objects, its ->release callback will be invoked and it
may sleep which goes against the SRCU callback execution
requirements.

To address this issue, make the device link removal code carry out
the device_link_free() actions preceded by SRCU synchronization from
a separate work item (the "long" workqueue is used for that, because
it does not matter when the device link memory is released and it may
take time to get to that point) instead of using SRCU callbacks.

While at it, make the code work analogously when SRCU is not enabled
to reduce the differences between the SRCU and non-SRCU cases.

Fixes: 843e600b8a2b ("driver core: Fix sleeping in invalid context during device link deletion")
Cc: stable <stable@vger.kernel.org>
Reported-by: chenxiang (M) <chenxiang66@hisilicon.com>
Tested-by: chenxiang (M) <chenxiang66@hisilicon.com>
Reviewed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/5722787.lOV4Wx5bFT@kreacher
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c    |   37 +++++++++++++++++++++++--------------
 include/linux/device.h |    6 ++----
 2 files changed, 25 insertions(+), 18 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -83,6 +83,11 @@ int device_links_read_lock_held(void)
 {
 	return srcu_read_lock_held(&device_links_srcu);
 }
+
+static void device_link_synchronize_removal(void)
+{
+	synchronize_srcu(&device_links_srcu);
+}
 #else /* !CONFIG_SRCU */
 static DECLARE_RWSEM(device_links_lock);
 
@@ -113,6 +118,10 @@ int device_links_read_lock_held(void)
 	return lockdep_is_held(&device_links_lock);
 }
 #endif
+
+static inline void device_link_synchronize_removal(void)
+{
+}
 #endif /* !CONFIG_SRCU */
 
 static bool device_is_ancestor(struct device *dev, struct device *target)
@@ -332,8 +341,13 @@ static struct attribute *devlink_attrs[]
 };
 ATTRIBUTE_GROUPS(devlink);
 
-static void device_link_free(struct device_link *link)
+static void device_link_release_fn(struct work_struct *work)
 {
+	struct device_link *link = container_of(work, struct device_link, rm_work);
+
+	/* Ensure that all references to the link object have been dropped. */
+	device_link_synchronize_removal();
+
 	while (refcount_dec_not_one(&link->rpm_active))
 		pm_runtime_put(link->supplier);
 
@@ -342,24 +356,19 @@ static void device_link_free(struct devi
 	kfree(link);
 }
 
-#ifdef CONFIG_SRCU
-static void __device_link_free_srcu(struct rcu_head *rhead)
-{
-	device_link_free(container_of(rhead, struct device_link, rcu_head));
-}
-
 static void devlink_dev_release(struct device *dev)
 {
 	struct device_link *link = to_devlink(dev);
 
-	call_srcu(&device_links_srcu, &link->rcu_head, __device_link_free_srcu);
-}
-#else
-static void devlink_dev_release(struct device *dev)
-{
-	device_link_free(to_devlink(dev));
+	INIT_WORK(&link->rm_work, device_link_release_fn);
+	/*
+	 * It may take a while to complete this work because of the SRCU
+	 * synchronization in device_link_release_fn() and if the consumer or
+	 * supplier devices get deleted when it runs, so put it into the "long"
+	 * workqueue.
+	 */
+	queue_work(system_long_wq, &link->rm_work);
 }
-#endif
 
 static struct class devlink_class = {
 	.name = "devlink",
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -570,7 +570,7 @@ struct device {
  * @flags: Link flags.
  * @rpm_active: Whether or not the consumer device is runtime-PM-active.
  * @kref: Count repeated addition of the same link.
- * @rcu_head: An RCU head to use for deferred execution of SRCU callbacks.
+ * @rm_work: Work structure used for removing the link.
  * @supplier_preactivated: Supplier has been made active before consumer probe.
  */
 struct device_link {
@@ -583,9 +583,7 @@ struct device_link {
 	u32 flags;
 	refcount_t rpm_active;
 	struct kref kref;
-#ifdef CONFIG_SRCU
-	struct rcu_head rcu_head;
-#endif
+	struct work_struct rm_work;
 	bool supplier_preactivated; /* Owned by consumer probe. */
 };
 


