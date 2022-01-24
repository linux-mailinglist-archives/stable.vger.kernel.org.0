Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB93499A6A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378627AbiAXVoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:44:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53028 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454740AbiAXVdd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:33:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BE3361028;
        Mon, 24 Jan 2022 21:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272E6C340E4;
        Mon, 24 Jan 2022 21:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060011;
        bh=Hwn0nBZSSS2Ox64jgXZDFCc5FEy6ow4iGWRyL3BCMjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKNQhUzEOyk49WXgykN/k42uBbMRNSeXbpHuWVGbn7LfcjfnKwzxUDNSjeQzi8UGM
         MV+hzW89MZF0IjjRqb9n1daYNjgWUBT/AC6nOThntBGILXIICMfKOeK+b+bpmUe4QN
         Uk6pBtoGkXKwg4oIH1EfHGi5FtapmPaC1Ic492oI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0810/1039] Revert "nfsd: skip some unnecessary stats in the v4 case"
Date:   Mon, 24 Jan 2022 19:43:19 +0100
Message-Id: <20220124184152.541304852@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 58f258f65267542959487dbe8b5641754411843d ]

On the wire, I observed NFSv4 OPEN(CREATE) operations sometimes
returning a reasonable-looking value in the cinfo.before field and
zero in the cinfo.after field.

RFC 8881 Section 10.8.1 says:
> When a client is making changes to a given directory, it needs to
> determine whether there have been changes made to the directory by
> other clients.  It does this by using the change attribute as
> reported before and after the directory operation in the associated
> change_info4 value returned for the operation.

and

> ... The post-operation change
> value needs to be saved as the basis for future change_info4
> comparisons.

A good quality client implementation therefore saves the zero
cinfo.after value. During a subsequent OPEN operation, it will
receive a different non-zero value in the cinfo.before field for
that directory, and it will incorrectly believe the directory has
changed, triggering an undesirable directory cache invalidation.

There are filesystem types where fs_supports_change_attribute()
returns false, tmpfs being one. On NFSv4 mounts, this means the
fh_getattr() call site in fill_pre_wcc() and fill_post_wcc() is
never invoked. Subsequently, nfsd4_change_attribute() is invoked
with an uninitialized @stat argument.

In fill_pre_wcc(), @stat contains stale stack garbage, which is
then placed on the wire. In fill_post_wcc(), ->fh_post_wc is all
zeroes, so zero is placed on the wire. Both of these values are
meaningless.

This fix can be applied immediately to stable kernels. Once there
are more regression tests in this area, this optimization can be
attempted again.

Fixes: 428a23d2bf0c ("nfsd: skip some unnecessary stats in the v4 case")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 44 +++++++++++++++++---------------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index c3ac1b6aa3aaa..84088581bbe09 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -487,11 +487,6 @@ neither:
 	return true;
 }
 
-static bool fs_supports_change_attribute(struct super_block *sb)
-{
-	return sb->s_flags & SB_I_VERSION || sb->s_export_op->fetch_iversion;
-}
-
 /*
  * Fill in the pre_op attr for the wcc data
  */
@@ -500,26 +495,24 @@ void fill_pre_wcc(struct svc_fh *fhp)
 	struct inode    *inode;
 	struct kstat	stat;
 	bool v4 = (fhp->fh_maxsize == NFS4_FHSIZE);
+	__be32 err;
 
 	if (fhp->fh_no_wcc || fhp->fh_pre_saved)
 		return;
 	inode = d_inode(fhp->fh_dentry);
-	if (fs_supports_change_attribute(inode->i_sb) || !v4) {
-		__be32 err = fh_getattr(fhp, &stat);
-
-		if (err) {
-			/* Grab the times from inode anyway */
-			stat.mtime = inode->i_mtime;
-			stat.ctime = inode->i_ctime;
-			stat.size  = inode->i_size;
-		}
-		fhp->fh_pre_mtime = stat.mtime;
-		fhp->fh_pre_ctime = stat.ctime;
-		fhp->fh_pre_size  = stat.size;
+	err = fh_getattr(fhp, &stat);
+	if (err) {
+		/* Grab the times from inode anyway */
+		stat.mtime = inode->i_mtime;
+		stat.ctime = inode->i_ctime;
+		stat.size  = inode->i_size;
 	}
 	if (v4)
 		fhp->fh_pre_change = nfsd4_change_attribute(&stat, inode);
 
+	fhp->fh_pre_mtime = stat.mtime;
+	fhp->fh_pre_ctime = stat.ctime;
+	fhp->fh_pre_size  = stat.size;
 	fhp->fh_pre_saved = true;
 }
 
@@ -530,6 +523,7 @@ void fill_post_wcc(struct svc_fh *fhp)
 {
 	bool v4 = (fhp->fh_maxsize == NFS4_FHSIZE);
 	struct inode *inode = d_inode(fhp->fh_dentry);
+	__be32 err;
 
 	if (fhp->fh_no_wcc)
 		return;
@@ -537,16 +531,12 @@ void fill_post_wcc(struct svc_fh *fhp)
 	if (fhp->fh_post_saved)
 		printk("nfsd: inode locked twice during operation.\n");
 
-	fhp->fh_post_saved = true;
-
-	if (fs_supports_change_attribute(inode->i_sb) || !v4) {
-		__be32 err = fh_getattr(fhp, &fhp->fh_post_attr);
-
-		if (err) {
-			fhp->fh_post_saved = false;
-			fhp->fh_post_attr.ctime = inode->i_ctime;
-		}
-	}
+	err = fh_getattr(fhp, &fhp->fh_post_attr);
+	if (err) {
+		fhp->fh_post_saved = false;
+		fhp->fh_post_attr.ctime = inode->i_ctime;
+	} else
+		fhp->fh_post_saved = true;
 	if (v4)
 		fhp->fh_post_change =
 			nfsd4_change_attribute(&fhp->fh_post_attr, inode);
-- 
2.34.1



