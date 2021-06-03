Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101F139A723
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhFCRKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:10:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231805AbhFCRKP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D21F3613F5;
        Thu,  3 Jun 2021 17:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740105;
        bh=dlgU04bR/sbF/+Ky2teH1Bjfg0yElnMFnXuEDB5oDSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGJjcXxCxI1WZyaYmi63T26mxnM2NixfEM165zl+ORZjn6+jS4BGnncb9MYpOlqpf
         iLws204RJy2ugHycr4ucol6TnKB7JlTbi9XI04lOfiI/MKfGnS9fFfubc4F9wVXMvb
         su6crFC1rWfgpA0n/V0BdukAe5VzvXJdkgIrhnx9t8zSQbiDPfD92h0egC4oLqCxha
         gboBWCYCbp+B0iq3akM2+3ZmD7Y3zMBVBq9q60yIxTwCZrSKv1hk2x3SQYqPjjrxsO
         NfAWOHXh6RCz1dIk36M14nBXzzHenFoXHQQHCOvf3M4L5iFVX+Ju0Of9iZC9p4DHvk
         6BvU7I3SXbJng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Yi Zhang <yi.zhang@redhat.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 41/43] nvmet: fix false keep-alive timeout when a controller is torn down
Date:   Thu,  3 Jun 2021 13:07:31 -0400
Message-Id: <20210603170734.3168284-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit aaeadd7075dc9e184bc7876e9dd7b3bada771df2 ]

Controller teardown flow may take some time in case it has many I/O
queues, and the host may not send us keep-alive during this period.
Hence reset the traffic based keep-alive timer so we don't trigger
a controller teardown as a result of a keep-alive expiration.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c  | 15 +++++++++++----
 drivers/nvme/target/nvmet.h |  2 +-
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 348057fdc568..32880c38ec69 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -388,10 +388,10 @@ static void nvmet_keep_alive_timer(struct work_struct *work)
 {
 	struct nvmet_ctrl *ctrl = container_of(to_delayed_work(work),
 			struct nvmet_ctrl, ka_work);
-	bool cmd_seen = ctrl->cmd_seen;
+	bool reset_tbkas = ctrl->reset_tbkas;
 
-	ctrl->cmd_seen = false;
-	if (cmd_seen) {
+	ctrl->reset_tbkas = false;
+	if (reset_tbkas) {
 		pr_debug("ctrl %d reschedule traffic based keep-alive timer\n",
 			ctrl->cntlid);
 		schedule_delayed_work(&ctrl->ka_work, ctrl->kato * HZ);
@@ -804,6 +804,13 @@ void nvmet_sq_destroy(struct nvmet_sq *sq)
 	percpu_ref_exit(&sq->ref);
 
 	if (ctrl) {
+		/*
+		 * The teardown flow may take some time, and the host may not
+		 * send us keep-alive during this period, hence reset the
+		 * traffic based keep-alive timer so we don't trigger a
+		 * controller teardown as a result of a keep-alive expiration.
+		 */
+		ctrl->reset_tbkas = true;
 		nvmet_ctrl_put(ctrl);
 		sq->ctrl = NULL; /* allows reusing the queue later */
 	}
@@ -953,7 +960,7 @@ bool nvmet_req_init(struct nvmet_req *req, struct nvmet_cq *cq,
 	}
 
 	if (sq->ctrl)
-		sq->ctrl->cmd_seen = true;
+		sq->ctrl->reset_tbkas = true;
 
 	return true;
 
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 5aad34b106dc..43a668dc8bc4 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -166,7 +166,7 @@ struct nvmet_ctrl {
 	struct nvmet_subsys	*subsys;
 	struct nvmet_sq		**sqs;
 
-	bool			cmd_seen;
+	bool			reset_tbkas;
 
 	struct mutex		lock;
 	u64			cap;
-- 
2.30.2

