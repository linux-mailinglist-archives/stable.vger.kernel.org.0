Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A4D3C375C
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhGJXv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:51:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231609AbhGJXvy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:51:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF8436135E;
        Sat, 10 Jul 2021 23:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625960948;
        bh=zBmnUkv3H49TxzHDaQnu/UzpaRVAJ0fO4BYykpPzPFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKO4EOjed6Cie7IXvjwM9KQDgcW3AZP09yh81B3C3S/QALoYA9cDOmaHUTz7PSEEF
         2IeqHtUnwNWDryQCoxlYBhyZNHfmkeMGj+tsPKL14wQL9GJBybDvNpVi5Y/Nq6YYqT
         4DdXmrK+M3K1JLYTG5eqN0vtjxUvr06zpL9z0LM8NoZS96KFyigSmukc0S2l+j5cko
         tXHlLCDMEJmxTZSMA/THLts/AxM8mNDkp7DR31xfJAki/8CG6kqYx802gQ/CY6KJ7q
         YDHVZqISMhmqJKiF/eMFbWwP6wzh36pQbSzJa6jVSbcDOfnjuENK99l09sMfEleQML
         wCPos5Dn3eGxA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 07/53] power: supply: ab8500: Avoid NULL pointers
Date:   Sat, 10 Jul 2021 19:48:11 -0400
Message-Id: <20210710234857.3220040-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710234857.3220040-1-sashal@kernel.org>
References: <20210710234857.3220040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index af32cfae9f19..57fbfe3d8c03 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -415,6 +415,14 @@ static void ab8500_enable_disable_sw_fallback(struct ab8500_charger *di,
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
@@ -441,7 +449,15 @@ static void ab8500_charger_set_usb_connected(struct ab8500_charger *di,
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

