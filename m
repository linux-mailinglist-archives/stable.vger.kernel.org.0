Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6163C537A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352463AbhGLHyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350414AbhGLHvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE48661927;
        Mon, 12 Jul 2021 07:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075899;
        bh=K4ou+PM/SCBQL9R1mcuAm8Z40Qri2W2yPvNi/GyPaOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D4o03ggIIQ+6KPs4mcEHg4U1t10Gexm/kAfLmhLenmS81t6mAfMtPlzlZO81bilPb
         F8LG76DCs/0+4l4qorG8pMFWIZDGzVsICEFk9JcXn1/+Iw2G3rB3njYF+h9kjOaVDz
         IVB5vi32dCAwAji1bKZ9AnyRUY2SykNYQxJvIbck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhan Liu <zhan.liu@amd.com>,
        Nikola Cornij <nikola.cornij@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 411/800] drm/amd/display: Avoid HPD IRQ in GPU reset state
Date:   Mon, 12 Jul 2021 08:07:14 +0200
Message-Id: <20210712061010.887315997@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhan Liu <zhan.liu@amd.com>

[ Upstream commit 509b9a5b4865dee723296f143695a7774fc96c4a ]

[Why]
If GPU is in reset state, force enabling link will cause
unexpected behaviour.

[How]
Avoid handling HPD IRQ when GPU is in reset state.

Signed-off-by: Zhan Liu <zhan.liu@amd.com>
Reviewed-by: Nikola Cornij <nikola.cornij@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 875fd187463e..dcb4e585c270 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2726,15 +2726,15 @@ static void handle_hpd_rx_irq(void *param)
 		}
 	}
 
-	if (!amdgpu_in_reset(adev))
+	if (!amdgpu_in_reset(adev)) {
 		mutex_lock(&adev->dm.dc_lock);
 #ifdef CONFIG_DRM_AMD_DC_HDCP
 	result = dc_link_handle_hpd_rx_irq(dc_link, &hpd_irq_data, NULL);
 #else
 	result = dc_link_handle_hpd_rx_irq(dc_link, NULL, NULL);
 #endif
-	if (!amdgpu_in_reset(adev))
 		mutex_unlock(&adev->dm.dc_lock);
+	}
 
 out:
 	if (result && !is_mst_root_connector) {
-- 
2.30.2



