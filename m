Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A2624B328
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgHTJmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729132AbgHTJl6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:41:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14776207DE;
        Thu, 20 Aug 2020 09:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916517;
        bh=nibtvUdmYlYfzAmksvOuc+YpD990OolnyT4nsyqRArQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwR1SFkRB9OoJm6k78RspePjp+zc0QfgYoLMfXKwG1SzaCciGkx2HDbnI0Evu6uQt
         JTAcbx1S0wrFv9DZwJVm5HpbCXTPmgYaQlkLvwKSnJLAjkAuPYzFjt0UFIvXb5msiH
         y+4/VijYw2+7ubBkr+VBNc/6G0yUFpMfURbJAY3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 126/204] rtc: pl031: fix set_alarm by adding back call to alarm_irq_enable
Date:   Thu, 20 Aug 2020 11:20:23 +0200
Message-Id: <20200820091612.583800658@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 4df2ef85f0efe44505f511ca5e4455585f53a2da ]

Commit c8ff5841a90b ("rtc: pl031: switch to rtc_time64_to_tm/rtc_tm_to_time64")
seemed to have accidentally removed the call to pl031_alarm_irq_enable
from pl031_set_alarm while switching to 64-bit apis.

Let us add back the same to get the set alarm functionality back.

Fixes: c8ff5841a90b ("rtc: pl031: switch to rtc_time64_to_tm/rtc_tm_to_time64")
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Tested-by: Valentin Schneider <valentin.schneider@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20200714124556.20294-1-sudeep.holla@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pl031.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index 40d7450a1ce49..c6b89273feba8 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -275,6 +275,7 @@ static int pl031_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	struct pl031_local *ldata = dev_get_drvdata(dev);
 
 	writel(rtc_tm_to_time64(&alarm->time), ldata->base + RTC_MR);
+	pl031_alarm_irq_enable(dev, alarm->enabled);
 
 	return 0;
 }
-- 
2.25.1



