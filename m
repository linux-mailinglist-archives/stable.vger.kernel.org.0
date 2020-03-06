Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F37E17BDF0
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 14:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgCFNPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 08:15:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:42042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbgCFNPl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 08:15:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B2162166E;
        Fri,  6 Mar 2020 13:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583500540;
        bh=z7FZZdK3bhLXQp9SUZ65YPhabl44jXvx/8gdpxIEyaw=;
        h=Subject:To:From:Date:From;
        b=Xwhl3vgfqoxZAdBpxvhUQWlUzvrwzuO1EeH2zZBI6HFRMXe9OFr/08gHGczE3KJxl
         7aTsEvyy5IIEKLK3bdi9Hm6DHAfq7xHGLphRgWC6+mEMqIc5AcoTODHBqajd9Nk6vy
         xm2Jldq3ZKJScOcgqHxSYwwEGyKky3AEfd922JKo=
Subject: patch "serdev: Fix detection of UART devices on Apple machines." added to tty-linus
To:     ronald@innovation.ch, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 06 Mar 2020 14:15:38 +0100
Message-ID: <158350053819545@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serdev: Fix detection of UART devices on Apple machines.

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 35d4670aaec7206b5ef19c842ca33076bde562e4 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ronald=20Tschal=C3=A4r?= <ronald@innovation.ch>
Date: Tue, 11 Feb 2020 11:47:23 -0800
Subject: serdev: Fix detection of UART devices on Apple machines.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Apple devices the _CRS method returns an empty resource template, and
the resource settings are instead provided by the _DSM method. But
commit 33364d63c75d6182fa369cea80315cf1bb0ee38e (serdev: Add ACPI
devices by ResourceSource field) changed the search for serdev devices
to require valid, non-empty resource template, thereby breaking Apple
devices and causing bluetooth devices to not be found.

This expands the check so that if we don't find a valid template, and
we're on an Apple machine, then just check for the device being an
immediate child of the controller and having a "baud" property.

Cc: <stable@vger.kernel.org> # 5.5
Fixes: 33364d63c75d ("serdev: Add ACPI devices by ResourceSource field")
Signed-off-by: Ronald Tschalär <ronald@innovation.ch>
Link: https://lore.kernel.org/r/20200211194723.486217-1-ronald@innovation.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serdev/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
index 42345e79920c..c5f0d936b003 100644
--- a/drivers/tty/serdev/core.c
+++ b/drivers/tty/serdev/core.c
@@ -18,6 +18,7 @@
 #include <linux/sched.h>
 #include <linux/serdev.h>
 #include <linux/slab.h>
+#include <linux/platform_data/x86/apple.h>
 
 static bool is_registered;
 static DEFINE_IDA(ctrl_ida);
@@ -631,6 +632,15 @@ static int acpi_serdev_check_resources(struct serdev_controller *ctrl,
 	if (ret)
 		return ret;
 
+	/*
+	 * Apple machines provide an empty resource template, so on those
+	 * machines just look for immediate children with a "baud" property
+	 * (from the _DSM method) instead.
+	 */
+	if (!lookup.controller_handle && x86_apple_machine &&
+	    !acpi_dev_get_property(adev, "baud", ACPI_TYPE_BUFFER, NULL))
+		acpi_get_parent(adev->handle, &lookup.controller_handle);
+
 	/* Make sure controller and ResourceSource handle match */
 	if (ACPI_HANDLE(ctrl->dev.parent) != lookup.controller_handle)
 		return -ENODEV;
-- 
2.25.1


