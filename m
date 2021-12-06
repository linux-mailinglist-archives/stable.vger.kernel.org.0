Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FAD46AA29
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351215AbhLFVXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:23:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59358 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351197AbhLFVXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:23:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 379CFB810D5;
        Mon,  6 Dec 2021 21:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48FCC341C6;
        Mon,  6 Dec 2021 21:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825609;
        bh=kC4FYwH8HJL7NPCMtXt+PJlk2zaVV6UEKAoqaCUMYyU=;
        h=From:To:Cc:Subject:Date:From;
        b=dE7ePROwJIlHNsiD8UbKkJWg8p5CF47/3y2d+N72MHwzsYQ14UzF/2P7oZtCjaHpH
         b3mEQl8hVIoLISfqMMjCmh8pFhJc+6bqqYGqILoggUu6Memc4VyxRr/02KEi8sJVFV
         Fef2aOhFgmXr5PboROQw0KfhkGh8ieWuIlI0TYibO5E24qX76W9tcb++gqhI/8lOE8
         5GOam5LN8bOSZstM4+xDir0EAMCzko9ei3a44Zf6ruHRm+HoS6ZNx8bi0MiXXJ3+R4
         vr9ElJKQgbsL17jT4aNFq0gc4WRYY9UQL/rT1Z8eVSsERbzKZ9Gd577k3NydaRzGSU
         vqdKmcS0C2rWw==
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
Subject: [PATCH AUTOSEL 4.14 1/6] drm/msm/dsi: set default num_data_lanes
Date:   Mon,  6 Dec 2021 16:19:57 -0500
Message-Id: <20211206212004.1661417-1-sashal@kernel.org>
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
index ef4e81d774464..d49f177481195 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1563,6 +1563,8 @@ static int dsi_host_parse_lane_data(struct msm_dsi_host *msm_host,
 	if (!prop) {
 		dev_dbg(dev,
 			"failed to find data lane mapping, using default\n");
+		/* Set the number of date lanes to 4 by default. */
+		msm_host->num_data_lanes = 4;
 		return 0;
 	}
 
-- 
2.33.0

