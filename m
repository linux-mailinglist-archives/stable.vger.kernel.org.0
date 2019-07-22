Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869467007B
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 15:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfGVNDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 09:03:20 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46945 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728924AbfGVNDU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 09:03:20 -0400
Received: by mail-ed1-f67.google.com with SMTP id d4so40572974edr.13
        for <stable@vger.kernel.org>; Mon, 22 Jul 2019 06:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RGtootUUACzE3D9a2msPbnq8uijsx/Cktbd+3vpMz5c=;
        b=gTvMGy2YukWB30QnM/rBXFJ8wUyUqoax28y+aF6hGbnS99pL+mbOYPSU2palJArR5X
         l0UJpMeVY+TzeuhOmmExc120fAapXgA4tbX5sqoR0uC0kuX84t7QCyxHnQq7AQP5LPj8
         S5Blo3dVHKRO3g7llcRxpPCSMC+Ds15P/dKn1or2cQBzy4XoB8RtlWOkkktIlMaB/9xG
         1AWl6dt51bOY3uYLpnCQapooL9zJ4PIXWFnJYl2C37iibka6Fyn7/jCAoGJCeofExkOQ
         ygLw/jcqv2nI8xoP54Q1i9rCIlDpvxzvo4DoiGWo1pAy4m4XOlYj2ltI3X25sI/9mmbU
         wnPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RGtootUUACzE3D9a2msPbnq8uijsx/Cktbd+3vpMz5c=;
        b=VV1Vp0DaFK0laHnnqna0FJX5Qnmw+hS7tDoP+dgKnQyLtA/BT5MtPnVUBl74TF7LX9
         /phWiVdo1soQ6J5Hw1qzP+XoeSQNy5eVxF5kVg8F4RCDEXfsAFlc0np+d4pCbQO8tWiG
         o2WF0peZLZBnz7d+lVI1GbZHsdB0Ruq4RU0r/0AZ0k0BsVfnPTE3dQUn/d+XSRiANTGq
         PqXCC5VnPKuKYvn7MGgjn/3WXqgz1e8WVt/i2Glj9XP7Uw+RxEwkc8D27UsM6zTuYCy5
         zu94fj5umAGgpA367ZKTX/ue3AUiVfkezPeAQ506dt5PH5Rcp+iIof03jCNFr3mx8b5W
         bi4A==
X-Gm-Message-State: APjAAAUoFOsqHmBv4CZIJL8wB+tOTDrqpr0LOtPXmHMZ51j81SZCY8cS
        41gWVGV+HqCUXKFNS955vnQ=
X-Google-Smtp-Source: APXvYqzQRgKd2YbcCfmD73UO8ZsoL5tvS/MmC9VbDt9PZDIvWGp/ibb01Nz9vEXtGFLeQWp/r+1aBw==
X-Received: by 2002:a05:6402:145a:: with SMTP id d26mr60098126edx.10.1563800598460;
        Mon, 22 Jul 2019 06:03:18 -0700 (PDT)
Received: from jwang-Latitude-5491.pb.local ([62.217.45.26])
        by smtp.gmail.com with ESMTPSA id v12sm7996085ejj.52.2019.07.22.06.03.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 06:03:18 -0700 (PDT)
From:   Jack Wang <jinpuwang@gmail.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [stable-4.19 4/4] vhost: scsi: add weight support
Date:   Mon, 22 Jul 2019 15:03:13 +0200
Message-Id: <20190722130313.18562-5-jinpuwang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190722130313.18562-1-jinpuwang@gmail.com>
References: <20190722130313.18562-1-jinpuwang@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

commit c1ea02f15ab5efb3e93fc3144d895410bf79fcf2 upstream

This patch will check the weight and exit the loop if we exceeds the
weight. This is useful for preventing scsi kthread from hogging cpu
which is guest triggerable.

This addresses CVE-2019-3900.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Fixes: 057cbf49a1f0 ("tcm_vhost: Initial merge for vhost level target fabric driver")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
[jwang: backport to 4.19]
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/vhost/scsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 087ce17b0c39..5e298d9287f1 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -817,7 +817,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	u64 tag;
 	u32 exp_data_len, data_direction;
 	unsigned int out = 0, in = 0;
-	int head, ret, prot_bytes;
+	int head, ret, prot_bytes, c = 0;
 	size_t req_size, rsp_size = sizeof(struct virtio_scsi_cmd_resp);
 	size_t out_size, in_size;
 	u16 lun;
@@ -836,7 +836,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 
 	vhost_disable_notify(&vs->dev, vq);
 
-	for (;;) {
+	do {
 		head = vhost_get_vq_desc(vq, vq->iov,
 					 ARRAY_SIZE(vq->iov), &out, &in,
 					 NULL, NULL);
@@ -1051,7 +1051,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		 */
 		INIT_WORK(&cmd->work, vhost_scsi_submission_work);
 		queue_work(vhost_scsi_workqueue, &cmd->work);
-	}
+	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:
 	mutex_unlock(&vq->mutex);
 }
-- 
2.17.1

