Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477954A4429
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346037AbiAaL1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350380AbiAaLYy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:24:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3ABC08E90D;
        Mon, 31 Jan 2022 03:15:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DCAEB82A76;
        Mon, 31 Jan 2022 11:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD92C340E8;
        Mon, 31 Jan 2022 11:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627719;
        bh=6KaW5Y5nA33xZyeLXiMYIERa4OTwAfNGh5VGj+IhCh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2hU0I6uLWLpaqXRk0tfG0DwbjAmUm+ldsR1rW1L2fd18gb0Q4ZTsdWG5MSiIVRqs
         7qQpAtTzt3qNQOAlk0Dn2aFhyapNLiyyTlDpC9vKC1m2n+s1L1dcl6uNY1bEPyp1Vo
         3OPY5wUoLStyutdK/BXwy99f+6LqGUaQfyof6AGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/171] hwmon: (lm90) Re-enable interrupts after alert clears
Date:   Mon, 31 Jan 2022 11:56:37 +0100
Message-Id: <20220131105234.476637088@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit bc341a1a98827925082e95db174734fc8bd68af6 ]

If alert handling is broken, interrupts are disabled after an alert and
re-enabled after the alert clears. However, if there is an interrupt
handler, this does not apply if alerts were originally disabled and enabled
when the driver was loaded. In that case, interrupts will stay disabled
after an alert was handled though the alert handler even after the alert
condition clears. Address the situation by always re-enabling interrupts
after the alert condition clears if there is an interrupt handler.

Fixes: 2abdc357c55d9 ("hwmon: (lm90) Unmask hardware interrupt")
Cc: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm90.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index cc5e48fe304b1..e4ecf3440d7cf 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -848,7 +848,7 @@ static int lm90_update_device(struct device *dev)
 		 * Re-enable ALERT# output if it was originally enabled and
 		 * relevant alarms are all clear
 		 */
-		if (!(data->config_orig & 0x80) &&
+		if ((client->irq || !(data->config_orig & 0x80)) &&
 		    !(data->alarms & data->alert_alarms)) {
 			if (data->config & 0x80) {
 				dev_dbg(&client->dev, "Re-enabling ALERT#\n");
-- 
2.34.1



