Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440A549A2B9
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365956AbiAXXwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843480AbiAXXED (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:04:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2AFC06C5B0;
        Mon, 24 Jan 2022 13:15:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AFDD61484;
        Mon, 24 Jan 2022 21:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5018DC340E4;
        Mon, 24 Jan 2022 21:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058929;
        bh=yetuTulqugrN0YKtx8LCtsv1oE7YkFAYIodyAMLxwTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCR8AzOZoKqHAsJsZClvPablykaoFU2mowffV1f/up3kMrhKnoq28jSoqPEUvMQV2
         PaXT6xl0de0iZAxu0LU3OJUaFYgIvv+cE1AuUdd9spCTu/r7W7rwfHStOxoVik+cQ/
         tP4vCIGqZluXRPr2hLqMf1HgohrE45ynezyrvg8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0449/1039] RDMA/bnxt_re: Scan the whole bitmap when checking if "disabling RCFW with pending cmd-bit"
Date:   Mon, 24 Jan 2022 19:37:18 +0100
Message-Id: <20220124184140.389611874@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a917dfb66c0a1fa1caacf3d71edcafcab48e6ff0 ]

The 'cmdq->cmdq_bitmap' bitmap is 'rcfw->cmdq_depth' bits long.  The size
stored in 'cmdq->bmap_size' is the size of the bitmap in bytes.

Remove this erroneous 'bmap_size' and use 'rcfw->cmdq_depth' directly in
'bnxt_qplib_disable_rcfw_channel()'. Otherwise some error messages may be
missing.

Other uses of 'cmdq_bitmap' already take into account 'rcfw->cmdq_depth'
directly.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Link: https://lore.kernel.org/r/47ed717c3070a1d0f53e7b4c768a4fd11caf365d.1636707421.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 6 ++----
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h | 1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 3de854727460e..19a0778d38a2d 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -618,8 +618,6 @@ int bnxt_qplib_alloc_rcfw_channel(struct bnxt_qplib_res *res,
 	if (!cmdq->cmdq_bitmap)
 		goto fail;
 
-	cmdq->bmap_size = bmap_size;
-
 	/* Allocate one extra to hold the QP1 entries */
 	rcfw->qp_tbl_size = qp_tbl_sz + 1;
 	rcfw->qp_tbl = kcalloc(rcfw->qp_tbl_size, sizeof(struct bnxt_qplib_qp_node),
@@ -667,8 +665,8 @@ void bnxt_qplib_disable_rcfw_channel(struct bnxt_qplib_rcfw *rcfw)
 	iounmap(cmdq->cmdq_mbox.reg.bar_reg);
 	iounmap(creq->creq_db.reg.bar_reg);
 
-	indx = find_first_bit(cmdq->cmdq_bitmap, cmdq->bmap_size);
-	if (indx != cmdq->bmap_size)
+	indx = find_first_bit(cmdq->cmdq_bitmap, rcfw->cmdq_depth);
+	if (indx != rcfw->cmdq_depth)
 		dev_err(&rcfw->pdev->dev,
 			"disabling RCFW with pending cmd-bit %lx\n", indx);
 
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
index 82faa4e4cda84..0a3d8e7da3d42 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
@@ -152,7 +152,6 @@ struct bnxt_qplib_cmdq_ctx {
 	wait_queue_head_t		waitq;
 	unsigned long			flags;
 	unsigned long			*cmdq_bitmap;
-	u32				bmap_size;
 	u32				seq_num;
 };
 
-- 
2.34.1



