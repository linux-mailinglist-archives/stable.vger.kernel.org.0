Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 788365CBA5
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbfGBIPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727230AbfGBIFV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:05:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7783B21841;
        Tue,  2 Jul 2019 08:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054720;
        bh=DVbWl661h8fKpGSMoDH+GeHAFMhCmBHPf/PTz2W5Xe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIsqtWqbQepiCiE8OOeAdDfWqXjuQTAEB31lZ7EscnQxJt972+FdKv+jWWcCCwjyI
         wGumCfREVSBePjwHWOWCwFwnd2LwClWBKZs3FcajmiNEnWznB3UKQ3s4YqMY0ypihg
         1iCNFVEM/1q3OJX15J1vjK+VE3JeiU0yEiV7uJrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Bortoli <tomasbortoli@gmail.com>,
        syzbot+467050c1ce275af2a5b8@syzkaller.appspotmail.com,
        Dominique Martinet <dominique.martinet@cea.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/72] 9p: Add refcount to p9_req_t
Date:   Tue,  2 Jul 2019 10:01:13 +0200
Message-Id: <20190702080125.223711175@linuxfoundation.org>
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

[ Upstream commit 728356dedeff8ef999cb436c71333ef4ac51a81c ]

To avoid use-after-free(s), use a refcount to keep track of the
usable references to any instantiated struct p9_req_t.

This commit adds p9_req_put(), p9_req_get() and p9_req_try_get() as
wrappers to kref_put(), kref_get() and kref_get_unless_zero().
These are used by the client and the transports to keep track of
valid requests' references.

p9_free_req() is added back and used as callback by kref_put().

Add SLAB_TYPESAFE_BY_RCU as it ensures that the memory freed by
kmem_cache_free() will not be reused for another type until the rcu
synchronisation period is over, so an address gotten under rcu read
lock is safe to inc_ref() without corrupting random memory while
the lock is held.

