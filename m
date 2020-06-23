Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DCC2063C8
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391788AbgFWVLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391323AbgFWUce (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:32:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7572206C3;
        Tue, 23 Jun 2020 20:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944353;
        bh=LXRUZhOPGCTcX1pmROf5+W34OKhgdQK427m+aoFZ5pA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8a+ZNmshZeXkXCQxS+CL9ZnBZVP+Fwea4PhUUohCXZ4LqfGXSK/5MUeRDaQ/yQHc
         TpOAwmVlCRwMcxHgNPxZtGdjrHpFQdDq/V2f/WUOj3u+NmPZwL+OQwrHXpXgAd+1e9
         7BSwO0cNHPnNdhciUDE7J5fWfdWWTvnsl1BO85qA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 272/314] afs: Set error flag rather than return error from file status decode
Date:   Tue, 23 Jun 2020 21:57:47 +0200
Message-Id: <20200623195351.960713472@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 38355eec6a7d2b8f2f313f9174736dc877744e59 ]

Set a flag in the call struct to indicate an unmarshalling error rather
than return and handle an error from the decoding of file statuses.  This
flag is checked on a successful return from the delivery function.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/fsclient.c  | 88 +++++++++++++---------------------------------
 fs/afs/internal.h  |  1 +
 fs/afs/rxrpc.c     |  4 +++
 fs/afs/yfsclient.c | 85 +++++++++++++-------------------------------
 4 files changed, 55 insertions(+), 123 deletions(-)

diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index 0a4fed9e706b7..5c2729fc07e52 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -56,16 +56,15 @@ static void xdr_dump_bad(const __be32 *bp)
 /*
  * decode an AFSFetchStatus block
  */
