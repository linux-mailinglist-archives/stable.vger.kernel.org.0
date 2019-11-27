Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D9E10BFA1
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbfK0VoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:44:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727681AbfK0Uhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:37:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DBF72158C;
        Wed, 27 Nov 2019 20:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887064;
        bh=+UUgulf3umEery2eT/3tjTxrLJpprV9yV0f2vEDgfkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KiaqL4TJWTiwq30s+m3y5oU4j9iavuBvXsNi+BVQCjqLpkceNuCNUifjIl1sD4/Ml
         PzWNII/IEBbOJXnNnbHQAZ6vaLGVKYEyZhGC0Eecz7En7Tz4gyYhEbcF4wEwCK1aN4
         ZbqRNtxPKIfH0eCMXj7JKlYXxAoDT2X2w6E4Qryc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        James Erwin <james.erwin@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 098/132] IB/hfi1: Ensure full Gen3 speed in a Gen4 system
Date:   Wed, 27 Nov 2019 21:31:29 +0100
Message-Id: <20191127203023.103702509@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Erwin <james.erwin@intel.com>

If an hfi1 card is inserted in a Gen4 systems, the driver will avoid the
gen3 speed bump and the card will operate at half speed.

This is because the driver avoids the gen3 speed bump when the parent bus
speed isn't identical to gen3, 8.0GT/s.  This is not compatible with gen4
and newer speeds.

Fix by relaxing the test to explicitly look for the lower capability
speeds which inherently allows for gen4 and all future speeds.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Link: https://lore.kernel.org/r/20191101192059.106248.1699.stgit@awfm-01.aw.intel.com
Cc: <stable@vger.kernel.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: James Erwin <james.erwin@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rdma/hfi1/pcie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index a956044459a2b..ea4df848d8405 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -389,7 +389,8 @@ int pcie_speeds(struct hfi1_devdata *dd)
 	/*
 	 * bus->max_bus_speed is set from the bridge's linkcap Max Link Speed
 	 */
-	if (dd->pcidev->bus->max_bus_speed != PCIE_SPEED_8_0GT) {
+	if (dd->pcidev->bus->max_bus_speed == PCIE_SPEED_2_5GT ||
+	     dd->pcidev->bus->max_bus_speed == PCIE_SPEED_5_0GT) {
 		dd_dev_info(dd, "Parent PCIe bridge does not support Gen3\n");
 		dd->link_gen3_capable = 0;
 	}
-- 
2.20.1



