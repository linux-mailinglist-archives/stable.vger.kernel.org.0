Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBA4177F18
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729787AbgCCRsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:48:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:55880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730348AbgCCRsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:48:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ADC720870;
        Tue,  3 Mar 2020 17:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257721;
        bh=YX1TBuFdUVCTm0Ixl1Y81X3tEt1dG0LsEV4R/yy7HiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4U2guOPx6p54Wbph/43IDFh+8pQuWMC2+vm5k9R/T6auNFB8tuKMcBIyp44H2lHX
         GEieB3EncfKsX+HaxYoJ/MrpkYNEC+6QeEnnczXvNgI3cxQdvyG1s02Z2ltieOFWV+
         fIdqw1plcbFp1VCy9oiGU7DCdVySB+PkbWhfGqoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Eidelman <anton@lightbitslabs.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 078/176] nvme/tcp: fix bug on double requeue when send fails
Date:   Tue,  3 Mar 2020 18:42:22 +0100
Message-Id: <20200303174313.656931332@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Eidelman <anton@lightbitslabs.com>

[ Upstream commit 2d570a7c0251c594489a2c16b82b14ae30345c03 ]

When nvme_tcp_io_work() fails to send to socket due to
connection close/reset, error_recovery work is triggered
from nvme_tcp_state_change() socket callback.
This cancels all the active requests in the tagset,
which requeues them.

The failed request, however, was ended and thus requeued
individually as well unless send returned -EPIPE.
Another return code to be treated the same way is -ECONNRESET.

Double requeue caused BUG_ON(blk_queued_rq(rq))
in blk_mq_requeue_request() from either the individual requeue
of the failed request or the bulk requeue from
blk_mq_tagset_busy_iter(, nvme_cancel_request, );

Signed-off-by: Anton Eidelman <anton@lightbitslabs.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 6d43b23a0fc8b..f8fa5c5b79f17 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1054,7 +1054,12 @@ static void nvme_tcp_io_work(struct work_struct *w)
 		} else if (unlikely(result < 0)) {
 			dev_err(queue->ctrl->ctrl.device,
 				"failed to send request %d\n", result);
-			if (result != -EPIPE)
+
+			/*
+			 * Fail the request unless peer closed the connection,
+			 * in which case error recovery flow will complete all.
+			 */
+			if ((result != -EPIPE) && (result != -ECONNRESET))
 				nvme_tcp_fail_request(queue->request);
 			nvme_tcp_done_send_req(queue);
 			return;
-- 
2.20.1



