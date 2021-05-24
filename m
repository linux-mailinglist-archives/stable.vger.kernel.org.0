Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63CA38EF76
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235416AbhEXP5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233148AbhEXP4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:56:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21C8A613B6;
        Mon, 24 May 2021 15:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870983;
        bh=UaJTUP9vSwhaor5B3Ksj/UGX8v9gBy3zGKcvbV9+OGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CAMRRYbdL1AJOkwCYd9CLNpoIEyip5qzNAvcWg8CY/GYp4s1YcaEJE9GPANNqymmA
         PJkd5u50umiZcnQ8d+DzwaW7JdLwMbONTa7V21InKuRInxguHF4TaUH30PpHeiVXK4
         67H5b2qZRUO/5NI6NjY6/HQUrV4oIckkTi8beLs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <jsmart2021@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 020/127] nvme-fc: clear q_live at beginning of association teardown
Date:   Mon, 24 May 2021 17:25:37 +0200
Message-Id: <20210524152335.540349481@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit a7d139145a6640172516b193abf6d2398620aa14 ]

The __nvmf_check_ready() routine used to bounce all filesystem io if the
controller state isn't LIVE.  However, a later patch changed the logic so
that it rejection ends up being based on the Q live check.  The FC
transport has a slightly different sequence from rdma and tcp for
shutting down queues/marking them non-live.  FC marks its queue non-live
after aborting all ios and waiting for their termination, leaving a
rather large window for filesystem io to continue to hit the transport.
Unfortunately this resulted in filesystem I/O or applications seeing I/O
errors.

Change the FC transport to mark the queues non-live at the first sign of
teardown for the association (when I/O is initially terminated).

Fixes: 73a5379937ec ("nvme-fabrics: allow to queue requests for live queues")
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 6ffa8de2a0d7..5eee603bc249 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2460,6 +2460,18 @@ nvme_fc_terminate_exchange(struct request *req, void *data, bool reserved)
 static void
 __nvme_fc_abort_outstanding_ios(struct nvme_fc_ctrl *ctrl, bool start_queues)
 {
+	int q;
+
+	/*
+	 * if aborting io, the queues are no longer good, mark them
+	 * all as not live.
+	 */
+	if (ctrl->ctrl.queue_count > 1) {
+		for (q = 1; q < ctrl->ctrl.queue_count; q++)
+			clear_bit(NVME_FC_Q_LIVE, &ctrl->queues[q].flags);
+	}
+	clear_bit(NVME_FC_Q_LIVE, &ctrl->queues[0].flags);
+
 	/*
 	 * If io queues are present, stop them and terminate all outstanding
 	 * ios on them. As FC allocates FC exchange for each io, the
-- 
2.30.2



