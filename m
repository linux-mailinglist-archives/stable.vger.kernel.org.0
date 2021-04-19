Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A34C364448
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241593AbhDSN0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242064AbhDSNZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:25:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5624C613C2;
        Mon, 19 Apr 2021 13:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838424;
        bh=a5wCfOGJQWW5KdkqJShWnNNebQHSGOal7vr47/aMm/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sa31m7vuKekbmTr0brXtKBfGzyQOUJI7irp3wsKheFx38HBpmFCwLMGLdMQIacMqu
         Ej1KmOCzSP06sUtCLdTwqgWrDnQhXq5LmSoTl1slCXeHJjBHnT1aIzlz+hVBKtAZLM
         XooWTMEiECukh3P3t8MrytGA/Lqov0ZRrASDmQPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 54/73] net: macb: fix the restore of cmp registers
Date:   Mon, 19 Apr 2021 15:06:45 +0200
Message-Id: <20210419130525.570992940@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

commit a714e27ea8bdee2b238748029d31472d0a65b611 upstream.

Commit a14d273ba159 ("net: macb: restore cmp registers on resume path")
introduces the restore of CMP registers on resume path. In case the IP
doesn't support type 2 screeners (zero on DCFG8 register) the
struct macb::rx_fs_list::list is not initialized and thus the
list_for_each_entry(item, &bp->rx_fs_list.list, list) loop introduced in
commit a14d273ba159 ("net: macb: restore cmp registers on resume path")
will access an uninitialized list leading to crash. Thus, initialize
the struct macb::rx_fs_list::list without taking into account if the
IP supports type 2 screeners or not.

Fixes: a14d273ba159 ("net: macb: restore cmp registers on resume path")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3590,6 +3590,7 @@ static int macb_init(struct platform_dev
 	reg = gem_readl(bp, DCFG8);
 	bp->max_tuples = min((GEM_BFEXT(SCR2CMP, reg) / 3),
 			GEM_BFEXT(T2SCR, reg));
+	INIT_LIST_HEAD(&bp->rx_fs_list.list);
 	if (bp->max_tuples > 0) {
 		/* also needs one ethtype match to check IPv4 */
 		if (GEM_BFEXT(SCR2ETH, reg) > 0) {
@@ -3600,7 +3601,6 @@ static int macb_init(struct platform_dev
 			/* Filtering is supported in hw but don't enable it in kernel now */
 			dev->hw_features |= NETIF_F_NTUPLE;
 			/* init Rx flow definitions */
-			INIT_LIST_HEAD(&bp->rx_fs_list.list);
 			bp->rx_fs_list.count = 0;
 			spin_lock_init(&bp->rx_fs_lock);
 		} else


