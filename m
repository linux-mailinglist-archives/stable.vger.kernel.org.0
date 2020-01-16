Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7160313E583
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391071AbgAPROm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:14:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391065AbgAPROl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:14:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 802A5246AC;
        Thu, 16 Jan 2020 17:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194880;
        bh=neRMrMZOSpRAzPxFlLtbh0wI0c2ycl3m/dsT9nRIn9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhZObM5vuV337AmsGa30ZeZc4LnYLTQGVxth5AlnydRajIuq6EXrYhv5JM5+Whe4y
         gMaUaM3Fros7vZ0WzojLyvZGF3SUbGtQMOlpw03kPJCWFzcFJ6N9dyYb25SqMjntPE
         pk0HMHfuV4JZHbnzlT4urOiy8FgAIG5dfY19rl48=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Gurtovoy <maxg@mellanox.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Israel Rukshin <israelr@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 669/671] IB/iser: Fix dma_nents type definition
Date:   Thu, 16 Jan 2020 12:05:07 -0500
Message-Id: <20200116170509.12787-406-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Gurtovoy <maxg@mellanox.com>

[ Upstream commit c1545f1a200f4adc4ef8dd534bf33e2f1aa22c2f ]

The retured value from ib_dma_map_sg saved in dma_nents variable. To avoid
future mismatch between types, define dma_nents as an integer instead of
unsigned.

Fixes: 57b26497fabe ("IB/iser: Pass the correct number of entries for dma mapped SGL")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Israel Rukshin <israelr@mellanox.com>
Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Acked-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 120b40829560..a7aeaa0c6fbc 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -197,7 +197,7 @@ struct iser_data_buf {
 	struct scatterlist *sg;
 	int                size;
 	unsigned long      data_len;
-	unsigned int       dma_nents;
+	int                dma_nents;
 };
 
 /* fwd declarations */
-- 
2.20.1

