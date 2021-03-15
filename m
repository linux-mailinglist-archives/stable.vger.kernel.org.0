Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2061733B833
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbhCOOCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232919AbhCOOAL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3075764F37;
        Mon, 15 Mar 2021 13:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816796;
        bh=nv8CHzVD7f2ZaIXac4duHpgpItPYqcxNlTfWIkDoVNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PdkalrzG5BYvRGmyhqR6pgJrbT97J7mt7SrWHwt9aUB4rwS0G85Ffm2fewM5C3ZjF
         Gm7yIeF5CTiYo8xOI3c+31a/IkSG8zKuvClv/ku4GSfhiswT18g59BumaUa4xfo4vn
         CXK7QpiHEUKBFLoB2P73WzFV1PVrmwsAj4ZCuzpA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/290] net: dsa: tag_lan9303: let DSA core deal with TX reallocation
Date:   Mon, 15 Mar 2021 14:53:32 +0100
Message-Id: <20210315135545.943540785@linuxfoundation.org>
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

[ Upstream commit 6ed94135f58372cdec34cafb60f7596893b0b371 ]

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_lan9303.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index ccfb6f641bbf..aa1318dccaf0 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -58,15 +58,6 @@ static struct sk_buff *lan9303_xmit(struct sk_buff *skb, struct net_device *dev)
 	__be16 *lan9303_tag;
 	u16 tag;
 
-	/* insert a special VLAN tag between the MAC addresses
-	 * and the current ethertype field.
-	 */
-	if (skb_cow_head(skb, LAN9303_TAG_LEN) < 0) {
-		dev_dbg(&dev->dev,
-			"Cannot make room for the special tag. Dropping packet\n");
-		return NULL;
-	}
-
 	/* provide 'LAN9303_TAG_LEN' bytes additional space */
 	skb_push(skb, LAN9303_TAG_LEN);
 
-- 
2.30.1



