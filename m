Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D521C8F9D
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgEGOd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:33:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728582AbgEGO3d (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:29:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B4A120838;
        Thu,  7 May 2020 14:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861773;
        bh=XbnFtCXYMLOqIB6JPSZmw6i8y0K9dGA+/5iIuo36EkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zFewgdpSbk7WqBX4Em4rtNuCIC/RT/jZM/r0ew88Ae6IOhb/0dyoU+5qmmKTAtaTN
         Z4ReIhLkc0Mf6KhzBjp7x7DXaGPITf4hkJw5ti/sCn36NQcF9qAKbCg5De0eWm1YzF
         M75mL1F0EzslnovN0p1LyWDzKB/R171TDzRqytfU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/20] RDMA/core: Fix race between destroy and release FD object
Date:   Thu,  7 May 2020 10:29:09 -0400
Message-Id: <20200507142917.26612-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142917.26612-1-sashal@kernel.org>
References: <20200507142917.26612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit f0abc761bbb9418876cc4d1ebc473e4ea6352e42 ]

The call to ->lookup_put() was too early and it caused an unlock of the
read/write protection of the uobject after the FD was put. This allows a
race:

     CPU1                                 CPU2
 rdma_lookup_put_uobject()
   lookup_put_fd_uobject()
     fput()
				   fput()
				     uverbs_uobject_fd_release()
				       WARN_ON(uverbs_try_lock_object(uobj,
					       UVERBS_LOOKUP_WRITE));
   atomic_dec(usecnt)

Fix the code by changing the order, first unlock and call to
->lookup_put() after that.

Fixes: 3832125624b7 ("IB/core: Add support for idr types")
Link: https://lore.kernel.org/r/20200423060122.6182-1-leon@kernel.org
Suggested-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/rdma_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 52737ad88bf1a..bf937fec50dca 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -697,7 +697,6 @@ void rdma_lookup_put_uobject(struct ib_uobject *uobj,
 			     enum rdma_lookup_mode mode)
 {
 	assert_uverbs_usecnt(uobj, mode);
-	uobj->uapi_object->type_class->lookup_put(uobj, mode);
 	/*
 	 * In order to unlock an object, either decrease its usecnt for
 	 * read access or zero it in case of exclusive access. See
@@ -714,6 +713,7 @@ void rdma_lookup_put_uobject(struct ib_uobject *uobj,
 		break;
 	}
 
+	uobj->uapi_object->type_class->lookup_put(uobj, mode);
 	/* Pairs with the kref obtained by type->lookup_get */
 	uverbs_uobject_put(uobj);
 }
-- 
2.20.1

