Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6099227174
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgGTVnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728127AbgGTViZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:38:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6571F22BF5;
        Mon, 20 Jul 2020 21:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281105;
        bh=qR3qR1P8zCZPBL7I5aiHn7cQAkCbUrhl/7b8QvE1Xlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06pGCm0S+Wk9MiJqHe5yAkTkfAHaJnSiH7O9QffxxiWweve3xIU3s4TiyxnvreRty
         WZreNzxTJW23CUEQv3EqrC4plXq1sOARTvzwma96L28CXq4+2TQuhBgXpUWW3tMDif
         b3hJSk58cIgzxXg6HfqMxRyMPxoSizsN7qQfPuxo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Derek Basehore <dbasehore@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 14/34] Input: elan_i2c - only increment wakeup count on touch
Date:   Mon, 20 Jul 2020 17:37:47 -0400
Message-Id: <20200720213807.407380-14-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213807.407380-1-sashal@kernel.org>
References: <20200720213807.407380-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Derek Basehore <dbasehore@chromium.org>

[ Upstream commit 966334dfc472bdfa67bed864842943b19755d192 ]

This moves the wakeup increment for elan devices to the touch report.
This prevents the drivers from incorrectly reporting a wakeup when the
resume callback resets then device, which causes an interrupt to
occur.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Link: https://lore.kernel.org/r/20200706235046.1984283-1-dbasehore@chromium.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/elan_i2c_core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/input/mouse/elan_i2c_core.c b/drivers/input/mouse/elan_i2c_core.c
index 8719da5403834..196e8505dd8d7 100644
--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -951,6 +951,8 @@ static void elan_report_absolute(struct elan_tp_data *data, u8 *packet)
 	u8 hover_info = packet[ETP_HOVER_INFO_OFFSET];
 	bool contact_valid, hover_event;
 
+	pm_wakeup_event(&data->client->dev, 0);
+
 	hover_event = hover_info & 0x40;
 	for (i = 0; i < ETP_MAX_FINGERS; i++) {
 		contact_valid = tp_info & (1U << (3 + i));
@@ -974,6 +976,8 @@ static void elan_report_trackpoint(struct elan_tp_data *data, u8 *report)
 	u8 *packet = &report[ETP_REPORT_ID_OFFSET + 1];
 	int x, y;
 
+	pm_wakeup_event(&data->client->dev, 0);
+
 	if (!data->tp_input) {
 		dev_warn_once(&data->client->dev,
 			      "received a trackpoint report while no trackpoint device has been created. Please report upstream.\n");
@@ -998,7 +1002,6 @@ static void elan_report_trackpoint(struct elan_tp_data *data, u8 *report)
 static irqreturn_t elan_isr(int irq, void *dev_id)
 {
 	struct elan_tp_data *data = dev_id;
-	struct device *dev = &data->client->dev;
 	int error;
 	u8 report[ETP_MAX_REPORT_LEN];
 
@@ -1016,8 +1019,6 @@ static irqreturn_t elan_isr(int irq, void *dev_id)
 	if (error)
 		goto out;
 
-	pm_wakeup_event(dev, 0);
-
 	switch (report[ETP_REPORT_ID_OFFSET]) {
 	case ETP_REPORT_ID:
 		elan_report_absolute(data, report);
@@ -1026,7 +1027,7 @@ static irqreturn_t elan_isr(int irq, void *dev_id)
 		elan_report_trackpoint(data, report);
 		break;
 	default:
-		dev_err(dev, "invalid report id data (%x)\n",
+		dev_err(&data->client->dev, "invalid report id data (%x)\n",
 			report[ETP_REPORT_ID_OFFSET]);
 	}
 
-- 
2.25.1

