Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C71D413F4FD
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389341AbgAPRIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:08:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:41484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389339AbgAPRIO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD6FA21D56;
        Thu, 16 Jan 2020 17:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194493;
        bh=dbN6Hk/xeS7pJGBNgUEA1kBcGzbGki87brQhHo3UQPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wkqPqmICKur3HiNo/1Y02Nb21pnAemKhRTIgSOHeTrCF4xNyQFHuh7frexjdPZRVq
         KoYtbW5sMxXr2CSgpa6SsQJdb8ZLAJ62Ct6w4i/9VpI7K3jEJ6haAq89sX2GgDw5Ys
         yKZxp4YQklwD63DJPjBTMGpGeXnjsaolanaIZZOs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 391/671] RDMA/uverbs: check for allocation failure in uapi_add_elm()
Date:   Thu, 16 Jan 2020 12:00:29 -0500
Message-Id: <20200116170509.12787-128-sashal@kernel.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit cac2a301c02a9b178842e22df34217da7854e588 ]

If the kzalloc() fails then we should return ERR_PTR(-ENOMEM).  In the
current code it's possible that the kzalloc() fails and the
radix_tree_insert() inserts the NULL pointer successfully and we return
the NULL "elm" pointer to the caller.  That results in a NULL pointer
dereference.

Fixes: 9ed3e5f44772 ("IB/uverbs: Build the specs into a radix tree at runtime")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_uapi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_uapi.c b/drivers/infiniband/core/uverbs_uapi.c
index be854628a7c6..959a3418a192 100644
--- a/drivers/infiniband/core/uverbs_uapi.c
+++ b/drivers/infiniband/core/uverbs_uapi.c
@@ -17,6 +17,8 @@ static void *uapi_add_elm(struct uverbs_api *uapi, u32 key, size_t alloc_size)
 		return ERR_PTR(-EOVERFLOW);
 
 	elm = kzalloc(alloc_size, GFP_KERNEL);
+	if (!elm)
+		return ERR_PTR(-ENOMEM);
 	rc = radix_tree_insert(&uapi->radix, key, elm);
 	if (rc) {
 		kfree(elm);
-- 
2.20.1

