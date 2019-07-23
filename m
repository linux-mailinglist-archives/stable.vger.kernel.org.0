Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDCA71860
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 14:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbfGWMkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 08:40:19 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17865 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfGWMkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 08:40:18 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d3700320000>; Tue, 23 Jul 2019 05:40:18 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 23 Jul 2019 05:40:17 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 23 Jul 2019 05:40:17 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 23 Jul
 2019 12:40:17 +0000
Received: from hqnvemgw02.nvidia.com (172.16.227.111) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 23 Jul 2019 12:40:17 +0000
Received: from viswanathl-pc.nvidia.com (Not Verified[10.24.34.161]) by hqnvemgw02.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5d37002f0001>; Tue, 23 Jul 2019 05:40:17 -0700
From:   Viswanath L <viswanathl@nvidia.com>
To:     <thierry.reding@gmail.com>, <airlied@linux.ie>, <daniel@ffwll.ch>,
        <jonathanh@nvidia.com>
CC:     <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Viswanath L <viswanathl@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH v3] drm/tegra: sor: Enable HDA interrupts at plug-in
Date:   Tue, 23 Jul 2019 18:10:10 +0530
Message-ID: <1563885610-27198-1-git-send-email-viswanathl@nvidia.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563885618; bh=vnUMhGHFntFjRCg50dKxkbAv1jtTZ2lFJW7TPW4MlWE=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:Content-Type;
        b=BBFi9+pINJlcbCbMk3Ue+WDikjwc8qnvNr6wz/l0ep+fGOMDIByfvx54x9zncg50F
         kTSB7lNswhIkdH7bTrNS+1ijAN6LAJn+uGLqA2vrNKHlshm1RLUPhhcdgr/QBihY25
         epAJB73dNVrt5bMJq4DduZjXolzRif9pU87hAtRPalrl9iDcJTOQNlv2SF2O63qLLe
         B2SaiQMUrKv/xc6eZhbYOBJrHa/5fTQYj93GLAkr6m4Y9hh4Vu6z555A6Wfp21HqpO
         Of1Rm0TIOU+q1PE5kPJx6utVT+sjqojafp0G4vt0SLrtfUDr3wKbmHlVwDfM06UmN4
         hfhuyWQIpQl9g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

HDMI plugout calls runtime suspend, which clears interrupt registers
and causes audio functionality to break on subsequent plug-in; setting
interrupt registers in sor_audio_prepare() solves the issue.

Signed-off-by: Viswanath L <viswanathl@nvidia.com>
Fixes: 8e2988a76c26 ("drm/tegra: sor: Support for audio over HDMI")
Cc: <stable@vger.kernel.org>
---
 drivers/gpu/drm/tegra/sor.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index 5be5a08..0470cfe 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -2164,6 +2164,15 @@ static void tegra_sor_audio_prepare(struct tegra_sor *sor)
 
 	value = SOR_AUDIO_HDA_PRESENSE_ELDV | SOR_AUDIO_HDA_PRESENSE_PD;
 	tegra_sor_writel(sor, value, SOR_AUDIO_HDA_PRESENSE);
+
+	/*
+	 * Enable and unmask the HDA codec SCRATCH0 register interrupt. This
+	 * is used for interoperability between the HDA codec driver and the
+	 * HDMI/DP driver.
+	 */
+	value = SOR_INT_CODEC_SCRATCH1 | SOR_INT_CODEC_SCRATCH0;
+	tegra_sor_writel(sor, value, SOR_INT_ENABLE);
+	tegra_sor_writel(sor, value, SOR_INT_MASK);
 }
 
 static void tegra_sor_audio_unprepare(struct tegra_sor *sor)
@@ -2913,15 +2922,6 @@ static int tegra_sor_init(struct host1x_client *client)
 	if (err < 0)
 		return err;
 
-	/*
-	 * Enable and unmask the HDA codec SCRATCH0 register interrupt. This
-	 * is used for interoperability between the HDA codec driver and the
-	 * HDMI/DP driver.
-	 */
-	value = SOR_INT_CODEC_SCRATCH1 | SOR_INT_CODEC_SCRATCH0;
-	tegra_sor_writel(sor, value, SOR_INT_ENABLE);
-	tegra_sor_writel(sor, value, SOR_INT_MASK);
-
 	return 0;
 }
 
-- 
2.7.4

