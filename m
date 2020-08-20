Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18D624BD57
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgHTND4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:03:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728848AbgHTJjg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:39:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AE4B20724;
        Thu, 20 Aug 2020 09:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916375;
        bh=vKgxG8WeJeP6CWDsoICmWqROrUHc7Mxhq5QDNjEq+kM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+CDYsuQorpVRwDsfsu3STreOzI7xfnp7jD2DBYMR5a0rZEMYylL5Ke7ACMpvJjJg
         23a2vjwDa0GhpK6KF1e9HKgLp6e9aPOwB05kl9nz04O+WZdVCEUwhVlERvnA0+7VNW
         rVUZjMpcEphhBczotFd38WbyoNawedBDapdjERm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Sicelo A. Mhlongo" <absicsz@gmail.com>,
        Dev Null <devnull@uvos.xyz>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 107/204] rtc: cpcap: fix range
Date:   Thu, 20 Aug 2020 11:20:04 +0200
Message-Id: <20200820091611.669353859@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 3180cfabf6fbf982ca6d1a6eb56334647cc1416b ]

Unbreak CPCAP driver, which has one more bit in the day counter
increasing the max. range from 2014 to 2058. The original commit
introducing the range limit was obviously wrong, since the driver
has only been written in 2017 (3 years after 14 bits would have
run out).

Fixes: d2377f8cc5a7 ("rtc: cpcap: set range")
Reported-by: Sicelo A. Mhlongo <absicsz@gmail.com>
Reported-by: Dev Null <devnull@uvos.xyz>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Tested-by: Merlijn Wajer <merlijn@wizzup.org>
Acked-by: Tony Lindgren <tony@atomide.com>
Acked-by: Merlijn Wajer <merlijn@wizzup.org>
Link: https://lore.kernel.org/r/20200629114123.27956-1-sebastian.reichel@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cpcap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-cpcap.c b/drivers/rtc/rtc-cpcap.c
index a603f1f211250..800667d73a6fb 100644
--- a/drivers/rtc/rtc-cpcap.c
+++ b/drivers/rtc/rtc-cpcap.c
@@ -261,7 +261,7 @@ static int cpcap_rtc_probe(struct platform_device *pdev)
 		return PTR_ERR(rtc->rtc_dev);
 
 	rtc->rtc_dev->ops = &cpcap_rtc_ops;
-	rtc->rtc_dev->range_max = (1 << 14) * SECS_PER_DAY - 1;
+	rtc->rtc_dev->range_max = (timeu64_t) (DAY_MASK + 1) * SECS_PER_DAY - 1;
 
 	err = cpcap_get_vendor(dev, rtc->regmap, &rtc->vendor);
 	if (err)
-- 
2.25.1



