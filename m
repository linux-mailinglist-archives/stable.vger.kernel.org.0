Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118334A41D2
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349011AbiAaLGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:06:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39018 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358725AbiAaLEa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:04:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F14C60ABE;
        Mon, 31 Jan 2022 11:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A75AC340E8;
        Mon, 31 Jan 2022 11:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627070;
        bh=lALiDyO/Vpb1qIVkbxs7SHyLIB3gHpgwds0GrcoB9Hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vhY6yQvdHdoKnfRwJ+sVYYRoi4uC2eTBKgZZdetYx2+ekjLCXX+2dlbjBpCNtHI47
         cOtIiBE2tRGkuGcDUFNtR/BQXn2bcNNl9WCzHGmoKwYBD72Z9+BINZ4oqpAWY8Equl
         moKcSbFzv47kRDPruAg+8X8qn2PTEUIewamqabYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 5.10 064/100] drm/msm/dsi: invalid parameter check in msm_dsi_phy_enable
Date:   Mon, 31 Jan 2022 11:56:25 +0100
Message-Id: <20220131105222.585441404@linuxfoundation.org>
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

From: José Expósito <jose.exposito89@gmail.com>

commit 5e761a2287234bc402ba7ef07129f5103bcd775c upstream.

The function performs a check on the "phy" input parameter, however, it
is used before the check.

Initialize the "dev" variable after the sanity check to avoid a possible
NULL pointer dereference.

Fixes: 5c8290284402b ("drm/msm/dsi: Split PHY drivers to separate files")
Addresses-Coverity-ID: 1493860 ("Null pointer dereference")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220116181844.7400-1-jose.exposito89@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
@@ -769,12 +769,14 @@ void __exit msm_dsi_phy_driver_unregiste
 int msm_dsi_phy_enable(struct msm_dsi_phy *phy, int src_pll_id,
 			struct msm_dsi_phy_clk_request *clk_req)
 {
-	struct device *dev = &phy->pdev->dev;
+	struct device *dev;
 	int ret;
 
 	if (!phy || !phy->cfg->ops.enable)
 		return -EINVAL;
 
+	dev = &phy->pdev->dev;
+
 	ret = dsi_phy_enable_resource(phy);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "%s: resource enable failed, %d\n",


