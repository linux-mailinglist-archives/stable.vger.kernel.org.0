Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6682D26F003
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbgIRCLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728650AbgIRCLb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39ECA2388D;
        Fri, 18 Sep 2020 02:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395090;
        bh=I50MCoWjWKzQtNvKvG/cDf7lfv3XytWC5UDqIGpN3j0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E133YC8mQki4vJ9AjMlXo2hQvyekcaMaiZkMq/AuiSYLf6cMY6IyJIa1R2xEVoA/N
         0Tk7hS/e14v0cx156YaVLCR48JbjbmnalaNf8vvHczHhYmXfR0/DFzFSDUO/Q+6MQ3
         Z2DOBrDNRCMPomZEBq9cKnnXq6ToFMkq1bowOyxI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 172/206] drm/nouveau: fix runtime pm imbalance on error
Date:   Thu, 17 Sep 2020 22:07:28 -0400
Message-Id: <20200918020802.2065198-172-sashal@kernel.org>
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

[ Upstream commit d7372dfb3f7f1602b87e0663e8b8646da23ebca7 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
the call returns an error code. Thus a pairing decrement is needed
on the error handling path to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_gem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index 791f970714ed6..a98fccb0d32f9 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -82,8 +82,10 @@ nouveau_gem_object_open(struct drm_gem_object *gem, struct drm_file *file_priv)
 		return ret;
 
 	ret = pm_runtime_get_sync(dev);
-	if (ret < 0 && ret != -EACCES)
+	if (ret < 0 && ret != -EACCES) {
+		pm_runtime_put_autosuspend(dev);
 		goto out;
+	}
 
 	ret = nouveau_vma_new(nvbo, &cli->vmm, &vma);
 	pm_runtime_mark_last_busy(dev);
-- 
2.25.1

