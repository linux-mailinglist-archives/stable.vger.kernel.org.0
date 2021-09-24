Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243C64174D6
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346472AbhIXNLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:11:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346003AbhIXNJH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:09:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6E1A615A3;
        Fri, 24 Sep 2021 12:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488258;
        bh=oO26n9HkAliWj05JqJMlaksjTn0jefMA4NhGYQYip58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjSqh427oagrLU4aR0T4ZqePQPGOtxnzKiCpWNHnqxNdf16F8TYwXEG6E5qKVswEt
         PkbWc9U9sc8//jztydwA+PZIgPOQBBV0efr2627Q7n6qOVKwv8tfcYnvHjzKziSuFD
         IxxbbzAN3K06eOFj7y0P/VhEi5dmWSmOHxhYA1jA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 45/63] ceph: remove the capsnaps when removing caps
Date:   Fri, 24 Sep 2021 14:44:45 +0200
Message-Id: <20210924124335.822963063@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit a6d37ccdd240e80f26aaea0e62cda310e0e184d7 ]

capsnaps will take inode references via ihold when queueing to flush.
When force unmounting, the client will just close the sessions and
may never get a flush reply, causing a leak and inode ref leak.

Fix this by removing the capsnaps for an inode when removing the caps.

URL: https://tracker.ceph.com/issues/52295
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c       | 68 +++++++++++++++++++++++++++++++++-----------
 fs/ceph/mds_client.c | 31 +++++++++++++++++++-
 fs/ceph/super.h      |  6 ++++
 3 files changed, 87 insertions(+), 18 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 678dac8365ed..f303e0d87c3f 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3169,7 +3169,16 @@ void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
 				break;
 			}
 		}
-		BUG_ON(!found);
+
+		if (!found) {
+			/*
+			 * The capsnap should already be removed when removing
+			 * auth cap in the case of a forced unmount.
+			 */
+			WARN_ON_ONCE(ci->i_auth_cap);
+			goto unlock;
+		}
+
 		capsnap->dirty_pages -= nr;
 		if (capsnap->dirty_pages == 0) {
 			complete_capsnap = true;
@@ -3191,6 +3200,7 @@ void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
 		     complete_capsnap ? " (complete capsnap)" : "");
 	}
 
+unlock:
 	spin_unlock(&ci->i_ceph_lock);
 
 	if (last) {
@@ -3657,6 +3667,43 @@ out:
 		iput(inode);
 }
 
