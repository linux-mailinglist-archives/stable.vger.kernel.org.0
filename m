Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157EF1EAC9B
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731383AbgFASNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:13:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730208AbgFASNs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:13:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42F152068D;
        Mon,  1 Jun 2020 18:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035226;
        bh=uB/nrNTc33V1p9MjKZ2UT3WMBnL+IeRKZpIjZGkr7aQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3zwKCPZUIIjncyMzM/5x9ObFfOdvKWGJSNXmCOb0GabbGhcr4gbi7KNmcMeDUv0p
         6/P4QKoNGGZs+sKRV3ER6qj3j81cCfDqW9O8FSwjGY15NkugYsnStMnhAmRECKZMbD
         oFGs+9YngvAb+bl18V8wp5fP6X2KalWw9PCpG7ZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 065/177] usb: phy: twl6030-usb: Fix a resource leak in an error handling path in twl6030_usb_probe()
Date:   Mon,  1 Jun 2020 19:53:23 +0200
Message-Id: <20200601174054.352250089@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



