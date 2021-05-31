Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F8F395D6E
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbhEaNpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:45:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231814AbhEaNnk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:43:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E46B161494;
        Mon, 31 May 2021 13:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467742;
        bh=sKaT5YixtxzQyKlLv9HkAvXC+U1pkCLhdK2nykBu0ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yI05T77fDIIGqQBX+VgcXUERGHK6CwkHcmJln9M9JzsZ4I0IpFbJ+bwXiaKVyb4GS
         UTd5fH0IQcKlR/fxHyzG5P8TZIVhBejrsxcDLqfiS828MpXjVqdYPcO92JD7+2yRDA
         MkEMjdD/XYkCaEBAFTQE9ZXcaKHaIEFEDFmoSBFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 63/79] net: netcp: Fix an error message
Date:   Mon, 31 May 2021 15:14:48 +0200
Message-Id: <20210531130638.013062405@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
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
index 437d36289786..67167bc49a3a 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1364,8 +1364,8 @@ int netcp_txpipe_open(struct netcp_tx_pipe *tx_pipe)
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



