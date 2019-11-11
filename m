Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33216F7EF7
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbfKKSiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:38:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:57206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728970AbfKKSiS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:38:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 380DB204FD;
        Mon, 11 Nov 2019 18:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497497;
        bh=lWYXohEveQ9l45sEh9RSFjZwLmKDb85yvXYMavMpE8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yNitIQTuNwWQlGr766FR2ftyArrZERQepCynuZFmnjP9paPs9tnyncHxis2qeJGpq
         OT1Vkeck6HYyW7qg41VcCnxGw4aIyDDT5phkldzOz7qZxdk286ar87oxlgLd3PeP6m
         fIT9W51izacVPzp7nMEkIbYrcidFVtNdbUoYW0Sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 074/105] RDMA/uverbs: Prevent potential underflow
Date:   Mon, 11 Nov 2019 19:28:44 +0100
Message-Id: <20191111181446.065683727@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
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
index 37c8903e7fd0c..8d79a48ccd388 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -87,7 +87,7 @@
 
 struct ib_uverbs_device {
 	atomic_t				refcount;
-	int					num_comp_vectors;
+	u32					num_comp_vectors;
 	struct completion			comp;
 	struct device			       *dev;
 	struct ib_device	__rcu	       *ib_dev;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index b8a5118b6a428..4a43193319894 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -306,7 +306,7 @@ enum ib_cq_creation_flags {
 
 struct ib_cq_init_attr {
 	unsigned int	cqe;
-	int		comp_vector;
+	u32		comp_vector;
 	u32		flags;
 };
 
-- 
2.20.1



