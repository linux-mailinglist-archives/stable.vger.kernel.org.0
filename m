Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C57A5CBA9
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbfGBIFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:05:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727885AbfGBIFP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:05:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 144B520659;
        Tue,  2 Jul 2019 08:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054714;
        bh=1uAF2VEZnNCpmekLPCqcTz9szVkonBBewY4/IYP6DcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNJ4eKdVopEr/RwSxcErfCt7wqPJvuc+Yx/24FDohb2EwmHSlG0XRNG3lSiCGK6vb
         9963Xb3jLGoVPNBUgrLA4ZHeXHlitfdeGnEnRpky5qfxYxwJ65p7Gefjp7zy2ZQ8Jl
         rJMZa19khJgQgOxEWDvPEkV9IkCdE37Tj0/qFmAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominique Martinet <dominique.martinet@cea.fr>,
        Jun Piao <piaojun@huawei.com>,
        Matthew Wilcox <willy@infradead.org>,
        Greg Kurz <groug@kaod.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/72] 9p: add a per-client fcall kmem_cache
Date:   Tue,  2 Jul 2019 10:01:11 +0200
Message-Id: <20190702080125.107936681@linuxfoundation.org>
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

[ Upstream commit 91a76be37ff89795526c452a6799576b03bec501 ]

Having a specific cache for the fcall allocations helps speed up
end-to-end latency.

The caches will automatically be merged if there are multiple caches
of items with the same size so we do not need to try to share a cache
between different clients of the same size.

Since the msize is negotiated with the server, only allocate the cache
after that negotiation has happened - previous allocations or
allocations of different sizes (e.g. zero-copy fcall) are made with
kmalloc directly.

Some figures on two beefy VMs with Connect-IB (sriov) / trans=rdma,
with ior running 32 processes in parallel doing small 32 bytes IOs:
 - no alloc (4.18-rc7 request cache): 65.4k req/s
 - non-power of two alloc, no patch: 61.6k req/s
 - power of two alloc, no patch: 62.2k req/s
 - non-power of two alloc, with patch: 64.7k req/s
 - power of two alloc, with patch: 65.1k req/s

Link: http://lkml.kernel.org/r/1532943263-24378-2-git-send-email-asmadeus@codewreck.org
Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
Acked-by: Jun Piao <piaojun@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Greg Kurz <groug@kaod.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/9p/9p.h     |  4 ++++
 include/net/9p/client.h |  1 +
 net/9p/client.c         | 37 ++++++++++++++++++++++++++++++++-----
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index b8eb51a661e5..4ab293f574e0 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -336,6 +336,9 @@ enum p9_qid_t {
 #define P9_NOFID	(u32)(~0)
 #define P9_MAXWELEM	16
 
+/* Minimal header size: size[4] type[1] tag[2] */
+#define P9_HDRSZ	7
+
 /* ample room for Twrite/Rread header */
 #define P9_IOHDRSZ	24
 
@@ -558,6 +561,7 @@ struct p9_fcall {
 	size_t offset;
 	size_t capacity;
 
+	struct kmem_cache *cache;
 	u8 *sdata;
 };
 
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index c2671d40bb6b..735f3979d559 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -123,6 +123,7 @@ struct p9_client {
 	struct p9_trans_module *trans_mod;
 	enum p9_trans_status status;
 	void *trans;
+	struct kmem_cache *fcall_cache;
 
 	union {
 		struct {
diff --git a/net/9p/client.c b/net/9p/client.c
index 83e39fef58e1..7ef54719c6f7 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -237,9 +237,16 @@ static int parse_opts(char *opts, struct p9_client *clnt)
 	return ret;
 }
 
-static int p9_fcall_init(struct p9_fcall *fc, int alloc_msize)
+static int p9_fcall_init(struct p9_client *c, struct p9_fcall *fc,
+			 int alloc_msize)
 {
-	fc->sdata = kmalloc(alloc_msize, GFP_NOFS);
+	if (likely(c->fcall_cache) && alloc_msize == c->msize) {
+		fc->sdata = kmem_cache_alloc(c->fcall_cache, GFP_NOFS);
+		fc->cache = c->fcall_cache;
+	} else {
+		fc->sdata = kmalloc(alloc_msize, GFP_NOFS);
+		fc->cache = NULL;
+	}
 	if (!fc->sdata)
 		return -ENOMEM;
 	fc->capacity = alloc_msize;
@@ -248,7 +255,16 @@ static int p9_fcall_init(struct p9_fcall *fc, int alloc_msize)
 
 void p9_fcall_fini(struct p9_fcall *fc)
 {
-	kfree(fc->sdata);
+	/* sdata can be NULL for interrupted requests in trans_rdma,
+	 * and kmem_cache_free does not do NULL-check for us
+	 */
+	if (unlikely(!fc->sdata))
+		return;
+
+	if (fc->cache)
+		kmem_cache_free(fc->cache, fc->sdata);
+	else
+		kfree(fc->sdata);
 }
 EXPORT_SYMBOL(p9_fcall_fini);
 
@@ -273,9 +289,9 @@ p9_tag_alloc(struct p9_client *c, int8_t type, unsigned int max_size)
 	if (!req)
 		return NULL;
 
-	if (p9_fcall_init(&req->tc, alloc_msize))
+	if (p9_fcall_init(c, &req->tc, alloc_msize))
 		goto free_req;
-	if (p9_fcall_init(&req->rc, alloc_msize))
+	if (p9_fcall_init(c, &req->rc, alloc_msize))
 		goto free;
 
 	p9pdu_reset(&req->tc);
@@ -965,6 +981,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 
 	clnt->trans_mod = NULL;
 	clnt->trans = NULL;
+	clnt->fcall_cache = NULL;
 
 	client_id = utsname()->nodename;
 	memcpy(clnt->name, client_id, strlen(client_id) + 1);
@@ -1008,6 +1025,15 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	if (err)
 		goto close_trans;
 
+	/* P9_HDRSZ + 4 is the smallest packet header we can have that is
+	 * followed by data accessed from userspace by read
+	 */
+	clnt->fcall_cache =
+		kmem_cache_create_usercopy("9p-fcall-cache", clnt->msize,
+					   0, 0, P9_HDRSZ + 4,
+					   clnt->msize - (P9_HDRSZ + 4),
+					   NULL);
+
 	return clnt;
 
 close_trans:
@@ -1039,6 +1065,7 @@ void p9_client_destroy(struct p9_client *clnt)
 
 	p9_tag_cleanup(clnt);
 
+	kmem_cache_destroy(clnt->fcall_cache);
 	kfree(clnt);
 }
 EXPORT_SYMBOL(p9_client_destroy);
-- 
2.20.1



