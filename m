Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A66B2064C0
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388331AbgFWV0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388684AbgFWURc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:17:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 097AC21473;
        Tue, 23 Jun 2020 20:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943452;
        bh=UpmWjVDb2Zz7jPjmPm5Uk7yI4I8pS8mSFJu6GDPjzdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x77WVf49QN+QxOl2N4eyrdfE8/wRmjwI+yAW1WWg4kp1v+Oyz7cs2szl4/16IQ/9N
         3EbcvDWXPcuw035JivICxJejRfkkY0oV2Gofo7YWdpAwrzWxpANjcy3xaUhSbARvdC
         2Fzea4plhKSK7P4gwgjDeXakzuKzetGhqf0LTMrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <hmadhani2024@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        James Smart <james.smart@broadcom.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 370/477] nvme-fc: dont call nvme_cleanup_cmd() for AENs
Date:   Tue, 23 Jun 2020 21:56:07 +0200
Message-Id: <20200623195425.020114039@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit c9c12e51b82b2bd0c59ac4e27ee5427f382a503f ]

Asynchronous event notifications do not have an associated request.
When fcp_io() fails we unconditionally call nvme_cleanup_cmd() which
leads to a crash.

Fixes: 16686f3a6c3c ("nvme: move common call to nvme_cleanup_cmd to core layer")
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 5ef4a84c442a1..564e3f220ac79 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2300,10 +2300,11 @@ nvme_fc_start_fcp_op(struct nvme_fc_ctrl *ctrl, struct nvme_fc_queue *queue,
 		opstate = atomic_xchg(&op->state, FCPOP_STATE_COMPLETE);
 		__nvme_fc_fcpop_chk_teardowns(ctrl, op, opstate);
 
-		if (!(op->flags & FCOP_FLAGS_AEN))
+		if (!(op->flags & FCOP_FLAGS_AEN)) {
 			nvme_fc_unmap_data(ctrl, op->rq, op);
+			nvme_cleanup_cmd(op->rq);
+		}
 
-		nvme_cleanup_cmd(op->rq);
 		nvme_fc_ctrl_put(ctrl);
 
 		if (ctrl->rport->remoteport.port_state == FC_OBJSTATE_ONLINE &&
-- 
2.25.1



