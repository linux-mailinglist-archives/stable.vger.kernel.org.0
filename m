Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5540A12C83F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732313AbfL2Rwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:52:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732310AbfL2Rwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:52:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADFFB206A4;
        Sun, 29 Dec 2019 17:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641957;
        bh=2CGT0AYPFX89wRW2P4+iHm7KLRCcTSHvlfJx878gp/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+3cDu23K5g4MoDOvFi4UWjFAOiUWVP4R6UAxEHWBRNqqnlgq3Nb7tKSXSGLqpUud
         VuKSGy/T5IxvflfRz7a0oOVs/Q7sJj+Yn1B4vQlQ97VgaVV69JxQPHWCaQxHHupRiK
         pNlqeo27eVSj5/t63+slq4XLSkmi7oCK3FtmJsw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 240/434] RDMA/core: Fix return code when modify_port isnt supported
Date:   Sun, 29 Dec 2019 18:24:53 +0100
Message-Id: <20191229172717.824696073@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e6327d8f5b79..2b5bd7206fc6 100644
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



