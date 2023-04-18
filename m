Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33B46E6425
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbjDRMqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbjDRMqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:46:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B23B14F71
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:46:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A76C8633AF
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FD4C4339B;
        Tue, 18 Apr 2023 12:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821988;
        bh=yERQUqiGn9anUkbxhnMbdjm1L9VY9JBDcH1uL2RINgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQ3wQKJ+Luu2Gkx6f8dNCsNjbtBVQfuhEbdP+6xXXfWZqvnSQA24YxojkzyvQEbrZ
         gwrESEVocnrWYyMvU1iXSk9b3Qwp479Vozj3bjZlRnNEsMYd2l1hGUbeFi/W3JB/Xv
         okw3gemXcpfQSI7f8YtOGnjMSBvTrtGLSTKZJtHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Denis Arefev <arefev@swemel.ru>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/134] power: supply: axp288_fuel_gauge: Added check for negative values
Date:   Tue, 18 Apr 2023 14:22:10 +0200
Message-Id: <20230418120315.612198170@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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



