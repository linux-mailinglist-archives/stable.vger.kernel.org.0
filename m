Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBD735AF2
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 13:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfFELPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 07:15:32 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40121 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727330AbfFELPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 07:15:32 -0400
Received: by mail-pg1-f195.google.com with SMTP id d30so12204457pgm.7
        for <stable@vger.kernel.org>; Wed, 05 Jun 2019 04:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Os6hgQ4PaEd8eE9dNOjj22ajR4Ww3254gEhIvX/BVAI=;
        b=rfJbcdca7MvdukSVLWSgPqUMYpqgP1YudYjDRT19/yLtOQ3400RXH6SZ/45JRrILEI
         u6tl4yVFaZeCTatSfqoAXQ3+sDHl7ZgBXlcmtcWoIVKiTY71K60q+w6kKs4hPLWvTlbz
         7wwdi8CFKK1z4Gnzz3gLs3onuFrhGV9Wim1EcJfVZLetWNAz9s2tg9rie2UtaE5j5o+D
         godFUW/vEZiS9cfwka7hJGEWwZsGnCrDFUE2SlvP3EaDra4wGmmwW9c/JKJ+Og0d9I0C
         GwGm4QY7FTFudi9Nm94JUtyU6gSrgKpFJOEvUqoIdHgU9u22ngyher/+GV9IyGg1TPDQ
         szVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Os6hgQ4PaEd8eE9dNOjj22ajR4Ww3254gEhIvX/BVAI=;
        b=ogG4pf778zFdQfSglplwsBmT0M0vRbvboeSgYgVsE5BxXzMVzPi3+YRlDMS0dHnt4n
         U+0tDfZ/Vmq7xGISXnP7LPmBmkU0Oa/dzq+T0PRyKeuimQQLIThmceOy3ngmnuyw6rjn
         C4SU3DvkBg7p9ez+a8f7xCbNLt06mHbLh2kk+xgU1WRTE73idscvGz1Yu7E1xejPhWWf
         OX49ck+pq7gnOTgvzyhaV97lkLm1UAKPsQuqxKCVDvGowtcSAKAOvt+SamNeR45pUVBo
         hpWKROBvV6V12dQybLWS75ac86N1WC+TvxEfovhJf/wPVVufjapVjbKqxdV4LXGQbyOC
         WPvQ==
X-Gm-Message-State: APjAAAUM/UezGBi2K5cYE0JH++K9uiZutRqfTcWHcysHTcVuVTyKDQnQ
        ifc61UjWZoq+qN75s+Lq79ClZA==
X-Google-Smtp-Source: APXvYqzm2uya0Csh0G0kg3px1p2uilA/ZfNTrdIjO41m1gNoYp1b5/8pjVJaIfYNjCt/LZbmI0dOPA==
X-Received: by 2002:a63:4714:: with SMTP id u20mr3596625pga.347.1559733331417;
        Wed, 05 Jun 2019 04:15:31 -0700 (PDT)
Received: from ubt.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id f21sm2856860pjq.2.2019.06.05.04.15.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 04:15:30 -0700 (PDT)
From:   Chunyan Zhang <zhang.chunyan@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.Strashko@ti.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [BACKPORT 4.4.y] PM / sleep: prohibit devices probing during suspend/hibernation
Date:   Wed,  5 Jun 2019 19:14:12 +0800
Message-Id: <20190605111412.3461-1-zhang.chunyan@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Strashko, Grygorii" <grygorii.strashko@ti.com>

[ Upstream commit 013c074f8642d8e815ad670601f8e27155a74b57 ]

It is unsafe [1] if probing of devices will happen during suspend or
hibernation and system behavior will be unpredictable in this case.
So, let's prohibit device's probing in dpm_prepare() and defer their
probing instead. The normal behavior will be restored in
dpm_complete().

This patch introduces new DD core APIs:
 device_block_probing()
   It will disable probing of devices and defer their probes instead.
 device_unblock_probing()
   It will restore normal behavior and trigger re-probing of deferred
   devices.

