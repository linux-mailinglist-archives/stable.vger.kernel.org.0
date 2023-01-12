Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800276677DE
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240059AbjALOuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239825AbjALOtk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:49:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0363AE0DF
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:36:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E9ABB81E7A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EFDC433D2;
        Thu, 12 Jan 2023 14:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534187;
        bh=1cnXBobQ0Y4/JTuHzxMZROHcYD7vaHdIK3BPV9Wv0NM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSd8saAte75lfgEYFr75kG+tg1da7mHbo9oMKk+LuccivKZcOi+TSb7QiwZqeNLDI
         ycV62IWhrbNsYWK48ysDP8LiE3nUfjufpK5chV4GLq+kVdLoHI62nXfau75SUIrQ0S
         B+Lmb7RgNZI0cz8COk/pb0oPi2AaSyX7/n/93pjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, minoura makoto <minoura@valinux.co.jp>,
        Hiroshi Shimamoto <h-shimamoto@nec.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 724/783] SUNRPC: ensure the matching upcall is in-flight upon downcall
Date:   Thu, 12 Jan 2023 14:57:20 +0100
Message-Id: <20230112135557.915060755@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: minoura makoto <minoura@valinux.co.jp>

[ Upstream commit b18cba09e374637a0a3759d856a6bca94c133952 ]

Commit 9130b8dbc6ac ("SUNRPC: allow for upcalls for the same uid
but different gss service") introduced `auth` argument to
__gss_find_upcall(), but in gss_pipe_downcall() it was left as NULL
since it (and auth->service) was not (yet) determined.

When multiple upcalls with the same uid and different service are
ongoing, it could happen that __gss_find_upcall(), which returns the
first match found in the pipe->in_downcall list, could not find the
correct gss_msg corresponding to the downcall we are looking for.
Moreover, it might return a msg which is not sent to rpc.gssd yet.

We could see mount.nfs process hung in D state with multiple mount.nfs
are executed in parallel.  The call trace below is of CentOS 7.9
kernel-3.10.0-1160.24.1.el7.x86_64 but we observed the same hang w/
elrepo kernel-ml-6.0.7-1.el7.

PID: 71258  TASK: ffff91ebd4be0000  CPU: 36  COMMAND: "mount.nfs"
 #0 [ffff9203ca3234f8] __schedule at ffffffffa3b8899f
 #1 [ffff9203ca323580] schedule at ffffffffa3b88eb9
 #2 [ffff9203ca323590] gss_cred_init at ffffffffc0355818 [auth_rpcgss]
 #3 [ffff9203ca323658] rpcauth_lookup_credcache at ffffffffc0421ebc
[sunrpc]
 #4 [ffff9203ca3236d8] gss_lookup_cred at ffffffffc0353633 [auth_rpcgss]
 #5 [ffff9203ca3236e8] rpcauth_lookupcred at ffffffffc0421581 [sunrpc]
 #6 [ffff9203ca323740] rpcauth_refreshcred at ffffffffc04223d3 [sunrpc]
 #7 [ffff9203ca3237a0] call_refresh at ffffffffc04103dc [sunrpc]
 #8 [ffff9203ca3237b8] __rpc_execute at ffffffffc041e1c9 [sunrpc]
 #9 [ffff9203ca323820] rpc_execute at ffffffffc0420a48 [sunrpc]

The scenario is like this. Let's say there are two upcalls for
services A and B, A -> B in pipe->in_downcall, B -> A in pipe->pipe.

When rpc.gssd reads pipe to get the upcall msg corresponding to
service B from pipe->pipe and then writes the response, in
gss_pipe_downcall the msg corresponding to service A will be picked
because only uid is used to find the msg and it is before the one for
B in pipe->in_downcall.  And the process waiting for the msg
corresponding to service A will be woken up.

Actual scheduing of that process might be after rpc.gssd processes the
next msg.  In rpc_pipe_generic_upcall it clears msg->errno (for A).
The process is scheduled to see gss_msg->ctx == NULL and
gss_msg->msg.errno == 0, therefore it cannot break the loop in
gss_create_upcall and is never woken up after that.

This patch adds a simple check to ensure that a msg which is not
sent to rpc.gssd yet is not chosen as the matching upcall upon
receiving a downcall.

Signed-off-by: minoura makoto <minoura@valinux.co.jp>
Signed-off-by: Hiroshi Shimamoto <h-shimamoto@nec.com>
Tested-by: Hiroshi Shimamoto <h-shimamoto@nec.com>
Cc: Trond Myklebust <trondmy@hammerspace.com>
Fixes: 9130b8dbc6ac ("SUNRPC: allow for upcalls for same uid but different gss service")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/rpc_pipe_fs.h |  5 +++++
 net/sunrpc/auth_gss/auth_gss.c     | 19 +++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/linux/sunrpc/rpc_pipe_fs.h b/include/linux/sunrpc/rpc_pipe_fs.h
index cd188a527d16..3b35b6f6533a 100644
--- a/include/linux/sunrpc/rpc_pipe_fs.h
+++ b/include/linux/sunrpc/rpc_pipe_fs.h
@@ -92,6 +92,11 @@ extern ssize_t rpc_pipe_generic_upcall(struct file *, struct rpc_pipe_msg *,
 				       char __user *, size_t);
 extern int rpc_queue_upcall(struct rpc_pipe *, struct rpc_pipe_msg *);
 
+/* returns true if the msg is in-flight, i.e., already eaten by the peer */
+static inline bool rpc_msg_is_inflight(const struct rpc_pipe_msg *msg) {
+	return (msg->copied != 0 && list_empty(&msg->list));
+}
+
 struct rpc_clnt;
 extern struct dentry *rpc_create_client_dir(struct dentry *, const char *, struct rpc_clnt *);
 extern int rpc_remove_client_dir(struct rpc_clnt *);
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 5f42aa5fc612..2ff66a6a7e54 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -301,7 +301,7 @@ __gss_find_upcall(struct rpc_pipe *pipe, kuid_t uid, const struct gss_auth *auth
 	list_for_each_entry(pos, &pipe->in_downcall, list) {
 		if (!uid_eq(pos->uid, uid))
 			continue;
-		if (auth && pos->auth->service != auth->service)
+		if (pos->auth->service != auth->service)
 			continue;
 		refcount_inc(&pos->count);
 		return pos;
@@ -685,6 +685,21 @@ gss_create_upcall(struct gss_auth *gss_auth, struct gss_cred *gss_cred)
 	return err;
 }
 
+static struct gss_upcall_msg *
+gss_find_downcall(struct rpc_pipe *pipe, kuid_t uid)
+{
+	struct gss_upcall_msg *pos;
+	list_for_each_entry(pos, &pipe->in_downcall, list) {
+		if (!uid_eq(pos->uid, uid))
+			continue;
+		if (!rpc_msg_is_inflight(&pos->msg))
+			continue;
+		refcount_inc(&pos->count);
+		return pos;
+	}
+	return NULL;
+}
+
 #define MSG_BUF_MAXSIZE 1024
 
 static ssize_t
@@ -731,7 +746,7 @@ gss_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
 	err = -ENOENT;
 	/* Find a matching upcall */
 	spin_lock(&pipe->lock);
-	gss_msg = __gss_find_upcall(pipe, uid, NULL);
+	gss_msg = gss_find_downcall(pipe, uid);
 	if (gss_msg == NULL) {
 		spin_unlock(&pipe->lock);
 		goto err_put_ctx;
-- 
2.35.1



