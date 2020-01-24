Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAA5147D1E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbgAXJ5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:57:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:32816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731035AbgAXJ5R (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:57:17 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AB6F214AF;
        Fri, 24 Jan 2020 09:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859836;
        bh=7bw2nOfb9pp3DL6IT/E9v7cEYrhBwFKvdoBR3TwdHVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWpXK+E2EJIb4NMYbTV2K8sZWsUEv84+PJ/z2BiKntKrTnar/90rcfVXKeqJvUCYF
         XbemyNEPHBaxIJRaz9FP7hdpIC0su6gy6mvOXTHC576HtQoMTVoWjVwrhZnxe1pHez
         yj4N+8EVIudw4GjRwZTno+m4Z0Rd/oiJOsag3YQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 197/343] vfio/mdev: Fix aborting mdev child device removal if one fails
Date:   Fri, 24 Jan 2020 10:30:15 +0100
Message-Id: <20200124092945.891331671@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8cfa712308773..e052f62fdea7e 100644
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



