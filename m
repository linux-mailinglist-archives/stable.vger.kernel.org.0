Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6B92E379B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 13:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgL1M6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:58:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:54162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729041AbgL1M6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:58:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1BF822583;
        Mon, 28 Dec 2020 12:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160273;
        bh=XNUT/zhrydKZ2ZoLA9bXfxOYLb6acnw01IGB8X9deQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0JL+LvMwWGM6HTTBuOxkWw6G2BX5oTTjQkYW9A6GxAHvTl4CM8w64Ed2wFc3gT2a0
         lMABqYYY9pRvuWtbp9Q/lWsPd5kSFNncBqDFalE7HDSjt8KHvBcJyhwmdJTm6Bo32L
         lF/5+8UFTt3/7C2g8Khi7QjikTIXT4eT3NQSJFcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Luis Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 4.4 120/132] ceph: fix race in concurrent __ceph_remove_cap invocations
Date:   Mon, 28 Dec 2020 13:50:04 +0100
Message-Id: <20201228124852.212569819@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Henriques <lhenriques@suse.de>

commit e5cafce3ad0f8652d6849314d951459c2bff7233 upstream.

A NULL pointer dereference may occur in __ceph_remove_cap with some of the
callbacks used in ceph_iterate_session_caps, namely trim_caps_cb and
remove_session_caps_cb. Those callers hold the session->s_mutex, so they
are prevented from concurrent execution, but ceph_evict_inode does not.

Since the callers of this function hold the i_ceph_lock, the fix is simply
a matter of returning immediately if caps->ci is NULL.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/43272
Suggested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Luis Henriques <lhenriques@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/caps.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -920,12 +920,19 @@ void __ceph_remove_cap(struct ceph_cap *
 {
 	struct ceph_mds_session *session = cap->session;
 	struct ceph_inode_info *ci = cap->ci;
-	struct ceph_mds_client *mdsc =
-		ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
+	struct ceph_mds_client *mdsc;
 	int removed = 0;
 
+	/* 'ci' being NULL means the remove have already occurred */
+	if (!ci) {
+		dout("%s: cap inode is NULL\n", __func__);
+		return;
+	}
+
 	dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
 
+	mdsc = ceph_inode_to_client(&ci->vfs_inode)->mdsc;
+
 	/* remove from inode's cap rbtree, and clear auth cap */
 	rb_erase(&cap->ci_node, &ci->i_caps);
 	if (ci->i_auth_cap == cap)


