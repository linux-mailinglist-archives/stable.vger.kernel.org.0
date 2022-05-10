Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061F952178D
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244019AbiEJN1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242819AbiEJNYv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:24:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258B254BCA;
        Tue, 10 May 2022 06:17:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B40716123F;
        Tue, 10 May 2022 13:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A4EC385C6;
        Tue, 10 May 2022 13:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188660;
        bh=9WcJbyhKyfzGMsCcZQ0zZD8M8VKozBDleT5fSmyAk5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLsHXNbUTnNOobZ2FNu4Q2GYCu9bGpkhJffqnZBfHknQPXITejIVhoehQqyzIxumu
         WuQyw3AeE1KZgNRaj8BZSLgUoNLpmbO3ejupZhjupOmgIoalkaDiT61EPboNNXlWcL
         5KGwccNAWpi4fiqs/lFztM2YX1XVnvKrT7GVzBTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Lemon <jonathan.lemon@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 39/78] net: bcmgenet: hide status block before TX timestamping
Date:   Tue, 10 May 2022 15:07:25 +0200
Message-Id: <20220510130733.691527722@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.522479698@linuxfoundation.org>
References: <20220510130732.522479698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>

[ Upstream commit acac0541d1d65e81e599ec399d34d184d2424401 ]

The hardware checksum offloading requires use of a transmit
status block inserted before the outgoing frame data, this was
updated in '9a9ba2a4aaaa ("net: bcmgenet: always enable status blocks")'

However, skb_tx_timestamp() assumes that it is passed a raw frame
and PTP parsing chokes on this status block.

Fix this by calling __skb_pull(), which hides the TSB before calling
skb_tx_timestamp(), so an outgoing PTP packet is parsed correctly.

As the data in the skb has already been set up for DMA, and the
dma_unmap_* calls use a separately stored address, there is no
no effective change in the data transmission.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220424165307.591145-1-jonathan.lemon@gmail.com
Fixes: d03825fba459 ("net: bcmgenet: add skb_tx_timestamp call")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index b819a9bde6cc..9bb398d05837 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1522,6 +1522,11 @@ static struct sk_buff *bcmgenet_put_tx_csum(struct net_device *dev,
 	return skb;
 }
 
+static void bcmgenet_hide_tsb(struct sk_buff *skb)
+{
+	__skb_pull(skb, sizeof(struct status_64));
+}
+
 static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
@@ -1632,6 +1637,8 @@ static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	GENET_CB(skb)->last_cb = tx_cb_ptr;
+
+	bcmgenet_hide_tsb(skb);
 	skb_tx_timestamp(skb);
 
 	/* Decrement total BD count and advance our write pointer */
-- 
2.35.1



