Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4821CAB0B
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgEHMjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727889AbgEHMjS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B09C021835;
        Fri,  8 May 2020 12:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941556;
        bh=L6nWKzvXisLJ9SUYs6xKsGRTVvesEBjOfyTT5CiIIL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/bxdruIUT1WB7xnUaNWoOvnBuR3YtjswUk0aEPQpeSI437ddjwJjvPUkxH+fFBBS
         iZyl5R7EVyUmznDx7I/TFQHma6tfBtL3hdeFV8gE279Yyj/WCAapB5NzgVC17OPJL+
         7XTBSzX180iS8QbuaW78sBSiqUDlqyR62069LqFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 079/312] net/mlx5e: Fix blue flame quota logic
Date:   Fri,  8 May 2020 14:31:10 +0200
Message-Id: <20200508123130.075466608@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

commit 0ca00fc1f808602137dc6d51f17747b3bb0fc34d upstream.

Blue flame is a latency enhancement feature that allows the driver to
write the packet data directly to the NIC's registers thus making the
read of the packet data from host memory redundant.

We maintain a quota for the blue flame which is reloaded whenever we
identify that the hardware is processing send requests and processes
them fast enough so by the time we post the next send request it was
able to process all the pending ones. This indicates that the hardware
is capable of processing more blue flame requests efficiently. The blue
flame quota is decremented whenever we send using blue flame.

The current code erroneously clears the budget if we did not use blue
flame for the current post send operation and we fix it here.

Fixes: 88a85f99e51f ('net/mlx5e: TX latency optimization to save DMA reads')
Signed-off-by: Eli Cohen <eli@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -290,7 +290,8 @@ static netdev_tx_t mlx5e_sq_xmit(struct
 	while ((sq->pc & wq->sz_m1) > sq->edge)
 		mlx5e_send_nop(sq, false);
 
-	sq->bf_budget = bf ? sq->bf_budget - 1 : 0;
+	if (bf)
+		sq->bf_budget--;
 
 	sq->stats.packets++;
 	return NETDEV_TX_OK;


