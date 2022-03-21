Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC174E28BE
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243558AbiCUOAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349213AbiCUN7u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:59:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4622529B;
        Mon, 21 Mar 2022 06:58:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D58CFB816D2;
        Mon, 21 Mar 2022 13:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3771C340E8;
        Mon, 21 Mar 2022 13:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871102;
        bh=bxKaI78TST9aNbXIOxncy2ZRjY5+Q4ivxya09cBs6XE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uu96r14uwG5phlaF6E8e3mpU1B/NtTuUsvjl6NWdNIZulTHmaYpiw29eB/OcTRvZ1
         vgfuWYmk192/MAXBLmPdYzeq7W86YiblFAkDIoSsuC9gAmOSGGAW5vGlhqUKOsxy1O
         q3ueftffgz415zSpnkrhsi8GMjgmQRYdt525QsRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sam Ravnborg <sam@ravnborg.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/17] drm/panel: simple: Fix Innolux G070Y2-L01 BPP settings
Date:   Mon, 21 Mar 2022 14:52:44 +0100
Message-Id: <20220321133217.397728564@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133217.148831184@linuxfoundation.org>
References: <20220321133217.148831184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit fc1b6ef7bfb3d1d4df868b1c3e0480cacda6cd81 ]

The Innolux G070Y2-L01 supports two modes of operation:
1) FRC=Low/NC ... MEDIA_BUS_FMT_RGB666_1X7X3_SPWG ... BPP=6
2) FRC=High ..... MEDIA_BUS_FMT_RGB888_1X7X4_SPWG ... BPP=8

Currently the panel description mixes both, BPP from 1) and bus
format from 2), which triggers a warning at panel-simple.c:615.

Pick the later, set bpp=8, fix the warning.

Fixes: a5d2ade627dca ("drm/panel: simple: Add support for Innolux G070Y2-L01")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Christoph Fritz <chf.fritz@googlemail.com>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Maxime Ripard <maxime@cerno.tech>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220220040718.532866-1-marex@denx.de
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index f0ea782df836..312a3c4e2331 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1619,7 +1619,7 @@ static const struct display_timing innolux_g070y2_l01_timing = {
 static const struct panel_desc innolux_g070y2_l01 = {
 	.timings = &innolux_g070y2_l01_timing,
 	.num_timings = 1,
-	.bpc = 6,
+	.bpc = 8,
 	.size = {
 		.width = 152,
 		.height = 91,
-- 
2.34.1



