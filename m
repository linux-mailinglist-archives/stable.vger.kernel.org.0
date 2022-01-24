Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9626449934C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239555AbiAXUcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:32:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60586 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347362AbiAXUXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:23:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03F36B8122C;
        Mon, 24 Jan 2022 20:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7F9C340E5;
        Mon, 24 Jan 2022 20:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055786;
        bh=JyF5JCPlW0N+n4V0C2zTc0MJpMg5u5AoJfeBsSyMvIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGwqSUBHzI2fgV53YfnhleO/t/99mlJFwjET27eSjqNwHNzcsLZqOZqmIGvDqK7aP
         oDqo5pXeOUDCqdKt8eZZXwjG/wGwNKiAmDAY1j2Vaa62p7DOrP4d4oQrO3LPpFLITf
         ehh6V24C6G3dLY3bhmuMIiVl4kFNO5dTcXExcxGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 266/846] mt76: mt7921: drop offload_flags overwritten
Date:   Mon, 24 Jan 2022 19:36:23 +0100
Message-Id: <20220124184110.100494488@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 63ec140c9c372..9eb90e6f01031 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -285,12 +285,6 @@ static int mt7921_add_interface(struct ieee80211_hw *hw,
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



