Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E07475EE0
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245603AbhLORZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245712AbhLORYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:24:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B193C061751;
        Wed, 15 Dec 2021 09:24:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC56861A02;
        Wed, 15 Dec 2021 17:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8BCC36AE2;
        Wed, 15 Dec 2021 17:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589071;
        bh=Sa+KGCq2/sHFHnova0dYBBp7RPzJf/V7LKGoUhjeFd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFTLggvC5mpzW+PsQIEEPZjKToox7cldtK8sEeE2a4QsQuyyGIMO4ABX9MVq777eM
         mnT4twv57MsZEeiG3YZ355LfhRm6+XIp8XCO/0cf2uG3PNNTDLsdHF8CQZ74OCFru9
         oo02qULKv6zSgytD8hfHNwErnv1hdVLA30A5UxyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philip Chen <philipchen@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 02/33] drm/msm/dsi: set default num_data_lanes
Date:   Wed, 15 Dec 2021 18:21:00 +0100
Message-Id: <20211215172024.869997288@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172024.787958154@linuxfoundation.org>
References: <20211215172024.787958154@linuxfoundation.org>
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
index 96b5dcf8e4540..64454a63bbacf 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1692,6 +1692,8 @@ static int dsi_host_parse_lane_data(struct msm_dsi_host *msm_host,
 	if (!prop) {
 		DRM_DEV_DEBUG(dev,
 			"failed to find data lane mapping, using default\n");
+		/* Set the number of date lanes to 4 by default. */
+		msm_host->num_data_lanes = 4;
 		return 0;
 	}
 
-- 
2.33.0



