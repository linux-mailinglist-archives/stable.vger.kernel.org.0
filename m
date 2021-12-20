Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEEC47ABE7
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbhLTOj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:39:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48044 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234302AbhLTOjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:39:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 094D4B80EDF;
        Mon, 20 Dec 2021 14:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39018C36AE7;
        Mon, 20 Dec 2021 14:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011145;
        bh=kC4FYwH8HJL7NPCMtXt+PJlk2zaVV6UEKAoqaCUMYyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OVCiieCoqtTklqHvnIoVeaFrQ5tQN9zJZGFlPqPsSd1HnrLIS4G/I6D3BV0/IgamN
         3rq7abwykdSQ+0KPN0CRzk4yG6TCGqsOX8sQ90qjt9vbjb8wAWEDIDUku9dlbACh7D
         inhz07HyTx5Z+gLP9zHl7j8VmvC34GDZ8G8tCfmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philip Chen <philipchen@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 02/45] drm/msm/dsi: set default num_data_lanes
Date:   Mon, 20 Dec 2021 15:33:57 +0100
Message-Id: <20211220143022.346155978@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143022.266532675@linuxfoundation.org>
References: <20211220143022.266532675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



