Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA743288E2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhCARrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:47:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238302AbhCARlj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:41:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1B5E650C4;
        Mon,  1 Mar 2021 16:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617822;
        bh=xel0gKhRlsTOXAsKe+89zbCDEAMa49GG+FhgGN801J8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PmqLfnqXh0xDBCCoiKwzueBBC7uCcXUzKc5V5AVKTwgsvIIzClSCeXeqftKfo8Z9T
         5qxK+U+Mu+x2oEdaokYNKpkXjbu7hlH0Fw3J0LbuR6/mQDbMD/zvFf2xlzGNcWPCqE
         CLvnZyRltexvcXSGq0XPOFcCLa/ngbRKwwpcTRk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 209/340] drm/msm/dsi: Correct io_start for MSM8994 (20nm PHY)
Date:   Mon,  1 Mar 2021 17:12:33 +0100
Message-Id: <20210301161058.586757487@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index 1afb7c579dbbb..eca86bf448f74 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_20nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_20nm.c
@@ -139,7 +139,7 @@ const struct msm_dsi_phy_cfg dsi_phy_20nm_cfgs = {
 		.disable = dsi_20nm_phy_disable,
 		.init = msm_dsi_phy_init_common,
 	},
-	.io_start = { 0xfd998300, 0xfd9a0300 },
+	.io_start = { 0xfd998500, 0xfd9a0500 },
 	.num_dsi_phy = 2,
 };
 
-- 
2.27.0



