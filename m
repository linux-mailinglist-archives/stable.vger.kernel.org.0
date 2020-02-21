Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF08B167510
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388330AbgBUIWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:22:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:34218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388317AbgBUIWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:22:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DD7E24672;
        Fri, 21 Feb 2020 08:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273354;
        bh=GmrqN0DFIZ7l/FZPcAk3tdx0dJ/S2si6wfb5OJrkPpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PH0PsBMTQBgk0XSvcARdW/nYBUhI6jSQ7xr6QlGnWCZJAo4pW6969AK27CeuowSsk
         WuNvyH6Ah1qB+4QveEiloaImB/r8enIDfoU/2qlxXTkVwBbFrEoJmmTAXveEjx3UK7
         eW711QO19nBJnO3U4W8QtUFhT+yas/sbfCFXAJ6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 140/191] pwm: omap-dmtimer: Remove PWM chip in .remove before making it unfunctional
Date:   Fri, 21 Feb 2020 08:41:53 +0100
Message-Id: <20200221072307.481538716@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 43efdc8f0e6d7088ec61bd55a73bf853f002d043 ]

In the old code (e.g.) mutex_destroy() was called before
pwmchip_remove(). Between these two calls it is possible that a PWM
callback is used which tries to grab the mutex.

Fixes: 6604c6556db9 ("pwm: Add PWM driver for OMAP using dual-mode timers")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-omap-dmtimer.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-omap-dmtimer.c b/drivers/pwm/pwm-omap-dmtimer.c
index 2d585c101d52e..c6e710a713d31 100644
--- a/drivers/pwm/pwm-omap-dmtimer.c
+++ b/drivers/pwm/pwm-omap-dmtimer.c
@@ -364,6 +364,11 @@ put:
 static int pwm_omap_dmtimer_remove(struct platform_device *pdev)
 {
 	struct pwm_omap_dmtimer_chip *omap = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = pwmchip_remove(&omap->chip);
+	if (ret)
+		return ret;
 
 	if (pm_runtime_active(&omap->dm_timer_pdev->dev))
 		omap->pdata->stop(omap->dm_timer);
@@ -372,7 +377,7 @@ static int pwm_omap_dmtimer_remove(struct platform_device *pdev)
 
 	mutex_destroy(&omap->mutex);
 
-	return pwmchip_remove(&omap->chip);
+	return 0;
 }
 
 static const struct of_device_id pwm_omap_dmtimer_of_match[] = {
-- 
2.20.1



