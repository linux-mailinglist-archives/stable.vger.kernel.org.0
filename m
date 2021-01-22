Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F593005F3
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbhAVOsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:48:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728668AbhAVOY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:24:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09F0823BCA;
        Fri, 22 Jan 2021 14:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325166;
        bh=EA0j0tW0F8pwoknKDbu7v/q3Tc+3xEWVkM4PWVpdb6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3iPxEvW7kQdgZsb2WYBC+cDe1Gf8NYlFNKxCHADJfJSaVvUxXiFvy0YYTio/1kU8
         KgrHJZmI644qEmzDf2urEZHyjuyF1srBTCt3HL/SDz3LnWBxqR10B5s28nS5GQr+BZ
         rY0VMDciWqNvE6Z1gg/ZpUyu5qWQeVnrTMEeS/Q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 39/43] mac80211: check if atf has been disabled in __ieee80211_schedule_txq
Date:   Fri, 22 Jan 2021 15:12:55 +0100
Message-Id: <20210122135737.245163119@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit c13cf5c159660451c8fbdc37efb998b198e1d305 upstream.

Check if atf has been disabled in __ieee80211_schedule_txq() in order to
avoid a given sta is always put to the beginning of the active_txqs list
and never moved to the end since deficit is not decremented in
ieee80211_sta_register_airtime()

Fixes: b4809e9484da1 ("mac80211: Add airtime accounting and scheduling to TXQs")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://lore.kernel.org/r/93889406c50f1416214c079ca0b8c9faecc5143e.1608975195.git.lorenzo@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3836,7 +3836,7 @@ void __ieee80211_schedule_txq(struct iee
 		 * get immediately moved to the back of the list on the next
 		 * call to ieee80211_next_txq().
 		 */
-		if (txqi->txq.sta &&
+		if (txqi->txq.sta && local->airtime_flags &&
 		    wiphy_ext_feature_isset(local->hw.wiphy,
 					    NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
 			list_add(&txqi->schedule_order,


