Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2C527C605
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbgI2LlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730617AbgI2LlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:41:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F5872065C;
        Tue, 29 Sep 2020 11:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379665;
        bh=DE7SCW9moeshv/1VrDqcJQRsTInKF3qjHMUPLCrLqTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPIpyVoxgW4t1Mj5Clqme3mtL+c717RkYVzgrUn+9VJofb5/WHth0wzryF3cD1aLl
         vYa//7QLVTLudyYK6s4bdP7YsbaPxv+wHtdZ5nTZiwGx7NlomEBfE9ttGmh1E46DGl
         ibcr1I1yZd6MMSpCly9OHPrYcU75kG9DDRW/o0Us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Rusek <rusek@9livesdata.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 265/388] fuse: update attr_version counter on fuse_notify_inval_inode()
Date:   Tue, 29 Sep 2020 12:59:56 +0200
Message-Id: <20200929110023.297864166@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 5ddd9ced9aef6cfa76af27d384c17c9e2d610ce8 ]

A GETATTR request can race with FUSE_NOTIFY_INVAL_INODE, resulting in the
attribute cache being updated with stale information after the
invalidation.

Fix this by bumping the attribute version in fuse_reverse_inval_inode().

Reported-by: Krzysztof Rusek <rusek@9livesdata.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 5dca643a257c9..f58ab84b09fb3 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -323,6 +323,8 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 int fuse_reverse_inval_inode(struct super_block *sb, u64 nodeid,
 			     loff_t offset, loff_t len)
 {
+	struct fuse_conn *fc = get_fuse_conn_super(sb);
+	struct fuse_inode *fi;
 	struct inode *inode;
 	pgoff_t pg_start;
 	pgoff_t pg_end;
@@ -331,6 +333,11 @@ int fuse_reverse_inval_inode(struct super_block *sb, u64 nodeid,
 	if (!inode)
 		return -ENOENT;
 
+	fi = get_fuse_inode(inode);
+	spin_lock(&fi->lock);
+	fi->attr_version = atomic64_inc_return(&fc->attr_version);
+	spin_unlock(&fi->lock);
+
 	fuse_invalidate_attr(inode);
 	forget_all_cached_acls(inode);
 	if (offset >= 0) {
-- 
2.25.1



