Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A2F37C8A0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbhELQLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:11:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238646AbhELQFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:05:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A4C66194D;
        Wed, 12 May 2021 15:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833691;
        bh=kP8zmwsYpphptjHlMFc5rFpOQQ2vW/p1l6FVVnGVhwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5DSVbZmxFaqrR51UMHYohVV7pSdUzLUUPlO/SnSLROSVk7h8XTLuzpCzzHaH+zLl
         svsyA8DZsGBmhVlYKyqq2H8WC1DhwtyyTi7nAq1R0CHEihVCSwVEyQxj95DTkV7cZK
         RKZgPByzDPuZrTv1pmL9GagP/5sYaJp4K8NXxXcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 249/601] clocksource/drivers/ingenic_ost: Fix return value check in ingenic_ost_probe()
Date:   Wed, 12 May 2021 16:45:26 +0200
Message-Id: <20210512144836.029449203@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 2a65f7e2772613debd03fa2492e76a635aa04545 ]

In case of error, the function device_node_to_regmap() returns
ERR_PTR() and never returns NULL. The NULL test in the return
value check should be replaced with IS_ERR().

Fixes: ca7b72b5a5f2 ("clocksource: Add driver for the Ingenic JZ47xx OST")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210308123031.2285083-1-weiyongjun1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/ingenic-ost.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/ingenic-ost.c b/drivers/clocksource/ingenic-ost.c
index 029efc2731b4..6af2470136bd 100644
--- a/drivers/clocksource/ingenic-ost.c
+++ b/drivers/clocksource/ingenic-ost.c
@@ -88,9 +88,9 @@ static int __init ingenic_ost_probe(struct platform_device *pdev)
 		return PTR_ERR(ost->regs);
 
 	map = device_node_to_regmap(dev->parent->of_node);
-	if (!map) {
+	if (IS_ERR(map)) {
 		dev_err(dev, "regmap not found");
-		return -EINVAL;
+		return PTR_ERR(map);
 	}
 
 	ost->clk = devm_clk_get(dev, "ost");
-- 
2.30.2



