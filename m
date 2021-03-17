Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196AE33E463
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhCQA7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:59:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232226AbhCQA7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E05264FE1;
        Wed, 17 Mar 2021 00:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942721;
        bh=DktL64CecxMdctqRV6G669oGtXDYAHLcGAc3jaz8tcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GT4f3K2tUW6kHTkniKIHfAyvcA+FYLLJR8xaQ4reRnZE7L1hWYs8IzacGsJ+eeleo
         FarPHGBYX04FRDpP8jU6q0xyHR+969MXpJWXHdwz0xeOOIA7mfOJwGVGQE7XT7NfTq
         sLHJIzUttLJSDxxHmNh7fEYqkcttFzlco4P01iVmbIbaEP5PjaF856cptTIGfhHjNb
         Oyr+xJMEElaRsTGxE1mYKQ/yARG4/i8NPIRUsH4Fc5CfCWdbH63tsqqwQdP7OKf1ve
         6vqEZfv4IGEiYSR6oEXtfXDcds5KsYqCZqQQvYJgnn6bXThGBEUrc9wRlLZDfUkKXl
         U3i/IdlNtI6yw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chao Leng <lengchao@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 31/37] nvme: add NVME_REQ_CANCELLED flag in nvme_cancel_request()
Date:   Tue, 16 Mar 2021 20:57:56 -0400
Message-Id: <20210317005802.725825-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005802.725825-1-sashal@kernel.org>
References: <20210317005802.725825-1-sashal@kernel.org>
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
index 95d77a17375e..2719f84c3759 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -312,6 +312,7 @@ bool nvme_cancel_request(struct request *req, void *data, bool reserved)
 		return true;
 
 	nvme_req(req)->status = NVME_SC_HOST_ABORTED_CMD;
+	nvme_req(req)->flags |= NVME_REQ_CANCELLED;
 	blk_mq_complete_request(req);
 	return true;
 }
-- 
2.30.1

