Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6DB92E685E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441033AbgL1QfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:35:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729979AbgL1NCI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:02:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75D2B22573;
        Mon, 28 Dec 2020 13:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160513;
        bh=w/jIiCdB4hH0VtmD/FjeQIDWgM8kH+eyi5kTzMPkg4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mSDeXDuM3wd97s7+hTxvJm373CHM+Oph+6ZsfgnXqLdUDUd+B7gw0AXgMznwL1u+A
         yx6YwWNkpK0YJLvyCDQQBJMvU0DqKr4U0nYqT2j1HSKdFldkMFuf7gCm4r0X+Jox6H
         kkNGZPP+8a7n/ThpCmw2Wiw+tbfYTBGQBi9fhc4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 076/175] RDMA/cxgb4: Validate the number of CQEs
Date:   Mon, 28 Dec 2020 13:48:49 +0100
Message-Id: <20201228124856.922283475@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
index a856371bbe58c..501f496f4e1a1 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -893,6 +893,9 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev,
 
 	rhp = to_c4iw_dev(ibdev);
 
+	if (entries < 1 || entries > ibdev->attrs.max_cqe)
+		return -EINVAL;
+
 	if (vector >= rhp->rdev.lldi.nciq)
 		return ERR_PTR(-EINVAL);
 
-- 
2.27.0



