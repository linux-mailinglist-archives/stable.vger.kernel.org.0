Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A5A111D12
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbfLCWuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:50:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729684AbfLCWuB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:50:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEB2C2084B;
        Tue,  3 Dec 2019 22:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413400;
        bh=O/VI7sXUGSsNwzPIEjdS0sm34QNGBeHgpdnhGgXZJwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wlDqx/68gwYpvj4+WkX1Caa9dYyR7uSFeP02FkkZubdt1pGqi6tc3ZtG8Ek1LfjVk
         wwXSwwv8GhjQpmRda7A6+fV4rtE2V+guQk+1oxla+LFWy4NsLT4J7SbrXKcJvulgae
         7rkDsRVCuuXXGNujJfIwk1I3LVjovmD1fpT3y8SE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <keith.busch@intel.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/321] nvme: provide fallback for discard alloc failure
Date:   Tue,  3 Dec 2019 23:32:32 +0100
Message-Id: <20191203223431.629531090@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit cb5b7262b011cfb793519bf97e54dff5282da23c ]

When boxes are run near (or to) OOM, we have a problem with the discard
page allocation in nvme. If we fail allocating the special page, we
return busy, and it'll get retried. But since ordering is honored for
dispatch requests, we can keep retrying this same IO and failing. Behind
that IO could be requests that want to free memory, but they never get
the chance.

Allocate a fixed discard page per controller for a safe fallback, and use
that if the initial allocation fails.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Keith Busch <keith.busch@intel.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 41 ++++++++++++++++++++++++++++++++++------
 drivers/nvme/host/nvme.h |  3 +++
 2 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 44da9fe5b27b8..250ccf3108e98 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -551,9 +551,19 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 	struct nvme_dsm_range *range;
 	struct bio *bio;
 
-	range = kmalloc_array(segments, sizeof(*range), GFP_ATOMIC);
-	if (!range)
-		return BLK_STS_RESOURCE;
+	range = kmalloc_array(segments, sizeof(*range),
+				GFP_ATOMIC | __GFP_NOWARN);
+	if (!range) {
+		/*
+		 * If we fail allocation our range, fallback to the controller
+		 * discard page. If that's also busy, it's safe to return
+		 * busy, as we know we can make progress once that's freed.
+		 */
+		if (test_and_set_bit_lock(0, &ns->ctrl->discard_page_busy))
+			return BLK_STS_RESOURCE;
+
+		range = page_address(ns->ctrl->discard_page);
+	}
 
 	__rq_for_each_bio(bio, req) {
 		u64 slba = nvme_block_nr(ns, bio->bi_iter.bi_sector);
@@ -568,7 +578,10 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 	}
 
 	if (WARN_ON_ONCE(n != segments)) {
-		kfree(range);
+		if (virt_to_page(range) == ns->ctrl->discard_page)
+			clear_bit_unlock(0, &ns->ctrl->discard_page_busy);
+		else
+			kfree(range);
 		return BLK_STS_IOERR;
 	}
 
@@ -653,8 +666,13 @@ void nvme_cleanup_cmd(struct request *req)
 				blk_rq_bytes(req) >> ns->lba_shift);
 	}
 	if (req->rq_flags & RQF_SPECIAL_PAYLOAD) {
-		kfree(page_address(req->special_vec.bv_page) +
-		      req->special_vec.bv_offset);
+		struct nvme_ns *ns = req->rq_disk->private_data;
+		struct page *page = req->special_vec.bv_page;
+
+		if (page == ns->ctrl->discard_page)
+			clear_bit_unlock(0, &ns->ctrl->discard_page_busy);
+		else
+			kfree(page_address(page) + req->special_vec.bv_offset);
 	}
 }
 EXPORT_SYMBOL_GPL(nvme_cleanup_cmd);
@@ -3551,6 +3569,7 @@ static void nvme_free_ctrl(struct device *dev)
 	ida_simple_remove(&nvme_instance_ida, ctrl->instance);
 	kfree(ctrl->effects);
 	nvme_mpath_uninit(ctrl);
+	kfree(ctrl->discard_page);
 
 	if (subsys) {
 		mutex_lock(&subsys->lock);
@@ -3592,6 +3611,14 @@ int nvme_init_ctrl(struct nvme_ctrl *ctrl, struct device *dev,
 	memset(&ctrl->ka_cmd, 0, sizeof(ctrl->ka_cmd));
 	ctrl->ka_cmd.common.opcode = nvme_admin_keep_alive;
 
+	BUILD_BUG_ON(NVME_DSM_MAX_RANGES * sizeof(struct nvme_dsm_range) >
+			PAGE_SIZE);
+	ctrl->discard_page = alloc_page(GFP_KERNEL);
+	if (!ctrl->discard_page) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	ret = ida_simple_get(&nvme_instance_ida, 0, 0, GFP_KERNEL);
 	if (ret < 0)
 		goto out;
@@ -3629,6 +3656,8 @@ out_free_name:
 out_release_instance:
 	ida_simple_remove(&nvme_instance_ida, ctrl->instance);
 out:
+	if (ctrl->discard_page)
+		__free_page(ctrl->discard_page);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nvme_init_ctrl);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 2653e1f4196d5..cc4273f119894 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -238,6 +238,9 @@ struct nvme_ctrl {
 	u16 maxcmd;
 	int nr_reconnects;
 	struct nvmf_ctrl_options *opts;
+
+	struct page *discard_page;
+	unsigned long discard_page_busy;
 };
 
 struct nvme_subsystem {
-- 
2.20.1



