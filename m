Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 170835CB9A
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbfGBIGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:06:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728027AbfGBIF7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:05:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5F642183F;
        Tue,  2 Jul 2019 08:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054757;
        bh=jjLpPwxvMYCLHxw9Zy/8sUQAGzYYFQHNVw0gu2BXpsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MxL92S+KV+6ODnSf/4F4z1ZmmIGQSYGToT8sGNj8fZ2CgjaXZG2UQy1OgD2GChTnC
         2TX0S5CMKZ5nBFftfVVz2Zn/dsiOciJc8ziBPPOUwFFRbYMg+AUVtimAd5/nDkEO0n
         PdgCRSWnfVDbZcRWDvEIUekLrOEDhhTTWXvKKpog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Dominique Martinet <dominique.martinet@cea.fr>,
        Greg Kurz <groug@kaod.org>, Jun Piao <piaojun@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/72] 9p: embed fcall in req to round down buffer allocs
Date:   Tue,  2 Jul 2019 10:01:10 +0200
Message-Id: <20190702080125.059583519@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 523adb6cc10b48655c0abe556505240741425b49 ]

'msize' is often a power of two, or at least page-aligned, so avoiding
an overhead of two dozen bytes for each allocation will help the
allocator do its work and reduce memory fragmentation.

Link: http://lkml.kernel.org/r/1533825236-22896-1-git-send-email-asmadeus@codewreck.org
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
Reviewed-by: Greg Kurz <groug@kaod.org>
Acked-by: Jun Piao <piaojun@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/9p/client.h |   5 +-
 net/9p/client.c         | 167 +++++++++++++++++++++-------------------
 net/9p/trans_fd.c       |  12 +--
 net/9p/trans_rdma.c     |  29 +++----
 net/9p/trans_virtio.c   |  18 ++---
 net/9p/trans_xen.c      |  12 +--
 6 files changed, 125 insertions(+), 118 deletions(-)

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index a4dc42c53d18..c2671d40bb6b 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -95,8 +95,8 @@ struct p9_req_t {
 	int status;
 	int t_err;
 	wait_queue_head_t wq;
-	struct p9_fcall *tc;
-	struct p9_fcall *rc;
+	struct p9_fcall tc;
+	struct p9_fcall rc;
 	void *aux;
 	struct list_head req_list;
 };
@@ -230,6 +230,7 @@ int p9_client_mkdir_dotl(struct p9_fid *fid, const char *name, int mode,
 				kgid_t gid, struct p9_qid *);
 int p9_client_lock_dotl(struct p9_fid *fid, struct p9_flock *flock, u8 *status);
 int p9_client_getlock_dotl(struct p9_fid *fid, struct p9_getlock *fl);
+void p9_fcall_fini(struct p9_fcall *fc);
 struct p9_req_t *p9_tag_lookup(struct p9_client *, u16);
 void p9_client_cb(struct p9_client *c, struct p9_req_t *req, int status);
 
diff --git a/net/9p/client.c b/net/9p/client.c
index d8949c59d46e..83e39fef58e1 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -237,16 +237,20 @@ static int parse_opts(char *opts, struct p9_client *clnt)
 	return ret;
 }
 
-static struct p9_fcall *p9_fcall_alloc(int alloc_msize)
+static int p9_fcall_init(struct p9_fcall *fc, int alloc_msize)
 {
-	struct p9_fcall *fc;
-	fc = kmalloc(sizeof(struct p9_fcall) + alloc_msize, GFP_NOFS);
-	if (!fc)
-		return NULL;
+	fc->sdata = kmalloc(alloc_msize, GFP_NOFS);
+	if (!fc->sdata)
+		return -ENOMEM;
 	fc->capacity = alloc_msize;
-	fc->sdata = (char *) fc + sizeof(struct p9_fcall);
-	return fc;
+	return 0;
+}
+
+void p9_fcall_fini(struct p9_fcall *fc)
+{
+	kfree(fc->sdata);
 }
+EXPORT_SYMBOL(p9_fcall_fini);
 
 static struct kmem_cache *p9_req_cache;
 
@@ -269,13 +273,13 @@ p9_tag_alloc(struct p9_client *c, int8_t type, unsigned int max_size)
 	if (!req)
 		return NULL;
 
-	req->tc = p9_fcall_alloc(alloc_msize);
-	req->rc = p9_fcall_alloc(alloc_msize);
-	if (!req->tc || !req->rc)
+	if (p9_fcall_init(&req->tc, alloc_msize))
+		goto free_req;
+	if (p9_fcall_init(&req->rc, alloc_msize))
 		goto free;
 
