Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13438452617
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359858AbhKPCBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:01:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:48394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240134AbhKOSFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8829632F5;
        Mon, 15 Nov 2021 17:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998165;
        bh=EYQqwvIU2Jf5xonjsiX1RsACkhcB4QJwMFfsRuPF8uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbClbXkD7cadu6lDZcSYKURW3NLmoqLmnP4Lv2GTU2W9ckLrv2GcbK1HeDKPDnBN3
         fKXcDly9aByJakONfVnlHQHiAsi2nVY5CXFo9ePjhHpQgDM0IlYWnxpM7bLDZmDgfj
         LtTPy0ELWYn8ucikG51Y+/6XDD0fqpqwaPnuXY8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 394/575] RDMA/bnxt_re: Fix query SRQ failure
Date:   Mon, 15 Nov 2021 18:01:59 +0100
Message-Id: <20211115165357.395187479@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index d4d4959c2434c..bd153aa7e9ab3 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -707,12 +707,13 @@ int bnxt_qplib_query_srq(struct bnxt_qplib_res *res,
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



