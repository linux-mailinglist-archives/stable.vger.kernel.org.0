Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60353F6536
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbhHXRKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:10:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239380AbhHXRJE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:09:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1975861A4F;
        Tue, 24 Aug 2021 17:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824419;
        bh=F9KU1kXUlLKMpoObCkZ7bwUTHVJgLsXCOcsbhsXwtCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ThkrL+n/Yc4rAR73U3BzeukH1iuyJvHx/ZDVKVrXSmQFm1q0MkPPQURUvANBxq+CB
         moFQjQEEtJSwJ59/SGgiMSbAzKlWh+BNHRbDwTGWyk+yBiXOhRYlVgWmRffAl/IoTP
         el+IuKOFbptn9DSF74WxN6RRMIeaQG5N+fTtRc2NS2w+eoQkai8oDdLkVqnnEM7B3S
         12WtDTpBrrDyrCRFr/nbLWfc9TEqY600bGQSdco0nULCYwk7mdvcBOJejFcAh9c2Bb
         QPqtMQ5fIOnuuVGvDJjjq9jf97NJA1g0Wwgw4V11NEq8N/j7oKgJH9gzAR2sRNZO9N
         VgdhMdT0htIeg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 70/98] i40e: Fix ATR queue selection
Date:   Tue, 24 Aug 2021 12:58:40 -0400
Message-Id: <20210824165908.709932-71-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
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
index 615802b07521..5ad28129fab2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3556,8 +3556,7 @@ u16 i40e_lan_select_queue(struct net_device *netdev,
 
 	/* is DCB enabled at all? */
 	if (vsi->tc_config.numtc == 1)
-		return i40e_swdcb_skb_tx_hash(netdev, skb,
-					      netdev->real_num_tx_queues);
+		return netdev_pick_tx(netdev, skb, sb_dev);
 
 	prio = skb->priority;
 	hw = &vsi->back->hw;
-- 
2.30.2