-	p9pdu_reset(req->tc);
-	p9pdu_reset(req->rc);
+	p9pdu_reset(&req->tc);
+	p9pdu_reset(&req->rc);
 	req->status = REQ_STATUS_ALLOC;
 	init_waitqueue_head(&req->wq);
 	INIT_LIST_HEAD(&req->req_list);
@@ -287,7 +291,7 @@ p9_tag_alloc(struct p9_client *c, int8_t type, unsigned int max_size)
 				GFP_NOWAIT);
 	else
 		tag = idr_alloc(&c->reqs, req, 0, P9_NOTAG, GFP_NOWAIT);
-	req->tc->tag = tag;
+	req->tc.tag = tag;
 	spin_unlock_irq(&c->lock);
 	idr_preload_end();
 	if (tag < 0)
@@ -296,8 +300,9 @@ p9_tag_alloc(struct p9_client *c, int8_t type, unsigned int max_size)
 	return req;
 
 free:
-	kfree(req->tc);
-	kfree(req->rc);
+	p9_fcall_fini(&req->tc);
+	p9_fcall_fini(&req->rc);
+free_req:
 	kmem_cache_free(p9_req_cache, req);
 	return ERR_PTR(-ENOMEM);
 }
@@ -335,14 +340,14 @@ EXPORT_SYMBOL(p9_tag_lookup);
 static void p9_free_req(struct p9_client *c, struct p9_req_t *r)
 {
 	unsigned long flags;
-	u16 tag = r->tc->tag;
+	u16 tag = r->tc.tag;
 
 	p9_debug(P9_DEBUG_MUX, "clnt %p req %p tag: %d\n", c, r, tag);
 	spin_lock_irqsave(&c->lock, flags);
 	idr_remove(&c->reqs, tag);
 	spin_unlock_irqrestore(&c->lock, flags);
-	kfree(r->tc);
-	kfree(r->rc);
+	p9_fcall_fini(&r->tc);
+	p9_fcall_fini(&r->rc);
 	kmem_cache_free(p9_req_cache, r);
 }
 
