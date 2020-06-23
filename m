Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03AB206040
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403818AbgFWUk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:40:57 -0400
Received: from mga06.intel.com ([134.134.136.31]:5408 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392300AbgFWUk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:40:56 -0400
IronPort-SDR: 0uUS2beWsxHPSIBNNZFDCtTOiMx/saBBUi15AhTLCvwYcq35Gare1abNCqf4W1jIoqBuTK6ZHR
 fqWef0KUV+HA==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="205726880"
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="205726880"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 13:40:56 -0700
IronPort-SDR: x9woLDGMgUAiCdsLSPHe9Zmun2pEUmkopE64g0gfimRVOlLnK2MnyhR7zHPRZ8vmWQ9/ZZ/Noz
 cEeDX+6lCkQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="310581301"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by orsmga008.jf.intel.com with ESMTP; 23 Jun 2020 13:40:55 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id 05NKetPt057577;
        Tue, 23 Jun 2020 13:40:55 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id 05NKereZ107991;
        Tue, 23 Jun 2020 16:40:53 -0400
Subject: [PATCH for-rc v2 2/2] IB/hfi1: Do not destroy link_wq when the
 device is shut down
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Date:   Tue, 23 Jun 2020 16:40:53 -0400
Message-ID: <20200623204053.107638.70315.stgit@awfm-01.aw.intel.com>
In-Reply-To: <20200623203524.107638.62465.stgit@awfm-01.aw.intel.com>
References: <20200623203524.107638.62465.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

The workqueue link_wq should only be destroyed when the hfi1 driver
is unloaded, not when the device is shut down.

Fixes: 71d47008ca1b ("IB/hfi1: Create workqueue for link events")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>

---
Changes since v1:
  - Rebased on the first patch.
---
 drivers/infiniband/hw/hfi1/init.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 16d6788..cb7ad12 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -846,6 +846,10 @@ static void destroy_workqueues(struct hfi1_devdata *dd)
 			destroy_workqueue(ppd->hfi1_wq);
 			ppd->hfi1_wq = NULL;
 		}
+		if (ppd->link_wq) {
+			destroy_workqueue(ppd->link_wq);
+			ppd->link_wq = NULL;
+		}
 	}
 }
 
@@ -1122,14 +1126,10 @@ static void shutdown_device(struct hfi1_devdata *dd)
 		 * We can't count on interrupts since we are stopping.
 		 */
 		hfi1_quiet_serdes(ppd);
-
 		if (ppd->hfi1_wq)
 			flush_workqueue(ppd->hfi1_wq);
-		if (ppd->link_wq) {
+		if (ppd->link_wq)
 			flush_workqueue(ppd->link_wq);
-			destroy_workqueue(ppd->link_wq);
-			ppd->link_wq = NULL;
-		}
 	}
 	sdma_exit(dd);
 }