[1] https://lkml.org/lkml/2015/9/11/554

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
---
 drivers/base/base.h       |  2 ++
 drivers/base/dd.c         | 48 ++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/base/power/main.c | 17 +++++++++++++++++
 3 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 1782f3a..e05db38 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -131,6 +131,8 @@ extern void device_remove_groups(struct device *dev,
 extern char *make_class_name(const char *name, struct kobject *kobj);
 
 extern int devres_release_all(struct device *dev);
+extern void device_block_probing(void);
+extern void device_unblock_probing(void);
 
 /* /sys/devices directory */
 extern struct kset *devices_kset;
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index d888741..ddee3456 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -55,6 +55,13 @@ static struct workqueue_struct *deferred_wq;
 static atomic_t deferred_trigger_count = ATOMIC_INIT(0);
 
 /*
+ * In some cases, like suspend to RAM or hibernation, It might be reasonable
+ * to prohibit probing of devices as it could be unsafe.
+ * Once defer_all_probes is true all drivers probes will be forcibly deferred.
+ */
+static bool defer_all_probes;
+
+/*
  * deferred_probe_work_func() - Retry probing devices in the active list.
  */
 static void deferred_probe_work_func(struct work_struct *work)
@@ -172,6 +179,30 @@ static void driver_deferred_probe_trigger(void)
 }
 
 /**
+ * device_block_probing() - Block/defere device's probes
+ *
+ *	It will disable probing of devices and defer their probes instead.
+ */
+void device_block_probing(void)
+{
+	defer_all_probes = true;
+	/* sync with probes to avoid races. */
+	wait_for_device_probe();
+}
+
+/**
+ * device_unblock_probing() - Unblock/enable device's probes
+ *
+ *	It will restore normal behavior and trigger re-probing of deferred
+ * devices.
+ */
+void device_unblock_probing(void)
+{
+	defer_all_probes = false;
+	driver_deferred_probe_trigger();
+}
+
+/**
  * deferred_probe_initcall() - Enable probing of deferred devices
  *
  * We don't want to get in the way when the bulk of drivers are getting probed.
@@ -279,9 +310,20 @@ static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
 
 static int really_probe(struct device *dev, struct device_driver *drv)
 {
-	int ret = 0;
+	int ret = -EPROBE_DEFER;
 	int local_trigger_count = atomic_read(&deferred_trigger_count);
 
+	if (defer_all_probes) {
+		/*
+		 * Value of defer_all_probes can be set only by
+		 * device_defer_all_probes_enable() which, in turn, will call
+		 * wait_for_device_probe() right after that to avoid any races.
+		 */
+		dev_dbg(dev, "Driver %s force probe deferral\n", drv->name);
+		driver_deferred_probe_add(dev);
+		return ret;
+	}
+
 	atomic_inc(&probe_count);
 	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
 		 drv->bus->name, __func__, drv->name, dev_name(dev));
@@ -387,6 +429,10 @@ int driver_probe_done(void)
  */
 void wait_for_device_probe(void)
 {
+	/* wait for the deferred probe workqueue to finish */
+	if (driver_deferred_probe_enable)
+		flush_workqueue(deferred_wq);
+
 	/* wait for the known devices to complete their probing */
 	wait_event(probe_waitqueue, atomic_read(&probe_count) == 0);
 	async_synchronize_full();
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 6c5bc3f..cf4384d 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -966,6 +966,9 @@ void dpm_complete(pm_message_t state)
 	}
 	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
+
+	/* Allow device probing and trigger re-probing of deferred devices */
+	device_unblock_probing();
 	trace_suspend_resume(TPS("dpm_complete"), state.event, false);
 }
 
@@ -1638,6 +1641,20 @@ int dpm_prepare(pm_message_t state)
 	trace_suspend_resume(TPS("dpm_prepare"), state.event, true);
 	might_sleep();
 
+	/*
+	 * Give a chance for the known devices to complete their probes, before
+	 * disable probing of devices. This sync point is important at least
+	 * at boot time + hibernation restore.
+	 */
+	wait_for_device_probe();
+	/*
+	 * It is unsafe if probing of devices will happen during suspend or
+	 * hibernation and system behavior will be unpredictable in this case.
+	 * So, let's prohibit device's probing here and defer their probes
+	 * instead. The normal behavior will be restored in dpm_complete().
+	 */
+	device_block_probing();
+
 	mutex_lock(&dpm_list_mtx);
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);
-- 
1.9.1

