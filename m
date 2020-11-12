Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACAF92B02A4
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 11:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgKLKWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 05:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgKLKWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 05:22:20 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BACC0613D1;
        Thu, 12 Nov 2020 02:22:20 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kd9k8-006G8G-HC; Thu, 12 Nov 2020 11:22:16 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org,
        syzbot+32c6c38c4812d22f2f0b@syzkaller.appspotmail.com,
        syzbot+4c81fe92e372d26c4246@syzkaller.appspotmail.com,
        syzbot+6a7fe9faf0d1d61bc24a@syzkaller.appspotmail.com,
        syzbot+abed06851c5ffe010921@syzkaller.appspotmail.com,
        syzbot+b7aeb9318541a1c709f1@syzkaller.appspotmail.com,
        syzbot+d5a9416c6cafe53b5dd0@syzkaller.appspotmail.com
Subject: [PATCH] mac80211: free sta in sta_info_insert_finish() on errors
Date:   Thu, 12 Nov 2020 11:22:04 +0100
Message-Id: <20201112112201.ee6b397b9453.I9c31d667a0ea2151441cc64ed6613d36c18a48e0@changeid>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

If sta_info_insert_finish() fails, we currently keep the station
around and free it only in the caller, but there's only one such
caller and it always frees it immediately.

As syzbot found, another consequence of this split is that we can
put things that sleep only into __cleanup_single_sta() and not in
sta_info_free(), but this is the only place that requires such of
sta_info_free() now.

Change this to free the station in sta_info_insert_finish(), in
which case we can still sleep. This will also let us unify the
cleanup code later.

Cc: stable@vger.kernel.org
Fixes: dcd479e10a05 ("mac80211: always wind down STA state")
Reported-by: syzbot+32c6c38c4812d22f2f0b@syzkaller.appspotmail.com
Reported-by: syzbot+4c81fe92e372d26c4246@syzkaller.appspotmail.com
Reported-by: syzbot+6a7fe9faf0d1d61bc24a@syzkaller.appspotmail.com
Reported-by: syzbot+abed06851c5ffe010921@syzkaller.appspotmail.com
Reported-by: syzbot+b7aeb9318541a1c709f1@syzkaller.appspotmail.com
Reported-by: syzbot+d5a9416c6cafe53b5dd0@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 4fe284ff1ea3..ec6973ee88ef 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -705,7 +705,7 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
  out_drop_sta:
 	local->num_sta--;
 	synchronize_net();
-	__cleanup_single_sta(sta);
+	cleanup_single_sta(sta);
  out_err:
 	mutex_unlock(&local->sta_mtx);
 	kfree(sinfo);
@@ -724,19 +724,13 @@ int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
 
 	err = sta_info_insert_check(sta);
 	if (err) {
+		sta_info_free(local, sta);
 		mutex_unlock(&local->sta_mtx);
 		rcu_read_lock();
-		goto out_free;
+		return err;
 	}
 
-	err = sta_info_insert_finish(sta);
-	if (err)
-		goto out_free;
-
-	return 0;
- out_free:
-	sta_info_free(local, sta);
-	return err;
+	return sta_info_insert_finish(sta);
 }
 
 int sta_info_insert(struct sta_info *sta)
-- 
2.26.2

