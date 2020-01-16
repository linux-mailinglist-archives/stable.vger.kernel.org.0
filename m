Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBAA13F240
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgAPSeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:34:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391801AbgAPRYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:24:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7A6424683;
        Thu, 16 Jan 2020 17:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195480;
        bh=IpNxx3W+VnjKXEjn7C67RV765J6IboVPFp1m1VokPGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ZSWEv2zHNtc4RDs+BprQ++zDbSO+wSarwYyWaRF6kLZSnizCuPrn6Tsv5rC1+UlH
         06Pt8b4mhunpJLNPi5nJBEB8hnMeTu2BVoxdhAiLKDFtvhUt9U8PmYrnShWPibgxzq
         Ln+Gbn893B+QVRjqeXYjcrdGm6Tow4DuNoBK4YI8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 085/371] rtc: ds1307: rx8130: Fix alarm handling
Date:   Thu, 16 Jan 2020 12:19:17 -0500
Message-Id: <20200116172403.18149-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
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
index e7d9215c9201..8d45d93b1db6 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -733,8 +733,8 @@ static int rx8130_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	if (ret < 0)
 		return ret;
 
-	ctl[0] &= ~RX8130_REG_EXTENSION_WADA;
-	ctl[1] |= RX8130_REG_FLAG_AF;
+	ctl[0] &= RX8130_REG_EXTENSION_WADA;
+	ctl[1] &= ~RX8130_REG_FLAG_AF;
 	ctl[2] &= ~RX8130_REG_CONTROL0_AIE;
 
 	ret = regmap_bulk_write(ds1307->regmap, RX8130_REG_EXTENSION, ctl,
@@ -757,8 +757,7 @@ static int rx8130_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 
 	ctl[2] |= RX8130_REG_CONTROL0_AIE;
 
-	return regmap_bulk_write(ds1307->regmap, RX8130_REG_EXTENSION, ctl,
-				 sizeof(ctl));
+	return regmap_write(ds1307->regmap, RX8130_REG_CONTROL0, ctl[2]);
 }
 
 static int rx8130_alarm_irq_enable(struct device *dev, unsigned int enabled)
-- 
2.20.1

