Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C96610B8EF
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbfK0UsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:48:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729612AbfK0UsP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:48:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0321621826;
        Wed, 27 Nov 2019 20:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887694;
        bh=hyGOFn3YZetm72mwECSkAUsfLoBdMx0Ka7hvxQTUnmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FHnIg1KXxLIII1PVW9m7kYKTRkyIVXVSwxnxNX2h4c9UCz3/WgUf3Rdr5+M1+eoe9
         IfD8l7DOx2ymwCMUEvWHK1s3XSBLZN2Hlu447PMglUqOTvFQJWDqKRUvkKLusNGPsl
         XIxEd78sx++c5X6G6+jyVkm4OlLmQ/iex4CttwZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 059/211] xfs: fix use-after-free race in xfs_buf_rele
Date:   Wed, 27 Nov 2019 21:29:52 +0100
Message-Id: <20191127203059.636966049@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 37fd1678245f7a5898c1b05128bc481fb403c290 ]

When looking at a 4.18 based KASAN use after free report, I noticed
that racing xfs_buf_rele() may race on dropping the last reference
to the buffer and taking the buffer lock. This was the symptom
displayed by the KASAN report, but the actual issue that was
reported had already been fixed in 4.19-rc1 by commit e339dd8d8b04
("xfs: use sync buffer I/O for sync delwri queue submission").

Despite this, I think there is still an issue with xfs_buf_rele()
in this code:

        release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
        spin_lock(&bp->b_lock);
        if (!release) {
.....

If two threads race on the b_lock after both dropping a reference
and one getting dropping the last reference so release = true, we
end up with:

CPU 0				CPU 1
atomic_dec_and_lock()
				atomic_dec_and_lock()
				spin_lock(&bp->b_lock)
spin_lock(&bp->b_lock)
<spins>
				<release = true bp->b_lru_ref = 0>
				<remove from lists>
				freebuf = true
				spin_unlock(&bp->b_lock)
				xfs_buf_free(bp)
<gets lock, reading and writing freed memory>
<accesses freed memory>
spin_unlock(&bp->b_lock) <reads/writes freed memory>

IOWs, we can't safely take bp->b_lock after dropping the hold
reference because the buffer may go away at any time after we
drop that reference. However, this can be fixed simply by taking the
bp->b_lock before we drop the reference.

It is safe to nest the pag_buf_lock inside bp->b_lock as the
pag_buf_lock is only used to serialise against lookup in
xfs_buf_find() and no other locks are held over or under the
pag_buf_lock there. Make this clear by documenting the buffer lock
orders at the top of the file.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_buf.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e4a623956df57..e5970ecdfd585 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -58,6 +58,32 @@ static kmem_zone_t *xfs_buf_zone;
 #define xb_to_gfp(flags) \
 	((((flags) & XBF_READ_AHEAD) ? __GFP_NORETRY : GFP_NOFS) | __GFP_NOWARN)
 
+/*
+ * Locking orders
+ *
+ * xfs_buf_ioacct_inc:
+ * xfs_buf_ioacct_dec:
+ *	b_sema (caller holds)
+ *	  b_lock
+ *
+ * xfs_buf_stale:
+ *	b_sema (caller holds)
+ *	  b_lock
+ *	    lru_lock
+ *
+ * xfs_buf_rele:
+ *	b_lock
+ *	  pag_buf_lock
+ *	    lru_lock
+ *
+ * xfs_buftarg_wait_rele
+ *	lru_lock
+ *	  b_lock (trylock due to inversion)
+ *
+ * xfs_buftarg_isolate
+ *	lru_lock
+ *	  b_lock (trylock due to inversion)
+ */
 
 static inline int
 xfs_buf_is_vmapped(
@@ -983,8 +1009,18 @@ xfs_buf_rele(
 
 	ASSERT(atomic_read(&bp->b_hold) > 0);
 
-	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
+	/*
+	 * We grab the b_lock here first to serialise racing xfs_buf_rele()
+	 * calls. The pag_buf_lock being taken on the last reference only
+	 * serialises against racing lookups in xfs_buf_find(). IOWs, the second
+	 * to last reference we drop here is not serialised against the last
+	 * reference until we take bp->b_lock. Hence if we don't grab b_lock
+	 * first, the last "release" reference can win the race to the lock and
+	 * free the buffer before the second-to-last reference is processed,
+	 * leading to a use-after-free scenario.
+	 */
 	spin_lock(&bp->b_lock);
+	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
 	if (!release) {
 		/*
 		 * Drop the in-flight state if the buffer is already on the LRU
-- 
2.20.1



