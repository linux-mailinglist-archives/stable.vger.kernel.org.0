Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC522FB921
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 15:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395426AbhASOS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 09:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392628AbhASNOy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 08:14:54 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA967C061575
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 05:03:25 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id d13so19615538wrc.13
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 05:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6eQxUJyYjcpNGooFF9KRs2Vh+KrO03OdwmCtwKSfd84=;
        b=MU7h5plTlVYOi/yfhjJTaNzyweuruZca1u8+HHloNOKuF8gBNLzBusXXLTe2d15BEQ
         8KOVUb41KS0I/1q1kAg21ioRKUIW/xsWyVo7lhctUOq7CeRA2dfjRz6kQbwRtn4x8FSA
         zJtV6eUcitlWHfHPCg/q0aLKywUZL9D0FGIoI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6eQxUJyYjcpNGooFF9KRs2Vh+KrO03OdwmCtwKSfd84=;
        b=WWgguErBMnkJ6mMxlsGaEZdkhFTuqJhyw1Vc1V9oFa1HDKSgxT1zSBJ9a3GbzV6Q8I
         nfGYoufBsKHQQ9C8FIQRN34sMVfKgOYw6qKj30+PHfSJIOICaQvPGsiag09LsUSLay+i
         CWr1+2fGWhJyk19dq9GF3XRdSIdtlcnFu1jxBMre3T50c/w5jHtaqJpYscKbvX+K0Q4Y
         /d7p5um7yfNULLaOIvpXP1WGj2E8oFsQKSTuHprQ20v4An+3sCPxRgMD6qZMMdjitvKo
         LkDDcici/J+rgnjZqK39Af5z0ikoIYK3UtfnMhZmv2GOaQ/k8cFgwI/Z10r7wNSU0yOO
         jzLg==
X-Gm-Message-State: AOAM533fUFcF0v5L64ndA8PU3mpMpxluw0Kmw2MgfDUyAQaZvU6/2rts
        3lJIJr/m0X4v/q20qrqH68Adsw==
X-Google-Smtp-Source: ABdhPJxqEPlIGfDQZaX8UsE/8nzHzaavKyzbXjfCRpikMKlcA1u5hp+8qeTjF7c6ulNmawxfxXraxA==
X-Received: by 2002:adf:90e3:: with SMTP id i90mr4510035wri.248.1611061404477;
        Tue, 19 Jan 2021 05:03:24 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id d199sm3546715wmd.1.2021.01.19.05.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 05:03:23 -0800 (PST)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org
Subject: [PATCH] drm/syncobj: Fix use-after-free
Date:   Tue, 19 Jan 2021 14:03:18 +0100
Message-Id: <20210119130318.615145-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While reviewing Christian's annotation patch I noticed that we have a
user-after-free for the WAIT_FOR_SUBMIT case: We drop the syncobj
reference before we've completed the waiting.

Of course usually there's nothing bad happening here since userspace
keeps the reference, but we can't rely on userspace to play nice here!

Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Fixes: bc9c80fe01a2 ("drm/syncobj: use the timeline point in drm_syncobj_find_fence v4")
Cc: Christian König <christian.koenig@amd.com>
Cc: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.2+
---
 drivers/gpu/drm/drm_syncobj.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_syncobj.c b/drivers/gpu/drm/drm_syncobj.c
index 6e74e6745eca..349146049849 100644
--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -388,19 +388,18 @@ int drm_syncobj_find_fence(struct drm_file *file_private,
 		return -ENOENT;
 
 	*fence = drm_syncobj_fence_get(syncobj);
-	drm_syncobj_put(syncobj);
 
 	if (*fence) {
 		ret = dma_fence_chain_find_seqno(fence, point);
 		if (!ret)
-			return 0;
+			goto out;
 		dma_fence_put(*fence);
 	} else {
 		ret = -EINVAL;
 	}
 
 	if (!(flags & DRM_SYNCOBJ_WAIT_FLAGS_WAIT_FOR_SUBMIT))
-		return ret;
+		goto out;
 
 	memset(&wait, 0, sizeof(wait));
 	wait.task = current;
@@ -432,6 +431,9 @@ int drm_syncobj_find_fence(struct drm_file *file_private,
 	if (wait.node.next)
 		drm_syncobj_remove_wait(syncobj, &wait);
 
+out:
+	drm_syncobj_put(syncobj);
+
 	return ret;
 }
 EXPORT_SYMBOL(drm_syncobj_find_fence);
-- 
2.30.0

