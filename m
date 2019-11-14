Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E83FBE52
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 04:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfKNDbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 22:31:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbfKNDbh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Nov 2019 22:31:37 -0500
Received: from localhost (unknown [124.219.31.93])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0E8820672;
        Thu, 14 Nov 2019 03:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573702296;
        bh=JqPhWEyuIfRqba9PMYMdnfe/Rvynb/3XqaG+f/GcsYk=;
        h=Subject:To:From:Date:From;
        b=IOY0/gpxi+Y+trplDlxUTC+y9I0dN8nO5WetDBNptoTyPBQxcHxfzEn8eeRLktlOE
         fLI0kp3xlYCUU4OnPHjJ/bZPwExtgfS0w6s4jwh7sYHRvu5Czyx0VfV5kBSvOipS9y
         YDs8sHKj+b+5SSdnAs0tnmkHF/agD0XzvFeJMWcM=
Subject: patch "driver core: platform: use the correct callback type for" added to driver-core-testing
To:     samitolvanen@google.com, gregkh@linuxfoundation.org,
        keescook@chromium.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 14 Nov 2019 11:31:33 +0800
Message-ID: <1573702293127152@kroah.com>
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
in the driver-core-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the driver-core-next branch sometime soon,
after it passes testing, and the merge window is open.

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


