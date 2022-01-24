Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB43499716
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376747AbiAXVJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:09:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57456 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445711AbiAXVEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:04:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21F5AB8123D;
        Mon, 24 Jan 2022 21:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E8DC340EA;
        Mon, 24 Jan 2022 21:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058284;
        bh=B2XzkCbD1hJiPE4C447BD00cSG+WKckSPUTUv11flOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlV+OK3AQtKuEjxHrjSkMzA/cvGhFvpVh626t0eOIK7rAikFAQueTt5m//8b11MQ4
         hyRaZ5c2cpZSc7cBrgSaLubsVAYIIA9bDEi4TLzmvKGoRQfGE+J4MmDEKd34CNVeSX
         YY50MTIfpOUfrsOaublkzQaUy98wAlFyY4eRMGTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0240/1039] platform/x86: wmi: Fix driver->notify() vs ->probe() race
Date:   Mon, 24 Jan 2022 19:33:49 +0100
Message-Id: <20220124184133.392081454@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 9918878676a5f9e99b98679f04b9e6c0f5426b0a ]

The driver core sets struct device->driver before calling out
to the bus' probe() method, this leaves a window where an ACPI
notify may happen on the WMI object before the driver's
probe() method has completed running, causing e.g. the
driver's notify() callback to get called with drvdata
not yet being set leading to a NULL pointer deref.

At a check for this to the WMI core, ensuring that the notify()
callback is not called before the driver is ready.

Fixes: 1686f5444546 ("platform/x86: wmi: Incorporate acpi_install_notify_handler")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20211128190031.405620-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/wmi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 46178e03aecad..02aba274c4bc2 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -59,6 +59,7 @@ static_assert(__alignof__(struct guid_block) == 1);
 
 enum {	/* wmi_block flags */
 	WMI_READ_TAKES_NO_ARGS,
+	WMI_PROBED,
 };
 
 struct wmi_block {
@@ -1008,6 +1009,7 @@ static int wmi_dev_probe(struct device *dev)
 		}
 	}
 
+	set_bit(WMI_PROBED, &wblock->flags);
 	return 0;
 
 probe_misc_failure:
@@ -1025,6 +1027,8 @@ static void wmi_dev_remove(struct device *dev)
 	struct wmi_block *wblock = dev_to_wblock(dev);
 	struct wmi_driver *wdriver = drv_to_wdrv(dev->driver);
 
+	clear_bit(WMI_PROBED, &wblock->flags);
+
 	if (wdriver->filter_callback) {
 		misc_deregister(&wblock->char_dev);
 		kfree(wblock->char_dev.name);
@@ -1322,7 +1326,7 @@ static void acpi_wmi_notify_handler(acpi_handle handle, u32 event,
 		return;
 
 	/* If a driver is bound, then notify the driver. */
-	if (wblock->dev.dev.driver) {
+	if (test_bit(WMI_PROBED, &wblock->flags) && wblock->dev.dev.driver) {
 		struct wmi_driver *driver = drv_to_wdrv(wblock->dev.dev.driver);
 		struct acpi_buffer evdata = { ACPI_ALLOCATE_BUFFER, NULL };
 		acpi_status status;
-- 
2.34.1



