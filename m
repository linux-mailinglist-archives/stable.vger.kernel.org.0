Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3122332E9D3
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbhCEMfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:35:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232435AbhCEMe5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:34:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E88D46501A;
        Fri,  5 Mar 2021 12:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947697;
        bh=mMbMGvK82PX3oQrM7vu6NF1qOcbTscHtxXFdvBBeSeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTCu6wZArQAMOtQydOH+pVJXdZCeBXvgbn6YYXwNmuXLOUBNGZwhbONWAESyCIDly
         RXtNrM+PC+falFjmkhQUR25kczUroZllo/wNMy6/mkH4Y0pmfqpNJRy2+Z1gaelv6J
         an80gKlxEEyVL9IXBQ3A4dwar6aTn7cCN6sngC98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Leng <lengchao@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 51/72] nvme-tcp: add clean action for failed reconnection
Date:   Fri,  5 Mar 2021 13:21:53 +0100
Message-Id: <20210305120859.833090797@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Leng <lengchao@huawei.com>

[ Upstream commit 70a99574a79f1cd4dc7ad56ea37be40844bfb97b ]

If reconnect failed after start io queues, the queues will be unquiesced
and new requests continue to be delivered. Reconnection error handling
process directly free queues without cancel suspend requests. The
suppend request will time out, and then crash due to use the queue
after free.

Add sync queues and cancel suppend requests for reconnection error
handling.

Signed-off-by: Chao Leng <lengchao@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index a554021e1ab9..77a3c488ec12 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1710,8 +1710,10 @@ static int nvme_tcp_configure_io_queues(struct nvme_ctrl *ctrl, bool new)
 
 out_wait_freeze_timed_out:
 	nvme_stop_queues(ctrl);
+	nvme_sync_io_queues(ctrl);
 	nvme_tcp_stop_io_queues(ctrl);
 out_cleanup_connect_q:
+	nvme_cancel_tagset(ctrl);
 	if (new)
 		blk_cleanup_queue(ctrl->connect_q);
 out_free_tag_set:
@@ -1773,12 +1775,16 @@ static int nvme_tcp_configure_admin_queue(struct nvme_ctrl *ctrl, bool new)
 
 	error = nvme_init_identify(ctrl);
 	if (error)
-		goto out_stop_queue;
+		goto out_quiesce_queue;
 
 	return 0;
 
+out_quiesce_queue:
+	blk_mq_quiesce_queue(ctrl->admin_q);
+	blk_sync_queue(ctrl->admin_q);
 out_stop_queue:
 	nvme_tcp_stop_queue(ctrl, 0);
+	nvme_cancel_admin_tagset(ctrl);
 out_cleanup_queue:
 	if (new)
 		blk_cleanup_queue(ctrl->admin_q);
@@ -1892,10 +1898,18 @@ static int nvme_tcp_setup_ctrl(struct nvme_ctrl *ctrl, bool new)
 	return 0;
 
 destroy_io:
-	if (ctrl->queue_count > 1)
+	if (ctrl->queue_count > 1) {
+		nvme_stop_queues(ctrl);
+		nvme_sync_io_queues(ctrl);
+		nvme_tcp_stop_io_queues(ctrl);
+		nvme_cancel_tagset(ctrl);
 		nvme_tcp_destroy_io_queues(ctrl, new);
+	}
 destroy_admin:
+	blk_mq_quiesce_queue(ctrl->admin_q);
+	blk_sync_queue(ctrl->admin_q);
 	nvme_tcp_stop_queue(ctrl, 0);
+	nvme_cancel_admin_tagset(ctrl);
 	nvme_tcp_destroy_admin_queue(ctrl, new);
 	return ret;
 }
-- 
2.30.1



