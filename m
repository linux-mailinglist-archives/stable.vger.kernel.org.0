Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5584345C068
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245027AbhKXNHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:07:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347436AbhKXNFq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:05:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D8C661A6F;
        Wed, 24 Nov 2021 12:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757472;
        bh=y1ZxORNCrSNr8XyUdfGNHp+N831CPO33juciaNuhogA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D4NqAYWMacLG6NEe4arburW/cbnoNtIiffys8ALnhNbYFGJbVw1IrtLkamVNy/BU8
         b8jdcAuSHevUei1sImI2NAdvcKv6ASsllW59GidpyQ+RRwf4N9ufCCdBMjMzin80zF
         DyjLNU9AB30VoLvXdHYKgjtOLugSbwS9u7kRcGg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 179/323] RDMA/bnxt_re: Fix query SRQ failure
Date:   Wed, 24 Nov 2021 12:56:09 +0100
Message-Id: <20211124115724.992235526@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 598d16fa1bf93431ad35bbab3ed1affe4fb7b562 ]

Fill the missing parameters for the FW command while querying SRQ.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Link: https://lore.kernel.org/r/1631709163-2287-8-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 60f2fb7e7dbfe..d52ae7259e62d 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -637,12 +637,13 @@ int bnxt_qplib_query_srq(struct bnxt_qplib_res *res,
 	int rc = 0;
 
 	RCFW_CMD_PREP(req, QUERY_SRQ, cmd_flags);
-	req.srq_cid = cpu_to_le32(srq->id);
 
 	/* Configure the request */
 	sbuf = bnxt_qplib_rcfw_alloc_sbuf(rcfw, sizeof(*sb));
 	if (!sbuf)
 		return -ENOMEM;
+	req.resp_size = sizeof(*sb) / BNXT_QPLIB_CMDQE_UNITS;
+	req.srq_cid = cpu_to_le32(srq->id);
 	sb = sbuf->sb;
 	rc = bnxt_qplib_rcfw_send_message(rcfw, (void *)&req, (void *)&resp,
 					  (void *)sbuf, 0);
-- 
2.33.0



