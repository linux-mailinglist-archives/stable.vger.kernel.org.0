Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D753138074
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbgAKK34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:29:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730997AbgAKK34 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:29:56 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30E732084D;
        Sat, 11 Jan 2020 10:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738595;
        bh=1R8tx3K5QqVZpuOe5G+9ykmdSahGf0KttnPE3BmE5UM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQLxzPpJFXBdW50WrPLCu+E7pFMYyBgH4WLJwNBnXI6r6NDfjoEoxghp545Kra1GY
         0LyZeIe3yus3GwwOBo0bsNxcBRmm7ykA2ZaKV83iUPWDe9exIroGiWUT7CkoTdOe6c
         CL6aj8STKl5b4V0JqShcKoymECscxiIV8QAQ51mQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 122/165] net/ixgbe: Fix concurrency issues between config flow and XSK
Date:   Sat, 11 Jan 2020 10:50:41 +0100
Message-Id: <20200111094934.030792062@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit c0fdccfd226a1424683d3000d9e08384391210a2 ]

Use synchronize_rcu to wait until the XSK wakeup function finishes
before destroying the resources it uses:

1. ixgbe_down already calls synchronize_rcu after setting __IXGBE_DOWN.

2. After switching the XDP program, call synchronize_rcu to let
ixgbe_xsk_wakeup exit before the XDP program is freed.

3. Changing the number of channels brings the interface down.

4. Disabling UMEM sets __IXGBE_TX_DISABLED before closing hardware
resources and resetting xsk_umem. Check that bit in ixgbe_xsk_wakeup to
avoid using the XDP ring when it's already destroyed. synchronize_rcu is
called from ixgbe_txrx_ring_disable.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191217162023.16011-5-maximmi@mellanox.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 7 ++++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 8 ++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 1a7203fede12..c6404abf2dd1 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10248,7 +10248,12 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 
 	/* If transitioning XDP modes reconfigure rings */
 	if (need_reset) {
-		int err = ixgbe_setup_tc(dev, adapter->hw_tcs);
+		int err;
+
+		if (!prog)
+			/* Wait until ndo_xsk_wakeup completes. */
+			synchronize_rcu();
+		err = ixgbe_setup_tc(dev, adapter->hw_tcs);
 
 		if (err) {
 			rcu_assign_pointer(adapter->xdp_prog, old_prog);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index d6feaacfbf89..b43be9f14105 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -709,10 +709,14 @@ int ixgbe_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 	if (qid >= adapter->num_xdp_queues)
 		return -ENXIO;
 
-	if (!adapter->xdp_ring[qid]->xsk_umem)
+	ring = adapter->xdp_ring[qid];
+
+	if (test_bit(__IXGBE_TX_DISABLED, &ring->state))
+		return -ENETDOWN;
+
+	if (!ring->xsk_umem)
 		return -ENXIO;
 
-	ring = adapter->xdp_ring[qid];
 	if (!napi_if_scheduled_mark_missed(&ring->q_vector->napi)) {
 		u64 eics = BIT_ULL(ring->q_vector->v_idx);
 
-- 
2.20.1



