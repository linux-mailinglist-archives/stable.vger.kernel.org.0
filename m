Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2074340DF3B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbhIPQHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234178AbhIPQHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:07:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 316F661246;
        Thu, 16 Sep 2021 16:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808357;
        bh=MYTX7ZWAhoBW3unKg0JSbOFyuECije2MweeOMD8x40g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t//CT+V8s3I7b+0HioGkVATt6de6mkfRZEFK5efGrDDQ80ENd11gsNJ87cLmXLbY8
         pu9liCyPrVwONxenwz8XbH4S3ai6ZPrY+jkBpKqz1U2bnGWF2CMxrbqbSH7fzbAZz3
         1rsH1i62gbf6DoIsk+IMIwey3x/iKpOqYjb5+DAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Collier <josh.d.collier@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/306] IB/hfi1: Adjust pkey entry in index 0
Date:   Thu, 16 Sep 2021 17:56:45 +0200
Message-Id: <20210916155755.987677504@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
index 786c6316273f..b6e453e9ba23 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -650,12 +650,7 @@ void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
 
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



