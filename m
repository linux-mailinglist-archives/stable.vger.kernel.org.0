Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0385013FFFA
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388364AbgAPXqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:46:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:48742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390830AbgAPXV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:21:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABFA7206D9;
        Thu, 16 Jan 2020 23:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216889;
        bh=KDv9/903esDZ2Zd4v1or1l8x4BzyIxvvyXJ7g4xgGB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vUCXoGEqzhx39krgEgOoQ5YVuTaGEyit5UhJsazSKw7Enmgyy3n2Sq1HNuRPKxsbm
         i3s/2R1laMV3V6DrABJDku5LGm2ber6upQb0551nhF83qOLKHTyhDQjHNK24wxS444
         ly9YPApgDGYF9k/LbvtwhpP/Wfmlv+UOxikuKHDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 061/203] RDMA/hns: Prevent undefined behavior in hns_roce_set_user_sq_size()
Date:   Fri, 17 Jan 2020 00:16:18 +0100
Message-Id: <20200116231749.365403904@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit 515f60004ed985d2b2f03659365752e0b6142986 upstream.

The "ucmd->log_sq_bb_count" variable is a user controlled variable in the
0-255 range.  If we shift more than then number of bits in an int then
it's undefined behavior (it shift wraps), and potentially the int could
become negative.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Link: https://lore.kernel.org/r/20190608092514.GC28890@mwanda
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hns/hns_roce_qp.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -332,9 +332,8 @@ static int check_sq_size_with_integrity(
 	u8 max_sq_stride = ilog2(roundup_sq_stride);
 
 	/* Sanity check SQ size before proceeding */
-	if ((u32)(1 << ucmd->log_sq_bb_count) > hr_dev->caps.max_wqes ||
-	     ucmd->log_sq_stride > max_sq_stride ||
-	     ucmd->log_sq_stride < HNS_ROCE_IB_MIN_SQ_STRIDE) {
+	if (ucmd->log_sq_stride > max_sq_stride ||
+	    ucmd->log_sq_stride < HNS_ROCE_IB_MIN_SQ_STRIDE) {
 		ibdev_err(&hr_dev->ib_dev, "check SQ size error!\n");
 		return -EINVAL;
 	}
@@ -358,13 +357,16 @@ static int hns_roce_set_user_sq_size(str
 	u32 max_cnt;
 	int ret;
 
+	if (check_shl_overflow(1, ucmd->log_sq_bb_count, &hr_qp->sq.wqe_cnt) ||
+	    hr_qp->sq.wqe_cnt > hr_dev->caps.max_wqes)
+		return -EINVAL;
+
 	ret = check_sq_size_with_integrity(hr_dev, cap, ucmd);
 	if (ret) {
 		ibdev_err(&hr_dev->ib_dev, "Sanity check sq size failed\n");
 		return ret;
 	}
 
-	hr_qp->sq.wqe_cnt = 1 << ucmd->log_sq_bb_count;
 	hr_qp->sq.wqe_shift = ucmd->log_sq_stride;
 
 	max_cnt = max(1U, cap->max_send_sge);


