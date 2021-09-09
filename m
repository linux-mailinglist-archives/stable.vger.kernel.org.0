Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2C1404F0E
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345129AbhIIMQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:16:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244997AbhIIMNk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:13:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 431AE61A2E;
        Thu,  9 Sep 2021 11:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188142;
        bh=ulygN54DIgMwclPTclf9FlS0lmHQWf9LgYJJ/C3EWVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=praofPzgCObXQi13ge0RuPxkbzmqRa8XKgDqzKwRY4RKtmjCoQXCYmqo7lBhGNbwb
         A8P7Ej4/9CchHFnnyeF0qFvAmUEafC0SP+Xr8p1CKWo7my0c8Rq0Z9GEM5E2rqmC/T
         QoT4T+66io7eXNeyKfN9CBOSmCYFUv+ytUT0V0cAV1Y2eZoSFqhwFX6Pdo5oEcHqPE
         UkeOxoVnGG7wmRveVXF14AysL31XpgY+mESNYiieC1TNoFM+FnZKfZq7cbzX0dQF3C
         UKbWFuvN9ZVTQ+C9UoCW15ubB6Hk4YnYrzaABvRHC8omO6rAJktLgw8a3k9HJ9c+pj
         Vc8Ia5BK/fKnA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 113/219] drm/msm/dsi: Fix DSI and DSI PHY regulator config from SDM660
Date:   Thu,  9 Sep 2021 07:44:49 -0400
Message-Id: <20210909114635.143983-113-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index 65d68eb9e3cb..c96fd752fa1d 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
@@ -1049,7 +1049,7 @@ const struct msm_dsi_phy_cfg dsi_phy_14nm_660_cfgs = {
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

