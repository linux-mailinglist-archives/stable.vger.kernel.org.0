Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F2B4B49D5
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346225AbiBNKRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:17:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347676AbiBNKQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:16:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1898C7CA;
        Mon, 14 Feb 2022 01:54:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3DF4B80DFE;
        Mon, 14 Feb 2022 09:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D327AC340E9;
        Mon, 14 Feb 2022 09:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832451;
        bh=JsS9Skp3vsyC7yBa+nz/KP8/8m1F36/h6fchRD4RKj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPeuNRTlI9oR0bvOl6j5X28YgKiqpNOcL6KpBoOL1TSEClbB+og134VSaze5CvVLa
         lLuqGk6wSoKvsbRGgCfEcTJ0gV/O7oJyaG86rcS4HyVZTzfS9bxnwgaoHGI1LSZ/ze
         81fQwWmrkV3VHXkGPCHa3I0TBdGKZCR+TKUsILj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Aloni <dan.aloni@vastdata.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.16 019/203] NFSD: Fix the behavior of READ near OFFSET_MAX
Date:   Mon, 14 Feb 2022 10:24:23 +0100
Message-Id: <20220214092510.871536905@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 0cb4d23ae08c48f6bf3c29a8e5c4a74b8388b960 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs3proc.c |    8 ++++++--
 fs/nfsd/nfs4proc.c |    8 ++++++--
 fs/nfsd/nfs4xdr.c  |    8 ++------
 3 files changed, 14 insertions(+), 10 deletions(-)

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
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -782,12 +782,16 @@ nfsd4_read(struct svc_rqst *rqstp, struc
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
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3997,10 +3997,8 @@ nfsd4_encode_read(struct nfsd4_compoundr
 	}
 	xdr_commit_encode(xdr);
 
-	maxcount = svc_max_payload(resp->rqstp);
-	maxcount = min_t(unsigned long, maxcount,
+	maxcount = min_t(unsigned long, read->rd_length,
 			 (xdr->buf->buflen - xdr->buf->len));
-	maxcount = min_t(unsigned long, maxcount, read->rd_length);
 
 	if (file->f_op->splice_read &&
 	    test_bit(RQ_SPLICE_OK, &resp->rqstp->rq_flags))
@@ -4837,10 +4835,8 @@ nfsd4_encode_read_plus(struct nfsd4_comp
 		return nfserr_resource;
 	xdr_commit_encode(xdr);
 
-	maxcount = svc_max_payload(resp->rqstp);
-	maxcount = min_t(unsigned long, maxcount,
+	maxcount = min_t(unsigned long, read->rd_length,
 			 (xdr->buf->buflen - xdr->buf->len));
-	maxcount = min_t(unsigned long, maxcount, read->rd_length);
 	count    = maxcount;
 
 	eof = read->rd_offset >= i_size_read(file_inode(file));


