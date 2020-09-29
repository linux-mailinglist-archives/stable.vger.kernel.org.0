Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3663B27C7F9
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730233AbgI2L5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730728AbgI2Lmm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:42:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C4082076A;
        Tue, 29 Sep 2020 11:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379761;
        bh=KRKeUQKw05VcBoIIUdo4APnCM5j8pGKovFeyyHAl6Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ls9SGyWLUVNbBpx7Lb8VZ+/Cm49IDRwEWqF30+9og4xsOLH9JY8tdiHBtvQlSjpoj
         iOFH2XQlhv+ogN5lQvy3qLwU3tfAnxw2QrdwRr6KHKmRpmwGGS3O/XCFipIfb9wgGC
         DnfBhq4xooNBFDPjzX6KYCgImDrecr0NJXA3EdXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Markus Theil <markus.theil@tu-ilmenau.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 306/388] mac80211: skip mpath lookup also for control port tx
Date:   Tue, 29 Sep 2020 13:00:37 +0200
Message-Id: <20200929110025.280544119@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Markus Theil <markus.theil@tu-ilmenau.de>

[ Upstream commit 5af7fef39d7952c0f5551afa7b821ee7b6c9dd3d ]

When using 802.1X over mesh networks, at first an ordinary
mesh peering is established, then the 802.1X EAPOL dialog
happens, afterwards an authenticated mesh peering exchange
(AMPE) happens, finally the peering is complete and we can
set the STA authorized flag.

As 802.1X is an intermediate step here and key material is
not yet exchanged for stations we have to skip mesh path lookup
for these EAPOL frames. Otherwise the already configure mesh
group encryption key would be used to send a mesh path request
which no one can decipher, because we didn't already establish
key material on both peers, like with SAE and directly using AMPE.

Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
Link: https://lore.kernel.org/r/20200617082637.22670-2-markus.theil@tu-ilmenau.de
[remove pointless braces, remove unnecessary local variable,
 the list can only process one such frame (or its fragments)]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 30201aeb426cf..f029e75ec815a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3913,6 +3913,9 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		skb->prev = NULL;
 		skb->next = NULL;
 
+		if (skb->protocol == sdata->control_port_protocol)
+			ctrl_flags |= IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP;
+
 		skb = ieee80211_build_hdr(sdata, skb, info_flags,
 					  sta, ctrl_flags);
 		if (IS_ERR(skb))
@@ -5096,7 +5099,8 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 		return -EINVAL;
 
 	if (proto == sdata->control_port_protocol)
-		ctrl_flags |= IEEE80211_TX_CTRL_PORT_CTRL_PROTO;
+		ctrl_flags |= IEEE80211_TX_CTRL_PORT_CTRL_PROTO |
+			      IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP;
 
 	if (unencrypted)
 		flags = IEEE80211_TX_INTFL_DONT_ENCRYPT;
-- 
2.25.1



