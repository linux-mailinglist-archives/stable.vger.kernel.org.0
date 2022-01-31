Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6281E4A4402
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359723AbiAaLZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:25:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39350 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377748AbiAaLXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:23:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C4F9B82A5C;
        Mon, 31 Jan 2022 11:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD255C340E8;
        Mon, 31 Jan 2022 11:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628199;
        bh=6KaW5Y5nA33xZyeLXiMYIERa4OTwAfNGh5VGj+IhCh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUHUKN8RZ3FRX2TykURsxIUSkmn+0tjEM+RgTNaV8blSy1gtLiAF+W1UmkSNoB6xc
         kHHAIT8+7BG8alKe//J3iudfXehZ135KnHH2YksMv2/FvCDDrW7e7rUJHFZbRD1+Re
         bcxvMyPq+mJOazQ5sDYan1SeGk7Ziy7YbyWcI2DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 156/200] hwmon: (lm90) Re-enable interrupts after alert clears
Date:   Mon, 31 Jan 2022 11:56:59 +0100
Message-Id: <20220131105238.810582340@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
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



