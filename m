Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCCD11B5A4
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731541AbfLKPQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:16:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731642AbfLKPQF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:16:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF77A24654;
        Wed, 11 Dec 2019 15:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077365;
        bh=wy3YIPHob0rwT7NgwqV/wiFK4T5Z5pn4dDmhgqJTP9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4h7PuR/S/13hpMmpRZz0Cex/aSBG1c95vAjK+irYQvwV27vCAWz9Jbn2h3NBeFgM
         HVAjks5T6wQvTwpl9Jd6tpB6lT7T7+qt/BTAlpZhClQoVA7Ss7bmGFOp/gZTa0+BB3
         qjKVMUyv3QwjapINZHXBbzzoZvTpSrD/w773MWEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sirong Wang <wangsirong@huawei.com>,
        Weihang Li <liweihang@hisilicon.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 012/243] RDMA/hns: Correct the value of HNS_ROCE_HEM_CHUNK_LEN
Date:   Wed, 11 Dec 2019 16:02:54 +0100
Message-Id: <20191211150339.921079116@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sirong Wang <wangsirong@huawei.com>

[ Upstream commit 531eb45b3da4267fc2a64233ba256c8ffb02edd2 ]

Size of pointer to buf field of struct hns_roce_hem_chunk should be
considered when calculating HNS_ROCE_HEM_CHUNK_LEN, or sg table size will
be larger than expected when allocating hem.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Link: https://lore.kernel.org/r/1572575610-52530-2-git-send-email-liweihang@hisilicon.com
Signed-off-by: Sirong Wang <wangsirong@huawei.com>
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.h b/drivers/infiniband/hw/hns/hns_roce_hem.h
index e8850d59e7804..a94444db3045a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.h
@@ -54,7 +54,7 @@ enum {
 
 #define HNS_ROCE_HEM_CHUNK_LEN	\
 	 ((256 - sizeof(struct list_head) - 2 * sizeof(int)) /	 \
-	 (sizeof(struct scatterlist)))
+	 (sizeof(struct scatterlist) + sizeof(void *)))
 
 #define check_whether_bt_num_3(type, hop_num) \
 	(type < HEM_TYPE_MTT && hop_num == 2)
-- 
2.20.1



