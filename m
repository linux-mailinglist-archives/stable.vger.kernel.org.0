Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91733177F38
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731761AbgCCRtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:49:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:56626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729625AbgCCRtU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:49:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A43CE20870;
        Tue,  3 Mar 2020 17:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257760;
        bh=LKAi9ciioPWY0YjeU6EJygKdXh1e7ru3tazXnuOztQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gk4VZklhCAXa9y+fSvzd/k0mJ3uayzkQ1Pj3y4DLx9apfwe+m/XDQ95rNilVdWyki
         k0La942dxfBjK4p/ux2e9qDUwLLkUFwib+xWJOtxG+MatsRz6Ijq9nYL4WYKIcZMNt
         Tp1D9tu0fBhl+TU6RJZjwUgyhlfgUdQhE4DvUXG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.5 119/176] mac80211: Remove a redundant mutex unlock
Date:   Tue,  3 Mar 2020 18:43:03 +0100
Message-Id: <20200303174318.574821134@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

commit 0daa63ed4c6c4302790ce67b7a90c0997ceb7514 upstream.

The below-mentioned commit changed the code to unlock *inside*
the function, but previously the unlock was *outside*. It failed
to remove the outer unlock, however, leading to double unlock.

Fix this.

Fixes: 33483a6b88e4 ("mac80211: fix missing unlock on error in ieee80211_mark_sta_auth()")
Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Link: https://lore.kernel.org/r/20200221104719.cce4741cf6eb.I671567b185c8a4c2409377e483fd149ce590f56d@changeid
[rewrite commit message to better explain what happened]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2959,7 +2959,7 @@ static void ieee80211_rx_mgmt_auth(struc
 	    (auth_transaction == 2 &&
 	     ifmgd->auth_data->expected_transaction == 2)) {
 		if (!ieee80211_mark_sta_auth(sdata, bssid))
-			goto out_err;
+			return; /* ignore frame -- wait for timeout */
 	} else if (ifmgd->auth_data->algorithm == WLAN_AUTH_SAE &&
 		   auth_transaction == 2) {
 		sdata_info(sdata, "SAE peer confirmed\n");
@@ -2967,10 +2967,6 @@ static void ieee80211_rx_mgmt_auth(struc
 	}
 
 	cfg80211_rx_mlme_mgmt(sdata->dev, (u8 *)mgmt, len);
-	return;
- out_err:
-	mutex_unlock(&sdata->local->sta_mtx);
-	/* ignore frame -- wait for timeout */
 }
 
 #define case_WLAN(type) \


