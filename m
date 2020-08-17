Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5C02473CA
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403945AbgHQTBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:01:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730609AbgHQPrw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:47:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 540EA221E2;
        Mon, 17 Aug 2020 15:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679271;
        bh=qpYVExMYuXlY8Y4VITqpkEQO2JIAQnnXvNxeNv4FaKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CpUSdo7Gxf6+OrCEIGuk9McDIuze6s9Oq+MvLDRfqKCOPCZ/ONlY55ssHMPAR6P/e
         dKC1DvHLcV5Eurj3LYTUAHmjzAKVKizYzS5v4Y3D2F5tNY7ptWH8uBMX2QXE0fTCoC
         qSlcMcbS51Xv+gHUXEJsN0uHoktl+jcs9xnE1mYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Clark <robdclark@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 124/393] drm/bridge: ti-sn65dsi86: Fix off-by-one error in clock choice
Date:   Mon, 17 Aug 2020 17:12:54 +0200
Message-Id: <20200817143825.623167276@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit fe3d7a35497c807d0dad0642afd87d6ba5b6fc86 ]

If the rate in our table is _equal_ to the rate we want then it's OK
to pick it.  It doesn't need to be greater than the one we want.

Fixes: a095f15c00e2 ("drm/bridge: add support for sn65dsi86 bridge driver")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200504213225.1.I21646c7c37ff63f52ae6cdccc9bc829fbc3d9424@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index d865cc2565bc0..8a0e34f2160af 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -475,7 +475,7 @@ static int ti_sn_bridge_calc_min_dp_rate_idx(struct ti_sn_bridge *pdata)
 				   1000 * pdata->dp_lanes * DP_CLK_FUDGE_DEN);
 
 	for (i = 1; i < ARRAY_SIZE(ti_sn_bridge_dp_rate_lut) - 1; i++)
-		if (ti_sn_bridge_dp_rate_lut[i] > dp_rate_mhz)
+		if (ti_sn_bridge_dp_rate_lut[i] >= dp_rate_mhz)
 			break;
 
 	return i;
-- 
2.25.1



