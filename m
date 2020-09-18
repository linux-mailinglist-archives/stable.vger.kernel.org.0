Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AB326F020
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730022AbgIRCkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgIRCLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A6C423119;
        Fri, 18 Sep 2020 02:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395089;
        bh=ANEvw/4pMtBeQ3ZLljniHBGPRo5wvvucV4VHXsHoqgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c8c5OO//fkV+d4Y7uXa2rU64rApO6/Bq/HHgoYrcgrV1YEJDh7uxmPkvqEaBDHS+a
         M2mxiV8AbNqLx3Wz08MPC0K/NB6ZobIBfpUeQ8+KviyEo44qkIUdLfzR/uy/7wjh0Q
         B28RtuF923hyJugRrD+HxzuCYJTSLK4EYurKMbt8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 171/206] drm/nouveau/debugfs: fix runtime pm imbalance on error
Date:   Thu, 17 Sep 2020 22:07:27 -0400
Message-Id: <20200918020802.2065198-171-sashal@kernel.org>
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

[ Upstream commit 00583fbe8031f69bba8b0a9a861efb75fb7131af ]

pm_runtime_get_sync() increments the runtime PM usage counter even
the call returns an error code. Thus a pairing decrement is needed
on the error handling path to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_debugfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_debugfs.c b/drivers/gpu/drm/nouveau/nouveau_debugfs.c
index 9635704a1d864..4561a786fab07 100644
--- a/drivers/gpu/drm/nouveau/nouveau_debugfs.c
+++ b/drivers/gpu/drm/nouveau/nouveau_debugfs.c
@@ -161,8 +161,11 @@ nouveau_debugfs_pstate_set(struct file *file, const char __user *ubuf,
 	}
 
 	ret = pm_runtime_get_sync(drm->dev);
-	if (ret < 0 && ret != -EACCES)
+	if (ret < 0 && ret != -EACCES) {
+		pm_runtime_put_autosuspend(drm->dev);
 		return ret;
+	}
+
 	ret = nvif_mthd(ctrl, NVIF_CONTROL_PSTATE_USER, &args, sizeof(args));
 	pm_runtime_put_autosuspend(drm->dev);
 	if (ret < 0)
-- 
2.25.1

