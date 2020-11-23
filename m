Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4132C0AA6
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729715AbgKWMX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:23:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:33168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729699AbgKWMXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:23:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47D272076E;
        Mon, 23 Nov 2020 12:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134233;
        bh=qLSQZAzAmX4JJFtzr40HK8HX08R35CSymqzMrEN5Ccs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIv7KYmWu6H5QSdgc6yyAA7HrZEcxC84yAowWo2tyjhBgBQstqEQ0jOP0Dtc32lrv
         gC9/RlwPiWhGMC6Zq+SpK06xhyLvtHEKrsDHxlXQcdAg9VJjUJqgaveS2u5cZQQrJ2
         iXYVZMW+7Gul6h5s+Guo5nZX/zTmtXkxDXlz6QD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.4 35/38] mac80211: allow driver to prevent two stations w/ same address
Date:   Mon, 23 Nov 2020 13:22:21 +0100
Message-Id: <20201123121805.972492982@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121804.306030358@linuxfoundation.org>
References: <20201123121804.306030358@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 3110489117581a980537b6d999a3724214ba772c upstream.

Some devices or drivers cannot deal with having the same station
address for different virtual interfaces, say as a client to two
virtual AP interfaces. Rather than requiring each driver with a
limitation like that to enforce it, add a hardware flag for it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/mac80211.h  |    6 ++++++
 net/mac80211/debugfs.c  |    1 +
 net/mac80211/sta_info.c |   18 ++++++++++++++++--
 3 files changed, 23 insertions(+), 2 deletions(-)

--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1915,6 +1915,11 @@ struct ieee80211_txq {
  * @IEEE80211_HW_BEACON_TX_STATUS: The device/driver provides TX status
  *	for sent beacons.
  *
+ * @IEEE80211_HW_NEEDS_UNIQUE_STA_ADDR: Hardware (or driver) requires that each
+ *	station has a unique address, i.e. each station entry can be identified
+ *	by just its MAC address; this prevents, for example, the same station
+ *	from connecting to two virtual AP interfaces at the same time.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -1950,6 +1955,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TDLS_WIDER_BW,
 	IEEE80211_HW_SUPPORTS_AMSDU_IN_AMPDU,
 	IEEE80211_HW_BEACON_TX_STATUS,
+	IEEE80211_HW_NEEDS_UNIQUE_STA_ADDR,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -125,6 +125,7 @@ static const char *hw_flag_names[] = {
 	FLAG(TDLS_WIDER_BW),
 	FLAG(SUPPORTS_AMSDU_IN_AMPDU),
 	FLAG(BEACON_TX_STATUS),
+	FLAG(NEEDS_UNIQUE_STA_ADDR),
 #undef FLAG
 };
 
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -457,6 +457,19 @@ static int sta_info_insert_check(struct
 		    is_multicast_ether_addr(sta->sta.addr)))
 		return -EINVAL;
 
+	/* Strictly speaking this isn't necessary as we hold the mutex, but
+	 * the rhashtable code can't really deal with that distinction. We
+	 * do require the mutex for correctness though.
+	 */
+	rcu_read_lock();
+	lockdep_assert_held(&sdata->local->sta_mtx);
+	if (ieee80211_hw_check(&sdata->local->hw, NEEDS_UNIQUE_STA_ADDR) &&
+	    ieee80211_find_sta_by_ifaddr(&sdata->local->hw, sta->addr, NULL)) {
+		rcu_read_unlock();
+		return -ENOTUNIQ;
+	}
+	rcu_read_unlock();
+
 	return 0;
 }
 
@@ -585,14 +598,15 @@ int sta_info_insert_rcu(struct sta_info
 
 	might_sleep();
 
+	mutex_lock(&local->sta_mtx);
+
 	err = sta_info_insert_check(sta);
 	if (err) {
+		mutex_unlock(&local->sta_mtx);
 		rcu_read_lock();
 		goto out_free;
 	}
 
-	mutex_lock(&local->sta_mtx);
-
 	err = sta_info_insert_finish(sta);
 	if (err)
 		goto out_free;


