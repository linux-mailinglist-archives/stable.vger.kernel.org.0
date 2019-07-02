Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47DA65CA8A
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbfGBIFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727925AbfGBIFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:05:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C82C92183F;
        Tue,  2 Jul 2019 08:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054717;
        bh=ltOdjpxkO/4c81v6OIPsR9/PRW8l/83DvUla7eBudqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p16oBqNg4dUc/ClddZoCvZy94eWufY+LR1JFK+0MsU6ZCyJ6yS7yENNEX3lbQorIi
         xm7rQ5DPjU0UWkCM7rRSs3E447napuu9nE9kD4OVfGUxV5nVxCMgprHgowwig54px7
         72yeOk1fkTrblmXwgrT0Wa8ffrSCdjBNgBmEqeg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Bortoli <tomasbortoli@gmail.com>,
        Jun Piao <piaojun@huawei.com>,
        Dominique Martinet <dominique.martinet@cea.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/72] 9p: rename p9_free_req() function
Date:   Tue,  2 Jul 2019 10:01:12 +0200
Message-Id: <20190702080125.164358629@linuxfoundation.org>
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

[ Upstream commit 43cbcbee9938b17f77cf34f1bc12d302f456810f ]

In sight of the next patch to add a refcount in p9_req_t, rename
the p9_free_req() function in p9_release_req().

In the next patch the actual kfree will be moved to another function.

Link: http://lkml.kernel.org/r/20180811144254.23665-1-tomasbortoli@gmail.com
Signed-off-by: Tomas Bortoli <tomasbortoli@gmail.com>
Acked-by: Jun Piao <piaojun@huawei.com>
Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/client.c | 100 ++++++++++++++++++++++++------------------------
 1 file changed, 50 insertions(+), 50 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 7ef54719c6f7..3cde9f619980 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -347,13 +347,13 @@ struct p9_req_t *p9_tag_lookup(struct p9_client *c, u16 tag)
 EXPORT_SYMBOL(p9_tag_lookup);
 
 /**
- * p9_free_req - Free a request.
+ * p9_tag_remove - Remove a tag.
  * @c: Client session.
- * @r: Request to free.
+ * @r: Request of reference.
  *
  * Context: Any context.
  */
-static void p9_free_req(struct p9_client *c, struct p9_req_t *r)
+static void p9_tag_remove(struct p9_client *c, struct p9_req_t *r)
 {
 	unsigned long flags;
 	u16 tag = r->tc.tag;
@@ -382,7 +382,7 @@ static void p9_tag_cleanup(struct p9_client *c)
 	rcu_read_lock();
 	idr_for_each_entry(&c->reqs, req, id) {
 		pr_info("Tag %d still in use\n", id);
-		p9_free_req(c, req);
+		p9_tag_remove(c, req);
 	}
 	rcu_read_unlock();
 }
@@ -650,7 +650,7 @@ static int p9_client_flush(struct p9_client *c, struct p9_req_t *oldreq)
 		if (c->trans_mod->cancelled)
 			c->trans_mod->cancelled(c, oldreq);
 
-	p9_free_req(c, req);
+	p9_tag_remove(c, req);
 	return 0;
 }
 
@@ -684,7 +684,7 @@ static struct p9_req_t *p9_client_prepare_req(struct p9_client *c,
 	trace_9p_client_req(c, type, req->tc.tag);
 	return req;
 reterr:
-	p9_free_req(c, req);
+	p9_tag_remove(c, req);
 	return ERR_PTR(err);
 }
 
@@ -694,7 +694,7 @@ static struct p9_req_t *p9_client_prepare_req(struct p9_client *c,
  * @type: type of request
  * @fmt: protocol format string (see protocol.c)
  *
- * Returns request structure (which client must free using p9_free_req)
+ * Returns request structure (which client must free using p9_tag_remove)
  */
 
 static struct p9_req_t *
@@ -770,7 +770,7 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 	if (!err)
 		return req;
 reterr:
-	p9_free_req(c, req);
+	p9_tag_remove(c, req);
 	return ERR_PTR(safe_errno(err));
 }
 
@@ -785,7 +785,7 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
  * @hdrlen: reader header size, This is the size of response protocol data
  * @fmt: protocol format string (see protocol.c)
  *
