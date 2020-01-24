Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BABF71481D1
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391275AbgAXLXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:23:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:35130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391272AbgAXLXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:23:00 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E31D2077C;
        Fri, 24 Jan 2020 11:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864979;
        bh=f6MM8M30IvlGsLr55QwmbZJmg2tFGoH8lL+QaUmuUC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjZ+x4eonWnJ4N8TOKWbExE52Yl+42ZX7IhisBW4JlbTA2wC4D+fOO+gZMkh5fqeK
         TYdRXkkVmdboxP+AwwORQ74C8+1nLBpowZco5cWhagLNVNy7Di6lTCxI20xpx4gwSD
         u7RDHCmmvyz8WsFQHRE9CTPmIg6MfhJR6ZKLZ7J0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 406/639] RDMA/uverbs: check for allocation failure in uapi_add_elm()
Date:   Fri, 24 Jan 2020 10:29:36 +0100
Message-Id: <20200124093137.930604331@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index be854628a7c63..959a3418a192d 100644
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