+void __ceph_remove_capsnap(struct inode *inode, struct ceph_cap_snap *capsnap,
+			   bool *wake_ci, bool *wake_mdsc)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
+	bool ret;
+
+	lockdep_assert_held(&ci->i_ceph_lock);
+
+	dout("removing capsnap %p, inode %p ci %p\n", capsnap, inode, ci);
+
+	list_del_init(&capsnap->ci_item);
+	ret = __detach_cap_flush_from_ci(ci, &capsnap->cap_flush);
+	if (wake_ci)
+		*wake_ci = ret;
+
+	spin_lock(&mdsc->cap_dirty_lock);
+	if (list_empty(&ci->i_cap_flush_list))
+		list_del_init(&ci->i_flushing_item);
+
+	ret = __detach_cap_flush_from_mdsc(mdsc, &capsnap->cap_flush);
+	if (wake_mdsc)
+		*wake_mdsc = ret;
+	spin_unlock(&mdsc->cap_dirty_lock);
+}
+
+void ceph_remove_capsnap(struct inode *inode, struct ceph_cap_snap *capsnap,
+			 bool *wake_ci, bool *wake_mdsc)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+
+	lockdep_assert_held(&ci->i_ceph_lock);
+
+	WARN_ON_ONCE(capsnap->dirty_pages || capsnap->writing);
+	__ceph_remove_capsnap(inode, capsnap, wake_ci, wake_mdsc);
+}
+
 /*
  * Handle FLUSHSNAP_ACK.  MDS has flushed snap data to disk and we can
  * throw away our cap_snap.
@@ -3694,23 +3741,10 @@ static void handle_cap_flushsnap_ack(struct inode *inode, u64 flush_tid,
 			     capsnap, capsnap->follows);
 		}
 	}
-	if (flushed) {
-		WARN_ON(capsnap->dirty_pages || capsnap->writing);
-		dout(" removing %p cap_snap %p follows %lld\n",
-		     inode, capsnap, follows);
-		list_del(&capsnap->ci_item);
-		wake_ci |= __detach_cap_flush_from_ci(ci, &capsnap->cap_flush);
-
-		spin_lock(&mdsc->cap_dirty_lock);
-
-		if (list_empty(&ci->i_cap_flush_list))
-			list_del_init(&ci->i_flushing_item);
-
-		wake_mdsc |= __detach_cap_flush_from_mdsc(mdsc,
-							  &capsnap->cap_flush);
-		spin_unlock(&mdsc->cap_dirty_lock);
-	}
+	if (flushed)
+		ceph_remove_capsnap(inode, capsnap, &wake_ci, &wake_mdsc);
 	spin_unlock(&ci->i_ceph_lock);
+
 	if (flushed) {
 		ceph_put_snap_context(capsnap->context);
 		ceph_put_cap_snap(capsnap);
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 46606fb5b886..0f57b7d09457 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1587,14 +1587,39 @@ out:
 	return ret;
 }
 
+static int remove_capsnaps(struct ceph_mds_client *mdsc, struct inode *inode)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_cap_snap *capsnap;
+	int capsnap_release = 0;
+
+	lockdep_assert_held(&ci->i_ceph_lock);
+
+	dout("removing capsnaps, ci is %p, inode is %p\n", ci, inode);
+
+	while (!list_empty(&ci->i_cap_snaps)) {
+		capsnap = list_first_entry(&ci->i_cap_snaps,
+					   struct ceph_cap_snap, ci_item);
+		__ceph_remove_capsnap(inode, capsnap, NULL, NULL);
+		ceph_put_snap_context(capsnap->context);
+		ceph_put_cap_snap(capsnap);
+		capsnap_release++;
+	}
+	wake_up_all(&ci->i_cap_wq);
+	wake_up_all(&mdsc->cap_flushing_wq);
+	return capsnap_release;
+}
+
 static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 				  void *arg)
 {
 	struct ceph_fs_client *fsc = (struct ceph_fs_client *)arg;
+	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	LIST_HEAD(to_remove);
 	bool dirty_dropped = false;
 	bool invalidate = false;
+	int capsnap_release = 0;
 
 	dout("removing cap %p, ci is %p, inode is %p\n",
 	     cap, ci, &ci->vfs_inode);
@@ -1602,7 +1627,6 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	__ceph_remove_cap(cap, false);
 	if (!ci->i_auth_cap) {
 		struct ceph_cap_flush *cf;
-		struct ceph_mds_client *mdsc = fsc->mdsc;
 
 		if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
 			if (inode->i_data.nrpages > 0)
@@ -1666,6 +1690,9 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 			list_add(&ci->i_prealloc_cap_flush->i_list, &to_remove);
 			ci->i_prealloc_cap_flush = NULL;
 		}
+
+		if (!list_empty(&ci->i_cap_snaps))
+			capsnap_release = remove_capsnaps(mdsc, inode);
 	}
 	spin_unlock(&ci->i_ceph_lock);
 	while (!list_empty(&to_remove)) {
@@ -1682,6 +1709,8 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		ceph_queue_invalidate(inode);
 	if (dirty_dropped)
 		iput(inode);
+	while (capsnap_release--)
+		iput(inode);
 	return 0;
 }
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index a8c460393b01..9362eeb5812d 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1134,6 +1134,12 @@ extern void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci,
 					    int had);
 extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
 				       struct ceph_snap_context *snapc);
+extern void __ceph_remove_capsnap(struct inode *inode,
+				  struct ceph_cap_snap *capsnap,
+				  bool *wake_ci, bool *wake_mdsc);
+extern void ceph_remove_capsnap(struct inode *inode,
+				struct ceph_cap_snap *capsnap,
+				bool *wake_ci, bool *wake_mdsc);
 extern void ceph_flush_snaps(struct ceph_inode_info *ci,
 			     struct ceph_mds_session **psession);
 extern bool __ceph_should_report_size(struct ceph_inode_info *ci);
-- 
2.33.0



