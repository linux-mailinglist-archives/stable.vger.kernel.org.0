Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913434BE580
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349958AbiBUJ2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:28:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349194AbiBUJ1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:27:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E194D237D9;
        Mon, 21 Feb 2022 01:12:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D5A660B1B;
        Mon, 21 Feb 2022 09:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62625C340E9;
        Mon, 21 Feb 2022 09:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434757;
        bh=lIrrySYVtcncVdCuEiZ4YiYeeNz35RMRuhzq2z1xfFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+zw9hhsQKXGtCn01pUJ5cbm+B91bEROQaka2ACixy5tIr0v/Ymxlrr2ol7vhb8YH
         CbSeD+3twblbD8dC1zwQSPF1sG+I0ORgHd2p0nt6B9Y2v1eu4c4SUbc2dZnlr9+oiF
         Zb0J/yNjPat7yn3sdCt3rZXVWiKwD8+TXh0vq+fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 088/196] cfg80211: fix race in netlink owner interface destruction
Date:   Mon, 21 Feb 2022 09:48:40 +0100
Message-Id: <20220221084933.870043992@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit f0a6fd1527067da537e9c48390237488719948ed upstream.

My previous fix here to fix the deadlock left a race where
the exact same deadlock (see the original commit referenced
below) can still happen if cfg80211_destroy_ifaces() already
runs while nl80211_netlink_notify() is still marking some
interfaces as nl_owner_dead.

The race happens because we have two loops here - first we
dev_close() all the netdevs, and then we destroy them. If we
also have two netdevs (first one need only be a wdev though)
then we can find one during the first iteration, close it,
and go to the second iteration -- but then find two, and try
to destroy also the one we didn't close yet.

Fix this by only iterating once.

Reported-by: Toke Høiland-Jørgensen <toke@redhat.com>
Fixes: ea6b2098dd02 ("cfg80211: fix locking in netlink owner interface destruction")
Tested-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20220201130951.22093-1-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/core.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -5,7 +5,7 @@
  * Copyright 2006-2010		Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright 2015-2017	Intel Deutschland GmbH
- * Copyright (C) 2018-2021 Intel Corporation
+ * Copyright (C) 2018-2022 Intel Corporation
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -332,29 +332,20 @@ static void cfg80211_event_work(struct w
 void cfg80211_destroy_ifaces(struct cfg80211_registered_device *rdev)
 {
 	struct wireless_dev *wdev, *tmp;
-	bool found = false;
 
 	ASSERT_RTNL();
 
-	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+	list_for_each_entry_safe(wdev, tmp, &rdev->wiphy.wdev_list, list) {
 		if (wdev->nl_owner_dead) {
 			if (wdev->netdev)
 				dev_close(wdev->netdev);
-			found = true;
-		}
-	}
-
-	if (!found)
-		return;
 
-	wiphy_lock(&rdev->wiphy);
-	list_for_each_entry_safe(wdev, tmp, &rdev->wiphy.wdev_list, list) {
-		if (wdev->nl_owner_dead) {
+			wiphy_lock(&rdev->wiphy);
 			cfg80211_leave(rdev, wdev);
 			rdev_del_virtual_intf(rdev, wdev);
+			wiphy_unlock(&rdev->wiphy);
 		}
 	}
-	wiphy_unlock(&rdev->wiphy);
 }
 
 static void cfg80211_destroy_iface_wk(struct work_struct *work)


