Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7D233E43A
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhCQA6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231775AbhCQA5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB09E64FBD;
        Wed, 17 Mar 2021 00:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942666;
        bh=lRsNRWuLe5ce9HeO785r5xc3kAoean3MF0vE6dTmYhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFZBZbkD5kij5wtPF5QRH4rK8UTZmIfaX4c7rNbnERM7n3mPUs1B7XZAxj6E9QHpS
         RRjerOSEuRXo+qtk6F2Bxw8CNfBiVSo8HV62q2J+b6AWPoc//EfyO7Q+DqVjHXO60S
         66I1MnWzwjYlg+AxTSftU7Qknnmhj8r7psrhTmW+RqS3ZINrZLaE4QOenXWFcd2wrR
         CsQpm4K4SUOCtkFkxlDtlLzCz9OP/8FGI+RxGLfCnMscEeD3E21f0mXhVmDr/rbSN3
         LVQMLZqTO11+6OBcFE2V3V9/mhLpbNWSq5dgfxRtgshezKeVPf0P+dvwe+78fw7eZg
         /ogLT+8IDn2cw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 43/54] nvme: simplify error logic in nvme_validate_ns()
Date:   Tue, 16 Mar 2021 20:56:42 -0400
Message-Id: <20210317005654.724862-43-sashal@kernel.org>
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

[ Upstream commit d95c1f4179a7f3ea8aa728ed00252a8ed0f8158f ]

We only should remove namespaces when we get fatal error back from
the device or when the namespace IDs have changed.
So instead of painfully masking out error numbers which might indicate
that the error should be ignored we could use an NVME status code
to indicated when the namespace should be removed.
That simplifies the final logic and makes it less error-prone.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e1e574ecf031..990e1adafaad 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1371,7 +1371,7 @@ static int nvme_identify_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 		goto out_free_id;
 	}
 
-	error = -ENODEV;
+	error = NVME_SC_INVALID_NS | NVME_SC_DNR;
 	if ((*id)->ncap == 0) /* namespace not allocated or attached */
 		goto out_free_id;
 
@@ -3971,7 +3971,7 @@ static void nvme_ns_remove_by_nsid(struct nvme_ctrl *ctrl, u32 nsid)
 static void nvme_validate_ns(struct nvme_ns *ns, struct nvme_ns_ids *ids)
 {
 	struct nvme_id_ns *id;
-	int ret = -ENODEV;
+	int ret = NVME_SC_INVALID_NS | NVME_SC_DNR;
 
 	if (test_bit(NVME_NS_DEAD, &ns->flags))
 		goto out;
@@ -3980,7 +3980,7 @@ static void nvme_validate_ns(struct nvme_ns *ns, struct nvme_ns_ids *ids)
 	if (ret)
 		goto out;
 
-	ret = -ENODEV;
+	ret = NVME_SC_INVALID_NS | NVME_SC_DNR;
 	if (!nvme_ns_ids_equal(&ns->head->ids, ids)) {
 		dev_err(ns->ctrl->device,
 			"identifiers changed for nsid %d\n", ns->head->ns_id);
@@ -3998,7 +3998,7 @@ static void nvme_validate_ns(struct nvme_ns *ns, struct nvme_ns_ids *ids)
 	 *
 	 * TODO: we should probably schedule a delayed retry here.
 	 */
-	if (ret && ret != -ENOMEM && !(ret > 0 && !(ret & NVME_SC_DNR)))
+	if (ret > 0 && (ret & NVME_SC_DNR))
 		nvme_ns_remove(ns);
 	else
 		revalidate_disk_size(ns->disk, true);
-- 
2.30.1

