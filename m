Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7FE9F69F
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 01:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbfH0XKx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 27 Aug 2019 19:10:53 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:58988 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfH0XKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 19:10:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone.i.decadent.org.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1i2kby-0000jM-K5; Wed, 28 Aug 2019 00:10:50 +0100
Date:   Wed, 28 Aug 2019 00:10:49 +0100
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>
Subject: [PATCH 4.4 08/13] vhost: scsi: add weight support
Message-ID: <20190827231048.GH11046@xylophone.i.decadent.org.uk>
References: <20190827230906.GA11046@xylophone.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190827230906.GA11046@xylophone.i.decadent.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
[bwh: Backported to 4.4:
 - Drop changes in vhost_scsi_ctl_handle_vq()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
---
 drivers/vhost/scsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 47e659eacf17..269cfdd2958d 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -861,7 +861,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	u64 tag;
 	u32 exp_data_len, data_direction;
 	unsigned out, in;
-	int head, ret, prot_bytes;
+	int head, ret, prot_bytes, c = 0;
 	size_t req_size, rsp_size = sizeof(struct virtio_scsi_cmd_resp);
 	size_t out_size, in_size;
 	u16 lun;
@@ -880,7 +880,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 
 	vhost_disable_notify(&vs->dev, vq);
 
-	for (;;) {
+	do {
 		head = vhost_get_vq_desc(vq, vq->iov,
 					 ARRAY_SIZE(vq->iov), &out, &in,
 					 NULL, NULL);
@@ -1096,7 +1096,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		 */
 		INIT_WORK(&cmd->work, vhost_scsi_submission_work);
 		queue_work(vhost_scsi_workqueue, &cmd->work);
-	}
+	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:
 	mutex_unlock(&vq->mutex);
 }
-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom


