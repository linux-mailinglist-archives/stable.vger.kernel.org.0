Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6EA3DD795
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbhHBNq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233981AbhHBNqW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:46:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EBC160555;
        Mon,  2 Aug 2021 13:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627911972;
        bh=onN+AG9ioMbM04VJN/xrnWqij2LxuOIGiSndtJGtRuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mXqrwsWs2ukx0+zfBYx3tm/qTLK5SCL26U93gu1kQvCIZmBpYeUKajHCJIdkDz6X2
         RwiXRDvlFoqc33X9tOfL22BZMxL4YrohM6PU7VN0Oh1CR0gl6NrLVs/sKa+ZqQMpeL
         bu6eSEF8m44PN/z4LEXzaosPT3J4GumvrCbk2zOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 02/26] af_unix: fix garbage collect vs MSG_PEEK
Date:   Mon,  2 Aug 2021 15:44:12 +0200
Message-Id: <20210802134332.110702961@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134332.033552261@linuxfoundation.org>
References: <20210802134332.033552261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit cbcf01128d0a92e131bd09f1688fe032480b65ca upstream.

unix_gc() assumes that candidate sockets can never gain an external
reference (i.e.  be installed into an fd) while the unix_gc_lock is
held.  Except for MSG_PEEK this is guaranteed by modifying inflight
count under the unix_gc_lock.

MSG_PEEK does not touch any variable protected by unix_gc_lock (file
count is not), yet it needs to be serialized with garbage collection.
Do this by locking/unlocking unix_gc_lock:

 1) increment file count

 2) lock/unlock barrier to make sure incremented file count is visible
    to garbage collection

 3) install file into fd

This is a lock barrier (unlike smp_mb()) that ensures that garbage
collection is run completely before or completely after the barrier.

Cc: <stable@vger.kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/af_unix.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1506,6 +1506,53 @@ out:
 	return err;
 }
 
+static void unix_peek_fds(struct scm_cookie *scm, struct sk_buff *skb)
+{
+	scm->fp = scm_fp_dup(UNIXCB(skb).fp);
+
+	/*
+	 * Garbage collection of unix sockets starts by selecting a set of
+	 * candidate sockets which have reference only from being in flight
+	 * (total_refs == inflight_refs).  This condition is checked once during
+	 * the candidate collection phase, and candidates are marked as such, so
+	 * that non-candidates can later be ignored.  While inflight_refs is
+	 * protected by unix_gc_lock, total_refs (file count) is not, hence this
+	 * is an instantaneous decision.
+	 *
+	 * Once a candidate, however, the socket must not be reinstalled into a
+	 * file descriptor while the garbage collection is in progress.
+	 *
+	 * If the above conditions are met, then the directed graph of
+	 * candidates (*) does not change while unix_gc_lock is held.
+	 *
+	 * Any operations that changes the file count through file descriptors
+	 * (dup, close, sendmsg) does not change the graph since candidates are
+	 * not installed in fds.
+	 *
+	 * Dequeing a candidate via recvmsg would install it into an fd, but
+	 * that takes unix_gc_lock to decrement the inflight count, so it's
+	 * serialized with garbage collection.
+	 *
+	 * MSG_PEEK is special in that it does not change the inflight count,
+	 * yet does install the socket into an fd.  The following lock/unlock
+	 * pair is to ensure serialization with garbage collection.  It must be
+	 * done between incrementing the file count and installing the file into
+	 * an fd.
+	 *
+	 * If garbage collection starts after the barrier provided by the
+	 * lock/unlock, then it will see the elevated refcount and not mark this
+	 * as a candidate.  If a garbage collection is already in progress
+	 * before the file count was incremented, then the lock/unlock pair will
+	 * ensure that garbage collection is finished before progressing to
+	 * installing the fd.
+	 *
+	 * (*) A -> B where B is on the queue of A or B is on the queue of C
+	 * which is on the queue of listening socket A.
+	 */
+	spin_lock(&unix_gc_lock);
+	spin_unlock(&unix_gc_lock);
+}
+
 static int unix_scm_to_skb(struct scm_cookie *scm, struct sk_buff *skb, bool send_fds)
 {
 	int err = 0;
@@ -2131,7 +2178,7 @@ static int unix_dgram_recvmsg(struct soc
 		sk_peek_offset_fwd(sk, size);
 
 		if (UNIXCB(skb).fp)
-			scm.fp = scm_fp_dup(UNIXCB(skb).fp);
+			unix_peek_fds(&scm, skb);
 	}
 	err = (flags & MSG_TRUNC) ? skb->len - skip : size;
 
@@ -2376,7 +2423,7 @@ unlock:
 			/* It is questionable, see note in unix_dgram_recvmsg.
 			 */
 			if (UNIXCB(skb).fp)
-				scm.fp = scm_fp_dup(UNIXCB(skb).fp);
+				unix_peek_fds(&scm, skb);
 
 			sk_peek_offset_fwd(sk, chunk);
 


