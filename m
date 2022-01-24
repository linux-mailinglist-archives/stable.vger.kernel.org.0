Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC5A49951B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392214AbiAXUun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351749AbiAXUnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:43:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52073C019B20;
        Mon, 24 Jan 2022 11:53:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AF15B81218;
        Mon, 24 Jan 2022 19:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DF8C340E7;
        Mon, 24 Jan 2022 19:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053991;
        bh=EFTGqwFfNZIupBXAaiJo6wPohOcD99sfHVhnWJuEJKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C8aDu1tEDxxJMcqeVyOZraOMYzEriyZxNSqXjrZZqiDkM2h/GRrYhJ78C33ERK9ku
         SgW5NUkbCVV51aJk9VB2KxtjIIdDpcbFJ5XMDPgAwlcM/vtFHZjsWixDBrEKcrufWN
         Vx/dsobeI/m//NAHypWwodxw7b0DES6fvEmFodj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 242/563] RDMA/bnxt_re: Scan the whole bitmap when checking if "disabling RCFW with pending cmd-bit"
Date:   Mon, 24 Jan 2022 19:40:07 +0100
Message-Id: <20220124184032.798069203@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index 441eb421e5e59..5759027914b01 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -614,8 +614,6 @@ int bnxt_qplib_alloc_rcfw_channel(struct bnxt_qplib_res *res,
 	if (!cmdq->cmdq_bitmap)
 		goto fail;
 
-	cmdq->bmap_size = bmap_size;
-
 	/* Allocate one extra to hold the QP1 entries */
 	rcfw->qp_tbl_size = qp_tbl_sz + 1;
 	rcfw->qp_tbl = kcalloc(rcfw->qp_tbl_size, sizeof(struct bnxt_qplib_qp_node),
@@ -663,8 +661,8 @@ void bnxt_qplib_disable_rcfw_channel(struct bnxt_qplib_rcfw *rcfw)
 	iounmap(cmdq->cmdq_mbox.reg.bar_reg);
 	iounmap(creq->creq_db.reg.bar_reg);
 
-	indx = find_first_bit(cmdq->cmdq_bitmap, cmdq->bmap_size);
-	if (indx != cmdq->bmap_size)
+	indx = find_first_bit(cmdq->cmdq_bitmap, rcfw->cmdq_depth);
+	if (indx != rcfw->cmdq_depth)
 		dev_err(&rcfw->pdev->dev,
 			"disabling RCFW with pending cmd-bit %lx\n", indx);
 
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
index 5f2f0a5a3560f..6953f4e53dd20 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
@@ -150,7 +150,6 @@ struct bnxt_qplib_cmdq_ctx {
 	wait_queue_head_t		waitq;
 	unsigned long			flags;
 	unsigned long			*cmdq_bitmap;
-	u32				bmap_size;
 	u32				seq_num;
 };
 
-- 
2.34.1



