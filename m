Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFCE11CE2
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbfEBP0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:26:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727145AbfEBP0A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:26:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4878A20675;
        Thu,  2 May 2019 15:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810759;
        bh=qQn0/K5CrRb6a/UDIpJ0+TmSgtkLdapNLzx/sKNBoVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxt9aYoT+wR+xwBYwiLqNGB6To0o5Pr48t5tCXZnZ4Fv4HjsQEGPFAAouJnkLz23w
         GcVrNKPSzxFDS9faRugG8xVONCWWb6vt922HSRILlJ563b6wyD2FzsrvAaXgkCwRYG
         9V2uug7VDesY7cy87yeeNhsTJSNJ1Py5Mf5Wo7PQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nokia.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.19 11/72] net: stmmac: dont set own bit too early for jumbo frames
Date:   Thu,  2 May 2019 17:20:33 +0200
Message-Id: <20190502143334.324197718@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
References: <20190502143333.437607839@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 80acbed9f8fca1db3fbe915540b756f048aa0fd7 ]

Commit 0e80bdc9a72d ("stmmac: first frame prep at the end of xmit
routine") overlooked jumbo frames when re-ordering the code, and as a
result the own bit was not getting set anymore for the first jumbo frame
descriptor. Commit 487e2e22ab79 ("net: stmmac: Set OWN bit for jumbo
frames") tried to fix this, but now the bit is getting set too early and
the DMA may start while we are still setting up the remaining descriptors.
And with the chain mode the own bit remains still unset.

Fix by setting the own bit at the end of xmit also with jumbo frames.

Fixes: 0e80bdc9a72d ("stmmac: first frame prep at the end of xmit routine")
Fixes: 487e2e22ab79 ("net: stmmac: Set OWN bit for jumbo frames")
Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Acked-by: Jose Abreu <joabreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 62460a5b4ad9..39c105092214 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3195,14 +3195,16 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 		stmmac_prepare_tx_desc(priv, first, 1, nopaged_len,
 				csum_insertion, priv->mode, 1, last_segment,
 				skb->len);
-
-		/* The own bit must be the latest setting done when prepare the
-		 * descriptor and then barrier is needed to make sure that
-		 * all is coherent before granting the DMA engine.
-		 */
-		wmb();
+	} else {
+		stmmac_set_tx_owner(priv, first);
 	}
 
+	/* The own bit must be the latest setting done when prepare the
+	 * descriptor and then barrier is needed to make sure that
+	 * all is coherent before granting the DMA engine.
+	 */
+	wmb();
+
 	netdev_tx_sent_queue(netdev_get_tx_queue(dev, queue), skb->len);
 
 	stmmac_enable_dma_transmission(priv, priv->ioaddr);
-- 
2.19.1



