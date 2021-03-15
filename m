Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFE933B843
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbhCOOCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231713AbhCOOAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EF0064F4A;
        Mon, 15 Mar 2021 14:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816801;
        bh=RFrcURexPVc/7XiA8umAE8xd45I932cHo1tF9FoaQUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P5oz5fCU+ChCodFYzUVOANYouwnKTZeEmoZDgQ7LIgj/uddt/KLx1ntF/+ozMUsvg
         cu4WuZjFzriy48jS/PN2SiDINNSCIeAEZEluLV6r447A+9W0c8nbRa2yXBbrhgGMXT
         uBtbWN0q0WZx4YbG6Ob59rYCMVMIuqa8bgoS9mMA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/290] net: dsa: tag_dsa: let DSA core deal with TX reallocation
Date:   Mon, 15 Mar 2021 14:53:35 +0100
Message-Id: <20210315135546.040050935@linuxfoundation.org>
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

[ Upstream commit 952a06345015867e3bd37f8d9045fc1429637d43 ]

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Similar to the EtherType DSA tagger, the old Marvell tagger can
transform an 802.1Q header if present into a DSA tag, so there is no
headroom required in that case. But we are ensuring that it exists,
regardless (practically speaking, the headroom must be 4 bytes larger
than it needs to be).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_dsa.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 0b756fae68a5..63d690a0fca6 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -23,9 +23,6 @@ static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * the ethertype field for untagged packets.
 	 */
 	if (skb->protocol == htons(ETH_P_8021Q)) {
-		if (skb_cow_head(skb, 0) < 0)
-			return NULL;
-
 		/*
 		 * Construct tagged FROM_CPU DSA tag from 802.1q tag.
 		 */
@@ -41,8 +38,6 @@ static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
 			dsa_header[2] &= ~0x10;
 		}
 	} else {
-		if (skb_cow_head(skb, DSA_HLEN) < 0)
-			return NULL;
 		skb_push(skb, DSA_HLEN);
 
 		memmove(skb->data, skb->data + DSA_HLEN, 2 * ETH_ALEN);
-- 
2.30.1



