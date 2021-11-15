Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D644513A6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348573AbhKOTyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:54:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343710AbhKOTVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC864635D7;
        Mon, 15 Nov 2021 18:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001894;
        bh=GEK4oGja1rp4ZwDbg53pN+o2JQmK+EZF+En5tw4nLIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9JgcGnidVqIyHjFm9OW+VBBftyBIY3s4Y1xLYeSAmSOdh7dKMCj1TFFzcjt3rgpw
         GTnqvlKzV8HJ2JwNDj29SUs3roFQPsOiRHnH4flOCfUKTrYfL9ih6AbTsndlLKNwCN
         D+/G665KHZV5R+lrgDqaF2STar+SJml6LWagfo3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 361/917] cfg80211: always free wiphy specific regdomain
Date:   Mon, 15 Nov 2021 17:57:36 +0100
Message-Id: <20211115165441.002668348@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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



