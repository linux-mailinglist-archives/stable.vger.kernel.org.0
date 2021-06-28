Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6AB3B63F3
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236747AbhF1PCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:02:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232273AbhF1PAZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:00:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D76461D6E;
        Mon, 28 Jun 2021 14:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891254;
        bh=RpX+WGxLTHL19BXdL9ZW8S463Uw+Gr86xTRwIYqWZKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S1H2/zVt611fSdR8jGM9TW+Oaz5T+8iaSjtRwCBqi9tFZ73XwC5n13v9H6ow/wfYh
         BvmhXTkeQ2ePdA54aMu80SUaNiPkBKVUfjW3uHv2WxZf0OE56uNA18mbbuhnauomLv
         T5GONRQzC/nkxTKo5d669P+aK/VtMq8o3bcA3SCL9PsiOV2LBKGFUYUVzFsxFZX6aI
         mZVfklB6jSbH3sE/Offh9nFz4b1DitRfKtVjqs4DfJ6Wg/8t2fOhkt1I/hv6NYqW4u
         1UOokFcRdO7OGj79pjM4EDyohHllQaibzUbszNDP4YdQFtyH6OMlWldfqeHQq+nkkX
         um+MXHXg1n7jw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+7716dbc401d9a437890d@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 56/71] mac80211: remove warning in ieee80211_get_sband()
Date:   Mon, 28 Jun 2021 10:39:48 -0400
Message-Id: <20210628144003.34260-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
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
index 21b35255ecc2..f5532a3ce72e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1391,7 +1391,7 @@ ieee80211_get_sband(struct ieee80211_sub_if_data *sdata)
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 
-	if (WARN_ON_ONCE(!chanctx_conf)) {
+	if (!chanctx_conf) {
 		rcu_read_unlock();
 		return NULL;
 	}
-- 
2.30.2

