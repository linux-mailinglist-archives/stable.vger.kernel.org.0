Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B55523F8C1
	for <lists+stable@lfdr.de>; Sat,  8 Aug 2020 22:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgHHUd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 16:33:58 -0400
Received: from gofer.mess.org ([88.97.38.141]:48607 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbgHHUd6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 16:33:58 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 576C7C638B; Sat,  8 Aug 2020 21:33:52 +0100 (BST)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Cc:     syzbot+ceef16277388d6f24898@syzkaller.appspotmail.com,
        Hillf Danton <hdanton@sina.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] media: rc: uevent sysfs file races with rc_register_device()
Date:   Sat,  8 Aug 2020 21:33:51 +0100
Message-Id: <20200808203352.9793-1-sean@mess.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Only report uevent file contents if device still exists, else we might
read freed memory.

Reported-by: syzbot+ceef16277388d6f24898@syzkaller.appspotmail.com
Cc: Hillf Danton <hdanton@sina.com>
Cc: <stable@vger.kernel.org> # 4.16
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 7b53066d9d07..e1cda80a4b25 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1601,25 +1601,25 @@ static void rc_dev_release(struct device *device)
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
@@ -2011,14 +2011,14 @@ void rc_unregister_device(struct rc_dev *dev)
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
-- 
2.26.2

