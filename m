Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021155903B0
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237908AbiHKQYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237911AbiHKQXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:23:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F90103D;
        Thu, 11 Aug 2022 09:05:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11098B821AF;
        Thu, 11 Aug 2022 16:05:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704A4C433C1;
        Thu, 11 Aug 2022 16:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233909;
        bh=QWsvTVdOsB728owrMyfiqkNbfhBqYwdkZ8D14NLC2D4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJ9hxBn/0PENmMv6RQ4eUXO3h8Sp0EVsM7nR+lVA7kdBcrMrb8y26m+O9Y2/45HDL
         EU/U7t6TrJ3erNvBQE2OAVowldvaSLvrNcoqrqE2AreqwsQstT5m5n6jVCEtXrKBmk
         sN+wHCm6SXqWREDYteD8QRJKwmC8mva63uvY0/0zy575zAIIiiAUXLXIkgbvKN0E7Y
         P/q9Wl++Bivx2nkSoSeBwJRn5QupMsW7fQGy5XsQv6FaIZUZM8ruw4wgS31t11ZR3Z
         6g3KIdPKByE+IqWjV+vpDpo4TKzE+qNNhQ6oQ56Nh+7poY1/oXbIz+Cec85xFsoxih
         rN86hXgIITqLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 10/46] drm/radeon: integer overflow in radeon_mode_dumb_create()
Date:   Thu, 11 Aug 2022 12:03:34 -0400
Message-Id: <20220811160421.1539956-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160421.1539956-1-sashal@kernel.org>
References: <20220811160421.1539956-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>

[ Upstream commit feb54650bae25f2a2adfc493e3e254e7c27a3fba ]

Similar to the handling of amdgpu_mode_dumb_create in commit 54ef0b5461c0
("drm/amdgpu: integer overflow in amdgpu_mode_dumb_create()"),
we thought a patch might be needed here as well.

args->size is a u64.  arg->pitch and args->height are u32.  The
multiplication will overflow instead of using the high 32 bits as
intended.

Signed-off-by: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
index e5c4271e64ed..ac56d1dec214 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -758,7 +758,7 @@ int radeon_mode_dumb_create(struct drm_file *file_priv,
 
 	args->pitch = radeon_align_pitch(rdev, args->width,
 					 DIV_ROUND_UP(args->bpp, 8), 0);
-	args->size = args->pitch * args->height;
+	args->size = (u64)args->pitch * args->height;
 	args->size = ALIGN(args->size, PAGE_SIZE);
 
 	r = radeon_gem_object_create(rdev, args->size, 0,
-- 
2.35.1

