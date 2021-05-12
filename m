Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C2337C46C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbhELPaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235135AbhELP0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:26:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 056A0613FC;
        Wed, 12 May 2021 15:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832305;
        bh=kP8zmwsYpphptjHlMFc5rFpOQQ2vW/p1l6FVVnGVhwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wAKJGYYQupC6jOqX4R1Zbu/o+T852lA0JhEK4pCfqknsyueB7C/WUmIQ4edCumgLx
         EkXUoiKevLheLhCr4kC1TI3XKZp4Tsx/zvzCkqy2IT6hLtsYVT55tvhZUocPyqqQsq
         u+7x22ab58C1FR8c9HFqZIr8DMqs+op80a9y7u20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 218/530] clocksource/drivers/ingenic_ost: Fix return value check in ingenic_ost_probe()
Date:   Wed, 12 May 2021 16:45:28 +0200
Message-Id: <20210512144826.999564855@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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



