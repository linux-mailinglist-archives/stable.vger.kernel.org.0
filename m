Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026C1284CB7
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 15:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgJFNwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 09:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgJFNwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 09:52:43 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A15AC061755
        for <stable@vger.kernel.org>; Tue,  6 Oct 2020 06:52:43 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id b2so5339521wrs.7
        for <stable@vger.kernel.org>; Tue, 06 Oct 2020 06:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=0/KrUMvwQXva+lzA+DlFEkL13NaRZBhRto1HakTvgp4=;
        b=hZJJN1Lw42Y1X9D94ao9Y0A+py4f1unF85FllwKfWiUc1687ep8L//LxMlq2r2JkpF
         gHTi93b5epdEiWVLyMRlTOBnyKXhUyuHTv9c4jEu8Lm1Xh/YAmAYs+TLkJGmePxDWsMF
         3Yj9FO+QPN7NEzDWa9gQg0Ls44hS/tlyg1J2Ga9ytnXXbjfmH18TP8NDmyLtUGIKJ/by
         Bdxvo0KiDlBDxkrvKYXAO+9mQW4VvC1H5CFHY2PjEEg/YF9+IGNVDzrWoLvdTg+/zjBH
         NififsUM5WlIzjrxHT9/NIvBpLGMmONKCwOi9Da/5BzzXDfGS8yb7Bmd+QVJNdZ4R1ez
         +wJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0/KrUMvwQXva+lzA+DlFEkL13NaRZBhRto1HakTvgp4=;
        b=jsJ4/o8Iu2g9pqQAfatDSj4XKA4Sn/k/zxcB0oGZaJ7WON0VznUG7mlvyR7CFU48ZU
         Anw0rZBgdLgkjRrC1XGIje+ZAYdtuoesiuoq3wyy4ECwm9ptmgaX2XWgF3JHMVGA5WuG
         0FOZ5YgF+wwurZEfjf8R8l3mYZzQwSxqU4yA6EOvBEwL+H812aDebaT7BVzRj86p+zS8
         wk/swFcFqvUpnpEGxnSVM2U+7sCWVWLqbQHwLTifNJsA2SHmoNRrOlZ9jQ//CG+BPuh1
         pUdojDZgF0xwdBw79UJQx4QbmLhR1gWgL6vt+k7VdwXbf52Nx0pAO8sYzKEkGxR+N0iL
         Sz+w==
X-Gm-Message-State: AOAM53118TLLtBAMDZOIUiT+PtU60dFE0LyPSIqWyBi/B3HJsMa1fkV2
        NAgR72ru+XGrYRz0ZDSu9YXCDWxrqz5qvA==
X-Google-Smtp-Source: ABdhPJx3BIxx0g0RHcGUtHOsjpbKI3qyZ1LmFaYaqoqqoPd6+dBR75MaFe75PhBQXS4y07lzWZ/lzWlRAftSUg==
Sender: "gprocida via sendgmr" <gprocida@tef.lon.corp.google.com>
X-Received: from tef.lon.corp.google.com ([2a00:79e0:d:110:a6ae:11ff:fe11:4f04])
 (user=gprocida job=sendgmr) by 2002:a5d:494c:: with SMTP id
 r12mr5084797wrs.406.1601992360857; Tue, 06 Oct 2020 06:52:40 -0700 (PDT)
Date:   Tue,  6 Oct 2020 14:52:28 +0100
In-Reply-To: <20201006135228.113259-1-gprocida@google.com>
Message-Id: <20201006135228.113259-2-gprocida@google.com>
Mime-Version: 1.0
References: <20201006135228.113259-1-gprocida@google.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH 1/1] drm/syncobj: Fix drm_syncobj_handle_to_fd refcount leak
From:   Giuliano Procida <gprocida@google.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e7cdf5c82f1773c3386b93bbcf13b9bfff29fa31 upstream.

The cherry-pick 5fb252cad61f of the above commit introduced a refcount
imbalance and so leak of struct drm_syncobj objects that can be
triggered with DRM_IOCTL_SYNCOBJ_HANDLE_TO_FD.

The function drm_syncobj_handle_to_fd first calls drm_syncobj_find
which increments the refcount of the object on success. In all of the
drm_syncobj_handle_to_fd error paths, the refcount is decremented, but
in the success path the refcount should remain at +1 as the struct
drm_syncobj now belongs to the newly opened file. Instead, the
refcount was incremented again to +2.

Fixes: 5fb252cad61f ("drm/syncobj: Stop reusing the same struct file for all syncobj -> fd")
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 drivers/gpu/drm/drm_syncobj.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_syncobj.c b/drivers/gpu/drm/drm_syncobj.c
index 889c95d4feec..3f71bc3d93fe 100644
--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -355,7 +355,6 @@ static int drm_syncobj_handle_to_fd(struct drm_file *file_private,
 		return PTR_ERR(file);
 	}
 
-	drm_syncobj_get(syncobj);
 	fd_install(fd, file);
 
 	*p_fd = fd;
-- 
2.28.0.806.g8561365e88-goog

