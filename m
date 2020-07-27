Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597D622F237
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbgG0OiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:38:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729961AbgG0OLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:11:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD908208E4;
        Mon, 27 Jul 2020 14:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859068;
        bh=ck+t5BO0KC/lWu1r0TlgaUuIVf2Zmt5Tke3WUWETRiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VLRxcWRrz3OsczqasZc1JVi7GbPopHdApez9hPOCPGkXJBALmeEPCpKkGOAUO78C/
         LSwcmAz24qiZ1VxZ+SLi9lBaZ990jZli5c0VIARa8wa6mRM8UJy2G1ajWxbWLrjPOP
         xPy/UOW7zYK/bi/BQIhTJnDCR7mN8ZBNsiWIErQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Derek Basehore <dbasehore@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 54/86] Input: elan_i2c - only increment wakeup count on touch
Date:   Mon, 27 Jul 2020 16:04:28 +0200
Message-Id: <20200727134917.124943291@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/input/mouse/elan_i2c_core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/elan_i2c_core.c b/drivers/input/mouse/elan_i2c_core.c
index ae012639ae1d5..82afaca2e1a67 100644
--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -917,6 +917,8 @@ static void elan_report_absolute(struct elan_tp_data *data, u8 *packet)
 	u8 hover_info = packet[ETP_HOVER_INFO_OFFSET];
 	bool contact_valid, hover_event;
 
+	pm_wakeup_event(&data->client->dev, 0);
+
 	hover_event = hover_info & 0x40;
 	for (i = 0; i < ETP_MAX_FINGERS; i++) {
 		contact_valid = tp_info & (1U << (3 + i));
@@ -939,6 +941,8 @@ static void elan_report_trackpoint(struct elan_tp_data *data, u8 *report)
 	u8 *packet = &report[ETP_REPORT_ID_OFFSET + 1];
 	int x, y;
 
+	pm_wakeup_event(&data->client->dev, 0);
+
 	if (!data->tp_input) {
 		dev_warn_once(&data->client->dev,
 			      "received a trackpoint report while no trackpoint device has been created. Please report upstream.\n");
@@ -963,7 +967,6 @@ static void elan_report_trackpoint(struct elan_tp_data *data, u8 *report)
 static irqreturn_t elan_isr(int irq, void *dev_id)
 {
 	struct elan_tp_data *data = dev_id;
-	struct device *dev = &data->client->dev;
 	int error;
 	u8 report[ETP_MAX_REPORT_LEN];
 
@@ -989,7 +992,7 @@ static irqreturn_t elan_isr(int irq, void *dev_id)
 		elan_report_trackpoint(data, report);
 		break;
 	default:
-		dev_err(dev, "invalid report id data (%x)\n",
+		dev_err(&data->client->dev, "invalid report id data (%x)\n",
 			report[ETP_REPORT_ID_OFFSET]);
 	}
 
-- 
2.25.1



