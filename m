Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0749C4A4105
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358508AbiAaLBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:01:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48454 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358530AbiAaLAm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:00:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11C92B82A5B;
        Mon, 31 Jan 2022 11:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD33C340EE;
        Mon, 31 Jan 2022 11:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626839;
        bh=/wAIDgbERjf5UmB7nohSv94TjpNXrntbr7XxfL+KZ5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sv8U26TrP39ev74c6rTdXDE+ZMX4X5YHBn+oH4HxT/NlF7gKRcIF2/i9FJ2DsWt2Z
         8CBKn0DxAnHYdKc1rC1fRLFH4+3jlHwFxeLCRF/35mU2dwABTY5f6NgjdrDxycpVGH
         HkUVYArh8pqKKQ6coEipEkrzdmxyZmrXkI3JEy1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 56/64] drm/msm/hdmi: Fix missing put_device() call in msm_hdmi_get_phy
Date:   Mon, 31 Jan 2022 11:56:41 +0100
Message-Id: <20220131105217.568120068@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
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
index 355afb936401a..1a7e77373407f 100644
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



