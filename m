Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2162957578E
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 00:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiGNWYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 18:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbiGNWYF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 18:24:05 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4B06D553;
        Thu, 14 Jul 2022 15:24:04 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id f11so2810528pgj.7;
        Thu, 14 Jul 2022 15:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EjB4/XZ1VOt42RAc0P4znd64tR5ytn/gw4JkwQE4qDI=;
        b=eIjuE+33kFhlF6K+BGGlI7MGcy30iEdDE6AYCDlJuBvZ93HiUuFtzT0IDuGBWhtsa8
         M/ur34i9h6gQxa7TF8LQsJouGIHEbqfnCHuRFxeFfsQBL+TFQWYKAe3ujmfo0sulZ+LV
         NL0C6KYGY/gxqMQ1Av1Sx8LYZEgUPtC5WToiTAngH/JLTMYPWpkiTfa3tJrDXdt3RPq3
         S5kkxXNsb1uwB7nVojMMblhW7VEmxJjQ1ysd7gfDGCNXrVO1u7T/XnZzn4hC2wvdNDAA
         BCeSf3wVL4s9LCONbIGhXDJv4dY8doDmfgzYvhiQP5gWiIhIK0taSunRONcF7maK4vjd
         S19A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EjB4/XZ1VOt42RAc0P4znd64tR5ytn/gw4JkwQE4qDI=;
        b=BHU4O/CKTGSvVKB/S/41pkbQNggAk893i1Vs9bWXmbcJNJV0GdbzSsXPNIlMsrTAL1
         7nMZwASUPoSkj/0Bmre4GvRlkgDNnkJMtmCupmk0My8D5F6HZEOezPj14ZyVC/q9V5R7
         krMCoyeFML1dklZbvd4176IKdzIEmU0BSO9RUSjDJp5StfolFQKRembUMDfMzoMx/o+q
         v+612QQaZNGlDOEiLbQ66XYrP9Za0vrDKu+E8r1EHxsFUNM1EE8xOlr4+wkpr918wgr3
         6D95yIZPkqWZOMwMtoG3EZlDjvVt6D95WEqbF08p2Zz70iaeNuM+qUKkKBZAhecu10Ae
         ppCA==
X-Gm-Message-State: AJIora8iKvbAf0IYaQNtIVWeoOcqBG/EHT/IJoene3QPh/rS7H2L4+kj
        b4sSJ56aRI2EsLzt6KRNIznVWOI/R8mbDg==
X-Google-Smtp-Source: AGRyM1u5aS7xPAatObR2EMY/NvIbegHT7vlS5LJLHUf0R7av3Ja1SIp5u5v10bPgHf4CkJEERotWVg==
X-Received: by 2002:a63:c056:0:b0:411:b3d3:ae4c with SMTP id z22-20020a63c056000000b00411b3d3ae4cmr9365241pgi.102.1657837444083;
        Thu, 14 Jul 2022 15:24:04 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:4f72:1916:7fb3:18])
        by smtp.gmail.com with ESMTPSA id q25-20020a635059000000b0040c644e82efsm1884464pgl.43.2022.07.14.15.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 15:24:03 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 v2 2/4] xfs: don't include bnobt blocks when reserving free block pool
Date:   Thu, 14 Jul 2022 15:23:40 -0700
Message-Id: <20220714222342.4013916-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
In-Reply-To: <20220714222342.4013916-1-leah.rumancik@gmail.com>
References: <20220714222342.4013916-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit c8c568259772751a14e969b7230990508de73d9d ]

xfs_reserve_blocks controls the size of the user-visible free space
reserve pool.  Given the difference between the current and requested
pool sizes, it will try to reserve free space from fdblocks.  However,
the amount requested from fdblocks is also constrained by the amount of
space that we think xfs_mod_fdblocks will give us.  If we forget to
subtract m_allocbt_blks before calling xfs_mod_fdblocks, it will will
return ENOSPC and we'll hang the kernel at mount due to the infinite
loop.

In commit fd43cf600cf6, we decided that xfs_mod_fdblocks should not hand
out the "free space" used by the free space btrees, because some portion
of the free space btrees hold in reserve space for future btree
expansion.  Unfortunately, xfs_reserve_blocks' estimation of the number
of blocks that it could request from xfs_mod_fdblocks was not updated to
include m_allocbt_blks, so if space is extremely low, the caller hangs.

Fix this by creating a function to estimate the number of blocks that
can be reserved from fdblocks, which needs to exclude the set-aside and
m_allocbt_blks.

Found by running xfs/306 (which formats a single-AG 20MB filesystem)
with an fstests configuration that specifies a 1k blocksize and a
specially crafted log size that will consume 7/8 of the space (17920
blocks, specifically) in that AG.

Cc: Brian Foster <bfoster@redhat.com>
Fixes: fd43cf600cf6 ("xfs: set aside allocation btree blocks from block reservation")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c |  2 +-
 fs/xfs/xfs_mount.c |  2 +-
 fs/xfs/xfs_mount.h | 15 +++++++++++++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 33e26690a8c4..710e857bb825 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -434,7 +434,7 @@ xfs_reserve_blocks(
 	error = -ENOSPC;
 	do {
 		free = percpu_counter_sum(&mp->m_fdblocks) -
-						mp->m_alloc_set_aside;
+						xfs_fdblocks_unavailable(mp);
 		if (free <= 0)
 			break;
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 62f3c153d4b2..76056de83971 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1132,7 +1132,7 @@ xfs_mod_fdblocks(
 	 * problems (i.e. transaction abort, pagecache discards, etc.) than
 	 * slightly premature -ENOSPC.
 	 */
-	set_aside = mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
+	set_aside = xfs_fdblocks_unavailable(mp);
 	percpu_counter_add_batch(&mp->m_fdblocks, delta, batch);
 	if (__percpu_counter_compare(&mp->m_fdblocks, set_aside,
 				     XFS_FDBLOCKS_BATCH) >= 0) {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e091f3b3fa15..86564295fce6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -478,6 +478,21 @@ extern void	xfs_unmountfs(xfs_mount_t *);
  */
 #define XFS_FDBLOCKS_BATCH	1024
 
+/*
+ * Estimate the amount of free space that is not available to userspace and is
+ * not explicitly reserved from the incore fdblocks.  This includes:
+ *
+ * - The minimum number of blocks needed to support splitting a bmap btree
+ * - The blocks currently in use by the freespace btrees because they record
+ *   the actual blocks that will fill per-AG metadata space reservations
+ */
+static inline uint64_t
+xfs_fdblocks_unavailable(
+	struct xfs_mount	*mp)
+{
+	return mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
+}
+
 extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
 				 bool reserved);
 extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
-- 
2.37.0.170.g444d1eabd0-goog

