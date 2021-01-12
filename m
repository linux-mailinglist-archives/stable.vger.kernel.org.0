Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620902F3121
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbhALNQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:16:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390064AbhALM5b (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6E102313E;
        Tue, 12 Jan 2021 12:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456186;
        bh=6F7ZdDt4Gdnvj9HB0/c8v4mGbdGjGQCEU00+4wZsiBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ULvVA36tYqVFn36aykf8KsrthytzYGv2yJGbJ8u55R06T92yYq0b4qSDPteDHGw9V
         Bwd6ngccJtFnFLe7beHlhjqm91Q6hKJPVNUf6H3Uf41JjnrOpjStV5JpoM52JpLy1d
         iwRdm5ckQNgL51f6MLGZJfMQDHmftf8cdpFaZ/ScVQUOwDW6C3NRnEZv6b6prxC5kP
         +BcWB8+JfHT2i7yrzrVeE/NAmUukPwDn58fWJ6PiuPhV8C4IFfRIoTYAmPaeCPg6Gz
         C+5wUvmjIuLrNmiWVY4ugRhpdFFKvQ7iG9DxT7bGn7MzWEnMGij8tCGKfZ1C6KwoIV
         TlFghPJR7nhgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lalithambika Krishnakumar <lalithambika.krishnakumar@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 39/51] nvme: avoid possible double fetch in handling CQE
Date:   Tue, 12 Jan 2021 07:55:21 -0500
Message-Id: <20210112125534.70280-39-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

