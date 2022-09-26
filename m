Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C4A5EA71B
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 15:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbiIZN1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 09:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234275AbiIZN0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 09:26:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43F775FD7;
        Mon, 26 Sep 2022 04:51:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4623AB80691;
        Mon, 26 Sep 2022 10:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE715C433D6;
        Mon, 26 Sep 2022 10:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189204;
        bh=8Av7/e3VDqxsQaUnOOUZQ42WRu1s+S3WKW+HmkedUAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1XVD2hoFZcviqgypLvLmQIycBKA9evZDEBI7SVH7381czKyb4C/5sUVKQy+PO1kA8
         dIzg0VNWwEcJ8zkXr4wCuR4Zf2EecuebSjPxnMoO/8HHkbDsVmS2fqwB/wf+Uhb1c2
         GxjFvGhkb1CCtUy3/EmPCmCfSmfzRvIl/BksAZhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Schocher <hs@denx.de>,
        Fabio Estevam <festevam@denx.de>, Marek Vasut <marex@denx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 108/207] drm/panel: simple: Fix innolux_g121i1_l01 bus_format
Date:   Mon, 26 Sep 2022 12:11:37 +0200
Message-Id: <20220926100811.434576489@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Schocher <hs@denx.de>

[ Upstream commit a7c48a0ab87ae52c087d663e83e56b8225ac4cce ]

innolux_g121i1_l01 sets bpc to 6, so use the corresponding bus format:
MEDIA_BUS_FMT_RGB666_1X7X3_SPWG.

Fixes: 4ae13e486866 ("drm/panel: simple: Add more properties to Innolux G121I1-L01")
Signed-off-by: Heiko Schocher <hs@denx.de>
Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220826165021.1592532-1-festevam@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 4a2e580a2f7b..0e001ce8a40f 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2136,7 +2136,7 @@ static const struct panel_desc innolux_g121i1_l01 = {
 		.enable = 200,
 		.disable = 20,
 	},
-	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,
+	.bus_format = MEDIA_BUS_FMT_RGB666_1X7X3_SPWG,
 	.connector_type = DRM_MODE_CONNECTOR_LVDS,
 };
 
-- 
2.35.1



