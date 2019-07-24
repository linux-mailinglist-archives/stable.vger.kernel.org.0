Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 081D573F07
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388714AbfGXTcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388712AbfGXTcu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:32:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ADAB2238C;
        Wed, 24 Jul 2019 19:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996769;
        bh=1xrh3G+on1NI23elo0OivcqzZrW+sUcSvTTavWdAs6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MAPqS0XPrBMb7y/nApHqDhVkVTmqWUp9k0M8NLM7gCRAxMM3S6C10BhQew3yGXT8X
         pj3lHukY/6nXrgeYuAjdHXMjLPlKDZTDW/SlHEttS+Hd5bm/HBZXRMJL2YIJ2/Z2qo
         TKp6lqXp1yfbBwmC0fNAZWjny2Yde/7xUfPqQhlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 169/413] clocksource/drivers/tegra: Restore base address before cleanup
Date:   Wed, 24 Jul 2019 21:17:40 +0200
Message-Id: <20190724191747.077384807@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fc9babc2574691d3bbf0428f007b22261fed55c6 ]

We're adjusting the timer's base for each per-CPU timer to point to the
actual start of the timer since device-tree defines a compound registers
range that includes all of the timers. In this case the original base
need to be restore before calling iounmap to unmap the proper address.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-tegra20.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clocksource/timer-tegra20.c b/drivers/clocksource/timer-tegra20.c
index fe5cc0963ac9..462be34b41c4 100644
--- a/drivers/clocksource/timer-tegra20.c
+++ b/drivers/clocksource/timer-tegra20.c
@@ -319,6 +319,8 @@ static int __init tegra_init_timer(struct device_node *np)
 			irq_dispose_mapping(cpu_to->clkevt.irq);
 		}
 	}
+
+	to->of_base.base = timer_reg_base;
 out:
 	timer_of_cleanup(to);
 	return ret;
-- 
2.20.1



