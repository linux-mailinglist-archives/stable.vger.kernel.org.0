Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10AAB159A16
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 20:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbgBKTzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 14:55:10 -0500
Received: from chill.innovation.ch ([216.218.245.220]:53738 "EHLO
        chill.innovation.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730021AbgBKTzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Feb 2020 14:55:09 -0500
X-Greylist: delayed 448 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Feb 2020 14:55:09 EST
Received: from localhost (localhost [127.0.0.1])
        by chill.innovation.ch (Postfix) with ESMTP id DB6556412AE;
        Tue, 11 Feb 2020 11:47:35 -0800 (PST)
X-Virus-Scanned: amavisd-new at 
Received: from chill.innovation.ch ([127.0.0.1])
        by localhost (chill.innovation.ch [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id Yt8Xyz8cUtTD; Tue, 11 Feb 2020 11:47:29 -0800 (PST)
From:   =?UTF-8?q?Ronald=20Tschal=C3=A4r?= <ronald@innovation.ch>
DKIM-Filter: OpenDKIM Filter v2.10.3 chill.innovation.ch 0617D64012B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=innovation.ch;
        s=default; t=1581450449;
        bh=pKyDgEF01POMD1o+SCeOkRD2KX+9ORpUNRhOfljEE+0=;
        h=From:To:Cc:Subject:Date:From;
        b=l/8+zDjee0rYEua1qQlF3fSjIbLgjPn0NgFtJMojTap23v8RAHOGYXrnm+FtZ2mvv
         uOCYbXQJGj4nePDyrz3k2Wh+ENIPX5UHIMo8522dI/n39cm28++TI8WrPPMGSMJtWO
         PwJ+LYuUzZx35AWGHkYMfWb/F+GThXBG4nRF9MYNMa7TMxqHsrG31n1ZG7WPPNjE+u
         ZnruWK2T+tuB5lToiSsJnavxSQahY+shWsbjklUvi4wL2vRKeUr295OKXosxvphcxC
         gXR225rqTAaFaZUZYIzw08ucNyFhckoNmoKRlJJU/k1YuZLaCzDxQ+9OrX8Z8XfmqW
         lBE10xCUJXO/Q==
To:     Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Maximilian Luz <luzmaximilian@gmail.com>
Cc:     linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] serdev: Fix detection of UART devices on Apple machines.
Date:   Tue, 11 Feb 2020 11:47:23 -0800
Message-Id: <20200211194723.486217-1-ronald@innovation.ch>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Ronald Tschalär <ronald@innovation.ch>
---
 drivers/tty/serdev/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
index ce5309d00280..0f64a10ba51f 100644
--- a/drivers/tty/serdev/core.c
+++ b/drivers/tty/serdev/core.c
@@ -18,6 +18,7 @@
 #include <linux/sched.h>
 #include <linux/serdev.h>
 #include <linux/slab.h>
+#include <linux/platform_data/x86/apple.h>
 
 static bool is_registered;
 static DEFINE_IDA(ctrl_ida);
@@ -630,6 +631,15 @@ static int acpi_serdev_check_resources(struct serdev_controller *ctrl,
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
2.24.1

