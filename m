Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3DD1BC915
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbgD1Si2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730629AbgD1Si1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:38:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AA752085B;
        Tue, 28 Apr 2020 18:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099107;
        bh=/AT+BPEtbgPhVXoYP8gxORxx9FEIM787m91UbGqpI24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GQYsOeBPNCxoqdYiba6MFwtdRgDF/ygM6b+1jBTK4uExxnNWVPAzrK2D211cWUBH
         8eWMpH7u40w9qLuEDzW3eFRoT7BlaM8I8ZxzYKTM+p9UOSAm0R9EIXGfv8ctjeoSap
         Vle9qPd4CwJu8ec1jfXZkGMuYaRwv/T88VkEanJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manoj Malviya <manojmalviya@chelsio.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 057/168] cxgb4: fix large delays in PTP synchronization
Date:   Tue, 28 Apr 2020 20:23:51 +0200
Message-Id: <20200428182239.139390413@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit bd019427bf3623ee3c7d2845cf921bbf4c14846c ]

Fetching PTP sync information from mailbox is slow and can take
up to 10 milliseconds. Reduce this unnecessary delay by directly
reading the information from the corresponding registers.

Fixes: 9c33e4208bce ("cxgb4: Add PTP Hardware Clock (PHC) support")
Signed-off-by: Manoj Malviya <manojmalviya@chelsio.com>
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c |   27 +++++--------------------
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h   |    3 ++
 2 files changed, 9 insertions(+), 21 deletions(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
@@ -311,32 +311,17 @@ static int cxgb4_ptp_adjtime(struct ptp_
  */
 static int cxgb4_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 {
-	struct adapter *adapter = (struct adapter *)container_of(ptp,
-				   struct adapter, ptp_clock_info);
-	struct fw_ptp_cmd c;
+	struct adapter *adapter = container_of(ptp, struct adapter,
+					       ptp_clock_info);
 	u64 ns;
-	int err;
 
-	memset(&c, 0, sizeof(c));
-	c.op_to_portid = cpu_to_be32(FW_CMD_OP_V(FW_PTP_CMD) |
-				     FW_CMD_REQUEST_F |
-				     FW_CMD_READ_F |
-				     FW_PTP_CMD_PORTID_V(0));
-	c.retval_len16 = cpu_to_be32(FW_CMD_LEN16_V(sizeof(c) / 16));
-	c.u.ts.sc = FW_PTP_SC_GET_TIME;
-
-	err = t4_wr_mbox(adapter, adapter->mbox, &c, sizeof(c), &c);
-	if (err < 0) {
-		dev_err(adapter->pdev_dev,
-			"PTP: %s error %d\n", __func__, -err);
-		return err;
-	}
+	ns = t4_read_reg(adapter, T5_PORT_REG(0, MAC_PORT_PTP_SUM_LO_A));
+	ns |= (u64)t4_read_reg(adapter,
+			       T5_PORT_REG(0, MAC_PORT_PTP_SUM_HI_A)) << 32;
 
 	/* convert to timespec*/
-	ns = be64_to_cpu(c.u.ts.tm);
 	*ts = ns_to_timespec64(ns);
-
-	return err;
+	return 0;
 }
 
 /**
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
@@ -1900,6 +1900,9 @@
 
 #define MAC_PORT_CFG2_A 0x818
 
+#define MAC_PORT_PTP_SUM_LO_A 0x990
+#define MAC_PORT_PTP_SUM_HI_A 0x994
+
 #define MPS_CMN_CTL_A	0x9000
 
 #define COUNTPAUSEMCRX_S    5


