Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 329B313E628
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391121AbgAPRSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:18:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391478AbgAPRS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:18:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A09C246BF;
        Thu, 16 Jan 2020 17:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195109;
        bh=aP/6JkpNVjX8LDKp1dySfxmf/B7jz/SY40FUFv2/GLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qMmquzcYxC/pQUBfVBJg7j9JVpORwLBBkAZXnfeNT77gieJmQ7wiBm0Hlij3GKZAf
         iM+npWfUZIYM/HccAV37atNqdhsoA92JVrWEmIpViGGgFDjmE73UA8ou0hvE9i+DPB
         Bzn8toz730zPC4kvcdFi6vXCRIpAqNJaH4A0iAqY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gal Pressman <galpress@amazon.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 051/371] RDMA/ocrdma: Fix out of bounds index check in query pkey
Date:   Thu, 16 Jan 2020 12:11:59 -0500
Message-Id: <20200116171719.16965-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116171719.16965-1-sashal@kernel.org>
References: <20200116171719.16965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gal Pressman <galpress@amazon.com>

[ Upstream commit b188940796c7be31c1b8c25a9a0e0842c2e7a49e ]

The pkey table size is one element, index should be tested for > 0 instead
of > 1.

Fixes: fe2caefcdf58 ("RDMA/ocrdma: Add driver for Emulex OneConnect IBoE RDMA adapter")
Signed-off-by: Gal Pressman <galpress@amazon.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 27d5e8d9f08d..7683d13dad3d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -55,7 +55,7 @@
 
 int ocrdma_query_pkey(struct ib_device *ibdev, u8 port, u16 index, u16 *pkey)
 {
-	if (index > 1)
+	if (index > 0)
 		return -EINVAL;
 
 	*pkey = 0xffff;
-- 
2.20.1

