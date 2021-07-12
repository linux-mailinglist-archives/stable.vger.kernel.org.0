Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BE03C4EF9
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238590AbhGLHWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244375AbhGLHSQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:18:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A73836147E;
        Mon, 12 Jul 2021 07:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074128;
        bh=JrU/w6ibrI5CvIB8ew/Z264rC8h12/zrkK4QVi/N/5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UX2NLC8/1SWc4EH5yOj+/AajRkyvyhzRMaHZn6LzjRXkz0OcnseuZ4jNHzuWddLep
         nUmayXBQXl+afAbc6G3B3n5QfNg6bGRGTAM0wcWsV/NigdvQOMX1406Em/C9TId3RK
         ql8WwXQKP2fu+GyfdMADjlFHgT22paZZHhVDh+jY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 473/700] mac80211: remove iwlwifi specific workaround NDPs of null_response
Date:   Mon, 12 Jul 2021 08:09:16 +0200
Message-Id: <20210712061026.901460834@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 744757e46bf13ec3a7b3507d17ab3faab9516d43 ]

Remove the remaining workaround that is not removed by the
commit e41eb3e408de ("mac80211: remove iwlwifi specific workaround
that broke sta NDP tx")

Fixes: 41cbb0f5a295 ("mac80211: add support for HE")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://lore.kernel.org/r/20210623134826.10318-1-pkshih@realtek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f2fb69da9b6e..13250cadb420 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1398,11 +1398,6 @@ static void ieee80211_send_null_response(struct sta_info *sta, int tid,
 	struct ieee80211_tx_info *info;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 
-	/* Don't send NDPs when STA is connected HE */
-	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-	    !(sdata->u.mgd.flags & IEEE80211_STA_DISABLE_HE))
-		return;
-
 	if (qos) {
 		fc = cpu_to_le16(IEEE80211_FTYPE_DATA |
 				 IEEE80211_STYPE_QOS_NULLFUNC |
-- 
2.30.2



