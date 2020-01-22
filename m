Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C49114505D
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387529AbgAVJmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:42:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387689AbgAVJmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:42:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4261624680;
        Wed, 22 Jan 2020 09:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686133;
        bh=0oF3uSLp7so0kjfvcUBglP4VRwZLRZ+56HRBZYyOKKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBvC349hFi/kvZozUrxlCDGwqHGGJPtLw0j50At9nRFf1CiPYwJBOd38QmYf8xDg5
         CyaM2SDx6sQD2eNHQkNlTfhsLsl/OAFK1SwUq3MdOCtsVDRH1zj1S2pqSrn+0EkaGI
         aUbbqS1XWBLz1+WEWzrDGD3NrqydsWL8GoDh0rZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Markus Theil <markus.theil@tu-ilmenau.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 056/103] cfg80211: fix deadlocks in autodisconnect work
Date:   Wed, 22 Jan 2020 10:29:12 +0100
Message-Id: <20200122092812.073866895@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
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
@@ -1281,14 +1281,14 @@ void cfg80211_autodisconnect_wk(struct w
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


