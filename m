Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7DF1FE5D0
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733299AbgFRC2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:28:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729564AbgFRBQQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:16:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8322721D7E;
        Thu, 18 Jun 2020 01:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442975;
        bh=qgq4d/Tb4LxpgEzazG5SGHErDPeALQop0gAuqh4jUw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKeEmc4Qx0EUOed81J6Oj6RSQZgGnntUw326yAT/OKZJN18UVgdJ+g6obV/wKWnyp
         xgsCvszjTsFY+bT9OoyJpiGF45viFPvc9IHefDfs2OtMZcqkC07Uz9r/fm00ca4+AM
         xRwNUDkVoTpdH7vP9yIitCleZLitPXDzBDp3+r18=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <hmadhani2024@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        James Smart <james.smart@broadcom.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 378/388] nvme-fc: don't call nvme_cleanup_cmd() for AENs
Date:   Wed, 17 Jun 2020 21:07:55 -0400
Message-Id: <20200618010805.600873-378-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 7dfc4a2ecf1e..287a3e8ea317 100644
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

