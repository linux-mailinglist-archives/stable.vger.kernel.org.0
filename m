Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4CD383041
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239243AbhEQOZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:25:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237315AbhEQOWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:22:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 366A361480;
        Mon, 17 May 2021 14:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260732;
        bh=y8jXhEd11/4EYV/k/XtYQHWWe8BXEbMqsd7gqkPtRyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hd1NeBvlJssdL9NmQGK8HXTDm1w8vL4eet7jk5qftj+6etjbkVemzqQZvv/VWO79j
         SdNhhlVLimGvPDtkP2iPOEFZUjm7btSxjYg6oZiBbT+Hngssiyk8cZmP2gNQMS/VCd
         z9lOCfRjByiI1WDEjtiftPdmsjEWFp0Wb+Q2piKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 180/363] pwm: atmel: Fix duty cycle calculation in .get_state()
Date:   Mon, 17 May 2021 16:00:46 +0200
Message-Id: <20210517140308.681779469@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 453e8b3d8e36ddcb283b3d1698864a03ea45599a ]

The CDTY register contains the number of inactive cycles. .apply() does
this correctly, however .get_state() got this wrong.

Fixes: 651b510a74d4 ("pwm: atmel: Implement .get_state()")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-atmel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
index 5813339b597b..3292158157b6 100644
--- a/drivers/pwm/pwm-atmel.c
+++ b/drivers/pwm/pwm-atmel.c
@@ -319,7 +319,7 @@ static void atmel_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 
 		cdty = atmel_pwm_ch_readl(atmel_pwm, pwm->hwpwm,
 					  atmel_pwm->data->regs.duty);
-		tmp = (u64)cdty * NSEC_PER_SEC;
+		tmp = (u64)(cprd - cdty) * NSEC_PER_SEC;
 		tmp <<= pres;
 		state->duty_cycle = DIV64_U64_ROUND_UP(tmp, rate);
 
-- 
2.30.2



