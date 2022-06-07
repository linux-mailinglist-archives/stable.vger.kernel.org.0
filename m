Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B037F5406C7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347225AbiFGRiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347758AbiFGRfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:35:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B6B10A606;
        Tue,  7 Jun 2022 10:31:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E49F9B82285;
        Tue,  7 Jun 2022 17:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380F7C385A5;
        Tue,  7 Jun 2022 17:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623077;
        bh=cOVRoMh2dOk7ICQ8DdAnJhhYMLLUDecgkUZ1B1A+j5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wUyQJr1UAH/pmxgDG4Syjk9wK2Wb48asdzRRDklMg+46Fe6hdCbY/ifzREzHsR93/
         7YFPZs1Waq4PsChZ1T01OLYaXLkomDwpzSWbikLge/CYlasczZDtIz1v4JNioDTpEv
         H3nJrjaic8d2iEl0nUP7N3m1wQkhFsYp6tdKS9pY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Lv Ruyi <lv.ruyi@zte.com.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 285/452] mfd: ipaq-micro: Fix error check return value of platform_get_irq()
Date:   Tue,  7 Jun 2022 19:02:22 +0200
Message-Id: <20220607164917.043560760@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

[ Upstream commit 3b49ae380ce1a3054e0c505dd9a356b82a5b48e8 ]

platform_get_irq() return negative value on failure, so null check of
irq is incorrect. Fix it by comparing whether it is less than zero.

Fixes: dcc21cc09e3c ("mfd: Add driver for Atmel Microcontroller on iPaq h3xxx")
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20220412085305.2533030-1-lv.ruyi@zte.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/ipaq-micro.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ipaq-micro.c b/drivers/mfd/ipaq-micro.c
index e92eeeb67a98..4cd5ecc72211 100644
--- a/drivers/mfd/ipaq-micro.c
+++ b/drivers/mfd/ipaq-micro.c
@@ -403,7 +403,7 @@ static int __init micro_probe(struct platform_device *pdev)
 	micro_reset_comm(micro);
 
 	irq = platform_get_irq(pdev, 0);
-	if (!irq)
+	if (irq < 0)
 		return -EINVAL;
 	ret = devm_request_irq(&pdev->dev, irq, micro_serial_isr,
 			       IRQF_SHARED, "ipaq-micro",
-- 
2.35.1



