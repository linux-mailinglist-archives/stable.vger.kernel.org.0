Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA195B7344
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbiIMPFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbiIMPE0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:04:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A602474DE5;
        Tue, 13 Sep 2022 07:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F00E4614C1;
        Tue, 13 Sep 2022 14:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED75C433D6;
        Tue, 13 Sep 2022 14:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079341;
        bh=civBiXs5blTaL9ds5FtStWNScm/e7AOBfl2bHSnVqY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m12UXoMzYsPVwERMHUGjemBAzb4JFxUKIuJWaS6bcm4lq/33ax+6i0dnGRIAH3A86
         lyvJElEe4vT/5BFNkwrtbMs6+FjMYkkcXIgyEgwGLqU4CMiJTzxXN6GEzhEkFfxwLl
         +iBx0tryxaI0iccbjPf2d67GEpO+D4EWg7ElC+PI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffrey E Altman <jaltman@auristor.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/108] afs: Use the operation issue time instead of the reply time for callbacks
Date:   Tue, 13 Sep 2022 16:07:08 +0200
Message-Id: <20220913140357.790574282@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 7903192c4b4a82d792cb0dc5e2779a2efe60d45b ]

rxrpc and kafs between them try to use the receive timestamp on the first
data packet (ie. the one with sequence number 1) as a base from which to
calculate the time at which callback promise and lock expiration occurs.

However, we don't know how long it took for the server to send us the reply
from it having completed the basic part of the operation - it might then,
for instance, have to send a bunch of a callback breaks, depending on the
particular operation.

Fix this by using the time at which the operation is issued on the client
as a base instead.  That should never be longer than the server's idea of
the expiry time.

Fixes: 781070551c26 ("afs: Fix calculation of callback expiry time")
Fixes: 2070a3e44962 ("rxrpc: Allow the reply time to be obtained on a client call")
Suggested-by: Jeffrey E Altman <jaltman@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/flock.c     | 2 +-
 fs/afs/fsclient.c  | 2 +-
 fs/afs/internal.h  | 3 +--
 fs/afs/rxrpc.c     | 7 +------
 fs/afs/yfsclient.c | 3 +--
 5 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/afs/flock.c b/fs/afs/flock.c
index d5e5a6ddc8478..0fa05998a24d2 100644
--- a/fs/afs/flock.c
+++ b/fs/afs/flock.c
@@ -75,7 +75,7 @@ void afs_lock_op_done(struct afs_call *call)
 	if (call->error == 0) {
 		spin_lock(&vnode->lock);
 		trace_afs_flock_ev(vnode, NULL, afs_flock_timestamp, 0);
-		vnode->locked_at = call->reply_time;
+		vnode->locked_at = call->issue_time;
 		afs_schedule_lock_extension(vnode);
 		spin_unlock(&vnode->lock);
 	}
diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index 5c2729fc07e52..254580b1dc74c 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -136,7 +136,7 @@ static void xdr_decode_AFSFetchStatus(const __be32 **_bp,
 
 static time64_t xdr_decode_expiry(struct afs_call *call, u32 expiry)
 {
-	return ktime_divns(call->reply_time, NSEC_PER_SEC) + expiry;
+	return ktime_divns(call->issue_time, NSEC_PER_SEC) + expiry;
 }
 
 static void xdr_decode_AFSCallBack(const __be32 **_bp,
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index c3ad582f9fd0e..8d6582713fe72 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -159,7 +159,6 @@ struct afs_call {
 	bool			need_attention;	/* T if RxRPC poked us */
 	bool			async;		/* T if asynchronous */
 	bool			upgrade;	/* T to request service upgrade */
-	bool			have_reply_time; /* T if have got reply_time */
 	bool			intr;		/* T if interruptible */
 	bool			unmarshalling_error; /* T if an unmarshalling error occurred */
 	u16			service_id;	/* Actual service ID (after upgrade) */
@@ -173,7 +172,7 @@ struct afs_call {
 		} __attribute__((packed));
 		__be64		tmp64;
 	};
-	ktime_t			reply_time;	/* Time of first reply packet */
+	ktime_t			issue_time;	/* Time of issue of operation */
 };
 
 struct afs_call_type {
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 6adab30a83993..49fcce6529a60 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -428,6 +428,7 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
 	if (call->max_lifespan)
 		rxrpc_kernel_set_max_life(call->net->socket, rxcall,
 					  call->max_lifespan);
+	call->issue_time = ktime_get_real();
 
 	/* send the request */
 	iov[0].iov_base	= call->request;
@@ -532,12 +533,6 @@ static void afs_deliver_to_call(struct afs_call *call)
 			return;
 		}
 
-		if (!call->have_reply_time &&
-		    rxrpc_kernel_get_reply_time(call->net->socket,
-						call->rxcall,
-						&call->reply_time))
-			call->have_reply_time = true;
-
 		ret = call->type->deliver(call);
 		state = READ_ONCE(call->state);
 		if (ret == 0 && call->unmarshalling_error)
diff --git a/fs/afs/yfsclient.c b/fs/afs/yfsclient.c
index 3b19b009452a2..fa85b359f325b 100644
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -241,8 +241,7 @@ static void xdr_decode_YFSCallBack(const __be32 **_bp,
 	struct afs_callback *cb = &scb->callback;
 	ktime_t cb_expiry;
 
-	cb_expiry = call->reply_time;
-	cb_expiry = ktime_add(cb_expiry, xdr_to_u64(x->expiration_time) * 100);
+	cb_expiry = ktime_add(call->issue_time, xdr_to_u64(x->expiration_time) * 100);
 	cb->expires_at	= ktime_divns(cb_expiry, NSEC_PER_SEC);
 	scb->have_cb	= true;
 	*_bp += xdr_size(x);
-- 
2.35.1



