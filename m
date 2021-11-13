Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB2044F3B3
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 15:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhKMO1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 09:27:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:44442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231672AbhKMO1h (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 09:27:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2EBB60F14;
        Sat, 13 Nov 2021 14:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636813485;
        bh=nIVQArLIwNYlSEr4/0tlXI/rgcDAVcxr4wdsz/cgnTo=;
        h=Subject:To:Cc:From:Date:From;
        b=e7EO8XFqa1pAjkEZPEOBv1RsfzC97juPMfwn4KXKMLKvCKUKD4cX+E63u7Kco4JRp
         TIoSiBS1XAX2H0Dqw6/2SVMaYCvkOny4X97gulCLTdRS48RKJLGhureId+9RQrLklA
         X2W86naUt+sabg+sLCY0XMlaTAnNgNEsnymmLmYg=
Subject: FAILED: patch "[PATCH] PM: sleep: Do not let "syscore" devices runtime-suspend" failed to apply to 4.19-stable tree
To:     rafael.j.wysocki@intel.com, stable@vger.kernel.org,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 15:24:27 +0100
Message-ID: <163681346723560@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

