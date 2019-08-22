Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D362B99D7E
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404052AbfHVRm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:42:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404001AbfHVRXn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:43 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BDA42343C;
        Thu, 22 Aug 2019 17:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494623;
        bh=CZjCyvLmTAorm2RAOhXTckTqQlzizeKKtyw2uFgKLXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w9BeTkOni9kJyv0+fjW9YhalT5t98ytj1moM5vJOXnaJyHL4c5UkmufmbYDeFx/66
         oRoTAT4tPEvNGkaVtStGypmPWPWhbrbtJ5YcY5Rm0Mc0ugX89gm4RAnsEhA9Gkl5mx
         CJ7FgFKO9ERf557+retqkG3dfZgzDOjzG1XFWVZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.9 053/103] vhost: scsi: add weight support
Date:   Thu, 22 Aug 2019 10:18:41 -0700
Message-Id: <20190822171730.946298630@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
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
[bwh: Backported to 4.9:
 - Drop changes in vhost_scsi_ctl_handle_vq()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/scsi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -851,7 +851,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *
 	u64 tag;
 	u32 exp_data_len, data_direction;
 	unsigned out, in;
-	int head, ret, prot_bytes;
+	int head, ret, prot_bytes, c = 0;
 	size_t req_size, rsp_size = sizeof(struct virtio_scsi_cmd_resp);
 	size_t out_size, in_size;
 	u16 lun;
@@ -870,7 +870,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *
 
 	vhost_disable_notify(&vs->dev, vq);
 
-	for (;;) {
+	do {
 		head = vhost_get_vq_desc(vq, vq->iov,
 					 ARRAY_SIZE(vq->iov), &out, &in,
 					 NULL, NULL);
@@ -1086,7 +1086,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *
 		 */
 		INIT_WORK(&cmd->work, vhost_scsi_submission_work);
 		queue_work(vhost_scsi_workqueue, &cmd->work);
-	}
+	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:
 	mutex_unlock(&vq->mutex);
 }


