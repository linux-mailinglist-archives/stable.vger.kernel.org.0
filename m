Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B066A1195CC
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbfLJVLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:11:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:33578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728708AbfLJVLK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:11:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BD2424697;
        Tue, 10 Dec 2019 21:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012270;
        bh=6IUHqtOId68VED+dBh6FQNdwiznKbRUy/0McKi+HpdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MuLD4ui110tRoBgynjrLw2A7OHf8/osKuXcQtnQM3ix9n6e/NKPGIjUqqxP8E+cSY
         VDSalQGC7xI3GLc02FinaOT2l/eUhIjQGolfumNHp82XD9wDPxl20kPaVpnHvuPvs7
         jpNNTO9TB585VXQG3tEjXHgIfHFZnmd+0f97lZ6U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 215/350] RDMA/core: Fix return code when modify_port isn't supported
Date:   Tue, 10 Dec 2019 16:05:20 -0500
Message-Id: <20191210210735.9077-176-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit 55bfe905fa97633438c13fb029aed85371d85480 ]

Improve return code from ib_modify_port() by doing the following:
 - Use "-EOPNOTSUPP" instead "-ENOSYS" which is the proper return code

 - Allow only fake IB_PORT_CM_SUP manipulation for RoCE providers that
   didn't implement the modify_port callback, otherwise return
   "-EOPNOTSUPP"

Fixes: 61e0962d5221 ("IB: Avoid ib_modify_port() failure for RoCE devices")
Link: https://lore.kernel.org/r/20191028155931.1114-2-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index e6327d8f5b79a..2b5bd7206fc6e 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2409,8 +2409,12 @@ int ib_modify_port(struct ib_device *device,
 		rc = device->ops.modify_port(device, port_num,
 					     port_modify_mask,
 					     port_modify);
+	else if (rdma_protocol_roce(device, port_num) &&
+		 ((port_modify->set_port_cap_mask & ~IB_PORT_CM_SUP) == 0 ||
+		  (port_modify->clr_port_cap_mask & ~IB_PORT_CM_SUP) == 0))
+		rc = 0;
 	else
-		rc = rdma_protocol_roce(device, port_num) ? 0 : -ENOSYS;
+		rc = -EOPNOTSUPP;
 	return rc;
 }
 EXPORT_SYMBOL(ib_modify_port);
-- 
2.20.1

