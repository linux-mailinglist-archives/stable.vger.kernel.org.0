Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 611BEF7E63
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbfKKSpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:45:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729898AbfKKSpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:45:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A070B20674;
        Mon, 11 Nov 2019 18:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497940;
        bh=IQsZLuuqWUQYHXB821Rg58ODiZKecBYe5xc4iJpdbjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d/lAl1r790Ezsp17+oT+Soqi1L/fDQzqefmkX4OsYY62pPGec+7HHP27BL1fxMJ8O
         m2WL63zOFeKst4VJsq2l0uVHsecLBdiHbYLSu6rALRz0f2qgINFcqsBVYtIUBS13UQ
         t2GJZNPs1XUn7cL0xONuYzmPKc1JXiQs13S5J2sc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Ou <oulijun@huawei.com>,
        Weihang Li <liweihang@hisilicon.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 102/125] RDMA/hns: Prevent memory leaks of eq->buf_list
Date:   Mon, 11 Nov 2019 19:29:01 +0100
Message-Id: <20191111181453.499759919@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

[ Upstream commit b681a0529968d2261aa15d7a1e78801b2c06bb07 ]

eq->buf_list->buf and eq->buf_list should also be freed when eqe_hop_num
is set to 0, or there will be memory leaks.

Fixes: a5073d6054f7 ("RDMA/hns: Add eq support of hip08")
Link: https://lore.kernel.org/r/1572072995-11277-3-git-send-email-liweihang@hisilicon.com
Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index a442b29e76119..cf878e1b71fc1 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4572,9 +4572,9 @@ static void hns_roce_v2_free_eq(struct hns_roce_dev *hr_dev,
 		return;
 	}
 
-	if (eq->buf_list)
-		dma_free_coherent(hr_dev->dev, buf_chk_sz,
-				  eq->buf_list->buf, eq->buf_list->map);
+	dma_free_coherent(hr_dev->dev, buf_chk_sz, eq->buf_list->buf,
+			  eq->buf_list->map);
+	kfree(eq->buf_list);
 }
 
 static void hns_roce_config_eqc(struct hns_roce_dev *hr_dev,
-- 
2.20.1



