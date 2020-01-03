Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C90C12FCAC
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 19:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgACSlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 13:41:00 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34888 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728279AbgACSk7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 13:40:59 -0500
Received: by mail-pg1-f194.google.com with SMTP id l24so23795343pgk.2
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 10:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3yKojHRAj36mCSvlGfKC/lxiFlQ2VNMN7NXDBZFEcT0=;
        b=Z8pdKwxYhL1cfFkp/upyWXYolcbCknhGm5k9RGLodaksgPBJ7Vcaln7swMkMIqELN2
         orOxT2gVdRZmy70mlrXiez7WWXjpQyjg2pIEh6DeXiTIQxdD9YJwsNbR1QitCGlAOTGV
         z5bOmITbvPOzUoE2aX6hV0/+8QxkC6k+EcVGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3yKojHRAj36mCSvlGfKC/lxiFlQ2VNMN7NXDBZFEcT0=;
        b=h4Nv9HJiJh+OHoP+Ak3NjA3qroHvIYO662Hk7bBS2H4SxA4KxdOTMCCTHxJd5+6DxU
         CPOeKG36703wHFJJcjGSjLWb0aHErqusxQF6WhwviJzqRJASU+J1OZh9MXq92Rkj06yO
         G6lFRGfHlkWLa6fGkqL2Bilcln8anwe2BTEk0p+ifA17XZQp+AXructr2o6FpL45O/f9
         1p9mcGx+8MQ1veRMlC966HAAu7mC0htkkyLLoYuP78JRTm1SLSMNimWzFNUn6qKWBiaB
         NZBjBYntSYX4DRBIi0zwZQ0ngrH+38iY5hNVfWVAon4hm3N9jpd4NSuvBtV9o7Ptudga
         eaLw==
X-Gm-Message-State: APjAAAWWFaleletMiaeAxBVTBSB3AYmwxb3ONEfQH9UDcq/pjs7Ng1IM
        1MsB2Lg2cdBQO7axQ7Njyi2RNQ==
X-Google-Smtp-Source: APXvYqxVrwljxI2HL4rX6u24eEYQxy1UkCjmds5LXYbgMUrQNwd631RCc++jZ5SN+KXZIn30/Ya4Ww==
X-Received: by 2002:aa7:8b5a:: with SMTP id i26mr43991113pfd.214.1578076859098;
        Fri, 03 Jan 2020 10:40:59 -0800 (PST)
Received: from localhost ([2620:15c:202:201:bfdf:e7dd:b034:6ac7])
        by smtp.gmail.com with ESMTPSA id w38sm66207847pgk.45.2020.01.03.10.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jan 2020 10:40:58 -0800 (PST)
From:   Daniel Verkamp <dverkamp@chromium.org>
To:     virtualization@lists.linux-foundation.org
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Daniel Verkamp <dverkamp@chromium.org>, stable@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 1/2] virtio-balloon: initialize all vq callbacks
Date:   Fri,  3 Jan 2020 10:40:43 -0800
Message-Id: <20200103184044.73568-1-dverkamp@chromium.org>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ensure that elements of the callbacks array that correspond to
unavailable features are set to NULL; previously, they would be left
uninitialized.

Since the corresponding names array elements were explicitly set to
NULL, the uninitialized callback pointers would not actually be
dereferenced; however, the uninitialized callbacks elements would still
be read in vp_find_vqs_msix() and used to calculate the number of MSI-X
vectors required.

Cc: stable@vger.kernel.org
Fixes: 86a559787e6f ("virtio-balloon: VIRTIO_BALLOON_F_FREE_PAGE_HINT")
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Daniel Verkamp <dverkamp@chromium.org>
---

v1:
https://lists.linuxfoundation.org/pipermail/virtualization/2019-December/044829.html

Changes from v1:
- Clarified "array" in commit message to "callbacks array"

 drivers/virtio/virtio_balloon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 93f995f6cf36..8e400ece9273 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -475,7 +475,9 @@ static int init_vqs(struct virtio_balloon *vb)
 	names[VIRTIO_BALLOON_VQ_INFLATE] = "inflate";
 	callbacks[VIRTIO_BALLOON_VQ_DEFLATE] = balloon_ack;
 	names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
+	callbacks[VIRTIO_BALLOON_VQ_STATS] = NULL;
 	names[VIRTIO_BALLOON_VQ_STATS] = NULL;
+	callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
 	names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
 
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
-- 
2.24.1.735.g03f4e72817-goog

