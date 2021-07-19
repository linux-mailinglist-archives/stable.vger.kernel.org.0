Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1074D3CDFBD
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345383AbhGSPLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:11:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345833AbhGSPJk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:09:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFD80610D2;
        Mon, 19 Jul 2021 15:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709771;
        bh=7K9eVUMY1pQAF+2qstCDKAH0TI5uw0X4L1n6GzI9Y7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGLdhMbMDaf5amFD90EmDTKEL7wvI8n9tRECF7eQaN7RDCEA1CZrZ6HBCGRxzFxZs
         jXLvSkBkezpwMh/6sBUxZ1Hf+DwzM7bfpUiKX+a4ectiOf+npGrXyQUNTB5SsdvUgX
         bNJclwpcNafNdMqUyTrPy67Leg887JxY2Ee7w9Ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/149] pwm: tegra: Dont modify HW state in .remove callback
Date:   Mon, 19 Jul 2021 16:53:18 +0200
Message-Id: <20210719144922.719547625@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 86f7fa71cd830d18d7ebcaf719dffd5ddfe1acdd ]

A consumer is expected to disable a PWM before calling pwm_put(). And if
they didn't there is hopefully a good reason (or the consumer needs
fixing). Also if disabling an enabled PWM was the right thing to do,
this should better be done in the framework instead of in each low level
driver.

So drop the hardware modification from the .remove() callback.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-tegra.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/pwm/pwm-tegra.c b/drivers/pwm/pwm-tegra.c
index aa12fb3ed92e..3d55e30a6866 100644
--- a/drivers/pwm/pwm-tegra.c
+++ b/drivers/pwm/pwm-tegra.c
@@ -232,7 +232,6 @@ static int tegra_pwm_probe(struct platform_device *pdev)
 static int tegra_pwm_remove(struct platform_device *pdev)
 {
 	struct tegra_pwm_chip *pc = platform_get_drvdata(pdev);
-	unsigned int i;
 	int err;
 
 	if (WARN_ON(!pc))
@@ -242,18 +241,6 @@ static int tegra_pwm_remove(struct platform_device *pdev)
 	if (err < 0)
 		return err;
 
-	for (i = 0; i < pc->chip.npwm; i++) {
-		struct pwm_device *pwm = &pc->chip.pwms[i];
-
-		if (!pwm_is_enabled(pwm))
-			if (clk_prepare_enable(pc->clk) < 0)
-				continue;
-
-		pwm_writel(pc, i, 0);
-
-		clk_disable_unprepare(pc->clk);
-	}
-
 	reset_control_assert(pc->rst);
 	clk_disable_unprepare(pc->clk);
 
-- 
2.30.2