@@ -374,7 +379,7 @@ static void p9_tag_cleanup(struct p9_client *c)
  */
 void p9_client_cb(struct p9_client *c, struct p9_req_t *req, int status)
 {
-	p9_debug(P9_DEBUG_MUX, " tag %d\n", req->tc->tag);
+	p9_debug(P9_DEBUG_MUX, " tag %d\n", req->tc.tag);
 
 	/*
 	 * This barrier is needed to make sure any change made to req before
@@ -384,7 +389,7 @@ void p9_client_cb(struct p9_client *c, struct p9_req_t *req, int status)
 	req->status = status;
 
 	wake_up(&req->wq);
-	p9_debug(P9_DEBUG_MUX, "wakeup: %d\n", req->tc->tag);
+	p9_debug(P9_DEBUG_MUX, "wakeup: %d\n", req->tc.tag);
 }
 EXPORT_SYMBOL(p9_client_cb);
 
@@ -455,18 +460,18 @@ static int p9_check_errors(struct p9_client *c, struct p9_req_t *req)
 	int err;
 	int ecode;
 
-	err = p9_parse_header(req->rc, NULL, &type, NULL, 0);
-	if (req->rc->size >= c->msize) {
+	err = p9_parse_header(&req->rc, NULL, &type, NULL, 0);
+	if (req->rc.size >= c->msize) {
 		p9_debug(P9_DEBUG_ERROR,
 			 "requested packet size too big: %d\n",
-			 req->rc->size);
+			 req->rc.size);
 		return -EIO;
 	}
 	/*
 	 * dump the response from server
 	 * This should be after check errors which poplulate pdu_fcall.
 	 */
-	trace_9p_protocol_dump(c, req->rc);
+	trace_9p_protocol_dump(c, &req->rc);
 	if (err) {
 		p9_debug(P9_DEBUG_ERROR, "couldn't parse header %d\n", err);
 		return err;
@@ -476,7 +481,7 @@ static int p9_check_errors(struct p9_client *c, struct p9_req_t *req)
 
 	if (!p9_is_proto_dotl(c)) {
 		char *ename;
-		err = p9pdu_readf(req->rc, c->proto_version, "s?d",
+		err = p9pdu_readf(&req->rc, c->proto_version, "s?d",
 				  &ename, &ecode);
 		if (err)
 			goto out_err;
@@ -492,7 +497,7 @@ static int p9_check_errors(struct p9_client *c, struct p9_req_t *req)
 		}
 		kfree(ename);
 	} else {
-		err = p9pdu_readf(req->rc, c->proto_version, "d", &ecode);
+		err = p9pdu_readf(&req->rc, c->proto_version, "d", &ecode);
 		err = -ecode;
 
 		p9_debug(P9_DEBUG_9P, "<<< RLERROR (%d)\n", -ecode);
@@ -526,12 +531,12 @@ static int p9_check_zc_errors(struct p9_client *c, struct p9_req_t *req,
 	int8_t type;
 	char *ename = NULL;
 
-	err = p9_parse_header(req->rc, NULL, &type, NULL, 0);
+	err = p9_parse_header(&req->rc, NULL, &type, NULL, 0);
 	/*
 	 * dump the response from server
 	 * This should be after parse_header which poplulate pdu_fcall.
 	 */
-	trace_9p_protocol_dump(c, req->rc);
+	trace_9p_protocol_dump(c, &req->rc);
 	if (err) {
 		p9_debug(P9_DEBUG_ERROR, "couldn't parse header %d\n", err);
 		return err;
@@ -546,13 +551,13 @@ static int p9_check_zc_errors(struct p9_client *c, struct p9_req_t *req,
 		/* 7 = header size for RERROR; */
 		int inline_len = in_hdrlen - 7;
 
-		len =  req->rc->size - req->rc->offset;
+		len = req->rc.size - req->rc.offset;
 		if (len > (P9_ZC_HDR_SZ - 7)) {
 			err = -EFAULT;
 			goto out_err;
 		}
 
-		ename = &req->rc->sdata[req->rc->offset];
+		ename = &req->rc.sdata[req->rc.offset];
 		if (len > inline_len) {
 			/* We have error in external buffer */
 			if (!copy_from_iter_full(ename + inline_len,
@@ -562,7 +567,7 @@ static int p9_check_zc_errors(struct p9_client *c, struct p9_req_t *req,
 			}
 		}
 		ename = NULL;
-		err = p9pdu_readf(req->rc, c->proto_version, "s?d",
+		err = p9pdu_readf(&req->rc, c->proto_version, "s?d",
 				  &ename, &ecode);
 		if (err)
 			goto out_err;
@@ -578,7 +583,7 @@ static int p9_check_zc_errors(struct p9_client *c, struct p9_req_t *req,
 		}
 		kfree(ename);
 	} else {
-		err = p9pdu_readf(req->rc, c->proto_version, "d", &ecode);
+		err = p9pdu_readf(&req->rc, c->proto_version, "d", &ecode);
 		err = -ecode;
 
 		p9_debug(P9_DEBUG_9P, "<<< RLERROR (%d)\n", -ecode);
@@ -611,7 +616,7 @@ static int p9_client_flush(struct p9_client *c, struct p9_req_t *oldreq)
 	int16_t oldtag;
 	int err;
 
-	err = p9_parse_header(oldreq->tc, NULL, NULL, &oldtag, 1);
+	err = p9_parse_header(&oldreq->tc, NULL, NULL, &oldtag, 1);
 	if (err)
 		return err;
 
@@ -655,12 +660,12 @@ static struct p9_req_t *p9_client_prepare_req(struct p9_client *c,
 		return req;
 
 	/* marshall the data */
-	p9pdu_prepare(req->tc, req->tc->tag, type);
-	err = p9pdu_vwritef(req->tc, c->proto_version, fmt, ap);
+	p9pdu_prepare(&req->tc, req->tc.tag, type);
+	err = p9pdu_vwritef(&req->tc, c->proto_version, fmt, ap);
 	if (err)
 		goto reterr;
-	p9pdu_finalize(c, req->tc);
-	trace_9p_client_req(c, type, req->tc->tag);
+	p9pdu_finalize(c, &req->tc);
+	trace_9p_client_req(c, type, req->tc.tag);
 	return req;
 reterr:
 	p9_free_req(c, req);
@@ -745,7 +750,7 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 		goto reterr;
 
 	err = p9_check_errors(c, req);
-	trace_9p_client_res(c, type, req->rc->tag, err);
+	trace_9p_client_res(c, type, req->rc.tag, err);
 	if (!err)
 		return req;
 reterr:
@@ -827,7 +832,7 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
 		goto reterr;
 
 	err = p9_check_zc_errors(c, req, uidata, in_hdrlen);
-	trace_9p_client_res(c, type, req->rc->tag, err);
+	trace_9p_client_res(c, type, req->rc.tag, err);
 	if (!err)
 		return req;
 reterr:
@@ -910,10 +915,10 @@ static int p9_client_version(struct p9_client *c)
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	err = p9pdu_readf(req->rc, c->proto_version, "ds", &msize, &version);
+	err = p9pdu_readf(&req->rc, c->proto_version, "ds", &msize, &version);
 	if (err) {
 		p9_debug(P9_DEBUG_9P, "version error %d\n", err);
-		trace_9p_protocol_dump(c, req->rc);
+		trace_9p_protocol_dump(c, &req->rc);
 		goto error;
 	}
 
@@ -1077,9 +1082,9 @@ struct p9_fid *p9_client_attach(struct p9_client *clnt, struct p9_fid *afid,
 		goto error;
 	}
 
-	err = p9pdu_readf(req->rc, clnt->proto_version, "Q", &qid);
+	err = p9pdu_readf(&req->rc, clnt->proto_version, "Q", &qid);
 	if (err) {
-		trace_9p_protocol_dump(clnt, req->rc);
+		trace_9p_protocol_dump(clnt, &req->rc);
 		p9_free_req(clnt, req);
 		goto error;
 	}
@@ -1134,9 +1139,9 @@ struct p9_fid *p9_client_walk(struct p9_fid *oldfid, uint16_t nwname,
 		goto error;
 	}
 
-	err = p9pdu_readf(req->rc, clnt->proto_version, "R", &nwqids, &wqids);
+	err = p9pdu_readf(&req->rc, clnt->proto_version, "R", &nwqids, &wqids);
 	if (err) {
-		trace_9p_protocol_dump(clnt, req->rc);
+		trace_9p_protocol_dump(clnt, &req->rc);
 		p9_free_req(clnt, req);
 		goto clunk_fid;
 	}
@@ -1201,9 +1206,9 @@ int p9_client_open(struct p9_fid *fid, int mode)
 		goto error;
 	}
 
-	err = p9pdu_readf(req->rc, clnt->proto_version, "Qd", &qid, &iounit);
+	err = p9pdu_readf(&req->rc, clnt->proto_version, "Qd", &qid, &iounit);
 	if (err) {
-		trace_9p_protocol_dump(clnt, req->rc);
+		trace_9p_protocol_dump(clnt, &req->rc);
 		goto free_and_error;
 	}
 
@@ -1245,9 +1250,9 @@ int p9_client_create_dotl(struct p9_fid *ofid, const char *name, u32 flags, u32
 		goto error;
 	}
 
-	err = p9pdu_readf(req->rc, clnt->proto_version, "Qd", qid, &iounit);
+	err = p9pdu_readf(&req->rc, clnt->proto_version, "Qd", qid, &iounit);
 	if (err) {
-		trace_9p_protocol_dump(clnt, req->rc);
+		trace_9p_protocol_dump(clnt, &req->rc);
 		goto free_and_error;
 	}
 
@@ -1290,9 +1295,9 @@ int p9_client_fcreate(struct p9_fid *fid, const char *name, u32 perm, int mode,
 		goto error;
 	}
 
-	err = p9pdu_readf(req->rc, clnt->proto_version, "Qd", &qid, &iounit);
+	err = p9pdu_readf(&req->rc, clnt->proto_version, "Qd", &qid, &iounit);
 	if (err) {
-		trace_9p_protocol_dump(clnt, req->rc);
+		trace_9p_protocol_dump(clnt, &req->rc);
 		goto free_and_error;
 	}
 
@@ -1329,9 +1334,9 @@ int p9_client_symlink(struct p9_fid *dfid, const char *name,
 		goto error;
 	}
 
-	err = p9pdu_readf(req->rc, clnt->proto_version, "Q", qid);
+	err = p9pdu_readf(&req->rc, clnt->proto_version, "Q", qid);
 	if (err) {
-		trace_9p_protocol_dump(clnt, req->rc);
+		trace_9p_protocol_dump(clnt, &req->rc);
 		goto free_and_error;
 	}
 
@@ -1527,10 +1532,10 @@ p9_client_read(struct p9_fid *fid, u64 offset, struct iov_iter *to, int *err)
 			break;
 		}
 
-		*err = p9pdu_readf(req->rc, clnt->proto_version,
+		*err = p9pdu_readf(&req->rc, clnt->proto_version,
 				   "D", &count, &dataptr);
 		if (*err) {
-			trace_9p_protocol_dump(clnt, req->rc);
+			trace_9p_protocol_dump(clnt, &req->rc);
 			p9_free_req(clnt, req);
 			break;
 		}
@@ -1600,9 +1605,9 @@ p9_client_write(struct p9_fid *fid, u64 offset, struct iov_iter *from, int *err)
 			break;
 		}
 
-		*err = p9pdu_readf(req->rc, clnt->proto_version, "d", &count);
+		*err = p9pdu_readf(&req->rc, clnt->proto_version, "d", &count);
 		if (*err) {
-			trace_9p_protocol_dump(clnt, req->rc);
+			trace_9p_protocol_dump(clnt, &req->rc);
 			p9_free_req(clnt, req);
 			break;
 		}
@@ -1644,9 +1649,9 @@ struct p9_wstat *p9_client_stat(struct p9_fid *fid)
 		goto error;
 	}
 
-	err = p9pdu_readf(req->rc, clnt->proto_version, "wS", &ignored, ret);
+	err = p9pdu_readf(&req->rc, clnt->proto_version, "wS", &ignored, ret);
 	if (err) {
-		trace_9p_protocol_dump(clnt, req->rc);
+		trace_9p_protocol_dump(clnt, &req->rc);
 		p9_free_req(clnt, req);
 		goto error;
 	}
@@ -1697,9 +1702,9 @@ struct p9_stat_dotl *p9_client_getattr_dotl(struct p9_fid *fid,
 		goto error;
 	}
 
-	err = p9pdu_readf(req->rc, clnt->proto_version, "A", ret);
+	err = p9pdu_readf(&req->rc, clnt->proto_version, "A", ret);
 	if (err) {
-		trace_9p_protocol_dump(clnt, req->rc);
+		trace_9p_protocol_dump(clnt, &req->rc);
 		p9_free_req(clnt, req);
 		goto error;
 	}
@@ -1849,11 +1854,11 @@ int p9_client_statfs(struct p9_fid *fid, struct p9_rstatfs *sb)
 		goto error;
 	}
 
-	err = p9pdu_readf(req->rc, clnt->proto_version, "ddqqqqqqd", &sb->type,
-		&sb->bsize, &sb->blocks, &sb->bfree, &sb->bavail,
-		&sb->files, &sb->ffree, &sb->fsid, &sb->namelen);
+	err = p9pdu_readf(&req->rc, clnt->proto_version, "ddqqqqqqd", &sb->type,
+			  &sb->bsize, &sb->blocks, &sb->bfree, &sb->bavail,
+			  &sb->files, &sb->ffree, &sb->fsid, &sb->namelen);
 	if (err) {
-		trace_9p_protocol_dump(clnt, req->rc);
+		trace_9p_protocol_dump(clnt, &req->rc);
 		p9_free_req(clnt, req);
 		goto error;
 	}
@@ -1957,9 +1962,9 @@ struct p9_fid *p9_client_xattrwalk(struct p9_fid *file_fid,
 		err = PTR_ERR(req);
 		goto error;
 	}
-	err = p9pdu_readf(req->rc, clnt->proto_version, "q", attr_size);
+	err = p9pdu_readf(&req->rc, clnt->proto_version, "q", attr_size);
 	if (err) {
-		trace_9p_protocol_dump(clnt, req->rc);
+		trace_9p_protocol_dump(clnt, &req->rc);
 		p9_free_req(clnt, req);
 		goto clunk_fid;
 	}
@@ -2045,9 +2050,9 @@ int p9_client_readdir(struct p9_fid *fid, char *data, u32 count, u64 offset)
 		goto error;
 	}
 
-	err = p9pdu_readf(req->rc, clnt->proto_version, "D", &count, &dataptr);
+	err = p9pdu_readf(&req->rc, clnt->proto_version, "D", &count, &dataptr);
 	if (err) {
-		trace_9p_protocol_dump(clnt, req->rc);
+		trace_9p_protocol_dump(clnt, &req->rc);
 		goto free_and_error;
 	}
 	if (rsize < count) {
@@ -2086,9 +2091,9 @@ int p9_client_mknod_dotl(struct p9_fid *fid, const char *name, int mode,
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	err = p9pdu_readf(req->rc, clnt->proto_version, "Q", qid);
+	err = p9pdu_readf(&req->rc, clnt->proto_version, "Q", qid);
 	if (err) {
-		trace_9p_protocol_dump(clnt, req->rc);
+		trace_9p_protocol_dump(clnt, &req->rc);
 		goto error;
 	}
 	p9_debug(P9_DEBUG_9P, "<<< RMKNOD qid %x.%llx.%x\n", qid->type,
@@ -2117,9 +2122,9 @@ int p9_client_mkdir_dotl(struct p9_fid *fid, const char *name, int mode,
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	err = p9pdu_readf(req->rc, clnt->proto_version, "Q", qid);
+	err = p9pdu_readf(&req->rc, clnt->proto_version, "Q", qid);
 	if (err) {
-		trace_9p_protocol_dump(clnt, req->rc);
+		trace_9p_protocol_dump(clnt, &req->rc);
 		goto error;
 	}
 	p9_debug(P9_DEBUG_9P, "<<< RMKDIR qid %x.%llx.%x\n", qid->type,
@@ -2152,9 +2157,9 @@ int p9_client_lock_dotl(struct p9_fid *fid, struct p9_flock *flock, u8 *status)
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	err = p9pdu_readf(req->rc, clnt->proto_version, "b", status);
+	err = p9pdu_readf(&req->rc, clnt->proto_version, "b", status);
 	if (err) {
-		trace_9p_protocol_dump(clnt, req->rc);
+		trace_9p_protocol_dump(clnt, &req->rc);
 		goto error;
 	}
 	p9_debug(P9_DEBUG_9P, "<<< RLOCK status %i\n", *status);
@@ -2183,11 +2188,11 @@ int p9_client_getlock_dotl(struct p9_fid *fid, struct p9_getlock *glock)
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	err = p9pdu_readf(req->rc, clnt->proto_version, "bqqds", &glock->type,
-			&glock->start, &glock->length, &glock->proc_id,
-			&glock->client_id);
+	err = p9pdu_readf(&req->rc, clnt->proto_version, "bqqds", &glock->type,
+			  &glock->start, &glock->length, &glock->proc_id,
+			  &glock->client_id);
 	if (err) {
-		trace_9p_protocol_dump(clnt, req->rc);
+		trace_9p_protocol_dump(clnt, &req->rc);
 		goto error;
 	}
 	p9_debug(P9_DEBUG_9P, "<<< RGETLOCK type %i start %lld length %lld "
@@ -2213,9 +2218,9 @@ int p9_client_readlink(struct p9_fid *fid, char **target)
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	err = p9pdu_readf(req->rc, clnt->proto_version, "s", target);
+	err = p9pdu_readf(&req->rc, clnt->proto_version, "s", target);
 	if (err) {
-		trace_9p_protocol_dump(clnt, req->rc);
+		trace_9p_protocol_dump(clnt, &req->rc);
 		goto error;
 	}
 	p9_debug(P9_DEBUG_9P, "<<< RREADLINK target %s\n", *target);
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index e2ef3c782c53..51615c0fb744 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -354,7 +354,7 @@ static void p9_read_work(struct work_struct *work)
 			goto error;
 		}
 
-		if (m->req->rc == NULL) {
+		if (!m->req->rc.sdata) {
 			p9_debug(P9_DEBUG_ERROR,
 				 "No recv fcall for tag %d (req %p), disconnecting!\n",
 				 m->rc.tag, m->req);
@@ -362,7 +362,7 @@ static void p9_read_work(struct work_struct *work)
 			err = -EIO;
 			goto error;
 		}
-		m->rc.sdata = (char *)m->req->rc + sizeof(struct p9_fcall);
+		m->rc.sdata = m->req->rc.sdata;
 		memcpy(m->rc.sdata, m->tmp_buf, m->rc.capacity);
 		m->rc.capacity = m->rc.size;
 	}
@@ -372,7 +372,7 @@ static void p9_read_work(struct work_struct *work)
 	 */
 	if ((m->req) && (m->rc.offset == m->rc.capacity)) {
 		p9_debug(P9_DEBUG_TRANS, "got new packet\n");
-		m->req->rc->size = m->rc.offset;
+		m->req->rc.size = m->rc.offset;
 		spin_lock(&m->client->lock);
 		if (m->req->status != REQ_STATUS_ERROR)
 			status = REQ_STATUS_RCVD;
@@ -469,8 +469,8 @@ static void p9_write_work(struct work_struct *work)
 		p9_debug(P9_DEBUG_TRANS, "move req %p\n", req);
 		list_move_tail(&req->req_list, &m->req_list);
 
-		m->wbuf = req->tc->sdata;
-		m->wsize = req->tc->size;
+		m->wbuf = req->tc.sdata;
+		m->wsize = req->tc.size;
 		m->wpos = 0;
 		spin_unlock(&m->client->lock);
 	}
@@ -663,7 +663,7 @@ static int p9_fd_request(struct p9_client *client, struct p9_req_t *req)
 	struct p9_conn *m = &ts->conn;
 
 	p9_debug(P9_DEBUG_TRANS, "mux %p task %p tcall %p id %d\n",
-		 m, current, req->tc, req->tc->id);
+		 m, current, &req->tc, req->tc.id);
 	if (m->err < 0)
 		return m->err;
 
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index b513cffeeb3c..5b0cda1aaa7a 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -122,7 +122,7 @@ struct p9_rdma_context {
 	dma_addr_t busa;
 	union {
 		struct p9_req_t *req;
-		struct p9_fcall *rc;
+		struct p9_fcall rc;
 	};
 };
 
@@ -320,8 +320,8 @@ recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	if (wc->status != IB_WC_SUCCESS)
 		goto err_out;
 
-	c->rc->size = wc->byte_len;
-	err = p9_parse_header(c->rc, NULL, NULL, &tag, 1);
+	c->rc.size = wc->byte_len;
+	err = p9_parse_header(&c->rc, NULL, NULL, &tag, 1);
 	if (err)
 		goto err_out;
 
@@ -331,12 +331,13 @@ recv_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	/* Check that we have not yet received a reply for this request.
 	 */
-	if (unlikely(req->rc)) {
+	if (unlikely(req->rc.sdata)) {
 		pr_err("Duplicate reply for request %d", tag);
 		goto err_out;
 	}
 
-	req->rc = c->rc;
+	req->rc.size = c->rc.size;
+	req->rc.sdata = c->rc.sdata;
 	p9_client_cb(client, req, REQ_STATUS_RCVD);
 
  out:
@@ -361,7 +362,7 @@ send_done(struct ib_cq *cq, struct ib_wc *wc)
 		container_of(wc->wr_cqe, struct p9_rdma_context, cqe);
 
 	ib_dma_unmap_single(rdma->cm_id->device,
-			    c->busa, c->req->tc->size,
+			    c->busa, c->req->tc.size,
 			    DMA_TO_DEVICE);
 	up(&rdma->sq_sem);
 	kfree(c);
@@ -401,7 +402,7 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
 	struct ib_sge sge;
 
 	c->busa = ib_dma_map_single(rdma->cm_id->device,
-				    c->rc->sdata, client->msize,
+				    c->rc.sdata, client->msize,
 				    DMA_FROM_DEVICE);
 	if (ib_dma_mapping_error(rdma->cm_id->device, c->busa))
 		goto error;
@@ -443,9 +444,9 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 	 **/
 	if (unlikely(atomic_read(&rdma->excess_rc) > 0)) {
 		if ((atomic_sub_return(1, &rdma->excess_rc) >= 0)) {
-			/* Got one ! */
-			kfree(req->rc);
-			req->rc = NULL;
+			/* Got one! */
+			p9_fcall_fini(&req->rc);
+			req->rc.sdata = NULL;
 			goto dont_need_post_recv;
 		} else {
 			/* We raced and lost. */
@@ -459,7 +460,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 		err = -ENOMEM;
 		goto recv_error;
 	}
-	rpl_context->rc = req->rc;
+	rpl_context->rc.sdata = req->rc.sdata;
 
 	/*
 	 * Post a receive buffer for this request. We need to ensure
@@ -479,7 +480,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 		goto recv_error;
 	}
 	/* remove posted receive buffer from request structure */
-	req->rc = NULL;
+	req->rc.sdata = NULL;
 
 dont_need_post_recv:
 	/* Post the request */
@@ -491,7 +492,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 	c->req = req;
 
 	c->busa = ib_dma_map_single(rdma->cm_id->device,
-				    c->req->tc->sdata, c->req->tc->size,
+				    c->req->tc.sdata, c->req->tc.size,
 				    DMA_TO_DEVICE);
 	if (ib_dma_mapping_error(rdma->cm_id->device, c->busa)) {
 		err = -EIO;
@@ -501,7 +502,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 	c->cqe.done = send_done;
 
 	sge.addr = c->busa;
-	sge.length = c->req->tc->size;
+	sge.length = c->req->tc.size;
 	sge.lkey = rdma->pd->local_dma_lkey;
 
 	wr.next = NULL;
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 7728b0acde09..3dd6ce1c0f2d 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -155,7 +155,7 @@ static void req_done(struct virtqueue *vq)
 		}
 
 		if (len) {
-			req->rc->size = len;
+			req->rc.size = len;
 			p9_client_cb(chan->client, req, REQ_STATUS_RCVD);
 		}
 	}
@@ -273,12 +273,12 @@ p9_virtio_request(struct p9_client *client, struct p9_req_t *req)
 	out_sgs = in_sgs = 0;
 	/* Handle out VirtIO ring buffers */
 	out = pack_sg_list(chan->sg, 0,
-			   VIRTQUEUE_NUM, req->tc->sdata, req->tc->size);
+			   VIRTQUEUE_NUM, req->tc.sdata, req->tc.size);
 	if (out)
 		sgs[out_sgs++] = chan->sg;
 
 	in = pack_sg_list(chan->sg, out,
-			  VIRTQUEUE_NUM, req->rc->sdata, req->rc->capacity);
+			  VIRTQUEUE_NUM, req->rc.sdata, req->rc.capacity);
 	if (in)
 		sgs[out_sgs + in_sgs++] = chan->sg + out;
 
@@ -416,15 +416,15 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 		out_nr_pages = DIV_ROUND_UP(n + offs, PAGE_SIZE);
 		if (n != outlen) {
 			__le32 v = cpu_to_le32(n);
-			memcpy(&req->tc->sdata[req->tc->size - 4], &v, 4);
+			memcpy(&req->tc.sdata[req->tc.size - 4], &v, 4);
 			outlen = n;
 		}
 		/* The size field of the message must include the length of the
 		 * header and the length of the data.  We didn't actually know
 		 * the length of the data until this point so add it in now.
 		 */
-		sz = cpu_to_le32(req->tc->size + outlen);
-		memcpy(&req->tc->sdata[0], &sz, sizeof(sz));
+		sz = cpu_to_le32(req->tc.size + outlen);
+		memcpy(&req->tc.sdata[0], &sz, sizeof(sz));
 	} else if (uidata) {
 		int n = p9_get_mapped_pages(chan, &in_pages, uidata,
 					    inlen, &offs, &need_drop);
@@ -433,7 +433,7 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 		in_nr_pages = DIV_ROUND_UP(n + offs, PAGE_SIZE);
 		if (n != inlen) {
 			__le32 v = cpu_to_le32(n);
-			memcpy(&req->tc->sdata[req->tc->size - 4], &v, 4);
+			memcpy(&req->tc.sdata[req->tc.size - 4], &v, 4);
 			inlen = n;
 		}
 	}
@@ -445,7 +445,7 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 
 	/* out data */
 	out = pack_sg_list(chan->sg, 0,
-			   VIRTQUEUE_NUM, req->tc->sdata, req->tc->size);
+			   VIRTQUEUE_NUM, req->tc.sdata, req->tc.size);
 
 	if (out)
 		sgs[out_sgs++] = chan->sg;
@@ -464,7 +464,7 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 	 * alloced memory and payload onto the user buffer.
 	 */
 	in = pack_sg_list(chan->sg, out,
-			  VIRTQUEUE_NUM, req->rc->sdata, in_hdr_len);
+			  VIRTQUEUE_NUM, req->rc.sdata, in_hdr_len);
 	if (in)
 		sgs[out_sgs + in_sgs++] = chan->sg + out;
 
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 843cb823d9b9..782a07f2ad0c 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -141,7 +141,7 @@ static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
 	struct xen_9pfs_front_priv *priv = NULL;
 	RING_IDX cons, prod, masked_cons, masked_prod;
 	unsigned long flags;
-	u32 size = p9_req->tc->size;
+	u32 size = p9_req->tc.size;
 	struct xen_9pfs_dataring *ring;
 	int num;
 
@@ -154,7 +154,7 @@ static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
 	if (!priv || priv->client != client)
 		return -EINVAL;
 
-	num = p9_req->tc->tag % priv->num_rings;
+	num = p9_req->tc.tag % priv->num_rings;
 	ring = &priv->rings[num];
 
 again:
@@ -176,7 +176,7 @@ static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
 	masked_prod = xen_9pfs_mask(prod, XEN_9PFS_RING_SIZE);
 	masked_cons = xen_9pfs_mask(cons, XEN_9PFS_RING_SIZE);
 
-	xen_9pfs_write_packet(ring->data.out, p9_req->tc->sdata, size,
+	xen_9pfs_write_packet(ring->data.out, p9_req->tc.sdata, size,
 			      &masked_prod, masked_cons, XEN_9PFS_RING_SIZE);
 
 	p9_req->status = REQ_STATUS_SENT;
@@ -229,12 +229,12 @@ static void p9_xen_response(struct work_struct *work)
 			continue;
 		}
 
-		memcpy(req->rc, &h, sizeof(h));
-		req->rc->offset = 0;
+		memcpy(&req->rc, &h, sizeof(h));
+		req->rc.offset = 0;
 
 		masked_cons = xen_9pfs_mask(cons, XEN_9PFS_RING_SIZE);
 		/* Then, read the whole packet (including the header) */
-		xen_9pfs_read_packet(req->rc->sdata, ring->data.in, h.size,
+		xen_9pfs_read_packet(req->rc.sdata, ring->data.in, h.size,
 				     masked_prod, &masked_cons,
 				     XEN_9PFS_RING_SIZE);
 
-- 
2.20.1



