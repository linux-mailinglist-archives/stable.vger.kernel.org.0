Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D20116947A
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 03:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbgBWCam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 21:30:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728719AbgBWCXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Feb 2020 21:23:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77FE62071E;
        Sun, 23 Feb 2020 02:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424614;
        bh=cACRJLPYJUGqekbbL6xWCecdMYb50zkd2HoNIw//Oyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6XNaKwCrdR/zoLjg2tZ1IgNynM8WaXGtIOia6IA2gPnu1OqLzaIvUDDOYcMU46GV
         Wmq394k3rCrqeQvuiAC0VPsi5qm5MlOYP9okXRKoTd8XP+RY3GKOPeZJFtOwy+jBWX
         QgPhPoGrigHjyyAMYsvCSdt76QhVAciOvFO3sUiw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anton Eidelman <anton@lightbitslabs.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 48/50] nvme/tcp: fix bug on double requeue when send fails
Date:   Sat, 22 Feb 2020 21:22:33 -0500
Message-Id: <20200223022235.1404-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022235.1404-1-sashal@kernel.org>
References: <20200223022235.1404-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

