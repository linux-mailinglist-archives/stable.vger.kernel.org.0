Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7390E1C44A9
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732013AbgEDSGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732010AbgEDSGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:06:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C20DB2087E;
        Mon,  4 May 2020 18:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615604;
        bh=w+yPL/bVXvDTiFWPzUWODEVmw/6jrMVQG1TYGt8QO3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sah/UtS8oGuKUF2WBmfxkf+XAVobMbiRMf3gNRU4fmcdBzY1373TJqQnJe5S1QFx6
         I92d0MAnVZTi7IPgfGUxKrUj0JDTqkEJKnXjtHotfWw0buoPdOVoCX7HbmTY7Ksayc
         HXVzdiOffgez5EW8TupfH3M8+hJ5WoPqGHYZVlGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH 5.6 49/73] RDMA/core: Fix race between destroy and release FD object
Date:   Mon,  4 May 2020 19:57:52 +0200
Message-Id: <20200504165509.066749063@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

commit f0abc761bbb9418876cc4d1ebc473e4ea6352e42 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/rdma_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -678,7 +678,6 @@ void rdma_lookup_put_uobject(struct ib_u
 			     enum rdma_lookup_mode mode)
 {
 	assert_uverbs_usecnt(uobj, mode);
-	uobj->uapi_object->type_class->lookup_put(uobj, mode);
 	/*
 	 * In order to unlock an object, either decrease its usecnt for
 	 * read access or zero it in case of exclusive access. See
@@ -695,6 +694,7 @@ void rdma_lookup_put_uobject(struct ib_u
 		break;
 	}
 
+	uobj->uapi_object->type_class->lookup_put(uobj, mode);
 	/* Pairs with the kref obtained by type->lookup_get */
 	uverbs_uobject_put(uobj);
 }


