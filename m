Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292016CC3FA
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbjC1O6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbjC1O6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:58:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97205E38B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:58:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01EBB61828
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07829C433EF;
        Tue, 28 Mar 2023 14:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015511;
        bh=Ld89raY8Rvv136vl4jhY7EUToqD9arrbiDe/fMnC/wI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UasOHcf8S31h467rgTM5X221hOJPQVCTYh4E10WXQOvL0E611+zhSbPnCcdI6Vvot
         qnmuS+hK/2ypJjbPuRNsly7wkHLuIFdnxkF2MQ4+/9Q5SXTwacVZUCqrdPAMzCNoSH
         WoHwKNv7X13kOnOIBmGYJRRDsS+95itQmKwpGzr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nirmoy Das <nirmoy.das@intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/224] drm/i915: Print return value on error
Date:   Tue, 28 Mar 2023 16:40:44 +0200
Message-Id: <20230328142619.390173078@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@intel.com>

[ Upstream commit 20c68127e8e9d7899001c47465d0b79581f5fdc1 ]

Print returned error code for better debuggability.

Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221014154655.14075-1-nirmoy.das@intel.com
Stable-dep-of: ed00eba03474 ("drm/i915/fbdev: lock the fbdev obj before vma pin")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_fbdev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_fbdev.c b/drivers/gpu/drm/i915/display/intel_fbdev.c
index 9899b5dcd291d..d9b42905bad84 100644
--- a/drivers/gpu/drm/i915/display/intel_fbdev.c
+++ b/drivers/gpu/drm/i915/display/intel_fbdev.c
@@ -175,7 +175,7 @@ static int intelfb_alloc(struct drm_fb_helper *helper,
 	}
 
 	if (IS_ERR(obj)) {
-		drm_err(&dev_priv->drm, "failed to allocate framebuffer\n");
+		drm_err(&dev_priv->drm, "failed to allocate framebuffer (%pe)\n", obj);
 		return PTR_ERR(obj);
 	}
 
@@ -256,7 +256,7 @@ static int intelfb_create(struct drm_fb_helper *helper,
 
 	info = drm_fb_helper_alloc_fbi(helper);
 	if (IS_ERR(info)) {
-		drm_err(&dev_priv->drm, "Failed to allocate fb_info\n");
+		drm_err(&dev_priv->drm, "Failed to allocate fb_info (%pe)\n", info);
 		ret = PTR_ERR(info);
 		goto out_unpin;
 	}
@@ -291,7 +291,7 @@ static int intelfb_create(struct drm_fb_helper *helper,
 	vaddr = i915_vma_pin_iomap(vma);
 	if (IS_ERR(vaddr)) {
 		drm_err(&dev_priv->drm,
-			"Failed to remap framebuffer into virtual memory\n");
+			"Failed to remap framebuffer into virtual memory (%pe)\n", vaddr);
 		ret = PTR_ERR(vaddr);
 		goto out_unpin;
 	}
-- 
2.39.2



