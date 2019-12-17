Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90FCF12210B
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 02:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfLQBAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 20:00:02 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34672 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726671AbfLQAve (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:34 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15G-0003K8-JS; Tue, 17 Dec 2019 00:51:30 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15G-0005T8-0W; Tue, 17 Dec 2019 00:51:30 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Nicolas Waisman" <nico@semmle.com>,
        "Will Deacon" <will@kernel.org>,
        "Johannes Berg" <johannes.berg@intel.com>,
        "Kees Cook" <keescook@chromium.org>
Date:   Tue, 17 Dec 2019 00:45:57 +0000
Message-ID: <lsq.1576543535.569796514@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 023/136] mac80211: Reject malformed SSID elements
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

commit 4152561f5da3fca92af7179dd538ea89e248f9d0 upstream.

Although this shouldn't occur in practice, it's a good idea to bounds
check the length field of the SSID element prior to using it for things
like allocations or memcpy operations.

Cc: Kees Cook <keescook@chromium.org>
Reported-by: Nicolas Waisman <nico@semmle.com>
Signed-off-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20191004095132.15777-1-will@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/mlme.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2046,7 +2046,8 @@ struct sk_buff *ieee80211_ap_probereq_ge
 
 	rcu_read_lock();
 	ssid = ieee80211_bss_get_ie(cbss, WLAN_EID_SSID);
-	if (WARN_ON_ONCE(ssid == NULL))
+	if (WARN_ONCE(!ssid || ssid[1] > IEEE80211_MAX_SSID_LEN,
+		      "invalid SSID element (len=%d)", ssid ? ssid[1] : -1))
 		ssid_len = 0;
 	else
 		ssid_len = ssid[1];
@@ -4195,7 +4196,7 @@ int ieee80211_mgd_assoc(struct ieee80211
 
 	rcu_read_lock();
 	ssidie = ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
-	if (!ssidie) {
+	if (!ssidie || ssidie[1] > sizeof(assoc_data->ssid)) {
 		rcu_read_unlock();
 		kfree(assoc_data);
 		return -EINVAL;

