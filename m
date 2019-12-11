Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C7811B64C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730610AbfLKP76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:59:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731536AbfLKPN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E948C24654;
        Wed, 11 Dec 2019 15:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077237;
        bh=LGW7v87sNgdj7lp4cac8DXf/BuQaHXMOQQGoLFkmpZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKpPVzOo9XpfVsE460KoARdwU5mpvXWOcrRDZSEVflB3doKmuUBSj8lkcFxMHXrXg
         cVzdxDW+8TRRgR+9godw0ZQWy+7PUV/9VT77+Dg5gTgZdfoGP32z161OCReL1ipU9b
         od0hKycPVJUMrG7p8bH+L2aUqocWzeMh6sfTDdnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 5.3 068/105] nfsd: Ensure CLONE persists data and metadata changes to the target file
Date:   Wed, 11 Dec 2019 16:05:57 +0100
Message-Id: <20191211150249.287893236@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

commit a25e3726b32c746c0098125d4c7463bb84df72bb upstream.

The NFSv4.2 CLONE operation has implicit persistence requirements on the
target file, since there is no protocol requirement that the client issue
a separate operation to persist data.
For that reason, we should call vfs_fsync_range() on the destination file
after a successful call to vfs_clone_file_range().

Fixes: ffa0160a1039 ("nfsd: implement the NFSv4.2 CLONE operation")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: stable@vger.kernel.org # v4.5+
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4proc.c |    3 ++-
 fs/nfsd/vfs.c      |    8 +++++++-
 fs/nfsd/vfs.h      |    2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1083,7 +1083,8 @@ nfsd4_clone(struct svc_rqst *rqstp, stru
 		goto out;
 
 	status = nfsd4_clone_file_range(src, clone->cl_src_pos,
-			dst, clone->cl_dst_pos, clone->cl_count);
+			dst, clone->cl_dst_pos, clone->cl_count,
+			EX_ISSYNC(cstate->current_fh.fh_export));
 
 	fput(dst);
 	fput(src);
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -552,7 +552,7 @@ __be32 nfsd4_set_nfs4_label(struct svc_r
 #endif
 
 __be32 nfsd4_clone_file_range(struct file *src, u64 src_pos, struct file *dst,
-		u64 dst_pos, u64 count)
+		u64 dst_pos, u64 count, bool sync)
 {
 	loff_t cloned;
 
@@ -561,6 +561,12 @@ __be32 nfsd4_clone_file_range(struct fil
 		return nfserrno(cloned);
 	if (count && cloned != count)
 		return nfserrno(-EINVAL);
+	if (sync) {
+		loff_t dst_end = count ? dst_pos + count - 1 : LLONG_MAX;
+		int status = vfs_fsync_range(dst, dst_pos, dst_end, 0);
+		if (status < 0)
+			return nfserrno(status);
+	}
 	return 0;
 }
 
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -58,7 +58,7 @@ __be32          nfsd4_set_nfs4_label(str
 __be32		nfsd4_vfs_fallocate(struct svc_rqst *, struct svc_fh *,
 				    struct file *, loff_t, loff_t, int);
 __be32		nfsd4_clone_file_range(struct file *, u64, struct file *,
-			u64, u64);
+				       u64, u64, bool);
 #endif /* CONFIG_NFSD_V4 */
 __be32		nfsd_create_locked(struct svc_rqst *, struct svc_fh *,
 				char *name, int len, struct iattr *attrs,


