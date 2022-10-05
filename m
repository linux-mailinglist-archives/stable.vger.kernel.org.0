Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD135F53B9
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiJELjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiJELif (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:38:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7D679608;
        Wed,  5 Oct 2022 04:35:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93BEE6164C;
        Wed,  5 Oct 2022 11:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4755C433D6;
        Wed,  5 Oct 2022 11:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969700;
        bh=myyM/cpOxrZJqyMCFSWCCMivBd348xIo/wFw2g9wxm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4qMwT9XujtN6nfjXauwtjy1HupfwnsSehfevg5cuF5qbQ095GAldp4hY56lOAb+5
         9u9lJ8o/vA0Botx7175YtEgoUXaRbnJj9KJkU+/8Hh2t014toLZmDNb6tZzQXXR6sW
         gyt3GefCaBmoMawKCpH6dPC0Xj7p0TOVwsnaXPsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 49/51] Revert "drm/amdgpu: use dirty framebuffer helper"
Date:   Wed,  5 Oct 2022 13:32:37 +0200
Message-Id: <20221005113212.519468645@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
References: <20221005113210.255710920@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit c89849ecfd2e10838b31c519c2a6607266b58f02 which is
commit 66f99628eb24409cb8feb5061f78283c8b65f820 upstream.

It is reported to cause problems on 5.4.y so it should be reverted for
now.

Reported-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/7af02bc3-c0f2-7326-e467-02549e88c9ce@linuxfoundation.org
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Sasha Levin <sashal@kernel.org>
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
@@ -496,7 +495,6 @@ bool amdgpu_display_ddc_probe(struct amd
 static const struct drm_framebuffer_funcs amdgpu_fb_funcs = {
 	.destroy = drm_gem_fb_destroy,
 	.create_handle = drm_gem_fb_create_handle,
-	.dirty = drm_atomic_helper_dirtyfb,
 };
 
 uint32_t amdgpu_display_supported_domains(struct amdgpu_device *adev,


