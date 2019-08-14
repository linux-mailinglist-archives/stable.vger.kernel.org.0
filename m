Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A30568C985
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbfHNCjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:39:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727516AbfHNCLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:11:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7F3820989;
        Wed, 14 Aug 2019 02:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748693;
        bh=x+Nda0dplsGeQvZJUh8S6xSL8VrWFUAaYwqBqSC64qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmRLdQzuCgPlw2fZ7+JGkJTcQnsBicVyJJCRq+sSqdpdKITl3p5wB/LOfB6A9qBWu
         KgKLOYTYbgkU/KCzSc1Uye/Uks6rCXhZgjuoboeh6fejRaUGvsehcjByq2QnGFZN8M
         n5suTu02pMcK8otY0HR6g82v3lUCmYB36fyh1fIc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lubomir Rintel <lkundrak@v3.sk>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 024/123] spi: pxa2xx: Balance runtime PM enable/disable on error
Date:   Tue, 13 Aug 2019 22:09:08 -0400
Message-Id: <20190814021047.14828-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lubomir Rintel <lkundrak@v3.sk>

[ Upstream commit 1274204542f683e1d8491ebe9cc86284d5a8ebcc ]

Don't undo the PM initialization if we error out before we managed to
initialize it. The call to pm_runtime_disable() without being preceded
by pm_runtime_enable() would disturb the balance of the Force.

In practice, this happens if we fail to allocate any of the GPIOS ("cs",
"ready") due to -EPROBE_DEFER because we're getting probled before the
GPIO driver.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Link: https://lore.kernel.org/r/20190719122713.3444318-1-lkundrak@v3.sk
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-pxa2xx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index af3f37ba82c83..c1af8887d9186 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1817,14 +1817,16 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	status = devm_spi_register_controller(&pdev->dev, controller);
 	if (status != 0) {
 		dev_err(&pdev->dev, "problem registering spi controller\n");
-		goto out_error_clock_enabled;
+		goto out_error_pm_runtime_enabled;
 	}
 
 	return status;
 
-out_error_clock_enabled:
+out_error_pm_runtime_enabled:
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+
+out_error_clock_enabled:
 	clk_disable_unprepare(ssp->clk);
 
 out_error_dma_irq_alloc:
-- 
2.20.1

