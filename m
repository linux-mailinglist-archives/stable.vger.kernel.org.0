Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B048499755
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448515AbiAXVM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:12:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59368 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345225AbiAXVH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:07:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43A5BB80FA1;
        Mon, 24 Jan 2022 21:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E7BC340E5;
        Mon, 24 Jan 2022 21:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058445;
        bh=nu01olkCxJuUw8m66Dp5sIuc0VHqWRn2P7ZjH/2o+yY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UdHM1mmESkkCw0UlYhMwwG2M1ihl8LdTlx0kU/OeG1xTsGJ5ETGsvtcImWc6Lt3Ej
         pPr1viDe2rFWxfpDIRXAjEnGIpOeHDQvmdssCvtkNyWDIRVs15bcYanjI8H2iz2iFx
         jcBGbjMtyi+v3Er16UvJFVw7j/Ym7uKBufm8Rvac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0264/1039] drm/msm/dsi: fix initialization in the bonded DSI case
Date:   Mon, 24 Jan 2022 19:34:13 +0100
Message-Id: <20220124184134.174887354@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 92cb1bedde9dba78d802fe2510949743a2581aed ]

Commit 739b4e7756d3 ("drm/msm/dsi: Fix an error code in
msm_dsi_modeset_init()") changed msm_dsi_modeset_init() to return an
error code in case msm_dsi_manager_validate_current_config() returns
false. However this is not an error case, but a slave DSI of the bonded
DSI link. In this case msm_dsi_modeset_init() should return 0, but just
skip connector and bridge initialization.

To reduce possible confusion, drop the
msm_dsi_manager_validate_current_config() function, and specif 'bonded
&& !master' condition directly in the msm_dsi_modeset_init().

Fixes: 739b4e7756d3 ("drm/msm/dsi: Fix an error code in msm_dsi_modeset_init()")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Link: https://lore.kernel.org/r/20211125180114.561278-1-dmitry.baryshkov@linaro.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi.c         | 10 +++++++---
 drivers/gpu/drm/msm/dsi/dsi.h         |  1 -
 drivers/gpu/drm/msm/dsi/dsi_manager.c | 17 -----------------
 3 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi.c b/drivers/gpu/drm/msm/dsi/dsi.c
index 75ae3008b68f4..fc280cc434943 100644
--- a/drivers/gpu/drm/msm/dsi/dsi.c
+++ b/drivers/gpu/drm/msm/dsi/dsi.c
@@ -215,9 +215,13 @@ int msm_dsi_modeset_init(struct msm_dsi *msm_dsi, struct drm_device *dev,
 		goto fail;
 	}
 
-	if (!msm_dsi_manager_validate_current_config(msm_dsi->id)) {
-		ret = -EINVAL;
-		goto fail;
+	if (msm_dsi_is_bonded_dsi(msm_dsi) &&
+	    !msm_dsi_is_master_dsi(msm_dsi)) {
+		/*
+		 * Do not return an eror here,
+		 * Just skip creating encoder/connector for the slave-DSI.
+		 */
+		return 0;
 	}
 
 	msm_dsi->encoder = encoder;
diff --git a/drivers/gpu/drm/msm/dsi/dsi.h b/drivers/gpu/drm/msm/dsi/dsi.h
index 569c8ff062ba4..a63666e59d19e 100644
--- a/drivers/gpu/drm/msm/dsi/dsi.h
+++ b/drivers/gpu/drm/msm/dsi/dsi.h
@@ -82,7 +82,6 @@ int msm_dsi_manager_cmd_xfer(int id, const struct mipi_dsi_msg *msg);
 bool msm_dsi_manager_cmd_xfer_trigger(int id, u32 dma_base, u32 len);
 int msm_dsi_manager_register(struct msm_dsi *msm_dsi);
 void msm_dsi_manager_unregister(struct msm_dsi *msm_dsi);
-bool msm_dsi_manager_validate_current_config(u8 id);
 void msm_dsi_manager_tpg_enable(void);
 
 /* msm dsi */
diff --git a/drivers/gpu/drm/msm/dsi/dsi_manager.c b/drivers/gpu/drm/msm/dsi/dsi_manager.c
index 20c4d650fd80c..e58ec5c1a4c37 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_manager.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_manager.c
@@ -649,23 +649,6 @@ fail:
 	return ERR_PTR(ret);
 }
 
-bool msm_dsi_manager_validate_current_config(u8 id)
-{
-	bool is_bonded_dsi = IS_BONDED_DSI();
-
-	/*
-	 * For bonded DSI, we only have one drm panel. For this
-	 * use case, we register only one bridge/connector.
-	 * Skip bridge/connector initialisation if it is
-	 * slave-DSI for bonded DSI configuration.
-	 */
-	if (is_bonded_dsi && !IS_MASTER_DSI_LINK(id)) {
-		DBG("Skip bridge registration for slave DSI->id: %d\n", id);
-		return false;
-	}
-	return true;
-}
-
 /* initialize bridge */
 struct drm_bridge *msm_dsi_manager_bridge_init(u8 id)
 {
-- 
2.34.1



