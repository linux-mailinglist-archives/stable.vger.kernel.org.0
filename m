Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2561F2C34
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730509AbgFIAVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:21:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728823AbgFHXRm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:17:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D809E2088E;
        Mon,  8 Jun 2020 23:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658262;
        bh=uB/nrNTc33V1p9MjKZ2UT3WMBnL+IeRKZpIjZGkr7aQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBPJPvL2gMWFzmViTjM7ZTk5gcgP88+ScGPJdWYcVvuM3AP/TFEiIK2/dHhwX6T0U
         0BhMHhusKKpnyCvmc77vvwghqGsOi7eJ2yCtWPhP0iujpPPdh2zS+fcLYr7Gp9jx/+
         ZD/2fLIro3LQXYeCrpECxNkUyTjUy5wcQ1Kl7UWU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 270/606] usb: phy: twl6030-usb: Fix a resource leak in an error handling path in 'twl6030_usb_probe()'
Date:   Mon,  8 Jun 2020 19:06:35 -0400
Message-Id: <20200608231211.3363633-270-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit f058764d19000d98aef72010468db1f69faf9fa0 ]

A call to 'regulator_get()' is hidden in 'twl6030_usb_ldo_init()'. A
corresponding put must be performed in the error handling path, as
already done in the remove function.

While at it, also move a 'free_irq()' call in the error handling path in
order to be consistent.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-twl6030-usb.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/phy/phy-twl6030-usb.c b/drivers/usb/phy/phy-twl6030-usb.c
index bfebf1f2e991..9a7e655d5280 100644
--- a/drivers/usb/phy/phy-twl6030-usb.c
+++ b/drivers/usb/phy/phy-twl6030-usb.c
@@ -377,7 +377,7 @@ static int twl6030_usb_probe(struct platform_device *pdev)
 	if (status < 0) {
 		dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
 			twl->irq1, status);
-		return status;
+		goto err_put_regulator;
 	}
 
 	status = request_threaded_irq(twl->irq2, NULL, twl6030_usb_irq,
@@ -386,8 +386,7 @@ static int twl6030_usb_probe(struct platform_device *pdev)
 	if (status < 0) {
 		dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
 			twl->irq2, status);
-		free_irq(twl->irq1, twl);
-		return status;
+		goto err_free_irq1;
 	}
 
 	twl->asleep = 0;
@@ -396,6 +395,13 @@ static int twl6030_usb_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "Initialized TWL6030 USB module\n");
 
 	return 0;
+
+err_free_irq1:
+	free_irq(twl->irq1, twl);
+err_put_regulator:
+	regulator_put(twl->usb3v3);
+
+	return status;
 }
 
 static int twl6030_usb_remove(struct platform_device *pdev)
-- 
2.25.1

