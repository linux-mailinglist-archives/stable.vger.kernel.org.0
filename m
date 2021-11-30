Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F163B46380C
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243033AbhK3O5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:57:52 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:59524 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242489AbhK3Ozu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:55:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EA53FCE1A6F;
        Tue, 30 Nov 2021 14:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32210C8D184;
        Tue, 30 Nov 2021 14:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283948;
        bh=ICUdGkqYwSHrugGh9rrnC4N6Hn5WnSLJOgTy/dDQIMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJJj2/yU4wDHY29ypvRrp1JOlEaHjXBE53YdzcMif8GO2dJzVycMF1gQlr8ghu+nO
         JwzNlAbI6R24ZxUDGHKJ3BM6PP4xcCGTwHxCpT+DqCy9AOTnrpbqtVIxXATMpdDPo9
         no9sTGo9YjMA88hk6lvbiLd3OP28fL8rcwEnbt/mbKkCkX65DyxGHU5ioEf8pNeQ6x
         PsO6GJCNcOEY19CGkpLkyvP4FiwMHeMCG5MoAj82/XNfNpjNHX3RfcfgKg/6D2yBA8
         hEuvHUzOOXkQX+AWWrirwZBNAlGyFea7pN7GjNxwSTfDZ17iXVYPWr6stg7eTgIXUc
         vNvuHKsRKZlfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        John Meneghini <jmeneghi@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kch@nvidia.com,
        linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 16/25] nvmet-tcp: fix a race condition between release_queue and io_work
Date:   Tue, 30 Nov 2021 09:51:46 -0500
Message-Id: <20211130145156.946083-16-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145156.946083-1-sashal@kernel.org>
References: <20211130145156.946083-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit a208fc56721775987c1b86e20d86d7e0d017c0b2 ]

If the initiator executes a reset controller operation while
performing I/O, the target kernel will crash because of a race condition
between release_queue and io_work;
nvmet_tcp_uninit_data_in_cmds() may be executed while io_work
is running, calling flush_work() was not sufficient to
prevent this because io_work could requeue itself.

Fix this bug by using cancel_work_sync() to prevent io_work
from requeuing itself and set rcv_state to NVMET_TCP_RECV_ERR to
make sure we don't receive any more data from the socket.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index fac1985870765..b3e82b0889f0b 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1352,7 +1352,9 @@ static void nvmet_tcp_release_queue_work(struct work_struct *w)
 	mutex_unlock(&nvmet_tcp_queue_mutex);
 
 	nvmet_tcp_restore_socket_callbacks(queue);
-	flush_work(&queue->io_work);
+	cancel_work_sync(&queue->io_work);
+	/* stop accepting incoming data */
+	queue->rcv_state = NVMET_TCP_RECV_ERR;
 
 	nvmet_tcp_uninit_data_in_cmds(queue);
 	nvmet_sq_destroy(&queue->nvme_sq);
-- 
2.33.0

