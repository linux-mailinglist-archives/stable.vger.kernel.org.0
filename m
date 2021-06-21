Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5B63AF09C
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhFUQuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:50:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232184AbhFUQtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:49:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F99D611BD;
        Mon, 21 Jun 2021 16:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293252;
        bh=U3g65Nv1hP3/UzjrGi9s0kaPppyW9pjszhufNDJaguI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIvqnSUo4tEabErhZRuru1oauCP85eMDlmNupazPTPppSj0zzBfTQGUFDnaz949OF
         CApcPRuYTpJYxqEBHuarjk7gsIzbzPlfgGykvJXJasEJ4Kz1yMRhlos+N9k81FX5Eu
         GL7FsvZ02g2C47T/i0UUHs08egd966KqS0tXv00A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.12 154/178] cfg80211: fix phy80211 symlink creation
Date:   Mon, 21 Jun 2021 18:16:08 +0200
Message-Id: <20210621154928.001689757@linuxfoundation.org>
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

commit 43076c1e074359f11c85d7d1b85ede1bbb8ee6b9 upstream.

When I moved around the code here, I neglected that we could still
call register_netdev() or similar without the wiphy mutex held,
which then calls cfg80211_register_wdev() - that's also done from
cfg80211_register_netdevice(), but the phy80211 symlink creation
was only there. Now, the symlink isn't needed for a *pure* wdev,
but a netdev not registered via cfg80211_register_wdev() should
still have the symlink, so move the creation to the right place.

Cc: stable@vger.kernel.org
Fixes: 2fe8ef106238 ("cfg80211: change netdev registration/unregistration semantics")
Link: https://lore.kernel.org/r/20210608113226.a5dc4c1e488c.Ia42fe663cefe47b0883af78c98f284c5555bbe5d@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/core.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1339,6 +1339,11 @@ void cfg80211_register_wdev(struct cfg80
 	rdev->devlist_generation++;
 	wdev->registered = true;
 
+	if (wdev->netdev &&
+	    sysfs_create_link(&wdev->netdev->dev.kobj, &rdev->wiphy.dev.kobj,
+			      "phy80211"))
+		pr_err("failed to add phy80211 symlink to netdev!\n");
+
 	nl80211_notify_iface(rdev, wdev, NL80211_CMD_NEW_INTERFACE);
 }
 
@@ -1364,14 +1369,6 @@ int cfg80211_register_netdevice(struct n
 	if (ret)
 		goto out;
 
-	if (sysfs_create_link(&dev->dev.kobj, &rdev->wiphy.dev.kobj,
-			      "phy80211")) {
-		pr_err("failed to add phy80211 symlink to netdev!\n");
-		unregister_netdevice(dev);
-		ret = -EINVAL;
-		goto out;
-	}
-
 	cfg80211_register_wdev(rdev, wdev);
 	ret = 0;
 out:


