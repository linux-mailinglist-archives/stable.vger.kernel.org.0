Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D193CDD8E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245099AbhGSO6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245194AbhGSO5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:57:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 123CD613E9;
        Mon, 19 Jul 2021 15:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708921;
        bh=BrpNknLtV2X2AoTjMLqOVDmsgnK4iG7hZQJOUZh6HQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aPkk4oT6XykN48a3eIy75+jK0NhWqgjGdlsb6qvpPp5/QbPtmGNMM9kptnI59njQd
         NXiT1W73f9JJCs51QwcH6KtweR0fCkvRL5mGJ5b8PdaaIJMnL86bQ8Rd9saHwVaXQ0
         GSYy7KK6RTZ/SmJ7S3e+V7vZtFZ/5U0pTkt2L/+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 150/421] mac80211: remove iwlwifi specific workaround NDPs of null_response
Date:   Mon, 19 Jul 2021 16:49:21 +0200
Message-Id: <20210719144951.673084859@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index 71c6a462277f..3a907ba7f763 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1344,11 +1344,6 @@ static void ieee80211_send_null_response(struct sta_info *sta, int tid,
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



