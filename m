Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 168B8106645
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfKVFtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:49:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:53960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727227AbfKVFto (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:49:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDDF820708;
        Fri, 22 Nov 2019 05:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401783;
        bh=F3GGm7t3WHwYNXVgUb+L8W3UBg8MBtvEOZG23w1T2JQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mh3JeGh7AnLMLr45Ae0KwNw0KeuNy+BjnqPrhWR3fdMVRX+ZgkbtPNNVibAYdsX8M
         FXSlEhIzpXQImJP+/X6yzO3wBOx7osCfpBaUeeqfjUWMG8RxnblXuROUgn2pUTNrmm
         JvUIHs6J0ji9hr54zOM6tg1KljIWZuYmD+h79zw4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gal Pressman <galpress@amazon.com>,
        Adit Ranadive <aditr@vmware.com>,
        Yuval Shaia <yuval.shaia@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 032/219] RDMA/vmw_pvrdma: Use atomic memory allocation in create AH
Date:   Fri, 22 Nov 2019 00:46:04 -0500
Message-Id: <20191122054911.1750-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gal Pressman <galpress@amazon.com>

[ Upstream commit a276a4d93bf1580d737f38d1810e5f4b166f3edd ]

Create address handle callback should not sleep, use GFP_ATOMIC instead of
GFP_KERNEL for memory allocation.

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Cc: Adit Ranadive <aditr@vmware.com>
Signed-off-by: Gal Pressman <galpress@amazon.com>
Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
index b65d10b0a8759..f4cb5cf26006f 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
@@ -555,7 +555,7 @@ struct ib_ah *pvrdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
 	if (!atomic_add_unless(&dev->num_ahs, 1, dev->dsr->caps.max_ah))
 		return ERR_PTR(-ENOMEM);
 
-	ah = kzalloc(sizeof(*ah), GFP_KERNEL);
+	ah = kzalloc(sizeof(*ah), GFP_ATOMIC);
 	if (!ah) {
 		atomic_dec(&dev->num_ahs);
 		return ERR_PTR(-ENOMEM);
-- 
2.20.1

