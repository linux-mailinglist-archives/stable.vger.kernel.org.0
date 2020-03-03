Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E849F17801E
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732590AbgCCRys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:54:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732587AbgCCRys (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:54:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 364BC21739;
        Tue,  3 Mar 2020 17:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258087;
        bh=cACRJLPYJUGqekbbL6xWCecdMYb50zkd2HoNIw//Oyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=op1s4v6QAcFMXnis8cLSiUexdkXLa8FeQE8YVqFLFddUtvdchzcLAo13sL6s3T0VZ
         W64P+4C5Xzno40f+C1eXhWtLbP8RHmDorkP8Jdm0dQSPFJh5riH/FQV6yP1fy2aQXb
         M1sJBWK4x1Yzx7bPaOnea0/sVpLFDdUpEaR4Vr64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Eidelman <anton@lightbitslabs.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/152] nvme/tcp: fix bug on double requeue when send fails
Date:   Tue,  3 Mar 2020 18:42:45 +0100
Message-Id: <20200303174310.083118138@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
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
index 7544be84ab358..a870144542159 100644
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



