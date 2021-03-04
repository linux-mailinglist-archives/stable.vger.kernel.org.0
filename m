Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245BC32D613
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 16:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbhCDPHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 10:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbhCDPHE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 10:07:04 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10645C06175F
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 07:06:24 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id e6so19065112pgk.5
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 07:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sZKqfpm8IjXiAEdtnH0VRPDcK82+zaqpz3V3xRYBT7g=;
        b=iv9hbNga2wnoKTg9YfCQzOhVxB2gYJmvTml4LSz8hdkATjhGRmEsPQAVVMAjYx3U8k
         0JgQGsDsQDMGBfsAE/OHAwOFI+ErwO26RYoW67PYfsOD8NwtzoCqcVvlHIU52nSY4hAP
         wgq4G24EiZVtPGNg2rSABlw/5aSxtXZENIQNI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sZKqfpm8IjXiAEdtnH0VRPDcK82+zaqpz3V3xRYBT7g=;
        b=jAThEyC7FexTu+jUe2aUgydU1QyplGXvqLPCVIolc2KcwjrYPzNEZouISpmgouehe5
         ggOZMT5mx6HEREQil5h3Cm6G2qLNlx2d1PFhCjqR5ORjGKwsSpOez4x1IHrvN/+04s9d
         6ODmVX6BaPowqM5IpuqMsCqs95ma8XHwjYlfFQ1/jKbdEwSqCcQcHAi3DC6N5oB0OAtk
         rWey5PyBARGmfARHoSAsgaate0bY395mEpTQo1y5008KqBPe5YTlGm5kJKjSC8PdyU7s
         iAVToi3DBDbExqJ7u2WN5FWhLktjn091TNPLMf7b+NTcZcmxH+fE1buW3FNkwf9GUsb1
         ODOg==
X-Gm-Message-State: AOAM531vv4Jc9UGAuztcotYI5tssLtoy0yGbbSHRiWRndVE0ZchcZ5uB
        FYYV9PGpD/jp01hgwGXlZHcZPg==
X-Google-Smtp-Source: ABdhPJzhHZzEba1+Q9TLCSrzLMEDr6adh3yqanlnbd2AtmaAY851ndBY84XaTs7/lcDvOwkqswfewQ==
X-Received: by 2002:a05:6a00:1502:b029:1d2:72e7:a9db with SMTP id q2-20020a056a001502b02901d272e7a9dbmr4196609pfu.42.1614870383639;
        Thu, 04 Mar 2021 07:06:23 -0800 (PST)
Received: from senozhatsky.flets-east.jp ([2409:10:2e40:5100:7c25:421c:68d6:6590])
        by smtp.gmail.com with ESMTPSA id c12sm10003384pjq.48.2021.03.04.07.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 07:06:23 -0800 (PST)
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     adelva@google.com, kaiyili@google.com,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        stable@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
        Doug Horn <doughorn@google.com>
Subject: [PATCH] drm/virtio: use kvmalloc for large allocations
Date:   Fri,  5 Mar 2021 00:05:41 +0900
Message-Id: <20210304150541.212611-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
In-Reply-To: <20210302223800.1703918-1-doughorn@google.com>
References: <20210302223800.1703918-1-doughorn@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Senozhatsky <senozhatsky@chromium.org>

commit ea86f3defd55f141a44146e66cbf8ffb683d60da upstream.

We observed that some of virtio_gpu_object_shmem_init() allocations
can be rather costly - order 6 - which can be difficult to fulfill
under memory pressure conditions. Switch to kvmalloc_array() in
virtio_gpu_object_shmem_init() and let the kernel vmalloc the entries
array.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Link: http://patchwork.freedesktop.org/patch/msgid/20201105014744.1662226-1-senozhatsky@chromium.org
Cc: stable@vger.kernel.org [5.4]
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Doug Horn <doughorn@google.com>
---
 drivers/gpu/drm/virtio/virtgpu_vq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index 92022a83bbd5..bb46e7a0f1b5 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -992,8 +992,9 @@ int virtio_gpu_object_attach(struct virtio_gpu_device *vgdev,
 	}
 
 	/* gets freed when the ring has consumed it */
-	ents = kmalloc_array(nents, sizeof(struct virtio_gpu_mem_entry),
-			     GFP_KERNEL);
+	ents = kvmalloc_array(nents,
+			      sizeof(struct virtio_gpu_mem_entry),
+			      GFP_KERNEL);
 	if (!ents) {
 		DRM_ERROR("failed to allocate ent list\n");
 		return -ENOMEM;
-- 
2.30.1.766.gb4fecdf3b7-goog

