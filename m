Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93DD3289E3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239168AbhCASHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:07:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238325AbhCASBa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:01:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BF34651AC;
        Mon,  1 Mar 2021 17:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619288;
        bh=rK3a5NaRhJhvHTt3kevhobOks/qIUC/K0EwM4prBEYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SeJDX+ao1o1CrlnVExUBc+u7ARxr5r7kCqs5JNYjzf176elZ9lbsdsfoQwVCMRU/W
         ykQFcXsJ5bq6X5xCRDL3AQft2JIU0FWu2W0BjWXad3/o1/CtAlilJTm/sdIHqAZu3M
         XPCq678BfKL17mv5HLqJbV0b1OByCeUbs7Pw7fVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>,
        Trent Piepho <tpiepho@gmail.com>,
        Simon South <simon@simonsouth.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 401/663] pwm: rockchip: Enable APB clock during register access while probing
Date:   Mon,  1 Mar 2021 17:10:49 +0100
Message-Id: <20210301161201.711100535@linuxfoundation.org>
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

[ Upstream commit d9b657a5cdbd960de35dee7e06473caf44a9016f ]

Commit 457f74abbed0 ("pwm: rockchip: Keep enabled PWMs running while
probing") modified rockchip_pwm_probe() to access a PWM device's registers
directly to check whether or not the device is enabled, but did not also
change the function so it first enables the device's APB clock to be
certain the device can respond. This risks hanging the kernel on systems
with PWM devices that use more than a single clock.

Avoid this by enabling the device's APB clock before accessing its
registers (and disabling the clock when register access is complete).

Fixes: 457f74abbed0 ("pwm: rockchip: Keep enabled PWMs running while probing")
Reported-by: Thierry Reding <thierry.reding@gmail.com>
Suggested-by: Trent Piepho <tpiepho@gmail.com>
Signed-off-by: Simon South <simon@simonsouth.net>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-rockchip.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
index 77c23a2c6d71e..7b9cdefb3daa3 100644
--- a/drivers/pwm/pwm-rockchip.c
+++ b/drivers/pwm/pwm-rockchip.c
@@ -332,9 +332,9 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = clk_prepare(pc->pclk);
+	ret = clk_prepare_enable(pc->pclk);
 	if (ret) {
-		dev_err(&pdev->dev, "Can't prepare APB clk: %d\n", ret);
+		dev_err(&pdev->dev, "Can't prepare enable APB clk: %d\n", ret);
 		goto err_clk;
 	}
 
@@ -364,10 +364,12 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
 	if ((ctrl & enable_conf) != enable_conf)
 		clk_disable(pc->clk);
 
+	clk_disable(pc->pclk);
+
 	return 0;
 
 err_pclk:
-	clk_unprepare(pc->pclk);
+	clk_disable_unprepare(pc->pclk);
 err_clk:
 	clk_disable_unprepare(pc->clk);
 
-- 
2.27.0



