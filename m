Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCC2541A7C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379955AbiFGVdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380319AbiFGVam (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:30:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E69229B74;
        Tue,  7 Jun 2022 12:02:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86D3B617E4;
        Tue,  7 Jun 2022 19:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912E8C385A2;
        Tue,  7 Jun 2022 19:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628569;
        bh=brWqBySsTGrjDuMpp7++td+H+52jN/Qy6jJTsXAgFRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPccrwz6CTtiMyMEGTPe46Cn9Scf+7wFcvlacXKIxzOJ7JBHnag3uWlkjATh2ip+j
         7VXVM7BJ/O9TH2Wx9XYY+w1S93YCEJthv9c4jx8P5yw46ckLNiOnurysKdbypRWHwX
         72o4quSempaUuZTnNiFnobgBBE9coM5KkjXepUGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pin-Yen Lin <treapking@chromium.org>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 378/879] drm/bridge: it6505: Send DPCD SET_POWER to downstream
Date:   Tue,  7 Jun 2022 18:58:16 +0200
Message-Id: <20220607165013.842501152@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Pin-Yen Lin <treapking@chromium.org>

[ Upstream commit 46ca7da7f1e8592af6059419176dd58c10dcdb5b ]

Send DPCD SET_POWER command to downstream in .atomic_disable to make the
downstream monitor enter the power down mode, so the device suspend won't
be affected.

Fixes: b5c84a9edcd418 ("drm/bridge: add it6505 driver")
Signed-off-by: Pin-Yen Lin <treapking@chromium.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220425134424.1150965-1-treapking@chromium.org
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index f2f101220ade..c54664677172 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -737,8 +737,9 @@ static int it6505_drm_dp_link_probe(struct drm_dp_aux *aux,
 	return 0;
 }
 
-static int it6505_drm_dp_link_power_up(struct drm_dp_aux *aux,
-				       struct it6505_drm_dp_link *link)
+static int it6505_drm_dp_link_set_power(struct drm_dp_aux *aux,
+					struct it6505_drm_dp_link *link,
+					u8 mode)
 {
 	u8 value;
 	int err;
@@ -752,18 +753,20 @@ static int it6505_drm_dp_link_power_up(struct drm_dp_aux *aux,
 		return err;
 
 	value &= ~DP_SET_POWER_MASK;
-	value |= DP_SET_POWER_D0;
+	value |= mode;
 
 	err = drm_dp_dpcd_writeb(aux, DP_SET_POWER, value);
 	if (err < 0)
 		return err;
 
-	/*
-	 * According to the DP 1.1 specification, a "Sink Device must exit the
-	 * power saving state within 1 ms" (Section 2.5.3.1, Table 5-52, "Sink
-	 * Control Field" (register 0x600).
-	 */
-	usleep_range(1000, 2000);
+	if (mode == DP_SET_POWER_D0) {
+		/*
+		 * According to the DP 1.1 specification, a "Sink Device must
+		 * exit the power saving state within 1 ms" (Section 2.5.3.1,
+		 * Table 5-52, "Sink Control Field" (register 0x600).
+		 */
+		usleep_range(1000, 2000);
+	}
 
 	return 0;
 }
@@ -2624,7 +2627,8 @@ static enum drm_connector_status it6505_detect(struct it6505 *it6505)
 	if (it6505_get_sink_hpd_status(it6505)) {
 		it6505_aux_on(it6505);
 		it6505_drm_dp_link_probe(&it6505->aux, &it6505->link);
-		it6505_drm_dp_link_power_up(&it6505->aux, &it6505->link);
+		it6505_drm_dp_link_set_power(&it6505->aux, &it6505->link,
+					     DP_SET_POWER_D0);
 		it6505->auto_train_retry = AUTO_TRAIN_RETRY;
 
 		if (it6505->dpcd[0] == 0) {
@@ -2960,8 +2964,11 @@ static void it6505_bridge_atomic_disable(struct drm_bridge *bridge,
 
 	DRM_DEV_DEBUG_DRIVER(dev, "start");
 
-	if (it6505->powered)
+	if (it6505->powered) {
 		it6505_video_disable(it6505);
+		it6505_drm_dp_link_set_power(&it6505->aux, &it6505->link,
+					     DP_SET_POWER_D3);
+	}
 }
 
 static enum drm_connector_status
-- 
2.35.1



