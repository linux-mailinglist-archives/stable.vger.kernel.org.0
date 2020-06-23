Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649FA205DE2
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389571AbgFWURi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389570AbgFWURf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:17:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8442B20E65;
        Tue, 23 Jun 2020 20:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943455;
        bh=k6D8W2NuWeRisIkh7RP33hz5GirvQhO2LIuDCAaQcWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLJ6zkMpckNIekd0Ny7PUouELOtulQL5PGK+X2D0gs0VpZcH+p9+L01rIIF3BBWeO
         XDtHeJPuDBbPxYRiO285OVHYFbvXgSiKqKK/0AwYHCT4isBOj0xlX2QIHpdbf+WaY/
         qaVYcKDfjbdQVNXM7/4uAgFA2XO1Hnsvs7Ae/u74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 397/477] afs: Remove the error argument from afs_protocol_error()
Date:   Tue, 23 Jun 2020 21:56:34 +0200
Message-Id: <20200623195426.295116575@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 7126ead910aa9fcc9e16e9e7a8c9179658261f1d ]

Remove the error argument from afs_protocol_error() as it's always
-EBADMSG.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cmservice.c         |  9 +++------
 fs/afs/fsclient.c          | 17 ++++++-----------
 fs/afs/inode.c             |  4 ++--
 fs/afs/internal.h          |  2 +-
 fs/afs/rxrpc.c             |  6 +++---
 fs/afs/vlclient.c          | 34 ++++++++++++++--------------------
 fs/afs/yfsclient.c         | 17 ++++++-----------
 include/trace/events/afs.h | 10 ++++------
 8 files changed, 39 insertions(+), 60 deletions(-)

diff --git a/fs/afs/cmservice.c b/fs/afs/cmservice.c
index 380ad5ace7cfd..3a9b8b1f5f2b0 100644
--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -305,8 +305,7 @@ static int afs_deliver_cb_callback(struct afs_call *call)
 		call->count = ntohl(call->tmp);
 		_debug("FID count: %u", call->count);
 		if (call->count > AFSCBMAX)
-			return afs_protocol_error(call, -EBADMSG,
-						  afs_eproto_cb_fid_count);
+			return afs_protocol_error(call, afs_eproto_cb_fid_count);
 
 		call->buffer = kmalloc(array3_size(call->count, 3, 4),
 				       GFP_KERNEL);
@@ -351,8 +350,7 @@ static int afs_deliver_cb_callback(struct afs_call *call)
 		call->count2 = ntohl(call->tmp);
 		_debug("CB count: %u", call->count2);
 		if (call->count2 != call->count && call->count2 != 0)
-			return afs_protocol_error(call, -EBADMSG,
-						  afs_eproto_cb_count);
+			return afs_protocol_error(call, afs_eproto_cb_count);
 		call->iter = &call->def_iter;
 		iov_iter_discard(&call->def_iter, READ, call->count2 * 3 * 4);
 		call->unmarshall++;
@@ -672,8 +670,7 @@ static int afs_deliver_yfs_cb_callback(struct afs_call *call)
 		call->count = ntohl(call->tmp);
 		_debug("FID count: %u", call->count);
 		if (call->count > YFSCBMAX)
-			return afs_protocol_error(call, -EBADMSG,
-						  afs_eproto_cb_fid_count);
+			return afs_protocol_error(call, afs_eproto_cb_fid_count);
 
 		size = array_size(call->count, sizeof(struct yfs_xdr_YFSFid));
 		call->buffer = kmalloc(size, GFP_KERNEL);
diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index 585b678a6f705..7bca0c13d0c46 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -130,7 +130,7 @@ advance:
 
 bad:
 	xdr_dump_bad(*_bp);
-	afs_protocol_error(call, -EBADMSG, afs_eproto_bad_status);
+	afs_protocol_error(call, afs_eproto_bad_status);
 	goto advance;
 }
 
@@ -1470,8 +1470,7 @@ static int afs_deliver_fs_get_volume_status(struct afs_call *call)
 		call->count = ntohl(call->tmp);
 		_debug("volname length: %u", call->count);
 		if (call->count >= AFSNAMEMAX)
-			return afs_protocol_error(call, -EBADMSG,
-						  afs_eproto_volname_len);
+			return afs_protocol_error(call, afs_eproto_volname_len);
 		size = (call->count + 3) & ~3; /* It's padded */
 		afs_extract_to_buf(call, size);
 		call->unmarshall++;
