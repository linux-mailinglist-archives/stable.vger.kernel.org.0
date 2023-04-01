Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8CB6D2C92
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbjDABlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbjDABll (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:41:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3361EFD6;
        Fri, 31 Mar 2023 18:41:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B96F4B832E8;
        Sat,  1 Apr 2023 01:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743C4C433EF;
        Sat,  1 Apr 2023 01:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313297;
        bh=yERQUqiGn9anUkbxhnMbdjm1L9VY9JBDcH1uL2RINgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYBRqeBkxzG6zhRPtL7m6dWT6EmXiZURuW2VsG/EQNjjVyuQBfP9An6Vxk4O9aYOd
         hit3JU3PFh3KSZLFa+1KezNmR98VYysoT0vQzihcj9MCgEMXQEDjmgFSLhkXPIcRJ5
         cPS9Hc3YFL1dw9KV9a3KlXBefO+pyaJnwjWrJSdsmIqWIYgSVW7vZ+hOiCGzk2C8Uc
         2QdqsiYRYESHH0uwThNb7fktpT0kZ9p6ZlZ4E2wvLioLhGLBz0DvXUzt12W69NAuTV
         TjF75erLPZLoHhqHFiN2Ispd7NS8OGjeccdBjePDYwYtqvFXXUVIskupjAlXsO5XkY
         Jqb8Gfrx01KdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Denis Arefev <arefev@swemel.ru>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, sre@kernel.org, wens@csie.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 06/25] power: supply: axp288_fuel_gauge: Added check for negative values
Date:   Fri, 31 Mar 2023 21:41:04 -0400
Message-Id: <20230401014126.3356410-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014126.3356410-1-sashal@kernel.org>
References: <20230401014126.3356410-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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

