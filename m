Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B82431BE37
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 17:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbhBOQDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 11:03:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:53696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231829AbhBOPtj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:49:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D9C764E51;
        Mon, 15 Feb 2021 15:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403300;
        bh=3nh+QiYmUMSitgBwXEnFguLJUlFGGPN6t8DLeVwDXX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFYwuEjIRsQlB3N5Z8BSyQkCSGqe5ZRhh3dBTGw4w6whsfEH50GXqc5b4WzN43lZy
         irpZ198C4KpP7sKB7dv5bEHinblQysQsCouYkZynZJ112rWXbMF/nN4gUfAkOpt3+U
         XJpxLoedWjKwBLC3PbGvRCn1JWaIlSux/yJJLOVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.10 103/104] ovl: expand warning in ovl_d_real()
Date:   Mon, 15 Feb 2021 16:27:56 +0100
Message-Id: <20210215152722.792877588@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit cef4cbff06fbc3be54d6d79ee139edecc2ee8598 upstream.

There was a syzbot report with this warning but insufficient information...

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/super.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -79,7 +79,7 @@ static void ovl_dentry_release(struct de
 static struct dentry *ovl_d_real(struct dentry *dentry,
 				 const struct inode *inode)
 {
-	struct dentry *real;
+	struct dentry *real = NULL, *lower;
 
 	/* It's an overlay file */
 	if (inode && d_inode(dentry) == inode)
@@ -98,9 +98,10 @@ static struct dentry *ovl_d_real(struct
 	if (real && !inode && ovl_has_upperdata(d_inode(dentry)))
 		return real;
 
-	real = ovl_dentry_lowerdata(dentry);
-	if (!real)
+	lower = ovl_dentry_lowerdata(dentry);
+	if (!lower)
 		goto bug;
+	real = lower;
 
 	/* Handle recursion */
 	real = d_real(real, inode);
@@ -108,8 +109,10 @@ static struct dentry *ovl_d_real(struct
 	if (!inode || inode == d_inode(real))
 		return real;
 bug:
-	WARN(1, "ovl_d_real(%pd4, %s:%lu): real dentry not found\n", dentry,
-	     inode ? inode->i_sb->s_id : "NULL", inode ? inode->i_ino : 0);
+	WARN(1, "%s(%pd4, %s:%lu): real dentry (%p/%lu) not found\n",
+	     __func__, dentry, inode ? inode->i_sb->s_id : "NULL",
+	     inode ? inode->i_ino : 0, real,
+	     real && d_inode(real) ? d_inode(real)->i_ino : 0);
 	return dentry;
 }
 


