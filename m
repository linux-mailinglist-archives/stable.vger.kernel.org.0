Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58F9D15E70D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388681AbgBNQvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:51:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:52780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405020AbgBNQTh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:19:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E69D32470C;
        Fri, 14 Feb 2020 16:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697176;
        bh=rbYXY9x2U94T3ywVds9Mzo2LH017Iuuc5FYAlCQQUHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jflTV+Y8Sa+YQSX+fukvRH9T+vmIN2pclijbikuWX7/y/Ex1MZkY6chTnRRXLBz+w
         L+IdKST2EkjSZbGiI9O9M8PsOQkIbCIJRL4lbx81Jev4A9rt6jrAfoIUv4YtcmVE7R
         /VRLNsqe+ZuzxkVxkV8Fb/x8XmhFLsbQ5R64lUns=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 109/186] IB/hfi1: Add software counter for ctxt0 seq drop
Date:   Fri, 14 Feb 2020 11:15:58 -0500
Message-Id: <20200214161715.18113-109-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index af550c1767e31..c9a93f468f14a 100644
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

