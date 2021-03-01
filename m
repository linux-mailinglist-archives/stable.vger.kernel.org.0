Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA0932871F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbhCARUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:20:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237818AbhCARN0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:13:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFECA64EEF;
        Mon,  1 Mar 2021 16:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617060;
        bh=iRkAtZne3DbaehCo6gRHRnt87bPtYKLGOYt5u8xOlxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1PMdOfpSqjWXHuyUhsdcyKaZ+SxnIXW0xJ0p+fwPHos+yc5hXrbp3Uz+LeRTx6Ww
         yCxBmGiXeQmphqkin6Tc9MOtpxkKKdhH9xqvaPbo60IS8ISNDSceDZfKeAXhqf+b5M
         ETgawE1bgy9MwnSp5R3ElEKyq07373oAtJqfxOFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 159/247] drm/msm/dsi: Correct io_start for MSM8994 (20nm PHY)
Date:   Mon,  1 Mar 2021 17:12:59 +0100
Message-Id: <20210301161039.456609950@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit 33a7808ce1aea6e2edc1af25db25928137940c02 ]

The previous registers were *almost* correct, but instead of
PHYs, they were pointing at DSI PLLs, resulting in the PHY id
autodetection failing miserably.

Fixes: dcefc117cc19 ("drm/msm/dsi: Add support for msm8x94")
Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_20nm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_20nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_20nm.c
index 1ca6c69516f57..4c037d855b272 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_20nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_20nm.c
@@ -147,7 +147,7 @@ const struct msm_dsi_phy_cfg dsi_phy_20nm_cfgs = {
 		.disable = dsi_20nm_phy_disable,
 		.init = msm_dsi_phy_init_common,
 	},
-	.io_start = { 0xfd998300, 0xfd9a0300 },
+	.io_start = { 0xfd998500, 0xfd9a0500 },
 	.num_dsi_phy = 2,
 };
 
-- 
2.27.0



