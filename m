Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B495433B83A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbhCOOC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232933AbhCOOAM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF26364E4D;
        Mon, 15 Mar 2021 13:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816798;
        bh=iU51+qiRO0O6uZ2xgnCgNrGd4iUnUycf6tBqgeK7pTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mTYi4FTcCQH0fueKdUWUBZ/ImsU83na3Akpm2DQLxyRAOUiubAGEC+Kubs9SYPrj8
         63sxwB2BDdzJ/wLAi+YjNUdVfHBNR4GDetyeFPivROuBPQiNrCuNqF9NrwovTqRuue
         x4q48KZSkacD+b9gWFib40U5g5i3Tieaxqo9n8S4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/290] net: dsa: tag_edsa: let DSA core deal with TX reallocation
Date:   Mon, 15 Mar 2021 14:53:33 +0100
Message-Id: <20210315135545.975872489@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit c6c4e1237dfe731644e79fa06d073625f28cd945 ]

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Note that the VLAN code path needs a smaller extra headroom than the
regular EtherType DSA path. That isn't a problem, because this tagger
declares the larger tag length (8 bytes vs 4) as the protocol overhead,
so we are covered in both cases.

Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_edsa.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/dsa/tag_edsa.c b/net/dsa/tag_edsa.c
index 120614240319..abf70a29deb4 100644
--- a/net/dsa/tag_edsa.c
+++ b/net/dsa/tag_edsa.c
@@ -35,8 +35,6 @@ static struct sk_buff *edsa_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * current ethertype field if the packet is untagged.
 	 */
 	if (skb->protocol == htons(ETH_P_8021Q)) {
-		if (skb_cow_head(skb, DSA_HLEN) < 0)
-			return NULL;
 		skb_push(skb, DSA_HLEN);
 
 		memmove(skb->data, skb->data + DSA_HLEN, 2 * ETH_ALEN);
@@ -60,8 +58,6 @@ static struct sk_buff *edsa_xmit(struct sk_buff *skb, struct net_device *dev)
 			edsa_header[6] &= ~0x10;
 		}
 	} else {
-		if (skb_cow_head(skb, EDSA_HLEN) < 0)
-			return NULL;
 		skb_push(skb, EDSA_HLEN);
 
 		memmove(skb->data, skb->data + EDSA_HLEN, 2 * ETH_ALEN);
-- 
2.30.1



