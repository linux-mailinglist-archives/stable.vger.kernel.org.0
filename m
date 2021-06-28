Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654D63B6020
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbhF1OWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233225AbhF1OVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33C2661C77;
        Mon, 28 Jun 2021 14:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889955;
        bh=5kiAwe2sKo+HYspEPVNuKP3QHogOO1UsdneSrcR1T+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ThqijTfpea6zdONd1dmcVsgmu0E5LgnpHm+Ju0KQqSx0/w9+4RAXDqNrSzYfg93lY
         LQzqvveI/hYfFdyeaTYJhmFwFXF7q8LBIU8MQ+8AlVB7kOvoVwrZyh/0Bwu1AsPeY2
         HBwoWjxaPrDK/tmIhcW1cBFJ4UjvZgZmxLCQI+k+at4hHncQmwWCrKR804gOUEAGUQ
         w9C9O/yNP+LlcSB+qN/w8Faak9tgoxVfHtI09XwHE4l+0BhYlfcB5hLSzZmYvvxdOP
         WgsL3lm0s0Yajpptke8LDreHi25x8ceIlH5QL/Qb9GpqJhtYA6hSjLA0n1mPqxll0O
         386x2wnxRoF8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 054/110] mac80211: reset profile_periodicity/ema_ap
Date:   Mon, 28 Jun 2021 10:17:32 -0400
Message-Id: <20210628141828.31757-55-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit bbc6f03ff26e7b71d6135a7b78ce40e7dee3d86a ]

Apparently we never clear these values, so they'll remain set
since the setting of them is conditional. Clear the values in
the relevant other cases.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210618133832.316e32d136a9.I2a12e51814258e1e1b526103894f4b9f19a91c8d@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0fe91dc9817e..437d88822d8f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4062,10 +4062,14 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		if (elems.mbssid_config_ie)
 			bss_conf->profile_periodicity =
 				elems.mbssid_config_ie->profile_periodicity;
+		else
+			bss_conf->profile_periodicity = 0;
 
 		if (elems.ext_capab_len >= 11 &&
 		    (elems.ext_capab[10] & WLAN_EXT_CAPA11_EMA_SUPPORT))
 			bss_conf->ema_ap = true;
+		else
+			bss_conf->ema_ap = false;
 
 		/* continue assoc process */
 		ifmgd->assoc_data->timeout = jiffies;
@@ -5802,12 +5806,16 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 					      beacon_ies->data, beacon_ies->len);
 		if (elem && elem->datalen >= 3)
 			sdata->vif.bss_conf.profile_periodicity = elem->data[2];
+		else
+			sdata->vif.bss_conf.profile_periodicity = 0;
 
 		elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY,
 					  beacon_ies->data, beacon_ies->len);
 		if (elem && elem->datalen >= 11 &&
 		    (elem->data[10] & WLAN_EXT_CAPA11_EMA_SUPPORT))
 			sdata->vif.bss_conf.ema_ap = true;
+		else
+			sdata->vif.bss_conf.ema_ap = false;
 	} else {
 		assoc_data->timeout = jiffies;
 		assoc_data->timeout_started = true;
-- 
2.30.2

