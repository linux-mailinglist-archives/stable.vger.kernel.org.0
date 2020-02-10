Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89029157880
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729422AbgBJMja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:39:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729419AbgBJMj3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:29 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88BF52173E;
        Mon, 10 Feb 2020 12:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338369;
        bh=RHD10ebCza4NHAk6pj5Oqo7EKzszWSVb/Y/18F7+Lm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZ3pFS/femFVwRMkl+eiY+U2inxfNd+D+C3HDtx+BCFrbVaj+lM0fVg244wMlrxOT
         oWjuVBg+xnKI0vmxfUFvNrWG2odUVIAo8bUFs/30rhqryszSxinGjphCx0onoiNxCf
         xWZIW3muktw6CBvBQIZwk6rySQXbHIqAZ179btos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.5 039/367] nvmet: Fix controller use after free
Date:   Mon, 10 Feb 2020 04:29:12 -0800
Message-Id: <20200210122427.593836695@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Israel Rukshin <israelr@mellanox.com>

commit 1a3f540d63152b8db0a12de508bfa03776217d83 upstream.

After nvmet_install_queue() sets sq->ctrl calling to nvmet_sq_destroy()
reduces the controller refcount. In case nvmet_install_queue() fails,
calling to nvmet_ctrl_put() is done twice (at nvmet_sq_destroy and
nvmet_execute_io_connect/nvmet_execute_admin_connect) instead of once for
the queue which leads to use after free of the controller. Fix this by set
NULL at sq->ctrl in case of a failure at nvmet_install_queue().

The bug leads to the following Call Trace:

[65857.994862] refcount_t: underflow; use-after-free.
[65858.108304] Workqueue: events nvmet_rdma_release_queue_work [nvmet_rdma]
[65858.115557] RIP: 0010:refcount_warn_saturate+0xe5/0xf0
[65858.208141] Call Trace:
[65858.211203]  nvmet_sq_destroy+0xe1/0xf0 [nvmet]
[65858.216383]  nvmet_rdma_release_queue_work+0x37/0xf0 [nvmet_rdma]
[65858.223117]  process_one_work+0x167/0x370
[65858.227776]  worker_thread+0x49/0x3e0
[65858.232089]  kthread+0xf5/0x130
[65858.235895]  ? max_active_store+0x80/0x80
[65858.240504]  ? kthread_bind+0x10/0x10
[65858.244832]  ret_from_fork+0x1f/0x30
[65858.249074] ---[ end trace f82d59250b54beb7 ]---

Fixes: bb1cc74790eb ("nvmet: implement valid sqhd values in completions")
Fixes: 1672ddb8d691 ("nvmet: Add install_queue callout")
Signed-off-by: Israel Rukshin <israelr@mellanox.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/target/fabrics-cmd.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -109,6 +109,7 @@ static u16 nvmet_install_queue(struct nv
 	u16 qid = le16_to_cpu(c->qid);
 	u16 sqsize = le16_to_cpu(c->sqsize);
 	struct nvmet_ctrl *old;
+	u16 ret;
 
 	old = cmpxchg(&req->sq->ctrl, NULL, ctrl);
 	if (old) {
@@ -119,7 +120,8 @@ static u16 nvmet_install_queue(struct nv
 	if (!sqsize) {
 		pr_warn("queue size zero!\n");
 		req->error_loc = offsetof(struct nvmf_connect_command, sqsize);
-		return NVME_SC_CONNECT_INVALID_PARAM | NVME_SC_DNR;
+		ret = NVME_SC_CONNECT_INVALID_PARAM | NVME_SC_DNR;
+		goto err;
 	}
 
 	/* note: convert queue size from 0's-based value to 1's-based value */
@@ -132,16 +134,19 @@ static u16 nvmet_install_queue(struct nv
 	}
 
 	if (ctrl->ops->install_queue) {
-		u16 ret = ctrl->ops->install_queue(req->sq);
-
+		ret = ctrl->ops->install_queue(req->sq);
 		if (ret) {
 			pr_err("failed to install queue %d cntlid %d ret %x\n",
 				qid, ctrl->cntlid, ret);
-			return ret;
+			goto err;
 		}
 	}
 
 	return 0;
+
+err:
+	req->sq->ctrl = NULL;
+	return ret;
 }
 
 static void nvmet_execute_admin_connect(struct nvmet_req *req)


