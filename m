Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC254A4258
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359533AbiAaLLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376816AbiAaLJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:09:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0D3C061A27;
        Mon, 31 Jan 2022 03:05:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 202B260FB5;
        Mon, 31 Jan 2022 11:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DB3C340EF;
        Mon, 31 Jan 2022 11:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627135;
        bh=rPxomZGLw2T0AeFweigh+gNKt3+WX6XmgfGi+QBKnqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kW1OVtmxFxyqkLQP6VVYZKwHTEcGd5II8dTE6mV6EJLuVhjIWEHRTsUCcLJu/0wN5
         +vJtSo7E3ZX63QtoKj05Oq24nwASYc8IpnR1FIUau/KCO8nuCOvxcLUaerD0IzM3yG
         LiTJaxrTFbAKUvOynWZ7CSVXpTZeoJmeUqI5RYFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/100] drm/msm/hdmi: Fix missing put_device() call in msm_hdmi_get_phy
Date:   Mon, 31 Jan 2022 11:56:47 +0100
Message-Id: <20220131105223.346360687@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 774fe0cd838d1b1419d41ab4ea0613c80d4ecbd7 ]

The reference taken by 'of_find_device_by_node()' must be released when
not needed anymore.
Add the corresponding 'put_device()' in the error handling path.

Fixes: e00012b256d4 ("drm/msm/hdmi: Make HDMI core get its PHY")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220107085026.23831-1-linmq006@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index 737453b6e5966..94f948ef279d1 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -97,10 +97,15 @@ static int msm_hdmi_get_phy(struct hdmi *hdmi)
 
 	of_node_put(phy_node);
 
-	if (!phy_pdev || !hdmi->phy) {
+	if (!phy_pdev) {
 		DRM_DEV_ERROR(&pdev->dev, "phy driver is not ready\n");
 		return -EPROBE_DEFER;
 	}
+	if (!hdmi->phy) {
+		DRM_DEV_ERROR(&pdev->dev, "phy driver is not ready\n");
+		put_device(&phy_pdev->dev);
+		return -EPROBE_DEFER;
+	}
 
 	hdmi->phy_dev = get_device(&phy_pdev->dev);
 
-- 
2.34.1



