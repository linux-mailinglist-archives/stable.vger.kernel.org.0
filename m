Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A4465D5E5
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbjADOhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjADOhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:37:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E27426E1
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:37:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD6C161763
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD05CC433D2;
        Wed,  4 Jan 2023 14:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843043;
        bh=DASTPqVkIyhfB4adtdnhNqEkueNUpmnbyVrX6jg53u8=;
        h=Subject:To:Cc:From:Date:From;
        b=fAO2jxzXqE2B+JAf5jVyk+m2/3DgVQe2/JA8OnPY7QUjYb7FPHZf7/rt54wA/sXau
         cUiv7FxmxxUcj2W+ZXgPLEj35zchgTPvnl5+vv9AYj0llSe5WoBDoxFq0GwoR8ZxTD
         YJsDZLXYUZ2gnZ4hUnkgipyIrSfHuZXOrTBkICvs=
Subject: FAILED: patch "[PATCH] drm/amdgpu: always register an MMU notifier for userptr" failed to apply to 6.0-stable tree
To:     christian.koenig@amd.com, Felix.Kuehling@amd.com,
        alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:37:12 +0100
Message-ID: <1672843032204123@kroah.com>
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


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

631945e04e1e ("drm/amdgpu: always register an MMU notifier for userptr")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 631945e04e1e243a503089f4487cad797476e8ca Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Date: Wed, 9 Nov 2022 12:14:44 +0100
Subject: [PATCH] drm/amdgpu: always register an MMU notifier for userptr
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since switching to HMM we always need that because we no longer grab
references to the pages.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
CC: stable@vger.kernel.org
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index 8ef31d687ef3..111484ceb47d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -413,11 +413,9 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
 	if (r)
 		goto release_object;
 
-	if (args->flags & AMDGPU_GEM_USERPTR_REGISTER) {
-		r = amdgpu_mn_register(bo, args->addr);
-		if (r)
-			goto release_object;
-	}
+	r = amdgpu_mn_register(bo, args->addr);
+	if (r)
+		goto release_object;
 
 	if (args->flags & AMDGPU_GEM_USERPTR_VALIDATE) {
 		r = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages);

