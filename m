Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7420F68D782
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbjBGNAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbjBGNA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:00:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CC939B92
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:00:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BE5F613DC
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21520C433D2;
        Tue,  7 Feb 2023 13:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774806;
        bh=kP70VMP6SHJKvNGbQVmUF0PVRk9mFCSaVtDjnkFrnpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=055dYb78jK636OfGAw0zNuQvP7g9Pmwq27QEG7V0lPBC73rFLdFegc4tbrB7N6fek
         PUs1d8Ky9/8aUQ2aXyAGKST1NEdZz3zrwtPkmbe6FsvzUC3FbJCxYXzD1TjKdGQ3s8
         p8heEkZlqlXYzMgymaN7qcGUE8E+QrUmU6F4W1tA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin Coddington <bcodding@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/208] vhost-scsi: unbreak any layout for response
Date:   Tue,  7 Feb 2023 13:54:53 +0100
Message-Id: <20230207125636.074338005@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 6dd88fd59da84631b5fe5c8176931c38cfa3b265 ]

Al Viro said:

"""
Since "vhost/scsi: fix reuse of &vq->iov[out] in response"
we have this:
                cmd->tvc_resp_iov = vq->iov[vc.out];
                cmd->tvc_in_iovs = vc.in;
combined with
                iov_iter_init(&iov_iter, ITER_DEST, &cmd->tvc_resp_iov,
                              cmd->tvc_in_iovs, sizeof(v_rsp));
in vhost_scsi_complete_cmd_work().  We used to have ->tvc_resp_iov
_pointing_ to vq->iov[vc.out]; back then iov_iter_init() asked to
set an iovec-backed iov_iter over the tail of vq->iov[], with
length being the amount of iovecs in the tail.

Now we have a copy of one element of that array.  Fortunately, the members
following it in the containing structure are two non-NULL kernel pointers,
so copy_to_iter() will not copy anything beyond the first iovec - kernel
pointer is not (on the majority of architectures) going to be accepted by
access_ok() in copyout() and it won't be skipped since the "length" (in
reality - another non-NULL kernel pointer) won't be zero.

So it's not going to give a guest-to-qemu escalation, but it's definitely
a bug.  Frankly, my preference would be to verify that the very first iovec
is long enough to hold rsp_size.  Due to the above, any users that try to
give us vq->iov[vc.out].iov_len < sizeof(struct virtio_scsi_cmd_resp)
would currently get a failure in vhost_scsi_complete_cmd_work()
anyway.
"""

However, the spec doesn't say anything about the legacy descriptor
layout for the respone. So this patch tries to not assume the response
to reside in a single separate descriptor which is what commit
79c14141a487 ("vhost/scsi: Convert completion path to use") tries to
achieve towards to ANY_LAYOUT.

This is done by allocating and using dedicate resp iov in the
command. To be safety, start with UIO_MAXIOV to be consistent with the
limitation that we advertise to the vhost_get_vq_desc().

Testing with the hacked virtio-scsi driver that use 1 descriptor for 1
byte in the response.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin Coddington <bcodding@redhat.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Fixes: a77ec83a5789 ("vhost/scsi: fix reuse of &vq->iov[out] in response")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20230119073647.76467-1-jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index dca6346d75b3..d5ecb8876fc9 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -80,7 +80,7 @@ struct vhost_scsi_cmd {
 	struct scatterlist *tvc_prot_sgl;
 	struct page **tvc_upages;
 	/* Pointer to response header iovec */
-	struct iovec tvc_resp_iov;
+	struct iovec *tvc_resp_iov;
 	/* Pointer to vhost_scsi for our device */
 	struct vhost_scsi *tvc_vhost;
 	/* Pointer to vhost_virtqueue for the cmd */
@@ -563,7 +563,7 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 		memcpy(v_rsp.sense, cmd->tvc_sense_buf,
 		       se_cmd->scsi_sense_length);
 
-		iov_iter_init(&iov_iter, ITER_DEST, &cmd->tvc_resp_iov,
+		iov_iter_init(&iov_iter, ITER_DEST, cmd->tvc_resp_iov,
 			      cmd->tvc_in_iovs, sizeof(v_rsp));
 		ret = copy_to_iter(&v_rsp, sizeof(v_rsp), &iov_iter);
 		if (likely(ret == sizeof(v_rsp))) {
@@ -594,6 +594,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	struct vhost_scsi_cmd *cmd;
 	struct vhost_scsi_nexus *tv_nexus;
 	struct scatterlist *sg, *prot_sg;
+	struct iovec *tvc_resp_iov;
 	struct page **pages;
 	int tag;
 
@@ -613,6 +614,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	sg = cmd->tvc_sgl;
 	prot_sg = cmd->tvc_prot_sgl;
 	pages = cmd->tvc_upages;
+	tvc_resp_iov = cmd->tvc_resp_iov;
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->tvc_sgl = sg;
 	cmd->tvc_prot_sgl = prot_sg;
@@ -625,6 +627,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	cmd->tvc_data_direction = data_direction;
 	cmd->tvc_nexus = tv_nexus;
 	cmd->inflight = vhost_scsi_get_inflight(vq);
+	cmd->tvc_resp_iov = tvc_resp_iov;
 
 	memcpy(cmd->tvc_cdb, cdb, VHOST_SCSI_MAX_CDB_SIZE);
 
@@ -935,7 +938,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	struct iov_iter in_iter, prot_iter, data_iter;
 	u64 tag;
 	u32 exp_data_len, data_direction;
-	int ret, prot_bytes, c = 0;
+	int ret, prot_bytes, i, c = 0;
 	u16 lun;
 	u8 task_attr;
 	bool t10_pi = vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI);
@@ -1092,7 +1095,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		}
 		cmd->tvc_vhost = vs;
 		cmd->tvc_vq = vq;
-		cmd->tvc_resp_iov = vq->iov[vc.out];
+		for (i = 0; i < vc.in ; i++)
+			cmd->tvc_resp_iov[i] = vq->iov[vc.out + i];
 		cmd->tvc_in_iovs = vc.in;
 
 		pr_debug("vhost_scsi got command opcode: %#02x, lun: %d\n",
@@ -1461,6 +1465,7 @@ static void vhost_scsi_destroy_vq_cmds(struct vhost_virtqueue *vq)
 		kfree(tv_cmd->tvc_sgl);
 		kfree(tv_cmd->tvc_prot_sgl);
 		kfree(tv_cmd->tvc_upages);
+		kfree(tv_cmd->tvc_resp_iov);
 	}
 
 	sbitmap_free(&svq->scsi_tags);
@@ -1508,6 +1513,14 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 			goto out;
 		}
 
+		tv_cmd->tvc_resp_iov = kcalloc(UIO_MAXIOV,
+					       sizeof(struct iovec),
+					       GFP_KERNEL);
+		if (!tv_cmd->tvc_resp_iov) {
+			pr_err("Unable to allocate tv_cmd->tvc_resp_iov\n");
+			goto out;
+		}
+
 		tv_cmd->tvc_prot_sgl = kcalloc(VHOST_SCSI_PREALLOC_PROT_SGLS,
 					       sizeof(struct scatterlist),
 					       GFP_KERNEL);
-- 
2.39.0



