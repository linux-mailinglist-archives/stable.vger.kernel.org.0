Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1FE409250
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245383AbhIMOKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:10:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344165AbhIMOIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:08:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0055613D0;
        Mon, 13 Sep 2021 13:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540450;
        bh=QHSNXY9dhwl7f2GDctk4VxjuLThwO2gejCHNTBgB+q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0uZjRNJXuktll29MQXg1cUcMPKJOCftn8cIpb3SASH60yOF07SVjggNiOoE/wq3F6
         uQ6aukX/71c7K9aijzVbrvtOlUNQ7bSK8wi9+UYuB3P1qRbQezqdPICXVz3J4Ki5Yo
         2DDVuXRAKcmPpl2MaiSf5N5fTFPmlgPKC4QC7ryw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <khsieh@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 166/300] drm/msm/dp: update is_connected status base on sink count at dp_pm_resume()
Date:   Mon, 13 Sep 2021 15:13:47 +0200
Message-Id: <20210913131115.022433777@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuogee Hsieh <khsieh@codeaurora.org>

[ Upstream commit e8a767e04dbc7b201cb17ab99dca723a3488b6d4 ]

Currently at dp_pm_resume() is_connected state is decided base on hpd connection
status only. This will put is_connected in wrongly "true" state at the scenario
that dongle attached to DUT but without hmdi cable connecting to it. Fix this
problem by adding read sink count from dongle and decided is_connected state base
on both sink count and hpd connection status.

Changes in v2:
-- remove dp_get_sink_count() cand call drm_dp_read_sink_count()

Changes in v3:
-- delete status local variable from dp_pm_resume()

Changes in v4:
-- delete un necessary comment at dp_pm_resume()

Fixes: d9aa6571b28ba ("drm/msm/dp: check sink_count before update is_connected status")
Signed-off-by: Kuogee Hsieh <khsieh@codeaurora.org>
Link: https://lore.kernel.org/r/1628092261-32346-1-git-send-email-khsieh@codeaurora.org
Tested-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index cdec0a367a2c..e6706a88d804 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -1286,7 +1286,7 @@ static int dp_pm_resume(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct msm_dp *dp_display = platform_get_drvdata(pdev);
 	struct dp_display_private *dp;
-	u32 status;
+	int sink_count = 0;
 
 	dp = container_of(dp_display, struct dp_display_private, dp_display);
 
@@ -1300,14 +1300,25 @@ static int dp_pm_resume(struct device *dev)
 
 	dp_catalog_ctrl_hpd_config(dp->catalog);
 
-	status = dp_catalog_link_is_connected(dp->catalog);
+	/*
+	 * set sink to normal operation mode -- D0
+	 * before dpcd read
+	 */
+	dp_link_psm_config(dp->link, &dp->panel->link_info, false);
+
+	if (dp_catalog_link_is_connected(dp->catalog)) {
+		sink_count = drm_dp_read_sink_count(dp->aux);
+		if (sink_count < 0)
+			sink_count = 0;
+	}
 
+	dp->link->sink_count = sink_count;
 	/*
 	 * can not declared display is connected unless
 	 * HDMI cable is plugged in and sink_count of
 	 * dongle become 1
 	 */
-	if (status && dp->link->sink_count)
+	if (dp->link->sink_count)
 		dp->dp_display.is_connected = true;
 	else
 		dp->dp_display.is_connected = false;
-- 
2.30.2



