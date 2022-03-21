Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5524E28B5
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348440AbiCUOAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348995AbiCUN6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:58:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263BE17336B;
        Mon, 21 Mar 2022 06:56:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8780611CF;
        Mon, 21 Mar 2022 13:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4657C340E8;
        Mon, 21 Mar 2022 13:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871018;
        bh=9JTt34aHZeSuDuvlZZThhxWsuMi1zHKindJey8xLQd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITXrwND0OqGfPFPonDBnQJIO3dhsxN/z6PZ/qQGjnKt0iwUf7iGTlI1ITddNXXjrQ
         YzpClG6vwfnptVYg+JPXhBQZWGcABfzbMyGGHh2v7V8TcQItJNGAMBvLaep4XOzZL1
         9sXFgV7zVWxWxgoKmlXsrY+nO7uDgc7bpQ4km5oM=
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
Subject: [PATCH 4.19 51/57] drm/panel: simple: Fix Innolux G070Y2-L01 BPP settings
Date:   Mon, 21 Mar 2022 14:52:32 +0100
Message-Id: <20220321133223.465843785@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
References: <20220321133221.984120927@linuxfoundation.org>
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
index 8814aa38c5e7..a424afdcc77a 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1244,7 +1244,7 @@ static const struct display_timing innolux_g070y2_l01_timing = {
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



