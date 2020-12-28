Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9913D2E3CE2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438652AbgL1OIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:08:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:42886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438645AbgL1OIT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:08:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C0192063A;
        Mon, 28 Dec 2020 14:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164458;
        bh=3MmpDDqL5dqQFlyFfQEQH4nXPsv/iniCXrcR9JwhZw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0qUKPjkCE3uTVxIiByj7640RuYGRSbZ3tXbJ6w8HRE2oScW8bDEeyWhlQ77/fJmc
         gjbQCLsIv1RG7l9HSAhZX76l/FO2UUykpZKcM2rFmn2mlAwUzj4KBH4L/cEyv7PO03
         +DtSVAJHth0fyOY7PMwiO/9JjL927NHOnEs+ETLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 188/717] RDMA/cxgb4: Validate the number of CQEs
Date:   Mon, 28 Dec 2020 13:43:06 +0100
Message-Id: <20201228125029.978229933@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit 6d8285e604e0221b67bd5db736921b7ddce37d00 ]

Before create CQ, make sure that the requested number of CQEs is in the
supported range.

Fixes: cfdda9d76436 ("RDMA/cxgb4: Add driver for Chelsio T4 RNIC")
Link: https://lore.kernel.org/r/20201108132007.67537-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 28349ed508854..d6cfefc269ee3 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -1008,6 +1008,9 @@ int c4iw_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	if (attr->flags)
 		return -EINVAL;
 
+	if (entries < 1 || entries > ibdev->attrs.max_cqe)
+		return -EINVAL;
+
 	if (vector >= rhp->rdev.lldi.nciq)
 		return -EINVAL;
 
-- 
2.27.0



