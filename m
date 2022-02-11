Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8C54B2162
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 10:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348428AbiBKJRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 04:17:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237952AbiBKJRm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 04:17:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E1BAB
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 01:17:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A84C961E9C
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 09:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D062C340E9;
        Fri, 11 Feb 2022 09:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644571061;
        bh=vVKJJAz1vLI+mBt/QzHzN4K8Ao9xjLm9j4u4HZjyTUw=;
        h=Subject:To:Cc:From:Date:From;
        b=uCIi+bpCEohinOasATdBMdkLxBEkjYYrGdNApaqvWcnRNht8XU80DHcSGe59Z/vBY
         Q+rBN83AjVr6ycKzdHm7bkJoMs6QUBfGYXCF+mvLZ6yMiU7EDc1J8FAqgfEqmrqewN
         GFlBGfPhjS1sgGr2L05OPw3nIf3ATvUTr4Khi/BU=
Subject: FAILED: patch "[PATCH] NFSD: Fix the behavior of READ near OFFSET_MAX" failed to apply to 4.19-stable tree
To:     chuck.lever@oracle.com, dan.aloni@vastdata.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 11 Feb 2022 10:17:32 +0100
Message-ID: <1644571052212194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0cb4d23ae08c48f6bf3c29a8e5c4a74b8388b960 Mon Sep 17 00:00:00 2001
From: Chuck Lever <chuck.lever@oracle.com>
Date: Fri, 4 Feb 2022 15:19:34 -0500
Subject: [PATCH] NFSD: Fix the behavior of READ near OFFSET_MAX

Dan Aloni reports:
> Due to commit 8cfb9015280d ("NFS: Always provide aligned buffers to
> the RPC read layers") on the client, a read of 0xfff is aligned up
> to server rsize of 0x1000.
>
> As a result, in a test where the server has a file of size
> 0x7fffffffffffffff, and the client tries to read from the offset
> 0x7ffffffffffff000, the read causes loff_t overflow in the server
> and it returns an NFS code of EINVAL to the client. The client as
> a result indefinitely retries the request.

The Linux NFS client does not handle NFS?ERR_INVAL, even though all
NFS specifications permit servers to return that status code for a
READ.

Instead of NFS?ERR_INVAL, have out-of-range READ requests succeed
and return a short result. Set the EOF flag in the result to prevent
the client from retrying the READ request. This behavior appears to
be consistent with Solaris NFS servers.

Note that NFSv3 and NFSv4 use u64 offset values on the wire. These
must be converted to loff_t internally before use -- an implicit
type cast is not adequate for this purpose. Otherwise VFS checks
against sb->s_maxbytes do not work properly.

Reported-by: Dan Aloni <dan.aloni@vastdata.com>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 2c681785186f..b5a52528f19f 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -150,13 +150,17 @@ nfsd3_proc_read(struct svc_rqst *rqstp)
 	unsigned int len;
 	int v;
 
-	argp->count = min_t(u32, argp->count, max_blocksize);
-
 	dprintk("nfsd: READ(3) %s %lu bytes at %Lu\n",
 				SVCFH_fmt(&argp->fh),
 				(unsigned long) argp->count,
 				(unsigned long long) argp->offset);
 
+	argp->count = min_t(u32, argp->count, max_blocksize);
+	if (argp->offset > (u64)OFFSET_MAX)
+		argp->offset = (u64)OFFSET_MAX;
+	if (argp->offset + argp->count > (u64)OFFSET_MAX)
+		argp->count = (u64)OFFSET_MAX - argp->offset;
+
 	v = 0;
 	len = argp->count;
 	resp->pages = rqstp->rq_next_page;
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index ed1ee25647be..71d735b125a0 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -782,12 +782,16 @@ nfsd4_read(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	__be32 status;
 
 	read->rd_nf = NULL;
-	if (read->rd_offset >= OFFSET_MAX)
-		return nfserr_inval;
 
 	trace_nfsd_read_start(rqstp, &cstate->current_fh,
 			      read->rd_offset, read->rd_length);
 
+	read->rd_length = min_t(u32, read->rd_length, svc_max_payload(rqstp));
+	if (read->rd_offset > (u64)OFFSET_MAX)
+		read->rd_offset = (u64)OFFSET_MAX;
+	if (read->rd_offset + read->rd_length > (u64)OFFSET_MAX)
+		read->rd_length = (u64)OFFSET_MAX - read->rd_offset;
+
 	/*
 	 * If we do a zero copy read, then a client will see read data
 	 * that reflects the state of the file *after* performing the
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 899de438e529..f5e3430bb6ff 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3986,10 +3986,8 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
 	}
 	xdr_commit_encode(xdr);
 
-	maxcount = svc_max_payload(resp->rqstp);
-	maxcount = min_t(unsigned long, maxcount,
+	maxcount = min_t(unsigned long, read->rd_length,
 			 (xdr->buf->buflen - xdr->buf->len));
-	maxcount = min_t(unsigned long, maxcount, read->rd_length);
 
 	if (file->f_op->splice_read &&
 	    test_bit(RQ_SPLICE_OK, &resp->rqstp->rq_flags))
@@ -4826,10 +4824,8 @@ nfsd4_encode_read_plus(struct nfsd4_compoundres *resp, __be32 nfserr,
 		return nfserr_resource;
 	xdr_commit_encode(xdr);
 
-	maxcount = svc_max_payload(resp->rqstp);
-	maxcount = min_t(unsigned long, maxcount,
+	maxcount = min_t(unsigned long, read->rd_length,
 			 (xdr->buf->buflen - xdr->buf->len));
-	maxcount = min_t(unsigned long, maxcount, read->rd_length);
 	count    = maxcount;
 
 	eof = read->rd_offset >= i_size_read(file_inode(file));

