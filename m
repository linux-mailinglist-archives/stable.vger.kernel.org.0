Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4F3303397
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730444AbhAZE7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:59:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731104AbhAYSuu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:50:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 826E8207B3;
        Mon, 25 Jan 2021 18:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600597;
        bh=5jnrlHnylrYAHa/akBJ9ZvTWQzQ1pKGPovbDQaIXsEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vXs4UgRZIse6ahGcpZ/5DeJepQ/gUk2HbV/SID/YNg+2r26rmsF02W67ALZb2o5aa
         NeNEYr9OlKzh6rW4TgLq0d26aY6G7794CvFDFwl+swZBZFYFPO3N4cfZqE1mo4c8w9
         IsjuG3N/S6f1Q35oum5Djgu3eg61gvRyR8brIvh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/199] nfsd: Fixes for nfsd4_encode_read_plus_data()
Date:   Mon, 25 Jan 2021 19:38:18 +0100
Message-Id: <20210125183219.474286489@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 72d78717c6d06adf65d2e3dccc96d9e9dc978593 ]

Ensure that we encode the data payload + padding, and that we truncate
the preallocated buffer to the actual read size.

Fixes: 528b84934eb9 ("NFSD: Add READ_PLUS data support")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 833a2c64dfe80..26f6e277101de 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -4632,6 +4632,7 @@ nfsd4_encode_read_plus_data(struct nfsd4_compoundres *resp,
 			    resp->rqstp->rq_vec, read->rd_vlen, maxcount, eof);
 	if (nfserr)
 		return nfserr;
+	xdr_truncate_encode(xdr, starting_len + 16 + xdr_align_size(*maxcount));
 
 	tmp = htonl(NFS4_CONTENT_DATA);
 	write_bytes_to_xdr_buf(xdr->buf, starting_len,      &tmp,   4);
@@ -4639,6 +4640,10 @@ nfsd4_encode_read_plus_data(struct nfsd4_compoundres *resp,
 	write_bytes_to_xdr_buf(xdr->buf, starting_len + 4,  &tmp64, 8);
 	tmp = htonl(*maxcount);
 	write_bytes_to_xdr_buf(xdr->buf, starting_len + 12, &tmp,   4);
+
+	tmp = xdr_zero;
+	write_bytes_to_xdr_buf(xdr->buf, starting_len + 16 + *maxcount, &tmp,
+			       xdr_pad_size(*maxcount));
 	return nfs_ok;
 }
 
-- 
2.27.0



