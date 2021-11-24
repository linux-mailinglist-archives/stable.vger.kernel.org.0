Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6507845BCFF
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343734AbhKXMeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:34:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:49470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245131AbhKXMcn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:32:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 442CA6135F;
        Wed, 24 Nov 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756410;
        bh=TnXwMQ/T/jEwFXNGHUxEOqGvj/xXrUg5Fc35nDDRcp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCLotGe64ROQjVUXwTq3Jn5hisXrFl8gP6nGlZexUQSdKlUnb5AOsc09gOUt2vYRJ
         MLodTUKE27cMeCHrvdCuK6Fy6JM4HQgQkcMCJE80/AI08j1YlMEhFXv/FxIXinSNBq
         plL0bQKGKszLJQK6qjoXRhW9ls+iDtoGu137HzB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 077/251] mwifiex: Properly initialize private structure on interface type changes
Date:   Wed, 24 Nov 2021 12:55:19 +0100
Message-Id: <20211124115712.934914035@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Dreßler <verdre@v0yd.nl>

[ Upstream commit c606008b70627a2fc485732a53cc22f0f66d0981 ]

When creating a new virtual interface in mwifiex_add_virtual_intf(), we
update our internal driver states like bss_type, bss_priority, bss_role
and bss_mode to reflect the mode the firmware will be set to.

When switching virtual interface mode using
mwifiex_init_new_priv_params() though, we currently only update bss_mode
and bss_role. In order for the interface mode switch to actually work,
we also need to update bss_type to its proper value, so do that.

This fixes a crash of the firmware (because the driver tries to execute
commands that are invalid in AP mode) when switching from station mode
to AP mode.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210914195909.36035-9-verdre@v0yd.nl
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 7bdcbe79d963d..a88bddc383894 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -898,16 +898,20 @@ mwifiex_init_new_priv_params(struct mwifiex_private *priv,
 	switch (type) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
-		priv->bss_role =  MWIFIEX_BSS_ROLE_STA;
+		priv->bss_role = MWIFIEX_BSS_ROLE_STA;
+		priv->bss_type = MWIFIEX_BSS_TYPE_STA;
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
-		priv->bss_role =  MWIFIEX_BSS_ROLE_STA;
+		priv->bss_role = MWIFIEX_BSS_ROLE_STA;
+		priv->bss_type = MWIFIEX_BSS_TYPE_P2P;
 		break;
 	case NL80211_IFTYPE_P2P_GO:
-		priv->bss_role =  MWIFIEX_BSS_ROLE_UAP;
+		priv->bss_role = MWIFIEX_BSS_ROLE_UAP;
+		priv->bss_type = MWIFIEX_BSS_TYPE_P2P;
 		break;
 	case NL80211_IFTYPE_AP:
 		priv->bss_role = MWIFIEX_BSS_ROLE_UAP;
+		priv->bss_type = MWIFIEX_BSS_TYPE_UAP;
 		break;
 	default:
 		mwifiex_dbg(adapter, ERROR,
-- 
2.33.0



