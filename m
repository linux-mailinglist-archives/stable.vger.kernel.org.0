Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB393FDC8D
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345557AbhIAMvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:51:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346405AbhIAMuL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A237561104;
        Wed,  1 Sep 2021 12:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500094;
        bh=sL1J6GCX0cXYB6pTbhNmDiPsvxDkc/vNW2Pl3uUkdy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ue4YI4YK65/pecEGNNdIIFHcmM86gQFhI1yi8lRCij2gJLAXNko894cArvt9bWPVu
         VsWQFEAjytWd71n5StdZaN1hfosFf9rAKf+lz0S9QMzD+MEijqRoU153ncyFIkgmwN
         P3o+uECdWrxOXt590osM4Gpgo5Q7Os/SCXoAPjOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 067/113] net: stmmac: add mutex lock to protect est parameters
Date:   Wed,  1 Sep 2021 14:28:22 +0200
Message-Id: <20210901122304.222144856@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
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
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 12 +++++++++++-
 include/linux/stmmac.h                          |  1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 4e70efc45458..fb5207dcbcaa 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -775,14 +775,18 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
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
@@ -813,6 +817,7 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 		priv->plat->est->gcl[i] = delta_ns | (gates << wid);
 	}
 
+	mutex_lock(&priv->plat->est->lock);
 	/* Adjust for real system time */
 	priv->ptp_clock_ops.gettime64(&priv->ptp_clock_ops, &current_time);
 	current_time_ns = timespec64_to_ktime(current_time);
@@ -837,8 +842,10 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	priv->plat->est->ctr[0] = do_div(ctr, NSEC_PER_SEC);
 	priv->plat->est->ctr[1] = (u32)ctr;
 
-	if (fpe && !priv->dma_cap.fpesel)
+	if (fpe && !priv->dma_cap.fpesel) {
+		mutex_unlock(&priv->plat->est->lock);
 		return -EOPNOTSUPP;
+	}
 
 	/* Actual FPE register configuration will be done after FPE handshake
 	 * is success.
@@ -847,6 +854,7 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 
 	ret = stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
 				   priv->plat->clk_ptp_rate);
+	mutex_unlock(&priv->plat->est->lock);
 	if (ret) {
 		netdev_err(priv->dev, "failed to configure EST\n");
 		goto disable;
@@ -862,9 +870,11 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	return 0;
 
 disable:
+	mutex_lock(&priv->plat->est->lock);
 	priv->plat->est->enable = false;
 	stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
 			     priv->plat->clk_ptp_rate);
+	mutex_unlock(&priv->plat->est->lock);
 
 	priv->plat->fpe_cfg->enable = false;
 	stmmac_fpe_configure(priv, priv->ioaddr,
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 0db36360ef21..cb7fbd747ae1 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -115,6 +115,7 @@ struct stmmac_axi {
 
 #define EST_GCL		1024
 struct stmmac_est {
+	struct mutex lock;
 	int enable;
 	u32 btr_offset[2];
 	u32 btr[2];
-- 
2.30.2



