Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79AAA450B43
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237021AbhKORVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:21:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236279AbhKORRb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:17:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E35061BE5;
        Mon, 15 Nov 2021 17:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996402;
        bh=f3N/kgs6bo6MHjbx6q85/nXKf+mVH4MjV0F5rCvAmiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0DF7a+FzDn/+pCBqEamJG3svgkX0XsO+2vWpK80bcesnQyQj++8GQzsfpMbnt6Iod
         t6d54sS5tvIWN/IZ3eOQ2/+NBTaN6aFJzy1VjsaqwpuL8YdOftBuEhfPNDbe+o8omx
         emEFTe454UurBzrxU5pAgQM9Btjj55CCO2gMj25A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 126/355] mwifiex: Run SET_BSS_MODE when changing from P2P to STATION vif-type
Date:   Mon, 15 Nov 2021 18:00:50 +0100
Message-Id: <20211115165317.888228645@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index 9e6dc289ec3e8..b5134f11fc32b 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1233,29 +1233,15 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
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



