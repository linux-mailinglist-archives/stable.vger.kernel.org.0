Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA6A6B42F8
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbjCJOJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbjCJOI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:08:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915B185B28
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:08:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40591B822C3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18BEC433D2;
        Fri, 10 Mar 2023 14:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457272;
        bh=glR3WvKNXYByI7nWKoEqFRBH+SXx0nZO071j7vFh4Cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIJJ055LAzNQ3vZIUYB8D7IWiccs5d3yWC/N2M9VG2OTBccpTkERK6cHacUruYu5S
         Y5MpSFWEMd8XXsN6q1c/Z3MjxjjtP4FBtzil81094WX+o8LDnUv+1XdRb9Wvt4/bjb
         StlItXheCxtqdBvT55gIeokwnjsnGG0DTxpfCZUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vadim Fedorenko <vadfed@meta.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/200] mlx5: fix possible ptp queue fifo use-after-free
Date:   Fri, 10 Mar 2023 14:38:07 +0100
Message-Id: <20230310133719.559597295@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Fedorenko <vadfed@meta.com>

[ Upstream commit 3a50cf1e8e5157b82268eee7e330dbe5736a0948 ]

Fifo indexes are not checked during pop operations and it leads to
potential use-after-free when poping from empty queue. Such case was
possible during re-sync action. WARN_ON_ONCE covers future cases.

There were out-of-order cqe spotted which lead to drain of the queue and
use-after-free because of lack of fifo pointers check. Special check and
counter are added to avoid resync operation if SKB could not exist in the
fifo because of OOO cqe (skb_id must be between consumer and producer
index).

Fixes: 58a518948f60 ("net/mlx5e: Add resiliency for PTP TX port timestamp")
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 19 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  2 ++
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  1 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  1 +
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index b72de2b520ecb..ae75e230170b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -86,6 +86,17 @@ static bool mlx5e_ptp_ts_cqe_drop(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb
 	return (ptpsq->ts_cqe_ctr_mask && (skb_cc != skb_id));
 }
 
+static bool mlx5e_ptp_ts_cqe_ooo(struct mlx5e_ptpsq *ptpsq, u16 skb_id)
+{
+	u16 skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
+	u16 skb_pc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc);
+
+	if (PTP_WQE_CTR2IDX(skb_id - skb_cc) >= PTP_WQE_CTR2IDX(skb_pc - skb_cc))
+		return true;
+
+	return false;
+}
+
 static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc,
 					     u16 skb_id, int budget)
 {
@@ -120,8 +131,14 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 		goto out;
 	}
 
-	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id))
+	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id)) {
+		if (mlx5e_ptp_ts_cqe_ooo(ptpsq, skb_id)) {
+			/* already handled by a previous resync */
+			ptpsq->cq_stats->ooo_cqe_drop++;
+			return;
+		}
 		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id, budget);
+	}
 
 	skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
 	hwtstamp = mlx5e_cqe_ts_to_ns(sq->ptp_cyc2time, sq->clock, get_cqe_ts(cqe));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 15a5a57b47b85..1b3a65325ece1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -297,6 +297,8 @@ void mlx5e_skb_fifo_push(struct mlx5e_skb_fifo *fifo, struct sk_buff *skb)
 static inline
 struct sk_buff *mlx5e_skb_fifo_pop(struct mlx5e_skb_fifo *fifo)
 {
+	WARN_ON_ONCE(*fifo->pc == *fifo->cc);
+
 	return *mlx5e_skb_fifo_get(fifo, (*fifo->cc)++);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 03c1841970f14..f7f54550a8bbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -2121,6 +2121,7 @@ static const struct counter_desc ptp_cq_stats_desc[] = {
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, abort_abs_diff_ns) },
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, resync_cqe) },
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, resync_event) },
+	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, ooo_cqe_drop) },
 };
 
 static const struct counter_desc ptp_rq_stats_desc[] = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 9f781085be471..52a67efafcd37 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -459,6 +459,7 @@ struct mlx5e_ptp_cq_stats {
 	u64 abort_abs_diff_ns;
 	u64 resync_cqe;
 	u64 resync_event;
+	u64 ooo_cqe_drop;
 };
 
 struct mlx5e_stats {
-- 
2.39.2



