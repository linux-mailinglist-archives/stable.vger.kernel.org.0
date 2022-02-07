Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337C14ABA88
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383873AbiBGLXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378265AbiBGLPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:15:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23900C0401E0;
        Mon,  7 Feb 2022 03:15:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9772B811A6;
        Mon,  7 Feb 2022 11:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D865BC340EB;
        Mon,  7 Feb 2022 11:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232518;
        bh=Q97Eg1yGWPuCM9Q3yh8qkEPnDzvSL2qN4yS7WFruiwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+t9UBK86FQVpWdAq9ox81mTfRKsKXRG9ukGTiFHpvQjrjsW3e1Y4zyGWMEhn/ZoJ
         t7+7k4ZnVisilCdHQMqOKR0E0+V7gJLcu5XBhuSRVxVS0q9Yjhq4Nwql5/vWRngOaS
         MoxqYw1mw0jrOL5lYX8XvwP/xX0SAt4IGr0rmYEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 4.19 36/86] drm/msm/dsi: invalid parameter check in msm_dsi_phy_enable
Date:   Mon,  7 Feb 2022 12:05:59 +0100
Message-Id: <20220207103758.713106289@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: José Expósito <jose.exposito89@gmail.com>

commit 5e761a2287234bc402ba7ef07129f5103bcd775c upstream.

The function performs a check on the "phy" input parameter, however, it
is used before the check.

Initialize the "dev" variable after the sanity check to avoid a possible
NULL pointer dereference.

Fixes: 5c8290284402b ("drm/msm/dsi: Split PHY drivers to separate files")
Addresses-Coverity-ID: 1493860 ("Null pointer dereference")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220116181844.7400-1-jose.exposito89@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
@@ -667,12 +667,14 @@ void __exit msm_dsi_phy_driver_unregiste
 int msm_dsi_phy_enable(struct msm_dsi_phy *phy, int src_pll_id,
 			struct msm_dsi_phy_clk_request *clk_req)
 {
-	struct device *dev = &phy->pdev->dev;
+	struct device *dev;
 	int ret;
 
 	if (!phy || !phy->cfg->ops.enable)
 		return -EINVAL;
 
+	dev = &phy->pdev->dev;
+
 	ret = dsi_phy_enable_resource(phy);
 	if (ret) {
 		dev_err(dev, "%s: resource enable failed, %d\n",


