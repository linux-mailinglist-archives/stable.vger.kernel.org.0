Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF403ED6A0
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237068AbhHPNWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240963AbhHPNU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:20:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 415D3632DA;
        Mon, 16 Aug 2021 13:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119752;
        bh=0W4EdmruMnkUfZ0bPruTlYpD4HsXhpLEHu6A4D2qCog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qhcGFBK/IYZ+IjN7saXGZJ5pOifdyxhN7JxoSjaTWYTs0c8+f85JCUsXNttMDOirv
         eqXBxcI1jTvrdUb8SOT5WGhytZB2UMGMJ1UiYhciQQQF7P77omLy+RM9wm9UQakN8y
         CY2MgtHNcIXRRl95EcgVl6NC2gzE7njhdK69Ns7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.13 148/151] ceph: add some lockdep assertions around snaprealm handling
Date:   Mon, 16 Aug 2021 15:02:58 +0200
Message-Id: <20210816125448.959506987@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit a6862e6708c15995bc10614b2ef34ca35b4b9078 upstream.

Turn some comments into lockdep asserts.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/snap.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -65,6 +65,8 @@
 void ceph_get_snap_realm(struct ceph_mds_client *mdsc,
 			 struct ceph_snap_realm *realm)
 {
+	lockdep_assert_held_write(&mdsc->snap_rwsem);
+
 	dout("get_realm %p %d -> %d\n", realm,
 	     atomic_read(&realm->nref), atomic_read(&realm->nref)+1);
 	/*
@@ -113,6 +115,8 @@ static struct ceph_snap_realm *ceph_crea
 {
 	struct ceph_snap_realm *realm;
 
+	lockdep_assert_held_write(&mdsc->snap_rwsem);
+
 	realm = kzalloc(sizeof(*realm), GFP_NOFS);
 	if (!realm)
 		return ERR_PTR(-ENOMEM);
@@ -143,6 +147,8 @@ static struct ceph_snap_realm *__lookup_
 	struct rb_node *n = mdsc->snap_realms.rb_node;
 	struct ceph_snap_realm *r;
 
+	lockdep_assert_held_write(&mdsc->snap_rwsem);
+
 	while (n) {
 		r = rb_entry(n, struct ceph_snap_realm, node);
 		if (ino < r->ino)
@@ -176,6 +182,8 @@ static void __put_snap_realm(struct ceph
 static void __destroy_snap_realm(struct ceph_mds_client *mdsc,
 				 struct ceph_snap_realm *realm)
 {
+	lockdep_assert_held_write(&mdsc->snap_rwsem);
+
 	dout("__destroy_snap_realm %p %llx\n", realm, realm->ino);
 
 	rb_erase(&realm->node, &mdsc->snap_realms);
@@ -198,6 +206,8 @@ static void __destroy_snap_realm(struct
 static void __put_snap_realm(struct ceph_mds_client *mdsc,
 			     struct ceph_snap_realm *realm)
 {
+	lockdep_assert_held_write(&mdsc->snap_rwsem);
+
 	dout("__put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
 	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
 	if (atomic_dec_and_test(&realm->nref))
@@ -236,6 +246,8 @@ static void __cleanup_empty_realms(struc
 {
 	struct ceph_snap_realm *realm;
 
+	lockdep_assert_held_write(&mdsc->snap_rwsem);
+
 	spin_lock(&mdsc->snap_empty_lock);
 	while (!list_empty(&mdsc->snap_empty)) {
 		realm = list_first_entry(&mdsc->snap_empty,
@@ -269,6 +281,8 @@ static int adjust_snap_realm_parent(stru
 {
 	struct ceph_snap_realm *parent;
 
+	lockdep_assert_held_write(&mdsc->snap_rwsem);
+
 	if (realm->parent_ino == parentino)
 		return 0;
 
@@ -696,6 +710,8 @@ int ceph_update_snap_trace(struct ceph_m
 	int err = -ENOMEM;
 	LIST_HEAD(dirty_realms);
 
+	lockdep_assert_held_write(&mdsc->snap_rwsem);
+
 	dout("update_snap_trace deletion=%d\n", deletion);
 more:
 	ceph_decode_need(&p, e, sizeof(*ri), bad);


