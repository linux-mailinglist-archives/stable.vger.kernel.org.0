Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34E01CEB38
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 05:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbgELDNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 23:13:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:45744 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727942AbgELDNZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 23:13:25 -0400
IronPort-SDR: J/3wESodKtWFndSYsePy/jtE6vggWTvIfnVzt3ecSKzpYVC/E0vQq6XoF8fddCYlsNENBDNRaX
 ovZ3j2tUKvdw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 20:13:24 -0700
IronPort-SDR: 1kezfB2QDv5fHUvAycjpns52H2FaSMCcoRcZjDFa7bkCganoJ/dFrRE1ivxasnCOzEcN/ZO0IP
 KRTYPF7/JpPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,381,1583222400"; 
   d="scan'208";a="251339650"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by fmsmga007.fm.intel.com with ESMTP; 11 May 2020 20:13:23 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id 04C3DNEo043352;
        Mon, 11 May 2020 20:13:23 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id 04C3DMEU190318;
        Mon, 11 May 2020 23:13:22 -0400
Subject: [PATCH for-rc or next 2/3] IB/hfi1: Do not destroy link_wq when the
 device is shut down
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Date:   Mon, 11 May 2020 23:13:22 -0400
Message-ID: <20200512031322.189865.4129.stgit@awfm-01.aw.intel.com>
In-Reply-To: <20200512030622.189865.65024.stgit@awfm-01.aw.intel.com>
References: <20200512030622.189865.65024.stgit@awfm-01.aw.intel.com>
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
 drivers/infiniband/hw/hfi1/init.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 10fb5c6..49a4566 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -844,6 +844,10 @@ static void destroy_workqueues(struct hfi1_devdata *dd)
 			destroy_workqueue(ppd->hfi1_wq);
 			ppd->hfi1_wq = NULL;
 		}
+		if (ppd->link_wq) {
+			destroy_workqueue(ppd->link_wq);
+			ppd->link_wq = NULL;
+		}
 	}
 }
 
@@ -1120,11 +1124,6 @@ static void shutdown_device(struct hfi1_devdata *dd)
 		 * We can't count on interrupts since we are stopping.
 		 */
 		hfi1_quiet_serdes(ppd);
-
-		if (ppd->link_wq) {
-			destroy_workqueue(ppd->link_wq);
-			ppd->link_wq = NULL;
-		}
 	}
 	sdma_exit(dd);
 }

