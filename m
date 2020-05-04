Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6F61C373B
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 12:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgEDKv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 06:51:57 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:53469 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726756AbgEDKv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 06:51:57 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 34FD16D3;
        Mon,  4 May 2020 06:51:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 04 May 2020 06:51:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=gb6Tck
        nHKwdVKchikBhCSsrUpLox9tZd5ocYY2YXGKA=; b=C+xShO/Y/795V5yKiKr1Z5
        BtN1Z8ZuxO/d44FAsPQPUlfOrt/orOEOY4+Cf2fjVynHFG0cKSmhHjAbeN922ZfX
        JNfYARMt8YOcAvnXD0xta8KXdQCatmnVaOQ39+oWDl3nWUcROlx3xKW3TT/XE6ZX
        OYzq+TNADrlcVCiYKc0PO84EUScBnpAooyv6ZD2ygHY9E1HEA0d/Dd+KW2V3j5g8
        /3349UJfV496PJegdHA/lplKaFJTzmZfAexBq54R+LK929yZoXpOGGnv+2OusQny
        qCNiZDRPcaDTpgB5EeiynfR+JdjaW64lvuTsxT7F4DqsBWacmwldI2otQ7oRVtWw
        ==
X-ME-Sender: <xms:y_OvXnMnemWvQcG2_gjhrXE1P7b_F8w8DqGRCP9TmPsxHTEqjpJXNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrjeeggddvlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:y_OvXlMW2tkUvarq26l1pOOyQvdWvXuFxxuII3aca6BUNnjbfTGHGQ>
    <xmx:y_OvXtzvkMTnpcLm-ugiV4DwL2GAhk4NSQSDj291qrxpamAZStu6ig>
    <xmx:y_OvXpXbGtJ-gwm2Zxx9ieLibZ7ETWrsRahLuILTlm1AsDxf5_Iwkw>
    <xmx:y_OvXt_JgeRY5e3BqCY8auO7fkRPiXS5j8XRETcHOG4KhucOaJKkClMf3Mk>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 401483066016;
        Mon,  4 May 2020 06:51:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] RDMA/core: Fix race between destroy and release FD object" failed to apply to 4.14-stable tree
To:     leon@kernel.org, jgg@mellanox.com, leonro@mellanox.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 May 2020 12:51:54 +0200
Message-ID: <1588589514134197@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f0abc761bbb9418876cc4d1ebc473e4ea6352e42 Mon Sep 17 00:00:00 2001
From: Leon Romanovsky <leon@kernel.org>
Date: Thu, 23 Apr 2020 09:01:22 +0300
Subject: [PATCH] RDMA/core: Fix race between destroy and release FD object

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

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 2947f4f83561..177333d8bcda 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -678,7 +678,6 @@ void rdma_lookup_put_uobject(struct ib_uobject *uobj,
 			     enum rdma_lookup_mode mode)
 {
 	assert_uverbs_usecnt(uobj, mode);
-	uobj->uapi_object->type_class->lookup_put(uobj, mode);
 	/*
 	 * In order to unlock an object, either decrease its usecnt for
 	 * read access or zero it in case of exclusive access. See
@@ -695,6 +694,7 @@ void rdma_lookup_put_uobject(struct ib_uobject *uobj,
 		break;
 	}
 
+	uobj->uapi_object->type_class->lookup_put(uobj, mode);
 	/* Pairs with the kref obtained by type->lookup_get */
 	uverbs_uobject_put(uobj);
 }

