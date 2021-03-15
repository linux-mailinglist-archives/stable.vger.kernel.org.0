Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB1933B689
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbhCON6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231904AbhCON5d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB72D64F05;
        Mon, 15 Mar 2021 13:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816653;
        bh=rzT91xFi5CSgXz3amxkHUuCpim2XmCzSMYdvJbcna9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fq17ApAWspDrXVqXoxDOfD27u+aJze5sHXnLi9GhNMypO0HNjE61x9udCjPP+FZyR
         7IbHvr2ty25gyYLq+smSIwnOUEQ65K9ZR4uk8qqCyf5Jbtc130hdb/O/5hsAV9WjOa
         d4mO2c6XKl30DK3v6x4GTkBgzSZa3kNS0rwNfD6U=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 035/290] net: dsa: tag_rtl4_a: fix egress tags
Date:   Mon, 15 Mar 2021 14:52:08 +0100
Message-Id: <20210315135543.109508081@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: DENG Qingfang <dqfext@gmail.com>

commit 9eb8bc593a5eed167dac2029abef343854c5ba75 upstream.

Commit 86dd9868b878 has several issues, but was accepted too soon
before anyone could take a look.

- Double free. dsa_slave_xmit() will free the skb if the xmit function
  returns NULL, but the skb is already freed by eth_skb_pad(). Use
  __skb_put_padto() to avoid that.
- Unnecessary allocation. It has been done by DSA core since commit
  a3b0b6479700.
- A u16 pointer points to skb data. It should be __be16 for network
  byte order.
- Typo in comments. "numer" -> "number".

Fixes: 86dd9868b878 ("net: dsa: tag_rtl4_a: Support also egress tags")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/tag_rtl4_a.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -35,14 +35,12 @@ static struct sk_buff *rtl4a_tag_xmit(st
 				      struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	__be16 *p;
 	u8 *tag;
-	u16 *p;
 	u16 out;
 
 	/* Pad out to at least 60 bytes */
-	if (unlikely(eth_skb_pad(skb)))
-		return NULL;
-	if (skb_cow_head(skb, RTL4_A_HDR_LEN) < 0)
+	if (unlikely(__skb_put_padto(skb, ETH_ZLEN, false)))
 		return NULL;
 
 	netdev_dbg(dev, "add realtek tag to package to port %d\n",
@@ -53,13 +51,13 @@ static struct sk_buff *rtl4a_tag_xmit(st
 	tag = skb->data + 2 * ETH_ALEN;
 
 	/* Set Ethertype */
-	p = (u16 *)tag;
+	p = (__be16 *)tag;
 	*p = htons(RTL4_A_ETHERTYPE);
 
 	out = (RTL4_A_PROTOCOL_RTL8366RB << 12) | (2 << 8);
-	/* The lower bits is the port numer */
+	/* The lower bits is the port number */
 	out |= (u8)dp->index;
-	p = (u16 *)(tag + 2);
+	p = (__be16 *)(tag + 2);
 	*p = htons(out);
 
 	return skb;


