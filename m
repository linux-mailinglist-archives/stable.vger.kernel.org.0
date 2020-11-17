Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4692B6214
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731133AbgKQNZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:25:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730499AbgKQNZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:25:15 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 457EA2467A;
        Tue, 17 Nov 2020 13:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619514;
        bh=x8TLj+fP73fNdus5vmAR0RJd6M3QnbPkJCnShKC68G8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExzHFB1VkuSeYRe3S2MuDsPNso4anayVbQ5nQ+T1dCMsBSwA+VZsW20KrhndA+GGW
         WvSbBfIpyHDPNmRyJanORMOh2dZ2l3qa+2uh9wyt+hvkmSV7tTlAHICRj8UuoZ2FUp
         PaF+FJyflKk11M/X9WI56BtPQl0fRyIEyrZ79Tlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+2e293dbd67de2836ba42@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/151] mac80211: always wind down STA state
Date:   Tue, 17 Nov 2020 14:04:54 +0100
Message-Id: <20201117122124.534890029@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit dcd479e10a0510522a5d88b29b8f79ea3467d501 ]

When (for example) an IBSS station is pre-moved to AUTHORIZED
before it's inserted, and then the insertion fails, we don't
clean up the fast RX/TX states that might already have been
created, since we don't go through all the state transitions
again on the way down.

Do that, if it hasn't been done already, when the station is
freed. I considered only freeing the fast TX/RX state there,
but we might add more state so it's more robust to wind down
the state properly.

Note that we warn if the station was ever inserted, it should
have been properly cleaned up in that case, and the driver
will probably not like things happening out of order.

Reported-by: syzbot+2e293dbd67de2836ba42@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20201009141710.7223b322a955.I95bd08b9ad0e039c034927cce0b75beea38e059b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 4f14d8a06915a..38bb6d512b36d 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -244,6 +244,24 @@ struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
  */
 void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 {
+	/*
+	 * If we had used sta_info_pre_move_state() then we might not
+	 * have gone through the state transitions down again, so do
+	 * it here now (and warn if it's inserted).
+	 *
+	 * This will clear state such as fast TX/RX that may have been
+	 * allocated during state transitions.
+	 */
+	while (sta->sta_state > IEEE80211_STA_NONE) {
+		int ret;
+
+		WARN_ON_ONCE(test_sta_flag(sta, WLAN_STA_INSERTED));
+
+		ret = sta_info_move_state(sta, sta->sta_state - 1);
+		if (WARN_ONCE(ret, "sta_info_move_state() returned %d\n", ret))
+			break;
+	}
+
 	if (sta->rate_ctrl)
 		rate_control_free_sta(sta);
 
-- 
2.27.0



