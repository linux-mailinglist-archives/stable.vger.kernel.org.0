Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8192E99EB
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbhADQE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:04:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:40970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728095AbhADQDe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:03:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B86122516;
        Mon,  4 Jan 2021 16:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776173;
        bh=TBFURPubX4lJg4Bp/uUQfXFe64zJLuJrE0DcFxmIhis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ULQIIaa2watUVEbDzaf1+BE70vlxwGOTKPULJG2ghpIduIxdloeHjdE68CHBEytSY
         jyaqVyd1tPDN34yB2sjusNIMsvoENeiLfZ9Ds1WRVAPAA6DzmuKjQVoLbaok6d9q3e
         ZKm71xeIIaSOKc7MTQFYV8iCPuHUPs4/Kg+3wu1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 54/63] NFSv4.2: Dont error when exiting early on a READ_PLUS buffer overflow
Date:   Mon,  4 Jan 2021 16:57:47 +0100
Message-Id: <20210104155711.434974524@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 503b934a752f7e789a5f33217520e0a79f3096ac ]

Expanding the READ_PLUS extents can cause the read buffer to overflow.
If it does, then don't error, but just exit early.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42xdr.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/nfs/nfs42xdr.c b/fs/nfs/nfs42xdr.c
index 8432bd6b95f08..c078f88552695 100644
--- a/fs/nfs/nfs42xdr.c
+++ b/fs/nfs/nfs42xdr.c
@@ -1019,29 +1019,24 @@ static int decode_deallocate(struct xdr_stream *xdr, struct nfs42_falloc_res *re
 	return decode_op_hdr(xdr, OP_DEALLOCATE);
 }
 
-static int decode_read_plus_data(struct xdr_stream *xdr, struct nfs_pgio_res *res,
-				 uint32_t *eof)
+static int decode_read_plus_data(struct xdr_stream *xdr,
+				 struct nfs_pgio_res *res)
 {
 	uint32_t count, recvd;
 	uint64_t offset;
 	__be32 *p;
 
 	p = xdr_inline_decode(xdr, 8 + 4);
-	if (unlikely(!p))
-		return -EIO;
+	if (!p)
+		return 1;
 
 	p = xdr_decode_hyper(p, &offset);
 	count = be32_to_cpup(p);
 	recvd = xdr_align_data(xdr, res->count, count);
 	res->count += recvd;
 
-	if (count > recvd) {
-		dprintk("NFS: server cheating in read reply: "
-				"count %u > recvd %u\n", count, recvd);
-		*eof = 0;
+	if (count > recvd)
 		return 1;
-	}
-
 	return 0;
 }
 
@@ -1052,18 +1047,16 @@ static int decode_read_plus_hole(struct xdr_stream *xdr, struct nfs_pgio_res *re
 	__be32 *p;
 
 	p = xdr_inline_decode(xdr, 8 + 8);
-	if (unlikely(!p))
-		return -EIO;
+	if (!p)
+		return 1;
 
 	p = xdr_decode_hyper(p, &offset);
 	p = xdr_decode_hyper(p, &length);
 	recvd = xdr_expand_hole(xdr, res->count, length);
 	res->count += recvd;
 
-	if (recvd < length) {
-		*eof = 0;
+	if (recvd < length)
 		return 1;
-	}
 	return 0;
 }
 
@@ -1088,12 +1081,12 @@ static int decode_read_plus(struct xdr_stream *xdr, struct nfs_pgio_res *res)
 
 	for (i = 0; i < segments; i++) {
 		p = xdr_inline_decode(xdr, 4);
-		if (unlikely(!p))
-			return -EIO;
+		if (!p)
+			goto early_out;
 
 		type = be32_to_cpup(p++);
 		if (type == NFS4_CONTENT_DATA)
-			status = decode_read_plus_data(xdr, res, &eof);
+			status = decode_read_plus_data(xdr, res);
 		else if (type == NFS4_CONTENT_HOLE)
 			status = decode_read_plus_hole(xdr, res, &eof);
 		else
@@ -1102,12 +1095,17 @@ static int decode_read_plus(struct xdr_stream *xdr, struct nfs_pgio_res *res)
 		if (status < 0)
 			return status;
 		if (status > 0)
-			break;
+			goto early_out;
 	}
 
 out:
 	res->eof = eof;
 	return 0;
+early_out:
+	if (unlikely(!i))
+		return -EIO;
+	res->eof = 0;
+	return 0;
 }
 
 static int decode_seek(struct xdr_stream *xdr, struct nfs42_seek_res *res)
-- 
2.27.0



