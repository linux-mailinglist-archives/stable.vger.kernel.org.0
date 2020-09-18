Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B615426EC6F
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbgIRCLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:11:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728653AbgIRCLc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4833D2389E;
        Fri, 18 Sep 2020 02:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395092;
        bh=WmY0h/LyaQQeF/T0eNBda+SBvSEMz0WiZq+JKE44jk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nx1S4IHPCmv68iLej2xJj53npCFC8MSjjKBZCg7tcK7GgHSnDOLHo2m7TieB3vQ98
         ATEiAeVdXWuWuFKhzvGDhL7QGJ0o5MMC/bbDax+VDAH9wvc1F8UOs3/UKLTwBz0XA9
         Sp8J5YU62mnp96obpvSsaWcu7MgaH0WRL4Xal0CU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 173/206] drm/nouveau/dispnv50: fix runtime pm imbalance on error
Date:   Thu, 17 Sep 2020 22:07:29 -0400
Message-Id: <20200918020802.2065198-173-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit dc455f4c888365595c0a13da445e092422d55b8d ]

pm_runtime_get_sync() increments the runtime PM usage counter even
the call returns an error code. Thus a pairing decrement is needed
on the error handling path to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index e06ea8c8184cb..1bb0a9f6fa730 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -909,8 +909,10 @@ nv50_mstc_detect(struct drm_connector *connector, bool force)
 		return connector_status_disconnected;
 
 	ret = pm_runtime_get_sync(connector->dev->dev);
-	if (ret < 0 && ret != -EACCES)
+	if (ret < 0 && ret != -EACCES) {
+		pm_runtime_put_autosuspend(connector->dev->dev);
 		return connector_status_disconnected;
+	}
 
 	conn_status = drm_dp_mst_detect_port(connector, mstc->port->mgr,
 					     mstc->port);
-- 
2.25.1

