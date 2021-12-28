Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0C048074D
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 09:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235549AbhL1IVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 03:21:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:9047 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235547AbhL1IVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Dec 2021 03:21:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640679663; x=1672215663;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AIBLrEpmeumF4RV008nDuADBqcjGVk+Xt88TWCgW/xY=;
  b=dT2ixvfpGV+v3NPRLX68PQSxhoNc9rRcK0hw+xPu377tq9yrHbO6h0kZ
   bCT2rN4IeH5KHPnmzpQ6fwLriX5CyhgFAjAc/5gB69US4sTUpLMquYixI
   XSx0tCH6gWw473XALLQq9wTh+glCVL8A3QPflKjNPpQrm00STiglnpvxx
   GxI4QdxkIFgAwBrtt69i8z+ynIuxQlZo+ZHvBjFoANXJmL6F/EI71M2eC
   eaCdAxInwHl8wDypJJdxQEY9f+EJXrAh+NA/YCiHoNt3pgfyQW6PGPYzC
   tQkwKuq/cyCveQaxKRBV5ltmCssMemcXFfPxkMa02QSX3fc6YmrYFzLMK
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10210"; a="241134462"
X-IronPort-AV: E=Sophos;i="5.88,241,1635231600"; 
   d="scan'208";a="241134462"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2021 00:21:03 -0800
X-IronPort-AV: E=Sophos;i="5.88,241,1635231600"; 
   d="scan'208";a="523558623"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.141])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2021 00:21:00 -0800
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        Vitaly Lubart <vitaly.lubart@intel.com>,
        linux-kernel@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        stable@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: hbm: fix client dma reply status
Date:   Tue, 28 Dec 2021 10:20:47 +0200
Message-Id: <20211228082047.378115-1-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Don't blindly copy status value received from the firmware
into internal client status field,
It may be positive and ERR_PTR(ret) will translate it
into an invalid address and the caller will crash.

Put the error code into the client status on failure.

Fixes: 369aea845951 ("mei: implement client dma setup.")
Reported-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: <stable@vger.kernel.org> # v5.11+
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index be41843df75b..cebcca6d6d3e 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -672,10 +672,14 @@ static void mei_hbm_cl_dma_map_res(struct mei_device *dev,
 	if (!cl)
 		return;
 
-	dev_dbg(dev->dev, "cl dma map result = %d\n", res->status);
-	cl->status = res->status;
-	if (!cl->status)
+	if (res->status) {
+		dev_err(dev->dev, "cl dma map failed %d\n", res->status);
+		cl->status = -EFAULT;
+	} else {
+		dev_dbg(dev->dev, "cl dma map succeeded\n");
 		cl->dma_mapped = 1;
+		cl->status = 0;
+	}
 	wake_up(&cl->wait);
 }
 
@@ -698,10 +702,14 @@ static void mei_hbm_cl_dma_unmap_res(struct mei_device *dev,
 	if (!cl)
 		return;
 
-	dev_dbg(dev->dev, "cl dma unmap result = %d\n", res->status);
-	cl->status = res->status;
-	if (!cl->status)
+	if (res->status) {
+		dev_err(dev->dev, "cl dma unmap failed %d\n", res->status);
+		cl->status = -EFAULT;
+	} else {
+		dev_dbg(dev->dev, "cl dma unmap succeeded\n");
 		cl->dma_mapped = 0;
+		cl->status = 0;
+	}
 	wake_up(&cl->wait);
 }
 
-- 
2.31.1

