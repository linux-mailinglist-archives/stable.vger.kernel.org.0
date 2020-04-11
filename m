Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 324FC1A4FBB
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgDKMLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:11:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbgDKMLM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:11:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 823DE20787;
        Sat, 11 Apr 2020 12:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607071;
        bh=aDGK5rQcXBA9uGsDFP25cA3dCh5xzG68JG0usjQxYLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbJpzsDqQkUndtEcFHPJn+WL7Xp1QktLIebKKP2lxpMWEcieKTcODh3NEsVyaUOaq
         Swxuvh2TUzLU5vCER/FgX5EcZiG4oZJlAB3AFTTEYsReqDTsNuQYxJpQqUWfhd74zi
         CU32y+qjWhVylku97JA+H+x1I7P97O75MGy1NewE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.4 25/29] IB/hfi1: Call kobject_put() when kobject_init_and_add() fails
Date:   Sat, 11 Apr 2020 14:08:55 +0200
Message-Id: <20200411115412.036558577@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115407.651296755@linuxfoundation.org>
References: <20200411115407.651296755@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

commit dfb5394f804ed4fcea1fc925be275a38d66712ab upstream.

When kobject_init_and_add() returns an error in the function
hfi1_create_port_files(), the function kobject_put() is not called for the
corresponding kobject, which potentially leads to memory leak.

This patch fixes the issue by calling kobject_put() even if
kobject_init_and_add() fails.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200326163813.21129.44280.stgit@awfm-01.aw.intel.com
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rdma/hfi1/sysfs.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/staging/rdma/hfi1/sysfs.c
+++ b/drivers/staging/rdma/hfi1/sysfs.c
@@ -620,7 +620,11 @@ int hfi1_create_port_files(struct ib_dev
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
 
@@ -630,7 +634,7 @@ int hfi1_create_port_files(struct ib_dev
 		dd_dev_err(dd,
 			   "Skipping sl2sc sysfs info, (err %d) port %u\n",
 			   ret, port_num);
-		goto bail_sc2vl;
+		goto bail_sl2sc;
 	}
 	kobject_uevent(&ppd->sl2sc_kobj, KOBJ_ADD);
 
@@ -640,7 +644,7 @@ int hfi1_create_port_files(struct ib_dev
 		dd_dev_err(dd,
 			   "Skipping vl2mtu sysfs info, (err %d) port %u\n",
 			   ret, port_num);
-		goto bail_sl2sc;
+		goto bail_vl2mtu;
 	}
 	kobject_uevent(&ppd->vl2mtu_kobj, KOBJ_ADD);
 
@@ -651,7 +655,7 @@ int hfi1_create_port_files(struct ib_dev
 		dd_dev_err(dd,
 		 "Skipping Congestion Control sysfs info, (err %d) port %u\n",
 		 ret, port_num);
-		goto bail_vl2mtu;
+		goto bail_cc;
 	}
 
 	kobject_uevent(&ppd->pport_cc_kobj, KOBJ_ADD);
@@ -691,7 +695,6 @@ bail_sl2sc:
 	kobject_put(&ppd->sl2sc_kobj);
 bail_sc2vl:
 	kobject_put(&ppd->sc2vl_kobj);
-bail:
 	return ret;
 }
 


