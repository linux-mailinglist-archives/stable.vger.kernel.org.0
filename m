Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA1232B054
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344712AbhCCAyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382738AbhCBWmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 17:42:52 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98789C061756
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 14:42:12 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id m68so3037679qkd.5
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 14:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:cc;
        bh=EmjSCJIQzKowmfybzIw2xmzY3e2wBh/G2X7ry+IVaXI=;
        b=r2pJDEQpZQN2M2XFfyq4lyKISs91wGkp8qhUu8egG+S27U4ibzAzuwWVqMo7HA/YqP
         bDqe5aSTBy0vn4wf3crfsBX01roWCp3SiU1UsXtY5hINWQ1nuIzDhv9UKcOiK0/LhRM4
         z/f1mt0q6noHjz+UfAHeVl8OOBfdqc5t6aarm7wU8i5KkqK98cP+Pax9tA/6S7/hHltg
         /bjNO6rcYg/vBvuZ6CA9Ihscp1ioavmiGTV8Kkp6+8CYK3V3C6i4BMoPaxSIwYNKQbR6
         kyzIUG72xmQru8Vgi3DjBsbPy5jWvlHbxicv8fdUN2kW8fJviDM38k+xe8iHTkdbAGH3
         XfBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :cc;
        bh=EmjSCJIQzKowmfybzIw2xmzY3e2wBh/G2X7ry+IVaXI=;
        b=p7l8rzFX/jmgGCAoTLTHTRv+dZ8alJPkRXaMm6omLB2Z0fGpW1HdiTA7TYOdT7VHbS
         5VDxELy0AguVdePyEcKpaJolX5Zp8FaZR+FsPin3k/pXX4FOWFFd6cpy3+PPHFVOv3dx
         FsjX2bHo/SQdj19oC/9/zpizNDQQ3qvvE6UEX1pM3R/U4uggam7Hsqg29+LOXqSIVk37
         UFWRRUhFgXqHcEs7Ta5Ks+5eFGU24dxULK44XHHL7QJ6FeJQd5m5W1ZjpQvK5WDBJR6T
         8l6gqrV6ooXsd0csujoaTLAEu/2qdHTvkOSeLhuuk3bunX4a0WWcwBPLam215lhBUTFD
         gkrA==
X-Gm-Message-State: AOAM531Vtp+6+vqJ0Rl8eV9yM3FVmfoamv6q7WosbBSqn37TW/Bsuvi0
        xF1PQlRydc9xNjCNOH/rGA6/Q5CRD6AtuiRwnquN8n5ACNrZE3dG1wg+KAaQ4zQgzYSROGP25kW
        PvtLHPzBn62fNhrA002DCFsq7btQp1tEIX57cL9erA89CFj0+Vu7LTiQdK5s5N9iMa2c=
X-Google-Smtp-Source: ABdhPJxNzAwlIyzHHtZl9Hf52+aPkQ2r+PvbSpxgEWdIFifml41/cnnT27Mx6AGp03mKhq17KCndwZ2Y69DLhQ==
Sender: "doughorn via sendgmr" <doughorn@doughorn0.sfo.corp.google.com>
X-Received: from doughorn0.sfo.corp.google.com ([2620:15c:8:15:e402:c6e4:56a:6a78])
 (user=doughorn job=sendgmr) by 2002:a0c:f9cc:: with SMTP id
 j12mr5831100qvo.15.1614724931678; Tue, 02 Mar 2021 14:42:11 -0800 (PST)
Date:   Tue,  2 Mar 2021 14:42:04 -0800
Message-Id: <20210302224204.1705144-1-doughorn@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 1/1] drm/virtio: use kvmalloc for large allocations
From:   Doug Horn <doughorn@google.com>
Cc:     stable@vger.kernel.org, senozhatsky@chromium.org,
        adelva@google.com, tomcherry@google.com,
        Gerd Hoffmann <kraxel@redhat.com>,
        Doug Horn <doughorn@google.com>
Content-Type: text/plain; charset="UTF-8"
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
Cc: stable@vger.kernel.org [5.10+]
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Doug Horn <doughorn@google.com>
---
 drivers/gpu/drm/virtio/virtgpu_object.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_object.c b/drivers/gpu/drm/virtio/virtgpu_object.c
index 00d6b95e259d..0c98978e2e55 100644
--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -172,8 +172,9 @@ static int virtio_gpu_object_shmem_init(struct virtio_gpu_device *vgdev,
 		*nents = shmem->pages->orig_nents;
 	}
 
-	*ents = kmalloc_array(*nents, sizeof(struct virtio_gpu_mem_entry),
-			      GFP_KERNEL);
+	*ents = kvmalloc_array(*nents,
+			       sizeof(struct virtio_gpu_mem_entry),
+			       GFP_KERNEL);
 	if (!(*ents)) {
 		DRM_ERROR("failed to allocate ent list\n");
 		return -ENOMEM;
-- 
2.30.1.766.gb4fecdf3b7-goog

