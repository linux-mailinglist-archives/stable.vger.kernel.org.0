Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFAC3AF092
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbhFUQu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:50:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232760AbhFUQsB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:48:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F33F161361;
        Mon, 21 Jun 2021 16:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293243;
        bh=YXCuLwSz2ejN/KjrJmX7mM1K9SRerSB1sOYShyduPC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mxtFyY+j82TfFF3v+JphOsIPUSys4u3NlxfOqu9Zj7MPJZPGqgi/qrPcoS7gBtwnE
         qdLDACWPN3CfP+U22j/Kdrz8kAtatPWkMzL2t3Wo6DlCHJ8sOGXX8YAP9FNDaODIn9
         Bb4yJyNl0B0Tvkc4O4oIQFDqNmzB0AlMoFW8RiUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+452ea4fbbef700ff0a56@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.12 151/178] mac80211: fix deadlock in AP/VLAN handling
Date:   Mon, 21 Jun 2021 18:16:05 +0200
Message-Id: <20210621154927.904510289@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit d5befb224edbe53056c2c18999d630dafb4a08b9 upstream.

Syzbot reports that when you have AP_VLAN interfaces that are up
and close the AP interface they belong to, we get a deadlock. No
surprise - since we dev_close() them with the wiphy mutex held,
which goes back into the netdev notifier in cfg80211 and tries to
acquire the wiphy mutex there.

To fix this, we need to do two things:
 1) prevent changing iftype while AP_VLANs are up, we can't
    easily fix this case since cfg80211 already calls us with
    the wiphy mutex held, but change_interface() is relatively
    rare in drivers anyway, so changing iftype isn't used much
    (and userspace has to fall back to down/change/up anyway)
 2) pull the dev_close() loop over VLANs out of the wiphy mutex
    section in the normal stop case

Cc: stable@vger.kernel.org
Reported-by: syzbot+452ea4fbbef700ff0a56@syzkaller.appspotmail.com
Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
Link: https://lore.kernel.org/r/20210517160322.9b8f356c0222.I392cb0e2fa5a1a94cf2e637555d702c7e512c1ff@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/iface.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -475,14 +475,7 @@ static void ieee80211_do_stop(struct iee
 				   GFP_KERNEL);
 	}
 
-	/* APs need special treatment */
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
-		struct ieee80211_sub_if_data *vlan, *tmpsdata;
-
-		/* down all dependent devices, that is VLANs */
-		list_for_each_entry_safe(vlan, tmpsdata, &sdata->u.ap.vlans,
-					 u.vlan.list)
-			dev_close(vlan->dev);
 		WARN_ON(!list_empty(&sdata->u.ap.vlans));
 	} else if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
 		/* remove all packets in parent bc_buf pointing to this dev */
@@ -640,6 +633,15 @@ static int ieee80211_stop(struct net_dev
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
+	/* close all dependent VLAN interfaces before locking wiphy */
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
+		struct ieee80211_sub_if_data *vlan, *tmpsdata;
+
+		list_for_each_entry_safe(vlan, tmpsdata, &sdata->u.ap.vlans,
+					 u.vlan.list)
+			dev_close(vlan->dev);
+	}
+
 	wiphy_lock(sdata->local->hw.wiphy);
 	ieee80211_do_stop(sdata, true);
 	wiphy_unlock(sdata->local->hw.wiphy);
@@ -1589,6 +1591,9 @@ static int ieee80211_runtime_change_ifty
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
+		if (!list_empty(&sdata->u.ap.vlans))
+			return -EBUSY;
+		break;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_OCB:


