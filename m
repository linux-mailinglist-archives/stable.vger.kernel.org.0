Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C7B3CE495
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348624AbhGSPoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:44:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346744AbhGSPlW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:41:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA0BE611ED;
        Mon, 19 Jul 2021 16:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711677;
        bh=1lRDiCc8YbkpHq7VPWj7qmsoIYu99lImpAU5h12Bcns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wncYE8jHZK/c/Sxhjdgda7BRRP2tInOowdjU/p8zU9Q1Zb2RBfRKp4NGxvbfJXkc0
         C+nOE0FuWE+AxpcGGcOMt4nlPYY//2RuaPnA9UV8728vngXUlBJhXH1asDLfj11imB
         8l0B8EtSj0UIxjBION+nFTC/rhZd6z/yukF13cfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 092/292] gpio: zynq: Check return value of pm_runtime_get_sync
Date:   Mon, 19 Jul 2021 16:52:34 +0200
Message-Id: <20210719144945.533448833@linuxfoundation.org>
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
index 3521c1dc3ac0..fb8684d70fe3 100644
--- a/drivers/gpio/gpio-zynq.c
+++ b/drivers/gpio/gpio-zynq.c
@@ -1001,8 +1001,11 @@ err_pm_dis:
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



