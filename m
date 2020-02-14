Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC8815F17E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388497AbgBNSDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:03:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:37052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387611AbgBNPzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:55:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D37B24681;
        Fri, 14 Feb 2020 15:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695744;
        bh=SQvgkyKG2UZPO1OOMVojkzDRJi1u236kyGI4974oQnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mog67SNVCFmaq8Xksy6ywb3d9zApj1YYcOq6AtpgaDaG+BtfS3KL3/fuQxCRrG4UY
         hhiCtBDwtfKHMnHpiD454Itk+SsCs5I4kBJccUBbJIq6hQfpSD9I5/JipVAwySDoqk
         nZ2DKis67z+lxkhFAjTZCV9XAWFp1Zue61orXk9A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 316/542] IB/hfi1: Add RcvShortLengthErrCnt to hfi1stats
Date:   Fri, 14 Feb 2020 10:45:08 -0500
Message-Id: <20200214154854.6746-316-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

