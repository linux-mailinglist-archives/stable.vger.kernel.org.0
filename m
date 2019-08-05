Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2778981CBE
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731271AbfHENZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730661AbfHENZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:25:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2CF220644;
        Mon,  5 Aug 2019 13:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011541;
        bh=jEn+wxUjfcgpGi49PFhTR5A1N/uFke//IAptykdhFCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pvdKtic7ODzpiIWC6wVl6P68CyjXC1f1/7XpbsyQE5xTRHbF/IKJtc5/1hHhYLYji
         TMdUOwoM/r+/u0Ac9btiE8oWVxVCXpskv6roTcE83GZlW08134u0UC2CdJ6ce7z2BA
         zIpXyWnVa1O//tmA6G2fRnHiDLbekjplABACQNog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        John Fleck <john.fleck@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.2 127/131] IB/hfi1: Check for error on call to alloc_rsm_map_table
Date:   Mon,  5 Aug 2019 15:03:34 +0200
Message-Id: <20190805125000.483589754@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fleck <john.fleck@intel.com>

commit cd48a82087231fdba0e77521102386c6ed0168d6 upstream.

The call to alloc_rsm_map_table does not check if the kmalloc fails.
Check for a NULL on alloc, and bail if it fails.

Fixes: 372cc85a13c9 ("IB/hfi1: Extract RSM map table init from QOS")
Link: https://lore.kernel.org/r/20190715164521.74174.27047.stgit@awfm-01.aw.intel.com
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: John Fleck <john.fleck@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/chip.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -14452,7 +14452,7 @@ void hfi1_deinit_vnic_rsm(struct hfi1_de
 		clear_rcvctrl(dd, RCV_CTRL_RCV_RSM_ENABLE_SMASK);
 }
 
-static void init_rxe(struct hfi1_devdata *dd)
+static int init_rxe(struct hfi1_devdata *dd)
 {
 	struct rsm_map_table *rmt;
 	u64 val;
@@ -14461,6 +14461,9 @@ static void init_rxe(struct hfi1_devdata
 	write_csr(dd, RCV_ERR_MASK, ~0ull);
 
 	rmt = alloc_rsm_map_table(dd);
+	if (!rmt)
+		return -ENOMEM;
+
 	/* set up QOS, including the QPN map table */
 	init_qos(dd, rmt);
 	init_fecn_handling(dd, rmt);
@@ -14487,6 +14490,7 @@ static void init_rxe(struct hfi1_devdata
 	val |= ((4ull & RCV_BYPASS_HDR_SIZE_MASK) <<
 		RCV_BYPASS_HDR_SIZE_SHIFT);
 	write_csr(dd, RCV_BYPASS, val);
+	return 0;
 }
 
 static void init_other(struct hfi1_devdata *dd)
@@ -15024,7 +15028,10 @@ int hfi1_init_dd(struct hfi1_devdata *dd
 		goto bail_cleanup;
 
 	/* set initial RXE CSRs */
-	init_rxe(dd);
+	ret = init_rxe(dd);
+	if (ret)
+		goto bail_cleanup;
+
 	/* set initial TXE CSRs */
 	init_txe(dd);
 	/* set initial non-RXE, non-TXE CSRs */


