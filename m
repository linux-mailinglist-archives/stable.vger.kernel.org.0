Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C8C39622A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhEaOvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230518AbhEaOtl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:49:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 320F961C9D;
        Mon, 31 May 2021 13:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469434;
        bh=HJ7qAgUp3pfDTGdMoTByNj0yMeZBO441FzbToT+maD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AduvClokyIvzCCN9H3+VeC8AsfxQw+/eD3HH9vMHbECQj+2VS4r4Cj/pKVbEJgtZh
         S0vEXlHv1xnnlNo4Ntpa88OO2d7A/XeFssqMzogdf663WsA98L+xbLCt6yTG7ahZ4o
         yo9rXBwmreY/a0cMiZ0PL3FJE7Rg5G94FbkCKbvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 196/296] Revert "net: liquidio: fix a NULL pointer dereference"
Date:   Mon, 31 May 2021 15:14:11 +0200
Message-Id: <20210531130710.463681892@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 4fd798a5a89114c1892574c50f2aebd49bc5b4f5 ]

This reverts commit fe543b2f174f34a7a751aa08b334fe6b105c4569.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

While the original commit does keep the immediate "NULL dereference"
from happening, it does not properly propagate the error back to the
callers, AND it does not fix this same identical issue in the
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c for some reason.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: David S. Miller <davem@davemloft.net>
Link: https://lore.kernel.org/r/20210503115736.2104747-65-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/lio_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 7c5af4beedc6..6fa570068648 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1166,11 +1166,6 @@ static void send_rx_ctrl_cmd(struct lio *lio, int start_stop)
 	sc = (struct octeon_soft_command *)
 		octeon_alloc_soft_command(oct, OCTNET_CMD_SIZE,
 					  16, 0);
-	if (!sc) {
-		netif_info(lio, rx_err, lio->netdev,
-			   "Failed to allocate octeon_soft_command\n");
-		return;
-	}
 
 	ncmd = (union octnet_cmd *)sc->virtdptr;
 
-- 
2.30.2



