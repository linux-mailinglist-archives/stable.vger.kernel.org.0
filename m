Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8F731013CC
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbfKSF13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:27:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727723AbfKSF13 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:27:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EA7A21783;
        Tue, 19 Nov 2019 05:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141248;
        bh=DWeebrJx8H6xViZvK61SrP4XsgVD2r/OoVtegmbXWEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obbf7Ch7cof48zmWoBy+cBeHiJBsbLZOwmOQVuRq1nZ/5rgUDitMniQYu5/+hy7Ow
         tvCaC+G1zD8FUObuV+akiqP4GcySZRMtKalq723PYtUk6w9zFkHyNHOg9Ie9zSQT88
         2C1CDEkHz31ko8FBvXVROM3Zrdh8jD9/g31qAvHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dedy Lansky <dlansky@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/422] wil6210: drop Rx multicast packets that are looped-back to STA
Date:   Tue, 19 Nov 2019 06:14:14 +0100
Message-Id: <20191119051403.459992899@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

[ Upstream commit 9a65064abdf82934e0ed4744125f9f466f421f57 ]

Delivering a looped-back multicast packet to network stack can cause
higher layer protocols to fail like for example IPv6 DAD.
In STA mode, upon receiving Rx multicast packet, check if the source
MAC address is equal to our own MAC address and if so drop the packet.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 1b1b58e0129a3..25a65ca424c84 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -766,7 +766,14 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 		return;
 	}
 
-	if (wdev->iftype == NL80211_IFTYPE_AP && !vif->ap_isolate) {
+	if (wdev->iftype == NL80211_IFTYPE_STATION) {
+		if (mcast && ether_addr_equal(eth->h_source, ndev->dev_addr)) {
+			/* mcast packet looped back to us */
+			rc = GRO_DROP;
+			dev_kfree_skb(skb);
+			goto stats;
+		}
+	} else if (wdev->iftype == NL80211_IFTYPE_AP && !vif->ap_isolate) {
 		if (mcast) {
 			/* send multicast frames both to higher layers in
 			 * local net stack and back to the wireless medium
-- 
2.20.1



