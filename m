Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBADD38325F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240965AbhEQOrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:47:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241519AbhEQOpI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:45:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E0A761958;
        Mon, 17 May 2021 14:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261253;
        bh=Eg/G/UjjFFu407dQzUK3rl62N3J47c9o9i1w6JqNAWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q77TLo2e0gQ6o7p+eTenyPXc+m0xYmVXpEgLEQkQqSuPaXTJaD4y+Ot2SOegVHSKv
         WTNEjvCnSPTMCWlxin98KDmPRu/+WVeZGT1cqEGFfS8ftBAoj2mL2bGi2AsBnTePrc
         Z08YdIrcAZMCSUBr8manlxpNpmiHUs9wiJIXJszA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Bauer <mail@david-bauer.net>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/141] mt76: mt76x0: disable GTK offloading
Date:   Mon, 17 May 2021 16:01:17 +0200
Message-Id: <20210517140243.610370265@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Bauer <mail@david-bauer.net>

[ Upstream commit 4b36cc6b390f18dbc59a45fb4141f90d7dfe2b23 ]

When operating two VAP on a MT7610 with encryption (PSK2, SAE, OWE),
only the first one to be created will transmit properly encrypteded
frames.

All subsequently created VAPs will sent out frames with the payload left
unencrypted, breaking multicast traffic (ICMP6 NDP) and potentially
disclosing information to a third party.

Disable GTK offloading and encrypt these frames in software to
circumvent this issue. THis only seems to be necessary on MT7610 chips,
as MT7612 is not affected from our testing.

Signed-off-by: David Bauer <mail@david-bauer.net>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index de0d6f21c621..075871f52bad 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -450,6 +450,10 @@ int mt76x02_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
 		return -EOPNOTSUPP;
 
+	/* MT76x0 GTK offloading does not work with more than one VIF */
+	if (is_mt76x0(dev) && !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		return -EOPNOTSUPP;
+
 	msta = sta ? (struct mt76x02_sta *)sta->drv_priv : NULL;
 	wcid = msta ? &msta->wcid : &mvif->group_wcid;
 
-- 
2.30.2



