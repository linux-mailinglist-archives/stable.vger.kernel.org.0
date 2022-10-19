Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E86603EC1
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbiJSJUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233475AbiJSJTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:19:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC114D77C0;
        Wed, 19 Oct 2022 02:08:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB8126178B;
        Wed, 19 Oct 2022 09:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF25AC433C1;
        Wed, 19 Oct 2022 09:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170212;
        bh=sQ9NXxr/f8eLg3digNQPAnvxyfeNTxmeNbktTp8h32g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sUFtiuTvXciwz+xm+hNoCOfJC8bNmYYPLyMmPxpJV0iQI75WM4zh4qvxCUNXz/ZEH
         AuxTAmwpg3vOPTujt7Y9Zip/fc4QTfMhgALeQPvQDCSmDIn2l2nPT6SCFpYyYxoVYH
         Fpztkg+BLolRBp7G9Q9Y6AVNFrPab5Zu96+z2ANI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Hannes Reinecke <hare@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 570/862] nvmet-auth: dont try to cancel a non-initialized work_struct
Date:   Wed, 19 Oct 2022 10:30:57 +0200
Message-Id: <20221019083315.174120838@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 1befd944e05050d76950014f3dc04ed47faba2c3 ]

Currently blktests nvme/002 trips up debugobjects if CONFIG_NVME_AUTH is
enabled, but authentication is not on a queue.  This is because
nvmet_auth_sq_free cancels sq->auth_expired_work unconditionaly, while
auth_expired_work is only ever initialized if authentication is enabled
for a given controller.

Fix this by calling most of what is nvmet_init_auth unconditionally
when initializing the SQ, and just do the setting of the result
field in the connect command handler.

Fixes: db1312dd9548 ("nvmet: implement basic In-Band Authentication")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c             |  1 +
 drivers/nvme/target/fabrics-cmd-auth.c | 13 ++++---------
 drivers/nvme/target/fabrics-cmd.c      |  6 ++++--
 drivers/nvme/target/nvmet.h            |  7 ++++---
 4 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 7f4083cf953a..14677145bbba 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -832,6 +832,7 @@ int nvmet_sq_init(struct nvmet_sq *sq)
 	}
 	init_completion(&sq->free_done);
 	init_completion(&sq->confirm_done);
+	nvmet_auth_sq_init(sq);
 
 	return 0;
 }
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index ebdf9aa81041..0c078b6b1447 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -23,17 +23,12 @@ static void nvmet_auth_expired_work(struct work_struct *work)
 	sq->dhchap_tid = -1;
 }
 
-void nvmet_init_auth(struct nvmet_ctrl *ctrl, struct nvmet_req *req)
+void nvmet_auth_sq_init(struct nvmet_sq *sq)
 {
-	u32 result = le32_to_cpu(req->cqe->result.u32);
-
 	/* Initialize in-band authentication */
-	INIT_DELAYED_WORK(&req->sq->auth_expired_work,
-			  nvmet_auth_expired_work);
-	req->sq->authenticated = false;
-	req->sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE;
-	result |= (u32)NVME_CONNECT_AUTHREQ_ATR << 16;
-	req->cqe->result.u32 = cpu_to_le32(result);
+	INIT_DELAYED_WORK(&sq->auth_expired_work, nvmet_auth_expired_work);
+	sq->authenticated = false;
+	sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE;
 }
 
 static u16 nvmet_auth_negotiate(struct nvmet_req *req, void *d)
diff --git a/drivers/nvme/target/fabrics-cmd.c b/drivers/nvme/target/fabrics-cmd.c
index f91a56180d3d..bd739d8b6991 100644
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -272,7 +272,8 @@ static void nvmet_execute_admin_connect(struct nvmet_req *req)
 	req->cqe->result.u16 = cpu_to_le16(ctrl->cntlid);
 
 	if (nvmet_has_auth(ctrl))
-		nvmet_init_auth(ctrl, req);
+		req->cqe->result.u32 |=
+			cpu_to_le32((u32)NVME_CONNECT_AUTHREQ_ATR << 16);
 out:
 	kfree(d);
 complete:
@@ -334,7 +335,8 @@ static void nvmet_execute_io_connect(struct nvmet_req *req)
 	pr_debug("adding queue %d to ctrl %d.\n", qid, ctrl->cntlid);
 	req->cqe->result.u16 = cpu_to_le16(ctrl->cntlid);
 	if (nvmet_has_auth(ctrl))
-		nvmet_init_auth(ctrl, req);
+		req->cqe->result.u32 |=
+			cpu_to_le32((u32)NVME_CONNECT_AUTHREQ_ATR << 16);
 
 out:
 	kfree(d);
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 6ffeeb0a1c49..dfe3894205aa 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -704,7 +704,7 @@ int nvmet_auth_set_key(struct nvmet_host *host, const char *secret,
 		       bool set_ctrl);
 int nvmet_auth_set_host_hash(struct nvmet_host *host, const char *hash);
 int nvmet_setup_auth(struct nvmet_ctrl *ctrl);
-void nvmet_init_auth(struct nvmet_ctrl *ctrl, struct nvmet_req *req);
+void nvmet_auth_sq_init(struct nvmet_sq *sq);
 void nvmet_destroy_auth(struct nvmet_ctrl *ctrl);
 void nvmet_auth_sq_free(struct nvmet_sq *sq);
 int nvmet_setup_dhgroup(struct nvmet_ctrl *ctrl, u8 dhgroup_id);
@@ -726,8 +726,9 @@ static inline int nvmet_setup_auth(struct nvmet_ctrl *ctrl)
 {
 	return 0;
 }
-static inline void nvmet_init_auth(struct nvmet_ctrl *ctrl,
-				   struct nvmet_req *req) {};
+static inline void nvmet_auth_sq_init(struct nvmet_sq *sq)
+{
+}
 static inline void nvmet_destroy_auth(struct nvmet_ctrl *ctrl) {};
 static inline void nvmet_auth_sq_free(struct nvmet_sq *sq) {};
 static inline bool nvmet_check_auth_status(struct nvmet_req *req)
-- 
2.35.1



