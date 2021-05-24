Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941DB38EF21
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235241AbhEXP4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234418AbhEXPwQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:52:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B0D2613F3;
        Mon, 24 May 2021 15:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870740;
        bh=LEkjlQhBJKYdOwVtxAHgm3u6ALPjzQ7XpA6VTqnK/iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8Yjm9HlkNr2DXMNpJpjxsLZ3FLB+vzzPJfnTjWovORK2xy0Q9owSzQDlWJ5pTZuq
         ZYjjAOAOf79SdConXuB8DB1aH4sOXZUBngeNOoc8qQQE/chScMcjatZNMM8jKP2wnK
         gWSY4fHpfvj4RZ/UAdsFFqCUc1KU1YZZZURPb5eA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit <amit.engel@dell.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/104] nvmet: remove unused ctrl->cqs
Date:   Mon, 24 May 2021 17:25:08 +0200
Message-Id: <20210524152333.269792078@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit <amit.engel@dell.com>

[ Upstream commit 6d65aeab7bf6e83e75f53cfdbdb84603e52e1182 ]

remove unused cqs from nvmet_ctrl struct
this will reduce the allocated memory.

Signed-off-by: Amit <amit.engel@dell.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c  | 15 ++-------------
 drivers/nvme/target/nvmet.h |  1 -
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 1e79d33c1df7..870d06cfd815 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -757,8 +757,6 @@ void nvmet_cq_setup(struct nvmet_ctrl *ctrl, struct nvmet_cq *cq,
 {
 	cq->qid = qid;
 	cq->size = size;
-
-	ctrl->cqs[qid] = cq;
 }
 
 void nvmet_sq_setup(struct nvmet_ctrl *ctrl, struct nvmet_sq *sq,
@@ -1355,20 +1353,14 @@ u16 nvmet_alloc_ctrl(const char *subsysnqn, const char *hostnqn,
 	if (!ctrl->changed_ns_list)
 		goto out_free_ctrl;
 
-	ctrl->cqs = kcalloc(subsys->max_qid + 1,
-			sizeof(struct nvmet_cq *),
-			GFP_KERNEL);
-	if (!ctrl->cqs)
-		goto out_free_changed_ns_list;
-
 	ctrl->sqs = kcalloc(subsys->max_qid + 1,
 			sizeof(struct nvmet_sq *),
 			GFP_KERNEL);
 	if (!ctrl->sqs)
-		goto out_free_cqs;
+		goto out_free_changed_ns_list;
 
 	if (subsys->cntlid_min > subsys->cntlid_max)
-		goto out_free_cqs;
+		goto out_free_changed_ns_list;
 
 	ret = ida_simple_get(&cntlid_ida,
 			     subsys->cntlid_min, subsys->cntlid_max,
@@ -1406,8 +1398,6 @@ u16 nvmet_alloc_ctrl(const char *subsysnqn, const char *hostnqn,
 
 out_free_sqs:
 	kfree(ctrl->sqs);
-out_free_cqs:
-	kfree(ctrl->cqs);
 out_free_changed_ns_list:
 	kfree(ctrl->changed_ns_list);
 out_free_ctrl:
@@ -1437,7 +1427,6 @@ static void nvmet_ctrl_free(struct kref *ref)
 
 	nvmet_async_events_free(ctrl);
 	kfree(ctrl->sqs);
-	kfree(ctrl->cqs);
 	kfree(ctrl->changed_ns_list);
 	kfree(ctrl);
 
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index bc91336080e0..ea96487b5424 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -164,7 +164,6 @@ static inline struct nvmet_port *ana_groups_to_port(
 
 struct nvmet_ctrl {
 	struct nvmet_subsys	*subsys;
-	struct nvmet_cq		**cqs;
 	struct nvmet_sq		**sqs;
 
 	bool			cmd_seen;
-- 
2.30.2



