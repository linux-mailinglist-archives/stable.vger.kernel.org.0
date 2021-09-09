Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03FA404B7C
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242617AbhIILwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240947AbhIILui (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:50:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3C1F6121E;
        Thu,  9 Sep 2021 11:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187832;
        bh=Sbp8hkmrJH0wllDVah8IY9qF0XbUzi100p4DkLVpl9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cm7q/NoKfFPKKUuR/KAfAw3FPWZ508UDZwdVijrudH6EE9ygPrQ5LZukfLwrtg2kQ
         FQK5tazdwjUGVvCgy0vs7gwbDW6Afzbt88u6t4MXZFcv3AeQDbGwVW/dH/EFqQTR7p
         6olFWo0Vz5bkUEUXmHI+udhGCRov//ttsQzrkCPQnyZJP9ICHvidz2iTGqXUjvmdp4
         k6DGVH1MrPPBk27JehnSFn7d3UH07lTAoJzY4kZmRVNc77a9xVmGogDXnPJVxTiPf1
         CCRgK8QcVOJd2AQyiuG5cSpEzV9Fy68AjhO71MKa2It0fpqXcH+odoGaiAaHhwEWxR
         xbw/ziY+6gJuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 128/252] drm/msm/dsi: Fix DSI and DSI PHY regulator config from SDM660
Date:   Thu,  9 Sep 2021 07:39:02 -0400
Message-Id: <20210909114106.141462-128-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit 462f7017a6918d152870bfb8852f3c70fd74b296 ]

VDDA is not present and the specified load value is wrong. Fix it.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Link: https://lore.kernel.org/r/20210728222057.52641-1-konrad.dybcio@somainline.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_cfg.c          | 1 -
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_cfg.c b/drivers/gpu/drm/msm/dsi/dsi_cfg.c
index f3f1c03c7db9..763f127e4621 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_cfg.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_cfg.c
@@ -154,7 +154,6 @@ static const struct msm_dsi_config sdm660_dsi_cfg = {
 	.reg_cfg = {
 		.num = 2,
 		.regs = {
-			{"vdd", 73400, 32 },	/* 0.9 V */
 			{"vdda", 12560, 4 },	/* 1.2 V */
 		},
 	},
diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
index a34cf151c517..bb31230721bd 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
@@ -1050,7 +1050,7 @@ const struct msm_dsi_phy_cfg dsi_phy_14nm_660_cfgs = {
 	.reg_cfg = {
 		.num = 1,
 		.regs = {
-			{"vcca", 17000, 32},
+			{"vcca", 73400, 32},
 		},
 	},
 	.ops = {
-- 
2.30.2

