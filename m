Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8D13CE14B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346556AbhGSPZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:25:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346069AbhGSPQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:16:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D06A61249;
        Mon, 19 Jul 2021 15:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710237;
        bh=2Y87ANqT1IR8S1xi4zUf0mMImWInqGSIW0qfOzPDjc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OI26XxVOQ5KuarmrRTp3kAuvpVyaGi1qvtMZn5rRFUizbcf65+LhlxhYJhFHwyo5G
         CE2Y4QVSrDwOegMTWtHULgRXNLKoV6X/xSOI7rlAvZUBfbq/+JrdkvXzaZhm6wULIH
         g8fHDRfM2KFKzF2X9y1QXr9DsRngCpluRM+VHQ2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 133/243] drm/gma500: Add the missed drm_gem_object_put() in psb_user_framebuffer_create()
Date:   Mon, 19 Jul 2021 16:52:42 +0200
Message-Id: <20210719144945.209433073@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
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
index 54d9876b5305..6ef4ea07d1bb 100644
--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -435,6 +435,7 @@ static struct drm_framebuffer *psb_user_framebuffer_create
 			 const struct drm_mode_fb_cmd2 *cmd)
 {
 	struct drm_gem_object *obj;
+	struct drm_framebuffer *fb;
 
 	/*
 	 *	Find the GEM object and thus the gtt range object that is
@@ -445,7 +446,11 @@ static struct drm_framebuffer *psb_user_framebuffer_create
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



