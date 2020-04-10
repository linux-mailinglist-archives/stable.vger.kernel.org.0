Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2638A1A416D
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 06:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgDJECU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 00:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727007AbgDJDrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:47:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47E3620A8B;
        Fri, 10 Apr 2020 03:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490427;
        bh=C342YGSxZ7cHTwUi8UWJoDuCX2Aj+5ytjAAcmtQ8Fzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVIrxrJrLjE1Q14OWXSKEJT9xoA1ibX+G+P5kAR+X+y4kABosZsm74LemNdBPFfNf
         jXb2JT+TWUGYercvjy3sviAUxy+h1NTIAaxyzqi571Mq6P21uNywg9qzSieAY9VptS
         i77MOC0fpQdbMMZh2G6b6cU4LttG5Xy0gE2zRero=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 26/68] clocksource/drivers/timer-microchip-pit64b: Fix rate for gck
Date:   Thu,  9 Apr 2020 23:45:51 -0400
Message-Id: <20200410034634.7731-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034634.7731-1-sashal@kernel.org>
References: <20200410034634.7731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 0585244523f0f4de7e4480375e871617a79cab98 ]

Generic clock rate needs to be set in case it was selected as timer clock
source in mchp_pit64b_init_mode(). Otherwise it will be enabled with wrong
rate.

Fixes: 625022a5f160 ("clocksource/drivers/timer-microchip-pit64b: Add Microchip PIT64B support")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/1584352376-32585-1-git-send-email-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-microchip-pit64b.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/timer-microchip-pit64b.c b/drivers/clocksource/timer-microchip-pit64b.c
index bd63d3484838a..59e11ca8ee73e 100644
--- a/drivers/clocksource/timer-microchip-pit64b.c
+++ b/drivers/clocksource/timer-microchip-pit64b.c
@@ -264,6 +264,7 @@ static int __init mchp_pit64b_init_mode(struct mchp_pit64b_timer *timer,
 
 	if (!best_diff) {
 		timer->mode |= MCHP_PIT64B_MR_SGCLK;
+		clk_set_rate(timer->gclk, gclk_round);
 		goto done;
 	}
 
-- 
2.20.1

