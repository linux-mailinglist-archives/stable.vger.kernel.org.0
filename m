Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F98C1EA91D
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgFAR6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:58:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729166AbgFAR6U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:58:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D5D42077D;
        Mon,  1 Jun 2020 17:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034299;
        bh=6LefHzvUIAUrbqMU+zrcftUJaKiEVuC7+lGsCMX0KfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1NAu9NG0RFs/+2b45MuLXb0oU/Wl+R8xZqp4v4FU644GCo+p8otA4rUbKPyPP3lX6
         DMvg6Uau+BaF/zRuhQMVey5InSaCk75GyG5eB6yi5jvZAH+SuU1gXkCvlKizn9CIpA
         8rFGdhUIzPUX4TeX3IMdCer7mc+zUyuJEvBenorA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Yi <teroincn@gmail.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 30/61] IB/qib: Call kobject_put() when kobject_init_and_add() fails
Date:   Mon,  1 Jun 2020 19:53:37 +0200
Message-Id: <20200601174017.385450957@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174010.316778377@linuxfoundation.org>
References: <20200601174010.316778377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8ce0f6eef89e..b9d653afff8b 100644
--- a/drivers/infiniband/hw/qib/qib_sysfs.c
+++ b/drivers/infiniband/hw/qib/qib_sysfs.c
@@ -756,7 +756,7 @@ int qib_create_port_files(struct ib_device *ibdev, u8 port_num,
 		qib_dev_err(dd,
 			"Skipping linkcontrol sysfs info, (err %d) port %u\n",
 			ret, port_num);
-		goto bail;
+		goto bail_link;
 	}
 	kobject_uevent(&ppd->pport_kobj, KOBJ_ADD);
 
@@ -766,7 +766,7 @@ int qib_create_port_files(struct ib_device *ibdev, u8 port_num,
 		qib_dev_err(dd,
 			"Skipping sl2vl sysfs info, (err %d) port %u\n",
 			ret, port_num);
-		goto bail_link;
+		goto bail_sl;
 	}
 	kobject_uevent(&ppd->sl2vl_kobj, KOBJ_ADD);
 
@@ -776,7 +776,7 @@ int qib_create_port_files(struct ib_device *ibdev, u8 port_num,
 		qib_dev_err(dd,
 			"Skipping diag_counters sysfs info, (err %d) port %u\n",
 			ret, port_num);
-		goto bail_sl;
+		goto bail_diagc;
 	}
 	kobject_uevent(&ppd->diagc_kobj, KOBJ_ADD);
 
@@ -789,7 +789,7 @@ int qib_create_port_files(struct ib_device *ibdev, u8 port_num,
 		qib_dev_err(dd,
 		 "Skipping Congestion Control sysfs info, (err %d) port %u\n",
 		 ret, port_num);
-		goto bail_diagc;
+		goto bail_cc;
 	}
 
 	kobject_uevent(&ppd->pport_cc_kobj, KOBJ_ADD);
@@ -871,6 +871,7 @@ void qib_verbs_unregister_sysfs(struct qib_devdata *dd)
 				&cc_table_bin_attr);
 			kobject_put(&ppd->pport_cc_kobj);
 		}
+		kobject_put(&ppd->diagc_kobj);
 		kobject_put(&ppd->sl2vl_kobj);
 		kobject_put(&ppd->pport_kobj);
 	}
-- 
2.25.1



