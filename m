Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F1F4CF734
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238216AbiCGJo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241148AbiCGJl4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCCC60FC;
        Mon,  7 Mar 2022 01:40:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3884B810B2;
        Mon,  7 Mar 2022 09:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA07C340F3;
        Mon,  7 Mar 2022 09:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646046;
        bh=vvaTcHyj7TRMBBCsqCwDzydb6UBT3bjKyJ+9yqUkG6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJ2KFavxBczo9sQxqZs2tP4v7BXG9fbTC/+rTnPgiUM4eAbSzaAlQ/jlptqVzDmA4
         45Be+l5K3i242fPcUZzwjR7L2cYbzyWYG/xfjO8v6Hktwth/8/JmWhKkAPq0DgicQt
         BvdCrErU5aU6w7i5I4vLdUQwF/O88MkRT3L9WC1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Kepplinger <martink@posteo.de>,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Stefan Agner <stefan@agner.ch>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/262] drm: mxsfb: Set fallback bus format when the bridge doesnt provide one
Date:   Mon,  7 Mar 2022 10:17:39 +0100
Message-Id: <20220307091705.713819381@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guido Günther <agx@sigxcpu.org>

[ Upstream commit 1db060509903b29d63fe2e39c14fd0f99c4a447e ]

If a bridge doesn't do any bus format handling MEDIA_BUS_FMT_FIXED is
returned. Fallback to a reasonable default (MEDIA_BUS_FMT_RGB888_1X24) in
that case.

This unbreaks e.g. using mxsfb with the nwl bridge and mipi dsi panels.

Reported-by: Martin Kepplinger <martink@posteo.de>
Signed-off-by: Guido Günther <agx@sigxcpu.org>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Stefan Agner <stefan@agner.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/781f0352052cc50c823c199ef5f53c84902d0580.1633959458.git.agx@sigxcpu.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mxsfb/mxsfb_kms.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/mxsfb/mxsfb_kms.c b/drivers/gpu/drm/mxsfb/mxsfb_kms.c
index 89dd618d78f31..b96ba348c68d9 100644
--- a/drivers/gpu/drm/mxsfb/mxsfb_kms.c
+++ b/drivers/gpu/drm/mxsfb/mxsfb_kms.c
@@ -362,6 +362,12 @@ static void mxsfb_crtc_atomic_enable(struct drm_crtc *crtc,
 			drm_atomic_get_new_bridge_state(state,
 							mxsfb->bridge);
 		bus_format = bridge_state->input_bus_cfg.format;
+		if (bus_format == MEDIA_BUS_FMT_FIXED) {
+			dev_warn_once(drm->dev,
+				      "Bridge does not provide bus format, assuming MEDIA_BUS_FMT_RGB888_1X24.\n"
+				      "Please fix bridge driver by handling atomic_get_input_bus_fmts.\n");
+			bus_format = MEDIA_BUS_FMT_RGB888_1X24;
+		}
 	}
 
 	/* If there is no bridge, use bus format from connector */
-- 
2.34.1



