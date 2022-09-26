Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4BD5EA1F0
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237009AbiIZLAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237280AbiIZK7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:59:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B375C968;
        Mon, 26 Sep 2022 03:30:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2613EB8094F;
        Mon, 26 Sep 2022 10:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C377C43145;
        Mon, 26 Sep 2022 10:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188226;
        bh=TPTqPH8lO4PrEtCqgz7vLf7xXCtNmo5sVkmCqzTcWpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sP1pscyow0sAFomdZ6nOljMV74w7KL1vlQA+yHwRihmIWEYr7YmbTKV3/p7GebeuG
         G9pt8PIRGFtRV5ByjDnCBCYTsbDXmG9daeL+Ox6BeW8jsyyQ5J8SfqMAXuOSIntkWu
         ahj05juouLmItWAkHGsAFUbwwn78zKhyeAyMnwsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Schocher <hs@denx.de>,
        Fabio Estevam <festevam@denx.de>, Marek Vasut <marex@denx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/141] drm/panel: simple: Fix innolux_g121i1_l01 bus_format
Date:   Mon, 26 Sep 2022 12:11:47 +0200
Message-Id: <20220926100757.391528875@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
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
index bf2c845ef3a2..b7b37082a9d7 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2201,7 +2201,7 @@ static const struct panel_desc innolux_g121i1_l01 = {
 		.enable = 200,
 		.disable = 20,
 	},
-	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,
+	.bus_format = MEDIA_BUS_FMT_RGB666_1X7X3_SPWG,
 	.connector_type = DRM_MODE_CONNECTOR_LVDS,
 };
 
-- 
2.35.1



