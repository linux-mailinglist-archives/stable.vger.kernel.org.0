Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6425B20E6E8
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404574AbgF2Vvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:51:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbgF2Sfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34B2324744;
        Mon, 29 Jun 2020 15:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444065;
        bh=NMTP80wN+ewpTJxV9j+dBrPqhrhKQJgOIdEz6TaTsNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pMyZSv6iS/bHNTweW6qbWu7Ian979E2Ma3rSxVRadeWnqkhbBwmAUqJxVHuAPizqU
         fXgD5fOwg0bj/ol+Wm7Rxof6JloeUl9WiTSKsyGRR92Ca+irt5pTHX52l8B15pLan7
         GIdxDsOg6OUIBitVbhpCmxJ52gugdRgbxKtnk9g0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 174/265] socionext: account for napi_gro_receive never returning GRO_DROP
Date:   Mon, 29 Jun 2020 11:16:47 -0400
Message-Id: <20200629151818.2493727-175-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit e5e7d8052f6140985c03bd49ebaa0af9c2944bc6 ]

The napi_gro_receive function no longer returns GRO_DROP ever, making
handling GRO_DROP dead code. This commit removes that dead code.
Further, it's not even clear that device drivers have any business in
taking action after passing off received packets; that's arguably out of
their hands.

Fixes: 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in napi_gro_receive()")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/socionext/netsec.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index a5a0fb60193ab..5a70c49bf454f 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1038,8 +1038,9 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 
 next:
-		if ((skb && napi_gro_receive(&priv->napi, skb) != GRO_DROP) ||
-		    xdp_result) {
+		if (skb)
+			napi_gro_receive(&priv->napi, skb);
+		if (skb || xdp_result) {
 			ndev->stats.rx_packets++;
 			ndev->stats.rx_bytes += xdp.data_end - xdp.data;
 		}
-- 
2.25.1

