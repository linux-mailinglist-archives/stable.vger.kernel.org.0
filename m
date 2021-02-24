Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FDE323CD2
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235441AbhBXM4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 07:56:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:50916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235324AbhBXMxh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:53:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B48D564EDD;
        Wed, 24 Feb 2021 12:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171086;
        bh=n2t/uc5ZxGBO0vRl39m8JivSlLwT/t9BtbiI+dqzzGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNfpHJmrvRnPTGnftJV+dPSCkfu0zdQnapL6zjhyerVgjpbs7p8VuNWOwxkZjNctX
         oPaXjNnufe/hmQlNYEblw8+yFOEl8QIYhnAYfvvrfASe9SmUHd59UIm65/DzJCwAn/
         XgJ0oirNdz2cIajXwWHST2shK/rv4+fJEfaMLL8FHtwJ3Zir3PFx/wvEMAuZ1tLzs/
         +KJafWij3WzrFEqTtU6W76fxa6iuyKSSeMpRBzxcz6N87O670icoIwgifZZXRG9WPD
         QCYXC41hkn1ED8Cz5kCHFH2If1EbGbTY4kSBBgM8eFDXbdGfEpqzOt7i7ux9I62pi3
         EGvXyVxUMBNCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Leng <lengchao@huawei.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 44/67] nvme-core: add cancel tagset helpers
Date:   Wed, 24 Feb 2021 07:50:02 -0500
Message-Id: <20210224125026.481804-44-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Leng <lengchao@huawei.com>

[ Upstream commit 2547906982e2e6a0d42f8957f55af5bb51a7e55f ]

Add nvme_cancel_tagset and nvme_cancel_admin_tagset for tear down and
reconnection error handling.

Signed-off-by: Chao Leng <lengchao@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 20 ++++++++++++++++++++
 drivers/nvme/host/nvme.h |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f13eb4ded95fa..129e2b6bd6d3f 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -371,6 +371,26 @@ bool nvme_cancel_request(struct request *req, void *data, bool reserved)
 }
 EXPORT_SYMBOL_GPL(nvme_cancel_request);
 
+void nvme_cancel_tagset(struct nvme_ctrl *ctrl)
+{
+	if (ctrl->tagset) {
+		blk_mq_tagset_busy_iter(ctrl->tagset,
+				nvme_cancel_request, ctrl);
+		blk_mq_tagset_wait_completed_request(ctrl->tagset);
+	}
+}
+EXPORT_SYMBOL_GPL(nvme_cancel_tagset);
+
+void nvme_cancel_admin_tagset(struct nvme_ctrl *ctrl)
+{
+	if (ctrl->admin_tagset) {
+		blk_mq_tagset_busy_iter(ctrl->admin_tagset,
+				nvme_cancel_request, ctrl);
+		blk_mq_tagset_wait_completed_request(ctrl->admin_tagset);
+	}
+}
+EXPORT_SYMBOL_GPL(nvme_cancel_admin_tagset);
+
 bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		enum nvme_ctrl_state new_state)
 {
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 88a6b97247f50..a72f071810910 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -576,6 +576,8 @@ static inline bool nvme_is_aen_req(u16 qid, __u16 command_id)
 
 void nvme_complete_rq(struct request *req);
 bool nvme_cancel_request(struct request *req, void *data, bool reserved);
+void nvme_cancel_tagset(struct nvme_ctrl *ctrl);
+void nvme_cancel_admin_tagset(struct nvme_ctrl *ctrl);
 bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		enum nvme_ctrl_state new_state);
 bool nvme_wait_reset(struct nvme_ctrl *ctrl);
-- 
2.27.0

