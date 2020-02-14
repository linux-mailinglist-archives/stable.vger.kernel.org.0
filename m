Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0EE15E940
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389842AbgBNRFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:05:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391882AbgBNQOz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:14:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34D98246DD;
        Fri, 14 Feb 2020 16:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696894;
        bh=M0i73VriuxGDmKDh8rSwrzHZmZKAv/zzvhVanDWsHQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CI/8mCnvvNgXl4vBmf84+BdTBQ/1l98412tCip3rjcwni/u//cEXzKvLtOB6P8oHW
         /ZAY814lPRh7LXXJDuX2Lgjyn/HONHaQ0dXKQP4q0dawt4XlHIy5Mz5A66Q8qeLYmb
         72Rekei9I41qAKVUt3rxW/Gpq3fCkMxd1a4wA4Cw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 146/252] IB/hfi1: Add software counter for ctxt0 seq drop
Date:   Fri, 14 Feb 2020 11:10:01 -0500
Message-Id: <20200214161147.15842-146-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
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
index b09a4b1cf397b..1221faea75a68 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -1687,6 +1687,14 @@ static u64 access_sw_pio_drain(const struct cntr_entry *entry,
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
@@ -4247,6 +4255,8 @@ static struct cntr_entry dev_cntrs[DEV_CNTR_LAST] = {
 			    access_sw_cpu_intr),
 [C_SW_CPU_RCV_LIM] = CNTR_ELEM("RcvLimit", 0, 0, CNTR_NORMAL,
 			    access_sw_cpu_rcv_limit),
+[C_SW_CTX0_SEQ_DROP] = CNTR_ELEM("SeqDrop0", 0, 0, CNTR_NORMAL,
+			    access_sw_ctx0_seq_drop),
 [C_SW_VTX_WAIT] = CNTR_ELEM("vTxWait", 0, 0, CNTR_NORMAL,
 			    access_sw_vtx_wait),
 [C_SW_PIO_WAIT] = CNTR_ELEM("PioWait", 0, 0, CNTR_NORMAL,
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index 36b04d6300e54..c9a352d8a7e13 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -909,6 +909,7 @@ enum {
 	C_DC_PG_STS_TX_MBE_CNT,
 	C_SW_CPU_INTR,
 	C_SW_CPU_RCV_LIM,
+	C_SW_CTX0_SEQ_DROP,
 	C_SW_VTX_WAIT,
 	C_SW_PIO_WAIT,
 	C_SW_PIO_DRAIN,
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index d5277c23cba60..769e114567a03 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -734,6 +734,7 @@ static noinline int skip_rcv_packet(struct hfi1_packet *packet, int thread)
 {
 	int ret;
 
+	packet->rcd->dd->ctx0_seq_drop++;
 	/* Set up for the next packet */
 	packet->rhqoff += packet->rsize;
 	if (packet->rhqoff >= packet->maxcnt)
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 232fc4b59a98c..59c133935e23a 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1093,6 +1093,8 @@ struct hfi1_devdata {
 
 	char *boardname; /* human readable board info */
 
+	u64 ctx0_seq_drop;
+
 	/* reset value */
 	u64 z_int_counter;
 	u64 z_rcv_limit;
-- 
2.20.1

