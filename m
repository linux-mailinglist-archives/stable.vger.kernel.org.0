Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5476B3C37BC
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbhGJXw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:52:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232034AbhGJXwi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:52:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6D60613B0;
        Sat, 10 Jul 2021 23:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625960992;
        bh=IWa6rNN8M5qqyxJN6EtU7EI4tHS7i0cvTiHx3ChZI0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVTThEcoQtKq0NcVQmvWpInor8Er8DVSENlNsph8nJWwGQADB4Wg2znv6buhsa6V5
         PKhEgyE2cYZTBg08H4Y8O5N7DVp3e6nqcGR9vBnxfO5hk5i4RbZFN/eRwDahIyxI7D
         MzVr2IBEZpPH3tZeKldkIc9xUhLk1U7ZqdJuWcGPe0ElOG0ubpk8DSF6kjn4/Xb7mx
         HouDI7o3RDj7hvoOr4AJ7pBM45F5eQLgxpQAvh9yx0nnUTGvpNmHQbsPHu1Fj1KpRg
         gfQUVpYwhCRqyajsEistBhUGeFFGYB804lr3h8HmcB18zQ2GrheKLqgViqbhPpuP47
         DfqZN4uFYnAEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 25/43] drm/gma500: Add the missed drm_gem_object_put() in psb_user_framebuffer_create()
Date:   Sat, 10 Jul 2021 19:48:57 -0400
Message-Id: <20210710234915.3220342-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710234915.3220342-1-sashal@kernel.org>
References: <20210710234915.3220342-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit cd8f318fbd266b127ffc93cc4c1eaf9a5196fafb ]

psb_user_framebuffer_create() misses to call drm_gem_object_put() in an
error path. Add the missed function call to fix it.

Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210629115956.15160-1-jingxiangfeng@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/framebuffer.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
index ebe9dccf2d83..0b8648396fb2 100644
--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -352,6 +352,7 @@ static struct drm_framebuffer *psb_user_framebuffer_create
 			 const struct drm_mode_fb_cmd2 *cmd)
 {
 	struct drm_gem_object *obj;
+	struct drm_framebuffer *fb;
 
 	/*
 	 *	Find the GEM object and thus the gtt range object that is
@@ -362,7 +363,11 @@ static struct drm_framebuffer *psb_user_framebuffer_create
 		return ERR_PTR(-ENOENT);
 
 	/* Let the core code do all the work */
-	return psb_framebuffer_create(dev, cmd, obj);
+	fb = psb_framebuffer_create(dev, cmd, obj);
+	if (IS_ERR(fb))
+		drm_gem_object_put(obj);
+
+	return fb;
 }
 
 static int psbfb_probe(struct drm_fb_helper *fb_helper,
-- 
2.30.2

