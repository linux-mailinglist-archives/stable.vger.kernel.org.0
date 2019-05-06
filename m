Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D2014F5F
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfEFOei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:34:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726699AbfEFOeh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:34:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5F6921019;
        Mon,  6 May 2019 14:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153277;
        bh=mM1dMY4wEQFHJP5ZF0f4aj7mhZdeDuWVVaAbt1qSCq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ggR59tEC3sACZyIHZclP7J5neyG2FuBnOcCVioA+wdct/6pGh971kZ4J2cgHjnyL1
         tAc443aVQmLp9e4o+zobno9cMK52EdHgRZKvm4d+B6OZlk5/vSGxNX4f0IftHFGNOO
         L44hXNNR9kPZ5njuwjj9ZTdkgfu7zY7yYrFO/JYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Evan Green <evgreen@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 029/122] rtc: cros-ec: Fail suspend/resume if wake IRQ cant be configured
Date:   Mon,  6 May 2019 16:31:27 +0200
Message-Id: <20190506143057.381838909@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d6752e185c3168771787a02dc6a55f32260943cc ]

If we encounter a failure during suspend where this RTC was programmed
to wakeup the system from suspend, but that wakeup couldn't be
configured because the system didn't support wakeup interrupts, we'll
run into the following warning:

	Unbalanced IRQ 166 wake disable
	WARNING: CPU: 7 PID: 3071 at kernel/irq/manage.c:669 irq_set_irq_wake+0x108/0x278

This happens because the suspend process isn't aborted when the RTC
fails to configure the wakeup IRQ. Instead, we continue suspending the
system and then another suspend callback fails the suspend process and
"unwinds" the previously suspended drivers by calling their resume
callbacks. When we get back to resuming this RTC driver, we'll call
disable_irq_wake() on an IRQ that hasn't been configured for wake.

Let's just fail suspend/resume here if we can't configure the system to
wake and the user has chosen to wakeup with this device. This fixes this
warning and makes the code more robust in case there are systems out
there that can't wakeup from suspend on this line but the user has
chosen to do so.

Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: Evan Green <evgreen@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Acked-By: Benson Leung <bleung@chromium.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/rtc/rtc-cros-ec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-cros-ec.c b/drivers/rtc/rtc-cros-ec.c
index e5444296075e..4d6bf9304ceb 100644
--- a/drivers/rtc/rtc-cros-ec.c
+++ b/drivers/rtc/rtc-cros-ec.c
@@ -298,7 +298,7 @@ static int cros_ec_rtc_suspend(struct device *dev)
 	struct cros_ec_rtc *cros_ec_rtc = dev_get_drvdata(&pdev->dev);
 
 	if (device_may_wakeup(dev))
-		enable_irq_wake(cros_ec_rtc->cros_ec->irq);
+		return enable_irq_wake(cros_ec_rtc->cros_ec->irq);
 
 	return 0;
 }
@@ -309,7 +309,7 @@ static int cros_ec_rtc_resume(struct device *dev)
 	struct cros_ec_rtc *cros_ec_rtc = dev_get_drvdata(&pdev->dev);
 
 	if (device_may_wakeup(dev))
-		disable_irq_wake(cros_ec_rtc->cros_ec->irq);
+		return disable_irq_wake(cros_ec_rtc->cros_ec->irq);
 
 	return 0;
 }
-- 
2.20.1



