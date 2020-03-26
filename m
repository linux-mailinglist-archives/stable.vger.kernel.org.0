Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26443194C65
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgCZXYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbgCZXYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:24:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51EC920B80;
        Thu, 26 Mar 2020 23:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265088;
        bh=x1oBz/4EeoEH0IuRsxGJH5wWdqksV4YEUNXQ3V7mBW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1TSV/FMmIrwy8gO8AdhkiEjMdh/nBQPYu2bZKkF4eBplDVx9JXOpcXbe3DLQ1Q+IJ
         l1jegLEnluZ6dZLNpdn6E5mcap3UIw6psvnpCJfdtw08eH1wcn4qW5M4nX48FdSPiQ
         OH0upsGm1YPmpJTT/6X0Y74meOk20/qVXO0AhD6I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Mark Wunderlich <mark.wunderlich@intel.com>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 14/19] nvmet-tcp: set MSG_MORE only if we actually have more to send
Date:   Thu, 26 Mar 2020 19:24:26 -0400
Message-Id: <20200326232431.7816-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326232431.7816-1-sashal@kernel.org>
References: <20200326232431.7816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 98fd5c723730f560e5bea919a64ac5b83d45eb72 ]

When we send PDU data, we want to optimize the tcp stack
operation if we have more data to send. So when we set MSG_MORE
when:
- We have more fragments coming in the batch, or
- We have a more data to send in this PDU
- We don't have a data digest trailer
- We optimize with the SUCCESS flag and omit the NVMe completion
  (used if sq_head pointer update is disabled)

This addresses a regression in QD=1 with SUCCESS flag optimization
as we unconditionally set MSG_MORE when we didn't actually have
more data to send.

Fixes: 70583295388a ("nvmet-tcp: implement C2HData SUCCESS optimization")
Reported-by: Mark Wunderlich <mark.wunderlich@intel.com>
Tested-by: Mark Wunderlich <mark.wunderlich@intel.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index d535080b781f9..2fe34fd4c3f3b 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -515,7 +515,7 @@ static int nvmet_try_send_data_pdu(struct nvmet_tcp_cmd *cmd)
 	return 1;
 }
 
-static int nvmet_try_send_data(struct nvmet_tcp_cmd *cmd)
+static int nvmet_try_send_data(struct nvmet_tcp_cmd *cmd, bool last_in_batch)
 {
 	struct nvmet_tcp_queue *queue = cmd->queue;
 	int ret;
@@ -523,9 +523,15 @@ static int nvmet_try_send_data(struct nvmet_tcp_cmd *cmd)
 	while (cmd->cur_sg) {
 		struct page *page = sg_page(cmd->cur_sg);
 		u32 left = cmd->cur_sg->length - cmd->offset;
+		int flags = MSG_DONTWAIT;
+
+		if ((!last_in_batch && cmd->queue->send_list_len) ||
+		    cmd->wbytes_done + left < cmd->req.transfer_len ||
+		    queue->data_digest || !queue->nvme_sq.sqhd_disabled)
+			flags |= MSG_MORE;
 
 		ret = kernel_sendpage(cmd->queue->sock, page, cmd->offset,
-					left, MSG_DONTWAIT | MSG_MORE);
+					left, flags);
 		if (ret <= 0)
 			return ret;
 
@@ -660,7 +666,7 @@ static int nvmet_tcp_try_send_one(struct nvmet_tcp_queue *queue,
 	}
 
 	if (cmd->state == NVMET_TCP_SEND_DATA) {
-		ret = nvmet_try_send_data(cmd);
+		ret = nvmet_try_send_data(cmd, last_in_batch);
 		if (ret <= 0)
 			goto done_send;
 	}
-- 
2.20.1

