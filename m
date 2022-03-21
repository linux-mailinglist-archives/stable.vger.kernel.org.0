Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72054E290E
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348569AbiCUOBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348635AbiCUOAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:00:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFB033E9B;
        Mon, 21 Mar 2022 06:58:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C05BBB816C8;
        Mon, 21 Mar 2022 13:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148C0C340E8;
        Mon, 21 Mar 2022 13:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871134;
        bh=CjL/5lpWAEaZS+q0TB+7Ysy9hllqnIj2eeqoVU0PgtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+4KIcc+Ao5ZCDLfKN9S9kcW7rAUjiYkyUD+fLHkIudQvr/sa3Nv0Rz482YxuDbXe
         nZbRM3gFRrHtC8VA4llWn/n6/u+P30DNcZKI+Z39yRIipF3WChFqbmuMm33ZCmlZ81
         IU1GRs2f5f1VjAZP9zClY0b+KKZpaViWba2Hd7+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/30] net: bcmgenet: skip invalid partial checksums
Date:   Mon, 21 Mar 2022 14:52:47 +0100
Message-Id: <20220321133220.145489200@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133219.643490199@linuxfoundation.org>
References: <20220321133219.643490199@linuxfoundation.org>
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
index e19cf020e5ae..a2062144d7ca 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2239,8 +2239,10 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
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



