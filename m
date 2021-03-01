Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A433E32848B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbhCAQho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:37:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231481AbhCAQ3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:29:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3832664EF9;
        Mon,  1 Mar 2021 16:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615839;
        bh=TrmnSrMsPBXUqpWCCyxe6z6PBZntaCPJ+MHZuYTzRWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5vu8E+Jfuzz+JdHO+VbLpBiK4mOfRZrdMCZtWtK+Z8iqPtacJYEkPg6VnWdZvod4
         1jyf7186hdD2RdtKqRoYI3cuJdLFErzUPJADhPQOMaaAzeVO5n1tGP9fkXsS0GFQBg
         RHPVf2O2vqNrSuiCECVFGd9gkYSrydYNW9kUnbQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 079/134] drm/msm/dsi: Correct io_start for MSM8994 (20nm PHY)
Date:   Mon,  1 Mar 2021 17:13:00 +0100
Message-Id: <20210301161017.457717674@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
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
index c757e2070cac7..636e9df3d1181 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_20nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_20nm.c
@@ -146,7 +146,7 @@ const struct msm_dsi_phy_cfg dsi_phy_20nm_cfgs = {
 		.enable = dsi_20nm_phy_enable,
 		.disable = dsi_20nm_phy_disable,
 	},
-	.io_start = { 0xfd998300, 0xfd9a0300 },
+	.io_start = { 0xfd998500, 0xfd9a0500 },
 	.num_dsi_phy = 2,
 };
 
-- 
2.27.0



