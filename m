Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06246AEEFD
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbjCGST3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbjCGSTK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:19:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB80799BD5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:13:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 555DB614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF67C433EF;
        Tue,  7 Mar 2023 18:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212801;
        bh=7W5jGb9b5LZt03E4If3VJss6LKD8D6n1PMG0qhaKjPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IYnYrN8dUlH9jw3SgZZPC8jRa8K6YKWEDU8QiLUA33OLwhJDZSv4F226/L9o78Gd6
         zR3IP+xxwDhqU32Z2g5nptOsMgMqfkTf+ryahAcA/QP56u3w+DRUxSbeeN6wQDmzPe
         Exi0TvtcIqPxSQGFnhPtNbllos5J83oRgDQjeReU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 301/885] drm/bridge: lt9611: fix programming of video modes
Date:   Tue,  7 Mar 2023 17:53:55 +0100
Message-Id: <20230307170015.164748182@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit ad188aa47edaa033a270e1a3efae43836ff47569 ]

Program the upper part of the hfront_porch into the proper register.

Fixes: 23278bf54afe ("drm/bridge: Introduce LT9611 DSI to HDMI bridge")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230118081658.2198520-5-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt9611.c b/drivers/gpu/drm/bridge/lontium-lt9611.c
index deb503ca956af..f377052a45a44 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611.c
@@ -187,7 +187,8 @@ static void lt9611_mipi_video_setup(struct lt9611 *lt9611,
 
 	regmap_write(lt9611->regmap, 0x8319, (u8)(hfront_porch % 256));
 
-	regmap_write(lt9611->regmap, 0x831a, (u8)(hsync_porch / 256));
+	regmap_write(lt9611->regmap, 0x831a, (u8)(hsync_porch / 256) |
+						((hfront_porch / 256) << 4));
 	regmap_write(lt9611->regmap, 0x831b, (u8)(hsync_porch % 256));
 }
 
-- 
2.39.2



