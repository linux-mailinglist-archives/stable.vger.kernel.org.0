Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6E244F3B0
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 15:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhKMO13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 09:27:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230001AbhKMO12 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 09:27:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1217D60F14;
        Sat, 13 Nov 2021 14:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636813476;
        bh=Mnki8agZpKoZvgsz9gMvTc6OW62vt9+elGm3CLQxjcc=;
        h=Subject:To:Cc:From:Date:From;
        b=dnf9LtrrYkPWbxi8EX0obFAwjWipRUi8gLxsk10JbFjiaybTzrZKA45qvmAOiFCFb
         /mG41LP237rLYgqKkUv4kOyHbbLYMhEWsyOvGFEGFuHt/Y3sJdPfqJb5SoYYrLjgtG
         ext1F42y24tES/EJv7nicxu9vLKukgxhkUzDP8jQ=
Subject: FAILED: patch "[PATCH] PM: sleep: Do not let "syscore" devices runtime-suspend" failed to apply to 4.14-stable tree
To:     rafael.j.wysocki@intel.com, stable@vger.kernel.org,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 15:24:26 +0100
Message-ID: <1636813466151164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 928265e3601cde78c7e0a3e518a93b27defed3b1 Mon Sep 17 00:00:00 2001
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Fri, 22 Oct 2021 14:58:23 +0200
Subject: [PATCH] PM: sleep: Do not let "syscore" devices runtime-suspend
 during system transitions

There is no reason to allow "syscore" devices to runtime-suspend
during system-wide PM transitions, because they are subject to the
same possible failure modes as any other devices in that respect.

Accordingly, change device_prepare() and device_complete() to call
pm_runtime_get_noresume() and pm_runtime_put(), respectively, for
"syscore" devices too.

Fixes: 057d51a1268f ("Merge branch 'pm-sleep'")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 3.10+ <stable@vger.kernel.org> # 3.10+
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index cbea78e79f3d..fca6eab871fc 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1051,7 +1051,7 @@ static void device_complete(struct device *dev, pm_message_t state)
 	const char *info = NULL;
 
 	if (dev->power.syscore)
-		return;
+		goto out;
 
 	device_lock(dev);
 
@@ -1081,6 +1081,7 @@ static void device_complete(struct device *dev, pm_message_t state)
 
 	device_unlock(dev);
 
+out:
 	pm_runtime_put(dev);
 }
 
@@ -1794,9 +1795,6 @@ static int device_prepare(struct device *dev, pm_message_t state)
 	int (*callback)(struct device *) = NULL;
 	int ret = 0;
 
-	if (dev->power.syscore)
-		return 0;
-
 	/*
 	 * If a device's parent goes into runtime suspend at the wrong time,
 	 * it won't be possible to resume the device.  To prevent this we
@@ -1805,6 +1803,9 @@ static int device_prepare(struct device *dev, pm_message_t state)
 	 */
 	pm_runtime_get_noresume(dev);
 
+	if (dev->power.syscore)
+		return 0;
+
 	device_lock(dev);
 
 	dev->power.wakeup_path = false;

