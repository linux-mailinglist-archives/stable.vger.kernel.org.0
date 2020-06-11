Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2B71F6BAB
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 17:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgFKPzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 11:55:36 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:60639 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbgFKPzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 11:55:36 -0400
Received: from moto.blr.asicdesigners.com (moto.blr.asicdesigners.com [10.193.184.79] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05BFrs75005517;
        Thu, 11 Jun 2020 08:55:03 -0700
From:   Dakshaja Uppalapati <dakshaja@chelsio.com>
To:     eduard@hasenleithner.at, kbusch@kernel.org, sagi@grimberg.me,
        hch@lst.de
Cc:     stable@vger.kernel.org, nirranjan@chelsio.com, bharat@chelsio.com,
        dakshaja@chelsio.com, Logan Gunthorpe <logang@deltatee.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-stable nvmet 2/6] nvmet: Introduce common execute function for get_log_page and identify
Date:   Thu, 11 Jun 2020 21:23:35 +0530
Message-Id: <20200611155339.9429-3-dakshaja@chelsio.com>
X-Mailer: git-send-email 2.18.0.232.gb7bd9486b.dirty
In-Reply-To: <20200611155339.9429-1-dakshaja@chelsio.com>
References: <20200611155339.9429-1-dakshaja@chelsio.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Instead of picking the sub-command handler to execute in a nested
switch statement introduce a landing functions that calls out
to the appropriate sub-command handler.

This will allow us to have a common place in the handler to check
the transfer length in a future patch.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Dakshaja Uppalapati <dakshaja@chelsio.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
[split patch, update change log]
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/nvme/target/admin-cmd.c | 93 ++++++++++++++++++---------------
 1 file changed, 50 insertions(+), 43 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 831a062d27cb..3665b45d6515 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -282,6 +282,33 @@ static void nvmet_execute_get_log_page_ana(struct nvmet_req *req)
 	nvmet_req_complete(req, status);
 }
 
+static void nvmet_execute_get_log_page(struct nvmet_req *req)
+{
+	switch (req->cmd->get_log_page.lid) {
+	case NVME_LOG_ERROR:
+		return nvmet_execute_get_log_page_error(req);
+	case NVME_LOG_SMART:
+		return nvmet_execute_get_log_page_smart(req);
+	case NVME_LOG_FW_SLOT:
+		/*
+		 * We only support a single firmware slot which always is
+		 * active, so we can zero out the whole firmware slot log and
+		 * still claim to fully implement this mandatory log page.
+		 */
+		return nvmet_execute_get_log_page_noop(req);
+	case NVME_LOG_CHANGED_NS:
+		return nvmet_execute_get_log_changed_ns(req);
+	case NVME_LOG_CMD_EFFECTS:
+		return nvmet_execute_get_log_cmd_effects_ns(req);
+	case NVME_LOG_ANA:
+		return nvmet_execute_get_log_page_ana(req);
+	}
+	pr_err("unhandled lid %d on qid %d\n",
+	       req->cmd->get_log_page.lid, req->sq->qid);
+	req->error_loc = offsetof(struct nvme_get_log_page_command, lid);
+	nvmet_req_complete(req, NVME_SC_INVALID_FIELD | NVME_SC_DNR);
+}
+
 static void nvmet_execute_identify_ctrl(struct nvmet_req *req)
 {
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
@@ -565,6 +592,25 @@ static void nvmet_execute_identify_desclist(struct nvmet_req *req)
 	nvmet_req_complete(req, status);
 }
 
+static void nvmet_execute_identify(struct nvmet_req *req)
+{
+	switch (req->cmd->identify.cns) {
+	case NVME_ID_CNS_NS:
+		return nvmet_execute_identify_ns(req);
+	case NVME_ID_CNS_CTRL:
+		return nvmet_execute_identify_ctrl(req);
+	case NVME_ID_CNS_NS_ACTIVE_LIST:
+		return nvmet_execute_identify_nslist(req);
+	case NVME_ID_CNS_NS_DESC_LIST:
+		return nvmet_execute_identify_desclist(req);
+	}
+
+	pr_err("unhandled identify cns %d on qid %d\n",
+	       req->cmd->identify.cns, req->sq->qid);
+	req->error_loc = offsetof(struct nvme_identify, cns);
+	nvmet_req_complete(req, NVME_SC_INVALID_FIELD | NVME_SC_DNR);
+}
+
 /*
  * A "minimum viable" abort implementation: the command is mandatory in the
  * spec, but we are not required to do any useful work.  We couldn't really
@@ -819,52 +865,13 @@ u16 nvmet_parse_admin_cmd(struct nvmet_req *req)
 
 	switch (cmd->common.opcode) {
 	case nvme_admin_get_log_page:
+		req->execute = nvmet_execute_get_log_page;
 		req->data_len = nvmet_get_log_page_len(cmd);
-
-		switch (cmd->get_log_page.lid) {
-		case NVME_LOG_ERROR:
-			req->execute = nvmet_execute_get_log_page_error;
-			return 0;
-		case NVME_LOG_SMART:
-			req->execute = nvmet_execute_get_log_page_smart;
-			return 0;
-		case NVME_LOG_FW_SLOT:
-			/*
-			 * We only support a single firmware slot which always
-			 * is active, so we can zero out the whole firmware slot
-			 * log and still claim to fully implement this mandatory
-			 * log page.
-			 */
-			req->execute = nvmet_execute_get_log_page_noop;
-			return 0;
-		case NVME_LOG_CHANGED_NS:
-			req->execute = nvmet_execute_get_log_changed_ns;
-			return 0;
-		case NVME_LOG_CMD_EFFECTS:
-			req->execute = nvmet_execute_get_log_cmd_effects_ns;
-			return 0;
-		case NVME_LOG_ANA:
-			req->execute = nvmet_execute_get_log_page_ana;
-			return 0;
-		}
-		break;
+		return 0;
 	case nvme_admin_identify:
+		req->execute = nvmet_execute_identify;
 		req->data_len = NVME_IDENTIFY_DATA_SIZE;
-		switch (cmd->identify.cns) {
-		case NVME_ID_CNS_NS:
-			req->execute = nvmet_execute_identify_ns;
-			return 0;
-		case NVME_ID_CNS_CTRL:
-			req->execute = nvmet_execute_identify_ctrl;
-			return 0;
-		case NVME_ID_CNS_NS_ACTIVE_LIST:
-			req->execute = nvmet_execute_identify_nslist;
-			return 0;
-		case NVME_ID_CNS_NS_DESC_LIST:
-			req->execute = nvmet_execute_identify_desclist;
-			return 0;
-		}
-		break;
+		return 0;
 	case nvme_admin_abort_cmd:
 		req->execute = nvmet_execute_abort;
 		req->data_len = 0;
-- 
2.18.0.232.gb7bd9486b.dirty

