Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41176147C30
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730108AbgAXJto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:49:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:50140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387874AbgAXJtk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:49:40 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C5D820718;
        Fri, 24 Jan 2020 09:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859379;
        bh=t8K6NMEkiDZjSYdCxvSmkf6v/GWXQR8W2bpkmwogeM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPLF74axAsf3SPyiEV+Crf8Q362jIUzk0eEMx2VWp3bYUkwV6EUNBq/lEzmRDUFJU
         /N023c+NIMM88fX6vRnjBDaH6hCOSF9/KG+K4RN6k6NHXJQwQoG0q/t1NkVYk5G8Pv
         FwSnWbJFuZyWkQ/IGHQXRNt97Gl+aO4EBvguXtZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 092/343] rtc: ds1307: rx8130: Fix alarm handling
Date:   Fri, 24 Jan 2020 10:28:30 +0100
Message-Id: <20200124092932.158904990@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e7d9215c9201b..8d45d93b1db67 100644
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



