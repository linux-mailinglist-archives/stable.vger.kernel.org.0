Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 537BA13F0E5
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392377AbgAPR1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:27:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:36366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392321AbgAPR1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:27:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F419246D4;
        Thu, 16 Jan 2020 17:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195619;
        bh=HEfK2KpxI9JcRyxK58/DnvyfOIJxDZIR/FRlXyEiOzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+wcKfGfHxIpgRUcx6UgklASu+0dSS1r6y7UE9XUsOiB1JA3uG92WyL9USu8kDTpE
         zHKB6ptp9Pyhw/lRe/6N3ZePXitdfXR2yaDH3IXjID3pK7n9cfZvCTSUrkf6nfdxys
         WH7s5WDXkjbgvQwZM3eYIJkZADPtl7Hn3ELmW9S4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@mellanox.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 191/371] vfio/mdev: Fix aborting mdev child device removal if one fails
Date:   Thu, 16 Jan 2020 12:21:03 -0500
Message-Id: <20200116172403.18149-134-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit 6093e348a5e2475c5bb2e571346460f939998670 ]

device_for_each_child() stops executing callback function for remaining
child devices, if callback hits an error.
Each child mdev device is independent of each other.
While unregistering parent device, mdev core must remove all child mdev
devices.
Therefore, mdev_device_remove_cb() always returns success so that
device_for_each_child doesn't abort if one child removal hits error.

While at it, improve remove and unregister functions for below simplicity.

There isn't need to pass forced flag pointer during mdev parent
removal which invokes mdev_device_remove(). So simplify the flow.

mdev_device_remove() is called from two paths.
1. mdev_unregister_driver()
     mdev_device_remove_cb()
       mdev_device_remove()
2. remove_store()
     mdev_device_remove()

Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/mdev/mdev_core.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 8cfa71230877..e052f62fdea7 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -150,10 +150,10 @@ static int mdev_device_remove_ops(struct mdev_device *mdev, bool force_remove)
 
 static int mdev_device_remove_cb(struct device *dev, void *data)
 {
-	if (!dev_is_mdev(dev))
-		return 0;
+	if (dev_is_mdev(dev))
+		mdev_device_remove(dev, true);
 
-	return mdev_device_remove(dev, data ? *(bool *)data : true);
+	return 0;
 }
 
 /*
@@ -241,7 +241,6 @@ EXPORT_SYMBOL(mdev_register_device);
 void mdev_unregister_device(struct device *dev)
 {
 	struct mdev_parent *parent;
-	bool force_remove = true;
 
 	mutex_lock(&parent_list_lock);
 	parent = __find_parent_device(dev);
@@ -255,8 +254,7 @@ void mdev_unregister_device(struct device *dev)
 	list_del(&parent->next);
 	class_compat_remove_link(mdev_bus_compat_class, dev, NULL);
 
-	device_for_each_child(dev, (void *)&force_remove,
-			      mdev_device_remove_cb);
+	device_for_each_child(dev, NULL, mdev_device_remove_cb);
 
 	parent_remove_sysfs_files(parent);
 
-- 
2.20.1

