Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0DB261BE5
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731725AbgIHTKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:10:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731230AbgIHQFY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:05:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E78E229C6;
        Tue,  8 Sep 2020 15:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579969;
        bh=JHLVLYmI8zY5PT20YbNvmKVzTXAxqKwjCnx+wA90X0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=isGxuOxIcdUzPRsVUe1yQjI0LGeqrIoSV7Szwf942acnCiyAaI0nlfITL80zjn8oc
         TY8Bq59BlqQ2VIrdGwK0pYZ7m3ClUNNxC+zGgpcNUrXweU7BkrWD1bAYWEtd7vp+u6
         lyr2ATFBDLtetCnpgUR/9982ONTMPC1yUT1f4qMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ceef16277388d6f24898@syzkaller.appspotmail.com,
        Hillf Danton <hdanton@sina.com>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 105/129] media: rc: uevent sysfs file races with rc_unregister_device()
Date:   Tue,  8 Sep 2020 17:25:46 +0200
Message-Id: <20200908152235.088505773@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit 4f0835d6677dc69263f90f976524cb92b257d9f4 upstream.

Only report uevent file contents if device still registered, else we
might read freed memory.

Reported-by: syzbot+ceef16277388d6f24898@syzkaller.appspotmail.com
Cc: Hillf Danton <hdanton@sina.com>
Cc: <stable@vger.kernel.org> # 4.16+
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/rc/rc-main.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1577,25 +1577,25 @@ static void rc_dev_release(struct device
 	kfree(dev);
 }
 
-#define ADD_HOTPLUG_VAR(fmt, val...)					\
-	do {								\
-		int err = add_uevent_var(env, fmt, val);		\
-		if (err)						\
-			return err;					\
-	} while (0)
-
 static int rc_dev_uevent(struct device *device, struct kobj_uevent_env *env)
 {
 	struct rc_dev *dev = to_rc_dev(device);
+	int ret = 0;
 
-	if (dev->rc_map.name)
-		ADD_HOTPLUG_VAR("NAME=%s", dev->rc_map.name);
-	if (dev->driver_name)
-		ADD_HOTPLUG_VAR("DRV_NAME=%s", dev->driver_name);
-	if (dev->device_name)
-		ADD_HOTPLUG_VAR("DEV_NAME=%s", dev->device_name);
+	mutex_lock(&dev->lock);
 
-	return 0;
+	if (!dev->registered)
+		ret = -ENODEV;
+	if (ret == 0 && dev->rc_map.name)
+		ret = add_uevent_var(env, "NAME=%s", dev->rc_map.name);
+	if (ret == 0 && dev->driver_name)
+		ret = add_uevent_var(env, "DRV_NAME=%s", dev->driver_name);
+	if (ret == 0 && dev->device_name)
+		ret = add_uevent_var(env, "DEV_NAME=%s", dev->device_name);
+
+	mutex_unlock(&dev->lock);
+
+	return ret;
 }
 
 /*
@@ -1987,14 +1987,14 @@ void rc_unregister_device(struct rc_dev
 	del_timer_sync(&dev->timer_keyup);
 	del_timer_sync(&dev->timer_repeat);
 
-	rc_free_rx_device(dev);
-
 	mutex_lock(&dev->lock);
 	if (dev->users && dev->close)
 		dev->close(dev);
 	dev->registered = false;
 	mutex_unlock(&dev->lock);
 
+	rc_free_rx_device(dev);
+
 	/*
 	 * lirc device should be freed with dev->registered = false, so
 	 * that userspace polling will get notified.


