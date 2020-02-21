Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2750D167158
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730054AbgBUHxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:53:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:51606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729493AbgBUHxW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:53:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 449492465D;
        Fri, 21 Feb 2020 07:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271601;
        bh=SQvgkyKG2UZPO1OOMVojkzDRJi1u236kyGI4974oQnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yw2d3iVoWo/pGb/GJOGA6NB096UN0GuY7FQeX+OHT9QdgtUBNxNuE7tmwYgAzfa5q
         yQOWdO3PjG6Bi+Ftcpwd8eqjNOT8Q1EFomctSnYq8w702DFxo/uY2mTZbb6CRKCEi+
         mQoKvFwdsyDzK+Zhyo2x/BmEZhOu5TWBdygVoJYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 227/399] IB/hfi1: Add RcvShortLengthErrCnt to hfi1stats
Date:   Fri, 21 Feb 2020 08:39:12 +0100
Message-Id: <20200221072424.948082021@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

[ Upstream commit 2c9d4e26d1ab27ceae2ded2ffe930f8e5f5b2a89 ]

This counter, RxShrErr, is required for error analysis and debug.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Link: https://lore.kernel.org/r/20200106134235.119356.29123.stgit@awfm-01.aw.intel.com
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/chip.c           | 1 +
 drivers/infiniband/hw/hfi1/chip.h           | 1 +
 drivers/infiniband/hw/hfi1/chip_registers.h | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index d5961918fe157..10924f1220720 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -4114,6 +4114,7 @@ def_access_ibp_counter(rc_crwaits);
 static struct cntr_entry dev_cntrs[DEV_CNTR_LAST] = {
 [C_RCV_OVF] = RXE32_DEV_CNTR_ELEM(RcvOverflow, RCV_BUF_OVFL_CNT, CNTR_SYNTH),
 [C_RX_LEN_ERR] = RXE32_DEV_CNTR_ELEM(RxLenErr, RCV_LENGTH_ERR_CNT, CNTR_SYNTH),
+[C_RX_SHORT_ERR] = RXE32_DEV_CNTR_ELEM(RxShrErr, RCV_SHORT_ERR_CNT, CNTR_SYNTH),
 [C_RX_ICRC_ERR] = RXE32_DEV_CNTR_ELEM(RxICrcErr, RCV_ICRC_ERR_CNT, CNTR_SYNTH),
 [C_RX_EBP] = RXE32_DEV_CNTR_ELEM(RxEbpCnt, RCV_EBP_CNT, CNTR_SYNTH),
 [C_RX_TID_FULL] = RXE32_DEV_CNTR_ELEM(RxTIDFullEr, RCV_TID_FULL_ERR_CNT,
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index bfccd4ae07a72..af0061936c666 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -859,6 +859,7 @@ static inline int idx_from_vl(int vl)
 enum {
 	C_RCV_OVF = 0,
 	C_RX_LEN_ERR,
+	C_RX_SHORT_ERR,
 	C_RX_ICRC_ERR,
 	C_RX_EBP,
 	C_RX_TID_FULL,
diff --git a/drivers/infiniband/hw/hfi1/chip_registers.h b/drivers/infiniband/hw/hfi1/chip_registers.h
index ab3589d17aee6..fb3ec9bff7a22 100644
--- a/drivers/infiniband/hw/hfi1/chip_registers.h
+++ b/drivers/infiniband/hw/hfi1/chip_registers.h
@@ -381,6 +381,7 @@
 #define DC_LCB_STS_LINK_TRANSFER_ACTIVE (DC_LCB_CSRS + 0x000000000468)
 #define DC_LCB_STS_ROUND_TRIP_LTP_CNT (DC_LCB_CSRS + 0x0000000004B0)
 #define RCV_LENGTH_ERR_CNT 0
+#define RCV_SHORT_ERR_CNT 2
 #define RCV_ICRC_ERR_CNT 6
 #define RCV_EBP_CNT 9
 #define RCV_BUF_OVFL_CNT 10
-- 
2.20.1



