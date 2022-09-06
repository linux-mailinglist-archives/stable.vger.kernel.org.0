Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250D75AEBC6
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240667AbiIFOAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240831AbiIFN6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:58:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BBD82D37;
        Tue,  6 Sep 2022 06:42:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C4CFDCE177D;
        Tue,  6 Sep 2022 13:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FE2C433D7;
        Tue,  6 Sep 2022 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471706;
        bh=8+kkAUlsHO/yNF6tJQWKq9mQcwOhlQDepvOfdAU3qdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+SHG0PnH2chNhfJiTJjc5h9YM8S0S1Bcg6+TVOQW1p/L3lpOGgQ6/LCAWOtCPU+K
         pNG7RBuIo1LMbzU3A/+JZFqcsJ/+uP/2ihQPzH3H3IL6iw5/hDQDHpVjhn1uU2dQzm
         FW66Dh8vptJxkBRVAHsjfieGvw5RrgCVe6EK+PSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Lv Ruyi <lv.ruyi@zte.com.cn>,
        Iwona Winiarska <iwona.winiarska@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 011/155] peci: aspeed: fix error check return value of platform_get_irq()
Date:   Tue,  6 Sep 2022 15:29:19 +0200
Message-Id: <20220906132829.913662661@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

[ Upstream commit e79b548b7202bb3accdfe64f113129a4340bc2f9 ]

platform_get_irq() return negative value on failure, so null check of
priv->irq is incorrect. Fix it by comparing whether it is less than zero.

Fixes: a85e4c52086c ("peci: Add peci-aspeed controller driver")
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Link: https://lore.kernel.org/r/20220413010425.2534887-1-lv.ruyi@zte.com.cn
Reviewed-by: Iwona Winiarska <iwona.winiarska@intel.com>
Signed-off-by: Iwona Winiarska <iwona.winiarska@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/peci/controller/peci-aspeed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/peci/controller/peci-aspeed.c b/drivers/peci/controller/peci-aspeed.c
index 1925ddc13f002..731c5d8f75c66 100644
--- a/drivers/peci/controller/peci-aspeed.c
+++ b/drivers/peci/controller/peci-aspeed.c
@@ -523,7 +523,7 @@ static int aspeed_peci_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->base);
 
 	priv->irq = platform_get_irq(pdev, 0);
-	if (!priv->irq)
+	if (priv->irq < 0)
 		return priv->irq;
 
 	ret = devm_request_irq(&pdev->dev, priv->irq, aspeed_peci_irq_handler,
-- 
2.35.1



