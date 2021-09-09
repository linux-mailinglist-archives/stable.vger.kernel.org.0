Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0A940554D
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358747AbhIINJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:09:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357885AbhIINFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:05:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A371963280;
        Thu,  9 Sep 2021 12:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188803;
        bh=cJuvfYSyGsgXQlB4XaacXMJyw9FoYiKpfP6CmbpT0+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RigmaCbjp0CoM5rYfq0wmrOtH8nI4+7xttdN2eUzhbuYz92fyyXXskESIxcjlRJTw
         senCtcIMqks+2l8PBYld+F44kounFQ5EqlcnkbS2zhsQxM4YKuYPkfS0BEZrNdhYL5
         p0bDHW9bFCZSV2T07EZaPBCVX1o9t18UjqnRjtyEbT+EvkAi8sTJcabb38hYjwTD0A
         l6YtBX3boxnO8jfSimd2Tl8RiKlKscXDjad+3wPRHvLMh9t1PwIFAf1SpAYbRnxMAd
         zjNmqfTf/imfV7mamRb8VW5vxMC/nRLmjLK0m6oJMqjFlFS/OHkFN4jEMsrmeE/LAJ
         g2eU41xFUGT1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nadezda Lutovinova <lutovinova@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 50/59] usb: musb: musb_dsps: request_irq() after initializing musb
Date:   Thu,  9 Sep 2021 07:58:51 -0400
Message-Id: <20210909115900.149795-50-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115900.149795-1-sashal@kernel.org>
References: <20210909115900.149795-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadezda Lutovinova <lutovinova@ispras.ru>

[ Upstream commit 7c75bde329d7e2a93cf86a5c15c61f96f1446cdc ]

If IRQ occurs between calling  dsps_setup_optional_vbus_irq()
and  dsps_create_musb_pdev(), then null pointer dereference occurs
since glue->musb wasn't initialized yet.

The patch puts initializing of neccesery data before registration
of the interrupt handler.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Nadezda Lutovinova <lutovinova@ispras.ru>
Link: https://lore.kernel.org/r/20210819163323.17714-1-lutovinova@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/musb/musb_dsps.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index b7d460adaa61..a582c3847dc2 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -930,23 +930,22 @@ static int dsps_probe(struct platform_device *pdev)
 	if (!glue->usbss_base)
 		return -ENXIO;
 
-	if (usb_get_dr_mode(&pdev->dev) == USB_DR_MODE_PERIPHERAL) {
-		ret = dsps_setup_optional_vbus_irq(pdev, glue);
-		if (ret)
-			goto err_iounmap;
-	}
-
 	platform_set_drvdata(pdev, glue);
 	pm_runtime_enable(&pdev->dev);
 	ret = dsps_create_musb_pdev(glue, pdev);
 	if (ret)
 		goto err;
 
+	if (usb_get_dr_mode(&pdev->dev) == USB_DR_MODE_PERIPHERAL) {
+		ret = dsps_setup_optional_vbus_irq(pdev, glue);
+		if (ret)
+			goto err;
+	}
+
 	return 0;
 
 err:
 	pm_runtime_disable(&pdev->dev);
-err_iounmap:
 	iounmap(glue->usbss_base);
 	return ret;
 }
-- 
2.30.2

