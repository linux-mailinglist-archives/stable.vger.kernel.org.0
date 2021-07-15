Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8603CA82C
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241313AbhGOS64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241273AbhGOS6E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:58:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 097D0613E9;
        Thu, 15 Jul 2021 18:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375308;
        bh=gyNbe78AFY1UzqreDnREF1h2G5X1Dv9nW1W/K3xfdW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hx0D3QQJ110Wshk91T1U71nQK45+jfm2PAzfMiM8P6cbPvb29817nQZoZ2NA/FdYI
         blohLhB31GB+wcPqiDKsFPAEEInrhdqTwcSiQoDsQYmpRA7U8VNR0Z9H6R/TqCfd/+
         aC+0km7Wr/I8XTBkqBUufmo86LbQBpxJVgRTuW0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 033/242] igb: fix assignment on big endian machines
Date:   Thu, 15 Jul 2021 20:36:35 +0200
Message-Id: <20210715182557.789971903@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

[ Upstream commit b514958dd1a3bd57638b0e63b8e5152b1960e6aa ]

The igb driver was trying hard to be sparse correct, but somehow
ended up converting a variable into little endian order and then
tries to OR something with it.

A much plainer way of doing things is to leave all variables and
OR operations in CPU (non-endian) mode, and then convert to
little endian only once, which is what this change does.

This probably fixes a bug that might have been seen only on
big endian systems.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 894b9b87dba1..434220a342df 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6277,12 +6277,12 @@ int igb_xmit_xdp_ring(struct igb_adapter *adapter,
 	cmd_type |= len | IGB_TXD_DCMD;
 	tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type);
 
-	olinfo_status = cpu_to_le32(len << E1000_ADVTXD_PAYLEN_SHIFT);
+	olinfo_status = len << E1000_ADVTXD_PAYLEN_SHIFT;
 	/* 82575 requires a unique index per ring */
 	if (test_bit(IGB_RING_FLAG_TX_CTX_IDX, &tx_ring->flags))
 		olinfo_status |= tx_ring->reg_idx << 4;
 
-	tx_desc->read.olinfo_status = olinfo_status;
+	tx_desc->read.olinfo_status = cpu_to_le32(olinfo_status);
 
 	netdev_tx_sent_queue(txring_txq(tx_ring), tx_buffer->bytecount);
 
-- 
2.30.2



