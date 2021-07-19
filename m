Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E07E3CDBF7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239398AbhGSOum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237769AbhGSOoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:44:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD20C61351;
        Mon, 19 Jul 2021 15:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708163;
        bh=Zcos7YUKack1/HCELWL80ho/jZyblcu6oGVU/TBX8y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqJ5hxyC0+KfYsbvEJTUiq23+MpvlnFlxTmBUQy0dpH6+wI8iS+QJidAX2N5uPno+
         /UyyogTumhDZcls0mL6aWBDSurCnfwnLIrKieAaVbbAwv2st937zAE4komhgqfhGXQ
         jcWUTkJwDUsldjrcnqDHJdIRZdRF8gc6qtrJjFaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, johannes@sipsolutions.net
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "linux-wireless@vger.kernel.org, stable@vger.kernel.org, Davis Mosenkovs" 
        <davis@mosenkovs.lv>, Davis Mosenkovs <davis@mosenkovs.lv>
Subject: [PATCH 4.14 205/315] mac80211: fix memory corruption in EAPOL handling
Date:   Mon, 19 Jul 2021 16:51:34 +0200
Message-Id: <20210719144950.170089499@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
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
@@ -2404,7 +2404,7 @@ ieee80211_deliver_skb(struct ieee80211_r
 #endif
 
 	if (skb) {
-		struct ethhdr *ehdr = (void *)skb_mac_header(skb);
+		struct ethhdr *ehdr = (struct ethhdr *)skb->data;
 
 		/* deliver to local stack */
 		skb->protocol = eth_type_trans(skb, dev);


