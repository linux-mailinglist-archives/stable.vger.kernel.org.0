Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D42242692B
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241340AbhJHLeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:34:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240857AbhJHLdD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:33:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CAC16101A;
        Fri,  8 Oct 2021 11:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692660;
        bh=QzJLtmy/dBqYkwtm+nx3JK5csRcCgkF9+xbvX4U8p8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xdbFExX5jJM1UwiOl8IKo38oiydVyA390q/yNA0Vv4AfGBO6STv0Hplsu9qeGo+0n
         JiZskc0nni+x2WIzlCFBfp1sO+yJpxROR0eK4y1Ad42JcYha0WPfpbz3FuzAL3VX0R
         vXKTE6Z5KO6HhNxQX9IPMBJ2xrw+2Ar34vv7NZXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        James Smart <jsmart2021@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/29] nvme-fc: update hardware queues before using them
Date:   Fri,  8 Oct 2021 13:28:04 +0200
Message-Id: <20211008112717.531254194@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112716.914501436@linuxfoundation.org>
References: <20211008112716.914501436@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 555f66d0f8a38537456acc77043d0e4469fcbe8e ]

In case the number of hardware queues changes, we need to update the
tagset and the mapping of ctx to hctx first.

If we try to create and connect the I/O queues first, this operation
will fail (target will reject the connect call due to the wrong number
of queues) and hence we bail out of the recreate function. Then we
will to try the very same operation again, thus we don't make any
progress.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index a0bcec33b020..86c6862e71a1 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2952,14 +2952,6 @@ nvme_fc_recreate_io_queues(struct nvme_fc_ctrl *ctrl)
 	if (ctrl->ctrl.queue_count == 1)
 		return 0;
 
-	ret = nvme_fc_create_hw_io_queues(ctrl, ctrl->ctrl.sqsize + 1);
-	if (ret)
-		goto out_free_io_queues;
-
-	ret = nvme_fc_connect_io_queues(ctrl, ctrl->ctrl.sqsize + 1);
-	if (ret)
-		goto out_delete_hw_queues;
-
 	if (prior_ioq_cnt != nr_io_queues) {
 		dev_info(ctrl->ctrl.device,
 			"reconnect: revising io queue count from %d to %d\n",
@@ -2969,6 +2961,14 @@ nvme_fc_recreate_io_queues(struct nvme_fc_ctrl *ctrl)
 		nvme_unfreeze(&ctrl->ctrl);
 	}
 
+	ret = nvme_fc_create_hw_io_queues(ctrl, ctrl->ctrl.sqsize + 1);
+	if (ret)
+		goto out_free_io_queues;
+
+	ret = nvme_fc_connect_io_queues(ctrl, ctrl->ctrl.sqsize + 1);
+	if (ret)
+		goto out_delete_hw_queues;
+
 	return 0;
 
 out_delete_hw_queues:
-- 
2.33.0



