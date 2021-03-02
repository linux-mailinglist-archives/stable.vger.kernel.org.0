Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454DE32B04B
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344655AbhCCAyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382572AbhCBWi4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 17:38:56 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932CCC061756
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 14:38:05 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id u1so24238087ybu.14
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 14:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:cc;
        bh=XfpfVFmJG+r/j7urf3WBTDmJgOmmFP/mmfpdewnbZB4=;
        b=DSZm4qVCOe8FXSsFutmrZeiUA3Lxb9paFFxEBxxNdfD1lqkgveGKBlhmlpZPsH8z7O
         Sbja/KVNTLZNeondD8eOtmqfnXAG/TBir7tH7VisDTklBri/TReMOKJFtk69VC4ZcRoY
         EVqPZWnfXmmRpCNddTgpuUUNu5WjYkaLEbdlzJGgv35nsGa9Qxat7Cvv9d5/ol49TCrO
         1v7sznlNuF6+SGtJ5dsti2W4SNoaln9D/9f1be34/WRR7nTrPf6AHnuAcGwYA17QUo7+
         y2cufNyYW4pGgwQ6LncI4o2w1H3lOXY8OwDFo+noZNemQoxmJ+IZOwi4FJsNsqYT2rwr
         i7Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :cc;
        bh=XfpfVFmJG+r/j7urf3WBTDmJgOmmFP/mmfpdewnbZB4=;
        b=EC0n8PnwCwfsWc5vNHChnLHJTCo2JN0KZEcC/UvjtlbxLGuyBXKm4qSrw88ePysuM8
         FSDGzc+P1IFMWST1uWOOxp2b0KGGY9R5sbuP4yvyPu4NPaKLp0tyfE1urJE4wgxoxvuJ
         TdG9baAYGC0FCQ4zi7Oj0qJyuJkexmKYDcgxzJ+DQWEAGaoFE//2NgFdMYd+hVANDOGj
         TzGU7dI5GLgIw8zDoo1Gsd5cxT1ORWxAnagUTcg1mhCBb1WsNS9tzuEqoqydCJ/orGhW
         Eb4g+1xBJBknQspF11jWiu3/Pm/h8g7S8oq74fVZxdfDIeew/he62WfD64CoQu8szlJK
         4ymw==
X-Gm-Message-State: AOAM530K7qOGU1Eu3tJSPFQckVSJaVv6xo8EdK8wx8j0I77nqkzygWA0
        YSV9s3wNRTpRbATR8YZ3TEzU0tI1PUZ5drDtKMfCemo9hm1NsLVjXB4+wnnCsUnajcxozbzx4A4
        S050SQe/iYTbwGBEU4pClJvunLagbNc5L12fueXb/s3TaEPXjCWJ6wkJXfkZR6Wn92jU=
X-Google-Smtp-Source: ABdhPJyZw1V8u7rgCsqWyzFEm/uhl0kTzfD1OJ+4431qzIp2W125+ZoirHckvySRTL66d59NXThyszZSHnjrdQ==
Sender: "doughorn via sendgmr" <doughorn@doughorn0.sfo.corp.google.com>
X-Received: from doughorn0.sfo.corp.google.com ([2620:15c:8:15:e402:c6e4:56a:6a78])
 (user=doughorn job=sendgmr) by 2002:a25:2d6a:: with SMTP id
 s42mr35261322ybe.376.1614724684731; Tue, 02 Mar 2021 14:38:04 -0800 (PST)
Date:   Tue,  2 Mar 2021 14:38:00 -0800
Message-Id: <20210302223800.1703918-1-doughorn@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 1/1] drm/virtio: use kvmalloc for large allocations
From:   Doug Horn <doughorn@google.com>
Cc:     stable@vger.kernel.org, senozhatsky@chromium.org,
        adelva@google.com, kaiyili@google.com,
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

the original patch applied to a different file, this backport moved this
change to the proper place for 4.14/4.19/5.4.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Link: http://patchwork.freedesktop.org/patch/msgid/20201105014744.1662226-1-senozhatsky@chromium.org
Cc: stable@vger.kernel.org [4.14, 4.19, 5.4]
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Doug Horn <doughorn@google.com>
---
 drivers/gpu/drm/virtio/virtgpu_vq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index a956c73ea85e..374279ba1444 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -865,9 +865,9 @@ int virtio_gpu_object_attach(struct virtio_gpu_device *vgdev,
 	}
 
 	/* gets freed when the ring has consumed it */
-	ents = kmalloc_array(obj->pages->nents,
-			     sizeof(struct virtio_gpu_mem_entry),
-			     GFP_KERNEL);
+	ents = kvmalloc_array(obj->pages->nents,
+			      sizeof(struct virtio_gpu_mem_entry),
+			      GFP_KERNEL);
 	if (!ents) {
 		DRM_ERROR("failed to allocate ent list\n");
 		return -ENOMEM;
-- 
2.30.1.766.gb4fecdf3b7-goog

