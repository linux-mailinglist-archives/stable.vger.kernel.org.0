Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF1AF12C7E1
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731323AbfL2Rrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:47:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:58680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731335AbfL2Rrs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:47:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 743F8206A4;
        Sun, 29 Dec 2019 17:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641667;
        bh=V3ZgLUd1FEmKt3QjPw6TkCxgYEvtXhnglxoa+c6O49I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0XMgAC9XHifIQRjonz9da/muerdv7sAnBc2Aqbbpk27OPJ1eyYNPNyRCfJQiI0bR1
         e2Zd4VWcHkqyh8YMYM610UUpcYuKXynBmlGVyM+jzYkNbFYPxmHaeInYwXLGYlDK4v
         U8TP70kxPSzDlMnG/aYte+fQB0fhzNDfkn8wU33U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Merlijn Wajer <merlijn@wizzup.org>,
        Pavel Machek <pavel@ucw.cz>, Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 162/434] power: supply: cpcap-battery: Check voltage before orderly_poweroff
Date:   Sun, 29 Dec 2019 18:23:35 +0100
Message-Id: <20191229172712.537510975@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 61d6447d1966..00a96e4a1cdc 100644
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



