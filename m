Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D52BA106A20
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfKVKcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:32:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727547AbfKVKcD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:32:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B85062077B;
        Fri, 22 Nov 2019 10:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418722;
        bh=/yiiXOWAr9PvapQdaj5ekwCQqFmwzeoTbzKcrhuHjvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7FTCVhM3YS3QD9HaW78/4MBqiD8H1wsSAdbdbK2AFmfdN4OyD/d9NgCldccIPosd
         vhkZvL7qrUXB+IyXWOP/+kZG3Rp3tn3MTtdpa/WJRv0NWX08rrORUlBhF+fsR1d+CC
         xywplSGxHYxdfloGUfy/o1jX2HB7bkwnuEACkCsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.4 006/159] ecryptfs_lookup_interpose(): lower_dentry->d_inode is not stable
Date:   Fri, 22 Nov 2019 11:26:37 +0100
Message-Id: <20191122100710.046390303@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
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
@@ -330,7 +330,7 @@ static int ecryptfs_lookup_interpose(str
 				     struct dentry *lower_dentry,
 				     struct inode *dir_inode)
 {
-	struct inode *inode, *lower_inode = d_inode(lower_dentry);
+	struct inode *inode, *lower_inode;
 	struct ecryptfs_dentry_info *dentry_info;
 	struct vfsmount *lower_mnt;
 	int rc = 0;
@@ -352,7 +352,15 @@ static int ecryptfs_lookup_interpose(str
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
 		return 0;


