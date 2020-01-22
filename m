Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD30145647
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbgAVNY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:24:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:43398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729151AbgAVNYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:24:25 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 905532468A;
        Wed, 22 Jan 2020 13:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699465;
        bh=q2Ktr8oEsKQfbcS/mb8ot+UDb6iWm9eHCebzprgScec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQU642j/bc7AYTlj2oIhKMt5q9QjC2NrTghB0s8HGAXSwfnVsmYXo0uPZHaZOh2EB
         dwG8WQvDofQ96AtY47BrQ7I4JiiMrv5NUdRM2ttNtI0aiKPLNO+TQH31uP8oILTMA7
         Cm1RmAnvbzEuicn2zh7MHG9KiN0VNIgjSuzdeYG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Markus Theil <markus.theil@tu-ilmenau.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 118/222] cfg80211: fix deadlocks in autodisconnect work
Date:   Wed, 22 Jan 2020 10:28:24 +0100
Message-Id: <20200122092842.189163287@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Markus Theil <markus.theil@tu-ilmenau.de>

commit 5a128a088a2ab0b5190eeb232b5aa0b1017a0317 upstream.

Use methods which do not try to acquire the wdev lock themselves.

Cc: stable@vger.kernel.org
Fixes: 37b1c004685a3 ("cfg80211: Support all iftypes in autodisconnect_wk")
Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
Link: https://lore.kernel.org/r/20200108115536.2262-1-markus.theil@tu-ilmenau.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/sme.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1307,14 +1307,14 @@ void cfg80211_autodisconnect_wk(struct w
 	if (wdev->conn_owner_nlportid) {
 		switch (wdev->iftype) {
 		case NL80211_IFTYPE_ADHOC:
-			cfg80211_leave_ibss(rdev, wdev->netdev, false);
+			__cfg80211_leave_ibss(rdev, wdev->netdev, false);
 			break;
 		case NL80211_IFTYPE_AP:
 		case NL80211_IFTYPE_P2P_GO:
-			cfg80211_stop_ap(rdev, wdev->netdev, false);
+			__cfg80211_stop_ap(rdev, wdev->netdev, false);
 			break;
 		case NL80211_IFTYPE_MESH_POINT:
-			cfg80211_leave_mesh(rdev, wdev->netdev);
+			__cfg80211_leave_mesh(rdev, wdev->netdev);
 			break;
 		case NL80211_IFTYPE_STATION:
 		case NL80211_IFTYPE_P2P_CLIENT:


