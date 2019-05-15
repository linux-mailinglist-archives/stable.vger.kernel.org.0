Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A09361EEA4
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731439AbfEOLXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731701AbfEOLXq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:23:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD7DF206BF;
        Wed, 15 May 2019 11:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919425;
        bh=BydgRU944q1yiGz9rk6nQF6qmhXifbIUFUdaxDokuM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WX4S+M3E7qXwNC4SwyOvlv+IlkGYbsLTmrzcaGhDCqGlX2afOSD8amwljWzXDNPPG
         aycC8CLub8zZwzpXTTL6pAiaeb6rSKEV66JKhnCXYPUo7FOnKIqCMd5Ris1DVaYjAy
         /oc6cdVxmh4vKmUj5rPlfGgvNJX11cGaz6nGnTl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.19 069/113] usb: typec: Fix unchecked return value
Date:   Wed, 15 May 2019 12:56:00 +0200
Message-Id: <20190515090658.761496210@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e82adc1074a7356f1158233551df9e86b7ebfb82 ]

Currently there is no check on platform_get_irq() return value
in case it fails, hence never actually reporting any errors and
causing unexpected behavior when using such value as argument
for function regmap_irq_get_virq().

Fix this by adding a proper check, a message error and return
*irq* in case platform_get_irq() fails.

Addresses-Coverity-ID: 1443899 ("Improper use of negative value")
Fixes: d2061f9cc32d ("usb: typec: add driver for Intel Whiskey Cove PMIC USB Type-C PHY")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/usb/typec/typec_wcove.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/typec_wcove.c b/drivers/usb/typec/typec_wcove.c
index 423208e19383c..6770afd407654 100644
--- a/drivers/usb/typec/typec_wcove.c
+++ b/drivers/usb/typec/typec_wcove.c
@@ -615,8 +615,13 @@ static int wcove_typec_probe(struct platform_device *pdev)
 	wcove->dev = &pdev->dev;
 	wcove->regmap = pmic->regmap;
 
-	irq = regmap_irq_get_virq(pmic->irq_chip_data_chgr,
-				  platform_get_irq(pdev, 0));
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "Failed to get IRQ: %d\n", irq);
+		return irq;
+	}
+
+	irq = regmap_irq_get_virq(pmic->irq_chip_data_chgr, irq);
 	if (irq < 0)
 		return irq;
 
-- 
2.20.1



