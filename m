Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629AE401B45
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241923AbhIFMhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:37:10 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:52363 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241911AbhIFMhK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 08:37:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630931766; x=1662467766;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FuCVAG73F+hbcI49Q1OEg+f4pzJw46TdoFedAsGkVEs=;
  b=nKLzIpRUNnwq5nWkI60O6m1++zyiRDsygOX1737d0LORiWTk7uX2MxzY
   /OzpPtIqOdR+lgLc7NhRfkI0FdtCAy7llegBCVlZqt4nZi7OJK3sscKqO
   DexY+gPn3xh2hG4oJh75nO/VIIzDbVpR7rQumHmkDFfzBVfNhf6dWtj4v
   8pIGs3YelReavNmXnwxQgEeKZWJj52E8u3sq7JdbQ+YZqNp6NzW70hwQF
   Z8D7DqKma2a5nfFwaKDoxIA6+HXVHd6Ga5+VR/ePUJkMx2IIYBCC1emxA
   mbQ2IibbOOV4FmyxaO/JABs5CJzdeJCumKRCAevVHgNyEkmwZ3VIdfqxW
   g==;
X-IronPort-AV: E=Sophos;i="5.85,272,1624291200"; 
   d="scan'208";a="179827824"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Sep 2021 20:36:05 +0800
IronPort-SDR: trvF3zLNFIZv4kFo3s+gzdaNH0eJcPuP+DE11bXCn2CzWNb5RFG2TyY8k49/KbjiN9fYCwhLor
 DFp2lst5SMZSaPn+A+8scSWH5dEX8wj1Wggz365ACzHhQta/1k8l1MoVzBA8v2A4Ztf4+qm/ZT
 JHO3kOrcgb7vrDdvsjg0BnuPKx8/peVwtDvoHdQ1tKc/hFXIsHDTJyKbkOHf5bo2TygZY6sZkI
 jXVrfb+zIbNC491EmkvXcC1EvOq80ORjWQDSA7PsgIfMVsWvVvoe9TAiFmCk9RMDgBfbO+yXGI
 88pYmdEg1X4lGnQbvIbXjhWN
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2021 05:12:44 -0700
IronPort-SDR: lPObxYB5FdJQKnE0MEtP+DtU6nG2b57tSofS7bazD1id1t0fgnx1Ytw1JHYR5wrT53l5RS9V1o
 6bKgS4aAdu1DSwEz2YEz0bAJW09bIGXGQjL2szq20q+NFC6iVw+dAxIgglEWUryBRgWal04G22
 jKU9+j1DGaQeOv3+oM4GDUVEdX1kwQQjecO64Tr5Sw9ZReEAsw2WUS942OheGuWpgkB4aEPnt6
 zoYL216SJDK9/7NdiDdBhgKvxCP1prL3HrDISO3G0E0y7e2bYxNQP8/4CKS4RYfK7FSOYloGYa
 TrQ=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Sep 2021 05:36:04 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Johannes Thumshirn <jth@kernel.org>, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/1] mcb: fix error handling in mcb_alloc_bus()
Date:   Mon,  6 Sep 2021 21:35:48 +0900
Message-Id: <32e160cf6864ce77f9d62948338e24db9fd8ead9.1630931319.git.johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1630931319.git.johannes.thumshirn@wdc.com>
References: <cover.1630931319.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

There are two bugs:
1) If ida_simple_get() fails then this code calls put_device(carrier)
   but we haven't yet called get_device(carrier) and probably that
   leads to a use after free.
2) After device_initialize() then we need to use put_device() to
   release the bus.  This will free the internal resources tied to the
   device and call mcb_free_bus() which will free the rest.

Fixes: 5d9e2ab9fea4 ("mcb: Implement bus->dev.release callback")
Fixes: 18d288198099 ("mcb: Correctly initialize the bus's device")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Johannes Thumshirn <jth@kernel.org>
---
 drivers/mcb/mcb-core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mcb/mcb-core.c b/drivers/mcb/mcb-core.c
index edf4ee6eff25..cf128b3471d7 100644
--- a/drivers/mcb/mcb-core.c
+++ b/drivers/mcb/mcb-core.c
@@ -275,8 +275,8 @@ struct mcb_bus *mcb_alloc_bus(struct device *carrier)
 
 	bus_nr = ida_simple_get(&mcb_ida, 0, 0, GFP_KERNEL);
 	if (bus_nr < 0) {
-		rc = bus_nr;
-		goto err_free;
+		kfree(bus);
+		return ERR_PTR(bus_nr);
 	}
 
 	bus->bus_nr = bus_nr;
@@ -291,12 +291,12 @@ struct mcb_bus *mcb_alloc_bus(struct device *carrier)
 	dev_set_name(&bus->dev, "mcb:%d", bus_nr);
 	rc = device_add(&bus->dev);
 	if (rc)
-		goto err_free;
+		goto err_put;
 
 	return bus;
-err_free:
-	put_device(carrier);
-	kfree(bus);
+
+err_put:
+	put_device(&bus->dev);
 	return ERR_PTR(rc);
 }
 EXPORT_SYMBOL_NS_GPL(mcb_alloc_bus, MCB);
-- 
2.32.0

