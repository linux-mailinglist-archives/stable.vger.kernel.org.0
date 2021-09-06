Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2608A40139C
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240463AbhIFB12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240457AbhIFBZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:25:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA96261156;
        Mon,  6 Sep 2021 01:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891339;
        bh=srCEX5hDH1f1BlauxJ8yXAYw6/Hk5sS8nPcQ4WwwupE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CMIMRwpnJIEDuVg8UedO5CjYG6TwnlF+JHOFoeUpWEnUSnPiY7mC4KjQ4cE0t50KR
         yOUIEyVdpgiD1gvmeyl8mQc8EW/O6m5c1ioNsl/81sDc7gj+bYccOz9DSB7z4WGbz9
         t2eu54mSgSQAMXC+x4cMPBJRNg9JD+RP1W2yDxzD6tPcC56kzyxZ0ilWzxaGcAK5Ug
         jmHM1nGcCZ96Iu7216NWGxLlx63vsi+39F3poXeVPPi9vzSdpDtoXiF7N2UZqGJdSE
         6kacwbg53sWDnlkdgjzNX4W6dTF4GWB2qU3P443UyXIF8JScM8gjDqg7QuFa6AE02C
         lwIsBuHrfqXEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amit Engel <amit.engel@dell.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 21/39] nvmet: pass back cntlid on successful completion
Date:   Sun,  5 Sep 2021 21:21:35 -0400
Message-Id: <20210906012153.929962-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012153.929962-1-sashal@kernel.org>
References: <20210906012153.929962-1-sashal@kernel.org>
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
index 42bd12b8bf00..e62d3d0fa6c8 100644
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -120,6 +120,7 @@ static u16 nvmet_install_queue(struct nvmet_ctrl *ctrl, struct nvmet_req *req)
 	if (!sqsize) {
 		pr_warn("queue size zero!\n");
 		req->error_loc = offsetof(struct nvmf_connect_command, sqsize);
+		req->cqe->result.u32 = IPO_IATTR_CONNECT_SQE(sqsize);
 		ret = NVME_SC_CONNECT_INVALID_PARAM | NVME_SC_DNR;
 		goto err;
 	}
@@ -263,11 +264,11 @@ static void nvmet_execute_io_connect(struct nvmet_req *req)
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

