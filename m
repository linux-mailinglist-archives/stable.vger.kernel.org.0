Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E07F5B7007
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbiIMOUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbiIMOTm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:19:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27268DEDF;
        Tue, 13 Sep 2022 07:14:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AC4F614C1;
        Tue, 13 Sep 2022 14:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4588EC43140;
        Tue, 13 Sep 2022 14:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078366;
        bh=UerA8/O15XJcRsS8zRHWNxG9/WoeSjEnoJAUSy+EY9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vquDGNGkOMPH59lz3rijScRbwGFn0NOForv1bGyJ0K3yStCml6i0+DALCsgEiX3Cr
         FlNeERmodV36yAzhjCqwCoHD9Hzbq4FPmrbBmSXGDA5RXgzIVCcKGicLM+eaK/jcOT
         J1Ns+3l2wzxNLYMC34+1KtHDsqN1Xpo3X3QNaO2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffrey E Altman <jaltman@auristor.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 112/192] afs: Use the operation issue time instead of the reply time for callbacks
Date:   Tue, 13 Sep 2022 16:03:38 +0200
Message-Id: <20220913140415.554897747@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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
index c4210a3964d8b..bbcc5afd15760 100644
--- a/fs/afs/flock.c
+++ b/fs/afs/flock.c
@@ -76,7 +76,7 @@ void afs_lock_op_done(struct afs_call *call)
 	if (call->error == 0) {
 		spin_lock(&vnode->lock);
 		trace_afs_flock_ev(vnode, NULL, afs_flock_timestamp, 0);
-		vnode->locked_at = call->reply_time;
+		vnode->locked_at = call->issue_time;
 		afs_schedule_lock_extension(vnode);
 		spin_unlock(&vnode->lock);
 	}
diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index 4943413d9c5f7..7d37f63ef0f09 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -131,7 +131,7 @@ static void xdr_decode_AFSFetchStatus(const __be32 **_bp,
 
 static time64_t xdr_decode_expiry(struct afs_call *call, u32 expiry)
 {
-	return ktime_divns(call->reply_time, NSEC_PER_SEC) + expiry;
+	return ktime_divns(call->issue_time, NSEC_PER_SEC) + expiry;
 }
 
 static void xdr_decode_AFSCallBack(const __be32 **_bp,
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index a6f25d9e75b52..28bdd0387e5ea 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -137,7 +137,6 @@ struct afs_call {
 	bool			need_attention;	/* T if RxRPC poked us */
 	bool			async;		/* T if asynchronous */
 	bool			upgrade;	/* T to request service upgrade */
-	bool			have_reply_time; /* T if have got reply_time */
 	bool			intr;		/* T if interruptible */
 	bool			unmarshalling_error; /* T if an unmarshalling error occurred */
 	u16			service_id;	/* Actual service ID (after upgrade) */
@@ -151,7 +150,7 @@ struct afs_call {
 		} __attribute__((packed));
 		__be64		tmp64;
 	};
-	ktime_t			reply_time;	/* Time of first reply packet */
+	ktime_t			issue_time;	/* Time of issue of operation */
 };
 
 struct afs_call_type {
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index a5434f3e57c68..e3de7fea36435 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -347,6 +347,7 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
 	if (call->max_lifespan)
 		rxrpc_kernel_set_max_life(call->net->socket, rxcall,
 					  call->max_lifespan);
+	call->issue_time = ktime_get_real();
 
 	/* send the request */
 	iov[0].iov_base	= call->request;
@@ -497,12 +498,6 @@ static void afs_deliver_to_call(struct afs_call *call)
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
index fdc7d675b4b0c..11571cca86c19 100644
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -232,8 +232,7 @@ static void xdr_decode_YFSCallBack(const __be32 **_bp,
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



