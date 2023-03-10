Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5F16B42E8
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbjCJOIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbjCJOIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:08:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4D51184C7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:07:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BEABB82291
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF7EC4339B;
        Fri, 10 Mar 2023 14:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457269;
        bh=GrS2Lw7JbN7t+iWzXR/rT0Zpd69CCXz6DPiigDbnBxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohWB8Hdl5ARHThCDKlO5HH2mkgEOiD2jDMNxFBPo/cWKXS6UM9PllZtJFmQDkPpmh
         M5JYkJ9QHccsrMntCanH34arz0RSNYs3p20ouB4oM7LW1J2GkIEyqto3xZtCL5WMUR
         4f1a/tUs1UDC4qWsBvCc4D7hZ9q4qrFZ0/ErCNSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Vadim Fedorenko <vadfed@meta.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/200] mlx5: fix skb leak while fifo resync and push
Date:   Fri, 10 Mar 2023 14:38:06 +0100
Message-Id: <20230310133719.530242278@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Fedorenko <vadfed@meta.com>

[ Upstream commit e435941b1da1a0be4ff8a7ae425774c76a5ac514 ]

During ptp resync operation SKBs were poped from the fifo but were never
freed neither by napi_consume nor by dev_kfree_skb_any. Add call to
napi_consume_skb to properly free SKBs.

Another leak was happening because mlx5e_skb_fifo_has_room() had an error
in the check. Comparing free running counters works well unless C promotes
the types to something wider than the counter. In this case counters are
u16 but the result of the substraction is promouted to int and it causes
wrong result (negative value) of the check when producer have already
overlapped but consumer haven't yet. Explicit cast to u16 fixes the issue.

Fixes: 58a518948f60 ("net/mlx5e: Add resiliency for PTP TX port timestamp")
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c  | 6 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 8469e9c386706..b72de2b520ecb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -86,7 +86,8 @@ static bool mlx5e_ptp_ts_cqe_drop(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb
 	return (ptpsq->ts_cqe_ctr_mask && (skb_cc != skb_id));
 }
 
-static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb_id)
+static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc,
+					     u16 skb_id, int budget)
 {
 	struct skb_shared_hwtstamps hwts = {};
 	struct sk_buff *skb;
@@ -98,6 +99,7 @@ static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_
 		hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
 		skb_tstamp_tx(skb, &hwts);
 		ptpsq->cq_stats->resync_cqe++;
+		napi_consume_skb(skb, budget);
 		skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
 	}
 }
@@ -119,7 +121,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 	}
 
 	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id))
-		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id);
+		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id, budget);
 
 	skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
 	hwtstamp = mlx5e_cqe_ts_to_ns(sq->ptp_cyc2time, sq->clock, get_cqe_ts(cqe));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 853f312cd7572..15a5a57b47b85 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -81,7 +81,7 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
 static inline bool
 mlx5e_skb_fifo_has_room(struct mlx5e_skb_fifo *fifo)
 {
-	return (*fifo->pc - *fifo->cc) < fifo->mask;
+	return (u16)(*fifo->pc - *fifo->cc) < fifo->mask;
 }
 
 static inline bool
-- 
2.39.2



