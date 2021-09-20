Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9B6412187
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350627AbhITSGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356954AbhITSCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:02:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38AEB6322D;
        Mon, 20 Sep 2021 17:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158184;
        bh=RVsQENPII5gI9SJod3iH8WlFbUt+eBnULnZfSW+HNqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1kZH2yzaOIEB/+sVdtgZCDFS++HaJcRvgIc+gbX3gRYfBrKb95Gd4iZTzoK8PonjH
         JFOK0PvYdJfqUFULoOEJX7Tlc6jgOabMmrOBKT3p2aFHpeH3sV7OnXoencEVGGgiMQ
         4WjqFZyXMc/eH+Ymq+rhCO1f2K48d7WEoI4UuT5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Collier <josh.d.collier@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/260] IB/hfi1: Adjust pkey entry in index 0
Date:   Mon, 20 Sep 2021 18:40:57 +0200
Message-Id: <20210920163932.447480767@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

[ Upstream commit 62004871e1fa7f9a60797595c03477af5b5ec36f ]

It is possible for the primary IPoIB network device associated with any
RDMA device to fail to join certain multicast groups preventing IPv6
neighbor discovery and possibly other network ULPs from working
correctly. The IPv4 broadcast group is not affected as the IPoIB network
device handles joining that multicast group directly.

This is because the primary IPoIB network device uses the pkey at ndex 0
in the associated RDMA device's pkey table. Anytime the pkey value of
index 0 changes, the primary IPoIB network device automatically modifies
it's broadcast address (i.e. /sys/class/net/[ib0]/broadcast), since the
broadcast address includes the pkey value, and then bounces carrier. This
includes initial pkey assignment, such as when the pkey at index 0
transitions from the opa default of invalid (0x0000) to some value such as
the OPA default pkey for Virtual Fabric 0: 0x8001 or when the fabric
manager is restarted with a configuration change causing the pkey at index
0 to change. Many network ULPs are not sensitive to the carrier bounce and
are not expecting the broadcast address to change including the linux IPv6
stack.  This problem does not affect IPoIB child network devices as their
pkey value is constant for all time.

To mitigate this issue, change the default pkey in at index 0 to 0x8001 to
cover the predominant case and avoid issues as ipoib comes up and the FM
sweeps.

At some point, ipoib multicast support should automatically fix
non-broadcast addresses as it does with the primary broadcast address.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Link: https://lore.kernel.org/r/20210715160445.142451.47651.stgit@awfm-01.cornelisnetworks.com
Suggested-by: Josh Collier <josh.d.collier@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/init.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index fbff6b2f00e7..1256dbd5b2ef 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -664,12 +664,7 @@ void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
 
 	ppd->pkeys[default_pkey_idx] = DEFAULT_P_KEY;
 	ppd->part_enforce |= HFI1_PART_ENFORCE_IN;
-
-	if (loopback) {
-		dd_dev_err(dd, "Faking data partition 0x8001 in idx %u\n",
-			   !default_pkey_idx);
-		ppd->pkeys[!default_pkey_idx] = 0x8001;
-	}
+	ppd->pkeys[0] = 0x8001;
 
 	INIT_WORK(&ppd->link_vc_work, handle_verify_cap);
 	INIT_WORK(&ppd->link_up_work, handle_link_up);
-- 
2.30.2



