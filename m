Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9B61138071
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730729AbgAKK3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:29:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:39288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730398AbgAKK3p (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:29:45 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 470C520842;
        Sat, 11 Jan 2020 10:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738584;
        bh=opyR2F1ucJGFv8k1cGKvBnL71fC1qVEfOu0nJcmSntY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QreB8LjWQC0nb/OaYe5U34Md7SWo6K+IDspriWmstmADFZcV5nAWjAwSH/cTYwxLn
         xv6etzRvHKUHpx9QDNjENU7Iyh1enqBI1Dz/tG4BSJNbDYrdDSMrL+/kqg224X2CjC
         8pYJYjSelzbkadulX6LOgM83TEoVk8NFJQS9WpQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 121/165] net/i40e: Fix concurrency issues between config flow and XSK
Date:   Sat, 11 Jan 2020 10:50:40 +0100
Message-Id: <20200111094933.799843970@linuxfoundation.org>
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

[ Upstream commit b3873a5be757b44d51af542a50a6f2a3b6f95284 ]

Use synchronize_rcu to wait until the XSK wakeup function finishes
before destroying the resources it uses:

1. i40e_down already calls synchronize_rcu. On i40e_down either
__I40E_VSI_DOWN or __I40E_CONFIG_BUSY is set. Check the latter in
i40e_xsk_wakeup (the former is already checked there).

2. After switching the XDP program, call synchronize_rcu to let
i40e_xsk_wakeup exit before the XDP program is freed.

3. Changing the number of channels brings the interface down (see
i40e_prep_for_reset and i40e_pf_quiesce_all_vsi).

4. Disabling UMEM sets __I40E_CONFIG_BUSY, too.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191217162023.16011-4-maximmi@mellanox.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h      |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c | 10 +++++++---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  |  4 ++++
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 2af9f6308f84..401304d4d553 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -1151,7 +1151,7 @@ void i40e_set_fec_in_flags(u8 fec_cfg, u32 *flags);
 
 static inline bool i40e_enabled_xdp_vsi(struct i40e_vsi *vsi)
 {
-	return !!vsi->xdp_prog;
+	return !!READ_ONCE(vsi->xdp_prog);
 }
 
 int i40e_create_queue_channel(struct i40e_vsi *vsi, struct i40e_channel *ch);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 339925af0206..4960c9c3e773 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6804,8 +6804,8 @@ void i40e_down(struct i40e_vsi *vsi)
 	for (i = 0; i < vsi->num_queue_pairs; i++) {
 		i40e_clean_tx_ring(vsi->tx_rings[i]);
 		if (i40e_enabled_xdp_vsi(vsi)) {
-			/* Make sure that in-progress ndo_xdp_xmit
-			 * calls are completed.
+			/* Make sure that in-progress ndo_xdp_xmit and
+			 * ndo_xsk_wakeup calls are completed.
 			 */
 			synchronize_rcu();
 			i40e_clean_tx_ring(vsi->xdp_rings[i]);
@@ -12526,8 +12526,12 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi,
 
 	old_prog = xchg(&vsi->xdp_prog, prog);
 
-	if (need_reset)
+	if (need_reset) {
+		if (!prog)
+			/* Wait until ndo_xsk_wakeup completes. */
+			synchronize_rcu();
 		i40e_reset_and_rebuild(pf, true, true);
+	}
 
 	for (i = 0; i < vsi->num_queue_pairs; i++)
 		WRITE_ONCE(vsi->rx_rings[i]->xdp_prog, vsi->xdp_prog);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index d07e1a890428..f73cd917c44f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -787,8 +787,12 @@ int i40e_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
 {
 	struct i40e_netdev_priv *np = netdev_priv(dev);
 	struct i40e_vsi *vsi = np->vsi;
+	struct i40e_pf *pf = vsi->back;
 	struct i40e_ring *ring;
 
+	if (test_bit(__I40E_CONFIG_BUSY, pf->state))
+		return -ENETDOWN;
+
 	if (test_bit(__I40E_VSI_DOWN, vsi->state))
 		return -ENETDOWN;
 
-- 
2.20.1



