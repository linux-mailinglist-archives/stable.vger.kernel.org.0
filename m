Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A8724B2E3
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgHTJij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:38:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728837AbgHTJi2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:38:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AB2520724;
        Thu, 20 Aug 2020 09:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916307;
        bh=F/lWx3rCyAx0QUIFhY6nhve4Bh0dW3+M/Nm1ZT3P9w8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N8j/evRkFu2XMgES6eeSQdtQk3yyl6g/Ag8/A5DtK2nqwRzm+an5yjbPRKZwHET9H
         bM4MmuQiXbFSK5pgDem9Ucj+asi9tshEFYoO3as/5ud9Rm9aJ9IS14Wh/C3AzlxBZ/
         Mc5LmyLY0P6yhD8xedPvZc+mqPAwjuJZb1ltIFdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.7 083/204] ceph: set sec_context xattr on symlink creation
Date:   Thu, 20 Aug 2020 11:19:40 +0200
Message-Id: <20200820091610.486448645@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit b748fc7a8763a5b3f8149f12c45711cd73ef8176 upstream.

Symlink inodes should have the security context set in their xattrs on
creation. We already set the context on creation, but we don't attach
the pagelist. The effect is that symlink inodes don't get an SELinux
context set on them at creation, so they end up unlabeled instead of
inheriting the proper context. Make it do so.

Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/dir.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -924,6 +924,10 @@ static int ceph_symlink(struct inode *di
 	req->r_num_caps = 2;
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
+	if (as_ctx.pagelist) {
+		req->r_pagelist = as_ctx.pagelist;
+		as_ctx.pagelist = NULL;
+	}
 	err = ceph_mdsc_do_request(mdsc, dir, req);
 	if (!err && !req->r_reply_info.head->is_dentry)
 		err = ceph_handle_notrace_create(dir, dentry);


