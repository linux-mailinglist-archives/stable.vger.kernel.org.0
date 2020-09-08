Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2FC261D22
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731032AbgIHTbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731002AbgIHP6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:58:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E26C246E2;
        Tue,  8 Sep 2020 15:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579610;
        bh=Zrta8asgImS4Hpgo1V9zLaLLHHYj8NOiLwkbHAizcAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wM74pc7XPB3qFecZSbutkDnk/Q7VV+9oEkSy/A57hkZnxw+pGrie/24O6O6/0EHiH
         VT+V7JehnyBhUnlW4HDgv5TlunlnaUzetDmlmccQL0xJxa5MwJhgd8NzlsV7jvbzXx
         nCKSEFnmQzXunasdpxjKInqzOQb+T3IpF2oPY78c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ceef16277388d6f24898@syzkaller.appspotmail.com,
        Hillf Danton <hdanton@sina.com>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.8 150/186] media: rc: uevent sysfs file races with rc_unregister_device()
Date:   Tue,  8 Sep 2020 17:24:52 +0200
Message-Id: <20200908152248.929464358@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
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
@@ -1613,25 +1613,25 @@ static void rc_dev_release(struct device
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
@@ -2023,14 +2023,14 @@ void rc_unregister_device(struct rc_dev
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


