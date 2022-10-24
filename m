Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E68C60AB8E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236632AbiJXNxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236600AbiJXNw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:52:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B318BBE3F;
        Mon, 24 Oct 2022 05:43:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C19F361311;
        Mon, 24 Oct 2022 12:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F32C433D7;
        Mon, 24 Oct 2022 12:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614783;
        bh=NPOknD0rJ0I/KWRESIDmNBsqO1xyQsFCXZyiqgfPqj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=op8mMeUZE0neJYd3c2Ogkvzi7dQTYt3NlU/AtTGF2f0oyeUHTW8A3kiaATVt+CVOQ
         +wEEU7vv+UkgTGcdYD+HVY8lCT8zhpU3LPBPZe4/NoJILzyNjhtidIcyB1CfHFJ8YT
         AsV9Vo2CRQZzJfw0+18E8jvaBDkVDDljNn86Zrmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.10 385/390] Revert "drm/amdgpu: use dirty framebuffer helper"
Date:   Mon, 24 Oct 2022 13:33:02 +0200
Message-Id: <20221024113039.374918348@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

This reverts commit 867b2b2b6802fb3995a0065fc39e0e7e20d8004d which is
commit 66f99628eb24409cb8feb5061f78283c8b65f820 upstream.

With this commit, dmesg fills up with the following messages and drm
initialization takes a very long time. This commit has bee reverted
from 5.4

[drm] Fence fallback timer expired on ring sdma0
[drm] Fence fallback timer expired on ring gfx
[drm] Fence fallback timer expired on ring sdma0
[drm] Fence fallback timer expired on ring gfx
[drm] Fence fallback timer expired on ring sdma0
[drm] Fence fallback timer expired on ring sdma0
[drm] Fence fallback timer expired on ring sdma0
[drm] Fence fallback timer expired on ring gfx

Cc: <stable@vger.kernel.org>    # 5.10
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -35,7 +35,6 @@
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
 #include <drm/drm_crtc_helper.h>
-#include <drm/drm_damage_helper.h>
 #include <drm/drm_edid.h>
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_fb_helper.h>
@@ -499,7 +498,6 @@ bool amdgpu_display_ddc_probe(struct amd
 static const struct drm_framebuffer_funcs amdgpu_fb_funcs = {
 	.destroy = drm_gem_fb_destroy,
 	.create_handle = drm_gem_fb_create_handle,
-	.dirty = drm_atomic_helper_dirtyfb,
 };
 
 uint32_t amdgpu_display_supported_domains(struct amdgpu_device *adev,


