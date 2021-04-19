Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72EC3643C0
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240802AbhDSNV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241234AbhDSNUR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7211613AF;
        Mon, 19 Apr 2021 13:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838163;
        bh=85UwOZleb5MMezLJRbqBXJSUIHvG7ohGjfuE76Je+bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kITpcCRaPtJNaxlZv0uDf511igz4+GkpYHfrSojfyyMpCA+L0Ig4G6lPClRoV+RKm
         ww1zo9WnrRY4LYkY6jokS53ckGpQwiBD/UfcV7cv1xds8mtLVm+m+63XsRWC6DYZjd
         SQovu11ZAHEAJ/JV8OUO36jzQy79GVQGlY3mhVF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 065/103] net: macb: fix the restore of cmp registers
Date:   Mon, 19 Apr 2021 15:06:16 +0200
Message-Id: <20210419130530.045815390@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
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
@@ -3777,6 +3777,7 @@ static int macb_init(struct platform_dev
 	reg = gem_readl(bp, DCFG8);
 	bp->max_tuples = min((GEM_BFEXT(SCR2CMP, reg) / 3),
 			GEM_BFEXT(T2SCR, reg));
+	INIT_LIST_HEAD(&bp->rx_fs_list.list);
 	if (bp->max_tuples > 0) {
 		/* also needs one ethtype match to check IPv4 */
 		if (GEM_BFEXT(SCR2ETH, reg) > 0) {
@@ -3787,7 +3788,6 @@ static int macb_init(struct platform_dev
 			/* Filtering is supported in hw but don't enable it in kernel now */
 			dev->hw_features |= NETIF_F_NTUPLE;
 			/* init Rx flow definitions */
-			INIT_LIST_HEAD(&bp->rx_fs_list.list);
 			bp->rx_fs_list.count = 0;
 			spin_lock_init(&bp->rx_fs_lock);
 		} else


