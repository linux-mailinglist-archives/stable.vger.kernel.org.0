Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9BD412222
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359848AbhITSNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:13:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356735AbhITSKr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:10:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4185063277;
        Mon, 20 Sep 2021 17:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158414;
        bh=6LOksXce/k5HvDLNXSjLG9Te585jaGoi0SD0jX9pYW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjw1SVxAX1ca0vVYIf7oEqEsK9Y8frh0zNeiRFYAw34f0yU2wmKNw6Pj8iZqA40JV
         RDnVrP5RZDQn6HNcHHK8Eo+hOtQzvPyubGAThLloXqW0y3Jnrld39ucMVpqpho/kSq
         oTlqhmRC8y8ujxMrvPAXSF7e9Hy6Csh9gj3qgbxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daire Byrne <daire@dneg.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 145/260] lockd: lockd server-side shouldnt set fl_ops
Date:   Mon, 20 Sep 2021 18:42:43 +0200
Message-Id: <20210920163936.043800511@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

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
index 498cb70c2c0d..273a81971ed5 100644
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



