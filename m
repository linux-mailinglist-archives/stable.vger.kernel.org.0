Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C5D40958B
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347760AbhIMOme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:42:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347757AbhIMOka (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:40:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C25E163156;
        Mon, 13 Sep 2021 13:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541371;
        bh=4l5ZrdaofJTOe11wHeeRAu2Ge5s16S2jwm6ZhcVMu/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0KInJnio4LqvYrtl4mZfq/9ByRZViCLm7rOaprnirWoYzFklXQ7atTAFvpsDJjzCw
         L1hfbZP7ZX/r4cyeB770mcoi6AgspoW4YrWw3ySL8n4hbiY3k2E9cxJR+/rsNtJNOC
         7SEUeSUvZoJLRkgEcMZ88198QKmK6uCnbnQgqqRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 270/334] net/mlx5e: Fix possible use-after-free deleting fdb rule
Date:   Mon, 13 Sep 2021 15:15:24 +0200
Message-Id: <20210913131122.543345389@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit 9a5f9cc794e17cf6ed2a5bb215d2e8b6832db444 ]

After neigh-update-add failure we are still with a slow path rule but
the driver always assume the rule is an fdb rule.
Fix neigh-update-del by checking slow path tc flag on the flow.
Also fix neigh-update-add for when neigh-update-del fails the same.

Fixes: 5dbe906ff1d5 ("net/mlx5e: Use a slow path rule instead if vxlan neighbour isn't available")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 2e846b741280..1c44c6c345f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -147,7 +147,7 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 	mlx5e_rep_queue_neigh_stats_work(priv);
 
 	list_for_each_entry(flow, flow_list, tmp_list) {
-		if (!mlx5e_is_offloaded_flow(flow))
+		if (!mlx5e_is_offloaded_flow(flow) || !flow_flag_test(flow, SLOW))
 			continue;
 		attr = flow->attr;
 		esw_attr = attr->esw_attr;
@@ -188,7 +188,7 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 	int err;
 
 	list_for_each_entry(flow, flow_list, tmp_list) {
-		if (!mlx5e_is_offloaded_flow(flow))
+		if (!mlx5e_is_offloaded_flow(flow) || flow_flag_test(flow, SLOW))
 			continue;
 		attr = flow->attr;
 		esw_attr = attr->esw_attr;
-- 
2.30.2



