Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69E426B4DF
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgIOXdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727073AbgIOOgT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:36:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07A18222EB;
        Tue, 15 Sep 2020 14:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179979;
        bh=Jn0pTMAKZy7QzzRrn82TyCTaPgNl1eImcw+dOq/uEfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C2nywbAo/xfzO7toPGA5308K8qkLIpzRplyXqyxcj1tIwTJ2CTc0+unhcMKl4LRTM
         Uj17zcEIXlXjYhUCoF8CUQyphMSpYnqmlj01zDcGqfbQ7+CUdUTRipwJXP4n7PN11m
         +dRjHuJeOo2DfaBylh3NZJbdQkWmUcPzlnEdAHiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 021/177] RDMA/bnxt_re: Fix driver crash on unaligned PSN entry address
Date:   Tue, 15 Sep 2020 16:11:32 +0200
Message-Id: <20200915140654.664863630@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>

[ Upstream commit 934d0ac9a64d21523e3ad03ea4098da7826bc788 ]

When computing the first psn entry, driver checks for page alignment. If
this address is not page aligned,it attempts to compute the offset in that
page for later use by using ALIGN macro. ALIGN macro does not return
offset bytes but the requested aligned address and hence cannot be used
directly to store as offset.  Since driver was using the address itself
instead of offset, it resulted in invalid address when filling the psn
buffer.

Fixed driver to use PAGE_MASK macro to calculate the offset.

Fixes: fddcbbb02af4 ("RDMA/bnxt_re: Simplify obtaining queue entry from hw ring")
Link: https://lore.kernel.org/r/1598292876-26529-7-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index b217208f6bcce..4b53f79b91d1d 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -922,10 +922,10 @@ static void bnxt_qplib_init_psn_ptr(struct bnxt_qplib_qp *qp, int size)
 	sq = &qp->sq;
 	hwq = &sq->hwq;
 
+	/* First psn entry */
 	fpsne = (u64)bnxt_qplib_get_qe(hwq, hwq->max_elements, &psn_pg);
 	if (!IS_ALIGNED(fpsne, PAGE_SIZE))
-		indx_pad = ALIGN(fpsne, PAGE_SIZE) / size;
-
+		indx_pad = (fpsne & ~PAGE_MASK) / size;
 	page = (u64 *)psn_pg;
 	for (indx = 0; indx < hwq->max_elements; indx++) {
 		pg_num = (indx + indx_pad) / (PAGE_SIZE / size);
-- 
2.25.1



