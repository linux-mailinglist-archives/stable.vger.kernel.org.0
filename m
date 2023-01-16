Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD3E66C823
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbjAPQgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbjAPQgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:36:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54AD730EA8
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:24:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1276B81077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41452C433EF;
        Mon, 16 Jan 2023 16:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886282;
        bh=AMocFMS+Hs77VOqRO1Sz6eVAXrViQyU/xeojGcUNQb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jj/2O4hCsdRP/5VKlGIjXoNBLeOKFgCgzq/thGj/xd9dkUQ7yDYLk10lfodo98Xxo
         +tDK4ZHRXUq5Jthu58jmDpUpS9HdKumuArpsOnVO/H3rkYPBGNM6v58a2axu4hrPHz
         KcXxpfjmzHeJa4WfqDNmr04nK/SROmHZNSZjls/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kbuild test robot <lkp@intel.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 371/658] NFSD: Add tracepoints to NFSDs duplicate reply cache
Date:   Mon, 16 Jan 2023 16:47:39 +0100
Message-Id: <20230116154926.548347449@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 0b175b18648ebedfe255b11a7792f1d76848a8f7 ]

Try to capture DRC failures.

Two additional clean-ups:
- Introduce Doxygen-style comments for the main entry points
- Remove a dprintk that fires for an allocation failure. This was
  the only dprintk in the REPCACHE class.

