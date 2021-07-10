Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF483C31CB
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhGJCpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:45:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235360AbhGJCnq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:43:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 064AA613F8;
        Sat, 10 Jul 2021 02:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884767;
        bh=weQNBX0jMb5LEh9P7RGQr+gjLeNyOff0TyiaH4Yfxro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4nd5Qtqt3HSsk6NijQ9//jXV6wIDaXyJ1KYDltoqI1dFkroCcOhBHBGdzctPVEsY
         E/bellgpb+aRk4QCZPMDiogDAvmp5Bs3P4QZYryZLrbxXI2w8z/KDnVytc//MwyKma
         9lBCuXJ9RtEsB+c8hffsMzjdmyfz+hfvVqmSDpymLzXWpa74/zHdfQ4x9gqQnkwZEn
         +qlnKg8TwpV3AM3xRV/A2Ob2fW4NZwEwpw20fPJCu0ww9CMoAYbTT1FvvfhoCKKVir
         bVAE6jsPtoYBBe9NOXRd2PhZuI4NsDIx0XNlWb02PBXMAIViwCqTkUIjzwfDBguyct
         AHduczYlbTlDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 12/23] gpio: zynq: Check return value of pm_runtime_get_sync
Date:   Fri,  9 Jul 2021 22:39:01 -0400
Message-Id: <20210710023912.3172972-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023912.3172972-1-sashal@kernel.org>
References: <20210710023912.3172972-1-sashal@kernel.org>
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
index 8abeacac5885..ccfdf5a45998 100644
--- a/drivers/gpio/gpio-zynq.c
+++ b/drivers/gpio/gpio-zynq.c
@@ -764,8 +764,11 @@ static int zynq_gpio_probe(struct platform_device *pdev)
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

