Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 862EF167468
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388227AbgBUIVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:21:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:60438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388225AbgBUIVI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:21:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 759AD222C4;
        Fri, 21 Feb 2020 08:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273266;
        bh=hEI+DnjtVdc0WPrY+zyzHd5RgdLumkLZqFZf81F03qA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MssJ9WLtpa7FxkAal3EyIqM3NxGJh9g5UdQlPQAya1A9Y5ux8JiiSkQJsMylhdXUV
         LekxMw4PHiaJuHcK2uTo5x8OK5LC5ZkcouG1eMabl1RAoCjQYFKfQXJm3azdynXwHC
         +XDrkPyZdJZlLOK+zKmiugau2QywHqkiz8rpinE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 107/191] IB/hfi1: Add software counter for ctxt0 seq drop
Date:   Fri, 21 Feb 2020 08:41:20 +0100
Message-Id: <20200221072303.764816803@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
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
index ab981874c71cc..e38de547785d0 100644
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