Reported-by: kbuild test robot <lkp@intel.com>
[ cel: force typecast for display of checksum values ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 3bc8edc98bd4 ("nfsd: under NFSv4.1, fix double svc_xprt_put on rpc_create failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfscache.c | 57 +++++++++++++++++++++++++++-----------------
 fs/nfsd/trace.h    | 59 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 94 insertions(+), 22 deletions(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index 670e97dd67f0..80c90fc231a5 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -20,8 +20,7 @@
 
 #include "nfsd.h"
 #include "cache.h"
-
-#define NFSDDBG_FACILITY	NFSDDBG_REPCACHE
+#include "trace.h"
 
 /*
  * We use this value to determine the number of hash buckets from the max
@@ -324,8 +323,10 @@ nfsd_cache_key_cmp(const struct svc_cacherep *key,
 			const struct svc_cacherep *rp, struct nfsd_net *nn)
 {
 	if (key->c_key.k_xid == rp->c_key.k_xid &&
-	    key->c_key.k_csum != rp->c_key.k_csum)
+	    key->c_key.k_csum != rp->c_key.k_csum) {
 		++nn->payload_misses;
+		trace_nfsd_drc_mismatch(nn, key, rp);
+	}
 
 	return memcmp(&key->c_key, &rp->c_key, sizeof(key->c_key));
 }
@@ -378,15 +379,22 @@ nfsd_cache_insert(struct nfsd_drc_bucket *b, struct svc_cacherep *key,
 	return ret;
 }
 
-/*
+/**
+ * nfsd_cache_lookup - Find an entry in the duplicate reply cache
+ * @rqstp: Incoming Call to find
+ *
  * Try to find an entry matching the current call in the cache. When none
  * is found, we try to grab the oldest expired entry off the LRU list. If
  * a suitable one isn't there, then drop the cache_lock and allocate a
  * new one, then search again in case one got inserted while this thread
  * didn't hold the lock.
+ *
+ * Return values:
+ *   %RC_DOIT: Process the request normally
+ *   %RC_REPLY: Reply from cache
+ *   %RC_DROPIT: Do not process the request further
  */
-int
-nfsd_cache_lookup(struct svc_rqst *rqstp)
+int nfsd_cache_lookup(struct svc_rqst *rqstp)
 {
 	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
 	struct svc_cacherep	*rp, *found;
@@ -400,7 +408,7 @@ nfsd_cache_lookup(struct svc_rqst *rqstp)
 	rqstp->rq_cacherep = NULL;
 	if (type == RC_NOCACHE) {
 		nfsdstats.rcnocache++;
-		return rtn;
+		goto out;
 	}
 
 	csum = nfsd_cache_csum(rqstp);
@@ -410,10 +418,8 @@ nfsd_cache_lookup(struct svc_rqst *rqstp)
 	 * preallocate an entry.
 	 */
 	rp = nfsd_reply_cache_alloc(rqstp, csum, nn);
-	if (!rp) {
-		dprintk("nfsd: unable to allocate DRC entry!\n");
-		return rtn;
-	}
+	if (!rp)
+		goto out;
 
 	spin_lock(&b->cache_lock);
 	found = nfsd_cache_insert(b, rp, nn);
@@ -432,8 +438,10 @@ nfsd_cache_lookup(struct svc_rqst *rqstp)
 
 	/* go ahead and prune the cache */
 	prune_bucket(b, nn);
- out:
+
+out_unlock:
 	spin_unlock(&b->cache_lock);
+out:
 	return rtn;
 
 found_entry:
@@ -443,13 +451,13 @@ nfsd_cache_lookup(struct svc_rqst *rqstp)
 
 	/* Request being processed */
 	if (rp->c_state == RC_INPROG)
-		goto out;
+		goto out_trace;
 
 	/* From the hall of fame of impractical attacks:
 	 * Is this a user who tries to snoop on the cache? */
 	rtn = RC_DOIT;
 	if (!test_bit(RQ_SECURE, &rqstp->rq_flags) && rp->c_secure)
-		goto out;
+		goto out_trace;
 
 	/* Compose RPC reply header */
 	switch (rp->c_type) {
@@ -461,20 +469,26 @@ nfsd_cache_lookup(struct svc_rqst *rqstp)
 		break;
 	case RC_REPLBUFF:
 		if (!nfsd_cache_append(rqstp, &rp->c_replvec))
-			goto out;	/* should not happen */
+			goto out_unlock; /* should not happen */
 		rtn = RC_REPLY;
 		break;
 	default:
 		WARN_ONCE(1, "nfsd: bad repcache type %d\n", rp->c_type);
 	}
 
-	goto out;
+out_trace:
+	trace_nfsd_drc_found(nn, rqstp, rtn);
+	goto out_unlock;
 }
 
-/*
- * Update a cache entry. This is called from nfsd_dispatch when
- * the procedure has been executed and the complete reply is in
- * rqstp->rq_res.
+/**
+ * nfsd_cache_update - Update an entry in the duplicate reply cache.
+ * @rqstp: svc_rqst with a finished Reply
+ * @cachetype: which cache to update
+ * @statp: Reply's status code
+ *
+ * This is called from nfsd_dispatch when the procedure has been
+ * executed and the complete reply is in rqstp->rq_res.
  *
  * We're copying around data here rather than swapping buffers because
  * the toplevel loop requires max-sized buffers, which would be a waste
@@ -487,8 +501,7 @@ nfsd_cache_lookup(struct svc_rqst *rqstp)
  * nfsd failed to encode a reply that otherwise would have been cached.
  * In this case, nfsd_cache_update is called with statp == NULL.
  */
-void
-nfsd_cache_update(struct svc_rqst *rqstp, int cachetype, __be32 *statp)
+void nfsd_cache_update(struct svc_rqst *rqstp, int cachetype, __be32 *statp)
 {
 	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
 	struct svc_cacherep *rp = rqstp->rq_cacherep;
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index dc6aae4ef41d..9d37d09d7ca8 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -310,6 +310,65 @@ TRACE_EVENT(nfsd_file_fsnotify_handle_event,
 			__entry->nlink, __entry->mode, __entry->mask)
 );
 
+#include "cache.h"
+
+TRACE_DEFINE_ENUM(RC_DROPIT);
+TRACE_DEFINE_ENUM(RC_REPLY);
+TRACE_DEFINE_ENUM(RC_DOIT);
+
+#define show_drc_retval(x)						\
+	__print_symbolic(x,						\
+		{ RC_DROPIT, "DROPIT" },				\
+		{ RC_REPLY, "REPLY" },					\
+		{ RC_DOIT, "DOIT" })
+
+TRACE_EVENT(nfsd_drc_found,
+	TP_PROTO(
+		const struct nfsd_net *nn,
+		const struct svc_rqst *rqstp,
+		int result
+	),
+	TP_ARGS(nn, rqstp, result),
+	TP_STRUCT__entry(
+		__field(unsigned long long, boot_time)
+		__field(unsigned long, result)
+		__field(u32, xid)
+	),
+	TP_fast_assign(
+		__entry->boot_time = nn->boot_time;
+		__entry->result = result;
+		__entry->xid = be32_to_cpu(rqstp->rq_xid);
+	),
+	TP_printk("boot_time=%16llx xid=0x%08x result=%s",
+		__entry->boot_time, __entry->xid,
+		show_drc_retval(__entry->result))
+
+);
+
+TRACE_EVENT(nfsd_drc_mismatch,
+	TP_PROTO(
+		const struct nfsd_net *nn,
+		const struct svc_cacherep *key,
+		const struct svc_cacherep *rp
+	),
+	TP_ARGS(nn, key, rp),
+	TP_STRUCT__entry(
+		__field(unsigned long long, boot_time)
+		__field(u32, xid)
+		__field(u32, cached)
+		__field(u32, ingress)
+	),
+	TP_fast_assign(
+		__entry->boot_time = nn->boot_time;
+		__entry->xid = be32_to_cpu(key->c_key.k_xid);
+		__entry->cached = (__force u32)key->c_key.k_csum;
+		__entry->ingress = (__force u32)rp->c_key.k_csum;
+	),
+	TP_printk("boot_time=%16llx xid=0x%08x cached-csum=0x%08x ingress-csum=0x%08x",
+		__entry->boot_time, __entry->xid, __entry->cached,
+		__entry->ingress)
+);
+
 #endif /* _NFSD_TRACE_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.35.1



