Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0024408E4
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 15:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhJ3NE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 09:04:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230082AbhJ3NE4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Oct 2021 09:04:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2B4C60E9C;
        Sat, 30 Oct 2021 13:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635598946;
        bh=MtiI/1/qUCqPv8HtpXnpPdQc2oR5+X30p5d1/5T+cp4=;
        h=Subject:To:Cc:From:Date:From;
        b=ApjYIcUbAxig9g7/EWi/I52b9UdOD2r9IKx9H8otMIf2wNa96TP9BPkZoMnKLNpMq
         6IhpNnEbEB2du0CLf5ew4mEe8/ADwY6M8OJGPv5YyG93buPSs3ibWn1IqxG+7kC8tn
         KpZ7PFWZtFhpPAfh2Ip8bThzecJe2rR6r+dEOP7c=
Subject: FAILED: patch "[PATCH] cfg80211: correct bridge/4addr mode check" failed to apply to 4.9-stable tree
To:     janusz.dziedzic@gmail.com, johannes.berg@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Oct 2021 15:02:10 +0200
Message-ID: <16355989302952@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 689a0a9f505f7bffdefe6f17fddb41c8ab6344f6 Mon Sep 17 00:00:00 2001
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Date: Sun, 24 Oct 2021 22:15:46 +0200
Subject: [PATCH] cfg80211: correct bridge/4addr mode check

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

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 18dba3d7c638..a1a99a574984 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1028,14 +1028,14 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
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

