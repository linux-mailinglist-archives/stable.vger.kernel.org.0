Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2753CE5A7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348611AbhGSPwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346417AbhGSPrO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:47:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 831A16144F;
        Mon, 19 Jul 2021 16:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712046;
        bh=K6sT0z5Ze+D+76RPWYHyQ8VyASl+PDH7AZMuq3ukA9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oCIg0f9ymELVf21sai7o91FqFG+hG+/huMlm1e4xgPwW8RJyyFD3loiW9IComw7oB
         Hl9PruCiFzxlaG2qwf9E57kiQxd5JKmjIMAS6vqpUv6RRAGWLON9GuGEjBdox+Npji
         RfyE4+lJ91GUbdjcdDmpvbkzhK8jpRMwp6OIDyKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 196/292] watchdog: jz4740: Fix return value check in jz4740_wdt_probe()
Date:   Mon, 19 Jul 2021 16:54:18 +0200
Message-Id: <20210719144948.937605194@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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



