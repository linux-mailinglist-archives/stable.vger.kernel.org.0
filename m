Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5293559E061
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353527AbiHWKPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353486AbiHWKNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:13:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04B77333E;
        Tue, 23 Aug 2022 01:59:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D854CB81C28;
        Tue, 23 Aug 2022 08:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0F3C433D6;
        Tue, 23 Aug 2022 08:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245179;
        bh=dlKpSa3x4yoY73lQP0rU57gjhQ+MYqOS71te7t6vVts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AyucyXNB0BOrhkw7Dt3Mre8pO6j7vxAvXXK8MOEcntdYfiXZjAT7ZWpvrO6f1G15d
         YLfQJgKH5pNlN0yOBzaIENQ6lCtiOgSPAmBnsC0yTe7A8vSla/1mSuk1dVn3lpUeQC
         q4eNgje2Ch8qc9gkCEnt63eLmGh9jFkVpZ2+GbiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 241/244] xfs: fix overfilling of reserve pool
Date:   Tue, 23 Aug 2022 10:26:40 +0200
Message-Id: <20220823080107.670496251@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 82be38bcf8a2e056b4c99ce79a3827fa743df6ec ]

Due to cycling of m_sb_lock, it's possible for multiple callers of
xfs_reserve_blocks to race at changing the pool size, subtracting blocks
from fdblocks, and actually putting it in the pool.  The result of all
this is that we can overfill the reserve pool to hilarious levels.

xfs_mod_fdblocks, when called with a positive value, already knows how
to take freed blocks and either fill the reserve until it's full, or put
them in fdblocks.  Use that instead of setting m_resblks_avail directly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_fsops.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -448,18 +448,17 @@ xfs_reserve_blocks(
 		 * count or we'll get an ENOSPC.  Don't set the reserved flag
 		 * here - we don't want to reserve the extra reserve blocks
 		 * from the reserve.
+		 *
+		 * The desired reserve size can change after we drop the lock.
+		 * Use mod_fdblocks to put the space into the reserve or into
+		 * fdblocks as appropriate.
 		 */
 		fdblks_delta = min(free, delta);
 		spin_unlock(&mp->m_sb_lock);
 		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
-		spin_lock(&mp->m_sb_lock);
-
-		/*
-		 * Update the reserve counters if blocks have been successfully
-		 * allocated.
-		 */
 		if (!error)
-			mp->m_resblks_avail += fdblks_delta;
+			xfs_mod_fdblocks(mp, fdblks_delta, 0);
+		spin_lock(&mp->m_sb_lock);
 	}
 out:
 	if (outval) {


