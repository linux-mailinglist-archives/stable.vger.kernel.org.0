Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFCF731128F
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 21:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbhBESwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 13:52:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233061AbhBEPEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:04:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E30F6508B;
        Fri,  5 Feb 2021 14:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534419;
        bh=MgQy4UZLclAsrRxdLQ/K1ZQLxh95k7KWRWTT6j3/uvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d9nH1ksh5HU/8g7KLrsbgF7tQBIztAp4HnnbQXmTt2kKHe8c3lNsgNFeqVnJNEWEk
         AhUSZb/udq4r5UaMY61HvTsUjVmMAp+jX0eUR0N0pj9VDTopaiMXf7dNgALNry4hMY
         U8HkF1WzElHhUXFCTg2/rE0C4UnEptC5axtgha8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/17] mac80211: fix fast-rx encryption check
Date:   Fri,  5 Feb 2021 15:08:06 +0100
Message-Id: <20210205140650.304145821@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140649.825180779@linuxfoundation.org>
References: <20210205140649.825180779@linuxfoundation.org>
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
index 5e56719f999c4..9e92e5e2336be 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4003,6 +4003,8 @@ void ieee80211_check_fast_rx(struct sta_info *sta)
 
 	rcu_read_lock();
 	key = rcu_dereference(sta->ptk[sta->ptk_idx]);
+	if (!key)
+		key = rcu_dereference(sdata->default_unicast_key);
 	if (key) {
 		switch (key->conf.cipher) {
 		case WLAN_CIPHER_SUITE_TKIP:
-- 
2.27.0



