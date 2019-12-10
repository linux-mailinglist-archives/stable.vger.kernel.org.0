Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D5111971C
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbfLJVJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:09:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727075AbfLJVJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E43A246B6;
        Tue, 10 Dec 2019 21:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012171;
        bh=ZkQNR1TZKmTtQmGs/IMX1SC2ZreDZnDVq2Ta/ZZTK8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4xCL4TiTIpvs4gkvK5qWXoIMYF7IAO2RsNHv+LR8wvTfVMSd8pEo2QlIaPJLBedk
         5Zlo8L1woZYpxL4fsgZTpd3FTK1TyGSsEaKBS6cg0+xSEDxAHByqVmtLAMkFjK57NF
         cNMor3WHzt3yqoQ559Q+owcfLv6pcihKZ8p4EvGk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 130/350] power: supply: cpcap-battery: Check voltage before orderly_poweroff
Date:   Tue, 10 Dec 2019 16:03:55 -0500
Message-Id: <20191210210735.9077-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 639c1524da3b273d20c42ff2387d08eb4b12e903 ]

We can get the low voltage interrupt trigger sometimes way too early,
maybe because of CPU load spikes. This causes orderly_poweroff() be
called too easily.

Let's check the voltage before orderly_poweroff in case it was not
yet a permanent condition. We will be getting more interrupts anyways
if the condition persists.

Let's also show the measured voltages for low battery and battery
empty warnings since we have them.

Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cpcap-battery.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/cpcap-battery.c b/drivers/power/supply/cpcap-battery.c
index 61d6447d1966f..00a96e4a1cdc3 100644
--- a/drivers/power/supply/cpcap-battery.c
+++ b/drivers/power/supply/cpcap-battery.c
@@ -562,12 +562,14 @@ static irqreturn_t cpcap_battery_irq_thread(int irq, void *data)
 	switch (d->action) {
 	case CPCAP_BATTERY_IRQ_ACTION_BATTERY_LOW:
 		if (latest->current_ua >= 0)
-			dev_warn(ddata->dev, "Battery low at 3.3V!\n");
+			dev_warn(ddata->dev, "Battery low at %imV!\n",
+				latest->voltage / 1000);
 		break;
 	case CPCAP_BATTERY_IRQ_ACTION_POWEROFF:
-		if (latest->current_ua >= 0) {
+		if (latest->current_ua >= 0 && latest->voltage <= 3200000) {
 			dev_emerg(ddata->dev,
-				  "Battery empty at 3.1V, powering off\n");
+				  "Battery empty at %imV, powering off\n",
+				  latest->voltage / 1000);
 			orderly_poweroff(true);
 		}
 		break;
-- 
2.20.1

