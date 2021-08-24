Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9623F65ED
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238988AbhHXRS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239833AbhHXRQX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:16:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E9D761AA3;
        Tue, 24 Aug 2021 17:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824510;
        bh=dFFGUXU9vNJqd4F1E0jObZPM5HAC1ZwhGhoIpP2/8uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tjq6ApnjQwI8vXAQdAZg7lSdGk3RN2T4JnqhkxKkaxKDhU/bbFv2ybbYddhuugs0i
         Asu/MLvyN40snqQAr7vvPjeCAPz4cDtpF5Sx50MGDIMCVjttGD20YS5LRbmrVR4NEa
         l1gcqLKQMcLWOO8bMmEuQoVWix0RO3tWTVIG0JfSEIlIaml+mz4t1lwURL9Xb3Iqpq
         D9WN0RQ4PNs/1+GPHFZYEWf/9UEDoOijQvM1f+Fj2GI8STXGZt3pQSPFcjpyI8iIUT
         6sRCpNQ11En+C5p0A0JfLEjbyuhcbGDsV2zP2sjW//tuykTdBShi2Zy1xmMdFRekBR
         dqqJYvkXKX8jw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 43/61] i40e: Fix ATR queue selection
Date:   Tue, 24 Aug 2021 13:00:48 -0400
Message-Id: <20210824170106.710221-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
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
index 8e38c547b53f..06987913837a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3553,8 +3553,7 @@ u16 i40e_lan_select_queue(struct net_device *netdev,
 
 	/* is DCB enabled at all? */
 	if (vsi->tc_config.numtc == 1)
-		return i40e_swdcb_skb_tx_hash(netdev, skb,
-					      netdev->real_num_tx_queues);
+		return netdev_pick_tx(netdev, skb, sb_dev);
 
 	prio = skb->priority;
 	hw = &vsi->back->hw;
-- 
2.30.2

