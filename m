Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037533D5D9F
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbhGZPCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:02:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235539AbhGZPC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:02:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95B9460F22;
        Mon, 26 Jul 2021 15:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314174;
        bh=l0Cw9TsyCc7qYbac/t7+DIPSgHI2IXBGitlxGGgv+sY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aeQWsIhiBJ2WWuvyEjIrntHRvi4rcsmEVWA84B1NBNRdY2CG8ZSP9jHz+Z3IBz/Ws
         4F+DK8Mo5E6eaHg7CER8zjndyekG+qW10j9jxfaHEprRI3ghBril26M7DgOtaPgoKu
         17BaWKjTJa4ErQc73F3VPSMhugUgKYjKQaG/g/AE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 12/60] rtc: max77686: Do not enforce (incorrect) interrupt trigger type
Date:   Mon, 26 Jul 2021 17:38:26 +0200
Message-Id: <20210726153825.256241677@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153824.868160836@linuxfoundation.org>
References: <20210726153824.868160836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 742b0d7e15c333303daad4856de0764f4bc83601 ]

Interrupt line can be configured on different hardware in different way,
even inverted.  Therefore driver should not enforce specific trigger
type - edge falling - but instead rely on Devicetree to configure it.

The Maxim 77686 datasheet describes the interrupt line as active low
with a requirement of acknowledge from the CPU therefore the edge
falling is not correct.

The interrupt line is shared between PMIC and RTC driver, so using level
sensitive interrupt is here especially important to avoid races.  With
an edge configuration in case if first PMIC signals interrupt followed
shortly after by the RTC, the interrupt might not be yet cleared/acked
thus the second one would not be noticed.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210526172036.183223-6-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-max77686.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index 182fdd00e290..ecd61573dd31 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -718,8 +718,8 @@ static int max77686_init_rtc_regmap(struct max77686_rtc_info *info)
 
 add_rtc_irq:
 	ret = regmap_add_irq_chip(info->rtc_regmap, info->rtc_irq,
-				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
-				  IRQF_SHARED, 0, info->drv_data->rtc_irq_chip,
+				  IRQF_ONESHOT | IRQF_SHARED,
+				  0, info->drv_data->rtc_irq_chip,
 				  &info->rtc_irq_data);
 	if (ret < 0) {
 		dev_err(info->dev, "Failed to add RTC irq chip: %d\n", ret);
-- 
2.30.2



