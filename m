Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF733C4E1A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240156AbhGLHQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243328AbhGLHQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:16:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 262A561151;
        Mon, 12 Jul 2021 07:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073960;
        bh=cFUBcCT2mkVPvTne/BvjoYfPQ7E242JQG1yRU1Typcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vjX8nflMg8uNSMhjzr/ho2z1u2d58FOzZxN2PO91JAD2PdQjDX3QtLlJ7aBKZy6dQ
         TRLAkISdyZKyCuWfj5Af8IwXpBxUleoRBB96G9ambQVlj/I+R3QJ452nGCerHg0lsf
         SZ7Hrvjb+IKvwkfgEMu7NxbShAfYuhDkePUgNJYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 417/700] wil6210: remove erroneous wiphy locking
Date:   Mon, 12 Jul 2021 08:08:20 +0200
Message-Id: <20210712061020.735451219@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 8f78caa2264ece71c2e207cba023f28ab6665138 ]

We already hold the wiphy lock in all cases when we get
here, so this would deadlock, remove the erroneous locking.

Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210426212929.83f1de07c2cd.I630a2a00eff185ba0452324b3d3f645e01128a95@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 6746fd206d2a..1ff2679963f0 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -2842,9 +2842,7 @@ void wil_p2p_wdev_free(struct wil6210_priv *wil)
 	wil->radio_wdev = wil->main_ndev->ieee80211_ptr;
 	mutex_unlock(&wil->vif_mutex);
 	if (p2p_wdev) {
-		wiphy_lock(wil->wiphy);
 		cfg80211_unregister_wdev(p2p_wdev);
-		wiphy_unlock(wil->wiphy);
 		kfree(p2p_wdev);
 	}
 }
-- 
2.30.2



