Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC8B413F668
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388364AbgAPRC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:02:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388353AbgAPRC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 045592077B;
        Thu, 16 Jan 2020 17:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194145;
        bh=2djee2Mzdhm5LjrME6B+HCK/qdkDAaWAQQU7n/IZMzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytHJ5U/FLurZzjsO/TBTD0rQ/0WDy8q5b+HpZS0GqeYgecUqp6Be2t1PaoFdP+neu
         SMcJnm8a7sVUdu8IMT3vG11zidDPQP4NorZrXQ89zgpVr2HSRTzOLy79OeLTaU/a2E
         2C+tr67UtiD4O6rFF3EPa/aIQZR6f/X9RYLRJUqI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 230/671] NFS: Add missing encode / decode sequence_maxsz to v4.2 operations
Date:   Thu, 16 Jan 2020 11:52:19 -0500
Message-Id: <20200116165940.10720-113-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 69f72ed2bf87..ec9803088f6b 100644
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

