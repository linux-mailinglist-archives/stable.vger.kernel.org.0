Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8B127C6AE
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730962AbgI2Lre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731076AbgI2Lrc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:47:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 196FF20702;
        Tue, 29 Sep 2020 11:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380051;
        bh=yFH87YJ3rXHh/f5O4rYj9w3fFMwofdzuayhJ5lAVm/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4xOJuSvKfC8EDLBT7rdY5iRnFsF7vWcYpiPL9kXIUVMi2ImoesZnde5V1PSX1F34
         JkIR05/d2pnheHq2XL8qOzBtY/PhfVPFD6V5IROrPVtlCHVzcFa12la+8acPKcE0d+
         N3cpJYVxFg/N+1Nd+Hff7laX8o0KZ+NcyD4LPk9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Yi Zhang <yi.zhang@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 45/99] RDMA/core: Fix ordering of CQ pool destruction
Date:   Tue, 29 Sep 2020 13:01:28 +0200
Message-Id: <20200929105931.947114944@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 4aa1615268a8ac2b20096211d3f9ac53874067d7 ]

rxe will hold a refcount on the IB device as long as CQ objects exist,
this causes destruction of a rxe device to hang if the CQ pool has any
cached CQs since they are being destroyed after the refcount must go to
zero.

Treat the CQ pool like a client and create/destroy it before/after all
other clients. No users of CQ pool can exist past a client remove call.

Link: https://lore.kernel.org/r/e8a240aa-9e9b-3dca-062f-9130b787f29b@acm.org
Fixes: c7ff819aefea ("RDMA/core: Introduce shared CQ pool API")
Tested-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index eadba29432dd7..abcfe4dc1284f 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1282,6 +1282,8 @@ static void disable_device(struct ib_device *device)
 		remove_client_context(device, cid);
 	}
 
+	ib_cq_pool_destroy(device);
+
 	/* Pairs with refcount_set in enable_device */
 	ib_device_put(device);
 	wait_for_completion(&device->unreg_completion);
@@ -1325,6 +1327,8 @@ static int enable_device_and_get(struct ib_device *device)
 			goto out;
 	}
 
+	ib_cq_pool_init(device);
+
 	down_read(&clients_rwsem);
 	xa_for_each_marked (&clients, index, client, CLIENT_REGISTERED) {
 		ret = add_client_context(device, client);
@@ -1397,7 +1401,6 @@ int ib_register_device(struct ib_device *device, const char *name)
 		goto dev_cleanup;
 	}
 
-	ib_cq_pool_init(device);
 	ret = enable_device_and_get(device);
 	dev_set_uevent_suppress(&device->dev, false);
 	/* Mark for userspace that device is ready */
@@ -1452,7 +1455,6 @@ static void __ib_unregister_device(struct ib_device *ib_dev)
 		goto out;
 
 	disable_device(ib_dev);
-	ib_cq_pool_destroy(ib_dev);
 
 	/* Expedite removing unregistered pointers from the hash table */
 	free_netdevs(ib_dev);
-- 
2.25.1



