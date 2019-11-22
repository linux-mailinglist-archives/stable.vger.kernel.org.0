Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3422106EB1
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbfKVLBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:01:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:54514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730766AbfKVLBb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:01:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFFE320721;
        Fri, 22 Nov 2019 11:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420490;
        bh=r8hnijHJ0SYL+qyAwyuyhR0Z1cWediu4nKfrfBcM7Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JpVkuxtUhTqkM/dnSbr0MjoEEpa+TJj/zmql6f32KLb9H56Rz7rBx1aLrSvCf5f1j
         10ZNEHpqK7c3L7OKWK69vV/J21xlEbnvXRXrRG+z1wMZYuC+vxdsxLpQPXba1yCYG3
         ygfaHypPYgGCi7T+CqpC18qWCDxmp6S0m6k5RlDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Radoslaw Tyl <radoslawx.tyl@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 080/220] ixgbe: Fix ixgbe TX hangs with XDP_TX beyond queue limit
Date:   Fri, 22 Nov 2019 11:27:25 +0100
Message-Id: <20191122100918.149260395@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radoslaw Tyl <radoslawx.tyl@intel.com>

[ Upstream commit 8d7179b1e2d64b3493c0114916486fe92e6109a9 ]

We have Tx hang when number Tx and XDP queues are more than 64.
In XDP always is MTQC == 0x0 (64TxQs). We need more space for Tx queues.

Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 85280765d793d..f3e21de3b1f0b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -3582,12 +3582,18 @@ static void ixgbe_setup_mtqc(struct ixgbe_adapter *adapter)
 		else
 			mtqc |= IXGBE_MTQC_64VF;
 	} else {
-		if (tcs > 4)
+		if (tcs > 4) {
 			mtqc = IXGBE_MTQC_RT_ENA | IXGBE_MTQC_8TC_8TQ;
-		else if (tcs > 1)
+		} else if (tcs > 1) {
 			mtqc = IXGBE_MTQC_RT_ENA | IXGBE_MTQC_4TC_4TQ;
-		else
-			mtqc = IXGBE_MTQC_64Q_1PB;
+		} else {
+			u8 max_txq = adapter->num_tx_queues +
+				adapter->num_xdp_queues;
+			if (max_txq > 63)
+				mtqc = IXGBE_MTQC_RT_ENA | IXGBE_MTQC_4TC_4TQ;
+			else
+				mtqc = IXGBE_MTQC_64Q_1PB;
+		}
 	}
 
 	IXGBE_WRITE_REG(hw, IXGBE_MTQC, mtqc);
-- 
2.20.1



