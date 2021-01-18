Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21842FA307
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392942AbhARO3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:29:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:39666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389680AbhARLoq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:44:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5454B221EC;
        Mon, 18 Jan 2021 11:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970217;
        bh=6F7ZdDt4Gdnvj9HB0/c8v4mGbdGjGQCEU00+4wZsiBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yK/lO+tMo+fgebEdgH7wsrU3do5oIM6bNOVNiqyiXRrqMQ7/Ah0mK9WA+gBzLRkrm
         fMMOdcVO2UGQmktmwnsWZTQybb3iGaaAYiIAJzp67t2bAGUZQkxcGv5EKAPjo9o8li
         k43Yc9zq90RHeUZcD9KQboQsXVxFCyu77s+b9MEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lalithambika Krishna Kumar 
        <lalithambika.krishnakumar@intel.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/152] nvme: avoid possible double fetch in handling CQE
Date:   Mon, 18 Jan 2021 12:34:21 +0100
Message-Id: <20210118113356.883655171@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lalithambika Krishnakumar <lalithambika.krishnakumar@intel.com>

[ Upstream commit 62df80165d7f197c9c0652e7416164f294a96661 ]

While handling the completion queue, keep a local copy of the command id
from the DMA-accessible completion entry. This silences a time-of-check
to time-of-use (TOCTOU) warning from KF/x[1], with respect to a
Thunderclap[2] vulnerability analysis. The double-read impact appears
benign.

There may be a theoretical window for @command_id to be used as an
adversary-controlled array-index-value for mounting a speculative
execution attack, but that mitigation is saved for a potential follow-on.
A man-in-the-middle attack on the data payload is out of scope for this
analysis and is hopefully mitigated by filesystem integrity mechanisms.

[1] https://github.com/intel/kernel-fuzzer-for-xen-project
[2] http://thunderclap.io/thunderclap-paper-ndss2019.pdf
Signed-off-by: Lalithambika Krishna Kumar <lalithambika.krishnakumar@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 143f16a9f8d7e..a89d74c5cd1a7 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -967,6 +967,7 @@ static inline struct blk_mq_tags *nvme_queue_tagset(struct nvme_queue *nvmeq)
 static inline void nvme_handle_cqe(struct nvme_queue *nvmeq, u16 idx)
 {
 	struct nvme_completion *cqe = &nvmeq->cqes[idx];
+	__u16 command_id = READ_ONCE(cqe->command_id);
 	struct request *req;
 
 	/*
@@ -975,17 +976,17 @@ static inline void nvme_handle_cqe(struct nvme_queue *nvmeq, u16 idx)
 	 * aborts.  We don't even bother to allocate a struct request
 	 * for them but rather special case them here.
 	 */
-	if (unlikely(nvme_is_aen_req(nvmeq->qid, cqe->command_id))) {
+	if (unlikely(nvme_is_aen_req(nvmeq->qid, command_id))) {
 		nvme_complete_async_event(&nvmeq->dev->ctrl,
 				cqe->status, &cqe->result);
 		return;
 	}
 
-	req = blk_mq_tag_to_rq(nvme_queue_tagset(nvmeq), cqe->command_id);
+	req = blk_mq_tag_to_rq(nvme_queue_tagset(nvmeq), command_id);
 	if (unlikely(!req)) {
 		dev_warn(nvmeq->dev->ctrl.device,
 			"invalid id %d completed on queue %d\n",
-			cqe->command_id, le16_to_cpu(cqe->sq_id));
+			command_id, le16_to_cpu(cqe->sq_id));
 		return;
 	}
 
-- 
2.27.0



