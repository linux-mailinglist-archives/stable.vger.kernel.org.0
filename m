Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2DD3B618F
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbhF1Og0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:36:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235142AbhF1OfF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:35:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F065361C8F;
        Mon, 28 Jun 2021 14:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890619;
        bh=eM2rhk2kL5c6dVU2ybax6brBIgOwt4Ta8MvU1pHwI5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4CaS41FfBfnDuTSBxTQjCxSrQUXMB43cQ/jJuGuI38MxavMaeMLzDEa5NtiY31iB
         dB9QFRCuF0zkaPuAXYAhUPPUuUQWrH08UkzIPomCxdSrJwKo7ME8kFMid/c/qqb/KZ
         EwwVQJGyBbE1RM/TU4Yi9iEQdX5D0na+W3BAOnbpKe9j9lHctmwffcqSZPddNOJXBP
         w1pA44dgMyFer9w79Xzl7twxd7Y9zOEu2nOsQgTUIvrgEHN7Iqb/Wta12tSBBo/gib
         meLl11IqxLivI/R/Ssf/0RwOe9YioaCp9Dr85aOgY7I0O+/NJ5ieLr+wLhT4J6MEoe
         bw348qNBxPKpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+7716dbc401d9a437890d@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 14/71] mac80211: remove warning in ieee80211_get_sband()
Date:   Mon, 28 Jun 2021 10:29:07 -0400
Message-Id: <20210628143004.32596-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 0ee4d55534f82a0624701d0bb9fc2304d4529086 ]

Syzbot reports that it's possible to hit this from userspace,
by trying to add a station before any other connection setup
has been done. Instead of trying to catch this in some other
way simply remove the warning, that will appropriately reject
the call from userspace.

Reported-by: syzbot+7716dbc401d9a437890d@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20210517164715.f537da276d17.Id05f40ec8761d6a8cc2df87f1aa09c651988a586@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a7933279a80b..e574fbf6745a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1420,7 +1420,7 @@ ieee80211_get_sband(struct ieee80211_sub_if_data *sdata)
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 
-	if (WARN_ON_ONCE(!chanctx_conf)) {
+	if (!chanctx_conf) {
 		rcu_read_unlock();
 		return NULL;
 	}
-- 
2.30.2

