Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77C2DDD4D8
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbfJRWDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:03:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727437AbfJRWDx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:03:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0DC2222CD;
        Fri, 18 Oct 2019 22:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436232;
        bh=1xRSt9tzsNlcbb8tmgkgfUxNyMUer98VWV4fSpMoq4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sy6UJfn/VCyLk5upMuD1Sah7eJp8/+P6PrrrKeLUC26mYFGrXCwg/cHPRcIvlPSWv
         kQBcQxR8R6EwuMfwnI5ESiPhjflg09ps9A21ZZjebjG73GD4iD6bDqaFWCxsRwkBtK
         B8SfRlNKLmwfGNgBgvc8nbtZIMbIpQaJ7YoG0wY4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 18/89] RDMA/hfi1: Prevent memory leak in sdma_init
Date:   Fri, 18 Oct 2019 18:02:13 -0400
Message-Id: <20191018220324.8165-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 34b3be18a04ecdc610aae4c48e5d1b799d8689f6 ]

In sdma_init if rhashtable_init fails the allocated memory for
tmp_sdma_rht should be released.

Fixes: 5a52a7acf7e2 ("IB/hfi1: NULL pointer dereference when freeing rhashtable")
Link: https://lore.kernel.org/r/20190925144543.10141-1-navid.emamdoost@gmail.com
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Acked-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/sdma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 2395fd4233a7e..2ed7bfd5feea6 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -1526,8 +1526,11 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 	}
 
 	ret = rhashtable_init(tmp_sdma_rht, &sdma_rht_params);
-	if (ret < 0)
+	if (ret < 0) {
+		kfree(tmp_sdma_rht);
 		goto bail;
+	}
+
 	dd->sdma_rht = tmp_sdma_rht;
 
 	dd_dev_info(dd, "SDMA num_sdma: %u\n", dd->num_sdma);
-- 
2.20.1