- * Returns request structure (which client must free using p9_free_req)
+ * Returns request structure (which client must free using p9_tag_remove)
  */
 static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
 					 struct iov_iter *uidata,
@@ -852,7 +852,7 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
 	if (!err)
 		return req;
 reterr:
-	p9_free_req(c, req);
+	p9_tag_remove(c, req);
 	return ERR_PTR(safe_errno(err));
 }
 
@@ -963,7 +963,7 @@ static int p9_client_version(struct p9_client *c)
 
 error:
 	kfree(version);
-	p9_free_req(c, req);
+	p9_tag_remove(c, req);
 
 	return err;
 }
@@ -1112,7 +1112,7 @@ struct p9_fid *p9_client_attach(struct p9_client *clnt, struct p9_fid *afid,
 	err = p9pdu_readf(&req->rc, clnt->proto_version, "Q", &qid);
 	if (err) {
 		trace_9p_protocol_dump(clnt, &req->rc);
-		p9_free_req(clnt, req);
+		p9_tag_remove(clnt, req);
 		goto error;
 	}
 
@@ -1121,7 +1121,7 @@ struct p9_fid *p9_client_attach(struct p9_client *clnt, struct p9_fid *afid,
 
 	memmove(&fid->qid, &qid, sizeof(struct p9_qid));
 
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 	return fid;
 
 error:
@@ -1169,10 +1169,10 @@ struct p9_fid *p9_client_walk(struct p9_fid *oldfid, uint16_t nwname,
 	err = p9pdu_readf(&req->rc, clnt->proto_version, "R", &nwqids, &wqids);
 	if (err) {
 		trace_9p_protocol_dump(clnt, &req->rc);
-		p9_free_req(clnt, req);
+		p9_tag_remove(clnt, req);
 		goto clunk_fid;
 	}
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 
 	p9_debug(P9_DEBUG_9P, "<<< RWALK nwqid %d:\n", nwqids);
 
@@ -1247,7 +1247,7 @@ int p9_client_open(struct p9_fid *fid, int mode)
 	fid->iounit = iounit;
 
 free_and_error:
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 error:
 	return err;
 }
@@ -1292,7 +1292,7 @@ int p9_client_create_dotl(struct p9_fid *ofid, const char *name, u32 flags, u32
 	ofid->iounit = iounit;
 
 free_and_error:
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 error:
 	return err;
 }
@@ -1337,7 +1337,7 @@ int p9_client_fcreate(struct p9_fid *fid, const char *name, u32 perm, int mode,
 	fid->iounit = iounit;
 
 free_and_error:
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 error:
 	return err;
 }
@@ -1371,7 +1371,7 @@ int p9_client_symlink(struct p9_fid *dfid, const char *name,
 			qid->type, (unsigned long long)qid->path, qid->version);
 
 free_and_error:
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 error:
 	return err;
 }
@@ -1391,7 +1391,7 @@ int p9_client_link(struct p9_fid *dfid, struct p9_fid *oldfid, const char *newna
 		return PTR_ERR(req);
 
 	p9_debug(P9_DEBUG_9P, "<<< RLINK\n");
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 	return 0;
 }
 EXPORT_SYMBOL(p9_client_link);
@@ -1415,7 +1415,7 @@ int p9_client_fsync(struct p9_fid *fid, int datasync)
 
 	p9_debug(P9_DEBUG_9P, "<<< RFSYNC fid %d\n", fid->fid);
 
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 
 error:
 	return err;
@@ -1450,7 +1450,7 @@ int p9_client_clunk(struct p9_fid *fid)
 
 	p9_debug(P9_DEBUG_9P, "<<< RCLUNK fid %d\n", fid->fid);
 
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 error:
 	/*
 	 * Fid is not valid even after a failed clunk
@@ -1484,7 +1484,7 @@ int p9_client_remove(struct p9_fid *fid)
 
 	p9_debug(P9_DEBUG_9P, "<<< RREMOVE fid %d\n", fid->fid);
 
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 error:
 	if (err == -ERESTARTSYS)
 		p9_client_clunk(fid);
@@ -1511,7 +1511,7 @@ int p9_client_unlinkat(struct p9_fid *dfid, const char *name, int flags)
 	}
 	p9_debug(P9_DEBUG_9P, "<<< RUNLINKAT fid %d %s\n", dfid->fid, name);
 
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 error:
 	return err;
 }
@@ -1563,7 +1563,7 @@ p9_client_read(struct p9_fid *fid, u64 offset, struct iov_iter *to, int *err)
 				   "D", &count, &dataptr);
 		if (*err) {
 			trace_9p_protocol_dump(clnt, &req->rc);
-			p9_free_req(clnt, req);
+			p9_tag_remove(clnt, req);
 			break;
 		}
 		if (rsize < count) {
@@ -1573,7 +1573,7 @@ p9_client_read(struct p9_fid *fid, u64 offset, struct iov_iter *to, int *err)
 
 		p9_debug(P9_DEBUG_9P, "<<< RREAD count %d\n", count);
 		if (!count) {
-			p9_free_req(clnt, req);
+			p9_tag_remove(clnt, req);
 			break;
 		}
 
@@ -1583,7 +1583,7 @@ p9_client_read(struct p9_fid *fid, u64 offset, struct iov_iter *to, int *err)
 			offset += n;
 			if (n != count) {
 				*err = -EFAULT;
-				p9_free_req(clnt, req);
+				p9_tag_remove(clnt, req);
 				break;
 			}
 		} else {
@@ -1591,7 +1591,7 @@ p9_client_read(struct p9_fid *fid, u64 offset, struct iov_iter *to, int *err)
 			total += count;
 			offset += count;
 		}
-		p9_free_req(clnt, req);
+		p9_tag_remove(clnt, req);
 	}
 	return total;
 }
@@ -1635,7 +1635,7 @@ p9_client_write(struct p9_fid *fid, u64 offset, struct iov_iter *from, int *err)
 		*err = p9pdu_readf(&req->rc, clnt->proto_version, "d", &count);
 		if (*err) {
 			trace_9p_protocol_dump(clnt, &req->rc);
-			p9_free_req(clnt, req);
+			p9_tag_remove(clnt, req);
 			break;
 		}
 		if (rsize < count) {
@@ -1645,7 +1645,7 @@ p9_client_write(struct p9_fid *fid, u64 offset, struct iov_iter *from, int *err)
 
 		p9_debug(P9_DEBUG_9P, "<<< RWRITE count %d\n", count);
 
-		p9_free_req(clnt, req);
+		p9_tag_remove(clnt, req);
 		iov_iter_advance(from, count);
 		total += count;
 		offset += count;
@@ -1679,7 +1679,7 @@ struct p9_wstat *p9_client_stat(struct p9_fid *fid)
 	err = p9pdu_readf(&req->rc, clnt->proto_version, "wS", &ignored, ret);
 	if (err) {
 		trace_9p_protocol_dump(clnt, &req->rc);
-		p9_free_req(clnt, req);
+		p9_tag_remove(clnt, req);
 		goto error;
 	}
 
@@ -1696,7 +1696,7 @@ struct p9_wstat *p9_client_stat(struct p9_fid *fid)
 		from_kgid(&init_user_ns, ret->n_gid),
 		from_kuid(&init_user_ns, ret->n_muid));
 
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 	return ret;
 
 error:
@@ -1732,7 +1732,7 @@ struct p9_stat_dotl *p9_client_getattr_dotl(struct p9_fid *fid,
 	err = p9pdu_readf(&req->rc, clnt->proto_version, "A", ret);
 	if (err) {
 		trace_9p_protocol_dump(clnt, &req->rc);
-		p9_free_req(clnt, req);
+		p9_tag_remove(clnt, req);
 		goto error;
 	}
 
@@ -1757,7 +1757,7 @@ struct p9_stat_dotl *p9_client_getattr_dotl(struct p9_fid *fid,
 		ret->st_ctime_nsec, ret->st_btime_sec, ret->st_btime_nsec,
 		ret->st_gen, ret->st_data_version);
 
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 	return ret;
 
 error:
@@ -1826,7 +1826,7 @@ int p9_client_wstat(struct p9_fid *fid, struct p9_wstat *wst)
 
 	p9_debug(P9_DEBUG_9P, "<<< RWSTAT fid %d\n", fid->fid);
 
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 error:
 	return err;
 }
@@ -1858,7 +1858,7 @@ int p9_client_setattr(struct p9_fid *fid, struct p9_iattr_dotl *p9attr)
 		goto error;
 	}
 	p9_debug(P9_DEBUG_9P, "<<< RSETATTR fid %d\n", fid->fid);
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 error:
 	return err;
 }
@@ -1886,7 +1886,7 @@ int p9_client_statfs(struct p9_fid *fid, struct p9_rstatfs *sb)
 			  &sb->files, &sb->ffree, &sb->fsid, &sb->namelen);
 	if (err) {
 		trace_9p_protocol_dump(clnt, &req->rc);
-		p9_free_req(clnt, req);
+		p9_tag_remove(clnt, req);
 		goto error;
 	}
 
@@ -1897,7 +1897,7 @@ int p9_client_statfs(struct p9_fid *fid, struct p9_rstatfs *sb)
 		sb->blocks, sb->bfree, sb->bavail, sb->files,  sb->ffree,
 		sb->fsid, (long int)sb->namelen);
 
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 error:
 	return err;
 }
@@ -1925,7 +1925,7 @@ int p9_client_rename(struct p9_fid *fid,
 
 	p9_debug(P9_DEBUG_9P, "<<< RRENAME fid %d\n", fid->fid);
 
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 error:
 	return err;
 }
@@ -1955,7 +1955,7 @@ int p9_client_renameat(struct p9_fid *olddirfid, const char *old_name,
 	p9_debug(P9_DEBUG_9P, "<<< RRENAMEAT newdirfid %d new name %s\n",
 		   newdirfid->fid, new_name);
 
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 error:
 	return err;
 }
@@ -1992,10 +1992,10 @@ struct p9_fid *p9_client_xattrwalk(struct p9_fid *file_fid,
 	err = p9pdu_readf(&req->rc, clnt->proto_version, "q", attr_size);
 	if (err) {
 		trace_9p_protocol_dump(clnt, &req->rc);
-		p9_free_req(clnt, req);
+		p9_tag_remove(clnt, req);
 		goto clunk_fid;
 	}
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 	p9_debug(P9_DEBUG_9P, "<<<  RXATTRWALK fid %d size %llu\n",
 		attr_fid->fid, *attr_size);
 	return attr_fid;
@@ -2029,7 +2029,7 @@ int p9_client_xattrcreate(struct p9_fid *fid, const char *name,
 		goto error;
 	}
 	p9_debug(P9_DEBUG_9P, "<<< RXATTRCREATE fid %d\n", fid->fid);
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 error:
 	return err;
 }
@@ -2092,11 +2092,11 @@ int p9_client_readdir(struct p9_fid *fid, char *data, u32 count, u64 offset)
 	if (non_zc)
 		memmove(data, dataptr, count);
 
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 	return count;
 
 free_and_error:
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 error:
 	return err;
 }
@@ -2127,7 +2127,7 @@ int p9_client_mknod_dotl(struct p9_fid *fid, const char *name, int mode,
 				(unsigned long long)qid->path, qid->version);
 
 error:
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 	return err;
 
 }
@@ -2158,7 +2158,7 @@ int p9_client_mkdir_dotl(struct p9_fid *fid, const char *name, int mode,
 				(unsigned long long)qid->path, qid->version);
 
 error:
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 	return err;
 
 }
@@ -2191,7 +2191,7 @@ int p9_client_lock_dotl(struct p9_fid *fid, struct p9_flock *flock, u8 *status)
 	}
 	p9_debug(P9_DEBUG_9P, "<<< RLOCK status %i\n", *status);
 error:
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 	return err;
 
 }
@@ -2226,7 +2226,7 @@ int p9_client_getlock_dotl(struct p9_fid *fid, struct p9_getlock *glock)
 		"proc_id %d client_id %s\n", glock->type, glock->start,
 		glock->length, glock->proc_id, glock->client_id);
 error:
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 	return err;
 }
 EXPORT_SYMBOL(p9_client_getlock_dotl);
@@ -2252,7 +2252,7 @@ int p9_client_readlink(struct p9_fid *fid, char **target)
 	}
 	p9_debug(P9_DEBUG_9P, "<<< RREADLINK target %s\n", *target);
 error:
-	p9_free_req(clnt, req);
+	p9_tag_remove(clnt, req);
 	return err;
 }
 EXPORT_SYMBOL(p9_client_readlink);
-- 
2.20.1



