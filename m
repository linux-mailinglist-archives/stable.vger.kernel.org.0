Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209584ABB15
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344612AbiBGL0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348918AbiBGLLn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:11:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E915FC043188;
        Mon,  7 Feb 2022 03:11:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C01361261;
        Mon,  7 Feb 2022 11:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4724BC004E1;
        Mon,  7 Feb 2022 11:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232301;
        bh=SYEi1y8BNmjcAX9A5+V0ogtiPcy/9q3B6MvHlLxKGk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WnZG1YgOErxbBF1Dk099t81pYIVEbDO5AJBkJlxJ+52i0b0AzB8Cn/Duu3bTEe44P
         mxsU/vXVoAmITbjQzqUsvSkRC9QqoBZ8C9wQCBaaqBVR56G5rh56UUgeldoml9HXcl
         DkwlRXKiqNgLkdsn2ebq/N2f9fJmZTmjZiKI2sL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 4.14 33/69] drm/msm/dsi: invalid parameter check in msm_dsi_phy_enable
Date:   Mon,  7 Feb 2022 12:05:55 +0100
Message-Id: <20220207103756.718127401@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
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
@@ -554,12 +554,14 @@ void __exit msm_dsi_phy_driver_unregiste
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


