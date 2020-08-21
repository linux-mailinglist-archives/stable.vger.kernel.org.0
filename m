Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E0124DD45
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgHUROv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:14:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728121AbgHUQQq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:16:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F90022BF3;
        Fri, 21 Aug 2020 16:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026606;
        bh=Fhn0sehRp1S4y4IwUJ1lKwt4b2NQb6RoFhhhnPVoLR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZCd8PFFn/mFtoTUu/ZNVMky8xmvznMOcJn0QYmAicl5MSArKs6rjwsDfElHSsqEl
         HGlh5sv1ICMVX3eM6qn4DPZqpO/hobrUwEkRZDrSypM76uFmbeemkA6qGHyLXkoYWe
         gko2IMgh7PK4r01RiR58i9gov+eWdHwjeNPKCGQA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 48/61] drm/nouveau: fix reference count leak in nv50_disp_atomic_commit
Date:   Fri, 21 Aug 2020 12:15:32 -0400
Message-Id: <20200821161545.347622-48-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161545.347622-1-sashal@kernel.org>
References: <20200821161545.347622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit a2cdf39536b0d21fb06113f5e16692513d7bcb9c ]

nv50_disp_atomic_commit() calls calls pm_runtime_get_sync and in turn
increments the reference count. In case of failure, decrement the
ref count before returning the error.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index 5835d19e1c45f..4088bf4b04264 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -2128,8 +2128,10 @@ nv50_disp_atomic_commit(struct drm_device *dev,
 	int ret, i;
 
 	ret = pm_runtime_get_sync(dev->dev);
-	if (ret < 0 && ret != -EACCES)
+	if (ret < 0 && ret != -EACCES) {
+		pm_runtime_put_autosuspend(dev->dev);
 		return ret;
+	}
 
 	ret = drm_atomic_helper_setup_commit(state, nonblock);
 	if (ret)
-- 
2.25.1

