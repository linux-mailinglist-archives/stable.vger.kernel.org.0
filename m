Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD6134C7FB
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbhC2IS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:18:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233010AbhC2ISW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:18:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DF816044F;
        Mon, 29 Mar 2021 08:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005901;
        bh=Vm04plOsjhlfLiwtFfQDIF+xCKzVZSCaeinJiKu6Zt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UYlkXq0Y+kbZ7pMrhIX50SXSn3IXqg5j2xCQxEzOjXaURdEL2EuLIAdZ00pHFf9pE
         RFlGZegIggETFqXe59PMtEDV3qw5z6levi5mRgMd9IssltYer4rVmlWj/BcygsWFhd
         bC1WzlW4Z3n9LR6qBFGl08Ush4khbWxuDtb6aHEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/221] nvme: simplify error logic in nvme_validate_ns()
Date:   Mon, 29 Mar 2021 09:56:16 +0200
Message-Id: <20210329075630.675406720@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index de846aaa8728..fbe2918ade78 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1371,7 +1371,7 @@ static int nvme_identify_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 		goto out_free_id;
 	}
 
-	error = -ENODEV;
+	error = NVME_SC_INVALID_NS | NVME_SC_DNR;
 	if ((*id)->ncap == 0) /* namespace not allocated or attached */
 		goto out_free_id;
 
@@ -3959,7 +3959,7 @@ static void nvme_ns_remove_by_nsid(struct nvme_ctrl *ctrl, u32 nsid)
 static void nvme_validate_ns(struct nvme_ns *ns, struct nvme_ns_ids *ids)
 {
 	struct nvme_id_ns *id;
-	int ret = -ENODEV;
+	int ret = NVME_SC_INVALID_NS | NVME_SC_DNR;
 
 	if (test_bit(NVME_NS_DEAD, &ns->flags))
 		goto out;
@@ -3968,7 +3968,7 @@ static void nvme_validate_ns(struct nvme_ns *ns, struct nvme_ns_ids *ids)
 	if (ret)
 		goto out;
 
-	ret = -ENODEV;
+	ret = NVME_SC_INVALID_NS | NVME_SC_DNR;
 	if (!nvme_ns_ids_equal(&ns->head->ids, ids)) {
 		dev_err(ns->ctrl->device,
 			"identifiers changed for nsid %d\n", ns->head->ns_id);
@@ -3986,7 +3986,7 @@ static void nvme_validate_ns(struct nvme_ns *ns, struct nvme_ns_ids *ids)
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



