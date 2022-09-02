Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2867F5AB111
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238595AbiIBNDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238401AbiIBNCo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:02:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA8810B971;
        Fri,  2 Sep 2022 05:41:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E556621AD;
        Fri,  2 Sep 2022 12:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1C3C433D6;
        Fri,  2 Sep 2022 12:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122388;
        bh=dxzaYWsKEC/iaUOjhi3s42CTv+Z/QYHQanu3QtWLlWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDEfYGI7VXWpN6dpYUvbRjKoz4+Yv5wJjv9f+ody21gcIoawHoGIXlba4hhPZyMye
         LAYOPpp02sxPiSEUdx0PQe7Csigp0DZNGXCcwWDcZH2PvcdoFBX6jaTrKFoM/40153
         6SAOJIn8JKPrszKT+UM5bFnyBOaa7b+SdyNldNO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 31/37] xfs: remove infinite loop when reserving free block pool
Date:   Fri,  2 Sep 2022 14:19:53 +0200
Message-Id: <20220902121400.150139481@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121359.177846782@linuxfoundation.org>
References: <20220902121359.177846782@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

commit 15f04fdc75aaaa1cccb0b8b3af1be290e118a7bc upstream.

[Added wrapper xfs_fdblocks_unavailable() for 5.10.y backport]

Infinite loops in kernel code are scary.  Calls to xfs_reserve_blocks
should be rare (people should just use the defaults!) so we really don't
need to try so hard.  Simplify the logic here by removing the infinite
loop.

Cc: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_fsops.c |   52 +++++++++++++++++++++-------------------------------
 fs/xfs/xfs_mount.h |    8 ++++++++
 2 files changed, 29 insertions(+), 31 deletions(-)

--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -376,46 +376,36 @@ xfs_reserve_blocks(
 	 * If the request is larger than the current reservation, reserve the
 	 * blocks before we update the reserve counters. Sample m_fdblocks and
 	 * perform a partial reservation if the request exceeds free space.
+	 *
+	 * The code below estimates how many blocks it can request from
+	 * fdblocks to stash in the reserve pool.  This is a classic TOCTOU
+	 * race since fdblocks updates are not always coordinated via
+	 * m_sb_lock.
 	 */
-	error = -ENOSPC;
-	do {
-		free = percpu_counter_sum(&mp->m_fdblocks) -
-						mp->m_alloc_set_aside;
-		if (free <= 0)
-			break;
-
-		delta = request - mp->m_resblks;
-		lcounter = free - delta;
-		if (lcounter < 0)
-			/* We can't satisfy the request, just get what we can */
-			fdblks_delta = free;
-		else
-			fdblks_delta = delta;
-
+	free = percpu_counter_sum(&mp->m_fdblocks) -
+						xfs_fdblocks_unavailable(mp);
+	delta = request - mp->m_resblks;
+	if (delta > 0 && free > 0) {
 		/*
 		 * We'll either succeed in getting space from the free block
-		 * count or we'll get an ENOSPC. If we get a ENOSPC, it means
-		 * things changed while we were calculating fdblks_delta and so
-		 * we should try again to see if there is anything left to
-		 * reserve.
-		 *
-		 * Don't set the reserved flag here - we don't want to reserve
-		 * the extra reserve blocks from the reserve.....
+		 * count or we'll get an ENOSPC.  Don't set the reserved flag
+		 * here - we don't want to reserve the extra reserve blocks
+		 * from the reserve.
 		 */
+		fdblks_delta = min(free, delta);
 		spin_unlock(&mp->m_sb_lock);
 		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
 		spin_lock(&mp->m_sb_lock);
-	} while (error == -ENOSPC);
 
-	/*
-	 * Update the reserve counters if blocks have been successfully
-	 * allocated.
-	 */
-	if (!error && fdblks_delta) {
-		mp->m_resblks += fdblks_delta;
-		mp->m_resblks_avail += fdblks_delta;
+		/*
+		 * Update the reserve counters if blocks have been successfully
+		 * allocated.
+		 */
+		if (!error) {
+			mp->m_resblks += fdblks_delta;
+			mp->m_resblks_avail += fdblks_delta;
+		}
 	}
-
 out:
 	if (outval) {
 		outval->resblks = mp->m_resblks;
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -406,6 +406,14 @@ extern int	xfs_initialize_perag(xfs_moun
 				     xfs_agnumber_t *maxagi);
 extern void	xfs_unmountfs(xfs_mount_t *);
 
+/* Accessor added for 5.10.y backport */
+static inline uint64_t
+xfs_fdblocks_unavailable(
+	struct xfs_mount	*mp)
+{
+	return mp->m_alloc_set_aside;
+}
+
 extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
 				 bool reserved);
 extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);


