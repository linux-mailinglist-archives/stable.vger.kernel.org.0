Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDFAB4E2A30
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349098AbiCUOOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348608AbiCUOHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:07:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF6B40A1C;
        Mon, 21 Mar 2022 07:02:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB1BC61291;
        Mon, 21 Mar 2022 14:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B464CC340E8;
        Mon, 21 Mar 2022 14:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871334;
        bh=Rz97jaPjP8A5cEQQ+BaDGDxuBYyUviewzR5qgh6PjaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QtoCLTtsShC0xZAVE11m7DZfay7sC4LDVfYKAPEz+5fiwKeRLnojNShyvsWHE5ULZ
         XpsVgLvTH65m/thLSz+rFx66ZjWlUlaCv1j2sTikguZ13UU0uEAuv5V1YUE5/yqtVT
         cLu+oUF7VvScBXyCgc36zjih7HgRmsqlLCHGzCbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 24/37] net: bcmgenet: skip invalid partial checksums
Date:   Mon, 21 Mar 2022 14:53:06 +0100
Message-Id: <20220321133221.996805822@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.290173884@linuxfoundation.org>
References: <20220321133221.290173884@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 0f643c88c8d240eba0ea25c2e095a46515ff46e9 ]

The RXCHK block will return a partial checksum of 0 if it encounters
a problem while receiving a packet. Since a 1's complement sum can
only produce this result if no bits are set in the received data
stream it is fair to treat it as an invalid partial checksum and
not pass it up the stack.

Fixes: 810155397890 ("net: bcmgenet: use CHECKSUM_COMPLETE for NETIF_F_RXCSUM")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220317012812.1313196-1-opendmb@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 87f1056e29ff..2da804f84b48 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2287,8 +2287,10 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 		dma_length_status = status->length_status;
 		if (dev->features & NETIF_F_RXCSUM) {
 			rx_csum = (__force __be16)(status->rx_csum & 0xffff);
-			skb->csum = (__force __wsum)ntohs(rx_csum);
-			skb->ip_summed = CHECKSUM_COMPLETE;
+			if (rx_csum) {
+				skb->csum = (__force __wsum)ntohs(rx_csum);
+				skb->ip_summed = CHECKSUM_COMPLETE;
+			}
 		}
 
 		/* DMA flags and length are still valid no matter how
-- 
2.34.1



