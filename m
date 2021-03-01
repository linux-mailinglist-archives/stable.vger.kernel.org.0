Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47D9327B48
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 10:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbhCAJzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 04:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234324AbhCAJxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 04:53:45 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015E5C06174A
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 01:53:04 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id o7-20020a05600c4fc7b029010a0247d5f0so2670702wmq.1
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 01:53:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gCxNwSmtosKjBOsP3oJostPTdxL4pw1j5WTp0Gs5jN4=;
        b=aT/lpsg3hVIo/j/sXTbm1YQnEo2Mhu8qNhuBG1++3ci9SmJZnTW1ScmMGSFirtKKo+
         6p/wq16Ys3GaxMJGktYpmGy9yfrOinrwYQg8YIxDxaODMfAeY07P6X6DxvfKufZ+/jKz
         jcvC1b842TLcrMDiduAHx5Mt88Yg6pXG8VfZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gCxNwSmtosKjBOsP3oJostPTdxL4pw1j5WTp0Gs5jN4=;
        b=M08ENUEX2ZRxjEOyHpanA7nS78XxC8WzwagN/WVkakYFX4D7wj+VpmLWLC4kM630gR
         Zx4JasnWAoJrRO+aZs9GZlrXustgsj2sNAPK5O8ifj7hasagmmx9S06U5rd5sbXuURgN
         +R27Xh8RU+1T2I3ou103zbm58cAi6MVeCxTcTS7punNy/1ospY4VbMNfrPRiD9gDE6f4
         tLKETBJHLOre5oUJkfRtiWHqjoSDdUvP68XOn7tD5wbRWZhrVc5LghWjmrf24VDoLs/0
         Norc+KTEadOlGPpxnGAecUryVriPYWW1R2/Fd+m8s73RsDZyzGUW5iCIwHqRnfxIYcnA
         iAiQ==
X-Gm-Message-State: AOAM531hA5UJ0oUNcmkDR4axzviOF1U0IyC7NJ3Yoml9IbG6k60pzxdA
        VMLH/+eTIdzofS+ky2hjwRKiaA==
X-Google-Smtp-Source: ABdhPJzS9tzgwkxeKN9NVWheGzS19gf3IPi0FqJ1+eBzNy1c7Bj1uTvARfgNW1EOExC3AnAg0STfPw==
X-Received: by 2002:a7b:c242:: with SMTP id b2mr13089760wmj.119.1614592381781;
        Mon, 01 Mar 2021 01:53:01 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id c9sm21770155wmb.33.2021.03.01.01.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 01:53:00 -0800 (PST)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        etnaviv@lists.freedesktop.org
Subject: [PATCH 1/2] drm/etnaviv: Use FOLL_FORCE for userptr
Date:   Mon,  1 Mar 2021 10:52:53 +0100
Message-Id: <20210301095254.1946084-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Nothing checks userptr.ro except this call to pup_fast, which means
there's nothing actually preventing userspace from writing to this.
Which means you can just read-only mmap any file you want, userptr it
and then write to it with the gpu. Not good.

The right way to handle this is FOLL_WRITE | FOLL_FORCE, which will
break any COW mappings and update tracking for MAY_WRITE mappings so
there's no exploit and the vm isn't confused about what's going on.
For any legit use case there's no difference from what userspace can
observe and do.

Cc: stable@vger.kernel.org
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Russell King <linux+etnaviv@armlinux.org.uk>
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: etnaviv@lists.freedesktop.org
---
 drivers/gpu/drm/etnaviv/etnaviv_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem.c b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
index 6d38c5c17f23..a9e696d05b33 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -689,7 +689,7 @@ static int etnaviv_gem_userptr_get_pages(struct etnaviv_gem_object *etnaviv_obj)
 		struct page **pages = pvec + pinned;
 
 		ret = pin_user_pages_fast(ptr, num_pages,
-					  !userptr->ro ? FOLL_WRITE : 0, pages);
+					  FOLL_WRITE | FOLL_FORCE, pages);
 		if (ret < 0) {
 			unpin_user_pages(pvec, pinned);
 			kvfree(pvec);
-- 
2.30.0

