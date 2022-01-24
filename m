Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B53499626
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353089AbiAXU70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:59:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50404 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442888AbiAXUzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:55:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 277E2B81063;
        Mon, 24 Jan 2022 20:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505D9C340E5;
        Mon, 24 Jan 2022 20:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057736;
        bh=xgcyrFkC9UljTjBgXTXk9Fpz/ONmehoFX52datGdw2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjnNok/L+5aLth2s5ezdHO8/dx7bir9HYXY67SlrvAFcjryCuVu5H3N7pxln0O/wP
         grVUsORK07nd1gus/JieUxI7uLNz5rUMcvyIXKrXydEOk8YhU5fl9eruTa6F1JKQgr
         GIs642dAGICMtft39ifNd0CgxVp2ACasUoGqwz30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.16 0063/1039] cxl/pmem: Fix reference counting for delayed work
Date:   Mon, 24 Jan 2022 19:30:52 +0100
Message-Id: <20220124184127.272839072@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit 08b9e0ab8af48895337192e683de44ab1e1b7427 upstream.

There is a potential race between queue_work() returning and the
queued-work running that could result in put_device() running before
get_device(). Introduce the cxl_nvdimm_bridge_state_work() helper that
takes the reference unconditionally, but drops it if no new work was
queued, to keep the references balanced.

Fixes: 8fdcb1704f61 ("cxl/pmem: Add initial infrastructure for pmem support")
Cc: <stable@vger.kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>
Link: https://lore.kernel.org/r/163553734757.2509761.3305231863616785470.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/pmem.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -266,14 +266,24 @@ static void cxl_nvb_update_state(struct
 	put_device(&cxl_nvb->dev);
 }
 
+static void cxl_nvdimm_bridge_state_work(struct cxl_nvdimm_bridge *cxl_nvb)
+{
+	/*
+	 * Take a reference that the workqueue will drop if new work
+	 * gets queued.
+	 */
+	get_device(&cxl_nvb->dev);
+	if (!queue_work(cxl_pmem_wq, &cxl_nvb->state_work))
+		put_device(&cxl_nvb->dev);
+}
+
 static void cxl_nvdimm_bridge_remove(struct device *dev)
 {
 	struct cxl_nvdimm_bridge *cxl_nvb = to_cxl_nvdimm_bridge(dev);
 
 	if (cxl_nvb->state == CXL_NVB_ONLINE)
 		cxl_nvb->state = CXL_NVB_OFFLINE;
-	if (queue_work(cxl_pmem_wq, &cxl_nvb->state_work))
-		get_device(&cxl_nvb->dev);
+	cxl_nvdimm_bridge_state_work(cxl_nvb);
 }
 
 static int cxl_nvdimm_bridge_probe(struct device *dev)
@@ -294,8 +304,7 @@ static int cxl_nvdimm_bridge_probe(struc
 	}
 
 	cxl_nvb->state = CXL_NVB_ONLINE;
-	if (queue_work(cxl_pmem_wq, &cxl_nvb->state_work))
-		get_device(&cxl_nvb->dev);
+	cxl_nvdimm_bridge_state_work(cxl_nvb);
 
 	return 0;
 }


