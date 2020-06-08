Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA681F2427
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730629AbgFHXSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:18:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730185AbgFHXSY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:18:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 223FC20872;
        Mon,  8 Jun 2020 23:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658304;
        bh=XO+oMWgl804ly3oZq6jef/75wIN+ikeQHz5cht/6Jlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xm/hTo4KHT86N5nV05g54s5fOho83plsj5/n++8MTJ79cx5ojVYBaI640N4BaAuTg
         errbVSAbboX1rm/pDJkgTede2JsuSAgDcl3LV03fdFaETDQvt1SPi14ZpfYyYnp1xX
         5iefqXaYjmuaYxzFSKr7ZjxQqztdss8ulfPmg2qo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kaike Wan <kaike.wan@intel.com>, Lin Yi <teroincn@gmail.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 306/606] IB/qib: Call kobject_put() when kobject_init_and_add() fails
Date:   Mon,  8 Jun 2020 19:07:11 -0400
Message-Id: <20200608231211.3363633-306-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

[ Upstream commit a35cd6447effd5c239b564c80fa109d05ff3d114 ]

When kobject_init_and_add() returns an error in the function
qib_create_port_files(), the function kobject_put() is not called for the
corresponding kobject, which potentially leads to memory leak.

This patch fixes the issue by calling kobject_put() even if
kobject_init_and_add() fails. In addition, the ppd->diagc_kobj is released
along with other kobjects when the sysfs is unregistered.

Fixes: f931551bafe1 ("IB/qib: Add new qib driver for QLogic PCIe InfiniBand adapters")
Link: https://lore.kernel.org/r/20200512031328.189865.48627.stgit@awfm-01.aw.intel.com
Cc: <stable@vger.kernel.org>
Suggested-by: Lin Yi <teroincn@gmail.com>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qib/qib_sysfs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/drivers/infiniband/hw/qib/qib_sysfs.c
index 568b21eb6ea1..021df0654ba7 100644
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
-- 
2.25.1

