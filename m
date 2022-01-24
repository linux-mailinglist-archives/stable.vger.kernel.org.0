Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3140499788
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448652AbiAXVNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60548 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446447AbiAXVIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:08:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FAC96146E;
        Mon, 24 Jan 2022 21:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077ACC340E5;
        Mon, 24 Jan 2022 21:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058494;
        bh=pINW5Y06eLywlZuwRwe+6QERGMYHIR/VYj2CTS7IREY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yiDAEWbsjE+ErvOU9i4wPaZwNnGTPUwwRUlUO7VjjHx2fQ21Ypeeh5RhFq71ukiuA
         RpOVcCFQGIvUvt/bEjt26yoVm6uvgVYHAG7uygOtU0rSldfq6wdiy5Ntjdo+1wzuZn
         JR9Tajn+p161aylzu+W9LO1PA/4LNmBIcZXxiR1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0308/1039] mt76: mt7921: drop offload_flags overwritten
Date:   Mon, 24 Jan 2022 19:34:57 +0100
Message-Id: <20220124184135.664168765@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 2363b6a646b65a207345b9a9024dff0eff3fec44 ]

offload_flags have to be dropped for mt7921 because mt76.omac_idx 0 would
always run as station mode that would cause Tx encapsulation setting
is not applied to mac80211.

Also, drop IEEE80211_OFFLOAD_ENCAP_4ADDR too because it is not really
being supported.

Fixes: e0f9fdda81bd ("mt76: mt7921: add ieee80211_ops")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 633c6d2a57acd..b144f5491798a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -318,12 +318,6 @@ static int mt7921_add_interface(struct ieee80211_hw *hw,
 		mtxq->wcid = &mvif->sta.wcid;
 	}
 
-	if (vif->type != NL80211_IFTYPE_AP &&
-	    (!mvif->mt76.omac_idx || mvif->mt76.omac_idx > 3))
-		vif->offload_flags = 0;
-
-	vif->offload_flags |= IEEE80211_OFFLOAD_ENCAP_4ADDR;
-
 out:
 	mt7921_mutex_release(dev);
 
-- 
2.34.1



