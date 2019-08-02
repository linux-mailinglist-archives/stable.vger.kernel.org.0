Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B59EE7F136
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731810AbfHBJhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:37:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404833AbfHBJgQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:36:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 242122184B;
        Fri,  2 Aug 2019 09:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738575;
        bh=UOlWSdtchKYsBmJqg8duIoQQ3H+xRyAdBrbbFVsXwRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhNDG1GEQTFaCZjGVB3n3nwhrbg9ULMKKyFIYa8c8u72lNv/aF80inBJJqQrGbkh9
         Pi6mw0RmBb5bwMBSfFloVroVTYjUcs0qydQX3HiPG2bFZno69zE5u6HQBd0MsGixii
         4s1IG+4s0j+BKGAYSkkSeFk3McvdEoHdfKzoRA50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 4.4 158/158] ceph: hold i_ceph_lock when removing caps for freeing inode
Date:   Fri,  2 Aug 2019 11:29:39 +0200
Message-Id: <20190802092233.875646888@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
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
 fs/ceph/caps.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1072,20 +1072,23 @@ static int send_cap_msg(struct ceph_mds_
 }
 
 /*
- * Queue cap releases when an inode is dropped from our cache.  Since
- * inode is about to be destroyed, there is no need for i_ceph_lock.
+ * Queue cap releases when an inode is dropped from our cache.
  */
 void ceph_queue_caps_release(struct inode *inode)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
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


