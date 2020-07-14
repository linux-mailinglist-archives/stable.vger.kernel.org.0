Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9091621FB71
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbgGNS6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:58:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731123AbgGNS44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:56:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB40722AAF;
        Tue, 14 Jul 2020 18:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753016;
        bh=InUAdj6RJYAkX7bsjeRys4kfr30Vf4l88303w68ZOvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vmn4xVCVsrXNKsNAG3EsmwqkQ5vjC2gn5CaL9qAElGvZxGxJAKYqNzwnfBz6uGy4B
         D6/6I+pcMV0exHy8/WAtTnBNiA9n3pE2YFX7YvjRlxFEw4C8zV2ld41oUcz8tO0aDq
         LVw+YBeYa6iJgYIUpsTBi7yYqk6axZOJIYUzrdjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 086/166] RDMA/siw: Fix reporting vendor_part_id
Date:   Tue, 14 Jul 2020 20:44:11 +0200
Message-Id: <20200714184119.968856576@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit 04340645f69ab7abb6f9052688a60f0213b3f79c ]

Move the initialization of the vendor_part_id to be before calling
ib_register_device(), this is needed because the query_device() callback
is called from the context of ib_register_device() before initializing the
vendor_part_id, so the reported value is wrong.

Fixes: bdcf26bf9b3a ("rdma/siw: network and RDMA core interface")
Link: https://lore.kernel.org/r/20200707130931.444724-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Reviewed-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
index 5cd40fb9e20ce..634c4b3716238 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -67,12 +67,13 @@ static int siw_device_register(struct siw_device *sdev, const char *name)
 	static int dev_id = 1;
 	int rv;
 
+	sdev->vendor_part_id = dev_id++;
+
 	rv = ib_register_device(base_dev, name);
 	if (rv) {
 		pr_warn("siw: device registration error %d\n", rv);
 		return rv;
 	}
-	sdev->vendor_part_id = dev_id++;
 
 	siw_dbg(base_dev, "HWaddr=%pM\n", sdev->netdev->dev_addr);
 
-- 
2.25.1



