Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7CF3C535A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352319AbhGLHyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350207AbhGLHup (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9989A6194C;
        Mon, 12 Jul 2021 07:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075847;
        bh=8c2iwcLox+yRX+nWX8MOd7zU7G7Qd/nNkT3n2ovEeQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iutkQcXPRKjIvz5qFaZ25j3nru98NUtw5VvVIB5UZgXYOO83pnALeutFttvgIDV7O
         RV73W2TrcmbKqpJDGhxHkjKPusmULcqAQ2L9DOPcFKMh7RmGRiD6TDyAHg2y5Z3m2l
         K+o2IjYqHHE4u85MY93mC4OGC1szbklWe3/e/4Rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yingjie Wang <wangyingjie55@126.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 391/800] drm/amd/dc: Fix a missing check bug in dm_dp_mst_detect()
Date:   Mon, 12 Jul 2021 08:06:54 +0200
Message-Id: <20210712061008.803368167@linuxfoundation.org>
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

From: Yingjie Wang <wangyingjie55@126.com>

[ Upstream commit 655c0ed19772d92c9665ed08bdc5202acc096dda ]

In dm_dp_mst_detect(), We should check whether or not @connector
has been unregistered from userspace. If the connector is unregistered,
we should return disconnected status.

Fixes: 4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
Signed-off-by: Yingjie Wang <wangyingjie55@126.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 9b221db526dc..d62460b69d95 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -278,6 +278,9 @@ dm_dp_mst_detect(struct drm_connector *connector,
 	struct amdgpu_dm_connector *aconnector = to_amdgpu_dm_connector(connector);
 	struct amdgpu_dm_connector *master = aconnector->mst_port;
 
+	if (drm_connector_is_unregistered(connector))
+		return connector_status_disconnected;
+
 	return drm_dp_mst_detect_port(connector, ctx, &master->mst_mgr,
 				      aconnector->port);
 }
-- 
2.30.2



