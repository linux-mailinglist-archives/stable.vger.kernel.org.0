Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF1548001C
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239159AbhL0PnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:43:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239152AbhL0PlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:41:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21483C0617A1;
        Mon, 27 Dec 2021 07:40:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4294610D5;
        Mon, 27 Dec 2021 15:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6FAC36AE7;
        Mon, 27 Dec 2021 15:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619645;
        bh=NcODNvOgON29ieKun7CvYvZBq/LoecKcJDKuZe6YOEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZTq7Oae4c4tss3KiH9+3C77IrbOUA3CsmUQE/X3EGPmi7mkc0OXeqqgsN7ocj6uF
         oxsqeXE0S2kc3Ryi/OidZMWZ3YaRQwNWcnx/AH0BwNRpQQtGgALSY4QkHe7zprOd6B
         CSOQy0iEBjNWZUb+wTHIe7+VOzTDvXjQcz5SFvMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anatoly Trosinenko <anatoly.trosinenko@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 009/128] NFSD: Fix READDIR buffer overflow
Date:   Mon, 27 Dec 2021 16:29:44 +0100
Message-Id: <20211227151331.809131485@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 53b1119a6e5028b125f431a0116ba73510d82a72 upstream.

If a client sends a READDIR count argument that is too small (say,
zero), then the buffer size calculation in the new init_dirlist
helper functions results in an underflow, allowing the XDR stream
functions to write beyond the actual buffer.

This calculation has always been suspect. NFSD has never sanity-
checked the READDIR count argument, but the old entry encoders
managed the problem correctly.

With the commits below, entry encoding changed, exposing the
underflow to the pointer arithmetic in xdr_reserve_space().

Modern NFS clients attempt to retrieve as much data as possible
for each READDIR request. Also, we have no unit tests that
exercise the behavior of READDIR at the lower bound of @count
values. Thus this case was missed during testing.

Reported-by: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Fixes: f5dcccd647da ("NFSD: Update the NFSv2 READDIR entry encoder to use struct xdr_stream")
Fixes: 7f87fc2d34d4 ("NFSD: Update NFSv3 READDIR entry encoders to use struct xdr_stream")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs3proc.c |   11 ++++-------
 fs/nfsd/nfsproc.c  |    8 ++++----
 2 files changed, 8 insertions(+), 11 deletions(-)

--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -439,22 +439,19 @@ nfsd3_proc_link(struct svc_rqst *rqstp)
 
 static void nfsd3_init_dirlist_pages(struct svc_rqst *rqstp,
 				     struct nfsd3_readdirres *resp,
-				     int count)
+				     u32 count)
 {
 	struct xdr_buf *buf = &resp->dirlist;
 	struct xdr_stream *xdr = &resp->xdr;
 
-	count = min_t(u32, count, svc_max_payload(rqstp));
+	count = clamp(count, (u32)(XDR_UNIT * 2), svc_max_payload(rqstp));
 
 	memset(buf, 0, sizeof(*buf));
 
 	/* Reserve room for the NULL ptr & eof flag (-2 words) */
 	buf->buflen = count - XDR_UNIT * 2;
 	buf->pages = rqstp->rq_next_page;
-	while (count > 0) {
-		rqstp->rq_next_page++;
-		count -= PAGE_SIZE;
-	}
+	rqstp->rq_next_page += (buf->buflen + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	/* This is xdr_init_encode(), but it assumes that
 	 * the head kvec has already been consumed. */
@@ -463,7 +460,7 @@ static void nfsd3_init_dirlist_pages(str
 	xdr->page_ptr = buf->pages;
 	xdr->iov = NULL;
 	xdr->p = page_address(*buf->pages);
-	xdr->end = xdr->p + (PAGE_SIZE >> 2);
+	xdr->end = (void *)xdr->p + min_t(u32, buf->buflen, PAGE_SIZE);
 	xdr->rqst = NULL;
 }
 
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -557,17 +557,17 @@ nfsd_proc_rmdir(struct svc_rqst *rqstp)
 
 static void nfsd_init_dirlist_pages(struct svc_rqst *rqstp,
 				    struct nfsd_readdirres *resp,
-				    int count)
+				    u32 count)
 {
 	struct xdr_buf *buf = &resp->dirlist;
 	struct xdr_stream *xdr = &resp->xdr;
 
-	count = min_t(u32, count, PAGE_SIZE);
+	count = clamp(count, (u32)(XDR_UNIT * 2), svc_max_payload(rqstp));
 
 	memset(buf, 0, sizeof(*buf));
 
 	/* Reserve room for the NULL ptr & eof flag (-2 words) */
-	buf->buflen = count - sizeof(__be32) * 2;
+	buf->buflen = count - XDR_UNIT * 2;
 	buf->pages = rqstp->rq_next_page;
 	rqstp->rq_next_page++;
 
@@ -578,7 +578,7 @@ static void nfsd_init_dirlist_pages(stru
 	xdr->page_ptr = buf->pages;
 	xdr->iov = NULL;
 	xdr->p = page_address(*buf->pages);
-	xdr->end = xdr->p + (PAGE_SIZE >> 2);
+	xdr->end = (void *)xdr->p + min_t(u32, buf->buflen, PAGE_SIZE);
 	xdr->rqst = NULL;
 }
 


