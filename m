Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97B963C8E9
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 21:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237193AbiK2UDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 15:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237192AbiK2UDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 15:03:01 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AB817E22;
        Tue, 29 Nov 2022 12:02:59 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id y17so6617091plp.3;
        Tue, 29 Nov 2022 12:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KmLZiaEVkjJr8RiYF6yToHXQoLPPBZhOHiujuwoMMv8=;
        b=Dz7C3calMnoC2yh0ZC4zZ18Y3+Fg658tq9lsj9p0WciuPXjgUd+tVvWl0Lc62p6jVW
         r2Bd5aY2VRPWULHTa6j95JU+cnKHKPHnhokZ8HHRUkXMxDRfKyho4TJOBtfLMgnN+jtk
         6qX+OzHN0jn37opP0t8b0WA97hE2SX19L9NufPseOkLxo9fx3ln3D27ws/2/FmFfLWBs
         2QiVp247MYChRznqD8zQlY1Lq6+md5jBcmE2ngOip1Im7cI9Rx6uQL1xuibovEpkTLY9
         POfy1S6VtEZK9vsQvB5mLbG+0CGKZwNmlz/ChDoSF5CaH+QBXV5gMYFobvOGJ+Jp5ez7
         mLzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KmLZiaEVkjJr8RiYF6yToHXQoLPPBZhOHiujuwoMMv8=;
        b=S7pxbw4PUyLUtUIrEQdYroomjl8+jdR330+KaDLk3ZXch6HlLkKZMtuLz0NacRhPqC
         K+ms40Z34BlsnJr8zBJB8dm3I0IIvhFANENJL6zynEn1qPIYDb1xeWwMloOHh8bgD+d1
         JP4qShSSr2lF6pM4zT9C8SEdXuTzB8TLleyO1134nyjDVLRrb3BDwaPM5q8j913jl3da
         EklmTXYrLUuplEqkwsawQlf+LdgBYv1wGRZLmkYSnGIyxOIU3UMlAbn5V0tYo4q+1N5C
         wDteGR6Ny1MMzd7leSZRWrGqY0N+PGHdxy0uLSIyjCcRPYeloi4vVdf8IGBysDnWs/r4
         IGEQ==
X-Gm-Message-State: ANoB5plFTbpgktu9inR6h4pOe/tJUios2seTBqvCFq8EVMV/SOmLIQGO
        3U9rNcKeYAWJ7wihGcpMAa4=
X-Google-Smtp-Source: AA0mqf58iGfyCo4hDR+2yRciiyJd2DTGXcfQcykl7GdRzbd7PwYHNjjcg3PQcDS5ZyQve/9BqimogA==
X-Received: by 2002:a17:902:dac6:b0:189:7105:59e8 with SMTP id q6-20020a170902dac600b00189710559e8mr19846111plx.50.1669752179326;
        Tue, 29 Nov 2022 12:02:59 -0800 (PST)
Received: from localhost ([2a00:79e1:abd:4a00:2703:3c72:eb1a:cffd])
        by smtp.gmail.com with ESMTPSA id q5-20020a17090311c500b00186985198a4sm11337838plh.169.2022.11.29.12.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 12:02:58 -0800 (PST)
From:   Rob Clark <robdclark@gmail.com>
To:     dri-devel@lists.freedesktop.org
Cc:     Daniel Vetter <daniel@ffwll.ch>,
        Rob Clark <robdclark@chromium.org>, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Eric Anholt <eric@anholt.net>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Rob Herring <robh@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] drm/shmem-helper: Avoid vm_open error paths
Date:   Tue, 29 Nov 2022 12:02:42 -0800
Message-Id: <20221129200242.298120-3-robdclark@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221129200242.298120-1-robdclark@gmail.com>
References: <20221129200242.298120-1-robdclark@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

vm_open() is not allowed to fail.  Fortunately we are guaranteed that
the pages are already pinned, and only need to increment the refcnt.  So
just increment it directly.

Fixes: 2194a63a818d ("drm: Add library for shmem backed GEM objects")
Cc: stable@vger.kernel.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 110a9eac2af8..9885ba64127f 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -571,12 +571,20 @@ static void drm_gem_shmem_vm_open(struct vm_area_struct *vma)
 {
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
-	int ret;
 
 	WARN_ON(shmem->base.import_attach);
 
-	ret = drm_gem_shmem_get_pages(shmem);
-	WARN_ON_ONCE(ret != 0);
+	mutex_lock(&shmem->pages_lock);
+
+	/*
+	 * We should have already pinned the pages, vm_open() just grabs
+	 * an additional reference for the new mm the vma is getting
+	 * copied into.
+	 */
+	WARN_ON_ONCE(!shmem->pages_use_count);
+
+	shmem->pages_use_count++;
+	mutex_unlock(&shmem->pages_lock);
 
 	drm_gem_vm_open(vma);
 }
-- 
2.38.1

