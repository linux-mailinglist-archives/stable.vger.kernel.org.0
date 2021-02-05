Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DF3311468
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhBEWFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:05:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232942AbhBEO5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:57:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B8A4650B3;
        Fri,  5 Feb 2021 14:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534470;
        bh=9fMKtInmWq7RhAaImznFoCR4n1sZdP2RPNNb1gM0Cqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQM4rJcM6XHQNo3TbGUU7QJEfbEvI6K6xgZdC/ZnqlIKDRRucGyHn0a3O0ket05ty
         flraC98vZsHQ4rAJ8/RSyjAp27BuhGiH6TWpkbp2B1rbHiNamsLfET+X/jk1Y1ucon
         cJz4ol2Ul/LD+d3gEfPoUPPPe6hviidE9fYbDIXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/15] mac80211: fix fast-rx encryption check
Date:   Fri,  5 Feb 2021 15:08:57 +0100
Message-Id: <20210205140650.229598170@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140649.733510103@linuxfoundation.org>
References: <20210205140649.733510103@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 622d3b4e39381262da7b18ca1ed1311df227de86 ]

When using WEP, the default unicast key needs to be selected, instead of
the STA PTK.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20201218184718.93650-5-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 04ae9de55d74b..48c6aa337c925 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3823,6 +3823,8 @@ void ieee80211_check_fast_rx(struct sta_info *sta)
 
 	rcu_read_lock();
 	key = rcu_dereference(sta->ptk[sta->ptk_idx]);
+	if (!key)
+		key = rcu_dereference(sdata->default_unicast_key);
 	if (key) {
 		switch (key->conf.cipher) {
 		case WLAN_CIPHER_SUITE_TKIP:
-- 
2.27.0



