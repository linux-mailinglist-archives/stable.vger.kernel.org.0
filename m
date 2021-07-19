Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6FA3CD831
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242845AbhGSOVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:21:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242619AbhGSOUL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:20:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98B2461073;
        Mon, 19 Jul 2021 15:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706850;
        bh=mMIS+Y5t42SGI2NUOoLIFM4/YIJr4m7BFnO3ggN34KQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Su0aZFM8jDhVMdmFNdutsRBQjKl2/0j+smW7g09nFfepoWigOPjI9kPOlwyH24jqf
         uVRWvxgIy25c7j369jX9Wc8IHrYEV/eMQ8NTp+dhnsDg68dr4I2spQXY03fmmYXfId
         ENKwSCY4eX86JIe3kf6QVh0dtVvHB/Lowcyw3ShE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, johannes@sipsolutions.net
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "linux-wireless@vger.kernel.org, stable@vger.kernel.org, Davis Mosenkovs" 
        <davis@mosenkovs.lv>, Davis Mosenkovs <davis@mosenkovs.lv>
Subject: [PATCH 4.4 126/188] mac80211: fix memory corruption in EAPOL handling
Date:   Mon, 19 Jul 2021 16:51:50 +0200
Message-Id: <20210719144940.616512993@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
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
@@ -2234,7 +2234,7 @@ ieee80211_deliver_skb(struct ieee80211_r
 #endif
 
 	if (skb) {
-		struct ethhdr *ehdr = (void *)skb_mac_header(skb);
+		struct ethhdr *ehdr = (struct ethhdr *)skb->data;
 
 		/* deliver to local stack */
 		skb->protocol = eth_type_trans(skb, dev);


