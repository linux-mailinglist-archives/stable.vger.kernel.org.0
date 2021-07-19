Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342733CE554
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347580AbhGSPsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:48:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349561AbhGSPpK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AF256140A;
        Mon, 19 Jul 2021 16:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711938;
        bh=IWa6rNN8M5qqyxJN6EtU7EI4tHS7i0cvTiHx3ChZI0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v9IXdx9Ecj1JuxrB/h/Olm3kR4iJoIlXgw+WxA5vqpM5Dp6A4awSzGSJQ971NYFs3
         hZ+Y42BFBVzBjbdBUVWF786gBId57cekzxZKIZPCO6jG6w0OVrx4XjiHpIcfbdRDGG
         w+o9ROEZUptQ7tuY0UuIkbpMr1bSUIK4qTnUpZn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 155/292] drm/gma500: Add the missed drm_gem_object_put() in psb_user_framebuffer_create()
Date:   Mon, 19 Jul 2021 16:53:37 +0200
Message-Id: <20210719144947.581853367@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



