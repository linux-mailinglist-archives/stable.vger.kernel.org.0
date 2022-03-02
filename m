Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0394CA8FE
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 16:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243396AbiCBPZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 10:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbiCBPZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 10:25:30 -0500
Received: from letterbox.kde.org (letterbox.kde.org [IPv6:2001:41c9:1:41e::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A11B0EB0
        for <stable@vger.kernel.org>; Wed,  2 Mar 2022 07:24:46 -0800 (PST)
Received: from vertex.localdomain (pool-108-36-85-85.phlapa.fios.verizon.net [108.36.85.85])
        (Authenticated sender: zack)
        by letterbox.kde.org (Postfix) with ESMTPSA id 7317C2872A2;
        Wed,  2 Mar 2022 15:24:43 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kde.org; s=users;
        t=1646234684; bh=4F+X8uCueyglrdMPtpqYPHzWxJyIY+coz153bAv64Es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRZ1Ib/2xpoqWMfsHeACmcfrl93ooVNYLBgZe1p5jWgOhz9LR0La+Rkzyl/zMARRx
         mg1UT+E4sXAey+hHPej9OL2MQS2xX81H264DAWG2G5xPYx4KvPnyLg7VoDZSoSp0Ot
         PmuQofqJ9KqnvIDjBmnXv2MCZK54v76Y1SUXChL7m7C+WlDeknEF4jIMl5IVhPqgEM
         +kay10V2UqM8+yDFAHibEYNgBtooWIe0fXLbR6v6lZlfCf1AaoTQheongo4rZ0I2F7
         PUJ8rwpfiXVYIcRrT0Z3yb5HHs+LRcg4SVsmTa6tMLUfUgcQwnL9U/p0rBeaVxRYYo
         +HZlBuLaxGjoA==
From:   Zack Rusin <zack@kde.org>
To:     dri-devel@lists.freedesktop.org
Cc:     krastevm@vmware.com, mombasawalam@vmware.com,
        Zack Rusin <zackr@vmware.com>,
        Daniel Vetter <daniel.vetter@intel.com>, stable@vger.kernel.org
Subject: [PATCH 6/8] drm/vmwgfx: Initialize drm_mode_fb_cmd2
Date:   Wed,  2 Mar 2022 10:24:24 -0500
Message-Id: <20220302152426.885214-7-zack@kde.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302152426.885214-1-zack@kde.org>
References: <20220302152426.885214-1-zack@kde.org>
Reply-To: Zack Rusin <zackr@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

Transition to drm_mode_fb_cmd2 from drm_mode_fb_cmd left the structure
unitialized. drm_mode_fb_cmd2 adds a few additional members, e.g. flags
and modifiers which were never initialized. Garbage in those members
can cause random failures during the bringup of the fbcon.

Initializing the structure fixes random blank screens after bootup due
to flags/modifiers mismatches during the fbcon bring up.

Fixes: dabdcdc9822a ("drm/vmwgfx: Switch to mode_cmd2")
Signed-off-by: Zack Rusin <zackr@vmware.com>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: <stable@vger.kernel.org> # v4.10+
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Reviewed-by: Maaz Mombasawala <mombasawalam@vmware.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
index 8ee34576c7d0..adf17c740656 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
@@ -483,7 +483,7 @@ static int vmw_fb_kms_detach(struct vmw_fb_par *par,
 
 static int vmw_fb_kms_framebuffer(struct fb_info *info)
 {
-	struct drm_mode_fb_cmd2 mode_cmd;
+	struct drm_mode_fb_cmd2 mode_cmd = {0};
 	struct vmw_fb_par *par = info->par;
 	struct fb_var_screeninfo *var = &info->var;
 	struct drm_framebuffer *cur_fb;
-- 
2.32.0

