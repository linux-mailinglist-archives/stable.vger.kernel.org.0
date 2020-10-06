Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0AB284FB7
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 18:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgJFQUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 12:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgJFQUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 12:20:13 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD46C061755
        for <stable@vger.kernel.org>; Tue,  6 Oct 2020 09:20:13 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id s8so5671066qvv.18
        for <stable@vger.kernel.org>; Tue, 06 Oct 2020 09:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Kkcvd5AeUHu/7QI5btDqB8/5zh+GBy9XCmSrw8Y+2UA=;
        b=fPCODs0xooE+a5d2V0S0jOFztMOJ/Kyf9mqCErprr6eVSYKaMnesZJtkO6qDhtd/X/
         3SvhcjWFIdA56kJRtLTdIO0tS4qLDNZaRz3rbX0gzqtbTThxI8FY4i9cUzgCbgUaw3g8
         PTKj09wq0wQ74c95B6nkkNf3UX4sdkPVI4LSV1X9ZvUJgE/J+P/4uc3ld76JSjhJbCK+
         HGerYqG91YrsvTDnk0iOzDmxMRY0/yMGmFceQdtrQJ3sCzEtvNNo7WjlHOf2FxyWPa8q
         5pWF8iREOgBHhFSIraaJGvuwGvh/nysxkizP1YECfZmslOnIcSUHlX0BXzPdSAa2Sd7+
         CRsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Kkcvd5AeUHu/7QI5btDqB8/5zh+GBy9XCmSrw8Y+2UA=;
        b=YsptvYUYNim0q3v2r2+jHefYOuzLxS6XqwJiBJ7Ba0w6ybijQnN+QpWrXVFe09A2Yu
         NWqwy6ZYlqgZPd35r1Sw1UZGPLRX3/BWW28n0cvzsZtk56ijXORZLoOJ5a+lNkkxdRSI
         nUguJs7ExCVrCbM963WP+X7y/1m6bCxsPiEG8M10jIsBDtuHCAM0lmil0DofYvjy+G4S
         GPDpaZQrICEgpGF3iZBnDKqzQ40/jTCqz8K8qRPlT1mwgCYEa+45bDNIsCBwkuj1ZYj9
         8ZLmKy1xyf8A/9Vp51sSRJKvhsmUwoVJqhRI1g7zk9u5MO6cB4osfO9JWp1oYyEGPqX2
         0CEg==
X-Gm-Message-State: AOAM533EYI3tXFbDnyax+3RWT/tnsVylFWev7Fp52CN1dhQWmSQIhtFE
        6LGfqU/0Vv1Jois3aO4G8SeAKYzl+5/S0Q==
X-Google-Smtp-Source: ABdhPJxd/xgVJqr1AhI2WELy4n26SGJ0aX9Ur3GsQZdbPUU7dKeKgt51JRIvdI0Qy7eQ33vcg2GQDKKcN+hb/w==
Sender: "gprocida via sendgmr" <gprocida@tef.lon.corp.google.com>
X-Received: from tef.lon.corp.google.com ([2a00:79e0:d:110:a6ae:11ff:fe11:4f04])
 (user=gprocida job=sendgmr) by 2002:a05:6214:1752:: with SMTP id
 dc18mr5690393qvb.10.1602001212340; Tue, 06 Oct 2020 09:20:12 -0700 (PDT)
Date:   Tue,  6 Oct 2020 17:20:00 +0100
In-Reply-To: <20201006135228.113259-2-gprocida@google.com>
Message-Id: <20201006162000.1146391-1-gprocida@google.com>
Mime-Version: 1.0
References: <20201006135228.113259-2-gprocida@google.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH v2 1/1] drm/syncobj: Fix drm_syncobj_handle_to_fd refcount leak
From:   Giuliano Procida <gprocida@google.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 5fb252cad61f20ae5d5a8b199f6cc4faf6f418e1, a cherry-pick of
upstream commit e7cdf5c82f1773c3386b93bbcf13b9bfff29fa31, introduced a
refcount imbalance and thus a struct drm_syncobj object leak which can
be triggered with DRM_IOCTL_SYNCOBJ_HANDLE_TO_FD.

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

