Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1380A30C7DE
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237629AbhBBRda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:33:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234062AbhBBOMh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:12:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A576665048;
        Tue,  2 Feb 2021 13:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273968;
        bh=u5+SVb4jKMMRYppbYEVPTy26a85mU/Njb4W2GRVbxYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z48vKsfo7kuABmXg+3fH2hZTHxmGr62mb8C5srDDU8Wedmgg6LYWXGBX1S+dcqad2
         mfq+2tHhhw19qSgHW8DZ5uWAdtKiEkYu6p07yv6CPySX9evj5ZcvrkkYRxMbaf8GAQ
         mvuX+bFrdIy2wSWuubC46RhWcuSKwExLaDnXMycs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d7a3b15976bf7de2238a@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 21/30] mac80211: pause TX while changing interface type
Date:   Tue,  2 Feb 2021 14:39:02 +0100
Message-Id: <20210202132943.012153860@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.138623851@linuxfoundation.org>
References: <20210202132942.138623851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 054c9939b4800a91475d8d89905827bf9e1ad97a ]

syzbot reported a crash that happened when changing the interface
type around a lot, and while it might have been easy to fix just
the symptom there, a little deeper investigation found that really
the reason is that we allowed packets to be transmitted while in
the middle of changing the interface type.

Disallow TX by stopping the queues while changing the type.

Fixes: 34d4bc4d41d2 ("mac80211: support runtime interface type changes")
Reported-by: syzbot+d7a3b15976bf7de2238a@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20210122171115.b321f98f4d4f.I6997841933c17b093535c31d29355be3c0c39628@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h | 1 +
 net/mac80211/iface.c       | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0e209a88d88a7..651705565dfb9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1047,6 +1047,7 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_FLUSH,
 	IEEE80211_QUEUE_STOP_REASON_TDLS_TEARDOWN,
 	IEEE80211_QUEUE_STOP_REASON_RESERVE_TID,
+	IEEE80211_QUEUE_STOP_REASON_IFTYPE_CHANGE,
 
 	IEEE80211_QUEUE_STOP_REASONS,
 };
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 6ce13e976b7a2..dc398a1816788 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1559,6 +1559,10 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 	if (ret)
 		return ret;
 
+	ieee80211_stop_vif_queues(local, sdata,
+				  IEEE80211_QUEUE_STOP_REASON_IFTYPE_CHANGE);
+	synchronize_net();
+
 	ieee80211_do_stop(sdata, false);
 
 	ieee80211_teardown_sdata(sdata);
@@ -1579,6 +1583,8 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 	err = ieee80211_do_open(&sdata->wdev, false);
 	WARN(err, "type change: do_open returned %d", err);
 
+	ieee80211_wake_vif_queues(local, sdata,
+				  IEEE80211_QUEUE_STOP_REASON_IFTYPE_CHANGE);
 	return ret;
 }
 
-- 
2.27.0