Link: http://lkml.kernel.org/r/1535626341-20693-1-git-send-email-asmadeus@codewreck.org
Co-developed-by: Dominique Martinet <dominique.martinet@cea.fr>
Signed-off-by: Tomas Bortoli <tomasbortoli@gmail.com>
Reported-by: syzbot+467050c1ce275af2a5b8@syzkaller.appspotmail.com
Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/9p/client.h | 14 ++++++++++
 net/9p/client.c         | 57 ++++++++++++++++++++++++++++++++++++-----
 net/9p/trans_fd.c       | 11 +++++++-
 net/9p/trans_rdma.c     |  1 +
 net/9p/trans_virtio.c   | 26 ++++++++++++++++---
 net/9p/trans_xen.c      |  1 +
 6 files changed, 98 insertions(+), 12 deletions(-)

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 735f3979d559..947a570307a6 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -94,6 +94,7 @@ enum p9_req_status_t {
 struct p9_req_t {
 	int status;
 	int t_err;
+	struct kref refcount;
 	wait_queue_head_t wq;
 	struct p9_fcall tc;
 	struct p9_fcall rc;
@@ -233,6 +234,19 @@ int p9_client_lock_dotl(struct p9_fid *fid, struct p9_flock *flock, u8 *status);
 int p9_client_getlock_dotl(struct p9_fid *fid, struct p9_getlock *fl);
 void p9_fcall_fini(struct p9_fcall *fc);
 struct p9_req_t *p9_tag_lookup(struct p9_client *, u16);
+
+static inline void p9_req_get(struct p9_req_t *r)
+{
+	kref_get(&r->refcount);
+}
+
+static inline int p9_req_try_get(struct p9_req_t *r)
+{
+	return kref_get_unless_zero(&r->refcount);
+}
+
+int p9_req_put(struct p9_req_t *r);
+
 void p9_client_cb(struct p9_client *c, struct p9_req_t *req, int status);
 
 int p9_parse_header(struct p9_fcall *, int32_t *, int8_t *, int16_t *, int);
diff --git a/net/9p/client.c b/net/9p/client.c
index 3cde9f619980..4becde979462 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -313,6 +313,18 @@ p9_tag_alloc(struct p9_client *c, int8_t type, unsigned int max_size)
 	if (tag < 0)
 		goto free;
 
+	/* Init ref to two because in the general case there is one ref
+	 * that is put asynchronously by a writer thread, one ref
+	 * temporarily given by p9_tag_lookup and put by p9_client_cb
+	 * in the recv thread, and one ref put by p9_tag_remove in the
+	 * main thread. The only exception is virtio that does not use
+	 * p9_tag_lookup but does not have a writer thread either
+	 * (the write happens synchronously in the request/zc_request
+	 * callback), so p9_client_cb eats the second ref there
+	 * as the pointer is duplicated directly by virtqueue_add_sgs()
+	 */
+	refcount_set(&req->refcount.refcount, 2);
+
 	return req;
 
 free:
@@ -336,10 +348,21 @@ struct p9_req_t *p9_tag_lookup(struct p9_client *c, u16 tag)
 	struct p9_req_t *req;
 
 	rcu_read_lock();
+again:
 	req = idr_find(&c->reqs, tag);
-	/* There's no refcount on the req; a malicious server could cause
-	 * us to dereference a NULL pointer
-	 */
+	if (req) {
+		/* We have to be careful with the req found under rcu_read_lock
+		 * Thanks to SLAB_TYPESAFE_BY_RCU we can safely try to get the
+		 * ref again without corrupting other data, then check again
+		 * that the tag matches once we have the ref
+		 */
+		if (!p9_req_try_get(req))
+			goto again;
+		if (req->tc.tag != tag) {
+			p9_req_put(req);
+			goto again;
+		}
+	}
 	rcu_read_unlock();
 
 	return req;
@@ -353,7 +376,7 @@ EXPORT_SYMBOL(p9_tag_lookup);
  *
  * Context: Any context.
  */
-static void p9_tag_remove(struct p9_client *c, struct p9_req_t *r)
+static int p9_tag_remove(struct p9_client *c, struct p9_req_t *r)
 {
 	unsigned long flags;
 	u16 tag = r->tc.tag;
@@ -362,11 +385,23 @@ static void p9_tag_remove(struct p9_client *c, struct p9_req_t *r)
 	spin_lock_irqsave(&c->lock, flags);
 	idr_remove(&c->reqs, tag);
 	spin_unlock_irqrestore(&c->lock, flags);
+	return p9_req_put(r);
+}
+
+static void p9_req_free(struct kref *ref)
+{
+	struct p9_req_t *r = container_of(ref, struct p9_req_t, refcount);
 	p9_fcall_fini(&r->tc);
 	p9_fcall_fini(&r->rc);
 	kmem_cache_free(p9_req_cache, r);
 }
 
+int p9_req_put(struct p9_req_t *r)
+{
+	return kref_put(&r->refcount, p9_req_free);
+}
+EXPORT_SYMBOL(p9_req_put);
+
 /**
  * p9_tag_cleanup - cleans up tags structure and reclaims resources
  * @c:  v9fs client struct
@@ -382,7 +417,9 @@ static void p9_tag_cleanup(struct p9_client *c)
 	rcu_read_lock();
 	idr_for_each_entry(&c->reqs, req, id) {
 		pr_info("Tag %d still in use\n", id);
-		p9_tag_remove(c, req);
+		if (p9_tag_remove(c, req) == 0)
+			pr_warn("Packet with tag %d has still references",
+				req->tc.tag);
 	}
 	rcu_read_unlock();
 }
@@ -406,6 +443,7 @@ void p9_client_cb(struct p9_client *c, struct p9_req_t *req, int status)
 
 	wake_up(&req->wq);
 	p9_debug(P9_DEBUG_MUX, "wakeup: %d\n", req->tc.tag);
+	p9_req_put(req);
 }
 EXPORT_SYMBOL(p9_client_cb);
 
@@ -646,9 +684,10 @@ static int p9_client_flush(struct p9_client *c, struct p9_req_t *oldreq)
 	 * if we haven't received a response for oldreq,
 	 * remove it from the list
 	 */
-	if (oldreq->status == REQ_STATUS_SENT)
+	if (oldreq->status == REQ_STATUS_SENT) {
 		if (c->trans_mod->cancelled)
 			c->trans_mod->cancelled(c, oldreq);
+	}
 
 	p9_tag_remove(c, req);
 	return 0;
@@ -685,6 +724,8 @@ static struct p9_req_t *p9_client_prepare_req(struct p9_client *c,
 	return req;
 reterr:
 	p9_tag_remove(c, req);
+	/* We have to put also the 2nd reference as it won't be used */
+	p9_req_put(req);
 	return ERR_PTR(err);
 }
 
@@ -719,6 +760,8 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 
 	err = c->trans_mod->request(c, req);
 	if (err < 0) {
+		/* write won't happen */
+		p9_req_put(req);
 		if (err != -ERESTARTSYS && err != -EFAULT)
 			c->status = Disconnected;
 		goto recalc_sigpending;
@@ -2259,7 +2302,7 @@ EXPORT_SYMBOL(p9_client_readlink);
 
 int __init p9_client_init(void)
 {
-	p9_req_cache = KMEM_CACHE(p9_req_t, 0);
+	p9_req_cache = KMEM_CACHE(p9_req_t, SLAB_TYPESAFE_BY_RCU);
 	return p9_req_cache ? 0 : -ENOMEM;
 }
 
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 51615c0fb744..aca528722183 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -132,6 +132,7 @@ struct p9_conn {
 	struct list_head req_list;
 	struct list_head unsent_req_list;
 	struct p9_req_t *req;
+	struct p9_req_t *wreq;
 	char tmp_buf[7];
 	struct p9_fcall rc;
 	int wpos;
@@ -383,6 +384,7 @@ static void p9_read_work(struct work_struct *work)
 		m->rc.sdata = NULL;
 		m->rc.offset = 0;
 		m->rc.capacity = 0;
+		p9_req_put(m->req);
 		m->req = NULL;
 	}
 
@@ -472,6 +474,8 @@ static void p9_write_work(struct work_struct *work)
 		m->wbuf = req->tc.sdata;
 		m->wsize = req->tc.size;
 		m->wpos = 0;
+		p9_req_get(req);
+		m->wreq = req;
 		spin_unlock(&m->client->lock);
 	}
 
@@ -492,8 +496,11 @@ static void p9_write_work(struct work_struct *work)
 	}
 
 	m->wpos += err;
-	if (m->wpos == m->wsize)
+	if (m->wpos == m->wsize) {
 		m->wpos = m->wsize = 0;
+		p9_req_put(m->wreq);
+		m->wreq = NULL;
+	}
 
 end_clear:
 	clear_bit(Wworksched, &m->wsched);
@@ -694,6 +701,7 @@ static int p9_fd_cancel(struct p9_client *client, struct p9_req_t *req)
 	if (req->status == REQ_STATUS_UNSENT) {
 		list_del(&req->req_list);
 		req->status = REQ_STATUS_FLSHD;
+		p9_req_put(req);
 		ret = 0;
 	}
 	spin_unlock(&client->lock);
@@ -711,6 +719,7 @@ static int p9_fd_cancelled(struct p9_client *client, struct p9_req_t *req)
 	spin_lock(&client->lock);
 	list_del(&req->req_list);
 	spin_unlock(&client->lock);
+	p9_req_put(req);
 
 	return 0;
 }
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 5b0cda1aaa7a..9cc9b3a19ee7 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -365,6 +365,7 @@ send_done(struct ib_cq *cq, struct ib_wc *wc)
 			    c->busa, c->req->tc.size,
 			    DMA_TO_DEVICE);
 	up(&rdma->sq_sem);
