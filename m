Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 521E7594C8A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245099AbiHPArL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245439AbiHPApk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:45:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5434D4773;
        Mon, 15 Aug 2022 13:40:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6252160F60;
        Mon, 15 Aug 2022 20:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB344C433C1;
        Mon, 15 Aug 2022 20:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596056;
        bh=47gk8JO9TD1qGRsrfrjdeiC39DRWKDDmOxDlwO2Yxuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k9F/qomQy9vCq+FMjN6O8tjiQ7D5gTNcUW/U6eAivqKKtXJH/ZI6OeNLChP327ICK
         MXQPkv5rEjps8KD4UN9NmDlrgbV634Qt9hyA6m2QYm6kbZST7U6vsBh9DOaqNLDIG8
         oItz3zdNvdMYaTx2SRFZsJQOAXv7KNo+xF1P/+f8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0959/1157] 9p: Add client parameter to p9_req_put()
Date:   Mon, 15 Aug 2022 20:05:15 +0200
Message-Id: <20220815180517.994837921@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Kent Overstreet <kent.overstreet@gmail.com>

[ Upstream commit 8b11ff098af42b1fa57fc817daadd53c8b244a0c ]

This is to aid in adding mempools, in the next patch.

Link: https://lkml.kernel.org/r/20220704014243.153050-2-kent.overstreet@gmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/9p/client.h |  2 +-
 net/9p/client.c         | 12 ++++++------
 net/9p/trans_fd.c       | 12 ++++++------
 net/9p/trans_rdma.c     |  2 +-
 net/9p/trans_virtio.c   |  4 ++--
 net/9p/trans_xen.c      |  2 +-
 6 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index c038c2d73dae..cb78e0e33332 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -235,7 +235,7 @@ static inline int p9_req_try_get(struct p9_req_t *r)
 	return refcount_inc_not_zero(&r->refcount);
 }
 
-int p9_req_put(struct p9_req_t *r);
+int p9_req_put(struct p9_client *c, struct p9_req_t *r);
 
 void p9_client_cb(struct p9_client *c, struct p9_req_t *req, int status);
 
diff --git a/net/9p/client.c b/net/9p/client.c
index 0ee48e8b7220..a36a40137caa 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -341,7 +341,7 @@ struct p9_req_t *p9_tag_lookup(struct p9_client *c, u16 tag)
 		if (!p9_req_try_get(req))
 			goto again;
 		if (req->tc.tag != tag) {
-			p9_req_put(req);
+			p9_req_put(c, req);
 			goto again;
 		}
 	}
@@ -367,10 +367,10 @@ static int p9_tag_remove(struct p9_client *c, struct p9_req_t *r)
 	spin_lock_irqsave(&c->lock, flags);
 	idr_remove(&c->reqs, tag);
 	spin_unlock_irqrestore(&c->lock, flags);
-	return p9_req_put(r);
+	return p9_req_put(c, r);
 }
 
-int p9_req_put(struct p9_req_t *r)
+int p9_req_put(struct p9_client *c, struct p9_req_t *r)
 {
 	if (refcount_dec_and_test(&r->refcount)) {
 		p9_fcall_fini(&r->tc);
@@ -423,7 +423,7 @@ void p9_client_cb(struct p9_client *c, struct p9_req_t *req, int status)
 
 	wake_up(&req->wq);
 	p9_debug(P9_DEBUG_MUX, "wakeup: %d\n", req->tc.tag);
-	p9_req_put(req);
+	p9_req_put(c, req);
 }
 EXPORT_SYMBOL(p9_client_cb);
 
@@ -706,7 +706,7 @@ static struct p9_req_t *p9_client_prepare_req(struct p9_client *c,
 reterr:
 	p9_tag_remove(c, req);
 	/* We have to put also the 2nd reference as it won't be used */
-	p9_req_put(req);
+	p9_req_put(c, req);
 	return ERR_PTR(err);
 }
 
@@ -743,7 +743,7 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 	err = c->trans_mod->request(c, req);
 	if (err < 0) {
 		/* write won't happen */
-		p9_req_put(req);
+		p9_req_put(c, req);
 		if (err != -ERESTARTSYS && err != -EFAULT)
 			c->status = Disconnected;
 		goto recalc_sigpending;
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 8f8f95e39b03..007c3f45fe05 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -378,7 +378,7 @@ static void p9_read_work(struct work_struct *work)
 		m->rc.sdata = NULL;
 		m->rc.offset = 0;
 		m->rc.capacity = 0;
-		p9_req_put(m->rreq);
+		p9_req_put(m->client, m->rreq);
 		m->rreq = NULL;
 	}
 
@@ -492,7 +492,7 @@ static void p9_write_work(struct work_struct *work)
 	m->wpos += err;
 	if (m->wpos == m->wsize) {
 		m->wpos = m->wsize = 0;
-		p9_req_put(m->wreq);
+		p9_req_put(m->client, m->wreq);
 		m->wreq = NULL;
 	}
 
@@ -695,7 +695,7 @@ static int p9_fd_cancel(struct p9_client *client, struct p9_req_t *req)
 	if (req->status == REQ_STATUS_UNSENT) {
 		list_del(&req->req_list);
 		req->status = REQ_STATUS_FLSHD;
-		p9_req_put(req);
+		p9_req_put(client, req);
 		ret = 0;
 	}
 	spin_unlock(&client->lock);
@@ -722,7 +722,7 @@ static int p9_fd_cancelled(struct p9_client *client, struct p9_req_t *req)
 	list_del(&req->req_list);
 	req->status = REQ_STATUS_FLSHD;
 	spin_unlock(&client->lock);
-	p9_req_put(req);
+	p9_req_put(client, req);
 
 	return 0;
 }
@@ -883,12 +883,12 @@ static void p9_conn_destroy(struct p9_conn *m)
 	p9_mux_poll_stop(m);
 	cancel_work_sync(&m->rq);
 	if (m->rreq) {
-		p9_req_put(m->rreq);
+		p9_req_put(m->client, m->rreq);
 		m->rreq = NULL;
 	}
 	cancel_work_sync(&m->wq);
 	if (m->wreq) {
-		p9_req_put(m->wreq);
+		p9_req_put(m->client, m->wreq);
 		m->wreq = NULL;
 	}
 
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 88e563826674..d817d3745238 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -350,7 +350,7 @@ send_done(struct ib_cq *cq, struct ib_wc *wc)
 			    c->busa, c->req->tc.size,
 			    DMA_TO_DEVICE);
 	up(&rdma->sq_sem);
-	p9_req_put(c->req);
+	p9_req_put(client, c->req);
 	kfree(c);
 }
 
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index b24a4fb0f0a2..147972bf2e79 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -199,7 +199,7 @@ static int p9_virtio_cancel(struct p9_client *client, struct p9_req_t *req)
 /* Reply won't come, so drop req ref */
 static int p9_virtio_cancelled(struct p9_client *client, struct p9_req_t *req)
 {
-	p9_req_put(req);
+	p9_req_put(client, req);
 	return 0;
 }
 
@@ -523,7 +523,7 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 	kvfree(out_pages);
 	if (!kicked) {
 		/* reply won't come */
-		p9_req_put(req);
+		p9_req_put(client, req);
 	}
 	return err;
 }
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 833cd3792c51..227f89cc7237 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -163,7 +163,7 @@ static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
 	ring->intf->out_prod = prod;
 	spin_unlock_irqrestore(&ring->lock, flags);
 	notify_remote_via_irq(ring->irq);
-	p9_req_put(p9_req);
+	p9_req_put(client, p9_req);
 
 	return 0;
 }
-- 
2.35.1



