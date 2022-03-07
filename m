Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6730C4CF69B
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237893AbiCGJmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240827AbiCGJlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927C96AA4D;
        Mon,  7 Mar 2022 01:38:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E21661224;
        Mon,  7 Mar 2022 09:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B3CC340F3;
        Mon,  7 Mar 2022 09:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645896;
        bh=rMRkmQDClOKJ7+4mjLGLVxSR6PLJXwDyQbTZU1l4vh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lknYoZ5e/eX7VlHqVCq/m9I9S8qkq2Nx7lq7UqFMhGgLCA2BGGXQyYK8lLkPwU0be
         l9B65uSPogHiDJbhoIvJ8djk9PH4sLZGBgf0/J2BTFYw4pZTcVjbOLmGG926tLgeH1
         HgPLF3ZJf/M5/1d27DOQGRrhFT9sIiWKVJpxzZAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/262] NFSD: Have legacy NFSD WRITE decoders use xdr_stream_subsegment()
Date:   Mon,  7 Mar 2022 10:16:27 +0100
Message-Id: <20220307091703.738616612@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit dae9a6cab8009e526570e7477ce858dcdfeb256e ]

Refactor.

Now that the NFSv2 and NFSv3 XDR decoders have been converted to
use xdr_streams, the WRITE decoder functions can use
xdr_stream_subsegment() to extract the WRITE payload into its own
xdr_buf, just as the NFSv4 WRITE XDR decoder currently does.

That makes it possible to pass the first kvec, pages array + length,
page_base, and total payload length via a single function parameter.

The payload's page_base is not yet assigned or used, but will be in
subsequent patches.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c         |  3 +--
 fs/nfsd/nfs3xdr.c          | 12 ++----------
 fs/nfsd/nfs4proc.c         |  3 +--
 fs/nfsd/nfsproc.c          |  3 +--
 fs/nfsd/nfsxdr.c           |  9 +--------
 fs/nfsd/xdr.h              |  2 +-
 fs/nfsd/xdr3.h             |  2 +-
 include/linux/sunrpc/svc.h |  3 +--
 net/sunrpc/svc.c           | 11 ++++++-----
 9 files changed, 15 insertions(+), 33 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 9918d6ad23ec9..354bbfcd96aae 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -210,8 +210,7 @@ nfsd3_proc_write(struct svc_rqst *rqstp)
 
 	fh_copy(&resp->fh, &argp->fh);
 	resp->committed = argp->stable;
-	nvecs = svc_fill_write_vector(rqstp, rqstp->rq_arg.pages,
-				      &argp->first, cnt);
+	nvecs = svc_fill_write_vector(rqstp, &argp->payload);
 	if (!nvecs) {
 		resp->status = nfserr_io;
 		goto out;
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 7a900131d20ca..0ee156b9c9d71 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -621,9 +621,6 @@ nfs3svc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p)
 	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd3_writeargs *args = rqstp->rq_argp;
 	u32 max_blocksize = svc_max_payload(rqstp);
-	struct kvec *head = rqstp->rq_arg.head;
-	struct kvec *tail = rqstp->rq_arg.tail;
-	size_t remaining;
 
 	if (!svcxdr_decode_nfs_fh3(xdr, &args->fh))
 		return 0;
@@ -641,17 +638,12 @@ nfs3svc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p)
 	/* request sanity */
 	if (args->count != args->len)
 		return 0;
-	remaining = head->iov_len + rqstp->rq_arg.page_len + tail->iov_len;
-	remaining -= xdr_stream_pos(xdr);
-	if (remaining < xdr_align_size(args->len))
-		return 0;
 	if (args->count > max_blocksize) {
 		args->count = max_blocksize;
 		args->len = max_blocksize;
 	}
