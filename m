Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13889441891
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbhKAJtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:49:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234132AbhKAJrW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:47:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2CDB61414;
        Mon,  1 Nov 2021 09:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759057;
        bh=MMTpxLRdQDPhQaudS+jBgkPVpIkj+q8EDE6cq3+zlzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IEqsE8510oA8U7VOH55wO+w6aOe+5QQL+shMv3Tg6ZFpw+cpPaJFcy+/04B+GRzVL
         1Qe4dfL7lxzKy5PaXg4f2AN7Nn1PWVsENs2gOb29GTojIhtCHQ2hJNf2QP6fHdgUz+
         QbD1INryLpsdxZ1zMVT4qonuX/UWqwWbiZsZkfBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 096/125] RDMA/irdma: Process extended CQ entries correctly
Date:   Mon,  1 Nov 2021 10:17:49 +0100
Message-Id: <20211101082551.350731476@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

[ Upstream commit e93c7d8e8c4cf80c6afe56e71c83c1cd31b4fce1 ]

The valid bit for extended CQE's written by HW is retrieved from the
incorrect quad-word. This leads to missed completions for any UD traffic
particularly after a wrap-around.

Get the valid bit for extended CQE's from the correct quad-word in the
descriptor.

Fixes: 551c46edc769 ("RDMA/irdma: Add user/kernel shared libraries")
Link: https://lore.kernel.org/r/20211005182302.374-1-shiraz.saleem@intel.com
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/uk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/uk.c b/drivers/infiniband/hw/irdma/uk.c
index 5fb92de1f015..9b544a3b1288 100644
--- a/drivers/infiniband/hw/irdma/uk.c
+++ b/drivers/infiniband/hw/irdma/uk.c
@@ -1092,12 +1092,12 @@ irdma_uk_cq_poll_cmpl(struct irdma_cq_uk *cq, struct irdma_cq_poll_info *info)
 		if (cq->avoid_mem_cflct) {
 			ext_cqe = (__le64 *)((u8 *)cqe + 32);
 			get_64bit_val(ext_cqe, 24, &qword7);
-			polarity = (u8)FIELD_GET(IRDMA_CQ_VALID, qword3);
+			polarity = (u8)FIELD_GET(IRDMA_CQ_VALID, qword7);
 		} else {
 			peek_head = (cq->cq_ring.head + 1) % cq->cq_ring.size;
 			ext_cqe = cq->cq_base[peek_head].buf;
 			get_64bit_val(ext_cqe, 24, &qword7);
-			polarity = (u8)FIELD_GET(IRDMA_CQ_VALID, qword3);
+			polarity = (u8)FIELD_GET(IRDMA_CQ_VALID, qword7);
 			if (!peek_head)
 				polarity ^= 1;
 		}
-- 
2.33.0



