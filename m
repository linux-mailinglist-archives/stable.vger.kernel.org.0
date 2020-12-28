Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839BC2E421F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391667AbgL1ODm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:03:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:37786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437185AbgL1ODl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:03:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CD3420715;
        Mon, 28 Dec 2020 14:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164180;
        bh=dWc5ccNpzefKV+J38cPC8zorQ5GdHydGLEwL75yVjwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rqyFtw4rq8G/vbg1VVE+TeuBYohfx4tW6vPyTUJZk2/L509SpWZYBYmKZtSBzdJlc
         4Qez+HBN3LhQ+bLJcYrar3V2avC97KDv1oBa0TwQKU8iUTXLaad303L4Qf3vToN3UP
         RWmpxoww+n22cH35BxkTqh5F2TrXXtxdefLsdLiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <khsieh@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/717] drm/msm/dp: skip checking LINK_STATUS_UPDATED bit
Date:   Mon, 28 Dec 2020 13:41:28 +0100
Message-Id: <20201228125025.289196875@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuogee Hsieh <khsieh@codeaurora.org>

[ Upstream commit ea530388e64bd584645f2d89e40ca7dffade8eff ]

Some dongle will not clear LINK_STATUS_UPDATED bit after
DPCD read which cause link training failed. This patch
just read 6 bytes of DPCD link status from sink and return
without checking LINK_STATUS_UPDATED bit.
Only 8 bits are used to represent link rate at sinker DPCD.
The really link rate is 2.7Mb times the 8 bits value.
For example, 0x0A at DPCD is equal to 2.7Gb (10 * 2.7Mb).
This patch also convert 8 bits value of DPCD to really link
rate to fix worng link rate error during phy compliance test.

Fixes: 6625e2637d93 ("drm/msm/dp: DisplayPort PHY compliance tests fixup")
Signed-off-by: Kuogee Hsieh <khsieh@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 20 ++++++--------------
 drivers/gpu/drm/msm/dp/dp_link.c | 29 ++++++++++++++---------------
 2 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index cee161c8ecc67..c83a1650437da 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1061,23 +1061,15 @@ static bool dp_ctrl_train_pattern_set(struct dp_ctrl_private *ctrl,
 static int dp_ctrl_read_link_status(struct dp_ctrl_private *ctrl,
 				    u8 *link_status)
 {
-	int len = 0;
-	u32 const offset = DP_LANE_ALIGN_STATUS_UPDATED - DP_LANE0_1_STATUS;
-	u32 link_status_read_max_retries = 100;
-
-	while (--link_status_read_max_retries) {
-		len = drm_dp_dpcd_read_link_status(ctrl->aux,
-			link_status);
-		if (len != DP_LINK_STATUS_SIZE) {
-			DRM_ERROR("DP link status read failed, err: %d\n", len);
-			return len;
-		}
+	int ret = 0, len;
 
-		if (!(link_status[offset] & DP_LINK_STATUS_UPDATED))
-			return 0;
+	len = drm_dp_dpcd_read_link_status(ctrl->aux, link_status);
+	if (len != DP_LINK_STATUS_SIZE) {
+		DRM_ERROR("DP link status read failed, err: %d\n", len);
+		ret = -EINVAL;
 	}
 
-	return -ETIMEDOUT;
+	return ret;
 }
 
 static int dp_ctrl_link_train_1(struct dp_ctrl_private *ctrl,
diff --git a/drivers/gpu/drm/msm/dp/dp_link.c b/drivers/gpu/drm/msm/dp/dp_link.c
index 49d7fad36fc4e..be986da78c4a5 100644
--- a/drivers/gpu/drm/msm/dp/dp_link.c
+++ b/drivers/gpu/drm/msm/dp/dp_link.c
@@ -773,7 +773,8 @@ static int dp_link_process_link_training_request(struct dp_link_private *link)
 			link->request.test_lane_count);
 
 	link->dp_link.link_params.num_lanes = link->request.test_lane_count;
-	link->dp_link.link_params.rate = link->request.test_link_rate;
+	link->dp_link.link_params.rate = 
+		drm_dp_bw_code_to_link_rate(link->request.test_link_rate);
 
 	return 0;
 }
@@ -943,22 +944,20 @@ static u8 get_link_status(const u8 link_status[DP_LINK_STATUS_SIZE], int r)
  */
 static int dp_link_process_link_status_update(struct dp_link_private *link)
 {
-	if (!(get_link_status(link->link_status,
-				DP_LANE_ALIGN_STATUS_UPDATED) &
-				DP_LINK_STATUS_UPDATED) ||
-			(drm_dp_clock_recovery_ok(link->link_status,
-					link->dp_link.link_params.num_lanes) &&
-			drm_dp_channel_eq_ok(link->link_status,
-					link->dp_link.link_params.num_lanes)))
-		return -EINVAL;
+       bool channel_eq_done = drm_dp_channel_eq_ok(link->link_status,
+                       link->dp_link.link_params.num_lanes);
 
-	DRM_DEBUG_DP("channel_eq_done = %d, clock_recovery_done = %d\n",
-			drm_dp_clock_recovery_ok(link->link_status,
-			link->dp_link.link_params.num_lanes),
-			drm_dp_clock_recovery_ok(link->link_status,
-			link->dp_link.link_params.num_lanes));
+       bool clock_recovery_done = drm_dp_clock_recovery_ok(link->link_status,
+                       link->dp_link.link_params.num_lanes);
 
-	return 0;
+       DRM_DEBUG_DP("channel_eq_done = %d, clock_recovery_done = %d\n",
+                        channel_eq_done, clock_recovery_done);
+
+       if (channel_eq_done && clock_recovery_done)
+               return -EINVAL;
+
+
+       return 0;
 }
 
 /**
-- 
2.27.0