@@ -1500,8 +1499,7 @@ static int afs_deliver_fs_get_volume_status(struct afs_call *call)
 		call->count = ntohl(call->tmp);
 		_debug("offline msg length: %u", call->count);
 		if (call->count >= AFSNAMEMAX)
-			return afs_protocol_error(call, -EBADMSG,
-						  afs_eproto_offline_msg_len);
+			return afs_protocol_error(call, afs_eproto_offline_msg_len);
 		size = (call->count + 3) & ~3; /* It's padded */
 		afs_extract_to_buf(call, size);
 		call->unmarshall++;
@@ -1531,8 +1529,7 @@ static int afs_deliver_fs_get_volume_status(struct afs_call *call)
 		call->count = ntohl(call->tmp);
 		_debug("motd length: %u", call->count);
 		if (call->count >= AFSNAMEMAX)
-			return afs_protocol_error(call, -EBADMSG,
-						  afs_eproto_motd_len);
+			return afs_protocol_error(call, afs_eproto_motd_len);
 		size = (call->count + 3) & ~3; /* It's padded */
 		afs_extract_to_buf(call, size);
 		call->unmarshall++;
@@ -2014,8 +2011,7 @@ static int afs_deliver_fs_inline_bulk_status(struct afs_call *call)
 		tmp = ntohl(call->tmp);
 		_debug("status count: %u/%u", tmp, call->count2);
 		if (tmp != call->count2)
-			return afs_protocol_error(call, -EBADMSG,
-						  afs_eproto_ibulkst_count);
+			return afs_protocol_error(call, afs_eproto_ibulkst_count);
 
 		call->count = 0;
 		call->unmarshall++;
@@ -2051,8 +2047,7 @@ static int afs_deliver_fs_inline_bulk_status(struct afs_call *call)
 		tmp = ntohl(call->tmp);
 		_debug("CB count: %u", tmp);
 		if (tmp != call->count2)
-			return afs_protocol_error(call, -EBADMSG,
-						  afs_eproto_ibulkst_cb_count);
+			return afs_protocol_error(call, afs_eproto_ibulkst_cb_count);
 		call->count = 0;
 		call->unmarshall++;
 	more_cbs:
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index a239884549c5b..d7b65fad66796 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -130,7 +130,7 @@ static int afs_inode_init_from_status(struct afs_vnode *vnode, struct key *key,
 	default:
 		dump_vnode(vnode, parent_vnode);
 		write_sequnlock(&vnode->cb_lock);
-		return afs_protocol_error(NULL, -EBADMSG, afs_eproto_file_type);
+		return afs_protocol_error(NULL, afs_eproto_file_type);
 	}
 
 	afs_set_i_size(vnode, status->size);
@@ -180,7 +180,7 @@ static void afs_apply_status(struct afs_fs_cursor *fc,
 			vnode->fid.vnode,
 			vnode->fid.unique,
 			status->type, vnode->status.type);
-		afs_protocol_error(NULL, -EBADMSG, afs_eproto_bad_status);
+		afs_protocol_error(NULL, afs_eproto_bad_status);
 		return;
 	}
 
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 017d392c17940..98e0cebd5e5e9 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -1129,7 +1129,7 @@ extern void afs_flat_call_destructor(struct afs_call *);
 extern void afs_send_empty_reply(struct afs_call *);
 extern void afs_send_simple_reply(struct afs_call *, const void *, size_t);
 extern int afs_extract_data(struct afs_call *, bool);
