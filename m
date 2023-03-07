Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B37D6AEA28
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjCGRbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjCGRax (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:30:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744C594397
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:26:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06B08614D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF89C433D2;
        Tue,  7 Mar 2023 17:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209973;
        bh=j3SsXPfit0k+7teO/+qymtnavDrv+NJw0Di82qu0viU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+QIjbiuR4HnYM+3k6d5dvAAcO6vS4oF9A3IKwNxEOPZ0AlQFlj+Xn+CECUsSdnNN
         m3CVRFlN3Kr8SM4qBzaZfJtvFurp12xcrwOazk/VOuokeJuvSkFT2Ye0XJBOrB/8YK
         Y9mmx35+gd668oXdSBfmiFfG4xvFjT7BVSPB4TTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0360/1001] drm/bridge: tc358767: Set default CLRSIPO count
Date:   Tue,  7 Mar 2023 17:52:12 +0100
Message-Id: <20230307170037.047713793@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 01338bb82fed40a6a234c2b36a92367c8671adf0 ]

The current CLRSIPO count is still marginal and does not work with high
DSI clock rates in burst mode. Increase it further to allow the DSI link
to work at up to 1Gbps lane speed. This returns the counts to defaults
as provided by datasheet.

Fixes: ea6490b02240b ("drm/bridge: tc358767: increase CLRSIPO count")
Signed-off-by: Marek Vasut <marex@denx.de>
Acked-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20221016003556.406441-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358767.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/tc358767.c b/drivers/gpu/drm/bridge/tc358767.c
index 2a58eb271f701..b9b681086fc49 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -1264,10 +1264,10 @@ static int tc_dsi_rx_enable(struct tc_data *tc)
 	u32 value;
 	int ret;
 
-	regmap_write(tc->regmap, PPI_D0S_CLRSIPOCOUNT, 5);
-	regmap_write(tc->regmap, PPI_D1S_CLRSIPOCOUNT, 5);
-	regmap_write(tc->regmap, PPI_D2S_CLRSIPOCOUNT, 5);
-	regmap_write(tc->regmap, PPI_D3S_CLRSIPOCOUNT, 5);
+	regmap_write(tc->regmap, PPI_D0S_CLRSIPOCOUNT, 25);
+	regmap_write(tc->regmap, PPI_D1S_CLRSIPOCOUNT, 25);
+	regmap_write(tc->regmap, PPI_D2S_CLRSIPOCOUNT, 25);
+	regmap_write(tc->regmap, PPI_D3S_CLRSIPOCOUNT, 25);
 	regmap_write(tc->regmap, PPI_D0S_ATMR, 0);
 	regmap_write(tc->regmap, PPI_D1S_ATMR, 0);
 	regmap_write(tc->regmap, PPI_TX_RX_TA, TTA_GET | TTA_SURE);
-- 
2.39.2



