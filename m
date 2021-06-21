Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B773AEE09
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhFUQZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:25:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230205AbhFUQX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:23:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B923613B4;
        Mon, 21 Jun 2021 16:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292442;
        bh=gzDejNICy4bQYydZ8dUtj9LevACs+31+dQ4Og9AmULY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HOiZ5idR4p3ZcwgoIKkfZlswjYA97rW6o6rh71zyddk/a9i5vrqPDsIycbCh7tQcR
         DeQhMcFKH+axvWy+lk0x1feWSRxYseC1YNu453fy89dd5gcyevGL+WR/tj2tmvuDgq
         8fpJqeDHMJTtcjAwXygsZ73DbVUZ4UWpbdB+A2Fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Esben Haabendal <esben@geanix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 75/90] net: ll_temac: Fix TX BD buffer overwrite
Date:   Mon, 21 Jun 2021 18:15:50 +0200
Message-Id: <20210621154906.695309818@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Esben Haabendal <esben@geanix.com>

commit c364df2489b8ef2f5e3159b1dff1ff1fdb16040d upstream.

Just as the initial check, we need to ensure num_frag+1 buffers available,
as that is the number of buffers we are going to use.

This fixes a buffer overflow, which might be seen during heavy network
load. Complete lockup of TEMAC was reproducible within about 10 minutes of
a particular load.

Fixes: 84823ff80f74 ("net: ll_temac: Fix race condition causing TX hang")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -846,7 +846,7 @@ temac_start_xmit(struct sk_buff *skb, st
 		smp_mb();
 
 		/* Space might have just been freed - check again */
-		if (temac_check_tx_bd_space(lp, num_frag))
+		if (temac_check_tx_bd_space(lp, num_frag + 1))
 			return NETDEV_TX_BUSY;
 
 		netif_wake_queue(ndev);


