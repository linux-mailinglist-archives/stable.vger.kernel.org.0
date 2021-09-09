Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4995C404C72
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239892AbhIIL5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245482AbhIILzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:55:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2434C613B3;
        Thu,  9 Sep 2021 11:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187903;
        bh=VfSF8ywJgus035S93IX3ZGmVlbPmqAAUHaLROvHLsII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aIFOdXMJ5DSVJ11x4uRT7/siy2ICiqZLu35AOECG2M8RvC05e9Q2JqEprYwUFWZ+c
         IF1XtRM8LjCCU8ttuooVvr+zQxv+3AIz9Uz00/frSoXhzKNCaajtvH9nL+U2kBvfwG
         zL0VRU/OD7gMi2pcmXixV7s3zq/b0Mw2fl9x7iqmikEdSOnWmhQsMcl/RFdCpibh8I
         8AIIn1xtejK7hHAJyUVO+ZuiQ7II6iC8G8i9OkQxQcvqrMC1U1wyXvxpJq5Q17xkWr
         blcfsOCTyZXAf+9cT/5uJh4dJW6fRDQ+emyCbAo0/ZU/2MUtTe6YI5EeFs87FUYObM
         pjyXRulXS0KOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Daire Byrne <daire@dneg.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 182/252] lockd: lockd server-side shouldn't set fl_ops
Date:   Thu,  9 Sep 2021 07:39:56 -0400
Message-Id: <20210909114106.141462-182-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

[ Upstream commit 7de875b231edb807387a81cde288aa9e1015ef9e ]

Locks have two sets of op arrays, fl_lmops for the lock manager (lockd
or nfsd), fl_ops for the filesystem.  The server-side lockd code has
been setting its own fl_ops, which leads to confusion (and crashes) in
the reexport case, where the filesystem expects to be the only one
setting fl_ops.

And there's no reason for it that I can see-the lm_get/put_owner ops do
the same job.

Reported-by: Daire Byrne <daire@dneg.com>
Tested-by: Daire Byrne <daire@dneg.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svclock.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index 61d3cc2283dc..1781fc5e9091 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -395,28 +395,10 @@ nlmsvc_release_lockowner(struct nlm_lock *lock)
 		nlmsvc_put_lockowner(lock->fl.fl_owner);
 }
 
-static void nlmsvc_locks_copy_lock(struct file_lock *new, struct file_lock *fl)
-{
-	struct nlm_lockowner *nlm_lo = (struct nlm_lockowner *)fl->fl_owner;
-	new->fl_owner = nlmsvc_get_lockowner(nlm_lo);
-}
-
-static void nlmsvc_locks_release_private(struct file_lock *fl)
-{
-	nlmsvc_put_lockowner((struct nlm_lockowner *)fl->fl_owner);
-}
-
-static const struct file_lock_operations nlmsvc_lock_ops = {
-	.fl_copy_lock = nlmsvc_locks_copy_lock,
-	.fl_release_private = nlmsvc_locks_release_private,
-};
-
 void nlmsvc_locks_init_private(struct file_lock *fl, struct nlm_host *host,
 						pid_t pid)
 {
 	fl->fl_owner = nlmsvc_find_lockowner(host, pid);
-	if (fl->fl_owner != NULL)
-		fl->fl_ops = &nlmsvc_lock_ops;
 }
 
 /*
@@ -788,9 +770,21 @@ nlmsvc_notify_blocked(struct file_lock *fl)
 	printk(KERN_WARNING "lockd: notification for unknown block!\n");
 }
 
+static fl_owner_t nlmsvc_get_owner(fl_owner_t owner)
+{
+	return nlmsvc_get_lockowner(owner);
+}
+
+static void nlmsvc_put_owner(fl_owner_t owner)
+{
+	nlmsvc_put_lockowner(owner);
+}
+
 const struct lock_manager_operations nlmsvc_lock_operations = {
 	.lm_notify = nlmsvc_notify_blocked,
 	.lm_grant = nlmsvc_grant_deferred,
+	.lm_get_owner = nlmsvc_get_owner,
+	.lm_put_owner = nlmsvc_put_owner,
 };
 
 /*
-- 
2.30.2

