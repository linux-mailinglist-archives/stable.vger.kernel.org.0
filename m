Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF3211DB9
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbfEBPcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729234AbfEBPck (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:32:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D562214DA;
        Thu,  2 May 2019 15:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811159;
        bh=IrfZlWArowlj4XAYmIMnowmF9GVSWBoqIzTFQcWYWMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9FuVaCnAX/etNBR3if3IsLb+CuHXw3Rrp7HfLoQtHJZzxGVIyLcuauKiDstytyEW
         LAT3DjOikibgWo8zcg/yxlZ3JfzBbCAJEXcJQL7qISNfv3rvghp30SbBZcx2bF4ZMT
         FsvwFMBICRnFdf/7akugI7tdSCapThcU6JzLeG/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 070/101] leds: trigger: netdev: fix refcnt leak on interface rename
Date:   Thu,  2 May 2019 17:21:12 +0200
Message-Id: <20190502143344.567363208@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4cb6560514fa19d556954b88128f3846fee66a03 ]

Renaming a netdev-trigger-tracked interface was resulting in an
unbalanced dev_hold().

Example:
> iw phy phy0 interface add foo type __ap
> echo netdev > trigger
> echo foo > device_name
> ip link set foo name bar
> iw dev bar del
[  237.355366] unregister_netdevice: waiting for bar to become free. Usage count = 1
[  247.435362] unregister_netdevice: waiting for bar to become free. Usage count = 1
[  257.545366] unregister_netdevice: waiting for bar to become free. Usage count = 1

Above problem was caused by trigger checking a dev->name which obviously
changes after renaming an interface. It meant missing all further events
including the NETDEV_UNREGISTER which is required for calling dev_put().

This change fixes that by:
1) Comparing device struct *address* for notification-filtering purposes
2) Dropping unneeded NETDEV_CHANGENAME code (no behavior change)

Fixes: 06f502f57d0d ("leds: trigger: Introduce a NETDEV trigger")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/leds/trigger/ledtrig-netdev.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 3dd3ed46d473..167a94c02d05 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -301,11 +301,11 @@ static int netdev_trig_notify(struct notifier_block *nb,
 		container_of(nb, struct led_netdev_data, notifier);
 
 	if (evt != NETDEV_UP && evt != NETDEV_DOWN && evt != NETDEV_CHANGE
-	    && evt != NETDEV_REGISTER && evt != NETDEV_UNREGISTER
-	    && evt != NETDEV_CHANGENAME)
+	    && evt != NETDEV_REGISTER && evt != NETDEV_UNREGISTER)
 		return NOTIFY_DONE;
 
-	if (strcmp(dev->name, trigger_data->device_name))
+	if (!(dev == trigger_data->net_dev ||
+	      (evt == NETDEV_REGISTER && !strcmp(dev->name, trigger_data->device_name))))
 		return NOTIFY_DONE;
 
 	cancel_delayed_work_sync(&trigger_data->work);
@@ -320,12 +320,9 @@ static int netdev_trig_notify(struct notifier_block *nb,
 		dev_hold(dev);
 		trigger_data->net_dev = dev;
 		break;
-	case NETDEV_CHANGENAME:
 	case NETDEV_UNREGISTER:
-		if (trigger_data->net_dev) {
-			dev_put(trigger_data->net_dev);
-			trigger_data->net_dev = NULL;
-		}
+		dev_put(trigger_data->net_dev);
+		trigger_data->net_dev = NULL;
 		break;
 	case NETDEV_UP:
 	case NETDEV_CHANGE:
-- 
2.19.1



