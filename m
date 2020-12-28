Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C252A2E3A4B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389252AbgL1Nez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:34:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389247AbgL1Nex (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:34:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7FE0207C9;
        Mon, 28 Dec 2020 13:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162452;
        bh=en4JodZ0izEoyc/4scQmt5IKrqWGjKoum/ZppeskoGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pwox1w1PftB8d6RijzhofG+k4v+RJ5SL65pS1gp1Kh+HneHR1IM33Ck9SVln3rvsX
         nwikmwSY02IamC63+YdK8MG0h6zB8JN235aSIctXsOP/ArJ9x02MnGf8T+QPmXforU
         LCeSs1BFyzEbIJArlxNZqepfNSDSWbnHP65pA8fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Luis Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 4.19 308/346] ceph: fix race in concurrent __ceph_remove_cap invocations
Date:   Mon, 28 Dec 2020 13:50:27 +0100
Message-Id: <20201228124934.686900299@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
@@ -1047,12 +1047,19 @@ void __ceph_remove_cap(struct ceph_cap *
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