-static int xdr_decode_AFSFetchStatus(const __be32 **_bp,
-				     struct afs_call *call,
-				     struct afs_status_cb *scb)
+static void xdr_decode_AFSFetchStatus(const __be32 **_bp,
+				      struct afs_call *call,
+				      struct afs_status_cb *scb)
 {
 	const struct afs_xdr_AFSFetchStatus *xdr = (const void *)*_bp;
 	struct afs_file_status *status = &scb->status;
 	bool inline_error = (call->operation_ID == afs_FS_InlineBulkStatus);
 	u64 data_version, size;
 	u32 type, abort_code;
-	int ret;
 
 	abort_code = ntohl(xdr->abort_code);
 
@@ -79,7 +78,7 @@ static int xdr_decode_AFSFetchStatus(const __be32 **_bp,
 			 */
 			status->abort_code = abort_code;
 			scb->have_error = true;
-			goto good;
+			goto advance;
 		}
 
 		pr_warn("Unknown AFSFetchStatus version %u\n", ntohl(xdr->if_version));
@@ -89,7 +88,7 @@ static int xdr_decode_AFSFetchStatus(const __be32 **_bp,
 	if (abort_code != 0 && inline_error) {
 		status->abort_code = abort_code;
 		scb->have_error = true;
-		goto good;
+		goto advance;
 	}
 
 	type = ntohl(xdr->type);
@@ -125,15 +124,13 @@ static int xdr_decode_AFSFetchStatus(const __be32 **_bp,
 	data_version |= (u64)ntohl(xdr->data_version_hi) << 32;
 	status->data_version = data_version;
 	scb->have_status = true;
-good:
-	ret = 0;
 advance:
 	*_bp = (const void *)*_bp + sizeof(*xdr);
-	return ret;
+	return;
 
 bad:
 	xdr_dump_bad(*_bp);
-	ret = afs_protocol_error(call, -EBADMSG, afs_eproto_bad_status);
+	afs_protocol_error(call, -EBADMSG, afs_eproto_bad_status);
 	goto advance;
 }
 
@@ -254,9 +251,7 @@ static int afs_deliver_fs_fetch_status_vnode(struct afs_call *call)
 
 	/* unmarshall the reply once we've received all of it */
 	bp = call->buffer;
-	ret = xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
-	if (ret < 0)
-		return ret;
+	xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
 	xdr_decode_AFSCallBack(&bp, call, call->out_scb);
 	xdr_decode_AFSVolSync(&bp, call->out_volsync);
 
@@ -419,9 +414,7 @@ static int afs_deliver_fs_fetch_data(struct afs_call *call)
 			return ret;
 
 		bp = call->buffer;
-		ret = xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
-		if (ret < 0)
-			return ret;
+		xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
 		xdr_decode_AFSCallBack(&bp, call, call->out_scb);
 		xdr_decode_AFSVolSync(&bp, call->out_volsync);
 
@@ -579,12 +572,8 @@ static int afs_deliver_fs_create_vnode(struct afs_call *call)
 	/* unmarshall the reply once we've received all of it */
 	bp = call->buffer;
 	xdr_decode_AFSFid(&bp, call->out_fid);
-	ret = xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
-	if (ret < 0)
-		return ret;
-	ret = xdr_decode_AFSFetchStatus(&bp, call, call->out_dir_scb);
-	if (ret < 0)
-		return ret;
+	xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
+	xdr_decode_AFSFetchStatus(&bp, call, call->out_dir_scb);
 	xdr_decode_AFSCallBack(&bp, call, call->out_scb);
 	xdr_decode_AFSVolSync(&bp, call->out_volsync);
 
@@ -693,9 +682,7 @@ static int afs_deliver_fs_dir_status_and_vol(struct afs_call *call)
 
 	/* unmarshall the reply once we've received all of it */
 	bp = call->buffer;
-	ret = xdr_decode_AFSFetchStatus(&bp, call, call->out_dir_scb);
-	if (ret < 0)
-		return ret;
+	xdr_decode_AFSFetchStatus(&bp, call, call->out_dir_scb);
 	xdr_decode_AFSVolSync(&bp, call->out_volsync);
 
 	_leave(" = 0 [done]");
@@ -786,12 +773,8 @@ static int afs_deliver_fs_link(struct afs_call *call)
 
 	/* unmarshall the reply once we've received all of it */
 	bp = call->buffer;
-	ret = xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
-	if (ret < 0)
-		return ret;
-	ret = xdr_decode_AFSFetchStatus(&bp, call, call->out_dir_scb);
-	if (ret < 0)
-		return ret;
+	xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
+	xdr_decode_AFSFetchStatus(&bp, call, call->out_dir_scb);
 	xdr_decode_AFSVolSync(&bp, call->out_volsync);
 
 	_leave(" = 0 [done]");
@@ -880,12 +863,8 @@ static int afs_deliver_fs_symlink(struct afs_call *call)
 	/* unmarshall the reply once we've received all of it */
 	bp = call->buffer;
 	xdr_decode_AFSFid(&bp, call->out_fid);
-	ret = xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
-	if (ret < 0)
-		return ret;
-	ret = xdr_decode_AFSFetchStatus(&bp, call, call->out_dir_scb);
-	if (ret < 0)
-		return ret;
+	xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
+	xdr_decode_AFSFetchStatus(&bp, call, call->out_dir_scb);
 	xdr_decode_AFSVolSync(&bp, call->out_volsync);
 
 	_leave(" = 0 [done]");
@@ -988,16 +967,12 @@ static int afs_deliver_fs_rename(struct afs_call *call)
 	if (ret < 0)
 		return ret;
 
+	bp = call->buffer;
 	/* If the two dirs are the same, we have two copies of the same status
 	 * report, so we just decode it twice.
 	 */
-	bp = call->buffer;
-	ret = xdr_decode_AFSFetchStatus(&bp, call, call->out_dir_scb);
-	if (ret < 0)
-		return ret;
-	ret = xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
-	if (ret < 0)
-		return ret;
+	xdr_decode_AFSFetchStatus(&bp, call, call->out_dir_scb);
+	xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
 	xdr_decode_AFSVolSync(&bp, call->out_volsync);
 
 	_leave(" = 0 [done]");
@@ -1105,9 +1080,7 @@ static int afs_deliver_fs_store_data(struct afs_call *call)
 
 	/* unmarshall the reply once we've received all of it */
 	bp = call->buffer;
-	ret = xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
-	if (ret < 0)
-		return ret;
+	xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
 	xdr_decode_AFSVolSync(&bp, call->out_volsync);
 
 	_leave(" = 0 [done]");
@@ -1285,9 +1258,7 @@ static int afs_deliver_fs_store_status(struct afs_call *call)
 
 	/* unmarshall the reply once we've received all of it */
 	bp = call->buffer;
-	ret = xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
-	if (ret < 0)
-		return ret;
+	xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
 	xdr_decode_AFSVolSync(&bp, call->out_volsync);
 
 	_leave(" = 0 [done]");
@@ -1956,9 +1927,7 @@ static int afs_deliver_fs_fetch_status(struct afs_call *call)
 
 	/* unmarshall the reply once we've received all of it */
 	bp = call->buffer;
-	ret = xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
-	if (ret < 0)
-		return ret;
+	xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
 	xdr_decode_AFSCallBack(&bp, call, call->out_scb);
 	xdr_decode_AFSVolSync(&bp, call->out_volsync);
 
@@ -2064,10 +2033,7 @@ static int afs_deliver_fs_inline_bulk_status(struct afs_call *call)
 
 		bp = call->buffer;
 		scb = &call->out_scb[call->count];
-		ret = xdr_decode_AFSFetchStatus(&bp, call, scb);
-		if (ret < 0)
-			return ret;
-
+		xdr_decode_AFSFetchStatus(&bp, call, scb);
 		call->count++;
 		if (call->count < call->count2)
 			goto more_counts;
@@ -2245,9 +2211,7 @@ static int afs_deliver_fs_fetch_acl(struct afs_call *call)
 			return ret;
 
 		bp = call->buffer;
-		ret = xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
-		if (ret < 0)
-			return ret;
+		xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
 		xdr_decode_AFSVolSync(&bp, call->out_volsync);
 
 		call->unmarshall++;
@@ -2328,9 +2292,7 @@ static int afs_deliver_fs_file_status_and_vol(struct afs_call *call)
 		return ret;
 
 	bp = call->buffer;
-	ret = xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
-	if (ret < 0)
-		return ret;
+	xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
 	xdr_decode_AFSVolSync(&bp, call->out_volsync);
 
 	_leave(" = 0 [done]");
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 485cc3b2aaa8a..555ad7c9afcb6 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -161,6 +161,7 @@ struct afs_call {
 	bool			upgrade;	/* T to request service upgrade */
 	bool			have_reply_time; /* T if have got reply_time */
 	bool			intr;		/* T if interruptible */
+	bool			unmarshalling_error; /* T if an unmarshalling error occurred */
 	u16			service_id;	/* Actual service ID (after upgrade) */
 	unsigned int		debug_id;	/* Trace ID */
 	u32			operation_ID;	/* operation ID for an incoming call */
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 52aa90fb4fbd9..6adab30a83993 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -540,6 +540,8 @@ static void afs_deliver_to_call(struct afs_call *call)
 
 		ret = call->type->deliver(call);
 		state = READ_ONCE(call->state);
+		if (ret == 0 && call->unmarshalling_error)
+			ret = -EBADMSG;
 		switch (ret) {
 		case 0:
 			afs_queue_call_work(call);
@@ -963,5 +965,7 @@ noinline int afs_protocol_error(struct afs_call *call, int error,
 				enum afs_eproto_cause cause)
 {
 	trace_afs_protocol_error(call, error, cause);
+	if (call)
+		call->unmarshalling_error = true;
 	return error;
 }
diff --git a/fs/afs/yfsclient.c b/fs/afs/yfsclient.c
index 8af7f093305d8..d21cf61d86b9f 100644
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -179,21 +179,20 @@ static void xdr_dump_bad(const __be32 *bp)
 /*
  * Decode a YFSFetchStatus block
  */
-static int xdr_decode_YFSFetchStatus(const __be32 **_bp,
-				     struct afs_call *call,
-				     struct afs_status_cb *scb)
+static void xdr_decode_YFSFetchStatus(const __be32 **_bp,
+				      struct afs_call *call,
+				      struct afs_status_cb *scb)
 {
 	const struct yfs_xdr_YFSFetchStatus *xdr = (const void *)*_bp;
 	struct afs_file_status *status = &scb->status;
 	u32 type;
-	int ret;
 
 	status->abort_code = ntohl(xdr->abort_code);
 	if (status->abort_code != 0) {
 		if (status->abort_code == VNOVNODE)
 			status->nlink = 0;
 		scb->have_error = true;
-		goto good;
+		goto advance;
 	}
 
 	type = ntohl(xdr->type);
@@ -221,15 +220,13 @@ static int xdr_decode_YFSFetchStatus(const __be32 **_bp,
 	status->size		= xdr_to_u64(xdr->size);
 	status->data_version	= xdr_to_u64(xdr->data_version);
 	scb->have_status	= true;
-good:
-	ret = 0;
 advance:
 	*_bp += xdr_size(xdr);
-	return ret;
+	return;
 
 bad:
 	xdr_dump_bad(*_bp);
-	ret = afs_protocol_error(call, -EBADMSG, afs_eproto_bad_status);
+	afs_protocol_error(call, -EBADMSG, afs_eproto_bad_status);
 	goto advance;
 }
 
@@ -348,9 +345,7 @@ static int yfs_deliver_fs_status_cb_and_volsync(struct afs_call *call)
 
 	/* unmarshall the reply once we've received all of it */
 	bp = call->buffer;
-	ret = xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
-	if (ret < 0)
-		return ret;
+	xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
 	xdr_decode_YFSCallBack(&bp, call, call->out_scb);
 	xdr_decode_YFSVolSync(&bp, call->out_volsync);
 
@@ -372,9 +367,7 @@ static int yfs_deliver_status_and_volsync(struct afs_call *call)
 		return ret;
 
 	bp = call->buffer;
-	ret = xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
-	if (ret < 0)
-		return ret;
+	xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
 	xdr_decode_YFSVolSync(&bp, call->out_volsync);
 
 	_leave(" = 0 [done]");
@@ -534,9 +527,7 @@ static int yfs_deliver_fs_fetch_data64(struct afs_call *call)
 			return ret;
 
 		bp = call->buffer;
-		ret = xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
-		if (ret < 0)
-			return ret;
+		xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
 		xdr_decode_YFSCallBack(&bp, call, call->out_scb);
 		xdr_decode_YFSVolSync(&bp, call->out_volsync);
 
@@ -645,12 +636,8 @@ static int yfs_deliver_fs_create_vnode(struct afs_call *call)
 	/* unmarshall the reply once we've received all of it */
 	bp = call->buffer;
 	xdr_decode_YFSFid(&bp, call->out_fid);
-	ret = xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
-	if (ret < 0)
-		return ret;
-	ret = xdr_decode_YFSFetchStatus(&bp, call, call->out_dir_scb);
-	if (ret < 0)
-		return ret;
+	xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
+	xdr_decode_YFSFetchStatus(&bp, call, call->out_dir_scb);
 	xdr_decode_YFSCallBack(&bp, call, call->out_scb);
 	xdr_decode_YFSVolSync(&bp, call->out_volsync);
 
@@ -803,14 +790,9 @@ static int yfs_deliver_fs_remove_file2(struct afs_call *call)
 		return ret;
 
 	bp = call->buffer;
-	ret = xdr_decode_YFSFetchStatus(&bp, call, call->out_dir_scb);
-	if (ret < 0)
-		return ret;
-
+	xdr_decode_YFSFetchStatus(&bp, call, call->out_dir_scb);
 	xdr_decode_YFSFid(&bp, &fid);
-	ret = xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
-	if (ret < 0)
-		return ret;
+	xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
 	/* Was deleted if vnode->status.abort_code == VNOVNODE. */
 
 	xdr_decode_YFSVolSync(&bp, call->out_volsync);
@@ -890,10 +872,7 @@ static int yfs_deliver_fs_remove(struct afs_call *call)
 		return ret;
 
 	bp = call->buffer;
-	ret = xdr_decode_YFSFetchStatus(&bp, call, call->out_dir_scb);
-	if (ret < 0)
-		return ret;
-
+	xdr_decode_YFSFetchStatus(&bp, call, call->out_dir_scb);
 	xdr_decode_YFSVolSync(&bp, call->out_volsync);
 	return 0;
 }
@@ -975,12 +954,8 @@ static int yfs_deliver_fs_link(struct afs_call *call)
 		return ret;
 
 	bp = call->buffer;
-	ret = xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
-	if (ret < 0)
-		return ret;
-	ret = xdr_decode_YFSFetchStatus(&bp, call, call->out_dir_scb);
-	if (ret < 0)
-		return ret;
+	xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
+	xdr_decode_YFSFetchStatus(&bp, call, call->out_dir_scb);
 	xdr_decode_YFSVolSync(&bp, call->out_volsync);
 	_leave(" = 0 [done]");
 	return 0;
@@ -1062,12 +1037,8 @@ static int yfs_deliver_fs_symlink(struct afs_call *call)
 	/* unmarshall the reply once we've received all of it */
 	bp = call->buffer;
 	xdr_decode_YFSFid(&bp, call->out_fid);
-	ret = xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
-	if (ret < 0)
-		return ret;
-	ret = xdr_decode_YFSFetchStatus(&bp, call, call->out_dir_scb);
-	if (ret < 0)
-		return ret;
+	xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
+	xdr_decode_YFSFetchStatus(&bp, call, call->out_dir_scb);
 	xdr_decode_YFSVolSync(&bp, call->out_volsync);
 
 	_leave(" = 0 [done]");
@@ -1155,13 +1126,11 @@ static int yfs_deliver_fs_rename(struct afs_call *call)
 		return ret;
 
 	bp = call->buffer;
-	ret = xdr_decode_YFSFetchStatus(&bp, call, call->out_dir_scb);
-	if (ret < 0)
-		return ret;
-	ret = xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
-	if (ret < 0)
-		return ret;
-
+	/* If the two dirs are the same, we have two copies of the same status
+	 * report, so we just decode it twice.
+	 */
+	xdr_decode_YFSFetchStatus(&bp, call, call->out_dir_scb);
+	xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
 	xdr_decode_YFSVolSync(&bp, call->out_volsync);
 	_leave(" = 0 [done]");
 	return 0;
@@ -1846,9 +1815,7 @@ static int yfs_deliver_fs_inline_bulk_status(struct afs_call *call)
 
 		bp = call->buffer;
 		scb = &call->out_scb[call->count];
-		ret = xdr_decode_YFSFetchStatus(&bp, call, scb);
-		if (ret < 0)
-			return ret;
+		xdr_decode_YFSFetchStatus(&bp, call, scb);
 
 		call->count++;
 		if (call->count < call->count2)
@@ -2068,9 +2035,7 @@ static int yfs_deliver_fs_fetch_opaque_acl(struct afs_call *call)
 		bp = call->buffer;
 		yacl->inherit_flag = ntohl(*bp++);
 		yacl->num_cleaned = ntohl(*bp++);
-		ret = xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
-		if (ret < 0)
-			return ret;
+		xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
 		xdr_decode_YFSVolSync(&bp, call->out_volsync);
 
 		call->unmarshall++;
-- 
2.25.1



