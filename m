Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC49F4637BC
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242954AbhK3Ozl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243108AbhK3OyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:54:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3980CC061372;
        Tue, 30 Nov 2021 06:49:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8517ECE1A58;
        Tue, 30 Nov 2021 14:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE41BC53FD1;
        Tue, 30 Nov 2021 14:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283750;
        bh=Gw5VQ3RYUXRNsUiATi1GYRmPBWdQxHeYZIBJlwYHLnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UbHT917w5sbc5FLhlCDUTHfQoevGT+ykC1Xo+FPPzepoU+mXmuKdP/4ZdrvLklWnN
         Fpno/yBqaHqFKOzWTShzFU+yLtMEJ/j+6AlzyqBH+rnKltgIH+qFy3GXr6BmJ/TPwJ
         26lDtMEu+fwn/KMzlzL+NDjRx8m03eT4AixbUZwAkbFjn6tdfHNBlYOANWpnMShDrQ
         IUHvS74R0QDKEpCNlvylxSPXhxUvIAz8mjbz9rerpkCycITu4q+2MS/Gd46l4Aomcb
         HsUO5JLlRuvqCLf05d1kkFIoLaLU4X59vRhcitSyIltcxxoEv7a/9QAW8M3iVZetRT
         eHP6SUg86swfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>, dmitry.torokhov@gmail.com,
        linux-input@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.15 48/68] xen: add "not_essential" flag to struct xenbus_driver
Date:   Tue, 30 Nov 2021 09:46:44 -0500
Message-Id: <20211130144707.944580-48-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 37a72b08a3e1eb28053214dd8211eb09c2fd3187 ]

When booting the xenbus driver will wait for PV devices to have
connected to their backends before continuing. The timeout is different
between essential and non-essential devices.

Non-essential devices are identified by their nodenames directly in the
xenbus driver, which requires to update this list in case a new device
type being non-essential is added (this was missed for several types
in the past).

In order to avoid this problem, add a "not_essential" flag to struct
xenbus_driver which can be set to "true" by the respective frontend.

Set this flag for the frontends currently regarded to be not essential
(vkbs and vfb) and use it for testing in the xenbus driver.

Signed-off-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20211022064800.14978-2-jgross@suse.com
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/xen-kbdfront.c          |  1 +
 drivers/video/fbdev/xen-fbfront.c          |  1 +
 drivers/xen/xenbus/xenbus_probe_frontend.c | 14 +++-----------
 include/xen/xenbus.h                       |  1 +
 4 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/input/misc/xen-kbdfront.c b/drivers/input/misc/xen-kbdfront.c
index 4ff5cd2a6d8de..3d17a0b3fe511 100644
--- a/drivers/input/misc/xen-kbdfront.c
+++ b/drivers/input/misc/xen-kbdfront.c
@@ -542,6 +542,7 @@ static struct xenbus_driver xenkbd_driver = {
 	.remove = xenkbd_remove,
 	.resume = xenkbd_resume,
 	.otherend_changed = xenkbd_backend_changed,
+	.not_essential = true,
 };
 
 static int __init xenkbd_init(void)
diff --git a/drivers/video/fbdev/xen-fbfront.c b/drivers/video/fbdev/xen-fbfront.c
index 5ec51445bee88..6826f986da436 100644
--- a/drivers/video/fbdev/xen-fbfront.c
+++ b/drivers/video/fbdev/xen-fbfront.c
@@ -695,6 +695,7 @@ static struct xenbus_driver xenfb_driver = {
 	.remove = xenfb_remove,
 	.resume = xenfb_resume,
 	.otherend_changed = xenfb_backend_changed,
+	.not_essential = true,
 };
 
 static int __init xenfb_init(void)
diff --git a/drivers/xen/xenbus/xenbus_probe_frontend.c b/drivers/xen/xenbus/xenbus_probe_frontend.c
index 480944606a3c9..07b010a68fcf9 100644
--- a/drivers/xen/xenbus/xenbus_probe_frontend.c
+++ b/drivers/xen/xenbus/xenbus_probe_frontend.c
@@ -211,19 +211,11 @@ static int is_device_connecting(struct device *dev, void *data, bool ignore_none
 	if (drv && (dev->driver != drv))
 		return 0;
 
-	if (ignore_nonessential) {
-		/* With older QEMU, for PVonHVM guests the guest config files
-		 * could contain: vfb = [ 'vnc=1, vnclisten=0.0.0.0']
-		 * which is nonsensical as there is no PV FB (there can be
-		 * a PVKB) running as HVM guest. */
+	xendrv = to_xenbus_driver(dev->driver);
 
-		if ((strncmp(xendev->nodename, "device/vkbd", 11) == 0))
-			return 0;
+	if (ignore_nonessential && xendrv->not_essential)
+		return 0;
 
-		if ((strncmp(xendev->nodename, "device/vfb", 10) == 0))
-			return 0;
-	}
-	xendrv = to_xenbus_driver(dev->driver);
 	return (xendev->state < XenbusStateConnected ||
 		(xendev->state == XenbusStateConnected &&
 		 xendrv->is_ready && !xendrv->is_ready(xendev)));
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index b94074c827721..b13eb86395e05 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -112,6 +112,7 @@ struct xenbus_driver {
 	const char *name;       /* defaults to ids[0].devicetype */
 	const struct xenbus_device_id *ids;
 	bool allow_rebind; /* avoid setting xenstore closed during remove */
+	bool not_essential;     /* is not mandatory for boot progress */
 	int (*probe)(struct xenbus_device *dev,
 		     const struct xenbus_device_id *id);
 	void (*otherend_changed)(struct xenbus_device *dev,
-- 
2.33.0

