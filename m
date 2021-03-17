Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986FC33E3A9
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhCQA5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231241AbhCQA4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C54A064FB1;
        Wed, 17 Mar 2021 00:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942599;
        bh=i7nnm8jlMD5cyaAei6bZYW7HxQe2ObppYJZxeKOl+kM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IDeR6VjZBKwrpaMFuTfX6D2DX8UEaVHhC8ic1kDXBB+xigl2XahLnAFKaJatOpJbP
         FxKLB1yBP2NixkDZ6s9Xjut42qy3jXoyi+LQGVrEqOq8Q72ADAFEF7F4YvDopfEywD
         9/uxie6PUZtVdZPJ8AMPcGyNVPo7gjVQJRjrKZQOey+HNScsoN+/n0xZfRt78R4m11
         3Yn5bAt2DulRg/F3c2NH6eHGBWjR+Yvz2jSTBjyiZS+7EMFSeAfx1c1EHAbNWkWeVD
         Ku1vxleebhOjvGxOiWcIv0oe+fi2sRISa8JMRiiKl/ijbxr6zc0NqBHe/Kcc6wqMVi
         uOb7Nmu1a5Ikw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        James Smart <jsmart2021@gmail.com>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 51/61] nvme-fc: set NVME_REQ_CANCELLED in nvme_fc_terminate_exchange()
Date:   Tue, 16 Mar 2021 20:55:25 -0400
Message-Id: <20210317005536.724046-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 3c7aafbc8d3d4d90430dfa126847a796c3e4ecfc ]

nvme_fc_terminate_exchange() is being called when exchanges are
being deleted, and as such we should be setting the NVME_REQ_CANCELLED
flag to have identical behaviour on all transports.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 5f36cfa8136c..cd2d28139d97 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2443,6 +2443,7 @@ nvme_fc_terminate_exchange(struct request *req, void *data, bool reserved)
 	struct nvme_fc_ctrl *ctrl = to_fc_ctrl(nctrl);
 	struct nvme_fc_fcp_op *op = blk_mq_rq_to_pdu(req);
 
+	op->nreq.flags |= NVME_REQ_CANCELLED;
 	__nvme_fc_abort_op(ctrl, op);
 	return true;
 }
-- 
2.30.1

