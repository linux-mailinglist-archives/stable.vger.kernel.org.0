Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D4114809D
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388174AbgAXLMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:12:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389259AbgAXLMp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:12:45 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F53220708;
        Fri, 24 Jan 2020 11:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864364;
        bh=vEm1+NPJNQEMaNckZljDmlqsaG7Su1fq4a6m5EJQ1FA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4YfztREjgM5TlUWBoqt4dZh+GZjpc2QsGoDwp7GnEDnITdr3kTkVUZttcWGvIFai
         EiiwSKM76XDZ2elwQgQw3hTVBjs7P/sDK+zLg+NIqmJnKpSjUoNSRGfgViEEXVQTdP
         yfo87SKNQCsgZuy2Hl8gyw57EawtJlX/T/IYpUeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 246/639] NFS: Add missing encode / decode sequence_maxsz to v4.2 operations
Date:   Fri, 24 Jan 2020 10:26:56 +0100
Message-Id: <20200124093117.589155216@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

[ Upstream commit 1a3466aed3a17eed41cd9411f89eb637f58349b0 ]

These really should have been there from the beginning, but we never
noticed because there was enough slack in the RPC request for the extra
bytes. Chuck's recent patch to use au_cslack and au_rslack to compute
buffer size shrunk the buffer enough that this was now a problem for
SEEK operations on my test client.

Fixes: f4ac1674f5da4 ("nfs: Add ALLOCATE support")
Fixes: 2e72448b07dc3 ("NFS: Add COPY nfs operation")
Fixes: cb95deea0b4aa ("NFS OFFLOAD_CANCEL xdr")
Fixes: 624bd5b7b683c ("nfs: Add DEALLOCATE support")
Fixes: 1c6dcbe5ceff8 ("NFS: Implement SEEK")
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42xdr.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/nfs/nfs42xdr.c b/fs/nfs/nfs42xdr.c
index 69f72ed2bf879..ec9803088f6b8 100644
--- a/fs/nfs/nfs42xdr.c
+++ b/fs/nfs/nfs42xdr.c
@@ -59,43 +59,53 @@
 #define decode_clone_maxsz		(op_decode_hdr_maxsz)
 
 #define NFS4_enc_allocate_sz		(compound_encode_hdr_maxsz + \
+					 encode_sequence_maxsz + \
 					 encode_putfh_maxsz + \
 					 encode_allocate_maxsz + \
 					 encode_getattr_maxsz)
 #define NFS4_dec_allocate_sz		(compound_decode_hdr_maxsz + \
+					 decode_sequence_maxsz + \
 					 decode_putfh_maxsz + \
 					 decode_allocate_maxsz + \
 					 decode_getattr_maxsz)
 #define NFS4_enc_copy_sz		(compound_encode_hdr_maxsz + \
+					 encode_sequence_maxsz + \
 					 encode_putfh_maxsz + \
 					 encode_savefh_maxsz + \
 					 encode_putfh_maxsz + \
 					 encode_copy_maxsz + \
 					 encode_commit_maxsz)
 #define NFS4_dec_copy_sz		(compound_decode_hdr_maxsz + \
+					 decode_sequence_maxsz + \
 					 decode_putfh_maxsz + \
 					 decode_savefh_maxsz + \
 					 decode_putfh_maxsz + \
 					 decode_copy_maxsz + \
 					 decode_commit_maxsz)
 #define NFS4_enc_offload_cancel_sz	(compound_encode_hdr_maxsz + \
+					 encode_sequence_maxsz + \
 					 encode_putfh_maxsz + \
 					 encode_offload_cancel_maxsz)
 #define NFS4_dec_offload_cancel_sz	(compound_decode_hdr_maxsz + \
+					 decode_sequence_maxsz + \
 					 decode_putfh_maxsz + \
 					 decode_offload_cancel_maxsz)
 #define NFS4_enc_deallocate_sz		(compound_encode_hdr_maxsz + \
+					 encode_sequence_maxsz + \
 					 encode_putfh_maxsz + \
 					 encode_deallocate_maxsz + \
 					 encode_getattr_maxsz)
 #define NFS4_dec_deallocate_sz		(compound_decode_hdr_maxsz + \
+					 decode_sequence_maxsz + \
 					 decode_putfh_maxsz + \
 					 decode_deallocate_maxsz + \
 					 decode_getattr_maxsz)
 #define NFS4_enc_seek_sz		(compound_encode_hdr_maxsz + \
+					 encode_sequence_maxsz + \
 					 encode_putfh_maxsz + \
 					 encode_seek_maxsz)
 #define NFS4_dec_seek_sz		(compound_decode_hdr_maxsz + \
+					 decode_sequence_maxsz + \
 					 decode_putfh_maxsz + \
 					 decode_seek_maxsz)
 #define NFS4_enc_layoutstats_sz		(compound_encode_hdr_maxsz + \
-- 
2.20.1



