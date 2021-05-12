Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409B137C52D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbhELPiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:38:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233176AbhELPat (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:30:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 127486194F;
        Wed, 12 May 2021 15:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832554;
        bh=UtdNivacHThNokihCSBKtp6WYfjbh9GlWT3m3yjRgSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Qahg9PvrIWzi7hdJEntT87qkAQAg1A6m/x0gC9xkt4QPOcn8KLLINVpUsiv79ydR
         0bb+PmYO2jo+Y9FyYmebCJwu6vILWt/Hoz2BJErDtfYUJB+BMZowsOycadiM28cDf5
         rdY8kdeuFm3Mgs84O9yspH3ri0DPk7dQ23Q19KAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yingjie Wang <wangyingjie55@126.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 326/530] drm/radeon: Fix a missing check bug in radeon_dp_mst_detect()
Date:   Wed, 12 May 2021 16:47:16 +0200
Message-Id: <20210512144830.524382697@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yingjie Wang <wangyingjie55@126.com>

[ Upstream commit 25315ebfaefcffd126a266116b37bb8a3d1c4620 ]

In radeon_dp_mst_detect(), We should check whether or not @connector
has been unregistered from userspace. If the connector is unregistered,
we should return disconnected status.

Fixes: 9843ead08f18 ("drm/radeon: add DisplayPort MST support (v2)")
Signed-off-by: Yingjie Wang <wangyingjie55@126.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_dp_mst.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_dp_mst.c b/drivers/gpu/drm/radeon/radeon_dp_mst.c
index 008308780443..9bd6c0697538 100644
--- a/drivers/gpu/drm/radeon/radeon_dp_mst.c
+++ b/drivers/gpu/drm/radeon/radeon_dp_mst.c
@@ -242,6 +242,9 @@ radeon_dp_mst_detect(struct drm_connector *connector,
 		to_radeon_connector(connector);
 	struct radeon_connector *master = radeon_connector->mst_port;
 
+	if (drm_connector_is_unregistered(connector))
+		return connector_status_disconnected;
+
 	return drm_dp_mst_detect_port(connector, ctx, &master->mst_mgr,
 				      radeon_connector->port);
 }
-- 
2.30.2



