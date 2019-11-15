Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F19BFD2AE
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 03:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfKOCFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 21:05:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:48040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726956AbfKOCFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Nov 2019 21:05:03 -0500
Received: from localhost (unknown [104.133.15.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E87BD20709;
        Fri, 15 Nov 2019 02:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573783502;
        bh=mMGHS7e5H/CHIY83Tf2sJ1Ki7LQvD6r/4RyrpUafnqo=;
        h=Subject:To:From:Date:From;
        b=Jm3buBPRZxVfDQHsMOksibVxExVtVrpogHqlBmp3CuzmwlhZOdi4REtL6WZEazGG6
         Q/a3h5CK+MMqZWLRHIYgffJQLNMKZqdBQvrLbUAFgVFyYnjL63eFJNAAp4hFg6uyDu
         ATcRrbaFbQljKhVwnQIluYTt7rATriyXVZ+wy8HQ=
Subject: patch "driver core: platform: use the correct callback type for" added to driver-core-next
To:     samitolvanen@google.com, gregkh@linuxfoundation.org,
        keescook@chromium.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Nov 2019 10:04:57 +0800
Message-ID: <15737834973529@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    driver core: platform: use the correct callback type for

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 492c88720d36eb662f9f10c1633f7726fbb07fc4 Mon Sep 17 00:00:00 2001
From: Sami Tolvanen <samitolvanen@google.com>
Date: Tue, 12 Nov 2019 13:41:56 -0800
Subject: driver core: platform: use the correct callback type for
 bus_find_device

platform_find_device_by_driver calls bus_find_device and passes
platform_match as the callback function. Casting the function to a
mismatching type trips indirect call Control-Flow Integrity (CFI) checking.

This change adds a callback function with the correct type and instead
of casting the function, explicitly casts the second parameter to struct
device_driver* as expected by platform_match.

Fixes: 36f3313d6bff9 ("platform: Add platform_find_device_by_driver() helper")
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191112214156.3430-1-samitolvanen@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/platform.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 1b8a20466eef..d51dc35749c6 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1310,6 +1310,11 @@ struct bus_type platform_bus_type = {
 };
 EXPORT_SYMBOL_GPL(platform_bus_type);
 
+static inline int __platform_match(struct device *dev, const void *drv)
+{
+	return platform_match(dev, (struct device_driver *)drv);
+}
+
 /**
  * platform_find_device_by_driver - Find a platform device with a given
  * driver.
@@ -1320,7 +1325,7 @@ struct device *platform_find_device_by_driver(struct device *start,
 					      const struct device_driver *drv)
 {
 	return bus_find_device(&platform_bus_type, start, drv,
-			       (void *)platform_match);
+			       __platform_match);
 }
 EXPORT_SYMBOL_GPL(platform_find_device_by_driver);
 
-- 
2.24.0


