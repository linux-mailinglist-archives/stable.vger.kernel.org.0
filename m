Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4521C1F33A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbfEOLGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728724AbfEOLGO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:06:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04D36216FD;
        Wed, 15 May 2019 11:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918373;
        bh=6jlw6kxbsl1OSxmlM7sqRC1e3PjCAuar3qYpvSLgfjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uikffmoE/rYBHydHoLWGjGahvjHS7wt/2j4IAByh6de8fxTux+o8LZ/0bsviH7RF3
         3iBfTuMoVSnEB2MbVHnKmN9G4D574k9ZoW0mW0CekqhdB1VA8Dvye65P4bRD4IfLXO
         iseYm8j7U+Lg9ncxbPLuAtYF95pGe9ekQkYQ/bQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.4 105/266] ceph: fix use-after-free on symlink traversal
Date:   Wed, 15 May 2019 12:53:32 +0200
Message-Id: <20190515090726.006075984@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit daf5cc27eed99afdea8d96e71b89ba41f5406ef6 ]

free the symlink body after the same RCU delay we have for freeing the
struct inode itself, so that traversal during RCU pathwalk wouldn't step
into freed memory.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 fs/ceph/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 9f0d99094cc1..a663b676d566 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -474,6 +474,7 @@ static void ceph_i_callback(struct rcu_head *head)
 	struct inode *inode = container_of(head, struct inode, i_rcu);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
+	kfree(ci->i_symlink);
 	kmem_cache_free(ceph_inode_cachep, ci);
 }
 
@@ -505,7 +506,6 @@ void ceph_destroy_inode(struct inode *inode)
 		ceph_put_snap_realm(mdsc, realm);
 	}
 
-	kfree(ci->i_symlink);
 	while ((n = rb_first(&ci->i_fragtree)) != NULL) {
 		frag = rb_entry(n, struct ceph_inode_frag, node);
 		rb_erase(n, &ci->i_fragtree);
-- 
2.19.1



