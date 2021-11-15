Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB66F45107C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239204AbhKOSt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:49:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242835AbhKOSqf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:46:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26FD063293;
        Mon, 15 Nov 2021 18:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999619;
        bh=GEK4oGja1rp4ZwDbg53pN+o2JQmK+EZF+En5tw4nLIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yF2ugqaoC3Xg6WwACCPcVwcI5YU7H4KVxROmOxSSpj+fKEPu+9JEbFXTMzwkDP3Tn
         mDLgwhbCBMRluEUbpTcUq57U09FNnD2kHiaEZCTJQOcVU7QwMcpCwb7DePHZiiGW7U
         rEX5Fn51maokETt6ti19AZzgDU0NeC54Txm7+pGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 364/849] cfg80211: always free wiphy specific regdomain
Date:   Mon, 15 Nov 2021 17:57:27 +0100
Message-Id: <20211115165432.546582455@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e53e9828a8d2c6545e01ff9711f1221f2fd199ce ]

In the (somewhat unlikely) event that we allocate a wiphy, then
add a regdomain to it, and then fail registration, we leak the
regdomain. Fix this by just always freeing it at the end, in the
normal cases we'll free (and NULL) it during wiphy_unregister().
This happened when the wiphy settings were bad, and since they
can be controlled by userspace with hwsim, syzbot was able to
find this issue.

Reported-by: syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com
Fixes: 3e0c3ff36c4c ("cfg80211: allow multiple driver regulatory_hints()")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20210927131105.68b70cef4674.I4b9f0aa08c2af28555963b9fe3d34395bb72e0cc@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index aaba847d79eb2..eb297e1015e05 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1081,6 +1081,16 @@ void cfg80211_dev_free(struct cfg80211_registered_device *rdev)
 	list_for_each_entry_safe(scan, tmp, &rdev->bss_list, list)
 		cfg80211_put_bss(&rdev->wiphy, &scan->pub);
 	mutex_destroy(&rdev->wiphy.mtx);
+
+	/*
+	 * The 'regd' can only be non-NULL if we never finished
+	 * initializing the wiphy and thus never went through the
+	 * unregister path - e.g. in failure scenarios. Thus, it
+	 * cannot have been visible to anyone if non-NULL, so we
+	 * can just free it here.
+	 */
+	kfree(rcu_dereference_raw(rdev->wiphy.regd));
+
 	kfree(rdev);
 }
 
-- 
2.33.0



