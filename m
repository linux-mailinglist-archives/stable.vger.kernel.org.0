Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 856E3101315
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbfKSFWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:22:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:37454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727675AbfKSFWL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:22:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A721F2231A;
        Tue, 19 Nov 2019 05:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140931;
        bh=SCTuBEqWLwhkUYPmE0gc4km31qBJp+HRBi+UPqTJucc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xOxJzEp1WrrqR5nFCrO0OFZslnyo1iCvXTvYhuIIUBTug8AWNtWNUjuZhOGd+3AS2
         YmRaGEuZR+mpX2iuep8skjEMxJrtDjnT5IF/dvZkrcjuhm3XuNO04MXZuRJ4Ie+ea1
         obEaC4pbmKTxIOKAaAWxyciOZup7sYUqOAaChx24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.3 34/48] ecryptfs_lookup_interpose(): lower_dentry->d_inode is not stable
Date:   Tue, 19 Nov 2019 06:19:54 +0100
Message-Id: <20191119051014.638038858@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit e72b9dd6a5f17d0fb51f16f8685f3004361e83d0 upstream.

lower_dentry can't go from positive to negative (we have it pinned),
but it *can* go from negative to positive.  So fetching ->d_inode
into a local variable, doing a blocking allocation, checking that
now ->d_inode is non-NULL and feeding the value we'd fetched
earlier to a function that won't accept NULL is not a good idea.

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/inode.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -311,7 +311,7 @@ static int ecryptfs_i_size_read(struct d
 static struct dentry *ecryptfs_lookup_interpose(struct dentry *dentry,
 				     struct dentry *lower_dentry)
 {
-	struct inode *inode, *lower_inode = d_inode(lower_dentry);
+	struct inode *inode, *lower_inode;
 	struct ecryptfs_dentry_info *dentry_info;
 	struct vfsmount *lower_mnt;
 	int rc = 0;
@@ -331,7 +331,15 @@ static struct dentry *ecryptfs_lookup_in
 	dentry_info->lower_path.mnt = lower_mnt;
 	dentry_info->lower_path.dentry = lower_dentry;
 
-	if (d_really_is_negative(lower_dentry)) {
+	/*
+	 * negative dentry can go positive under us here - its parent is not
+	 * locked.  That's OK and that could happen just as we return from
+	 * ecryptfs_lookup() anyway.  Just need to be careful and fetch
+	 * ->d_inode only once - it's not stable here.
+	 */
+	lower_inode = READ_ONCE(lower_dentry->d_inode);
+
+	if (!lower_inode) {
 		/* We want to add because we couldn't find in lower */
 		d_add(dentry, NULL);
 		return NULL;


