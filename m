Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8701738A49A
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbhETKGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:06:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235408AbhETKE7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:04:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9172160FDB;
        Thu, 20 May 2021 09:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503650;
        bh=v7WNeIKAggA4A//ov3l2VfYNkIpomM+0S0k8zUSHcaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tq0UB60jMjixqOzAdLe8sO5R/REqmZEVo8Nqouv4KOlF52dYyjXaiPwcsoWCr4G1n
         /z44sIEdnlE1AqEdTlQgJgzxTJi+mEkSvm6z/atRabelxV3IY3MRyg4Q8cyq8/N3xp
         2YsQPQxFKfHZ63eONlcf3OPHbGEgJsUxYkZ/7GeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 317/425] mac80211: clear the beacons CRC after channel switch
Date:   Thu, 20 May 2021 11:21:26 +0200
Message-Id: <20210520092141.850912526@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit d6843d1ee283137723b4a8c76244607ce6db1951 ]

After channel switch, we should consider any beacon with a
CSA IE as a new switch. If the CSA IE is a leftover from
before the switch that the AP forgot to remove, we'll get
a CSA-to-Self.

This caused issues in iwlwifi where the firmware saw a beacon
with a CSA-to-Self with mode = 1 on the new channel after a
switch. The firmware considered this a new switch and closed
its queues. Since the beacon didn't change between before and
after the switch, we wouldn't handle it (the CRC is the same)
and we wouldn't let the firmware open its queues again or
disconnect if the CSA IE stays for too long.

Clear the CRC valid state after we switch to make sure that
we handle the beacon and handle the CSA IE as required.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://lore.kernel.org/r/20210408143124.b9e68aa98304.I465afb55ca2c7d59f7bf610c6046a1fd732b4c28@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c53a332f7d65..cbcb60face2c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1185,6 +1185,11 @@ static void ieee80211_chswitch_post_beacon(struct ieee80211_sub_if_data *sdata)
 
 	sdata->vif.csa_active = false;
 	ifmgd->csa_waiting_bcn = false;
+	/*
+	 * If the CSA IE is still present on the beacon after the switch,
+	 * we need to consider it as a new CSA (possibly to self).
+	 */
+	ifmgd->beacon_crc_valid = false;
 
 	ret = drv_post_channel_switch(sdata);
 	if (ret) {
-- 
2.30.2



