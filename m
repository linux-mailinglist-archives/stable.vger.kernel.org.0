Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8B73A6394
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbhFNLPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234864AbhFNLMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:12:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FCD0613DB;
        Mon, 14 Jun 2021 10:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667702;
        bh=wXO39wCsdcrkENkG6Ajr5cPDuOypW5+mprTTBx4HEjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tyJwnL6Vjv9I1AgGeU8SU5FW8/hxeOCNJXN/pMDn99mc9rD2Dhr9ZDcarbtiQf+R7
         KgF7Daeu4eD8HkB3/J46SJA8mTZgF76ALwlXawBJp/UPYVWpyVxn2Kt3KRllUHovmP
         pZnN+pWZ+VysnxPwwEcyexgqegnfCIcVqr2Ry8v0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Zhang <yi.zhang@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 042/173] nvmet: fix false keep-alive timeout when a controller is torn down
Date:   Mon, 14 Jun 2021 12:26:14 +0200
Message-Id: <20210614102659.567114639@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7d16cb4cd8ac..83921dab8368 100644
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



