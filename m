Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8E42181B2
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 09:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgGHHtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 03:49:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:36412 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbgGHHtP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 03:49:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3B24EAF7A;
        Wed,  8 Jul 2020 07:49:15 +0000 (UTC)
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     airlied@redhat.com, daniel@ffwll.ch, sam@ravnborg.org,
        noralf@tronnes.org, emil.l.velikov@gmail.com,
        yc_chen@aspeedtech.com
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org
Subject: [PATCH 5/6] drm/ast: Initialize DRAM type before posting GPU
Date:   Wed,  8 Jul 2020 09:49:11 +0200
Message-Id: <20200708074912.25422-6-tzimmermann@suse.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200708074912.25422-1-tzimmermann@suse.de>
References: <20200708074912.25422-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Posting the GPU requires the correct DRAM type to be stored in
struct ast_private. Therefore first initialize the DRAM info and
then post the GPU. This restores the original order of instructions
in this function.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: bad09da6deab ("drm/ast: Fixed vram size incorrect issue on POWER")
Cc: Joel Stanley <joel@jms.id.au>
Cc: Y.C. Chen <yc_chen@aspeedtech.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Emil Velikov <emil.l.velikov@gmail.com>
Cc: "Y.C. Chen" <yc_chen@aspeedtech.com>
Cc: <stable@vger.kernel.org> # v4.11+
---
 drivers/gpu/drm/ast/ast_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_main.c b/drivers/gpu/drm/ast/ast_main.c
index b162cc82204d..87e5baded2a7 100644
--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -418,15 +418,15 @@ int ast_driver_load(struct drm_device *dev, unsigned long flags)
 
 	ast_detect_chip(dev, &need_post);
 
-	if (need_post)
-		ast_post_gpu(dev);
-
 	ret = ast_get_dram_info(dev);
 	if (ret)
 		goto out_free;
 	drm_info(dev, "dram MCLK=%u Mhz type=%d bus_width=%d\n",
 		 ast->mclk, ast->dram_type, ast->dram_bus_width);
 
+	if (need_post)
+		ast_post_gpu(dev);
+
 	ret = ast_mm_init(ast);
 	if (ret)
 		goto out_free;
-- 
2.27.0

