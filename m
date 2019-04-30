Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11706F719
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbfD3LtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730949AbfD3LtH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:49:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91A2220449;
        Tue, 30 Apr 2019 11:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624947;
        bh=+T1F1qSVXdecpRNVPxr8tVprDNtm46AYHKTyhyYoIOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f55pOvF3+tlCSMX1w6qGR13VcLD0BpzbqlNdM+u4fXQ+GmveX8ykcp6dsHd+jjJrN
         pMspOrJXDMkeGhXrB98yZI1OzaqhPJJJoXOQO1z+M5HaVIH6Qw3RzgPlrjU5X3TL50
         Zx8zYwNYOKvZSs65NP+MfEbRQZdIXLiQgxUq5BbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Slawomir Pryczek <slawek1211@gmail.com>,
        Neil Brown <neilb@suse.com>, Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 5.0 32/89] nfsd: wake blocked file lock waiters before sending callback
Date:   Tue, 30 Apr 2019 13:38:23 +0200
Message-Id: <20190430113611.416526562@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit f456458e4d25a8962d0946891617c76cc3ff5fb9 upstream.

When a blocked NFS lock is "awoken" we send a callback to the server and
then wake any hosts waiting on it. If a client attempts to get a lock
and then drops off the net, we could end up waiting for a long time
until we end up waking locks blocked on that request.

So, wake any other waiting lock requests before sending the callback.
Do this by calling locks_delete_block in a new "prepare" phase for
CB_NOTIFY_LOCK callbacks.

URL: https://bugzilla.kernel.org/show_bug.cgi?id=203363
Fixes: 16306a61d3b7 ("fs/locks: always delete_block after waiting.")
Reported-by: Slawomir Pryczek <slawek1211@gmail.com>
Cc: Neil Brown <neilb@suse.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -298,6 +298,14 @@ remove_blocked_locks(struct nfs4_lockown
 	}
 }
 
+static void
+nfsd4_cb_notify_lock_prepare(struct nfsd4_callback *cb)
+{
+	struct nfsd4_blocked_lock	*nbl = container_of(cb,
+						struct nfsd4_blocked_lock, nbl_cb);
+	locks_delete_block(&nbl->nbl_lock);
+}
+
 static int
 nfsd4_cb_notify_lock_done(struct nfsd4_callback *cb, struct rpc_task *task)
 {
@@ -325,6 +333,7 @@ nfsd4_cb_notify_lock_release(struct nfsd
 }
 
 static const struct nfsd4_callback_ops nfsd4_cb_notify_lock_ops = {
+	.prepare	= nfsd4_cb_notify_lock_prepare,
 	.done		= nfsd4_cb_notify_lock_done,
 	.release	= nfsd4_cb_notify_lock_release,
 };


