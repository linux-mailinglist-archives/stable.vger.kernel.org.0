Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2834615AA1
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiKBDhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiKBDhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:37:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7D22655C
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:37:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF3676172F
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963C3C433D6;
        Wed,  2 Nov 2022 03:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667360251;
        bh=XmH0GaFV6fThlQ/HnfD6J8R+gGh4ag/OMSrVb29DlZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=opom/pStMJbJox+MgXN9JDWnh6hbgyUHMGtVHCU24P6awtrew9ygB2KDQzSdlk1og
         JgLcIqXXJ7x1SUUn/VRE5k8WOjulaNh4fUiWby6C44jWUFlJ0MSQm/Rp3ifZdIVlp5
         v/RD9F6Rbf8Jk0xoN6eWIzrgJjoU6vBmKu30cW9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hyong Youb Kim <hyonkim@cisco.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 77/78] net/mlx5e: Do not increment ESN when updating IPsec ESN state
Date:   Wed,  2 Nov 2022 03:35:02 +0100
Message-Id: <20221102022055.192205480@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyong Youb Kim <hyonkim@cisco.com>

[ Upstream commit 888be6b279b7257b5f6e4c9527675bff0a335596 ]

An offloaded SA stops receiving after about 2^32 + replay_window
packets. For example, when SA reaches <seq-hi 0x1, seq 0x2c>, all
subsequent packets get dropped with SA-icv-failure (integrity_failed).

To reproduce the bug:
- ConnectX-6 Dx with crypto enabled (FW 22.30.1004)
- ipsec.conf:
  nic-offload = yes
  replay-window = 32
  esn = yes
  salifetime=24h
- Run netperf for a long time to send more than 2^32 packets
  netperf -H <device-under-test> -t TCP_STREAM -l 20000

When 2^32 + replay_window packets are received, the replay window
moves from the 2nd half of subspace (overlap=1) to the 1st half
(overlap=0). The driver then updates the 'esn' value in NIC
(i.e. seq_hi) as follows.

 seq_hi = xfrm_replay_seqhi(seq_bottom)
 new esn in NIC = seq_hi + 1

The +1 increment is wrong, as seq_hi already contains the correct
seq_hi. For example, when seq_hi=1, the driver actually tells NIC to
use seq_hi=2 (esn). This incorrect esn value causes all subsequent
packets to fail integrity checks (SA-icv-failure). So, do not
increment.

Fixes: cb01008390bb ("net/mlx5: IPSec, Add support for ESN")
Signed-off-by: Hyong Youb Kim <hyonkim@cisco.com>
Acked-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/20221026135153.154807-2-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index c467f5e981f6..70087f2542b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -117,7 +117,6 @@ static bool mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry)
 	struct xfrm_replay_state_esn *replay_esn;
 	u32 seq_bottom;
 	u8 overlap;
-	u32 *esn;
 
 	if (!(sa_entry->x->props.flags & XFRM_STATE_ESN)) {
 		sa_entry->esn_state.trigger = 0;
@@ -130,11 +129,9 @@ static bool mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry)
 
 	sa_entry->esn_state.esn = xfrm_replay_seqhi(sa_entry->x,
 						    htonl(seq_bottom));
-	esn = &sa_entry->esn_state.esn;
 
 	sa_entry->esn_state.trigger = 1;
 	if (unlikely(overlap && seq_bottom < MLX5E_IPSEC_ESN_SCOPE_MID)) {
-		++(*esn);
 		sa_entry->esn_state.overlap = 0;
 		return true;
 	} else if (unlikely(!overlap &&
-- 
2.35.1



