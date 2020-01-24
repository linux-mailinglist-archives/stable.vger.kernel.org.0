Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D604147B02
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732306AbgAXJkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:40:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732283AbgAXJkK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:40:10 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3C412070A;
        Fri, 24 Jan 2020 09:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858809;
        bh=O9Jvy2TlVkAc+RK8rKlLq3IrIZnt5MgaHxocavlgH/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2YXIRNqXnO2FVFXu5H9ZJn2vuPm2jtH4w3NmG2/WC1jv9EXZjdCVDTM7D7ZLPC1rH
         SSE60epRszRin09LeOkZrns5ArvGr1+qkWAuCUJM/XWUq0zDJFM2t1TaYYU0cFefhN
         OUAvEHoC4VOAfyTyVXLTNNHw0xM7T9XthYELfQRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/102] pwm: sun4i: Fix incorrect calculation of duty_cycle/period
Date:   Fri, 24 Jan 2020 10:31:03 +0100
Message-Id: <20200124092815.700678973@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

[ Upstream commit 50cc7e3e4f26e3bf5ed74a8d061195c4d2161b8b ]

Since 5.4-rc1, pwm_apply_state calls ->get_state after ->apply
if available, and this revealed an issue with integer precision
when calculating duty_cycle and period for the currently set
state in ->get_state callback.

This issue manifested in broken backlight on several Allwinner
based devices.

Previously this worked, because ->apply updated the passed state
directly.

Fixes: deb9c462f4e53 ("pwm: sun4i: Don't update the state for the caller of pwm_apply_state")
Signed-off-by: Ondrej Jirman <megous@megous.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-sun4i.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-sun4i.c b/drivers/pwm/pwm-sun4i.c
index 6f5840a1a82dc..05273725a9fff 100644
--- a/drivers/pwm/pwm-sun4i.c
+++ b/drivers/pwm/pwm-sun4i.c
@@ -137,10 +137,10 @@ static void sun4i_pwm_get_state(struct pwm_chip *chip,
 
 	val = sun4i_pwm_readl(sun4i_pwm, PWM_CH_PRD(pwm->hwpwm));
 
-	tmp = prescaler * NSEC_PER_SEC * PWM_REG_DTY(val);
+	tmp = (u64)prescaler * NSEC_PER_SEC * PWM_REG_DTY(val);
 	state->duty_cycle = DIV_ROUND_CLOSEST_ULL(tmp, clk_rate);
 
-	tmp = prescaler * NSEC_PER_SEC * PWM_REG_PRD(val);
+	tmp = (u64)prescaler * NSEC_PER_SEC * PWM_REG_PRD(val);
 	state->period = DIV_ROUND_CLOSEST_ULL(tmp, clk_rate);
 }
 
-- 
2.20.1



