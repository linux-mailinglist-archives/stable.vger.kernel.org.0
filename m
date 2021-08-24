Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0DF3F640E
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbhHXRAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238855AbhHXQ7H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:59:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B23A8613A7;
        Tue, 24 Aug 2021 16:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824248;
        bh=qswEFGmBYV/D1/KMp4wbHB1YQND6hMqZSuZd2iLkgyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GWDi8OxvKhFSj5Pnz1AMUCIBVQk9/4ZnZD5dcwEqWGOP549Pf3dTuDCGPyh7xioBn
         C69EMi1o/FeI4iwyuuRFbpRB5EHUIweDWS9Q36P+lUnNo3cGr5X9LTTM4j/vcv5w0z
         TBRRukgrUlyiWDOgs9mxWoE7D7rkPykeaKssrC7cTGfjHq0YTWt5Y0J62I0B4tRKxv
         YsuD85DtWfoU6sSxf6xDtTtnVCqix0reDQ7GPM2D4TCokzG9D0Cu1XRlCO1CrtklCV
         ZZl/pMPrT0ZfUADE7+Amawg11OfcvWE3bbyI+KYd+izqMbf/w7zwvTzA9+0Y5Yvs9q
         Vxirqup3E2KmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 081/127] i40e: Fix ATR queue selection
Date:   Tue, 24 Aug 2021 12:55:21 -0400
Message-Id: <20210824165607.709387-82-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[ Upstream commit a222be597e316389f9f8c26033352c124ce93056 ]

Without this patch, ATR does not work. Receive/transmit uses queue
selection based on SW DCB hashing method.

If traffic classes are not configured for PF, then use
netdev_pick_tx function for selecting queue for packet transmission.
Instead of calling i40e_swdcb_skb_tx_hash, call netdev_pick_tx,
which ensures that packet is transmitted/received from CPU that is
running the application.

Reproduction steps:
1. Load i40e driver
2. Map each MSI interrupt of i40e port for each CPU
3. Disable ntuple, enable ATR i.e.:
ethtool -K $interface ntuple off
ethtool --set-priv-flags $interface flow-director-atr
4. Run application that is generating traffic and is bound to a
single CPU, i.e.:
taskset -c 9 netperf -H 1.1.1.1 -t TCP_RR -l 10
5. Observe behavior:
Application's traffic should be restricted to the CPU provided in
taskset.

Fixes: 89ec1f0886c1 ("i40e: Fix queue-to-TC mapping on Tx")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 107fb472319e..b18ff0ed8527 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3665,8 +3665,7 @@ u16 i40e_lan_select_queue(struct net_device *netdev,
 
 	/* is DCB enabled at all? */
 	if (vsi->tc_config.numtc == 1)
-		return i40e_swdcb_skb_tx_hash(netdev, skb,
-					      netdev->real_num_tx_queues);
+		return netdev_pick_tx(netdev, skb, sb_dev);
 
 	prio = skb->priority;
 	hw = &vsi->back->hw;
-- 
2.30.2

