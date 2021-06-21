Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927F53AEF10
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhFUQfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232308AbhFUQdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:33:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D95FD613D1;
        Mon, 21 Jun 2021 16:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292793;
        bh=e/euqjV2yE9+gV+RI8fynVejNkPLYrzrh/Y66KQjMqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x9qB3y+Mv4VbH3lMfDYKYhlL6L+7YF5XiNyndJ25ZGQxA821z71sySD22t8uxeiSH
         rIubKDY/7SqKzP+eyGUgf9lsYGesCizd567LMdkN8bCaZFcDr+TN9YzanlGWinnOSv
         91ccwcKhCzIv24gBAkOZ7TBqStFL3H4nvORbooFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Esben Haabendal <esben@geanix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 133/146] net: ll_temac: Fix TX BD buffer overwrite
Date:   Mon, 21 Jun 2021 18:16:03 +0200
Message-Id: <20210621154920.019600162@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
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
@@ -849,7 +849,7 @@ temac_start_xmit(struct sk_buff *skb, st
 		smp_mb();
 
 		/* Space might have just been freed - check again */
-		if (temac_check_tx_bd_space(lp, num_frag))
+		if (temac_check_tx_bd_space(lp, num_frag + 1))
 			return NETDEV_TX_BUSY;
 
 		netif_wake_queue(ndev);


