Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD000451DF8
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349507AbhKPAeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344075AbhKOTXN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBA7463466;
        Mon, 15 Nov 2021 18:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002277;
        bh=AVW31n9fzhRQNes/25i+9GEMvMYh2gqpgZHO63OX+mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZT8rliRqPI0Q5lTUbEXqnbTzWzDM4pDxDgshguPmueQNzPSpDfDZJgfOpFU7OCADx
         1tbwaQFBw9xfrKGApm6hmIRJr4yt0vKVvKENxm0IxDFUtqqt56rgRkhEz+5gfPjelr
         xUtbsI+L2rnLxe8/FDkqkXeHgFMwx/NTJUAhvKb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Hainke <vincent@systemli.org>,
        Felix Fietkau <nbd@nbd.name>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 505/917] mt76: mt7615: mt7622: fix ibss and meshpoint
Date:   Mon, 15 Nov 2021 18:00:00 +0100
Message-Id: <20211115165445.892284081@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Hainke <vincent@systemli.org>

[ Upstream commit 753453afacc0243bd45de45e34218a8d17493e8f ]

commit 7f4b7920318b ("mt76: mt7615: add ibss support") introduced IBSS
and commit f4ec7fdf7f83 ("mt76: mt7615: enable support for mesh")
meshpoint support.

Both used in the "get_omac_idx"-function:

	if (~mask & BIT(HW_BSSID_0))
		return HW_BSSID_0;

With commit d8d59f66d136 ("mt76: mt7615: support 16 interfaces") the
ibss and meshpoint mode should "prefer hw bssid slot 1-3". However,
with that change the ibss or meshpoint mode will not send any beacon on
the mt7622 wifi anymore. Devices were still able to exchange data but
only if a bssid already existed. Two mt7622 devices will never be able
to communicate.

This commits reverts the preferation of slot 1-3 for ibss and
meshpoint. Only NL80211_IFTYPE_STATION will still prefer slot 1-3.

Tested on Banana Pi R64.

Fixes: d8d59f66d136 ("mt76: mt7615: support 16 interfaces")
Signed-off-by: Nick Hainke <vincent@systemli.org>
Acked-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211007225725.2615-1-vincent@systemli.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index dada43d6d879e..51260a669d166 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -135,8 +135,6 @@ static int get_omac_idx(enum nl80211_iftype type, u64 mask)
 	int i;
 
 	switch (type) {
-	case NL80211_IFTYPE_MESH_POINT:
-	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_STATION:
 		/* prefer hw bssid slot 1-3 */
 		i = get_free_idx(mask, HW_BSSID_1, HW_BSSID_3);
@@ -160,6 +158,8 @@ static int get_omac_idx(enum nl80211_iftype type, u64 mask)
 			return HW_BSSID_0;
 
 		break;
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_AP:
 		/* ap uses hw bssid 0 and ext bssid */
-- 
2.33.0



