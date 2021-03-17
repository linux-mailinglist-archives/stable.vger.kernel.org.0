Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670D233E3AC
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhCQA5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230507AbhCQA4h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E545D64FB4;
        Wed, 17 Mar 2021 00:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942596;
        bh=xhC/zSUQmyO9R3baAqSyxeaznB54cFDqoTtNGKDXqSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tV2xk4VvVRvzytebUg6bpOejq1LqyelNLmBT4hkYRh/U6v0kLpqYTUjBFAEIHfTnv
         axca6JiYIJXed33Ojyuh1Z4GPE8ID6N1o2finYwxFo9PFhUP2Auk3hSMU84/5xdUXL
         E/FU8yS/5o3gntXihtiGPJYoQwGj+tA/j5fdrzxiX13cbojNr1bZca0KlX4wkQ2wEb
         QEWAbA+WnjODDEWXmjcSMGZ2vPiUA86e8pteqUCjFWTpZU3QKJ0zZLCHjvhF61HTKM
         CI4FFfI4CjJP+9XcNMaqBsfJ7h3WaqXEsAo4pXL57Te6Fnvj6/vIuwZ1GXmZh5w0u1
         DsicenORKtH3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 49/61] nvme: simplify error logic in nvme_validate_ns()
Date:   Tue, 16 Mar 2021 20:55:23 -0400
Message-Id: <20210317005536.724046-49-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
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
index 129e2b6bd6d3..1d6576b6bda3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1425,7 +1425,7 @@ static int nvme_identify_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 		goto out_free_id;
 	}
 
-	error = -ENODEV;
+	error = NVME_SC_INVALID_NS | NVME_SC_DNR;
 	if ((*id)->ncap == 0) /* namespace not allocated or attached */
 		goto out_free_id;
 
@@ -4023,7 +4023,7 @@ static void nvme_ns_remove_by_nsid(struct nvme_ctrl *ctrl, u32 nsid)
 static void nvme_validate_ns(struct nvme_ns *ns, struct nvme_ns_ids *ids)
 {
 	struct nvme_id_ns *id;
-	int ret = -ENODEV;
+	int ret = NVME_SC_INVALID_NS | NVME_SC_DNR;
 
 	if (test_bit(NVME_NS_DEAD, &ns->flags))
 		goto out;
@@ -4032,7 +4032,7 @@ static void nvme_validate_ns(struct nvme_ns *ns, struct nvme_ns_ids *ids)
 	if (ret)
 		goto out;
 
-	ret = -ENODEV;
+	ret = NVME_SC_INVALID_NS | NVME_SC_DNR;
 	if (!nvme_ns_ids_equal(&ns->head->ids, ids)) {
 		dev_err(ns->ctrl->device,
 			"identifiers changed for nsid %d\n", ns->head->ns_id);
@@ -4050,7 +4050,7 @@ static void nvme_validate_ns(struct nvme_ns *ns, struct nvme_ns_ids *ids)
 	 *
 	 * TODO: we should probably schedule a delayed retry here.
 	 */
-	if (ret && ret != -ENOMEM && !(ret > 0 && !(ret & NVME_SC_DNR)))
+	if (ret > 0 && (ret & NVME_SC_DNR))
 		nvme_ns_remove(ns);
 }
 
-- 
2.30.1

