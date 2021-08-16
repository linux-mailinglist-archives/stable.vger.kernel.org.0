Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC893ED57C
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238122AbhHPNLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:11:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239562AbhHPNJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:09:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A461F604DC;
        Mon, 16 Aug 2021 13:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119365;
        bh=SiPgRGHbGQySDNfy3OJn4o1z2BoGp7oudsaI9vqwVuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0GCCW9t1JW81lWUB8//bRldhQw/hLp/idfLkacYhEU0sryQHtwiG+J6K4Gd8Pod2
         FeGxZf4qv3lYp5MuzVOvPKHRF2BD2JukqNwqsi+5NqBM5zwqMVt64bWf6daV9NcMAs
         EdasAU4eju0/5JxDmHCPR4gQ+cXvlart4tgKTH4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 94/96] ceph: clean up locking annotation for ceph_get_snap_realm and __lookup_snap_realm
Date:   Mon, 16 Aug 2021 15:02:44 +0200
Message-Id: <20210816125438.114351211@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit df2c0cb7f8e8c83e495260ad86df8c5da947f2a7 upstream.

They both say that the snap_rwsem must be held for write, but I don't
see any real reason for it, and it's not currently always called that
way.

The lookup is just walking the rbtree, so holding it for read should be
fine there. The "get" is bumping the refcount and (possibly) removing
it from the empty list. I see no need to hold the snap_rwsem for write
for that.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/snap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -60,12 +60,12 @@
 /*
  * increase ref count for the realm
  *
- * caller must hold snap_rwsem for write.
+ * caller must hold snap_rwsem.
  */
 void ceph_get_snap_realm(struct ceph_mds_client *mdsc,
 			 struct ceph_snap_realm *realm)
 {
-	lockdep_assert_held_write(&mdsc->snap_rwsem);
+	lockdep_assert_held(&mdsc->snap_rwsem);
 
 	dout("get_realm %p %d -> %d\n", realm,
 	     atomic_read(&realm->nref), atomic_read(&realm->nref)+1);
@@ -139,7 +139,7 @@ static struct ceph_snap_realm *ceph_crea
 /*
  * lookup the realm rooted at @ino.
  *
- * caller must hold snap_rwsem for write.
+ * caller must hold snap_rwsem.
  */
 static struct ceph_snap_realm *__lookup_snap_realm(struct ceph_mds_client *mdsc,
 						   u64 ino)
@@ -147,7 +147,7 @@ static struct ceph_snap_realm *__lookup_
 	struct rb_node *n = mdsc->snap_realms.rb_node;
 	struct ceph_snap_realm *r;
 
-	lockdep_assert_held_write(&mdsc->snap_rwsem);
+	lockdep_assert_held(&mdsc->snap_rwsem);
 
 	while (n) {
 		r = rb_entry(n, struct ceph_snap_realm, node);


