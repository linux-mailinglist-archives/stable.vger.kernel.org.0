Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64583CE2B2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238336AbhGSPbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347569AbhGSPTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:19:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C959560200;
        Mon, 19 Jul 2021 15:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710309;
        bh=K6sT0z5Ze+D+76RPWYHyQ8VyASl+PDH7AZMuq3ukA9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QqvKIMuFS045Jz1ExaJ4N2PjRwp4n/QjbhJmwAnAoO5jg8PVA4pl2pbnNgnbdgQ7h
         reCn87IY+KuORZwa23UKoFUecWY/rptI4QNWyBTEvN6BmiUr73POm/7nCn3cZr7Els
         tYWr6jh32Y4ZVeaW7JjNxrrAV1OSljmKAWZ385t8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 162/243] watchdog: jz4740: Fix return value check in jz4740_wdt_probe()
Date:   Mon, 19 Jul 2021 16:53:11 +0200
Message-Id: <20210719144946.129121807@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 29e85f53fb58b45b9e9276dcdf1f1cb762dd1c9f ]

In case of error, the function device_node_to_regmap() returns
ERR_PTR() and never returns NULL. The NULL test in the return
value check should be replaced with IS_ERR().

Fixes: 6d532143c915 ("watchdog: jz4740: Use regmap provided by TCU driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/20210304045909.945799-1-weiyongjun1@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/jz4740_wdt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/jz4740_wdt.c b/drivers/watchdog/jz4740_wdt.c
index bdf9564efa29..395bde79e292 100644
--- a/drivers/watchdog/jz4740_wdt.c
+++ b/drivers/watchdog/jz4740_wdt.c
@@ -176,9 +176,9 @@ static int jz4740_wdt_probe(struct platform_device *pdev)
 	watchdog_set_drvdata(jz4740_wdt, drvdata);
 
 	drvdata->map = device_node_to_regmap(dev->parent->of_node);
-	if (!drvdata->map) {
+	if (IS_ERR(drvdata->map)) {
 		dev_err(dev, "regmap not found\n");
-		return -EINVAL;
+		return PTR_ERR(drvdata->map);
 	}
 
 	return devm_watchdog_register_device(dev, &drvdata->wdt);
-- 
2.30.2



