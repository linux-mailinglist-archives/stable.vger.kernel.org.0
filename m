Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E576A15EFD3
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388738AbgBNP6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:58:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388400AbgBNP6y (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FF04222C4;
        Fri, 14 Feb 2020 15:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695934;
        bh=PLNrytnzgF1eAeTHEjvYL517Oe7v9++dJm1YPKnNc2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5lqIXlvgeFHkmc3ms1vvR9ZrOlliLaSHMZt8hbDRq5o8Su/Pi0Cdn4lWnBQkG6+y
         6CtaL4hC4eQCuHTIbvlRi8zqerUp/CsRZPuOY3eQ3d9XvVumnUw1TTliU7600UaHab
         8Eb03El6glPRq30+Ig9+gJoii2/YFwTW73hCL+yg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Gal Pressman <galpress@amazon.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 469/542] RDMA/core: Ensure that rdma_user_mmap_entry_remove() is a fence
Date:   Fri, 14 Feb 2020 10:47:41 -0500
Message-Id: <20200214154854.6746-469-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit 6b3712c0246ca7b2b8fa05eab2362cf267410f7e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/ib_core_uverbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/ib_core_uverbs.c b/drivers/infiniband/core/ib_core_uverbs.c
index b7cb59844ece4..b51bd7087a881 100644
--- a/drivers/infiniband/core/ib_core_uverbs.c
+++ b/drivers/infiniband/core/ib_core_uverbs.c
@@ -232,7 +232,9 @@ void rdma_user_mmap_entry_remove(struct rdma_user_mmap_entry *entry)
 	if (!entry)
 		return;
 
+	xa_lock(&entry->ucontext->mmap_xa);
 	entry->driver_removed = true;
+	xa_unlock(&entry->ucontext->mmap_xa);
 	kref_put(&entry->ref, rdma_user_mmap_entry_free);
 }
 EXPORT_SYMBOL(rdma_user_mmap_entry_remove);
-- 
2.20.1

