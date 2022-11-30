Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF2563E05B
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbiK3S6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiK3S55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:57:57 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40E543AF9;
        Wed, 30 Nov 2022 10:57:56 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id p24so13868228plw.1;
        Wed, 30 Nov 2022 10:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=443GVmcToH/y8glGR0fFoR2riM937PfQ5f3l05L3jxo=;
        b=nU5cx5ZeKoq3BQaltqdsx6egPMVueQQzwxAPy9tlM9TmEdoE3QctSFV5PK711ntz+M
         c3UIPubekuFGIAJW8HGycbOjmB4h5XlOpZK00YpUtvh6TszI58RY4FyR76sBEYXCRpJ3
         WZgg06t29/5muKCfY7GxFyilfZ4chVwf2O/4txjgp3U+pS+x1Qcerl0t/Xj0H5uDbMus
         1eZR+BfVQZBVA3ctLiURgDnE5yo9nje22jRt3h9ZalnN5DYLS364MiwA9Off5ZZfuIUH
         dQ+/NB5/sHleF9fmbkuZUsIVWh1L686M/A/wp/lMagmZtzYKlgXvlL7OaT3nBWi1gX2V
         NFCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=443GVmcToH/y8glGR0fFoR2riM937PfQ5f3l05L3jxo=;
        b=hvC+5tA2/sqpZA4Up4o3FqSZjMM1Rvx8W3nH06lHvb+3nkfMOwYefDDkxpzjAcWiqS
         HSZVGhy/epOcqjlkWqFVwTK/PT5wMCd2GAdbWfZL//b21GFaUANVCIkMYtuNxWrskFe9
         aDtPFZN3ztVw/pBwIU4rZP5SEzRIch9/QNf5pk9B+QIYmvB3SKpGrC5ehI+hXO5RNCgz
         gHhEWLE7nHfiG0zw/IZ1N7zrZT6k+Q8Qf55+93upw1OUzm6Qo+OJ1z1vQPUNFm9UmRGd
         ko4yaoBK1PvqTPp9a6kLaCwKZpITGiXbS7X9HEfRfe1UzVctAyWq/tUQsxtl7ZC3Q+dO
         f/jg==
X-Gm-Message-State: ANoB5pnMgK3m2xJHkQl4wqrdTKR08YIsI/xlXwr1k1JIwqiqNcLEHvuk
        gpRvB/ONoNjIJt76DERRCow=
X-Google-Smtp-Source: AA0mqf7TzMsWbL38UL/eRb+KGt8aU0pyZLP1+wMxjW8tk5BT/J69QqzSiQrv4oAbTk6NlputMW1O1g==
X-Received: by 2002:a17:903:2112:b0:188:7dca:6f41 with SMTP id o18-20020a170903211200b001887dca6f41mr43302945ple.72.1669834676369;
        Wed, 30 Nov 2022 10:57:56 -0800 (PST)
Received: from localhost ([2a00:79e1:abd:4a00:2703:3c72:eb1a:cffd])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902654600b00188f3970d4asm1823737pln.163.2022.11.30.10.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 10:57:56 -0800 (PST)
From:   Rob Clark <robdclark@gmail.com>
To:     dri-devel@lists.freedesktop.org
Cc:     Daniel Vetter <daniel@ffwll.ch>,
        Rob Clark <robdclark@chromium.org>,
        syzbot+c8ae65286134dd1b800d@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Eric Anholt <eric@anholt.net>, Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/2] drm/shmem-helper: Remove errant put in error path
Date:   Wed, 30 Nov 2022 10:57:47 -0800
Message-Id: <20221130185748.357410-2-robdclark@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130185748.357410-1-robdclark@gmail.com>
References: <20221130185748.357410-1-robdclark@gmail.com>
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

drm_gem_shmem_mmap() doesn't own this reference, resulting in the GEM
object getting prematurely freed leading to a later use-after-free.

Link: https://syzkaller.appspot.com/bug?extid=c8ae65286134dd1b800d
Reported-by: syzbot+c8ae65286134dd1b800d@syzkaller.appspotmail.com
Fixes: 2194a63a818d ("drm: Add library for shmem backed GEM objects")
Cc: stable@vger.kernel.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 35138f8a375c..3b7b71391a4c 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -622,10 +622,8 @@ int drm_gem_shmem_mmap(struct drm_gem_shmem_object *shmem, struct vm_area_struct
 	}
 
 	ret = drm_gem_shmem_get_pages(shmem);
-	if (ret) {
-		drm_gem_vm_close(vma);
+	if (ret)
 		return ret;
-	}
 
 	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
-- 
2.38.1