+	p9_req_put(c->req);
 	kfree(c);
 }
 
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 3dd6ce1c0f2d..eb596c2ed546 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -207,6 +207,13 @@ static int p9_virtio_cancel(struct p9_client *client, struct p9_req_t *req)
 	return 1;
 }
 
+/* Reply won't come, so drop req ref */
+static int p9_virtio_cancelled(struct p9_client *client, struct p9_req_t *req)
+{
+	p9_req_put(req);
+	return 0;
+}
+
 /**
  * pack_sg_list_p - Just like pack_sg_list. Instead of taking a buffer,
  * this takes a list of pages.
@@ -404,6 +411,7 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 	struct scatterlist *sgs[4];
 	size_t offs;
 	int need_drop = 0;
+	int kicked = 0;
 
 	p9_debug(P9_DEBUG_TRANS, "virtio request\n");
 
@@ -411,8 +419,10 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 		__le32 sz;
 		int n = p9_get_mapped_pages(chan, &out_pages, uodata,
 					    outlen, &offs, &need_drop);
-		if (n < 0)
-			return n;
+		if (n < 0) {
+			err = n;
+			goto err_out;
+		}
 		out_nr_pages = DIV_ROUND_UP(n + offs, PAGE_SIZE);
 		if (n != outlen) {
 			__le32 v = cpu_to_le32(n);
@@ -428,8 +438,10 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 	} else if (uidata) {
 		int n = p9_get_mapped_pages(chan, &in_pages, uidata,
 					    inlen, &offs, &need_drop);
-		if (n < 0)
-			return n;
+		if (n < 0) {
+			err = n;
+			goto err_out;
+		}
 		in_nr_pages = DIV_ROUND_UP(n + offs, PAGE_SIZE);
 		if (n != inlen) {
 			__le32 v = cpu_to_le32(n);
@@ -498,6 +510,7 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 	}
 	virtqueue_kick(chan->vq);
 	spin_unlock_irqrestore(&chan->lock, flags);
+	kicked = 1;
 	p9_debug(P9_DEBUG_TRANS, "virtio request kicked\n");
 	err = wait_event_killable(req->wq, req->status >= REQ_STATUS_RCVD);
 	/*
@@ -518,6 +531,10 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 	}
 	kvfree(in_pages);
 	kvfree(out_pages);
+	if (!kicked) {
+		/* reply won't come */
+		p9_req_put(req);
+	}
 	return err;
 }
 
@@ -750,6 +767,7 @@ static struct p9_trans_module p9_virtio_trans = {
 	.request = p9_virtio_request,
 	.zc_request = p9_virtio_zc_request,
 	.cancel = p9_virtio_cancel,
+	.cancelled = p9_virtio_cancelled,
 	/*
 	 * We leave one entry for input and one entry for response
 	 * headers. We also skip one more entry to accomodate, address
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 782a07f2ad0c..e2fbf3677b9b 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -185,6 +185,7 @@ static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
 	ring->intf->out_prod = prod;
 	spin_unlock_irqrestore(&ring->lock, flags);
 	notify_remote_via_irq(ring->irq);
+	p9_req_put(p9_req);
 
 	return 0;
 }
-- 
2.20.1



