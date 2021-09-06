Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA5C40140D
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241000AbhIFBcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241257AbhIFB2c (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:28:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9266461103;
        Mon,  6 Sep 2021 01:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891386;
        bh=LCusNe/AMO3RUFyj6lq33r72Gup2BEzvmGh1RFSV8nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OrQafpGw86Y5KFab4R0uOWMsaN6S2FiRhMKXFrJiYkMPhP0CH50bPokbhE4S6RESg
         nmWXmFVOK9vGg/ES69Xp31JzoqPwHdpVP1C/IUuU3woMNOOYDVupm9HjdCtP5FzIYJ
         Qp5qBe/NyDtTQbeGSHa59a2oDl+2mXNPhJlomMIGMdt6rhIRvZ3Wg3ooWX5WHLe/RR
         qbBYDUEZ0QEyJCbAYXiPTw9or5zH6ehKMl11qCR/cLbLFVJ/ujMI9voqurgxV/Cws6
         vXMpJzmm3ZVpy8aq9ObPrRmCBSOVk6aJPqtl/AodDius2HDRcSuUoqNxXZY9YDeuv6
         2p1bsTP00ttqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amit Engel <amit.engel@dell.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 18/30] nvmet: pass back cntlid on successful completion
Date:   Sun,  5 Sep 2021 21:22:31 -0400
Message-Id: <20210906012244.930338-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012244.930338-1-sashal@kernel.org>
References: <20210906012244.930338-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Engel <amit.engel@dell.com>

[ Upstream commit e804d5abe2d74cfe23f5f83be580d1cdc9307111 ]

According to the NVMe specification, the response dword 0 value of the
Connect command is based on status code: return cntlid for successful
compeltion return IPO and IATTR for connect invalid parameters.  Fix
a missing error information for a zero sized queue, and return the
cntlid also for I/O queue Connect commands.

Signed-off-by: Amit Engel <amit.engel@dell.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fabrics-cmd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/fabrics-cmd.c b/drivers/nvme/target/fabrics-cmd.c
index 4e9004fe5c6f..5e47395afc1d 100644
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -116,6 +116,7 @@ static u16 nvmet_install_queue(struct nvmet_ctrl *ctrl, struct nvmet_req *req)
 	if (!sqsize) {
 		pr_warn("queue size zero!\n");
 		req->error_loc = offsetof(struct nvmf_connect_command, sqsize);
+		req->cqe->result.u32 = IPO_IATTR_CONNECT_SQE(sqsize);
 		ret = NVME_SC_CONNECT_INVALID_PARAM | NVME_SC_DNR;
 		goto err;
 	}
@@ -250,11 +251,11 @@ static void nvmet_execute_io_connect(struct nvmet_req *req)
 	}
 
 	status = nvmet_install_queue(ctrl, req);
-	if (status) {
-		/* pass back cntlid that had the issue of installing queue */
-		req->cqe->result.u16 = cpu_to_le16(ctrl->cntlid);
+	if (status)
 		goto out_ctrl_put;
-	}
+
+	/* pass back cntlid for successful completion */
+	req->cqe->result.u16 = cpu_to_le16(ctrl->cntlid);
 
 	pr_debug("adding queue %d to ctrl %d.\n", qid, ctrl->cntlid);
 
-- 
2.30.2

