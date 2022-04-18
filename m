Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0C1505920
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239958AbiDROQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343604AbiDROOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:14:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7299838786;
        Mon, 18 Apr 2022 06:12:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19449B80EC4;
        Mon, 18 Apr 2022 13:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAA4C385A1;
        Mon, 18 Apr 2022 13:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287529;
        bh=LpqM6oePim4exxIdXfgoXKwgQgXWjEEDgaXDQZkm/BQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvumhso2YawudUuli0cyOfeeLC6QTY/42PdoDp20bdGC5Eo3JxQqMDz+RsnRgB1JN
         hIgZrd3KyNIgrsQCDzv9ZcfGxWGBqB+u1sCT39nt0yDNIErVCusKBkepxLHfEtz6om
         xBYNtu7v4HaQh8j1bVkc1RrGbNGeYLV5qOlqpWKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 190/218] drm/imx: Fix memory leak in imx_pd_connector_get_modes
Date:   Mon, 18 Apr 2022 14:14:16 +0200
Message-Id: <20220418121206.717081148@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit bce81feb03a20fca7bbdd1c4af16b4e9d5c0e1d3 ]

Avoid leaking the display mode variable if of_get_drm_display_mode
fails.

Fixes: 76ecd9c9fb24 ("drm/imx: parallel-display: check return code from of_get_drm_display_mode()")
Addresses-Coverity-ID: 1443943 ("Resource leak")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20220108165230.44610-1-jose.exposito89@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/parallel-display.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imx/parallel-display.c b/drivers/gpu/drm/imx/parallel-display.c
index d796ada2a47a..924a11232b84 100644
--- a/drivers/gpu/drm/imx/parallel-display.c
+++ b/drivers/gpu/drm/imx/parallel-display.c
@@ -83,8 +83,10 @@ static int imx_pd_connector_get_modes(struct drm_connector *connector)
 		ret = of_get_drm_display_mode(np, &imxpd->mode,
 					      &imxpd->bus_flags,
 					      OF_USE_NATIVE_MODE);
-		if (ret)
+		if (ret) {
+			drm_mode_destroy(connector->dev, mode);
 			return ret;
+		}
 
 		drm_mode_copy(mode, &imxpd->mode);
 		mode->type |= DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED,
-- 
2.35.1



