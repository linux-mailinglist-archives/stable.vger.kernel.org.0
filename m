Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615B524DBCC
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 18:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgHUQrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 12:47:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727954AbgHUQUU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:20:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 938A122EBF;
        Fri, 21 Aug 2020 16:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026769;
        bh=eoVwXSopgf/xZvR3o8MeKW7Gm09apVd6vtGLYyLUfC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yYBK4OeTNi2Te6AlBSJy5MaFuH//E47zqQnqe5L+lch97MJZ25odyf3cygPeVMcfs
         jvHBbUhAzOXo8VEGAPK3ERbVhiXeVi4UP/H9weG//4fUUeRi+J7VgALG22DM5lg+fr
         DWW23OuxkpnFXyc9fxXTeKoOlg2pVZQks+Vh5Ge4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 24/30] drm/nouveau/drm/noveau: fix reference count leak in nouveau_fbcon_open
Date:   Fri, 21 Aug 2020 12:18:51 -0400
Message-Id: <20200821161857.348955-24-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161857.348955-1-sashal@kernel.org>
References: <20200821161857.348955-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit bfad51c7633325b5d4b32444efe04329d53297b2 ]

nouveau_fbcon_open() calls calls pm_runtime_get_sync() that
increments the reference count. In case of failure, decrement the
ref count before returning the error.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_fbcon.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index 2b12d82aac150..0e23284fa1a3a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -184,8 +184,10 @@ nouveau_fbcon_open(struct fb_info *info, int user)
 	struct nouveau_fbdev *fbcon = info->par;
 	struct nouveau_drm *drm = nouveau_drm(fbcon->helper.dev);
 	int ret = pm_runtime_get_sync(drm->dev->dev);
-	if (ret < 0 && ret != -EACCES)
+	if (ret < 0 && ret != -EACCES) {
+		pm_runtime_put(drm->dev->dev);
 		return ret;
+	}
 	return 0;
 }
 
-- 
2.25.1

