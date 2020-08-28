Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B352601EE
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 19:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbgIGROv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 13:14:51 -0400
Received: from www.linuxtv.org ([130.149.80.248]:50410 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729705AbgIGOOl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 10:14:41 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1kFHoP-000Ijv-3p; Mon, 07 Sep 2020 14:08:01 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Fri, 28 Aug 2020 12:06:35 +0000
Subject: [git:media_tree/master] media: rc: uevent sysfs file races with rc_unregister_device()
To:     linuxtv-commits@linuxtv.org
Cc:     Sean Young <sean@mess.org>, Hillf Danton <hdanton@sina.com>,
        stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1kFHoP-000Ijv-3p@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: rc: uevent sysfs file races with rc_unregister_device()
Author:  Sean Young <sean@mess.org>
Date:    Sat Aug 8 13:19:12 2020 +0200

Only report uevent file contents if device still registered, else we
might read freed memory.

Reported-by: syzbot+ceef16277388d6f24898@syzkaller.appspotmail.com
Cc: Hillf Danton <hdanton@sina.com>
Cc: <stable@vger.kernel.org> # 4.16+
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/rc/rc-main.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

---

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
