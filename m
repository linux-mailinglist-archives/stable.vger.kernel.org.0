Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCEC323D9F
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236164AbhBXNN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:13:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234019AbhBXNGT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:06:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E92CF64F83;
        Wed, 24 Feb 2021 12:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171255;
        bh=bOO24WsPorACp8BnYIE4btxNZGRSmuSQ4QeDoezNLg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSb3CfAFiOpg76hb12RO+GWmVoBrl2g1K4QSqHZvmi14UDOGBYc4HkWls0OzmSO5K
         3KKCaklXaUwG0c02KNqFXMBOnGNTWhc8jY3ho8/xUuSsfiHkjrP0MrduU+Jibl5NQE
         og7Ux42QpVPkW0v1rMyZt3tUQ1Cui9el9bOgBL4jukvRDdHQgSURLMPKZCAmp4kaiJ
         fLZ6A3TKZLFALoujZdwPARvOUIdDSUMUxefWhnNdven8AVZ2qKLrzLvvJLP043lcom
         3OTH7mwQFFxXsfrlk8p5DX0eaUqTl/lhDmng5gxLiUmX5OmyI0ec17lzOiiEboItdR
         7ZfLe6saE4pgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Leng <lengchao@huawei.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 26/40] nvme-core: add cancel tagset helpers
Date:   Wed, 24 Feb 2021 07:53:26 -0500
Message-Id: <20210224125340.483162-26-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125340.483162-1-sashal@kernel.org>
References: <20210224125340.483162-1-sashal@kernel.org>
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
index c2cabd77884bf..95d77a17375e1 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -317,6 +317,26 @@ bool nvme_cancel_request(struct request *req, void *data, bool reserved)
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
index e392d6cd92ced..62e5401865fee 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -468,6 +468,8 @@ static inline void nvme_put_ctrl(struct nvme_ctrl *ctrl)
 
 void nvme_complete_rq(struct request *req);
 bool nvme_cancel_request(struct request *req, void *data, bool reserved);
+void nvme_cancel_tagset(struct nvme_ctrl *ctrl);
+void nvme_cancel_admin_tagset(struct nvme_ctrl *ctrl);
 bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		enum nvme_ctrl_state new_state);
 bool nvme_wait_reset(struct nvme_ctrl *ctrl);
-- 
2.27.0

