Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB0532909C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242758AbhCAULP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:11:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242130AbhCAT5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:57:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 304E865386;
        Mon,  1 Mar 2021 17:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621357;
        bh=x8YSJmHjWGDSy9YKbJ+3FtArCwab3cpypA/LHrHF9cA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tiAQjg90mNImQMjEMd0wyJ2213XpVYGAQptMYAGXVsaMYzP25rQvTPIxSpHx6VDju
         u3jI9XMTavVRlrTfzLw/ib/ZMa8e2BU/8i8wIelZDlObBbadYkb68fL1W5Ewu+2Rx9
         rMSKKDAjdhUR7iXiRJ/U2RCuEXH5WgrXLBtFIl2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon South <simon@simonsouth.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 486/775] pwm: rockchip: rockchip_pwm_probe(): Remove superfluous clk_unprepare()
Date:   Mon,  1 Mar 2021 17:10:54 +0100
Message-Id: <20210301161225.551230588@linuxfoundation.org>
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

[ Upstream commit d5d8d675865ccddfe4da26c85f22c55cec663bf2 ]

If rockchip_pwm_probe() fails to register a PWM device it calls
clk_unprepare() for the device's PWM clock, without having first disabled
the clock and before jumping to an error handler that also unprepares
it. This is likely to produce warnings from the kernel about the clock
being unprepared when it is still enabled, and then being unprepared when
it has already been unprepared.

Prevent these warnings by removing this unnecessary call to
clk_unprepare().

Fixes: 48cf973cae33 ("pwm: rockchip: Avoid glitches on already running PWMs")
Signed-off-by: Simon South <simon@simonsouth.net>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-rockchip.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
index e6929bc739684..90f969f9f5e2b 100644
--- a/drivers/pwm/pwm-rockchip.c
+++ b/drivers/pwm/pwm-rockchip.c
@@ -351,7 +351,6 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
 
 	ret = pwmchip_add(&pc->chip);
 	if (ret < 0) {
-		clk_unprepare(pc->clk);
 		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
 		goto err_pclk;
 	}
-- 
2.27.0



