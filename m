Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B30924DB03
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 18:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgHUQcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 12:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728255AbgHUQVe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:21:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E224207DF;
        Fri, 21 Aug 2020 16:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026835;
        bh=sMapnY9eiJygR4cWWZi/1wNJU2zdO+SwpykGS1RmFcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ER2h0R5EUYvRHKbKRllgjsr8Ptlf3W1hrkLI9Yoq/Ea9rSe4MfFDDHCaGeBhbJrq2
         fjE/pTcNoq8rO8JYgcuel/nNTp/FVcYUh8q6E2n3ol/HqSeTg0LY7CMsF30o5oZd2y
         0lkBxnnnzY0d7gubkqntt2YGGBXAoQq4e3NQGQtU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.4 16/22] drm/nouveau/drm/noveau: fix reference count leak in nouveau_fbcon_open
Date:   Fri, 21 Aug 2020 12:20:08 -0400
Message-Id: <20200821162014.349506-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821162014.349506-1-sashal@kernel.org>
References: <20200821162014.349506-1-sashal@kernel.org>
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
index 343476d157266..1b8392b382b03 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -184,8 +184,10 @@ nouveau_fbcon_open(struct fb_info *info, int user)
 	struct nouveau_fbdev *fbcon = info->par;
 	struct nouveau_drm *drm = nouveau_drm(fbcon->dev);
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

