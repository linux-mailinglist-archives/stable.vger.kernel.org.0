Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF83321666
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhBVMWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:22:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231158AbhBVMR7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:17:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7771764E4B;
        Mon, 22 Feb 2021 12:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996264;
        bh=Lp96/hbN9zF85s2USitS9aMGi0YbHNb+X/E9qNrrWbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxc6LCHxl65EyKJMlPrIBNel8IH6dkTk+2c9Inj+LIow6aKPlftND/qvuNkcGQdhv
         xW4YXkb7nbu6cZR7ejM1IY5ceZl2jRR2bMO9Xbq3r6otGPpL/MAEr1DqPBriFYR8VM
         1ucRgGhh9p8N/KW84iH2UEx+fmsJ6HyMhazvZfZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.19 36/50] ovl: expand warning in ovl_d_real()
Date:   Mon, 22 Feb 2021 13:13:27 +0100
Message-Id: <20210222121026.317653245@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
References: <20210222121019.925481519@linuxfoundation.org>
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
@@ -82,7 +82,7 @@ static void ovl_dentry_release(struct de
 static struct dentry *ovl_d_real(struct dentry *dentry,
 				 const struct inode *inode)
 {
-	struct dentry *real;
+	struct dentry *real = NULL, *lower;
 
 	/* It's an overlay file */
 	if (inode && d_inode(dentry) == inode)
@@ -101,9 +101,10 @@ static struct dentry *ovl_d_real(struct
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
@@ -111,8 +112,10 @@ static struct dentry *ovl_d_real(struct
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
 


