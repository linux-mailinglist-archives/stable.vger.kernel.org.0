Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52B794D719
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbfFTSQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729711AbfFTSQE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:16:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26F47208CA;
        Thu, 20 Jun 2019 18:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054562;
        bh=A0ZMX69gc3yuNN1AmuTtB2l1SGUCCmEgsDeBG7r0wa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzty2LQPaNRx6e3yYKHi1GbhxVCMb3KF4r9hJ7ec08lVsW/cyyvUE+1Bka27AmH4S
         kaSwtHgcjWH65riUkM3VYFL41SLmeujqrNbPUEBdrpdfYtb/EhfoLr37U2y5oYtD0d
         2lQA20IFfjjOZnp/zkzVyGtpE/sOu5Y9IXJl8yik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 71/98] dpaa_eth: use only online CPU portals
Date:   Thu, 20 Jun 2019 19:57:38 +0200
Message-Id: <20190620174352.739435973@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7aae703f8096d21e34ce5f34f16715587bc30902 ]

Make sure only the portals for the online CPUs are used.
Without this change, there are issues when someone boots with
maxcpus=n, with n < actual number of cores available as frames
either received or corresponding to the transmit confirmation
path would be offered for dequeue to the offline CPU portals,
getting lost.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     | 9 ++++-----
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c | 4 ++--
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index d3f2408dc9e8..f38c3fa7d705 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -780,7 +780,7 @@ static void dpaa_eth_add_channel(u16 channel)
 	struct qman_portal *portal;
 	int cpu;
 
-	for_each_cpu(cpu, cpus) {
+	for_each_cpu_and(cpu, cpus, cpu_online_mask) {
 		portal = qman_get_affine_portal(cpu);
 		qman_p_static_dequeue_add(portal, pool);
 	}
@@ -896,7 +896,7 @@ static void dpaa_fq_setup(struct dpaa_priv *priv,
 	u16 channels[NR_CPUS];
 	struct dpaa_fq *fq;
 
-	for_each_cpu(cpu, affine_cpus)
+	for_each_cpu_and(cpu, affine_cpus, cpu_online_mask)
 		channels[num_portals++] = qman_affine_channel(cpu);
 
 	if (num_portals == 0)
@@ -2174,7 +2174,6 @@ static int dpaa_eth_poll(struct napi_struct *napi, int budget)
 	if (cleaned < budget) {
 		napi_complete_done(napi, cleaned);
 		qman_p_irqsource_add(np->p, QM_PIRQ_DQRI);
-
 	} else if (np->down) {
 		qman_p_irqsource_add(np->p, QM_PIRQ_DQRI);
 	}
@@ -2448,7 +2447,7 @@ static void dpaa_eth_napi_enable(struct dpaa_priv *priv)
 	struct dpaa_percpu_priv *percpu_priv;
 	int i;
 
-	for_each_possible_cpu(i) {
+	for_each_online_cpu(i) {
 		percpu_priv = per_cpu_ptr(priv->percpu_priv, i);
 
 		percpu_priv->np.down = 0;
@@ -2461,7 +2460,7 @@ static void dpaa_eth_napi_disable(struct dpaa_priv *priv)
 	struct dpaa_percpu_priv *percpu_priv;
 	int i;
 
-	for_each_possible_cpu(i) {
+	for_each_online_cpu(i) {
 		percpu_priv = per_cpu_ptr(priv->percpu_priv, i);
 
 		percpu_priv->np.down = 1;
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index bdee441bc3b7..7ce2e99b594d 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -569,7 +569,7 @@ static int dpaa_set_coalesce(struct net_device *dev,
 	qman_dqrr_get_ithresh(portal, &prev_thresh);
 
 	/* set new values */
-	for_each_cpu(cpu, cpus) {
+	for_each_cpu_and(cpu, cpus, cpu_online_mask) {
 		portal = qman_get_affine_portal(cpu);
 		res = qman_portal_set_iperiod(portal, period);
 		if (res)
@@ -586,7 +586,7 @@ static int dpaa_set_coalesce(struct net_device *dev,
 
 revert_values:
 	/* restore previous values */
-	for_each_cpu(cpu, cpus) {
+	for_each_cpu_and(cpu, cpus, cpu_online_mask) {
 		if (!needs_revert[cpu])
 			continue;
 		portal = qman_get_affine_portal(cpu);
-- 
2.20.1



