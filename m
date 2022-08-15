Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52DDF59423C
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349284AbiHOVr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350233AbiHOVra (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:47:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D75B20BFA;
        Mon, 15 Aug 2022 12:31:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1931610A3;
        Mon, 15 Aug 2022 19:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7250C433D6;
        Mon, 15 Aug 2022 19:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591880;
        bh=UOH6REFJS8cP2N9uoUPHkUleTOhh+U4QEU+B7D5bc6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFFIlybauDg/ardgHNbMvLYzlOFR0uhbgsdKJVUeYpuvwSMhv3dqbKoEFLX3gAbB1
         DWKbVzpaVATnklPa289Dl/+9sbA6JktZao2EUBU58DGl+a6jcYoYbd9huOTZyCHxzc
         XniqxbFm3R5AW+avxZybqyQ8TaHxTuyqdTRq/vUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0693/1095] clk: qcom: camcc-sm8250: Fix halt on boot by reducing drivers init level
Date:   Mon, 15 Aug 2022 20:01:32 +0200
Message-Id: <20220815180458.050992029@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit c4f40351901a10cd662ac2c081396d8fb04f584d ]

Access to I/O of SM8250 camera clock controller IP depends on enabled
GCC_CAMERA_AHB_CLK clock supplied by global clock controller, the latter
one is inited on subsys level, so, to satisfy the dependency, it would
make sense to deprive the init level of camcc-sm8250 driver.

If both drivers are compiled as built-in, there is a change that a board
won't boot up due to a race, which happens on the same init level.

Fixes: 5d66ca79b58c ("clk: qcom: Add camera clock controller driver for SM8250")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220518103554.949511-1-vladimir.zapolskiy@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/camcc-sm8250.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/clk/qcom/camcc-sm8250.c b/drivers/clk/qcom/camcc-sm8250.c
index 439eaafdcc86..ae4e9774f36e 100644
--- a/drivers/clk/qcom/camcc-sm8250.c
+++ b/drivers/clk/qcom/camcc-sm8250.c
@@ -2440,17 +2440,7 @@ static struct platform_driver cam_cc_sm8250_driver = {
 	},
 };
 
-static int __init cam_cc_sm8250_init(void)
-{
-	return platform_driver_register(&cam_cc_sm8250_driver);
-}
-subsys_initcall(cam_cc_sm8250_init);
-
-static void __exit cam_cc_sm8250_exit(void)
-{
-	platform_driver_unregister(&cam_cc_sm8250_driver);
-}
-module_exit(cam_cc_sm8250_exit);
+module_platform_driver(cam_cc_sm8250_driver);
 
 MODULE_DESCRIPTION("QTI CAMCC SM8250 Driver");
 MODULE_LICENSE("GPL v2");
-- 
2.35.1



