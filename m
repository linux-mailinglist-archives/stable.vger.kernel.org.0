Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D57F0F7DC4
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbfKKS4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:56:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:53808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbfKKSz7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:55:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F64C2173B;
        Mon, 11 Nov 2019 18:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498558;
        bh=2rThCfLUbn/rOf+XHEOFzm5EjusfE9HRe4LqvbzfgZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJGfw5q4ZL1Y5JylSxeY6VtFw8NuxdahnMJI0WruyuRhIaiCaQv/hxlZjpSLP9G6z
         aCl5SHv0lbjXKLcc6G4vGvoGQg4/Yu1XO8buLijH/VdyWVrdR5EMzH5Abv8vMPgoSS
         XjL0Mdf9Zc2ioP40u+d/XeSTfq7XFHxE73YjwQI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 114/193] RDMA/uverbs: Prevent potential underflow
Date:   Mon, 11 Nov 2019 19:28:16 +0100
Message-Id: <20191111181509.541201231@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit a9018adfde809d44e71189b984fa61cc89682b5e ]

The issue is in drivers/infiniband/core/uverbs_std_types_cq.c in the
UVERBS_HANDLER(UVERBS_METHOD_CQ_CREATE) function.  We check that:

        if (attr.comp_vector >= attrs->ufile->device->num_comp_vectors) {

But we don't check if "attr.comp_vector" is negative.  It could
potentially lead to an array underflow.  My concern would be where
cq->vector is used in the create_cq() function from the cxgb4 driver.

And really "attr.comp_vector" is appears as a u32 to user space so that's
the right type to use.

Fixes: 9ee79fce3642 ("IB/core: Add completion queue (cq) object actions")
Link: https://lore.kernel.org/r/20191011133419.GA22905@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs.h | 2 +-
 include/rdma/ib_verbs.h          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 1e5aeb39f774d..63f7f7db59028 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -98,7 +98,7 @@ ib_uverbs_init_udata_buf_or_null(struct ib_udata *udata,
 
 struct ib_uverbs_device {
 	atomic_t				refcount;
-	int					num_comp_vectors;
+	u32					num_comp_vectors;
 	struct completion			comp;
 	struct device				dev;
 	/* First group for device attributes, NULL terminated array */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4f225175cb91e..77d8df4518051 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -327,7 +327,7 @@ struct ib_tm_caps {
 
 struct ib_cq_init_attr {
 	unsigned int	cqe;
-	int		comp_vector;
+	u32		comp_vector;
 	u32		flags;
 };
 
-- 
2.20.1



