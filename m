Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4FD61595B
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiKBDJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiKBDJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:09:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DCF17E32
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:09:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11398617BC
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB01C433D6;
        Wed,  2 Nov 2022 03:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358549;
        bh=2Aud58to4VhRzVxbwPRHtWQOnn9Vt+6M+4AOsHD9RJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AT5Kl7X7kC2qL2YEmSVrUcM8lbY8KBArukw0eQkRtt+ZfFcf0d80Q3sRN7MnMcSrx
         2QXTzABPccQuweBeJfTBa+ZxLLr58SJpQi2PQ/DIUrffe3zAdKat9RNqMQPEliKp05
         ITRVGgiENErY8h2BpWGPkxfxaQVyXKuvktWLXZKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hyong Youb Kim <hyonkim@cisco.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/132] net/mlx5e: Do not increment ESN when updating IPsec ESN state
Date:   Wed,  2 Nov 2022 03:33:43 +0100
Message-Id: <20221102022102.742856478@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
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
index 7cab08a2f715..05882d1a4407 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -113,7 +113,6 @@ static bool mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry)
 	struct xfrm_replay_state_esn *replay_esn;
 	u32 seq_bottom = 0;
 	u8 overlap;
-	u32 *esn;
 
 	if (!(sa_entry->x->props.flags & XFRM_STATE_ESN)) {
 		sa_entry->esn_state.trigger = 0;
@@ -128,11 +127,9 @@ static bool mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry)
 
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



