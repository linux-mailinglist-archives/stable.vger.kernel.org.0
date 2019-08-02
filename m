Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E63427F33E
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406529AbfHBJzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:55:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406314AbfHBJzX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:55:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DDF3206A2;
        Fri,  2 Aug 2019 09:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739722;
        bh=sMcHdwsShMKPny5SzSh2JPU8nH1PCi+pTwlmWMRfjS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ne1vyQINO09MF38pG7ApLQQBocTfFnSfvfWyKxOV7Orl8rimnR5klWdmqyHcXSi/0
         lbJJ4rWX5HETm/NCDhx/KWZkgvmVnTVTp0pl+cfqkIFIg2Pg/Onf+/WjOmqb2gE7P/
         wXsOXIfkN7RV3NO/Hw75QOdeW4jKDXTw45PLyPMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 4.14 24/25] ceph: hold i_ceph_lock when removing caps for freeing inode
Date:   Fri,  2 Aug 2019 11:39:56 +0200
Message-Id: <20190802092107.553439814@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092058.428079740@linuxfoundation.org>
References: <20190802092058.428079740@linuxfoundation.org>
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
@@ -1119,20 +1119,23 @@ static int send_cap_msg(struct cap_msg_a
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


