Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECDEA13F490
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389254AbgAPSuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:50:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:43864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389551AbgAPRI7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04B0421D56;
        Thu, 16 Jan 2020 17:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194538;
        bh=OI/m1Gx2TY/Qme7Qza/LH9tOD5k0vJmo+OSFylDlFdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dOTzAaYAs3JeVxcLbL5Y7I4eqnY6PCMFxVhEMeulwpSjnSdq1uRvSpjaDeVowsDzn
         oQhEN+Iyhan9QvtGAgLLWByX+qjLvudSNQj16/NnWQ6K6eCXb86DQ/V+BqaUZr6Ff8
         /iVaHfyCNyG2JWIbMocUXVWCT/NkF/YIqGb8NAYo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen-Yu Tsai <wens@csie.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 425/671] rtc: pcf8563: Fix interrupt trigger method
Date:   Thu, 16 Jan 2020 12:01:03 -0500
Message-Id: <20200116170509.12787-162-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 65f662cbf829834fa4d94190eb7691e5a9cb92d8 ]

The PCF8563 datasheet says the interrupt line is active low and stays
active until the events are cleared, i.e. a level trigger interrupt.

Fix the flags used to request the interrupt.

Fixes: ede3e9d47cca ("drivers/rtc/rtc-pcf8563.c: add alarm support")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf8563.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 3efc86c25d27..e358313466f1 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -605,7 +605,7 @@ static int pcf8563_probe(struct i2c_client *client,
 	if (client->irq > 0) {
 		err = devm_request_threaded_irq(&client->dev, client->irq,
 				NULL, pcf8563_irq,
-				IRQF_SHARED|IRQF_ONESHOT|IRQF_TRIGGER_FALLING,
+				IRQF_SHARED | IRQF_ONESHOT | IRQF_TRIGGER_LOW,
 				pcf8563_driver.driver.name, client);
 		if (err) {
 			dev_err(&client->dev, "unable to request IRQ %d\n",
-- 
2.20.1

