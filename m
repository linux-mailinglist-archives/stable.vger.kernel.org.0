Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E4424DDF4
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgHURYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:24:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbgHUQP2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:15:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29FCF20578;
        Fri, 21 Aug 2020 16:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026527;
        bh=TFcesgzQ7Oq2G8volWlqg/GYHHqF06Bz+VQQ33eO6+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+YKoUhCgYZg6noITHqJpWgtKkoCFRWKFnsq1iil9UnyniD4H8LKXC2gsr3eikhrF
         ssDxthBd2QHoAzWFEM2AxfH4JcXP2Xfx4CAXPHX3Bt22xbYwcKZ5I0YnbkuN7KpBYM
         lG7Zz3rJvZBJWYA76UtIzpQzdm1UG8W/H3y6VR9M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 50/62] drm/nouveau: Fix reference count leak in nouveau_connector_detect
Date:   Fri, 21 Aug 2020 12:14:11 -0400
Message-Id: <20200821161423.347071-50-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161423.347071-1-sashal@kernel.org>
References: <20200821161423.347071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 990a1162986e8eff7ca18cc5a0e03b4304392ae2 ]

nouveau_connector_detect() calls pm_runtime_get_sync and in turn
increments the reference count. In case of failure, decrement the
ref count before returning the error.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 1b383ae0248f3..ef8ddbe445812 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -572,8 +572,10 @@ nouveau_connector_detect(struct drm_connector *connector, bool force)
 		pm_runtime_get_noresume(dev->dev);
 	} else {
 		ret = pm_runtime_get_sync(dev->dev);
-		if (ret < 0 && ret != -EACCES)
+		if (ret < 0 && ret != -EACCES) {
+			pm_runtime_put_autosuspend(dev->dev);
 			return conn_status;
+		}
 	}
 
 	nv_encoder = nouveau_connector_ddc_detect(connector);
-- 
2.25.1

