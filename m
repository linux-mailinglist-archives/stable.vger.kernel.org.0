Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D12D17F394
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404121AbfHBJ6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406972AbfHBJ5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:57:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57FDE2067D;
        Fri,  2 Aug 2019 09:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739867;
        bh=d4yGjujxHP7IOdvqPfhDM8i8eT9d2PmBoGZVERq1gCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=my70lUaaaDwNdl8q9Vut9s5amcMkZvZgUp4fgjUufPBBcgmFgs7ZNFDliUFEUARhU
         p6HVxuP0xu9m6zYQpzrD/uJIAYuX32GnYRXFoEjE97yDCiZ750qGp4Dr6n8QV/RQ4g
         fCad5JqK45W5OppVeUyQD687dwYP45MM4zl0lgGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.2 20/20] ceph: hold i_ceph_lock when removing caps for freeing inode
Date:   Fri,  2 Aug 2019 11:40:14 +0200
Message-Id: <20190802092104.185027321@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092055.131876977@linuxfoundation.org>
References: <20190802092055.131876977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan, Zheng <zyan@redhat.com>

commit d6e47819721ae2d9d090058ad5570a66f3c42e39 upstream.

ceph_d_revalidate(, LOOKUP_RCU) may call __ceph_caps_issued_mask()
on a freeing inode.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/caps.c  |   10 ++++++----
 fs/ceph/inode.c |    2 +-
 fs/ceph/super.h |    2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1263,20 +1263,22 @@ static int send_cap_msg(struct cap_msg_a
 }
 
 /*
- * Queue cap releases when an inode is dropped from our cache.  Since
- * inode is about to be destroyed, there is no need for i_ceph_lock.
+ * Queue cap releases when an inode is dropped from our cache.
  */
-void __ceph_remove_caps(struct inode *inode)
+void __ceph_remove_caps(struct ceph_inode_info *ci)
 {
-	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct rb_node *p;
 
+	/* lock i_ceph_lock, because ceph_d_revalidate(..., LOOKUP_RCU)
+	 * may call __ceph_caps_issued_mask() on a freeing inode. */
+	spin_lock(&ci->i_ceph_lock);
 	p = rb_first(&ci->i_caps);
 	while (p) {
 		struct ceph_cap *cap = rb_entry(p, struct ceph_cap, ci_node);
 		p = rb_next(p);
 		__ceph_remove_cap(cap, true);
 	}
+	spin_unlock(&ci->i_ceph_lock);
 }
 
 /*
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -536,7 +536,7 @@ void ceph_evict_inode(struct inode *inod
 
 	ceph_fscache_unregister_inode_cookie(ci);
 
-	__ceph_remove_caps(inode);
+	__ceph_remove_caps(ci);
 
 	if (__ceph_has_any_quota(ci))
 		ceph_adjust_quota_realms_count(inode, false);
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1000,7 +1000,7 @@ extern void ceph_add_cap(struct inode *i
 			 unsigned cap, unsigned seq, u64 realmino, int flags,
 			 struct ceph_cap **new_cap);
 extern void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release);
-extern void __ceph_remove_caps(struct inode* inode);
+extern void __ceph_remove_caps(struct ceph_inode_info *ci);
 extern void ceph_put_cap(struct ceph_mds_client *mdsc,
 			 struct ceph_cap *cap);
 extern int ceph_is_any_caps(struct inode *inode);


