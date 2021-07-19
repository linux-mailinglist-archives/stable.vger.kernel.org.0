Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1023CD9D3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242752AbhGSObs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244639AbhGSO3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:29:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 486CF6113B;
        Mon, 19 Jul 2021 15:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707428;
        bh=IcrrfMENSAMzCA8Bq393mwfNqrFuA/ur07uvUXWQVF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsapD+dQZQDy9v5wGXnYqaBvN4pNvO4LTYL9F5//4w//fACLOdBzgBvk6aTFev07F
         lkO5JcfozesrcM423mWqVz9lP+2CwAlRqTkI+bjSxxSOm+U3GAcYBoNXEG+FZI6MZJ
         SgAx3I1UelNLjvI7wKGtZz/yCZxoRocaQANqF/F4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, johannes@sipsolutions.net
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "linux-wireless@vger.kernel.org, stable@vger.kernel.org, Davis Mosenkovs" 
        <davis@mosenkovs.lv>, Davis Mosenkovs <davis@mosenkovs.lv>
Subject: [PATCH 4.9 160/245] mac80211: fix memory corruption in EAPOL handling
Date:   Mon, 19 Jul 2021 16:51:42 +0200
Message-Id: <20210719144945.576632083@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davis Mosenkovs <davis@mosenkovs.lv>

Commit e3d4030498c3 ("mac80211: do not accept/forward invalid EAPOL
frames") uses skb_mac_header() before eth_type_trans() is called
leading to incorrect pointer, the pointer gets written to. This issue
has appeared during backporting to 4.4, 4.9 and 4.14.

Fixes: e3d4030498c3 ("mac80211: do not accept/forward invalid EAPOL frames")
Link: https://lore.kernel.org/r/CAHQn7pKcyC_jYmGyTcPCdk9xxATwW5QPNph=bsZV8d-HPwNsyA@mail.gmail.com
Cc: <stable@vger.kernel.org> # 4.4.x
Signed-off-by: Davis Mosenkovs <davis@mosenkovs.lv>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2380,7 +2380,7 @@ ieee80211_deliver_skb(struct ieee80211_r
 #endif
 
 	if (skb) {
-		struct ethhdr *ehdr = (void *)skb_mac_header(skb);
+		struct ethhdr *ehdr = (struct ethhdr *)skb->data;
 
 		/* deliver to local stack */
 		skb->protocol = eth_type_trans(skb, dev);


