Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C716F48D9
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733207AbfKHL7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:59:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:59174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733257AbfKHLoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:44:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4F0421D82;
        Fri,  8 Nov 2019 11:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213456;
        bh=1YNBzt0jbY+niUzO7ze/IcroOlW0T0+ZDdhYKHwxpCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zOe4V7J2CzbeZvMog1hLkQtsxx0r03ebsklcq5rVDi15kbhAyFe6yURPv2tcKepxc
         /2DARTKKzRS7Tf8CspV64Zf2nlheyorB+tQAAK3bt5ngY+xXHGrr4RTy1Y1YQbvY3S
         TA71Pesm7R5jXY1oe8a4y/bdFvEK7ImMiKB8qoWk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 045/103] RDMA/core: Follow correct unregister order between sysfs and cgroup
Date:   Fri,  8 Nov 2019 06:42:10 -0500
Message-Id: <20191108114310.14363-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit c715a39541bb399eb03d728a996b224d90ce1336 ]

During register_device() init sequence is,
(a) register with rdma cgroup followed by
(b) register with sysfs

Therefore, unregister_device() sequence should follow the reverse order.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Daniel Jurgens <danielj@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 61ade4b3e7bb5..6b0d1d8609cad 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -599,8 +599,8 @@ void ib_unregister_device(struct ib_device *device)
 	}
 	up_read(&lists_rwsem);
 
-	ib_device_unregister_rdmacg(device);
 	ib_device_unregister_sysfs(device);
+	ib_device_unregister_rdmacg(device);
 
 	mutex_unlock(&device_mutex);
 
-- 
2.20.1

