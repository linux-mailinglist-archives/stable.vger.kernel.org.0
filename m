Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B806626EF4
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732015AbfEVTxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:53:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731781AbfEVTZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:25:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4492A217F9;
        Wed, 22 May 2019 19:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553152;
        bh=lmU9g21+k0C40muQus4b77NNYcsDPyTrcPmreAglkX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0WN+tFWnCldHJFWb2VXDELux2bdm//DOEhGtqV3bQvwg/TQIe/3bG2FrWlgMe6USz
         fOpjafnhj0sidNSz+ogi4sAhC7Y+4Sj3iDNIk8f9HeT3TMGM0dfepBi5cF1Ex+KZiZ
         LQ2DhF6W2Y71tXVcj40OziXD+OzVJxMwJ2ZIp4pU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.0 080/317] nvme-tcp: fix a NULL deref when an admin connect times out
Date:   Wed, 22 May 2019 15:19:41 -0400
Message-Id: <20190522192338.23715-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 7a42589654ae79e1177f0d74306a02d6cef7bddf ]

If we timeout the admin startup sequence we might not yet have
an I/O tagset allocated which causes the teardown sequence to crash.
Make nvme_tcp_teardown_io_queues safe by not iterating inflight tags
if the tagset wasn't allocated.

Fixes: 39d57757467b ("nvme-tcp: fix timeout handler")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 5f0a004252422..e71b0058c57bd 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1686,7 +1686,9 @@ static void nvme_tcp_teardown_admin_queue(struct nvme_ctrl *ctrl,
 {
 	blk_mq_quiesce_queue(ctrl->admin_q);
 	nvme_tcp_stop_queue(ctrl, 0);
-	blk_mq_tagset_busy_iter(ctrl->admin_tagset, nvme_cancel_request, ctrl);
+	if (ctrl->admin_tagset)
+		blk_mq_tagset_busy_iter(ctrl->admin_tagset,
+			nvme_cancel_request, ctrl);
 	blk_mq_unquiesce_queue(ctrl->admin_q);
 	nvme_tcp_destroy_admin_queue(ctrl, remove);
 }
@@ -1698,7 +1700,9 @@ static void nvme_tcp_teardown_io_queues(struct nvme_ctrl *ctrl,
 		return;
 	nvme_stop_queues(ctrl);
 	nvme_tcp_stop_io_queues(ctrl);
-	blk_mq_tagset_busy_iter(ctrl->tagset, nvme_cancel_request, ctrl);
+	if (ctrl->tagset)
+		blk_mq_tagset_busy_iter(ctrl->tagset,
+			nvme_cancel_request, ctrl);
 	if (remove)
 		nvme_start_queues(ctrl);
 	nvme_tcp_destroy_io_queues(ctrl, remove);
-- 
2.20.1

