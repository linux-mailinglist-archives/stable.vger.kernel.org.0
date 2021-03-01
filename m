Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA657328F06
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238395AbhCATmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:42:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242086AbhCATfI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:35:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 113C665200;
        Mon,  1 Mar 2021 17:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619293;
        bh=kvVSK4iz6G8SvJ7GwNvkgmH05szPo7FQtFbJyKPhz3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9rO0dPhO6su0P0cQareEZLqrhuXBh0RahxifQt7Xg9/HnZ97nRpiS/OWHR2wk1Y0
         J7S1YGYUl6dsG/JuW7IbdPeMS3h38pusw/wPxXBKfmfcloR86853j/ihkuINKPVFa5
         F5707npP2ZzJZ46T4+lKAhW9UeBOJe8Ymt0X1yWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trent Piepho <tpiepho@gmail.com>,
        Simon South <simon@simonsouth.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 403/663] pwm: rockchip: Eliminate potential race condition when probing
Date:   Mon,  1 Mar 2021 17:10:51 +0100
Message-Id: <20210301161201.808684446@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index ede027fbf2bb4..3b8da7b0091b1 100644
--- a/drivers/pwm/pwm-rockchip.c
+++ b/drivers/pwm/pwm-rockchip.c
@@ -289,6 +289,7 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
 	struct rockchip_pwm_chip *pc;
 	struct resource *r;
 	u32 enable_conf, ctrl;
+	bool enabled;
 	int ret, count;
 
 	id = of_match_device(rockchip_pwm_dt_ids, &pdev->dev);
@@ -351,6 +352,10 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
 		pc->chip.of_pwm_n_cells = 3;
 	}
 
+	enable_conf = pc->data->enable_conf;
+	ctrl = readl_relaxed(pc->base + pc->data->regs.ctrl);
+	enabled = (ctrl & enable_conf) == enable_conf;
+
 	ret = pwmchip_add(&pc->chip);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
@@ -358,9 +363,7 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
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



