Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA7A610783A
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 20:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfKVTtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 14:49:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727416AbfKVTtf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 14:49:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3FC020865;
        Fri, 22 Nov 2019 19:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574452174;
        bh=QncCh4pQTgUhpPvU4k9NamkWDYyRUhFGs+V6hZtJi64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQUJpmtz3pFZeHwVXWexildxMLL+8C0wm0AQgNYx8v6uAouoF/7uM9EZmSQBLn1yf
         lqhcEoE/6gomG+QGZ584Bo420QyRfMjKsaVHcS751eqfuXGZbf9aVwLOuJm/CUmwtJ
         gdBX5qBHaomH95E8YUI/r5pF2PSFnxIZFTGl+Qd8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sirong Wang <wangsirong@huawei.com>,
        Weihang Li <liweihang@hisilicon.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 02/21] RDMA/hns: Correct the value of HNS_ROCE_HEM_CHUNK_LEN
Date:   Fri, 22 Nov 2019 14:49:12 -0500
Message-Id: <20191122194931.24732-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122194931.24732-1-sashal@kernel.org>
References: <20191122194931.24732-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 435748858252d..8e8917ebb013b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.h
@@ -52,7 +52,7 @@ enum {
 
 #define HNS_ROCE_HEM_CHUNK_LEN	\
 	 ((256 - sizeof(struct list_head) - 2 * sizeof(int)) /	 \
-	 (sizeof(struct scatterlist)))
+	 (sizeof(struct scatterlist) + sizeof(void *)))
 
 enum {
 	 HNS_ROCE_HEM_PAGE_SHIFT = 12,
-- 
2.20.1

