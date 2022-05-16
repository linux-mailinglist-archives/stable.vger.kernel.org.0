Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5459529112
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346507AbiEPULd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351097AbiEPUCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:02:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12772648;
        Mon, 16 May 2022 12:58:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FDAEB81614;
        Mon, 16 May 2022 19:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA99C34100;
        Mon, 16 May 2022 19:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731129;
        bh=WN2BNkInvGj0A55276VYzRrzw/MlqF8ZO3PtRBVvJOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hIP6bj2N1KfNrIdW8lrb/pTFFQdlDxC3cGTYQaSm5OBpD0X0KfW6kIY6UxvVhAAd4
         bUJE0bOAhmEjHCjLnc86a4p34dsNGHAdaubzaXJyYAao1sTWx6FPCqVrG2kr6QfMaS
         db7TD+vGRrpP37wdHWNIynssOAHGFe29Q1q3Uvgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zack Rusin <zackr@vmware.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Martin Krastev <krastevm@vmware.com>,
        Maaz Mombasawala <mombasawalam@vmware.com>
Subject: [PATCH 5.17 109/114] drm/vmwgfx: Initialize drm_mode_fb_cmd2
Date:   Mon, 16 May 2022 21:37:23 +0200
Message-Id: <20220516193628.602349592@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

commit 3059d9b9f6aa433a55b9d0d21b566396d5497c33 upstream.

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
Link: https://patchwork.freedesktop.org/patch/msgid/20220302152426.885214-7-zack@kde.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
@@ -483,7 +483,7 @@ static int vmw_fb_kms_detach(struct vmw_
 
 static int vmw_fb_kms_framebuffer(struct fb_info *info)
 {
-	struct drm_mode_fb_cmd2 mode_cmd;
+	struct drm_mode_fb_cmd2 mode_cmd = {0};
 	struct vmw_fb_par *par = info->par;
 	struct fb_var_screeninfo *var = &info->var;
 	struct drm_framebuffer *cur_fb;


