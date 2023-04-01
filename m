Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2103A6D2CE0
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbjDABo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbjDABnv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:43:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A015022219;
        Fri, 31 Mar 2023 18:43:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 003A562CEF;
        Sat,  1 Apr 2023 01:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B734C4339B;
        Sat,  1 Apr 2023 01:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313370;
        bh=yERQUqiGn9anUkbxhnMbdjm1L9VY9JBDcH1uL2RINgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BueEeOiq98ITPYU/b7dWOcB5zp3h8tdFBDA5vEQlyAH66xR1Iq925tFBbs1xF+Z1d
         B8s4y9QsYZUyZPmm/ZApfPVlzVaoNyhJElqRQCLrBUbTtfxY+ZPPYKEp1LHDqW9kvI
         WjBSSQqcgE6e+8U2R1JndycPkF+x5ASdk+xhrgOTgo8wGL4wVkZVPgLFKpIY1E7pjn
         Zr/Urg82bT5VGRqf2WVsevAFtMwk/FfKSVPCh0W9jmujR8U0GECdYVKa8lm7+CEybM
         ZJk3C4pkYzuV39FeSSbwtOSEemcq0RSqvZPMpoOSXaOOzoNc+0Gt6vYhQkkojI5XVX
         LxIru2Z0EGdRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Denis Arefev <arefev@swemel.ru>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, sre@kernel.org, wens@csie.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 05/24] power: supply: axp288_fuel_gauge: Added check for negative values
Date:   Fri, 31 Mar 2023 21:42:21 -0400
Message-Id: <20230401014242.3356780-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014242.3356780-1-sashal@kernel.org>
References: <20230401014242.3356780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Arefev <arefev@swemel.ru>

[ Upstream commit bf6c880d5d1448489ebf92e2d13d5713ff644930 ]

Variable 'pirq', which may receive negative value
in platform_get_irq().
Used as an index in a function regmap_irq_get_virq().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Denis Arefev <arefev@swemel.ru>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/axp288_fuel_gauge.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/power/supply/axp288_fuel_gauge.c b/drivers/power/supply/axp288_fuel_gauge.c
index 8e6f8a6550790..05f4131784629 100644
--- a/drivers/power/supply/axp288_fuel_gauge.c
+++ b/drivers/power/supply/axp288_fuel_gauge.c
@@ -724,6 +724,8 @@ static int axp288_fuel_gauge_probe(struct platform_device *pdev)
 
 	for (i = 0; i < AXP288_FG_INTR_NUM; i++) {
 		pirq = platform_get_irq(pdev, i);
+		if (pirq < 0)
+			continue;
 		ret = regmap_irq_get_virq(axp20x->regmap_irqc, pirq);
 		if (ret < 0)
 			return dev_err_probe(dev, ret, "getting vIRQ %d\n", pirq);
-- 
2.39.2

