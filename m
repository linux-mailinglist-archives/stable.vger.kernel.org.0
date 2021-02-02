Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D100E30C302
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 16:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhBBPHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 10:07:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:51352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230389AbhBBOQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:16:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CC216505A;
        Tue,  2 Feb 2021 13:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612274037;
        bh=j/DjIv88Ue3WliPJEw3uq8ulHomT7y/AVV/PQCiF24k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GftCEuB1YA9zs9SLAnt+mrrdQzlXfbDtHQRDq+8pwHZDW2NFyHT5ZxNnq0sIwrdnk
         h5/e1jJtnSyUj18uK17n0q/HB1ohB3oZk81VukGxnflE9HKnN/a3OiYKQ988pBb/Qv
         Ae8wQp7Mq0sSGHOi0Ep1VT2jT3Vj4Z9XRMeflBEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d7a3b15976bf7de2238a@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/37] mac80211: pause TX while changing interface type
Date:   Tue,  2 Feb 2021 14:39:11 +0100
Message-Id: <20210202132944.095977935@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.915040339@linuxfoundation.org>
References: <20210202132942.915040339@linuxfoundation.org>
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
index a879d8071712b..fc715bba59146 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1051,6 +1051,7 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_FLUSH,
 	IEEE80211_QUEUE_STOP_REASON_TDLS_TEARDOWN,
 	IEEE80211_QUEUE_STOP_REASON_RESERVE_TID,
+	IEEE80211_QUEUE_STOP_REASON_IFTYPE_CHANGE,
 
 	IEEE80211_QUEUE_STOP_REASONS,
 };
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 152d4365f9616..511ca6f74239d 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1542,6 +1542,10 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 	if (ret)
 		return ret;
 
+	ieee80211_stop_vif_queues(local, sdata,
+				  IEEE80211_QUEUE_STOP_REASON_IFTYPE_CHANGE);
+	synchronize_net();
+
 	ieee80211_do_stop(sdata, false);
 
 	ieee80211_teardown_sdata(sdata);
@@ -1562,6 +1566,8 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 	err = ieee80211_do_open(&sdata->wdev, false);
 	WARN(err, "type change: do_open returned %d", err);
 
+	ieee80211_wake_vif_queues(local, sdata,
+				  IEEE80211_QUEUE_STOP_REASON_IFTYPE_CHANGE);
 	return ret;
 }
 
-- 
2.27.0



