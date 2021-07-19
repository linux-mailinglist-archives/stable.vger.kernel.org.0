Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7383CE396
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236316AbhGSPkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:40:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234455AbhGSPcQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:32:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7030C61422;
        Mon, 19 Jul 2021 16:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711028;
        bh=SnAOl7fKWjhe20IC1l1tJmqdbQ16Q/mHPq4YJDqkeLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGAepVItK7Slc7thB6ZC4yJDsvNTpXiys5UCKY7LtKl88ggDnLDJs4/BPpWM6eJMJ
         6e+FUDKAcI8bvmGWBUa2NeB4ZbrCFuGXOG4C+864mZ/ZH4ZQPy+Ymx8yOFtEfHvhHn
         j8b5EnmygfzJqd+MoElZprc9f/i9tZIr3PmvyA6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 199/351] power: supply: surface_battery: Fix battery event handling
Date:   Mon, 19 Jul 2021 16:52:25 +0200
Message-Id: <20210719144951.546574054@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit e633f33d2669cb54db2846f9cde08662d254dbd3 ]

The battery subsystem of the Surface Aggregator Module EC requires us to
register the battery notifier with instance ID 0. However, battery
events are actually sent with the instance ID corresponding to the
device, which is nonzero. Thus, the strict-matching approach doesn't
work here and will discard events that the driver is expected to handle.

To fix this we have to fall back on notifier matching by target-category
only and have to manually check the instance ID in the notifier
callback.

Fixes: 167f77f7d0b3 ("power: supply: Add battery driver for Surface Aggregator Module")
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/surface_battery.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/surface_battery.c b/drivers/power/supply/surface_battery.c
index 7efa431a62b2..5ec2e6bb2465 100644
--- a/drivers/power/supply/surface_battery.c
+++ b/drivers/power/supply/surface_battery.c
@@ -345,6 +345,16 @@ static u32 spwr_notify_bat(struct ssam_event_notifier *nf, const struct ssam_eve
 	struct spwr_battery_device *bat = container_of(nf, struct spwr_battery_device, notif);
 	int status;
 
+	/*
+	 * We cannot use strict matching when registering the notifier as the
+	 * EC expects us to register it against instance ID 0. Strict matching
+	 * would thus drop events, as those may have non-zero instance IDs in
+	 * this subsystem. So we need to check the instance ID of the event
+	 * here manually.
+	 */
+	if (event->instance_id != bat->sdev->uid.instance)
+		return 0;
+
 	dev_dbg(&bat->sdev->dev, "power event (cid = %#04x, iid = %#04x, tid = %#04x)\n",
 		event->command_id, event->instance_id, event->target_id);
 
@@ -720,8 +730,8 @@ static void spwr_battery_init(struct spwr_battery_device *bat, struct ssam_devic
 	bat->notif.base.fn = spwr_notify_bat;
 	bat->notif.event.reg = registry;
 	bat->notif.event.id.target_category = sdev->uid.category;
-	bat->notif.event.id.instance = 0;
-	bat->notif.event.mask = SSAM_EVENT_MASK_STRICT;
+	bat->notif.event.id.instance = 0;	/* need to register with instance 0 */
+	bat->notif.event.mask = SSAM_EVENT_MASK_TARGET;
 	bat->notif.event.flags = SSAM_EVENT_SEQUENCED;
 
 	bat->psy_desc.name = bat->name;
-- 
2.30.2



