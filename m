Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D949540A5B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351568AbiFGSUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352483AbiFGSRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A272B5C;
        Tue,  7 Jun 2022 10:52:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 351E0617DA;
        Tue,  7 Jun 2022 17:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41923C341C6;
        Tue,  7 Jun 2022 17:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624332;
        bh=CI/MtxwgI5IVM7ehBNFPpDX7BnncfnKUfr4cm/yfJ4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aDYCBl6MUFXoqA95OJQO8DOdQfLy75fhZS29KuAtI1kMO64nmPCrKCHzXwVd7SSEW
         r+HJVCBNyTvdZzyxaA83cFtwq2AkEISS7adaVCZ0+7+STcRnuR4yKnq5E3JLSC2KTu
         NndzQAvLPT09BHA8SqqDPYKq/2f1qvelvbmW3clM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 289/667] drm/msm/dp: fix event thread stuck in wait_event after kthread_stop()
Date:   Tue,  7 Jun 2022 18:59:14 +0200
Message-Id: <20220607164943.446548784@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Kuogee Hsieh <quic_khsieh@quicinc.com>

[ Upstream commit 2f9b5b3ae2eb625b75a898212a76f3b8c6d0d2b0 ]

Event thread supposed to exit from its while loop after kthread_stop().
However there may has possibility that event thread is pending in the
middle of wait_event due to condition checking never become true.
To make sure event thread exit its loop after kthread_stop(), this
patch OR kthread_should_stop() into wait_event's condition checking
so that event thread will exit its loop after kernal_stop().

Changes in v2:
--  correct spelling error at commit title

Changes in v3:
-- remove unnecessary parenthesis
-- while(1) to replace while (!kthread_should_stop())

Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: 570d3e5d28db ("drm/msm/dp: stop event kernel thread when DP unbind")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/484576/
Link: https://lore.kernel.org/r/1651595136-24312-1-git-send-email-quic_khsieh@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 00e7d9db6199..7b624191abf1 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -1069,15 +1069,20 @@ static int hpd_event_thread(void *data)
 
 	dp_priv = (struct dp_display_private *)data;
 
-	while (!kthread_should_stop()) {
+	while (1) {
 		if (timeout_mode) {
 			wait_event_timeout(dp_priv->event_q,
-				(dp_priv->event_pndx == dp_priv->event_gndx),
-						EVENT_TIMEOUT);
+				(dp_priv->event_pndx == dp_priv->event_gndx) ||
+					kthread_should_stop(), EVENT_TIMEOUT);
 		} else {
 			wait_event_interruptible(dp_priv->event_q,
-				(dp_priv->event_pndx != dp_priv->event_gndx));
+				(dp_priv->event_pndx != dp_priv->event_gndx) ||
+					kthread_should_stop());
 		}
+
+		if (kthread_should_stop())
+			break;
+
 		spin_lock_irqsave(&dp_priv->event_lock, flag);
 		todo = &dp_priv->event_list[dp_priv->event_gndx];
 		if (todo->delay) {
-- 
2.35.1



