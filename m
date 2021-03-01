Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D7D328563
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbhCAQxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:53:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:50532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235261AbhCAQrX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:47:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF6CF64E68;
        Mon,  1 Mar 2021 16:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616312;
        bh=iRkAtZne3DbaehCo6gRHRnt87bPtYKLGOYt5u8xOlxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcI/MfrQMpnEONPT/wGL9mpgrz+M+TY/Vzp5i4M9Tf0v8Xmx7Dm+LKCN3jkGkzg5O
         s0+RaTqT24h3pjTDohcPk1KQ8i7jFN4CfCBgCavA1h1aTXXytAp1KA/Dp+itCXX/EV
         aFS6EuLQvze4JP0FD/5FacGXma0tHjTusdWH2Yxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 108/176] drm/msm/dsi: Correct io_start for MSM8994 (20nm PHY)
Date:   Mon,  1 Mar 2021 17:13:01 +0100
Message-Id: <20210301161026.344911233@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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



