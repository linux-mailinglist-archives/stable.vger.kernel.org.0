Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7809A6C634
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391151AbfGRDO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:14:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391798AbfGRDO1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:14:27 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A049C2053B;
        Thu, 18 Jul 2019 03:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419667;
        bh=LXZNXpO+sm9HMm26ctgzlsT1YNXqRzzH5b37UpQAV8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPsuN+gg/Be4fHbPNT/HGeTTlFyBBax142cVxpG584frPH1LrmNbsmM03ydvk363w
         oj/nPMvVjwUl8mf94vTE9sr6Kslg+VWDmR2ScEo4jMQm8TQO13WE7h8FTDh+XKT7Nt
         zPVF5ZBhVsDzq6NurVF7vmBXDiaBYKVrsxuSEVic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Pedersen <thomas@eero.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 03/40] mac80211: mesh: fix RCU warning
Date:   Thu, 18 Jul 2019 12:01:59 +0900
Message-Id: <20190718030040.414071487@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030039.676518610@linuxfoundation.org>
References: <20190718030039.676518610@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 551842446ed695641a00782cd118cbb064a416a1 ]

ifmsh->csa is an RCU-protected pointer. The writer context
in ieee80211_mesh_finish_csa() is already mutually
exclusive with wdev->sdata.mtx, but the RCU checker did
not know this. Use rcu_dereference_protected() to avoid a
warning.

fixes the following warning:

[   12.519089] =============================
[   12.520042] WARNING: suspicious RCU usage
[   12.520652] 5.1.0-rc7-wt+ #16 Tainted: G        W
[   12.521409] -----------------------------
[   12.521972] net/mac80211/mesh.c:1223 suspicious rcu_dereference_check() usage!
[   12.522928] other info that might help us debug this:
[   12.523984] rcu_scheduler_active = 2, debug_locks = 1
[   12.524855] 5 locks held by kworker/u8:2/152:
[   12.525438]  #0: 00000000057be08c ((wq_completion)phy0){+.+.}, at: process_one_work+0x1a2/0x620
[   12.526607]  #1: 0000000059c6b07a ((work_completion)(&sdata->csa_finalize_work)){+.+.}, at: process_one_work+0x1a2/0x620
[   12.528001]  #2: 00000000f184ba7d (&wdev->mtx){+.+.}, at: ieee80211_csa_finalize_work+0x2f/0x90
[   12.529116]  #3: 00000000831a1f54 (&local->mtx){+.+.}, at: ieee80211_csa_finalize_work+0x47/0x90
[   12.530233]  #4: 00000000fd06f988 (&local->chanctx_mtx){+.+.}, at: ieee80211_csa_finalize_work+0x51/0x90

Signed-off-by: Thomas Pedersen <thomas@eero.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 1cbc7bd26de3..4bd8f3f056d8 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1138,7 +1138,8 @@ int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
 	ifmsh->chsw_ttl = 0;
 
 	/* Remove the CSA and MCSP elements from the beacon */
-	tmp_csa_settings = rcu_dereference(ifmsh->csa);
+	tmp_csa_settings = rcu_dereference_protected(ifmsh->csa,
+					    lockdep_is_held(&sdata->wdev.mtx));
 	RCU_INIT_POINTER(ifmsh->csa, NULL);
 	if (tmp_csa_settings)
 		kfree_rcu(tmp_csa_settings, rcu_head);
@@ -1160,6 +1161,8 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
 	struct mesh_csa_settings *tmp_csa_settings;
 	int ret = 0;
 
+	lockdep_assert_held(&sdata->wdev.mtx);
+
 	tmp_csa_settings = kmalloc(sizeof(*tmp_csa_settings),
 				   GFP_ATOMIC);
 	if (!tmp_csa_settings)
-- 
2.20.1



