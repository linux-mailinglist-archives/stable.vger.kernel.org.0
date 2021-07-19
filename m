Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77A03CDFCA
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345515AbhGSPLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:11:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344771AbhGSPJJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:09:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D192561363;
        Mon, 19 Jul 2021 15:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709722;
        bh=Qd4pgqR1OCa6+4dBwCo8x/QTkWz6rgYkwjTbcm0aT6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CeBdp5yrV0RLtMUgGZV5LYB1/LvI+W1aMB43fNAf5w7cc6M6lPBMQhkK1C2//3MrF
         TdBhH7Nalw+eCHI97NOR9c3qzcsQShZY4wvTL8FybMa6KQzq3cIr2kTSxFtKeNb/VF
         TzWTWlYNA+Rz+2tWSaFdxM3UxZra0VZHEOQm72rU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/149] power: supply: ab8500: Avoid NULL pointers
Date:   Mon, 19 Jul 2021 16:53:00 +0200
Message-Id: <20210719144918.361678422@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
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
 drivers/power/supply/ab8500_charger.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index e51d0e72beea..90dbf3760e83 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -407,6 +407,14 @@ disable_otp:
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
@@ -433,7 +441,15 @@ static void ab8500_charger_set_usb_connected(struct ab8500_charger *di,
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



