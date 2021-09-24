Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB0B41738E
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343757AbhIXM7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:59:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343974AbhIXMzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:55:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 251FE61241;
        Fri, 24 Sep 2021 12:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487877;
        bh=wPBkiWYPFsUFpsLU3ScKX/PisasZhReLCCBsW3Ow3so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TOU0VNORFU/7D5o3Jln6LJ1Moxl3pk2Z2L40rePuhq+uUjwwHwn7BiLGq+gVeUnyJ
         u9hUyhm1alTUnM5yuXOB2oEPZMbnMhDixFOOKAEZ1vE3gcvCgt7nHtEAFwQlh3rAEh
         7oMubPvOq195fYt9IK5jHOO/c7zZ9RKremMe0auk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 47/50] pwm: stm32-lp: Dont modify HW state in .remove() callback
Date:   Fri, 24 Sep 2021 14:44:36 +0200
Message-Id: <20210924124333.824465471@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit d44084c93427bb0a9261432db1a8ca76a42d805e ]

A consumer is expected to disable a PWM before calling pwm_put(). And if
they didn't there is hopefully a good reason (or the consumer needs
fixing). Also if disabling an enabled PWM was the right thing to do,
this should better be done in the framework instead of in each low level
driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-stm32-lp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pwm/pwm-stm32-lp.c b/drivers/pwm/pwm-stm32-lp.c
index 67fca62524dc..05bb1f95a773 100644
--- a/drivers/pwm/pwm-stm32-lp.c
+++ b/drivers/pwm/pwm-stm32-lp.c
@@ -225,8 +225,6 @@ static int stm32_pwm_lp_remove(struct platform_device *pdev)
 {
 	struct stm32_pwm_lp *priv = platform_get_drvdata(pdev);
 
-	pwm_disable(&priv->chip.pwms[0]);
-
 	return pwmchip_remove(&priv->chip);
 }
 
-- 
2.33.0



