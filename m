Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D2344186C
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbhKAJrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:47:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232432AbhKAJpV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:45:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 456FB61221;
        Mon,  1 Nov 2021 09:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759012;
        bh=iLqvUfGOzcTvBkKwoy4yHgnn1Qocynembbf3asBRqT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKWktr7XCHTqZlghUOq7st5e29o+g9wDvsWgDh+vUAkNekLtYlPAaNqFMoRi0AtRQ
         CTH+ELL+xgzCPFOFOQ0TU8bEuZIbbGN1tAZ17jNQmRHhw+EoadGSU8Rs9MC5mL8Tk1
         BRf1KvRfam5Gfl8MtklgaYBWqzT7nH+uHfLXaA28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Janusz Dziedzic <janusz.dziedzic@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.14 078/125] cfg80211: correct bridge/4addr mode check
Date:   Mon,  1 Nov 2021 10:17:31 +0100
Message-Id: <20211101082548.022728364@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janusz Dziedzic <janusz.dziedzic@gmail.com>

commit 689a0a9f505f7bffdefe6f17fddb41c8ab6344f6 upstream.

Without the patch we fail:

$ sudo brctl addbr br0
$ sudo brctl addif br0 wlp1s0
$ sudo iw wlp1s0 set 4addr on
command failed: Device or resource busy (-16)

Last command failed but iface was already in 4addr mode.

Fixes: ad4bb6f8883a ("cfg80211: disallow bridging managed/adhoc interfaces")
Signed-off-by: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Link: https://lore.kernel.org/r/20211024201546.614379-1-janusz.dziedzic@gmail.com
[add fixes tag, fix indentation, edit commit log]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/util.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1028,14 +1028,14 @@ int cfg80211_change_iface(struct cfg8021
 	    !(rdev->wiphy.interface_modes & (1 << ntype)))
 		return -EOPNOTSUPP;
 
-	/* if it's part of a bridge, reject changing type to station/ibss */
-	if (netif_is_bridge_port(dev) &&
-	    (ntype == NL80211_IFTYPE_ADHOC ||
-	     ntype == NL80211_IFTYPE_STATION ||
-	     ntype == NL80211_IFTYPE_P2P_CLIENT))
-		return -EBUSY;
-
 	if (ntype != otype) {
+		/* if it's part of a bridge, reject changing type to station/ibss */
+		if (netif_is_bridge_port(dev) &&
+		    (ntype == NL80211_IFTYPE_ADHOC ||
+		     ntype == NL80211_IFTYPE_STATION ||
+		     ntype == NL80211_IFTYPE_P2P_CLIENT))
+			return -EBUSY;
+
 		dev->ieee80211_ptr->use_4addr = false;
 		dev->ieee80211_ptr->mesh_id_up_len = 0;
 		wdev_lock(dev->ieee80211_ptr);


