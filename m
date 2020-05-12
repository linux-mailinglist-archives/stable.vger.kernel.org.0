Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5B51CEB3A
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 05:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgELDNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 23:13:31 -0400
Received: from mga05.intel.com ([192.55.52.43]:42317 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727942AbgELDNb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 23:13:31 -0400
IronPort-SDR: 79TVY49VI2ZB9LvKUzfW/7CZAHyPV8du9GvJtJaair2M5lHtD4g+MIWgWd01PP6LnLv7JBAABN
 qFSd3r2AWaOg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 20:13:30 -0700
IronPort-SDR: /SBuS1it4DqOMLaaFyDedFDA+ktvEAJGvmSTQ0qabGVEk3X1jMu2Pv7OqM84pnDVGNJwkXb/ZH
 wcDW8iUMtARQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,381,1583222400"; 
   d="scan'208";a="436921207"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by orsmga005.jf.intel.com with ESMTP; 11 May 2020 20:13:30 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id 04C3DTIM043355;
        Mon, 11 May 2020 20:13:29 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id 04C3DSCp190333;
        Mon, 11 May 2020 23:13:28 -0400
Subject: [PATCH for-rc or next 3/3] IB/qib: Call kobject_put() when
 kobject_init_and_add() fails
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Date:   Mon, 11 May 2020 23:13:28 -0400
Message-ID: <20200512031328.189865.48627.stgit@awfm-01.aw.intel.com>
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

When kobject_init_and_add() returns an error in the function
qib_create_port_files(), the function kobject_put() is not called for
the corresponding kobject, which potentially leads to memory leak.

This patch fixes the issue by calling kobject_put() even if
kobject_init_and_add() fails. In addition, the ppd->diagc_kobj is
released along with other kobjects when the sysfs is unregistered.

Fixes: f931551bafe1 ("IB/qib: Add new qib driver for QLogic PCIe InfiniBand adapters")
Cc: <stable@vger.kernel.org>
Suggested-by: Lin Yi <teroincn@gmail.com>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/qib/qib_sysfs.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/drivers/infiniband/hw/qib/qib_sysfs.c
index 568b21e..021df06 100644
--- a/drivers/infiniband/hw/qib/qib_sysfs.c
+++ b/drivers/infiniband/hw/qib/qib_sysfs.c
@@ -760,7 +760,7 @@ int qib_create_port_files(struct ib_device *ibdev, u8 port_num,
 		qib_dev_err(dd,
 			"Skipping linkcontrol sysfs info, (err %d) port %u\n",
 			ret, port_num);
-		goto bail;
+		goto bail_link;
 	}
 	kobject_uevent(&ppd->pport_kobj, KOBJ_ADD);
 
@@ -770,7 +770,7 @@ int qib_create_port_files(struct ib_device *ibdev, u8 port_num,
 		qib_dev_err(dd,
 			"Skipping sl2vl sysfs info, (err %d) port %u\n",
 			ret, port_num);
-		goto bail_link;
+		goto bail_sl;
 	}
 	kobject_uevent(&ppd->sl2vl_kobj, KOBJ_ADD);
 
@@ -780,7 +780,7 @@ int qib_create_port_files(struct ib_device *ibdev, u8 port_num,
 		qib_dev_err(dd,
 			"Skipping diag_counters sysfs info, (err %d) port %u\n",
 			ret, port_num);
-		goto bail_sl;
+		goto bail_diagc;
 	}
 	kobject_uevent(&ppd->diagc_kobj, KOBJ_ADD);
 
@@ -793,7 +793,7 @@ int qib_create_port_files(struct ib_device *ibdev, u8 port_num,
 		qib_dev_err(dd,
 		 "Skipping Congestion Control sysfs info, (err %d) port %u\n",
 		 ret, port_num);
-		goto bail_diagc;
+		goto bail_cc;
 	}
 
 	kobject_uevent(&ppd->pport_cc_kobj, KOBJ_ADD);
@@ -854,6 +854,7 @@ void qib_verbs_unregister_sysfs(struct qib_devdata *dd)
 				&cc_table_bin_attr);
 			kobject_put(&ppd->pport_cc_kobj);
 		}
+		kobject_put(&ppd->diagc_kobj);
 		kobject_put(&ppd->sl2vl_kobj);
 		kobject_put(&ppd->pport_kobj);
 	}

