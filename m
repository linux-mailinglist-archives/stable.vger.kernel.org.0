Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11C2408C86
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240262AbhIMNUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236138AbhIMNTt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:19:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EEB2610A2;
        Mon, 13 Sep 2021 13:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539036;
        bh=LCusNe/AMO3RUFyj6lq33r72Gup2BEzvmGh1RFSV8nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GwJV0yVAZTGSgsgpGvHxU+Pm71dWqQL5t0vYymMtlvb7UodqoovD7telhEQ7HRXFK
         aDFyX63FJ2gwyGBW7dp9m6AcCHSF7sS5eCFl7MO4OGWQKGWoK7GBo+qs9qQHgIEYMw
         iJR47bd2pUY7oZMs+9VxQFvyrWBQ01idPHOwKrug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Engel <amit.engel@dell.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 018/144] nvmet: pass back cntlid on successful completion
Date:   Mon, 13 Sep 2021 15:13:19 +0200
Message-Id: <20210913131048.568435634@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



