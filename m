Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22A98171FBC
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731986AbgB0N4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:57194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731731AbgB0N4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:56:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91CB320578;
        Thu, 27 Feb 2020 13:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811799;
        bh=e/sQeZh+8BceHlQSU/UwtQr85a7ZNGnSTX6Lu/vMDlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOJbWSQihkZPXN7njJFqc2esJN04LAUHn25AjgW36kuseP9yYBGrtaSPeKDhB3UZC
         3qR1OU3fVALp2mEITH34KYrCnjMGwAL23AEuaYqsMxyDzGpgM7JQ6W+pyadK/ENYgs
         ZnZ/0sl79Xd6GHFOe2oQ5uKRXrVfe3RtJksCC8Tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 104/237] IB/hfi1: Add software counter for ctxt0 seq drop
Date:   Thu, 27 Feb 2020 14:35:18 +0100
Message-Id: <20200227132304.586129219@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

[ Upstream commit 5ffd048698ea5139743acd45e8ab388a683642b8 ]

All other code paths increment some form of drop counter.

This was missed in the original implementation.

Fixes: 82c2611daaf0 ("staging/rdma/hfi1: Handle packets with invalid RHF on context 0")
Link: https://lore.kernel.org/r/20200106134228.119356.96828.stgit@awfm-01.aw.intel.com
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/chip.c   | 10 ++++++++++
 drivers/infiniband/hw/hfi1/chip.h   |  1 +
 drivers/infiniband/hw/hfi1/driver.c |  1 +
 drivers/infiniband/hw/hfi1/hfi.h    |  2 ++
 4 files changed, 14 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 4a0b7c0034771..cb5785dda524e 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -1686,6 +1686,14 @@ static u64 access_sw_pio_drain(const struct cntr_entry *entry,
 	return dd->verbs_dev.n_piodrain;
 }
 
+static u64 access_sw_ctx0_seq_drop(const struct cntr_entry *entry,
+				   void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = context;
+
+	return dd->ctx0_seq_drop;
+}
+
 static u64 access_sw_vtx_wait(const struct cntr_entry *entry,
 			      void *context, int vl, int mode, u64 data)
 {
@@ -4246,6 +4254,8 @@ static struct cntr_entry dev_cntrs[DEV_CNTR_LAST] = {
 			    access_sw_cpu_intr),
 [C_SW_CPU_RCV_LIM] = CNTR_ELEM("RcvLimit", 0, 0, CNTR_NORMAL,
 			    access_sw_cpu_rcv_limit),
+[C_SW_CTX0_SEQ_DROP] = CNTR_ELEM("SeqDrop0", 0, 0, CNTR_NORMAL,
+			    access_sw_ctx0_seq_drop),
 [C_SW_VTX_WAIT] = CNTR_ELEM("vTxWait", 0, 0, CNTR_NORMAL,
 			    access_sw_vtx_wait),
 [C_SW_PIO_WAIT] = CNTR_ELEM("PioWait", 0, 0, CNTR_NORMAL,
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index 50b8645d0b876..a88ef2433cea2 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -864,6 +864,7 @@ enum {
 	C_DC_PG_STS_TX_MBE_CNT,
 	C_SW_CPU_INTR,
 	C_SW_CPU_RCV_LIM,
+	C_SW_CTX0_SEQ_DROP,
 	C_SW_VTX_WAIT,
 	C_SW_PIO_WAIT,
 	C_SW_PIO_DRAIN,
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 72c836b826ca8..7aa1aabb7a43c 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -710,6 +710,7 @@ static noinline int skip_rcv_packet(struct hfi1_packet *packet, int thread)
 {
 	int ret;
 
+	packet->rcd->dd->ctx0_seq_drop++;
 	/* Set up for the next packet */
 	packet->rhqoff += packet->rsize;
 	if (packet->rhqoff >= packet->maxcnt)
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 810ef5114772c..cf9bc95d80396 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1043,6 +1043,8 @@ struct hfi1_devdata {
 
 	char *boardname; /* human readable board info */
 
+	u64 ctx0_seq_drop;
+
 	/* reset value */
 	u64 z_int_counter;
 	u64 z_rcv_limit;
-- 
2.20.1



