Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A9E24B3A9
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbgHTJum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729744AbgHTJub (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:50:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70E3A206B5;
        Thu, 20 Aug 2020 09:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917031;
        bh=CKmop5NxXMa6Qh4q5NPvZefp3Hs//G66zjEg9SEtlnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TWdWuwI8MTxnnZ7J+8ArKzhQfaHf4kahYIfP6VHXZpuQvhijoyRZAIPYtClCyM93B
         VhCeFXROLq4Va04prcsd/oG9HSbKbDEIkJ9ACsQqhYnnJi8tXC+P9sU0/Ivvs5sEBR
         +JIxl1ojeroJSa7GimoNs2P+lOvr0jb1+AMIUnNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jeffrey Mitchell <jeffrey.mitchell@starlab.io>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 131/152] nfs: Fix getxattr kernel panic and memory overflow
Date:   Thu, 20 Aug 2020 11:21:38 +0200
Message-Id: <20200820091600.521265080@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>

[ Upstream commit b4487b93545214a9db8cbf32e86411677b0cca21 ]

Move the buffer size check to decode_attr_security_label() before memcpy()
Only call memcpy() if the buffer is large enough

Fixes: aa9c2669626c ("NFS: Client implementation of Labeled-NFS")
Signed-off-by: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
[Trond: clean up duplicate test of label->len != 0]
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 2 --
 fs/nfs/nfs4xdr.c  | 6 +++++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 1a1bd2fe6e98d..d0cb827b72cfa 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5811,8 +5811,6 @@ static int _nfs4_get_security_label(struct inode *inode, void *buf,
 		return ret;
 	if (!(fattr.valid & NFS_ATTR_FATTR_V4_SECURITY_LABEL))
 		return -ENOENT;
-	if (buflen < label.len)
-		return -ERANGE;
 	return 0;
 }
 
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 7c0ff1a3b5914..677751bc3a334 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4169,7 +4169,11 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
 			return -EIO;
 		if (len < NFS4_MAXLABELLEN) {
 			if (label) {
-				memcpy(label->label, p, len);
+				if (label->len) {
+					if (label->len < len)
+						return -ERANGE;
+					memcpy(label->label, p, len);
+				}
 				label->len = len;
 				label->pi = pi;
 				label->lfs = lfs;
-- 
2.25.1



