Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3247610BAA6
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732270AbfK0VFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:05:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:58948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732268AbfK0VFR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:05:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72B9B20637;
        Wed, 27 Nov 2019 21:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888716;
        bh=kZ8zWA2dW+43AmUKUBWUQPRKVQv73HqDZw+2W139/QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rB2y9KGXpuDDOpDAY4v8+YsHwUY5IIXAs20kb+7kcXlMiHnPkdKkdXAqO/JwMNV3D
         6CtXli7Qd+WGF9TLl2Ib27CFhYpWUjJeOgxtUvqhTSlOXK+d7fnvrZJ+GUVv7/BKCK
         P68NGW9tQsw7IZ4ICs1udTxswYcAR4eOQB4oBjsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sriram R <srirrama@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 243/306] cfg80211: Prevent regulatory restore during STA disconnect in concurrent interfaces
Date:   Wed, 27 Nov 2019 21:31:33 +0100
Message-Id: <20191127203132.706702903@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sriram R <srirrama@codeaurora.org>

[ Upstream commit 113f3aaa81bd56aba02659786ed65cbd9cb9a6fc ]

Currently when an AP and STA interfaces are active in the same or different
radios, regulatory settings are restored whenever the STA disconnects. This
restores all channel information including dfs states in all radios.
For example, if an AP interface is active in one radio and STA in another,
when radar is detected on the AP interface, the dfs state of the channel
will be changed to UNAVAILABLE. But when the STA interface disconnects,
this issues a regulatory disconnect hint which restores all regulatory
settings in all the radios attached and thereby losing the stored dfs
state on the other radio where the channel was marked as unavailable
earlier. Hence prevent such regulatory restore whenever another active
beaconing interface is present in the same or other radios.

Signed-off-by: Sriram R <srirrama@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/sme.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index d536b07582f8c..c7047c7b4e80f 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -642,11 +642,15 @@ static bool cfg80211_is_all_idle(void)
 	 * All devices must be idle as otherwise if you are actively
 	 * scanning some new beacon hints could be learned and would
 	 * count as new regulatory hints.
+	 * Also if there is any other active beaconing interface we
+	 * need not issue a disconnect hint and reset any info such
+	 * as chan dfs state, etc.
 	 */
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
 		list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 			wdev_lock(wdev);
-			if (wdev->conn || wdev->current_bss)
+			if (wdev->conn || wdev->current_bss ||
+			    cfg80211_beaconing_iface_active(wdev))
 				is_all_idle = false;
 			wdev_unlock(wdev);
 		}
-- 
2.20.1



