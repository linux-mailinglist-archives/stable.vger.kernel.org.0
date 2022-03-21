Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF68E4E294C
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348839AbiCUOEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349290AbiCUODf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:03:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C3117B884;
        Mon, 21 Mar 2022 07:00:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 919D66132F;
        Mon, 21 Mar 2022 14:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A202EC340E8;
        Mon, 21 Mar 2022 14:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871237;
        bh=M93oX6hsvrUhpN8B7XvzibrLcc4I2SIntqF+zDbjuwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzXx2fytyAPd1xS1QX31dhBRVPRIjq+BafO0gi4FaidP04WEmgOfQjljMisb2lPKV
         TSzLWY4nEMzv/lTnONlcvPxoVFSyqgz4zLE7Sl67zLrl5THPuwbj35cgO6YPwV7fbg
         Wi9yu8ndKCaGyWIyKwzVRd4ksIUiWsLfmb4I9AIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 22/32] net: bcmgenet: skip invalid partial checksums
Date:   Mon, 21 Mar 2022 14:52:58 +0100
Message-Id: <20220321133221.205761871@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133220.559554263@linuxfoundation.org>
References: <20220321133220.559554263@linuxfoundation.org>
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
index 9a67e24f46b2..b4f99dd284e5 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2243,8 +2243,10 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
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



