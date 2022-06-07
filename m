Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF0E541311
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357770AbiFGTzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358640AbiFGTws (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:52:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CCD37A31;
        Tue,  7 Jun 2022 11:21:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C06E460DDA;
        Tue,  7 Jun 2022 18:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD751C385A2;
        Tue,  7 Jun 2022 18:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626110;
        bh=wWRjEqG2Y+DWTjc/55XtqJj8VE6UoC3O30TEATDi1+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1S0mVG/sUPNdh7IdfeIzWq0JvVBZDL5nA9ApTPlgvU0PFOiz5dm/vzZvw6gBFj+5
         x77Zy2j/KH88qHVO73bW7YOHwyBfDdlSHlwy5jgpvemZbCWGM6v1q8pmLvGdU1rzy5
         Pn2TuYwjNNsNwotlwqM7JKlButTYgcUuGoROY8TU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Lv Ruyi <lv.ruyi@zte.com.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 262/772] ixp4xx_eth: fix error check return value of platform_get_irq()
Date:   Tue,  7 Jun 2022 18:57:34 +0200
Message-Id: <20220607164956.744179188@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

[ Upstream commit f45ba67eb74ab4b775616af731bdf8944afce3f1 ]

platform_get_irq() return negative value on failure, so null check of
return value is incorrect. Fix it by comparing whether it is less than
zero.

Fixes: 9055a2f59162 ("ixp4xx_eth: make ptp support a platform driver")
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220412085126.2532924-1-lv.ruyi@zte.com.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xscale/ptp_ixp46x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xscale/ptp_ixp46x.c b/drivers/net/ethernet/xscale/ptp_ixp46x.c
index 39234852e01b..20f6aa508003 100644
--- a/drivers/net/ethernet/xscale/ptp_ixp46x.c
+++ b/drivers/net/ethernet/xscale/ptp_ixp46x.c
@@ -272,7 +272,7 @@ static int ptp_ixp_probe(struct platform_device *pdev)
 	ixp_clock.master_irq = platform_get_irq(pdev, 0);
 	ixp_clock.slave_irq = platform_get_irq(pdev, 1);
 	if (IS_ERR(ixp_clock.regs) ||
-	    !ixp_clock.master_irq || !ixp_clock.slave_irq)
+	    ixp_clock.master_irq < 0 || ixp_clock.slave_irq < 0)
 		return -ENXIO;
 
 	ixp_clock.caps = ptp_ixp_caps;
-- 
2.35.1



