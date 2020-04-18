Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1EF91AED90
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 15:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgDRNwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 09:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726432AbgDRNse (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 09:48:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2607C22251;
        Sat, 18 Apr 2020 13:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587217713;
        bh=e50X4MmtkJexI4QRd79cP3skCvlBuDS3y6zV+tBhyIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0JxDMtShXU4WvQsEJdvws8FtQqr4LySdJENHGgnXyTKGX9ZxCVeiiOj2mS5hKsXS
         yQjuivrWnrweXEV8CKACQTZAJ5MBwSKw7rbSXcQ/1hCzHtCxkbGNMHQOa52XgNPRFm
         SP4GGqgOEnhdf3C3wtW6zTG4SbrD/Fif/cfKXuQY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 15/73] pwm: imx27: Fix clock handling in pwm_imx27_apply()
Date:   Sat, 18 Apr 2020 09:47:17 -0400
Message-Id: <20200418134815.6519-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418134815.6519-1-sashal@kernel.org>
References: <20200418134815.6519-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 15d4dbd601591858611184f9ddeb5bf21569159c ]

pwm_imx27_apply() enables the clocks if the previous PWM state was
disabled. Given that the clocks are supposed to be left on iff the PWM
is running, the decision to disable the clocks at the end of the
function must not depend on the previous state.

Without this fix the enable count of the two affected clocks increases
by one whenever ->apply() changes from one disabled state to another.

Fixes: bd88d319abe9 ("pwm: imx27: Unconditionally write state to hardware")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-imx27.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-imx27.c b/drivers/pwm/pwm-imx27.c
index 35a7ac42269c2..7e5ed01529773 100644
--- a/drivers/pwm/pwm-imx27.c
+++ b/drivers/pwm/pwm-imx27.c
@@ -289,7 +289,7 @@ static int pwm_imx27_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	writel(cr, imx->mmio_base + MX3_PWMCR);
 
-	if (!state->enabled && cstate.enabled)
+	if (!state->enabled)
 		pwm_imx27_clk_disable_unprepare(chip);
 
 	return 0;
-- 
2.20.1

