Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0AC7582D96
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbiG0RAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241398AbiG0Q7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:59:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AEB691F0;
        Wed, 27 Jul 2022 09:37:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B156AB821A6;
        Wed, 27 Jul 2022 16:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B94C433C1;
        Wed, 27 Jul 2022 16:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939853;
        bh=H6Ls8YFqH71j1ApB6PrAmK28ZzaHYIEAR7Jz0lr46Oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bx/f/pBjgSrYYCOxq3YSTYzW0G/tH5PBjFmWpmohv0l+lRPcGXnc9mJjIRoH1eAJY
         oyX/jf20UNFD7jv2zA7uBYs4LsK+4tHsQAud8COnJMtc9MyJEwX2CtbBWWMvbv4eee
         zgkzMutm89/NWVQGxbUX4m4VpYix588qN8vuveLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 021/201] xfs: fix maxlevels comparisons in the btree staging code
Date:   Wed, 27 Jul 2022 18:08:45 +0200
Message-Id: <20220727161027.780172627@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 78e8ec83a404d63dcc86b251f42e4ee8aff27465 ]

The btree geometry computation function has an off-by-one error in that
it does not allow maximally tall btrees (nlevels == XFS_BTREE_MAXLEVELS).
This can result in repairs failing unnecessarily on very fragmented
filesystems.  Subsequent patches to remove MAXLEVELS usage in favor of
the per-btree type computations will make this a much more likely
occurrence.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_btree_staging.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -662,7 +662,7 @@ xfs_btree_bload_compute_geometry(
 	xfs_btree_bload_ensure_slack(cur, &bbl->node_slack, 1);
 
 	bbl->nr_records = nr_this_level = nr_records;
-	for (cur->bc_nlevels = 1; cur->bc_nlevels < XFS_BTREE_MAXLEVELS;) {
+	for (cur->bc_nlevels = 1; cur->bc_nlevels <= XFS_BTREE_MAXLEVELS;) {
 		uint64_t	level_blocks;
 		uint64_t	dontcare64;
 		unsigned int	level = cur->bc_nlevels - 1;
@@ -724,7 +724,7 @@ xfs_btree_bload_compute_geometry(
 		nr_this_level = level_blocks;
 	}
 
-	if (cur->bc_nlevels == XFS_BTREE_MAXLEVELS)
+	if (cur->bc_nlevels > XFS_BTREE_MAXLEVELS)
 		return -EOVERFLOW;
 
 	bbl->btree_height = cur->bc_nlevels;


