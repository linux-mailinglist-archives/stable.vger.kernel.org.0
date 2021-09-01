Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE183FDB52
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344422AbhIAMks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:40:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343913AbhIAMij (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:38:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E59861159;
        Wed,  1 Sep 2021 12:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499689;
        bh=pySdCGYihI+ExzWMNFD7ulEUI6Axx+Lr/eU8OFQ2kug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6buttQRD40quOU9ooQSKmEYbAoINbmb2l1mh6actMcfFFT8q9MkQe964Y1Mfjqi9
         T41Ekd5r0xdHG/zlOfhy+ln+UqttyMciFrDDEH477hmtPX60NGG70BTbABoJezzY1T
         6v5rwIE3m0A5nIyUR0IjwOJ1f3jXGvS2/klyanww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/103] net: stmmac: add mutex lock to protect est parameters
Date:   Wed,  1 Sep 2021 14:27:57 +0200
Message-Id: <20210901122302.156121465@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

[ Upstream commit b2aae654a4794ef898ad33a179f341eb610f6b85 ]

Add a mutex lock to protect est structure parameters so that the
EST parameters can be updated by other threads.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 13 ++++++++++++-
 include/linux/stmmac.h                          |  1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 40dc14d1415f..8c2eae2a7efd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -689,14 +689,18 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 					 GFP_KERNEL);
 		if (!plat->est)
 			return -ENOMEM;
+
+		mutex_init(&priv->plat->est->lock);
 	} else {
 		memset(plat->est, 0, sizeof(*plat->est));
 	}
 
 	size = qopt->num_entries;
 
+	mutex_lock(&priv->plat->est->lock);
 	priv->plat->est->gcl_size = size;
 	priv->plat->est->enable = qopt->enable;
+	mutex_unlock(&priv->plat->est->lock);
 
 	for (i = 0; i < size; i++) {
 		s64 delta_ns = qopt->entries[i].interval;
@@ -727,6 +731,7 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 		priv->plat->est->gcl[i] = delta_ns | (gates << wid);
 	}
 
+	mutex_lock(&priv->plat->est->lock);
 	/* Adjust for real system time */
 	priv->ptp_clock_ops.gettime64(&priv->ptp_clock_ops, &current_time);
 	current_time_ns = timespec64_to_ktime(current_time);
@@ -751,8 +756,10 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	priv->plat->est->ctr[0] = do_div(ctr, NSEC_PER_SEC);
 	priv->plat->est->ctr[1] = (u32)ctr;
 
-	if (fpe && !priv->dma_cap.fpesel)
+	if (fpe && !priv->dma_cap.fpesel) {
+		mutex_unlock(&priv->plat->est->lock);
 		return -EOPNOTSUPP;
+	}
 
 	ret = stmmac_fpe_configure(priv, priv->ioaddr,
 				   priv->plat->tx_queues_to_use,
@@ -764,6 +771,7 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 
 	ret = stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
 				   priv->plat->clk_ptp_rate);
+	mutex_unlock(&priv->plat->est->lock);
 	if (ret) {
 		netdev_err(priv->dev, "failed to configure EST\n");
 		goto disable;
@@ -773,9 +781,12 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	return 0;
 
 disable:
+	mutex_lock(&priv->plat->est->lock);
 	priv->plat->est->enable = false;
 	stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
 			     priv->plat->clk_ptp_rate);
+	mutex_unlock(&priv->plat->est->lock);
+
 	return ret;
 }
 
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 15ca6b4167cc..b56e1dedcf2f 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -112,6 +112,7 @@ struct stmmac_axi {
 
 #define EST_GCL		1024
 struct stmmac_est {
+	struct mutex lock;
 	int enable;
 	u32 btr_offset[2];
 	u32 btr[2];
-- 
2.30.2



