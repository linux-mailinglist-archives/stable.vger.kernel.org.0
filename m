Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C7E3C3038
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbhGJCdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233581AbhGJCc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:32:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9C5A6143F;
        Sat, 10 Jul 2021 02:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884078;
        bh=glUyRGJpssEUWp1XjJ1DcA/CbbL9xDZj0iPpNNgStho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HD7lxE2Uxy9cTmuon8BgcwsWPelr9zCM6xbcB7GnshxqgCPi23+bxTkjzyKzRN/4V
         ptIk+o6l+2bd9NCbCE24yALlDmcb+5Y1RDDeL/GD4NoJXHILbbOyoalLm/uwF7665g
         hMWprUcdL8I62PWwKASBYS7Y+g9xioMn1sNNf6ngZ9brEfZiTxaRssVTDEjM74NLx7
         5T8WZoEYKWWS3WWfDf4c5OXHMNVznfuc9aTXjvCch8/u/HQDLdSu53PLi9zQxn3x8t
         uZzBfwJ0Q6kY4+yDrGt7CWDTWRSYh5Rx2HsyyO9nmiyjL9XDTYyHJVjuH2P1ioMWH4
         sP1h3n1TyvB4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 38/63] gpio: zynq: Check return value of pm_runtime_get_sync
Date:   Fri,  9 Jul 2021 22:26:44 -0400
Message-Id: <20210710022709.3170675-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Neeli <srinivas.neeli@xilinx.com>

[ Upstream commit a51b2fb94b04ab71e53a71b9fad03fa826941254 ]

Return value of "pm_runtime_get_sync" API was neither captured nor checked.
Fixed it by capturing the return value and then checking for any warning.

Addresses-Coverity: "check_return"
Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-zynq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-zynq.c b/drivers/gpio/gpio-zynq.c
index 88b04d8a7fa7..25a42605aa81 100644
--- a/drivers/gpio/gpio-zynq.c
+++ b/drivers/gpio/gpio-zynq.c
@@ -938,8 +938,11 @@ static int zynq_gpio_probe(struct platform_device *pdev)
 static int zynq_gpio_remove(struct platform_device *pdev)
 {
 	struct zynq_gpio *gpio = platform_get_drvdata(pdev);
+	int ret;
 
-	pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0)
+		dev_warn(&pdev->dev, "pm_runtime_get_sync() Failed\n");
 	gpiochip_remove(&gpio->chip);
 	clk_disable_unprepare(gpio->clk);
 	device_set_wakeup_capable(&pdev->dev, 0);
-- 
2.30.2

