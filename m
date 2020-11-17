Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6BD2B6370
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732535AbgKQNiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:38:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731634AbgKQNiH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:38:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23EEE2465E;
        Tue, 17 Nov 2020 13:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620286;
        bh=9rHokNqXDrt3/W7kyFVR6/D2SJ8EngZBVc5l42VSREs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tis4M0UEZWkyOIz4DFcjal6tIGukrrEU8WJTdnUTcpVK/s9Qyu16lUIYF2FLGj1h
         KRck8Qa5WRgAbVmpOwRwyEBu5TdiTmyQmPR2cVn9bHLzR7jS7KCB73BAGOC2g/TRdj
         L8B12STr5pnSHM0K1iQTHQILvUhcafMP6I7Fpk6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 169/255] NFS: Fix listxattr receive buffer size
Date:   Tue, 17 Nov 2020 14:05:09 +0100
Message-Id: <20201117122147.162738015@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 6c2190b3fcbc92cb79e39cc7e7531656b341e463 ]

Certain NFSv4.2/RDMA tests fail with v5.9-rc1.

rpcrdma_convert_kvec() runs off the end of the rl_segments array
because rq_rcv_buf.tail[0].iov_len holds a very large positive
value. The resultant kernel memory corruption is enough to crash
the client system.

Callers of rpc_prepare_reply_pages() must reserve an extra XDR_UNIT
in the maximum decode size for a possible XDR pad of the contents
of the xdr_buf's pages. That guarantees the allocated receive buffer
will be large enough to accommodate the usual contents plus that XDR
pad word.

encode_op_hdr() cannot add that extra word. If it does,
xdr_inline_pages() underruns the length of the tail iovec.

Fixes: 3e1f02123fba ("NFSv4.2: add client side XDR handling for extended attributes")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42xdr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs42xdr.c b/fs/nfs/nfs42xdr.c
index cc50085e151c5..d0ddf90c9be48 100644
--- a/fs/nfs/nfs42xdr.c
+++ b/fs/nfs/nfs42xdr.c
@@ -179,7 +179,7 @@
 				 1 + nfs4_xattr_name_maxsz + 1)
 #define decode_setxattr_maxsz   (op_decode_hdr_maxsz + decode_change_info_maxsz)
 #define encode_listxattrs_maxsz  (op_encode_hdr_maxsz + 2 + 1)
-#define decode_listxattrs_maxsz  (op_decode_hdr_maxsz + 2 + 1 + 1)
+#define decode_listxattrs_maxsz  (op_decode_hdr_maxsz + 2 + 1 + 1 + 1)
 #define encode_removexattr_maxsz (op_encode_hdr_maxsz + 1 + \
 				  nfs4_xattr_name_maxsz)
 #define decode_removexattr_maxsz (op_decode_hdr_maxsz + \
@@ -504,7 +504,7 @@ static void encode_listxattrs(struct xdr_stream *xdr,
 {
 	__be32 *p;
 
-	encode_op_hdr(xdr, OP_LISTXATTRS, decode_listxattrs_maxsz + 1, hdr);
+	encode_op_hdr(xdr, OP_LISTXATTRS, decode_listxattrs_maxsz, hdr);
 
 	p = reserve_space(xdr, 12);
 	if (unlikely(!p))
-- 
2.27.0



