Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF6A329099
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242668AbhCAUK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:10:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242333AbhCAT5K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:57:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E02E965387;
        Mon,  1 Mar 2021 17:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621360;
        bh=gowZsPk0fuAEgmh3tDpcLR8ZDLnl79JkqSjetN0KwHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q1q23ldfVPw6JZm36N5tShMnkoysvRmYnW5BBoYjujdaTfX99OF/OL5FvVvvW/+cR
         +cU/Xb7Mj1sfHwkBbWtR8AsthGROLdxPpF5YGsriiXzotKPz90jz9FV7skrJ4+1D7z
         5+J06GUAGDNJ3kezFquy7H9GbWi987DVxmYd5N8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trent Piepho <tpiepho@gmail.com>,
        Simon South <simon@simonsouth.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 487/775] pwm: rockchip: Eliminate potential race condition when probing
Date:   Mon,  1 Mar 2021 17:10:55 +0100
Message-Id: <20210301161225.598410002@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon South <simon@simonsouth.net>

[ Upstream commit d21ba5d6217bd5a6a696678385906ed1994b380b ]

Commit 48cf973cae33 ("pwm: rockchip: Avoid glitches on already running
PWMs") introduced a potential race condition in rockchip_pwm_probe(): A
consumer could enable an inactive PWM, or disable a running one, between
rockchip_pwm_probe() registering the device via pwmchip_add() and checking
whether it is enabled (to determine whether it was started by a
bootloader). This could result in a device's PWM clock being either enabled
once more than necessary, potentially causing it to continue running when
no longer needed, or disabled once more than necessary, producing a warning
from the kernel.

Eliminate these possibilities by modifying rockchip_pwm_probe() so it
checks whether a device is enabled before registering it rather than after.

Fixes: 48cf973cae33 ("pwm: rockchip: Avoid glitches on already running PWMs")
Reported-by: Trent Piepho <tpiepho@gmail.com>
Signed-off-by: Simon South <simon@simonsouth.net>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-rockchip.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
index 90f969f9f5e2b..f3a5641f6bca5 100644
--- a/drivers/pwm/pwm-rockchip.c
+++ b/drivers/pwm/pwm-rockchip.c
@@ -288,6 +288,7 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
 	const struct of_device_id *id;
 	struct rockchip_pwm_chip *pc;
 	u32 enable_conf, ctrl;
+	bool enabled;
 	int ret, count;
 
 	id = of_match_device(rockchip_pwm_dt_ids, &pdev->dev);
@@ -349,6 +350,10 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
 		pc->chip.of_pwm_n_cells = 3;
 	}
 
+	enable_conf = pc->data->enable_conf;
+	ctrl = readl_relaxed(pc->base + pc->data->regs.ctrl);
+	enabled = (ctrl & enable_conf) == enable_conf;
+
 	ret = pwmchip_add(&pc->chip);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
@@ -356,9 +361,7 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
 	}
 
 	/* Keep the PWM clk enabled if the PWM appears to be up and running. */
-	enable_conf = pc->data->enable_conf;
-	ctrl = readl_relaxed(pc->base + pc->data->regs.ctrl);
-	if ((ctrl & enable_conf) != enable_conf)
+	if (!enabled)
 		clk_disable(pc->clk);
 
 	clk_disable(pc->pclk);
-- 
2.27.0