-extern int afs_protocol_error(struct afs_call *, int, enum afs_eproto_cause);
+extern int afs_protocol_error(struct afs_call *, enum afs_eproto_cause);
 
 static inline void afs_set_fc_call(struct afs_call *call, struct afs_fs_cursor *fc)
 {
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 26f20cdd1a98e..e3c2655616dc7 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -961,11 +961,11 @@ int afs_extract_data(struct afs_call *call, bool want_more)
 /*
  * Log protocol error production.
  */
-noinline int afs_protocol_error(struct afs_call *call, int error,
+noinline int afs_protocol_error(struct afs_call *call,
 				enum afs_eproto_cause cause)
 {
-	trace_afs_protocol_error(call, error, cause);
+	trace_afs_protocol_error(call, cause);
 	if (call)
 		call->unmarshalling_error = true;
-	return error;
+	return -EBADMSG;
 }
diff --git a/fs/afs/vlclient.c b/fs/afs/vlclient.c
index 516e9a3bb5b43..e64b002c3bb3a 100644
--- a/fs/afs/vlclient.c
+++ b/fs/afs/vlclient.c
@@ -447,8 +447,7 @@ static int afs_deliver_yfsvl_get_endpoints(struct afs_call *call)
 		call->count2	= ntohl(*bp); /* Type or next count */
 
 		if (call->count > YFS_MAXENDPOINTS)
-			return afs_protocol_error(call, -EBADMSG,
-						  afs_eproto_yvl_fsendpt_num);
+			return afs_protocol_error(call, afs_eproto_yvl_fsendpt_num);
 
 		alist = afs_alloc_addrlist(call->count, FS_SERVICE, AFS_FS_PORT);
 		if (!alist)
@@ -468,8 +467,7 @@ static int afs_deliver_yfsvl_get_endpoints(struct afs_call *call)
 			size = sizeof(__be32) * (1 + 4 + 1);
 			break;
 		default:
-			return afs_protocol_error(call, -EBADMSG,
-						  afs_eproto_yvl_fsendpt_type);
+			return afs_protocol_error(call, afs_eproto_yvl_fsendpt_type);
 		}
 
 		size += sizeof(__be32);
@@ -487,21 +485,20 @@ static int afs_deliver_yfsvl_get_endpoints(struct afs_call *call)
 		switch (call->count2) {
 		case YFS_ENDPOINT_IPV4:
 			if (ntohl(bp[0]) != sizeof(__be32) * 2)
-				return afs_protocol_error(call, -EBADMSG,
-							  afs_eproto_yvl_fsendpt4_len);
+				return afs_protocol_error(
+					call, afs_eproto_yvl_fsendpt4_len);
 			afs_merge_fs_addr4(alist, bp[1], ntohl(bp[2]));
 			bp += 3;
 			break;
 		case YFS_ENDPOINT_IPV6:
 			if (ntohl(bp[0]) != sizeof(__be32) * 5)
-				return afs_protocol_error(call, -EBADMSG,
-							  afs_eproto_yvl_fsendpt6_len);
+				return afs_protocol_error(
+					call, afs_eproto_yvl_fsendpt6_len);
 			afs_merge_fs_addr6(alist, bp + 1, ntohl(bp[5]));
 			bp += 6;
 			break;
 		default:
-			return afs_protocol_error(call, -EBADMSG,
-						  afs_eproto_yvl_fsendpt_type);
+			return afs_protocol_error(call, afs_eproto_yvl_fsendpt_type);
 		}
 
 		/* Got either the type of the next entry or the count of
@@ -519,8 +516,7 @@ static int afs_deliver_yfsvl_get_endpoints(struct afs_call *call)
 		if (!call->count)
 			goto end;
 		if (call->count > YFS_MAXENDPOINTS)
-			return afs_protocol_error(call, -EBADMSG,
-						  afs_eproto_yvl_vlendpt_type);
+			return afs_protocol_error(call, afs_eproto_yvl_vlendpt_type);
 
 		afs_extract_to_buf(call, 1 * sizeof(__be32));
 		call->unmarshall = 3;
@@ -547,8 +543,7 @@ static int afs_deliver_yfsvl_get_endpoints(struct afs_call *call)
 			size = sizeof(__be32) * (1 + 4 + 1);
 			break;
 		default:
-			return afs_protocol_error(call, -EBADMSG,
-						  afs_eproto_yvl_vlendpt_type);
+			return afs_protocol_error(call, afs_eproto_yvl_vlendpt_type);
 		}
 
 		if (call->count > 1)
@@ -566,19 +561,18 @@ static int afs_deliver_yfsvl_get_endpoints(struct afs_call *call)
 		switch (call->count2) {
 		case YFS_ENDPOINT_IPV4:
 			if (ntohl(bp[0]) != sizeof(__be32) * 2)
-				return afs_protocol_error(call, -EBADMSG,
-							  afs_eproto_yvl_vlendpt4_len);
+				return afs_protocol_error(
+					call, afs_eproto_yvl_vlendpt4_len);
 			bp += 3;
 			break;
 		case YFS_ENDPOINT_IPV6:
 			if (ntohl(bp[0]) != sizeof(__be32) * 5)
-				return afs_protocol_error(call, -EBADMSG,
-							  afs_eproto_yvl_vlendpt6_len);
+				return afs_protocol_error(
+					call, afs_eproto_yvl_vlendpt6_len);
 			bp += 6;
 			break;
 		default:
-			return afs_protocol_error(call, -EBADMSG,
-						  afs_eproto_yvl_vlendpt_type);
+			return afs_protocol_error(call, afs_eproto_yvl_vlendpt_type);
 		}
 
 		/* Got either the type of the next entry or the count of
diff --git a/fs/afs/yfsclient.c b/fs/afs/yfsclient.c
index f118daa5f33a4..bf74c679c02bc 100644
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -226,7 +226,7 @@ advance:
 
 bad:
 	xdr_dump_bad(*_bp);
-	afs_protocol_error(call, -EBADMSG, afs_eproto_bad_status);
+	afs_protocol_error(call, afs_eproto_bad_status);
 	goto advance;
 }
 
@@ -1426,8 +1426,7 @@ static int yfs_deliver_fs_get_volume_status(struct afs_call *call)
 		call->count = ntohl(call->tmp);
 		_debug("volname length: %u", call->count);
 		if (call->count >= AFSNAMEMAX)
-			return afs_protocol_error(call, -EBADMSG,
-						  afs_eproto_volname_len);
+			return afs_protocol_error(call, afs_eproto_volname_len);
 		size = (call->count + 3) & ~3; /* It's padded */
 		afs_extract_to_buf(call, size);
 		call->unmarshall++;
@@ -1456,8 +1455,7 @@ static int yfs_deliver_fs_get_volume_status(struct afs_call *call)
 		call->count = ntohl(call->tmp);
 		_debug("offline msg length: %u", call->count);
 		if (call->count >= AFSNAMEMAX)
-			return afs_protocol_error(call, -EBADMSG,
-						  afs_eproto_offline_msg_len);
+			return afs_protocol_error(call, afs_eproto_offline_msg_len);
 		size = (call->count + 3) & ~3; /* It's padded */
 		afs_extract_to_buf(call, size);
 		call->unmarshall++;
@@ -1487,8 +1485,7 @@ static int yfs_deliver_fs_get_volume_status(struct afs_call *call)
 		call->count = ntohl(call->tmp);
 		_debug("motd length: %u", call->count);
 		if (call->count >= AFSNAMEMAX)
-			return afs_protocol_error(call, -EBADMSG,
-						  afs_eproto_motd_len);
+			return afs_protocol_error(call, afs_eproto_motd_len);
 		size = (call->count + 3) & ~3; /* It's padded */
 		afs_extract_to_buf(call, size);
 		call->unmarshall++;
@@ -1797,8 +1794,7 @@ static int yfs_deliver_fs_inline_bulk_status(struct afs_call *call)
 		tmp = ntohl(call->tmp);
 		_debug("status count: %u/%u", tmp, call->count2);
 		if (tmp != call->count2)
-			return afs_protocol_error(call, -EBADMSG,
-						  afs_eproto_ibulkst_count);
+			return afs_protocol_error(call, afs_eproto_ibulkst_count);
 
 		call->count = 0;
 		call->unmarshall++;
@@ -1835,8 +1831,7 @@ static int yfs_deliver_fs_inline_bulk_status(struct afs_call *call)
 		tmp = ntohl(call->tmp);
 		_debug("CB count: %u", tmp);
 		if (tmp != call->count2)
-			return afs_protocol_error(call, -EBADMSG,
-						  afs_eproto_ibulkst_cb_count);
+			return afs_protocol_error(call, afs_eproto_ibulkst_cb_count);
 		call->count = 0;
 		call->unmarshall++;
 	more_cbs:
diff --git a/include/trace/events/afs.h b/include/trace/events/afs.h
index c612cabbc378f..93eddd32bd741 100644
--- a/include/trace/events/afs.h
+++ b/include/trace/events/afs.h
@@ -988,24 +988,22 @@ TRACE_EVENT(afs_edit_dir,
 	    );
 
 TRACE_EVENT(afs_protocol_error,
-	    TP_PROTO(struct afs_call *call, int error, enum afs_eproto_cause cause),
+	    TP_PROTO(struct afs_call *call, enum afs_eproto_cause cause),
 
-	    TP_ARGS(call, error, cause),
+	    TP_ARGS(call, cause),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,		call		)
-		    __field(int,			error		)
 		    __field(enum afs_eproto_cause,	cause		)
 			     ),
 
 	    TP_fast_assign(
 		    __entry->call = call ? call->debug_id : 0;
-		    __entry->error = error;
 		    __entry->cause = cause;
 			   ),
 
-	    TP_printk("c=%08x r=%d %s",
-		      __entry->call, __entry->error,
+	    TP_printk("c=%08x %s",
+		      __entry->call,
 		      __print_symbolic(__entry->cause, afs_eproto_causes))
 	    );
 
-- 
2.25.1



