Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B06566BDF
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbiGEMJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235192AbiGEMIl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB714186ED;
        Tue,  5 Jul 2022 05:08:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 931CDB817CE;
        Tue,  5 Jul 2022 12:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C8BC341CD;
        Tue,  5 Jul 2022 12:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022885;
        bh=gKbmN6uWZ82Xii3MsIXGKeH4v7WVPEI8RzIUV0Mz5fQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PpZU+GVPSAq4iFQ+Flv18vw8zcqqR3s1U0q5SOFrq2J23JtwdfwZ+pq0jfImufwCM
         qSvmaS95KXGVhXYxGvYoc4ckUm2DXGnHVLFNrFQbid/z8f0yV6/+VzHC3D2Erp0K3u
         lmoXDuwrD8nZmJuuU3E9P9oyXAaRIpdshnjHXB9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Zorro Lang <zlang@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 46/84] xfs: update superblock counters correctly for !lazysbcount
Date:   Tue,  5 Jul 2022 13:58:09 +0200
Message-Id: <20220705115616.670135979@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 6543990a168acf366f4b6174d7bd46ba15a8a2a6 upstream.

Keep the mount superblock counters up to date for !lazysbcount
filesystems so that when we log the superblock they do not need
updating in any way because they are already correct.

It's found by what Zorro reported:
1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
2. mount $dev $mnt
3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
4. umount $mnt
5. xfs_repair -n $dev
and I've seen no problem with this patch.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reported-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_sb.c |   16 +++++++++++++---
 fs/xfs/xfs_trans.c     |    3 +++
 2 files changed, 16 insertions(+), 3 deletions(-)

--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -956,9 +956,19 @@ xfs_log_sb(
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_buf		*bp = xfs_trans_getsb(tp);
 
-	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
-	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
-	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+	/*
+	 * Lazy sb counters don't update the in-core superblock so do that now.
+	 * If this is at unmount, the counters will be exactly correct, but at
+	 * any other time they will only be ballpark correct because of
+	 * reservations that have been taken out percpu counters. If we have an
+	 * unclean shutdown, this will be corrected by log recovery rebuilding
+	 * the counters from the AGF block counts.
+	 */
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
+		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
+		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
+		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+	}
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -615,6 +615,9 @@ xfs_trans_unreserve_and_mod_sb(
 
 	/* apply remaining deltas */
 	spin_lock(&mp->m_sb_lock);
+	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
+	mp->m_sb.sb_icount += idelta;
+	mp->m_sb.sb_ifree += ifreedelta;
 	mp->m_sb.sb_frextents += rtxdelta;
 	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
 	mp->m_sb.sb_agcount += tp->t_agcount_delta;


