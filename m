Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB8F261C3C
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731941AbgIHTQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:16:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731174AbgIHQEj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:04:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8C3E23C3F;
        Tue,  8 Sep 2020 15:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579365;
        bh=E0S5fTo0mX+8r5130quZXaxIlSmWMKiZqSWg4n8H/MU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yc3FY8Et+gMhOBdliRNBI/a3MEFHpTfTCE7gHhU7o70veGouVXDifnTfr8QLvWnet
         m2lVenA/jINz/1mGKibW4Zep1esxbTiaYvwS6pfE2z/noIh2a/fZ3U+fUwFQJi1vFG
         OqRpf+wVj/gLBIhVX91Q+nZZ/LWI8TVaQFNf/QIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 018/186] drm/msm/a6xx: fix gmu start on newer firmware
Date:   Tue,  8 Sep 2020 17:22:40 +0200
Message-Id: <20200908152242.542199045@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit f5749d6181fa7df5ae741788e5d96f593d3a60b6 ]

New Qualcomm firmware has changed a way it reports back the 'started'
event. Support new register values.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 1d330204c465c..2dd1cf1ffbe25 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -207,6 +207,16 @@ static int a6xx_gmu_start(struct a6xx_gmu *gmu)
 {
 	int ret;
 	u32 val;
+	u32 mask, reset_val;
+
+	val = gmu_read(gmu, REG_A6XX_GMU_CM3_DTCM_START + 0xff8);
+	if (val <= 0x20010004) {
+		mask = 0xffffffff;
+		reset_val = 0xbabeface;
+	} else {
+		mask = 0x1ff;
+		reset_val = 0x100;
+	}
 
 	gmu_write(gmu, REG_A6XX_GMU_CM3_SYSRESET, 1);
 
@@ -218,7 +228,7 @@ static int a6xx_gmu_start(struct a6xx_gmu *gmu)
 	gmu_write(gmu, REG_A6XX_GMU_CM3_SYSRESET, 0);
 
 	ret = gmu_poll_timeout(gmu, REG_A6XX_GMU_CM3_FW_INIT_RESULT, val,
-		val == 0xbabeface, 100, 10000);
+		(val & mask) == reset_val, 100, 10000);
 
 	if (ret)
 		DRM_DEV_ERROR(gmu->dev, "GMU firmware initialization timed out\n");
-- 
2.25.1



