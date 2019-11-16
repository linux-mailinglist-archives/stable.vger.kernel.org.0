Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0EE6FF044
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbfKPPvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:51:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730817AbfKPPvm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:51:42 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAE9D2084B;
        Sat, 16 Nov 2019 15:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919500;
        bh=8v2/Cs1QTRw3u87ZKECXxUqI3I0na7RDg/PfoarGI0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vUAKDSb1EwCfaAhp8SFOS4j26TYUQhzEV/RwyIaDIZ/7SDXoZRW6m12cEyHyip0eM
         qCAXwf1K1nJ4pzlNmIK/lXC21eM7I7+krGK7FIR2Y2vPQbys33UMM9Y91LNOvKLnJH
         usH1iYTf53pn4sxQg6kXqQ1nJKx0XYCCLr6yhv4A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 27/99] xfs: fix use-after-free race in xfs_buf_rele
Date:   Sat, 16 Nov 2019 10:49:50 -0500
Message-Id: <20191116155103.10971-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 651755353374d..0b58b9d419e84 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -57,6 +57,32 @@ static kmem_zone_t *xfs_buf_zone;
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
@@ -957,8 +983,18 @@ xfs_buf_rele(
 
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

