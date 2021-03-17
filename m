Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12ACA33E43B
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbhCQA6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:58:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231783AbhCQA5x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BD3164FE6;
        Wed, 17 Mar 2021 00:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942668;
        bh=tYjGZQ3A/9doDNTjdj/vhCflGKISs1dWpYUHS0Px9kA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSjJeYt2nOz8OwGIFurOkHbgQXNYLK1txVi9QLdv/ppz+6NfCI7kqtrdNF2CM21Ok
         yvk2vEfTIfdu5l5Q2Jq/uIdPJI/zXwhuGxPQrAhrTSqKFVBo5AN6Y5Q8HwjcE8osQ/
         1JGtAFKAfalNqPeoh18RN/mj/SnezjpSfH7cIU/5Qxb2xjh3PzLqOUsulx0mgQ2Fey
         TlLqbmn6Zsa5APp3yYZCTMa21JSG8fj+IB4Y3KX2IM0+35FOVWTX3awB8198jOluaG
         EcNe5nIxUIzTIc/5qyOkn18qiKKNHaaqSbLrO227YHfIJyF1GWgHfiYYNeURBX7m2o
         bByrnY0QQNLSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chao Leng <lengchao@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 44/54] nvme: add NVME_REQ_CANCELLED flag in nvme_cancel_request()
Date:   Tue, 16 Mar 2021 20:56:43 -0400
Message-Id: <20210317005654.724862-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit d3589381987ec879b03f8ce3039df57e87f05901 ]

NVME_REQ_CANCELLED is translated into -EINTR in nvme_submit_sync_cmd(),
so we should be setting this flags during nvme_cancel_request() to
ensure that the callers to nvme_submit_sync_cmd() will get the correct
error code when the controller is reset.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chao Leng <lengchao@huawei.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 990e1adafaad..a684168fa4a3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -346,6 +346,7 @@ bool nvme_cancel_request(struct request *req, void *data, bool reserved)
 		return true;
 
 	nvme_req(req)->status = NVME_SC_HOST_ABORTED_CMD;
+	nvme_req(req)->flags |= NVME_REQ_CANCELLED;
 	blk_mq_complete_request(req);
 	return true;
 }
-- 
2.30.1

