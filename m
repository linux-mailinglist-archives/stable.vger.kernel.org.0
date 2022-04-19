Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6380C507774
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244537AbiDSSRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356474AbiDSSRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:17:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2293C3E5F4;
        Tue, 19 Apr 2022 11:12:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5CCFB818EE;
        Tue, 19 Apr 2022 18:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB51AC385A7;
        Tue, 19 Apr 2022 18:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650391966;
        bh=/gJsLD6N+b5xNTzzF4Bzt0cAnW+Ky2AHaiBFQ8+lpCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EfifMF0Ph8Cg41DkvZVkGPYBaTukJE5rHLlLVeq0BiOl35MmGEoiWxYQR0Xv3b46o
         vjdXgq57pu9Uf89/TMsHzMX2QZOLsYDCzDlZRjiffJr7sDChhdH78HvpPhXDTTeMdE
         l915aigEKCDracK8/kfsY09R6afNOS5gFQTUgjSgq0Dapzi0JjzrMpC0ETlsDQdNpw
         ck0i0Y9Hiu8twP8k2BrJEk3pGlHVi9UoYhU5Q6UbLj7iBqVmk34H3KYef2XoUPg2sj
         olX1HZFld4mkkyZVt5Mi3S+dXQhJRD9m5BlNkqTNgM9vof8f+44mKB0ij2hxtYeH0I
         1IzbJm32G6pFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 02/27] reset: renesas: Check return value of reset_control_deassert()
Date:   Tue, 19 Apr 2022 14:12:17 -0400
Message-Id: <20220419181242.485308-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181242.485308-1-sashal@kernel.org>
References: <20220419181242.485308-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit da18980a855edf44270f05455e0ec3f2472f64cc ]

Deasserting the reset is vital, therefore bail out in case of error.

Suggested-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/b2131908-0110-006b-862f-080517f3e2d8@gmail.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-rzg2l-usbphy-ctrl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/reset/reset-rzg2l-usbphy-ctrl.c b/drivers/reset/reset-rzg2l-usbphy-ctrl.c
index 1e8315038850..a8dde4606360 100644
--- a/drivers/reset/reset-rzg2l-usbphy-ctrl.c
+++ b/drivers/reset/reset-rzg2l-usbphy-ctrl.c
@@ -121,7 +121,9 @@ static int rzg2l_usbphy_ctrl_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(priv->rstc),
 				     "failed to get reset\n");
 
-	reset_control_deassert(priv->rstc);
+	error = reset_control_deassert(priv->rstc);
+	if (error)
+		return error;
 
 	priv->rcdev.ops = &rzg2l_usbphy_ctrl_reset_ops;
 	priv->rcdev.of_reset_n_cells = 1;
-- 
2.35.1

