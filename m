Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639E355C31E
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235336AbiF0L2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235195AbiF0L1L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:27:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AB99FD9;
        Mon, 27 Jun 2022 04:27:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24688614C8;
        Mon, 27 Jun 2022 11:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF92C385A9;
        Mon, 27 Jun 2022 11:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329220;
        bh=t6YNsAmuGSN6G8yIXFXw38LmA8/sEUriDb7d86ArpoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1zJzIXbhC9Kf5CGpvpDr1D6LifgpIXQMbz1+aVA26fEUs2HXHVghDioxfBrz8Czae
         KPu3tEUvmqOsENd9bDMPMCAdx9+T2q6ACxkHpa9wuRQ+rciX0Sh2R3gRo+st2riEJV
         9NW13uI3EBFo3gAZB26w3wZ0Pzh2mMyhQa7SSR4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <khsieh@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/102] drm/msm/dp: promote irq_hpd handle to handle link training correctly
Date:   Mon, 27 Jun 2022 13:20:51 +0200
Message-Id: <20220627111934.660299951@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuogee Hsieh <khsieh@codeaurora.org>

[ Upstream commit 26b8d66a399e625f3aa2c02ccbab1bff2e00040c ]

Some dongles require link training done at irq_hpd request instead
of plugin request. This patch promote irq_hpd handler to handle link
training and setup hpd_state correctly.

Signed-off-by: Kuogee Hsieh <khsieh@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index d504cf68283a..f1f777baa2c4 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -476,10 +476,9 @@ static int dp_display_handle_irq_hpd(struct dp_display_private *dp)
 	sink_request = dp->link->sink_request;
 
 	if (sink_request & DS_PORT_STATUS_CHANGED) {
-		dp_add_event(dp, EV_USER_NOTIFICATION, false, 0);
 		if (dp_display_is_sink_count_zero(dp)) {
 			DRM_DEBUG_DP("sink count is zero, nothing to do\n");
-			return 0;
+			return -ENOTCONN;
 		}
 
 		return dp_display_process_hpd_high(dp);
@@ -496,7 +495,9 @@ static int dp_display_handle_irq_hpd(struct dp_display_private *dp)
 static int dp_display_usbpd_attention_cb(struct device *dev)
 {
 	int rc = 0;
+	u32 sink_request;
 	struct dp_display_private *dp;
+	struct dp_usbpd *hpd;
 
 	if (!dev) {
 		DRM_ERROR("invalid dev\n");
@@ -510,10 +511,26 @@ static int dp_display_usbpd_attention_cb(struct device *dev)
 		return -ENODEV;
 	}
 
+	hpd = dp->usbpd;
+
 	/* check for any test request issued by sink */
 	rc = dp_link_process_request(dp->link);
-	if (!rc)
-		dp_display_handle_irq_hpd(dp);
+	if (!rc) {
+		sink_request = dp->link->sink_request;
+		if (sink_request & DS_PORT_STATUS_CHANGED) {
+			/* same as unplugged */
+			hpd->hpd_high = 0;
+			dp->hpd_state = ST_DISCONNECT_PENDING;
+			dp_add_event(dp, EV_USER_NOTIFICATION, false, 0);
+		}
+
+		rc = dp_display_handle_irq_hpd(dp);
+
+		if (!rc && (sink_request & DS_PORT_STATUS_CHANGED)) {
+			hpd->hpd_high = 1;
+			dp->hpd_state = ST_CONNECT_PENDING;
+		}
+	}
 
 	return rc;
 }
-- 
2.35.1



