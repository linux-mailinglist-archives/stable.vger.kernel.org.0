Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1116D2C08EF
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388302AbgKWNDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:03:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387630AbgKWMva (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:51:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D097B20857;
        Mon, 23 Nov 2020 12:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135887;
        bh=O5gee0t8j07fOPVBA6yTgfRJu0asMENr1zVciqfm7hE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xwqm3I28tgGCsgTciZicCyU1ivRDQNLuVM9g+cDqTW0EnjtErGuPbsfNozJbo5rv6
         DYmjThjPs9lOouoXstk+eEhq2ZXpR9G2ev2QGsrub9TK7swfkKqJmQHdtywxkP5Arp
         f0Fp9o9BD2jrSxbQ1s4FmoW4vANnYbLfsZxfXBLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+32c6c38c4812d22f2f0b@syzkaller.appspotmail.com,
        syzbot+4c81fe92e372d26c4246@syzkaller.appspotmail.com,
        syzbot+6a7fe9faf0d1d61bc24a@syzkaller.appspotmail.com,
        syzbot+abed06851c5ffe010921@syzkaller.appspotmail.com,
        syzbot+b7aeb9318541a1c709f1@syzkaller.appspotmail.com,
        syzbot+d5a9416c6cafe53b5dd0@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.9 231/252] mac80211: free sta in sta_info_insert_finish() on errors
Date:   Mon, 23 Nov 2020 13:23:01 +0100
Message-Id: <20201123121846.718632404@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 7bc40aedf24d31d8bea80e1161e996ef4299fb10 upstream.

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
Link: https://lore.kernel.org/r/20201112112201.ee6b397b9453.I9c31d667a0ea2151441cc64ed6613d36c18a48e0@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/sta_info.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -705,7 +705,7 @@ static int sta_info_insert_finish(struct
  out_drop_sta:
 	local->num_sta--;
 	synchronize_net();
-	__cleanup_single_sta(sta);
+	cleanup_single_sta(sta);
  out_err:
 	mutex_unlock(&local->sta_mtx);
 	kfree(sinfo);
@@ -724,19 +724,13 @@ int sta_info_insert_rcu(struct sta_info
 
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


