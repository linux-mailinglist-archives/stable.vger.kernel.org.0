Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C3113E2DC
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732853AbgAPQ6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:58:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387523AbgAPQ5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:57:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D92224673;
        Thu, 16 Jan 2020 16:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193860;
        bh=bRJwGJyGPypJB2TUxFTv7I8uq4hF8Uyq6ct81Bq1hJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OVDBzh1dqNb1COl/KVkh7XSWwnYHFp8L5uBx9GOAYeZcQKReMa9neT1g/4lRduht4
         Mp+aQn4U1CcsBS2mhJaoBzTPBNjZtDEODERkFxm4kg1Xab5T8/hXFFvjCsWAyPGFzj
         NLe6UV56RaekqO64Yp0NMAwI4ppudnZT2nVQVkk4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gal Pressman <galpress@amazon.com>,
        Parvi Kaustubhi <pkaustub@cisco.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 108/671] IB/usnic: Fix out of bounds index check in query pkey
Date:   Thu, 16 Jan 2020 11:45:39 -0500
Message-Id: <20200116165502.8838-108-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gal Pressman <galpress@amazon.com>

[ Upstream commit 4959d5da5737dd804255c75b8cea0a2929ce279a ]

The pkey table size is one element, index should be tested for > 0 instead
of > 1.

Fixes: e3cf00d0a87f ("IB/usnic: Add Cisco VIC low-level hardware driver")
Signed-off-by: Gal Pressman <galpress@amazon.com>
Acked-by: Parvi Kaustubhi <pkaustub@cisco.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 3db232429630..e611f133aa97 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -447,7 +447,7 @@ struct net_device *usnic_get_netdev(struct ib_device *device, u8 port_num)
 int usnic_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 				u16 *pkey)
 {
-	if (index > 1)
+	if (index > 0)
 		return -EINVAL;
 
 	*pkey = 0xffff;
-- 
2.20.1

