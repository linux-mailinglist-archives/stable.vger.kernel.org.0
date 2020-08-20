Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B982C24AB90
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgHTACF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbgHTACD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 20:02:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61070207FB;
        Thu, 20 Aug 2020 00:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881723;
        bh=2OGik1si2CQz73pb1R1EN1XL5l9NZWL7GYoRLCxjPrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0jd1aZ3ABMFlW1eOThTfdZhxvfRCQauZTIGAx4Y1SjgdW/YQKd00iYBZ0xvsdjZ+
         LEy0GVp1dpV39+yaDGfCjBmvCVYBFIhoVw53TEnERBwHZPF3djENWKQxN7zumuC9Xl
         FIG7Ro4BoWNvKEO9DNASCT4PjJhNN2B9jgKBlM/I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huacai Chen <chenhc@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 05/24] rtc: goldfish: Enable interrupt in set_alarm() when necessary
Date:   Wed, 19 Aug 2020 20:01:36 -0400
Message-Id: <20200820000155.215089-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820000155.215089-1-sashal@kernel.org>
References: <20200820000155.215089-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

[ Upstream commit 22f8d5a1bf230cf8567a4121fc3789babb46336d ]

When use goldfish rtc, the "hwclock" command fails with "select() to
/dev/rtc to wait for clock tick timed out". This is because "hwclock"
need the set_alarm() hook to enable interrupt when alrm->enabled is
true. This operation is missing in goldfish rtc (but other rtc drivers,
such as cmos rtc, enable interrupt here), so add it.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/1592654683-31314-1-git-send-email-chenhc@lemote.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-goldfish.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-goldfish.c b/drivers/rtc/rtc-goldfish.c
index cb6b0ad7ec3f2..5dd92147f1680 100644
--- a/drivers/rtc/rtc-goldfish.c
+++ b/drivers/rtc/rtc-goldfish.c
@@ -73,6 +73,7 @@ static int goldfish_rtc_set_alarm(struct device *dev,
 		rtc_alarm64 = rtc_tm_to_time64(&alrm->time) * NSEC_PER_SEC;
 		writel((rtc_alarm64 >> 32), base + TIMER_ALARM_HIGH);
 		writel(rtc_alarm64, base + TIMER_ALARM_LOW);
+		writel(1, base + TIMER_IRQ_ENABLED);
 	} else {
 		/*
 		 * if this function was called with enabled=0
-- 
2.25.1

