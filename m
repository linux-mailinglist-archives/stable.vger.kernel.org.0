Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B76A6AEEFA
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbjCGSTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:19:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbjCGSTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:19:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A4394A44
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:13:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2F8261531
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E70C433EF;
        Tue,  7 Mar 2023 18:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212792;
        bh=zjQJ37wesTy5MfybzEGPsH7AYE1h686Zma0+dUjBrFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dBPladIBp5oS6NAavc+tWiOnqwwzNxRNCPUEcFbBT63SOWRrEDNt3CGG+Fy4EAJc/
         AYK8eaOL1bw02RWVl5OvivOMyLGL8+KGa9ZMLKovNyichyRx8AV+m8wlmTeyrmOlPe
         HNuVEpE94IFu/6ovennthw29PDzS7yyr3HH7AqUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 298/885] drm/bridge: lt9611: fix sleep mode setup
Date:   Tue,  7 Mar 2023 17:53:52 +0100
Message-Id: <20230307170015.024676034@linuxfoundation.org>
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

[ Upstream commit ae2d329f104b75a0a78dcaded29fe6283289cdf9 ]

On atomic_post_disable the bridge goes to the low power state. However
the code disables too much of the chip, so the HPD event is not being
detected and delivered to the host. Reduce the power saving in order to
get the HPD event.

Fixes: 23278bf54afe ("drm/bridge: Introduce LT9611 DSI to HDMI bridge")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230118081658.2198520-2-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt9611.c b/drivers/gpu/drm/bridge/lontium-lt9611.c
index 7c0a99173b39f..2714184cc53f4 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611.c
@@ -448,12 +448,11 @@ static void lt9611_sleep_setup(struct lt9611 *lt9611)
 		{ 0x8023, 0x01 },
 		{ 0x8157, 0x03 }, /* set addr pin as output */
 		{ 0x8149, 0x0b },
-		{ 0x8151, 0x30 }, /* disable IRQ */
+
 		{ 0x8102, 0x48 }, /* MIPI Rx power down */
 		{ 0x8123, 0x80 },
 		{ 0x8130, 0x00 },
-		{ 0x8100, 0x01 }, /* bandgap power down */
-		{ 0x8101, 0x00 }, /* system clk power down */
+		{ 0x8011, 0x0a },
 	};
 
 	regmap_multi_reg_write(lt9611->regmap,
-- 
2.39.2



