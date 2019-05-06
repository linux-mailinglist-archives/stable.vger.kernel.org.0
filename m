Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE86E14E44
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbfEFOlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728126AbfEFOk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:40:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ED282087F;
        Mon,  6 May 2019 14:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153659;
        bh=PP62qLmgfDJlZIPrBq8eayt1MJXDMqv4avsrry8kdIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=db+J6ys5FQf76tdqSuCKrhwodspuMi08k2WVt4yKV9N6GWgtImFGnYCD/WCnAmGnB
         o2SI9igzBaWhmqHQ0lsMCrONn1AspM3Za2C06XhqZXprIz2ntCRcrrLMkP3tlJ4WOc
         s0Fi2qREnPDf/rxatb6FYMByhQxUoHA1M6Yiqn5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Steve Twiss <stwiss.opensource@diasemi.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 48/99] rtc: da9063: set uie_unsupported when relevant
Date:   Mon,  6 May 2019 16:32:21 +0200
Message-Id: <20190506143058.410177007@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 882c5e552ffd06856de42261460f46e18319d259 ]

The DA9063AD doesn't support alarms on any seconds and its granularity is
the minute. Set uie_unsupported in that case.

Reported-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Acked-by: Steve Twiss <stwiss.opensource@diasemi.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-da9063.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/rtc/rtc-da9063.c b/drivers/rtc/rtc-da9063.c
index b4e054c64bad..69b54e5556c0 100644
--- a/drivers/rtc/rtc-da9063.c
+++ b/drivers/rtc/rtc-da9063.c
@@ -480,6 +480,13 @@ static int da9063_rtc_probe(struct platform_device *pdev)
 	da9063_data_to_tm(data, &rtc->alarm_time, rtc);
 	rtc->rtc_sync = false;
 
+	/*
+	 * TODO: some models have alarms on a minute boundary but still support
+	 * real hardware interrupts. Add this once the core supports it.
+	 */
+	if (config->rtc_data_start != RTC_SEC)
+		rtc->rtc_dev->uie_unsupported = 1;
+
 	irq_alarm = platform_get_irq_byname(pdev, "ALARM");
 	ret = devm_request_threaded_irq(&pdev->dev, irq_alarm, NULL,
 					da9063_alarm_event,
-- 
2.20.1



