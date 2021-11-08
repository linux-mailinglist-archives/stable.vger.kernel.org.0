Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC18644A102
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbhKIBHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:07:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237694AbhKIBFP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:05:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F069B613B3;
        Tue,  9 Nov 2021 01:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419718;
        bh=VqO9UX80S7KII/tWuH8caqgUVnPtn1KRxFD1AbG4BM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLXnX0/pFk6FBQCYzrQ8ufJDzm6IihVwWHk1U1efWqvlpJ83tWwbe2ORhTFIw0vmV
         azJfVwjsNw8iZyyqDKQ5qR5if4FF6TQ9PCbPgtMwyzA157udOsK4Z3Arn1+g0JUd5n
         jT93Bj+DbjND9Hx2D/3Q2QWVBJjCkefzCdv587VUx57hLavUE82cuUtpcGXecqLRm0
         EIM8iuor7oKh0g5alkAXgm7CCtkpyOND7uUryGjWDjmUVQDKEul3ga+Fq3M1FfUZl4
         ErtxawMpGSgGbTnIuRlrp3XaaBZOGfTmsNhRew9Uc0qov8mO9Dy/5EuJ0kDLKWnVWU
         4KZtM7jy5+Emw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        syzbot+3f91de0b813cc3d19a80@syzkaller.appspotmail.com,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>, jmorris@namei.org,
        serge@hallyn.com, linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 016/138] smackfs: Fix use-after-free in netlbl_catmap_walk()
Date:   Mon,  8 Nov 2021 12:44:42 -0500
Message-Id: <20211108174644.1187889-16-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

[ Upstream commit 0817534ff9ea809fac1322c5c8c574be8483ea57 ]

Syzkaller reported use-after-free bug as described in [1]. The bug is
triggered when smk_set_cipso() tries to free stale category bitmaps
while there are concurrent reader(s) using the same bitmaps.

Wait for RCU grace period to finish before freeing the category bitmaps
in smk_set_cipso(). This makes sure that there are no more readers using
the stale bitmaps and freeing them should be safe.

[1] https://lore.kernel.org/netdev/000000000000a814c505ca657a4e@google.com/

Reported-by: syzbot+3f91de0b813cc3d19a80@syzkaller.appspotmail.com
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smackfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 3a75d2a8f5178..9d853c0e55b84 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -831,6 +831,7 @@ static int smk_open_cipso(struct inode *inode, struct file *file)
 static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos, int format)
 {
+	struct netlbl_lsm_catmap *old_cat;
 	struct smack_known *skp;
 	struct netlbl_lsm_secattr ncats;
 	char mapcatset[SMK_CIPSOLEN];
@@ -920,9 +921,11 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 
 	rc = smk_netlbl_mls(maplevel, mapcatset, &ncats, SMK_CIPSOLEN);
 	if (rc >= 0) {
-		netlbl_catmap_free(skp->smk_netlabel.attr.mls.cat);
+		old_cat = skp->smk_netlabel.attr.mls.cat;
 		skp->smk_netlabel.attr.mls.cat = ncats.attr.mls.cat;
 		skp->smk_netlabel.attr.mls.lvl = ncats.attr.mls.lvl;
+		synchronize_rcu();
+		netlbl_catmap_free(old_cat);
 		rc = count;
 		/*
 		 * This mapping may have been cached, so clear the cache.
-- 
2.33.0

