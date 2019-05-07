Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3264515996
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfEGFiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:38:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727969AbfEGFiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:38:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 418F32087F;
        Tue,  7 May 2019 05:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207484;
        bh=ejnkGt10CVUeV3b08a7mML8ViNQJMeaXbDDDt2m66aQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m11+7MWROt3Wa5pz0h6YYzZFH/RuAeQb5Bbf/lprsGMW+mkoQmAz86sAqg5BHM1Bf
         pAmiYuy38xYaKIjfUn8Dpc4b+QLdJ2hYJwVjJneReQQZuIlT0Oh/9PklVGIoR8OQS5
         g0nr20xpw5q4GyqATMXAGJTDbmf5eCSGtD7IO+Uo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 68/81] usb: typec: Fix unchecked return value
Date:   Tue,  7 May 2019 01:35:39 -0400
Message-Id: <20190507053554.30848-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

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
index 423208e19383..6770afd40765 100644
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

