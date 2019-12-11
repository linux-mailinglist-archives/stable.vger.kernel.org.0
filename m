Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3956B11B75F
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbfLKPM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:12:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:34164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731131AbfLKPM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAFE92465E;
        Wed, 11 Dec 2019 15:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077147;
        bh=z63DRufKh+HaVrDTfZRb6x5UHAIAw5yQ6olP9JxInJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyuUH5uZuZcPgRHmyjAjWChBuxNxz+Nu7x24uH4sFi1/P2lpm5L0qkzJYdwHSu/k2
         AG+v69wgMmAkStvQBLd0jxMC8srJiJgK3yFT09CPDyrsvgYe/mMREb5m4Ns4Tt9QxN
         9nPDR8BGU+t02s2Rzk0bO5ddI8M1FSQwqlElA8QA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Schiller <ms@dev.tdt.de>, Pavel Machek <pavel@ucw.cz>,
        Sasha Levin <sashal@kernel.org>, linux-leds@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 034/134] leds: trigger: netdev: fix handling on interface rename
Date:   Wed, 11 Dec 2019 10:10:10 -0500
Message-Id: <20191211151150.19073-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Schiller <ms@dev.tdt.de>

[ Upstream commit 5f820ed52371b4f5d8c43c93f03408d0dbc01e5b ]

The NETDEV_CHANGENAME code is not "unneeded" like it is stated in commit
4cb6560514fa ("leds: trigger: netdev: fix refcnt leak on interface
rename").

The event was accidentally misinterpreted equivalent to
NETDEV_UNREGISTER, but should be equivalent to NETDEV_REGISTER.

This was the case in the original code from the openwrt project.

Otherwise, you are unable to set netdev led triggers for (non-existent)
netdevices, which has to be renamed. This is the case, for example, for
ppp interfaces in openwrt.

Fixes: 06f502f57d0d ("leds: trigger: Introduce a NETDEV trigger")
Fixes: 4cb6560514fa ("leds: trigger: netdev: fix refcnt leak on interface rename")
Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/trigger/ledtrig-netdev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 136f86a1627d1..d5e774d830215 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -302,10 +302,12 @@ static int netdev_trig_notify(struct notifier_block *nb,
 		container_of(nb, struct led_netdev_data, notifier);
 
 	if (evt != NETDEV_UP && evt != NETDEV_DOWN && evt != NETDEV_CHANGE
-	    && evt != NETDEV_REGISTER && evt != NETDEV_UNREGISTER)
+	    && evt != NETDEV_REGISTER && evt != NETDEV_UNREGISTER
+	    && evt != NETDEV_CHANGENAME)
 		return NOTIFY_DONE;
 
 	if (!(dev == trigger_data->net_dev ||
+	      (evt == NETDEV_CHANGENAME && !strcmp(dev->name, trigger_data->device_name)) ||
 	      (evt == NETDEV_REGISTER && !strcmp(dev->name, trigger_data->device_name))))
 		return NOTIFY_DONE;
 
@@ -315,6 +317,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
 
 	clear_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
 	switch (evt) {
+	case NETDEV_CHANGENAME:
 	case NETDEV_REGISTER:
 		if (trigger_data->net_dev)
 			dev_put(trigger_data->net_dev);
-- 
2.20.1

