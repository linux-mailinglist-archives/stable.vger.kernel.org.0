Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F92326F22D
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgIRC45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbgIRCGt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:06:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AB002395A;
        Fri, 18 Sep 2020 02:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394804;
        bh=DE7SCW9moeshv/1VrDqcJQRsTInKF3qjHMUPLCrLqTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+0yJ+GkAH7GamIOMtNO54gSI2ffqV2cGIU+3bbv7B6ge3gE3RjMSAShLOfFj5Elu
         9jNSru6MhbtPCxI5M661Y1y3a7QisQtrN2M52IY3PQQEs8ShKCnBZyvtByqPRlt0SV
         pKstWQyjnOoMnUYFG6bbglO3wlPdGMSguB0KNxQ4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Krzysztof Rusek <rusek@9livesdata.com>,
        Sasha Levin <sashal@kernel.org>,
        fuse-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 273/330] fuse: update attr_version counter on fuse_notify_inval_inode()
Date:   Thu, 17 Sep 2020 22:00:13 -0400
Message-Id: <20200918020110.2063155-273-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

