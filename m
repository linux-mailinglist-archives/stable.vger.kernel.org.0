Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE59811B1
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfHEFha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:37:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55783 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfHEFha (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:37:30 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B931920C86;
        Mon,  5 Aug 2019 01:37:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:37:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2d+fUA
        mUMppvBq3ni2LV6Bz5JRwdWf6vwP1JTm5DyG8=; b=eREpdaIuRNJw/mctbiMCoh
        3xqUCeyJV8zAhWpixs+Fw9649qRa902IzuYVP4f5lsVkIgCAM4BukB+n5cQ6Iy8J
        AZpIH41+2AA2ztG6/B8LMiiC2XJx4ZHRJg+OaIZuwFdzQ0GAWhS8LR5RSCMJJFYU
        U+qrpgHcVPdtmOVenO61JdApryb3vxj3UpdRPnEXmLo5MdObQlfZtjs+8GaT1uVK
        +Yz851r4a/EG6vJq51UWhK4j9b7JlX9zUpljOCU4tvQDusiqWbOItMl78rwHkHsf
        KSSE/RPxOOfhhq0JOxay+Af9OmBlb910OmUkU9F5YZnyVl0xdUKask2PompvXtvQ
        ==
X-ME-Sender: <xms:mcBHXeclXyDqEVK9tOvb9vv5OsKjxBTLtZtYAQkkNp8HIgd5q3deUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeej
X-ME-Proxy: <xmx:mcBHXYpjJpkNvjFNX--dE6rliv5CdTAThUcFzi6MB1cb3ssRmk8_GQ>
    <xmx:mcBHXQNaBetlrnnt8tN1bwXr5SnXIbH8AcrCT0-5p1Qvqrjn99DSgg>
    <xmx:mcBHXTjstezXfNPAKr3Va5FZjhVEcFAbzjmlCpYTST4tRKahB5bHIg>
    <xmx:mcBHXT63M1nyDBIjoYyDbeL0ga4Tw70-oVi3YC545FztoQGoyMS4pA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1B2ED80059;
        Mon,  5 Aug 2019 01:37:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/hfi1: Check for error on call to alloc_rsm_map_table" failed to apply to 4.9-stable tree
To:     john.fleck@intel.com, jgg@mellanox.com, mike.marciniszyn@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:37:27 +0200
Message-ID: <156498344719618@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cd48a82087231fdba0e77521102386c6ed0168d6 Mon Sep 17 00:00:00 2001
From: John Fleck <john.fleck@intel.com>
Date: Mon, 15 Jul 2019 12:45:21 -0400
Subject: [PATCH] IB/hfi1: Check for error on call to alloc_rsm_map_table

The call to alloc_rsm_map_table does not check if the kmalloc fails.
Check for a NULL on alloc, and bail if it fails.

Fixes: 372cc85a13c9 ("IB/hfi1: Extract RSM map table init from QOS")
Link: https://lore.kernel.org/r/20190715164521.74174.27047.stgit@awfm-01.aw.intel.com
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: John Fleck <john.fleck@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index d5b643a1d9fd..67052dc3100c 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -14452,7 +14452,7 @@ void hfi1_deinit_vnic_rsm(struct hfi1_devdata *dd)
 		clear_rcvctrl(dd, RCV_CTRL_RCV_RSM_ENABLE_SMASK);
 }
 
-static void init_rxe(struct hfi1_devdata *dd)
+static int init_rxe(struct hfi1_devdata *dd)
 {
 	struct rsm_map_table *rmt;
 	u64 val;
@@ -14461,6 +14461,9 @@ static void init_rxe(struct hfi1_devdata *dd)
 	write_csr(dd, RCV_ERR_MASK, ~0ull);
 
 	rmt = alloc_rsm_map_table(dd);
+	if (!rmt)
+		return -ENOMEM;
+
 	/* set up QOS, including the QPN map table */
 	init_qos(dd, rmt);
 	init_fecn_handling(dd, rmt);
@@ -14487,6 +14490,7 @@ static void init_rxe(struct hfi1_devdata *dd)
 	val |= ((4ull & RCV_BYPASS_HDR_SIZE_MASK) <<
 		RCV_BYPASS_HDR_SIZE_SHIFT);
 	write_csr(dd, RCV_BYPASS, val);
+	return 0;
 }
 
 static void init_other(struct hfi1_devdata *dd)
@@ -15024,7 +15028,10 @@ int hfi1_init_dd(struct hfi1_devdata *dd)
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

