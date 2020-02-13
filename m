Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE56515C319
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbgBMP2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:28:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729169AbgBMP17 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:59 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBDD820661;
        Thu, 13 Feb 2020 15:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607679;
        bh=eOvi2lyam38R3vikiDpoBEPaRqMpYkr9BVA2+dxyxkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v0cxAT95fSV/foegaXT1g7EYFGg3y+5W+n1hTObl4Zmz7r4uXmpGEqmWiyJkGbanF
         46lxOSoRlTT6shCjvs2WsIKj022pIyPyX+FeuL9zofV9cSHlkj+/fUhAgm//6a3Er8
         XLGOcvj695Ft9zA3FIMWlTieyS9AmrHrN9xXpgb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <galpress@amazon.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.5 010/120] RDMA/core: Ensure that rdma_user_mmap_entry_remove() is a fence
Date:   Thu, 13 Feb 2020 07:20:06 -0800
Message-Id: <20200213151905.020233871@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit 6b3712c0246ca7b2b8fa05eab2362cf267410f7e upstream.

The set of entry->driver_removed is missing locking, protect it with
xa_lock() which is held by the only reader.

Otherwise readers may continue to see driver_removed = false after
rdma_user_mmap_entry_remove() returns and may continue to try and
establish new mmaps.

Fixes: 3411f9f01b76 ("RDMA/core: Create mmap database and cookie helper functions")
Link: https://lore.kernel.org/r/20200115202041.GA17199@ziepe.ca
Reviewed-by: Gal Pressman <galpress@amazon.com>
Acked-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/ib_core_uverbs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/infiniband/core/ib_core_uverbs.c
+++ b/drivers/infiniband/core/ib_core_uverbs.c
@@ -232,7 +232,9 @@ void rdma_user_mmap_entry_remove(struct
 	if (!entry)
 		return;
 
+	xa_lock(&entry->ucontext->mmap_xa);
 	entry->driver_removed = true;
+	xa_unlock(&entry->ucontext->mmap_xa);
 	kref_put(&entry->ref, rdma_user_mmap_entry_free);
 }
 EXPORT_SYMBOL(rdma_user_mmap_entry_remove);


