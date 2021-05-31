Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BE8395BF3
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbhEaN03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:26:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231837AbhEaNYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:24:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C874F613FA;
        Mon, 31 May 2021 13:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467228;
        bh=aTgG2riFV4u4JLKEo+ZITnnT3/960WFFm2TRp9q+8JY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jtmvuRkgRAVpTHzB0bGrHkJUIsAcuOBOf8EQiQgZ/x0r+G4c/HJ62sgGFBdZSgzjX
         N69oVbznf8rIHs08o1GfoD+P0iN1GQWyuruQCpK7RirFnQ8uH0sou1QPqrO/ZGnbLY
         Rj4W6pCc+BwU8lbo2sEANI1AMRwVZCiTf77T1K2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 54/66] net: netcp: Fix an error message
Date:   Mon, 31 May 2021 15:14:27 +0200
Message-Id: <20210531130637.965032742@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.254683895@linuxfoundation.org>
References: <20210531130636.254683895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ddb6e00f8413e885ff826e32521cff7924661de0 ]

'ret' is known to be 0 here.
The expected error code is stored in 'tx_pipe->dma_queue', so use it
instead.

While at it, switch from %d to %pe which is more user friendly.

Fixes: 84640e27f230 ("net: netcp: Add Keystone NetCP core ethernet driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/netcp_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index 32516661f180..a55e83a0946a 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1325,8 +1325,8 @@ int netcp_txpipe_open(struct netcp_tx_pipe *tx_pipe)
 	tx_pipe->dma_queue = knav_queue_open(name, tx_pipe->dma_queue_id,
 					     KNAV_QUEUE_SHARED);
 	if (IS_ERR(tx_pipe->dma_queue)) {
-		dev_err(dev, "Could not open DMA queue for channel \"%s\": %d\n",
-			name, ret);
+		dev_err(dev, "Could not open DMA queue for channel \"%s\": %pe\n",
+			name, tx_pipe->dma_queue);
 		ret = PTR_ERR(tx_pipe->dma_queue);
 		goto err;
 	}
-- 
2.30.2



