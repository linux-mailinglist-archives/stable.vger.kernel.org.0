Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA01194475
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 17:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgCZQiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 12:38:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:5990 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728631AbgCZQiS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 12:38:18 -0400
IronPort-SDR: BoiD7Z2RJ+7WPhH43tiIO8Fwaha9rpzLfsnO1BCanFzi9gSErqMAe9utfiSLkLgdmaY32diMMS
 cVGn+hzuDi2w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 09:38:17 -0700
IronPort-SDR: ntlAm4u21krpsxfqNrq1wULGeWs5TMGVdxghH+Ck+PZn+/sEq+YNqYEZz/jP6blPm0deGR/ft+
 2xjyVyp976Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="250843951"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by orsmga006.jf.intel.com with ESMTP; 26 Mar 2020 09:38:16 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id 02QGcFXf004634;
        Thu, 26 Mar 2020 09:38:15 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id 02QGcENu021350;
        Thu, 26 Mar 2020 12:38:14 -0400
Subject: [PATCH for-rc 2/2] IB/hfi1: Call kobject_put() when
 kobject_init_and_add() fails
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Date:   Thu, 26 Mar 2020 12:38:14 -0400
Message-ID: <20200326163813.21129.44280.stgit@awfm-01.aw.intel.com>
In-Reply-To: <20200326163619.21129.13002.stgit@awfm-01.aw.intel.com>
References: <20200326163619.21129.13002.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

When kobject_init_and_add() returns an error in the function
hfi1_create_port_files(), the function kobject_put() is not called for
the corresponding kobject, which potentially leads to memory leak.

This patch fixes the issue by calling kobject_put() even if
kobject_init_and_add() fails.

Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/sysfs.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/sysfs.c b/drivers/infiniband/hw/hfi1/sysfs.c
index f1bcecf..074ec71 100644
--- a/drivers/infiniband/hw/hfi1/sysfs.c
+++ b/drivers/infiniband/hw/hfi1/sysfs.c
@@ -674,7 +674,11 @@ int hfi1_create_port_files(struct ib_device *ibdev, u8 port_num,
 		dd_dev_err(dd,
 			   "Skipping sc2vl sysfs info, (err %d) port %u\n",
 			   ret, port_num);
-		goto bail;
+		/*
+		 * Based on the documentation for kobject_init_and_add(), the
+		 * caller should call kobject_put even if this call fails.
+		 */
+		goto bail_sc2vl;
 	}
 	kobject_uevent(&ppd->sc2vl_kobj, KOBJ_ADD);
 
@@ -684,7 +688,7 @@ int hfi1_create_port_files(struct ib_device *ibdev, u8 port_num,
 		dd_dev_err(dd,
 			   "Skipping sl2sc sysfs info, (err %d) port %u\n",
 			   ret, port_num);
-		goto bail_sc2vl;
+		goto bail_sl2sc;
 	}
 	kobject_uevent(&ppd->sl2sc_kobj, KOBJ_ADD);
 
@@ -694,7 +698,7 @@ int hfi1_create_port_files(struct ib_device *ibdev, u8 port_num,
 		dd_dev_err(dd,
 			   "Skipping vl2mtu sysfs info, (err %d) port %u\n",
 			   ret, port_num);
-		goto bail_sl2sc;
+		goto bail_vl2mtu;
 	}
 	kobject_uevent(&ppd->vl2mtu_kobj, KOBJ_ADD);
 
@@ -704,7 +708,7 @@ int hfi1_create_port_files(struct ib_device *ibdev, u8 port_num,
 		dd_dev_err(dd,
 			   "Skipping Congestion Control sysfs info, (err %d) port %u\n",
 			   ret, port_num);
-		goto bail_vl2mtu;
+		goto bail_cc;
 	}
 
 	kobject_uevent(&ppd->pport_cc_kobj, KOBJ_ADD);
@@ -742,7 +746,6 @@ int hfi1_create_port_files(struct ib_device *ibdev, u8 port_num,
 	kobject_put(&ppd->sl2sc_kobj);
 bail_sc2vl:
 	kobject_put(&ppd->sc2vl_kobj);
-bail:
 	return ret;
 }
 

