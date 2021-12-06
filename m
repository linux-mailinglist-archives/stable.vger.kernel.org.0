Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A65146A9E7
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350850AbhLFVV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:21:26 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48844 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350677AbhLFVVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:21:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 752C3CE1410;
        Mon,  6 Dec 2021 21:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27ED0C341C6;
        Mon,  6 Dec 2021 21:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825468;
        bh=GQokSa4i+2CGdyoT/xYJ7/ZpQkkuAmTHc9GaFqI9gjM=;
        h=From:To:Cc:Subject:Date:From;
        b=hw0h4XJcMRZiMZvesxmxZjkplsz/TwU3qvxVzy40IMSPYWUExb5TgW1qCDsCNzImA
         FFNVZa211SYV+AraTxGyNghzQNRBwMuhmv6J68gLqYOPNeZq+uwFcXjWLpk68sRGXd
         nZGBPjrUcbqFNIKWoDpK5cu1fyYjiwgmc0W4UNUZDLAS0/R20sP/XjZwRD7Uq5WhMR
         3VHuLhQVAc1C1+MiaJB3JwIyLWyNkSPHksMdRDv4lw4ODb80Xjp8eS7Mx9gNV3/57A
         gxJ9NEQpYQMpdDpHi7v7DRq+zGdtrcrRcG6ovn8t9b9UmEC1g0TZD0oL1xZZX6BrFr
         3pE9ZYWvCJeYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philip Chen <philipchen@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch,
        dmitry.baryshkov@linaro.org, abhinavk@codeaurora.org,
        bjorn.andersson@linaro.org, jonathan@marek.ca,
        jesszhan@codeaurora.org, vulab@iscas.ac.cn, tiny.windzz@gmail.com,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 01/10] drm/msm/dsi: set default num_data_lanes
Date:   Mon,  6 Dec 2021 16:17:20 -0500
Message-Id: <20211206211738.1661003-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Chen <philipchen@chromium.org>

[ Upstream commit cd92cc187c053ab010a1570e2d61d68394a5c725 ]

If "data_lanes" property of the dsi output endpoint is missing in
the DT, num_data_lanes would be 0 by default, which could cause
dsi_host_attach() to fail if dsi->lanes is set to a non-zero value
by the bridge driver.

According to the binding document of msm dsi controller, the
input/output endpoint of the controller is expected to have 4 lanes.
So let's set num_data_lanes to 4 by default.

Signed-off-by: Philip Chen <philipchen@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20211030100812.1.I6cd9af36b723fed277d34539d3b2ba4ca233ad2d@changeid
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 5613234823f7d..423c4ae2be10d 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1669,6 +1669,8 @@ static int dsi_host_parse_lane_data(struct msm_dsi_host *msm_host,
 	if (!prop) {
 		DRM_DEV_DEBUG(dev,
 			"failed to find data lane mapping, using default\n");
+		/* Set the number of date lanes to 4 by default. */
+		msm_host->num_data_lanes = 4;
 		return 0;
 	}
 
-- 
2.33.0

