Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB8C3643D5
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241231AbhDSNVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241427AbhDSNUd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEA16613EB;
        Mon, 19 Apr 2021 13:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838201;
        bh=AkIks0oqHhkdF+z6ehOanHRJwZy6mXz2P5PImIEaNsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dSmxVYzrDR8OXW5wIEnsmm8W605kEw8xAogubk8NCPYpm/cZtOy3FfiKjEVxpjB7K
         rOErErw9FhWworah10JlYc8/NKSwMLI8O7ZNN6a5Ag9yZOK2YbGskimMEeamAgIuKO
         SZ0hYJ4W7xZkeMpY6d2fcAJxBLp3xREsLl7hZtCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "A. Cody Schuffelen" <schuffelen@google.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/103] virt_wifi: Return micros for BSS TSF values
Date:   Mon, 19 Apr 2021 15:05:56 +0200
Message-Id: <20210419130529.364677158@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: A. Cody Schuffelen <schuffelen@google.com>

[ Upstream commit b57aa17f07c9270e576ef7df09f142978b5a75f0 ]

cfg80211_inform_bss expects to receive a TSF value, but is given the
time since boot in nanoseconds. TSF values are expected to be at
microsecond scale rather than nanosecond scale.

Signed-off-by: A. Cody Schuffelen <schuffelen@google.com>
Link: https://lore.kernel.org/r/20210318200419.1421034-1-schuffelen@google.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virt_wifi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/virt_wifi.c b/drivers/net/wireless/virt_wifi.c
index c878097f0dda..1df959532c7d 100644
--- a/drivers/net/wireless/virt_wifi.c
+++ b/drivers/net/wireless/virt_wifi.c
@@ -12,6 +12,7 @@
 #include <net/cfg80211.h>
 #include <net/rtnetlink.h>
 #include <linux/etherdevice.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 
 static struct wiphy *common_wiphy;
@@ -168,11 +169,11 @@ static void virt_wifi_scan_result(struct work_struct *work)
 			     scan_result.work);
 	struct wiphy *wiphy = priv_to_wiphy(priv);
 	struct cfg80211_scan_info scan_info = { .aborted = false };
+	u64 tsf = div_u64(ktime_get_boottime_ns(), 1000);
 
 	informed_bss = cfg80211_inform_bss(wiphy, &channel_5ghz,
 					   CFG80211_BSS_FTYPE_PRESP,
-					   fake_router_bssid,
-					   ktime_get_boottime_ns(),
+					   fake_router_bssid, tsf,
 					   WLAN_CAPABILITY_ESS, 0,
 					   (void *)&ssid, sizeof(ssid),
 					   DBM_TO_MBM(-50), GFP_KERNEL);
-- 
2.30.2



