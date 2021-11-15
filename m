Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15776451358
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348160AbhKOTug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:50:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:44648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245682AbhKOTVA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1BE46358A;
        Mon, 15 Nov 2021 18:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001561;
        bh=oE25VBAXKjug5zZ/ntNxpF9N4QRExlf1uT4rWOqGdyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q5nqzDb6PgbD3hv47q9GQ9mEnoyEGgtqvEIiQkFSa/mAkeZegaLg6+PRPIRJpxtPG
         kqVt2aVcu97sKS+UaLGhmOyUEF/NDejFPfu6RWMv7pNDgCG5DmEFX2azKquM+TexFx
         0lsAhxzKCPUHdV73erhQbtzgZIL8ETU1mjKQaobw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 204/917] mwifiex: Run SET_BSS_MODE when changing from P2P to STATION vif-type
Date:   Mon, 15 Nov 2021 17:54:59 +0100
Message-Id: <20211115165435.706704570@linuxfoundation.org>
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

From: Jonas Dreßler <verdre@v0yd.nl>

[ Upstream commit c2e9666cdffd347460a2b17988db4cfaf2a68fb9 ]

We currently handle changing from the P2P to the STATION virtual
interface type slightly different than changing from P2P to ADHOC: When
changing to STATION, we don't send the SET_BSS_MODE command. We do send
that command on all other type-changes though, and it probably makes
sense to send the command since after all we just changed our BSS_MODE.
Looking at prior changes to this part of the code, it seems that this is
simply a leftover from old refactorings.

Since sending the SET_BSS_MODE command is the only difference between
mwifiex_change_vif_to_sta_adhoc() and the current code, we can now use
mwifiex_change_vif_to_sta_adhoc() for both switching to ADHOC and
STATION interface type.

This does not fix any particular bug and just "looked right", so there's
a small chance it might be a regression.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210914195909.36035-4-verdre@v0yd.nl
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/marvell/mwifiex/cfg80211.c   | 22 ++++---------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 0961f4a5e415c..93eb5f109949f 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1229,29 +1229,15 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
+		if (mwifiex_cfg80211_deinit_p2p(priv))
+			return -EFAULT;
+
 		switch (type) {
-		case NL80211_IFTYPE_STATION:
-			if (mwifiex_cfg80211_deinit_p2p(priv))
-				return -EFAULT;
-			priv->adapter->curr_iface_comb.p2p_intf--;
-			priv->adapter->curr_iface_comb.sta_intf++;
-			dev->ieee80211_ptr->iftype = type;
-			if (mwifiex_deinit_priv_params(priv))
-				return -1;
-			if (mwifiex_init_new_priv_params(priv, dev, type))
-				return -1;
-			if (mwifiex_sta_init_cmd(priv, false, false))
-				return -1;
-			break;
 		case NL80211_IFTYPE_ADHOC:
-			if (mwifiex_cfg80211_deinit_p2p(priv))
-				return -EFAULT;
+		case NL80211_IFTYPE_STATION:
 			return mwifiex_change_vif_to_sta_adhoc(dev, curr_iftype,
 							       type, params);
-			break;
 		case NL80211_IFTYPE_AP:
-			if (mwifiex_cfg80211_deinit_p2p(priv))
-				return -EFAULT;
 			return mwifiex_change_vif_to_ap(dev, curr_iftype, type,
 							params);
 		case NL80211_IFTYPE_UNSPECIFIED:
-- 
2.33.0



