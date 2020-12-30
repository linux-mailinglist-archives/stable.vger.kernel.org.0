Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8DA2E78EB
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgL3NEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:04:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbgL3NEX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:04:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC3B02242A;
        Wed, 30 Dec 2020 13:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333417;
        bh=TYS9CyxV609M0wdg5tRs0/P/rV4X+CfCd2orivUlb5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m25d6LVtF9i+6WuO0wbyZo9bRtII8CkWVlvQxDjn36qfBQ9HIMNaabN4o5z4n5mDO
         40DpdX21wqbHJzEfww8uJs4FLgsz4lrfPCYXAUB+AgWjK8GzE56Uefj0YDWiFj+Dgz
         XXpBoXA2imwiCOkD7aA/CIq7cDaTnPgyN2J9ntCfhTZOhxcJ3/nLFQSPtZoblX5SsE
         B1nZF/pnjqA8TJKqcy9dyE2ShiAsT9DsiyX1G3lBF7FzbH5v76NDmRvBvGJlR6wSd4
         q+kwj2I/XwiltL87R2C69lKS1yJORbpDTc745fZ9c2+G/W+SdqE+bWnHXpgaSW/RKe
         LMoB3CD5DVWlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 17/31] watchdog: rti-wdt: fix reference leak in rti_wdt_probe
Date:   Wed, 30 Dec 2020 08:02:59 -0500
Message-Id: <20201230130314.3636961-17-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130314.3636961-1-sashal@kernel.org>
References: <20201230130314.3636961-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 8711071e9700b67045fe5518161d63f7a03e3c9e ]

pm_runtime_get_sync() will increment pm usage counter even it
failed. Forgetting to call pm_runtime_put_noidle will result
in reference leak in rti_wdt_probe, so we should fix it.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20201030154909.100023-1-zhangqilong3@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rti_wdt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/rti_wdt.c b/drivers/watchdog/rti_wdt.c
index 836319cbaca9d..359302f71f7ef 100644
--- a/drivers/watchdog/rti_wdt.c
+++ b/drivers/watchdog/rti_wdt.c
@@ -227,8 +227,10 @@ static int rti_wdt_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 	ret = pm_runtime_get_sync(dev);
-	if (ret)
+	if (ret) {
+		pm_runtime_put_noidle(dev);
 		return dev_err_probe(dev, ret, "runtime pm failed\n");
+	}
 
 	platform_set_drvdata(pdev, wdt);
 
-- 
2.27.0

