Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4E937D282
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350302AbhELSKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:10:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352685AbhELSEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:04:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65AEB6143C;
        Wed, 12 May 2021 18:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842573;
        bh=+IXOILcU2zmIP0zOiWzIOBTLsnPkTNvAChfh7lmrFIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=orc2ygmXH2cW33ldosbc460xMQZIvfSMztlCVDIhjpQWC23OGC+7Tg+3BjLM/pzLs
         GkrA/qvv7aZ2oiy79IP3ZywtPfLWCnnWJUm0qidlaNoqVt1fVTJkMeUNfweCUiL6eg
         kEkX55ok1c1cNM714uZKdxCoBeU0iuaiP9I0p9DZNvOQEXjFkPq4riy6QbWyjI+aRe
         4QaTlNyfk/7rBUrySwlvIGAzLzrpu75qFJvR9I3yqBdzRW2gOKE0QN7PUSxfS2Y3/r
         e8EvW6KqMV0rzxI8sQQs99pymvdwUipFEhvXSCncFgqFjnwY8jmxPaOaX/Z6PU25aY
         oixoM9QrMnHpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Yi Zhang <yi.zhang@redhat.com>,
        Klaus Jensen <k.jensen@samsung.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 28/35] nvmet: remove unsupported command noise
Date:   Wed, 12 May 2021 14:01:58 -0400
Message-Id: <20210512180206.664536-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180206.664536-1-sashal@kernel.org>
References: <20210512180206.664536-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 4a20342572f66c5b20a1ee680f5ac0a13703748f ]

Nothing can stop a host from submitting invalid commands. The target
just needs to respond with an appropriate status, but that's not a
target error. Demote invalid command messages to the debug level so
these events don't spam the kernel logs.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Klaus Jensen <k.jensen@samsung.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 1827d8d8f3b0..2c547d195d55 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -313,7 +313,7 @@ static void nvmet_execute_get_log_page(struct nvmet_req *req)
 	case NVME_LOG_ANA:
 		return nvmet_execute_get_log_page_ana(req);
 	}
-	pr_err("unhandled lid %d on qid %d\n",
+	pr_debug("unhandled lid %d on qid %d\n",
 	       req->cmd->get_log_page.lid, req->sq->qid);
 	req->error_loc = offsetof(struct nvme_get_log_page_command, lid);
 	nvmet_req_complete(req, NVME_SC_INVALID_FIELD | NVME_SC_DNR);
@@ -657,7 +657,7 @@ static void nvmet_execute_identify(struct nvmet_req *req)
 		return nvmet_execute_identify_desclist(req);
 	}
 
-	pr_err("unhandled identify cns %d on qid %d\n",
+	pr_debug("unhandled identify cns %d on qid %d\n",
 	       req->cmd->identify.cns, req->sq->qid);
 	req->error_loc = offsetof(struct nvme_identify, cns);
 	nvmet_req_complete(req, NVME_SC_INVALID_FIELD | NVME_SC_DNR);
@@ -972,7 +972,7 @@ u16 nvmet_parse_admin_cmd(struct nvmet_req *req)
 		return 0;
 	}
 
-	pr_err("unhandled cmd %d on qid %d\n", cmd->common.opcode,
+	pr_debug("unhandled cmd %d on qid %d\n", cmd->common.opcode,
 	       req->sq->qid);
 	req->error_loc = offsetof(struct nvme_common_command, opcode);
 	return NVME_SC_INVALID_OPCODE | NVME_SC_DNR;
-- 
2.30.2

