Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97C9B172059
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730669AbgB0Ntw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:49:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731109AbgB0Ntv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:49:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAC5C20801;
        Thu, 27 Feb 2020 13:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811391;
        bh=OjlB9AVcPer6GvN/IsZeDID4gRoeRc0i8+HUSWT00wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2LSAht2pCjuLgNxk4U6vBrNPu2ZBwxvZLf0o94zZFFEeAOKlcJvLPaWq4JUv4UO1F
         ic+i2XuoTRV5apZcLlO1doAWiTpDTp1W1Uoaax20/8Gb2ryPQsi4Fuf/dHo+T5ziGX
         QkFAvqeAmuUorXCBdtbAL8A+wahx3nTkmgkcwLIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 087/165] pwm: omap-dmtimer: Remove PWM chip in .remove before making it unfunctional
Date:   Thu, 27 Feb 2020 14:36:01 +0100
Message-Id: <20200227132244.012933520@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
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
index 5ad42f33e70c1..2e15acf13893d 100644
--- a/drivers/pwm/pwm-omap-dmtimer.c
+++ b/drivers/pwm/pwm-omap-dmtimer.c
@@ -337,6 +337,11 @@ static int pwm_omap_dmtimer_probe(struct platform_device *pdev)
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
@@ -345,7 +350,7 @@ static int pwm_omap_dmtimer_remove(struct platform_device *pdev)
 
 	mutex_destroy(&omap->mutex);
 
-	return pwmchip_remove(&omap->chip);
+	return 0;
 }
 
 static const struct of_device_id pwm_omap_dmtimer_of_match[] = {
-- 
2.20.1



