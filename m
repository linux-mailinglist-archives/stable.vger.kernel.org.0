Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7755D2E4090
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441574AbgL1OSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:18:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436558AbgL1OSW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 189A4207A9;
        Mon, 28 Dec 2020 14:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165061;
        bh=gGlTvwms0ABlxOyMUc92MnLMqf2nz9B+jnLhNrOlwnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gqx0lbo3OHqZd8P6h+1u2xQ1ckE6lCHDu3Hl3q6toskbGJX+iykrIhWQa8JihZrdj
         itOBvoomkTY0J2c1p78vCDV4dwgVxCxLNMoKp0B3W6eb8uqIGl9gSqYcccJb6Hhf8f
         QlrmYNWRZEVuw6gOvWf8dBN+sxOwYfh30/s0QiPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 396/717] RDMA/core: Do not indicate device ready when device enablement fails
Date:   Mon, 28 Dec 2020 13:46:34 +0100
Message-Id: <20201228125039.971185678@linuxfoundation.org>
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

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

[ Upstream commit 779e0bf47632c609c59f527f9711ecd3214dccb0 ]

In procedure ib_register_device, procedure kobject_uevent is called
(advertising that the device is ready for userspace usage) even when
device_enable_and_get() returned an error.

As a result, various RDMA modules attempted to register for the device
even while the device driver was preparing to unregister the device.

Fix this by advertising the device availability only after enabling the
device succeeds.

Fixes: e7a5b4aafd82 ("RDMA/device: Don't fire uevent before device is fully initialized")
Link: https://lore.kernel.org/r/20201208073545.9723-3-leon@kernel.org
Suggested-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index a3b1fc84cdcab..4a041511b70ec 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1374,9 +1374,6 @@ int ib_register_device(struct ib_device *device, const char *name,
 	}
 
 	ret = enable_device_and_get(device);
-	dev_set_uevent_suppress(&device->dev, false);
-	/* Mark for userspace that device is ready */
-	kobject_uevent(&device->dev.kobj, KOBJ_ADD);
 	if (ret) {
 		void (*dealloc_fn)(struct ib_device *);
 
@@ -1396,8 +1393,12 @@ int ib_register_device(struct ib_device *device, const char *name,
 		ib_device_put(device);
 		__ib_unregister_device(device);
 		device->ops.dealloc_driver = dealloc_fn;
+		dev_set_uevent_suppress(&device->dev, false);
 		return ret;
 	}
+	dev_set_uevent_suppress(&device->dev, false);
+	/* Mark for userspace that device is ready */
+	kobject_uevent(&device->dev.kobj, KOBJ_ADD);
 	ib_device_put(device);
 
 	return 0;
-- 
2.27.0



