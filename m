Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58A79F4A0E
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390452AbfKHMGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:06:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389109AbfKHLlC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35D43222C2;
        Fri,  8 Nov 2019 11:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213261;
        bh=DgnMDlLLXfeQeKctRy7xaYZdYGgwE1jsdDjdNnqBmGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMCjkmWK4PvLzh0xKnoY12cipaF9d+8w5f7KpNxDbaRpZlT88MW5llmjJk6/DuHkP
         lurQg/UtSjDi0Q2c4V7zezxzdo3m4mVHREKTOuLiwQz9stUQhFrznossNdVFGZ1MNI
         XzYkVlM2q64TYktHcocS9PSbi9ZQMndZKfY3GdZQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 126/205] rtc: pl030: fix possible race condition
Date:   Fri,  8 Nov 2019 06:36:33 -0500
Message-Id: <20191108113752.12502-126-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit c778ec85825dc895936940072aea9fe9037db684 ]

The IRQ is requested before the struct rtc is allocated and registered, but
this struct is used in the IRQ handler. This may lead to a NULL pointer
dereference.

Switch to devm_rtc_allocate_device/rtc_register_device to allocate the rtc
before requesting the IRQ.

Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pl030.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-pl030.c b/drivers/rtc/rtc-pl030.c
index f85a1a93e669f..343bb6ed17839 100644
--- a/drivers/rtc/rtc-pl030.c
+++ b/drivers/rtc/rtc-pl030.c
@@ -112,6 +112,13 @@ static int pl030_probe(struct amba_device *dev, const struct amba_id *id)
 		goto err_rtc;
 	}
 
+	rtc->rtc = devm_rtc_allocate_device(&dev->dev);
+	if (IS_ERR(rtc->rtc)) {
+		ret = PTR_ERR(rtc->rtc);
+		goto err_rtc;
+	}
+
+	rtc->rtc->ops = &pl030_ops;
 	rtc->base = ioremap(dev->res.start, resource_size(&dev->res));
 	if (!rtc->base) {
 		ret = -ENOMEM;
@@ -128,12 +135,9 @@ static int pl030_probe(struct amba_device *dev, const struct amba_id *id)
 	if (ret)
 		goto err_irq;
 
-	rtc->rtc = rtc_device_register("pl030", &dev->dev, &pl030_ops,
-				       THIS_MODULE);
-	if (IS_ERR(rtc->rtc)) {
-		ret = PTR_ERR(rtc->rtc);
+	ret = rtc_register_device(rtc->rtc);
+	if (ret)
 		goto err_reg;
-	}
 
 	return 0;
 
@@ -154,7 +158,6 @@ static int pl030_remove(struct amba_device *dev)
 	writel(0, rtc->base + RTC_CR);
 
 	free_irq(dev->irq[0], rtc);
-	rtc_device_unregister(rtc->rtc);
 	iounmap(rtc->base);
 	amba_release_regions(dev);
 
-- 
2.20.1

