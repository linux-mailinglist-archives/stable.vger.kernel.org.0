Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C492150772B
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356220AbiDSSOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356221AbiDSSOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:14:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620F83878F;
        Tue, 19 Apr 2022 11:11:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9C4AECE188A;
        Tue, 19 Apr 2022 18:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EB1C385A5;
        Tue, 19 Apr 2022 18:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650391876;
        bh=/gJsLD6N+b5xNTzzF4Bzt0cAnW+Ky2AHaiBFQ8+lpCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVRqpXpmRbqJgtuYo7dadVuPKvZrOOf/tZpD5HIENgBei1DK9IQ7z9HPR7ZNDYHEF
         iHb0JatwPInqqNVXoIWOBUq7IYSGaOOLoJFpfPe4yMmbvAsTUmhRIpyLoJZzr5XPxE
         MA7RQdtZ0ANAK5H+xyPdCaMvpoBXhZ5cnPJM+Dmd3+HlJ6CefZrfhAqDvEEwih3k7I
         T8KJilA0yyODWHU4BKQS6MM2/Anxfu7DCBypXtl762+GccN+DnlUJ5fR0JNwOhCQ+L
         tjwx3+mkJG8GGh9C1pC4wz7Q3NkhvQ9dpY2rpImjEpBPGezvbp49uqFcrGiXp4WmaH
         +qZwnLKPx0y2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.17 04/34] reset: renesas: Check return value of reset_control_deassert()
Date:   Tue, 19 Apr 2022 14:10:31 -0400
Message-Id: <20220419181104.484667-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181104.484667-1-sashal@kernel.org>
References: <20220419181104.484667-1-sashal@kernel.org>
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

