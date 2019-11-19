Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5FB2101571
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbfKSFoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:44:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:39526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729643AbfKSFoN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:44:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 660A32075E;
        Tue, 19 Nov 2019 05:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142252;
        bh=Ac5B6XUO63g1mIXDroLKb2RIGZiAiNvL0SvzwLi+qa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xzgrS8D9e0SLcXVDLJVPn695Pcow4DDoitYuKpUaFKzoGy7lqv+y9VY88Sh2kXzZU
         +7swJeA7+ABgl9kMwqPwp8iMBeTgaDART9vbjt1NKphzpP4de/402gBjwoYecvZTHs
         TGGLKFmeUomxPQ5m87bNWgZ9BymcaI3dm4TwSugk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        James Erwin <james.erwin@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.14 019/239] IB/hfi1: Ensure full Gen3 speed in a Gen4 system
Date:   Tue, 19 Nov 2019 06:16:59 +0100
Message-Id: <20191119051301.427742030@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Erwin <james.erwin@intel.com>

commit a9c3c4c597704b3a1a2b9bef990e7d8a881f6533 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/pcie.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/hfi1/pcie.c
+++ b/drivers/infiniband/hw/hfi1/pcie.c
@@ -327,7 +327,9 @@ int pcie_speeds(struct hfi1_devdata *dd)
 	/*
 	 * bus->max_bus_speed is set from the bridge's linkcap Max Link Speed
 	 */
-	if (parent && dd->pcidev->bus->max_bus_speed != PCIE_SPEED_8_0GT) {
+	if (parent &&
+	    (dd->pcidev->bus->max_bus_speed == PCIE_SPEED_2_5GT ||
+	     dd->pcidev->bus->max_bus_speed == PCIE_SPEED_5_0GT)) {
 		dd_dev_info(dd, "Parent PCIe bridge does not support Gen3\n");
 		dd->link_gen3_capable = 0;
 	}


