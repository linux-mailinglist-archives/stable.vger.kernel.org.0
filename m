Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5503CD8B2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242607AbhGSOZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243144AbhGSOW0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:22:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AC7061245;
        Mon, 19 Jul 2021 15:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706955;
        bh=Sh3k0haP4j3m4OI1KzmGOpnxvyieK4bU3KKRJYtp9Sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7FlFHaoXEY2OT4OxJXvOrB2rYWPIg02lJR9oOMDwqxv0A3lEH7wbKeP1Sd6EPT81
         kzaL1kz0O7UKcpZ7z/Iy49mToSizx1k2L1TPwT/ujTNMTOkDednANAAL13hj2bSgpM
         juI55+yw3hLsnUIS7WOteo3rMF97yWY7z7Sx/3o0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 165/188] power: supply: ab8500: Avoid NULL pointers
Date:   Mon, 19 Jul 2021 16:52:29 +0200
Message-Id: <20210719144941.894489969@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 5bcb5087c9dd3dca1ff0ebd8002c5313c9332b56 ]

Sometimes the code will crash because we haven't enabled
AC or USB charging and thus not created the corresponding
psy device. Fix it by checking that it is there before
notifying.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/ab8500_charger.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index e388171f4e58..98724c3a28e5 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -409,6 +409,14 @@ disable_otp:
 static void ab8500_power_supply_changed(struct ab8500_charger *di,
 					struct power_supply *psy)
 {
+	/*
+	 * This happens if we get notifications or interrupts and
+	 * the platform has been configured not to support one or
+	 * other type of charging.
+	 */
+	if (!psy)
+		return;
+
 	if (di->autopower_cfg) {
 		if (!di->usb.charger_connected &&
 		    !di->ac.charger_connected &&
@@ -435,7 +443,15 @@ static void ab8500_charger_set_usb_connected(struct ab8500_charger *di,
 		if (!connected)
 			di->flags.vbus_drop_end = false;
 
-		sysfs_notify(&di->usb_chg.psy->dev.kobj, NULL, "present");
+		/*
+		 * Sometimes the platform is configured not to support
+		 * USB charging and no psy has been created, but we still
+		 * will get these notifications.
+		 */
+		if (di->usb_chg.psy) {
+			sysfs_notify(&di->usb_chg.psy->dev.kobj, NULL,
+				     "present");
+		}
 
 		if (connected) {
 			mutex_lock(&di->charger_attached_mutex);
-- 
2.30.2



