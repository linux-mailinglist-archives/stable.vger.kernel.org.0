Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2E57F35C
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406757AbfHBJ4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:56:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406750AbfHBJ4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:56:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 502532067D;
        Fri,  2 Aug 2019 09:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739797;
        bh=fGDfugbvzy5P7KtjTCfMKH4yBsqFsiseJtrhtDRxyrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ih5jG3idBqFMpXZ4RPpLNLOatQk17olA/44a/Xb7Kt2yfb4SXWzAmFkESTUNrEoDe
         Be/LPwpQIflg2mnEAXd/zQqehs539sAF2T/yqLjn83Mkq+/KILps5Wtelwa6+5N+jJ
         NynaZUZEklkZk2d3i6oEbZqzwUXbUYFdVQP2qhdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 4.19 23/32] vhost: scsi: add weight support
Date:   Fri,  2 Aug 2019 11:39:57 +0200
Message-Id: <20190802092109.227507560@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092101.913646560@linuxfoundation.org>
References: <20190802092101.913646560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

commit c1ea02f15ab5efb3e93fc3144d895410bf79fcf2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vhost/scsi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -817,7 +817,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *
 	u64 tag;
 	u32 exp_data_len, data_direction;
 	unsigned int out = 0, in = 0;
-	int head, ret, prot_bytes;
+	int head, ret, prot_bytes, c = 0;
 	size_t req_size, rsp_size = sizeof(struct virtio_scsi_cmd_resp);
 	size_t out_size, in_size;
 	u16 lun;
@@ -836,7 +836,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *
 
 	vhost_disable_notify(&vs->dev, vq);
 
-	for (;;) {
+	do {
 		head = vhost_get_vq_desc(vq, vq->iov,
 					 ARRAY_SIZE(vq->iov), &out, &in,
 					 NULL, NULL);
@@ -1051,7 +1051,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *
 		 */
 		INIT_WORK(&cmd->work, vhost_scsi_submission_work);
 		queue_work(vhost_scsi_workqueue, &cmd->work);
-	}
+	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:
 	mutex_unlock(&vq->mutex);
 }


