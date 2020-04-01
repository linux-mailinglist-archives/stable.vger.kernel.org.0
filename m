Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64D7A19B03A
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387783AbgDAQZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387795AbgDAQZL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:25:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E62B42137B;
        Wed,  1 Apr 2020 16:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758310;
        bh=yTCKRj95Bx7h1wcaOR/rFqMuESRhROHSu1rAf99oYIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWs1d9fFuuk5iPjhPjXj10W8PZYI6bpt8a/iX31DdJgFO61mCSr64rmL598r2Vu7m
         556I3hvys/aZrntLVITVFXVeCND/mdbTsjiMFBq7Bz9r+KgtBk5UI3xZgksx7hMRY7
         G4fjr3hIMScZAL9hcMKCu+2h9daei6PBHz/uY+Ng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yanhu Cao <gmayyyha@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>
Subject: [PATCH 4.19 051/116] ceph: check POOL_FLAG_FULL/NEARFULL in addition to OSDMAP_FULL/NEARFULL
Date:   Wed,  1 Apr 2020 18:17:07 +0200
Message-Id: <20200401161549.104547630@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
References: <20200401161542.669484650@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

commit 7614209736fbc4927584d4387faade4f31444fce upstream.

CEPH_OSDMAP_FULL/NEARFULL aren't set since mimic, so we need to consult
per-pool flags as well.  Unfortunately the backwards compatibility here
is lacking:

- the change that deprecated OSDMAP_FULL/NEARFULL went into mimic, but
  was guarded by require_osd_release >= RELEASE_LUMINOUS
- it was subsequently backported to luminous in v12.2.2, but that makes
  no difference to clients that only check OSDMAP_FULL/NEARFULL because
  require_osd_release is not client-facing -- it is for OSDs

Since all kernels are affected, the best we can do here is just start
checking both map flags and pool flags and send that to stable.

These checks are best effort, so take osdc->lock and look up pool flags
just once.  Remove the FIXME, since filesystem quotas are checked above
and RADOS quotas are reflected in POOL_FLAG_FULL: when the pool reaches
its quota, both POOL_FLAG_FULL and POOL_FLAG_FULL_QUOTA are set.

Cc: stable@vger.kernel.org
Reported-by: Yanhu Cao <gmayyyha@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Sage Weil <sage@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/file.c              |   14 +++++++++++---
 include/linux/ceph/osdmap.h |    4 ++++
 include/linux/ceph/rados.h  |    6 ++++--
 net/ceph/osdmap.c           |    9 +++++++++
 4 files changed, 28 insertions(+), 5 deletions(-)

--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1384,9 +1384,12 @@ static ssize_t ceph_write_iter(struct ki
 	struct inode *inode = file_inode(file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
+	struct ceph_osd_client *osdc = &fsc->client->osdc;
 	struct ceph_cap_flush *prealloc_cf;
 	ssize_t count, written = 0;
 	int err, want, got;
+	u32 map_flags;
+	u64 pool_flags;
 	loff_t pos;
 	loff_t limit = max(i_size_read(inode), fsc->max_file_size);
 
@@ -1441,8 +1444,12 @@ retry_snap:
 			goto out;
 	}
 
-	/* FIXME: not complete since it doesn't account for being at quota */
-	if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_FULL)) {
+	down_read(&osdc->lock);
+	map_flags = osdc->osdmap->flags;
+	pool_flags = ceph_pg_pool_flags(osdc->osdmap, ci->i_layout.pool_id);
+	up_read(&osdc->lock);
+	if ((map_flags & CEPH_OSDMAP_FULL) ||
+	    (pool_flags & CEPH_POOL_FLAG_FULL)) {
 		err = -ENOSPC;
 		goto out;
 	}
@@ -1532,7 +1539,8 @@ retry_snap:
 	}
 
 	if (written >= 0) {
-		if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_NEARFULL))
+		if ((map_flags & CEPH_OSDMAP_NEARFULL) ||
+		    (pool_flags & CEPH_POOL_FLAG_NEARFULL))
 			iocb->ki_flags |= IOCB_DSYNC;
 		written = generic_write_sync(iocb, written);
 	}
--- a/include/linux/ceph/osdmap.h
+++ b/include/linux/ceph/osdmap.h
@@ -37,6 +37,9 @@ int ceph_spg_compare(const struct ceph_s
 #define CEPH_POOL_FLAG_HASHPSPOOL	(1ULL << 0) /* hash pg seed and pool id
 						       together */
 #define CEPH_POOL_FLAG_FULL		(1ULL << 1) /* pool is full */
+#define CEPH_POOL_FLAG_FULL_QUOTA	(1ULL << 10) /* pool ran out of quota,
+							will set FULL too */
+#define CEPH_POOL_FLAG_NEARFULL		(1ULL << 11) /* pool is nearfull */
 
 struct ceph_pg_pool_info {
 	struct rb_node node;
@@ -305,5 +308,6 @@ extern struct ceph_pg_pool_info *ceph_pg
 
 extern const char *ceph_pg_pool_name_by_id(struct ceph_osdmap *map, u64 id);
 extern int ceph_pg_poolid_by_name(struct ceph_osdmap *map, const char *name);
+u64 ceph_pg_pool_flags(struct ceph_osdmap *map, u64 id);
 
 #endif
--- a/include/linux/ceph/rados.h
+++ b/include/linux/ceph/rados.h
@@ -143,8 +143,10 @@ extern const char *ceph_osd_state_name(i
 /*
  * osd map flag bits
  */
-#define CEPH_OSDMAP_NEARFULL (1<<0)  /* sync writes (near ENOSPC) */
-#define CEPH_OSDMAP_FULL     (1<<1)  /* no data writes (ENOSPC) */
+#define CEPH_OSDMAP_NEARFULL (1<<0)  /* sync writes (near ENOSPC),
+					not set since ~luminous */
+#define CEPH_OSDMAP_FULL     (1<<1)  /* no data writes (ENOSPC),
+					not set since ~luminous */
 #define CEPH_OSDMAP_PAUSERD  (1<<2)  /* pause all reads */
 #define CEPH_OSDMAP_PAUSEWR  (1<<3)  /* pause all writes */
 #define CEPH_OSDMAP_PAUSEREC (1<<4)  /* pause recovery */
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -711,6 +711,15 @@ int ceph_pg_poolid_by_name(struct ceph_o
 }
 EXPORT_SYMBOL(ceph_pg_poolid_by_name);
 
+u64 ceph_pg_pool_flags(struct ceph_osdmap *map, u64 id)
+{
+	struct ceph_pg_pool_info *pi;
+
+	pi = __lookup_pg_pool(&map->pg_pools, id);
+	return pi ? pi->flags : 0;
+}
+EXPORT_SYMBOL(ceph_pg_pool_flags);
+
 static void __remove_pg_pool(struct rb_root *root, struct ceph_pg_pool_info *pi)
 {
 	rb_erase(&pi->node, root);


