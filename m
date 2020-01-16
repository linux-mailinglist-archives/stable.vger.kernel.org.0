Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F20D13F71C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387898AbgAPRAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:00:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387888AbgAPRAq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A988F2077B;
        Thu, 16 Jan 2020 17:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194045;
        bh=9CmACRvCZ9RqL8YToPIX7SMPU7HhhkHZU9u2iIPl+8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxfPwdKoJGwtVdu/MoBLYjSiFqkPmatBNsb0vDEa7K4ya7cwgFw6RiQwH5ROej28Z
         uLOGenRcwn62c2Lx4A3LEv3aE6LLhYs9cmc3zZHseyocoieGTHHjrsGcvpJIeDZJ/o
         fqcj4ARsYhj2fqSKj3gw2D6CPWj5+Kub7aI5XksA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 161/671] rtc: ds1307: rx8130: Fix alarm handling
Date:   Thu, 16 Jan 2020 11:51:10 -0500
Message-Id: <20200116165940.10720-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 3f929cad943380370b6db31fcb7a38d898d91089 ]

When the EXTENSION.WADA bit is set, register 0x19 contains a bitmap of
week days, not a day of month. As Linux only handles a single alarm
without repetition using day of month is more flexible, so clear this
bit. (Otherwise a value depending on time.tm_wday would have to be
written to register 0x19.)

Also optimize setting the AIE bit to use a single register write instead
of a bulk write of three registers.

Fixes: ee0981be7704 ("rtc: ds1307: Add support for Epson RX8130CE")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1307.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 71396b62dc52..ebd59e86a567 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -749,8 +749,8 @@ static int rx8130_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	if (ret < 0)
 		return ret;
 
-	ctl[0] &= ~RX8130_REG_EXTENSION_WADA;
-	ctl[1] |= RX8130_REG_FLAG_AF;
+	ctl[0] &= RX8130_REG_EXTENSION_WADA;
+	ctl[1] &= ~RX8130_REG_FLAG_AF;
 	ctl[2] &= ~RX8130_REG_CONTROL0_AIE;
 
 	ret = regmap_bulk_write(ds1307->regmap, RX8130_REG_EXTENSION, ctl,
@@ -773,8 +773,7 @@ static int rx8130_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 
 	ctl[2] |= RX8130_REG_CONTROL0_AIE;
 
-	return regmap_bulk_write(ds1307->regmap, RX8130_REG_EXTENSION, ctl,
-				 sizeof(ctl));
+	return regmap_write(ds1307->regmap, RX8130_REG_CONTROL0, ctl[2]);
 }
 
 static int rx8130_alarm_irq_enable(struct device *dev, unsigned int enabled)
-- 
2.20.1