-
-	args->first.iov_base = xdr->p;
-	args->first.iov_len = head->iov_len - xdr_stream_pos(xdr);
+	if (!xdr_stream_subsegment(xdr, &args->payload, args->count))
+		return 0;
 
 	return 1;
 }
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 4b9a3b90a41ff..65200910107f3 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1038,8 +1038,7 @@ nfsd4_write(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 
 	write->wr_how_written = write->wr_stable_how;
 
-	nvecs = svc_fill_write_vector(rqstp, write->wr_payload.pages,
-				      write->wr_payload.head, write->wr_buflen);
+	nvecs = svc_fill_write_vector(rqstp, &write->wr_payload);
 	WARN_ON_ONCE(nvecs > ARRAY_SIZE(rqstp->rq_vec));
 
 	status = nfsd_vfs_write(rqstp, &cstate->current_fh, nf,
diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 19c568b8a527f..de282f3273c50 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -234,8 +234,7 @@ nfsd_proc_write(struct svc_rqst *rqstp)
 		SVCFH_fmt(&argp->fh),
 		argp->len, argp->offset);
 
-	nvecs = svc_fill_write_vector(rqstp, rqstp->rq_arg.pages,
-				      &argp->first, cnt);
+	nvecs = svc_fill_write_vector(rqstp, &argp->payload);
 	if (!nvecs) {
 		resp->status = nfserr_io;
 		goto out;
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index a06c05fe3b421..26a42f87c2409 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -325,10 +325,7 @@ nfssvc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p)
 {
 	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd_writeargs *args = rqstp->rq_argp;
-	struct kvec *head = rqstp->rq_arg.head;
-	struct kvec *tail = rqstp->rq_arg.tail;
 	u32 beginoffset, totalcount;
-	size_t remaining;
 
 	if (!svcxdr_decode_fhandle(xdr, &args->fh))
 		return 0;
@@ -346,12 +343,8 @@ nfssvc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p)
 		return 0;
 	if (args->len > NFSSVC_MAXBLKSIZE_V2)
 		return 0;
-	remaining = head->iov_len + rqstp->rq_arg.page_len + tail->iov_len;
-	remaining -= xdr_stream_pos(xdr);
-	if (remaining < xdr_align_size(args->len))
+	if (!xdr_stream_subsegment(xdr, &args->payload, args->len))
 		return 0;
-	args->first.iov_base = xdr->p;
-	args->first.iov_len = head->iov_len - xdr_stream_pos(xdr);
 
 	return 1;
 }
diff --git a/fs/nfsd/xdr.h b/fs/nfsd/xdr.h
index f45b4bc93f527..80fd6d7f3404a 100644
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -33,7 +33,7 @@ struct nfsd_writeargs {
 	svc_fh			fh;
 	__u32			offset;
 	int			len;
-	struct kvec		first;
+	struct xdr_buf		payload;
 };
 
 struct nfsd_createargs {
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index 933008382bbeb..712c117300cb7 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -40,7 +40,7 @@ struct nfsd3_writeargs {
 	__u32			count;
 	int			stable;
 	__u32			len;
-	struct kvec		first;
+	struct xdr_buf		payload;
 };
 
 struct nfsd3_createargs {
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 064c96157d1f0..6263410c948a0 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -532,8 +532,7 @@ int		   svc_encode_result_payload(struct svc_rqst *rqstp,
 					     unsigned int offset,
 					     unsigned int length);
 unsigned int	   svc_fill_write_vector(struct svc_rqst *rqstp,
-					 struct page **pages,
-					 struct kvec *first, size_t total);
+					 struct xdr_buf *payload);
 char		  *svc_fill_symlink_pathname(struct svc_rqst *rqstp,
 					     struct kvec *first, void *p,
 					     size_t total);
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index a3bbe5ce4570f..08ca797bb8a46 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1676,16 +1676,17 @@ EXPORT_SYMBOL_GPL(svc_encode_result_payload);
 /**
  * svc_fill_write_vector - Construct data argument for VFS write call
  * @rqstp: svc_rqst to operate on
- * @pages: list of pages containing data payload
- * @first: buffer containing first section of write payload
- * @total: total number of bytes of write payload
+ * @payload: xdr_buf containing only the write data payload
  *
  * Fills in rqstp::rq_vec, and returns the number of elements.
  */
-unsigned int svc_fill_write_vector(struct svc_rqst *rqstp, struct page **pages,
-				   struct kvec *first, size_t total)
+unsigned int svc_fill_write_vector(struct svc_rqst *rqstp,
+				   struct xdr_buf *payload)
 {
+	struct page **pages = payload->pages;
+	struct kvec *first = payload->head;
 	struct kvec *vec = rqstp->rq_vec;
+	size_t total = payload->len;
 	unsigned int i;
 
 	/* Some types of transport can present the write payload
-- 
2.34.1



