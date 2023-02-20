Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9076369CD57
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbjBTNsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbjBTNsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:48:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E8FA5D3
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:48:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B09E660EA8
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AEEC433D2;
        Mon, 20 Feb 2023 13:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900901;
        bh=6O0Wv22PkDWZ/HadwUfR3jQFPtwX0PXBQoxVXNXlwfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OhWqPlZlUCk2P93s05Out50aTcgRYgzTZKvmxgBikZxV03s2prJVOr7dIGhmnYkV0
         X0wsPMi0pr6raxgoH/NaOfZ0KT6/1YqZkICzq0uew+yAS1Zwm/PIBoPOwv0NfkhEcL
         kmnDgtentWXasixtrs35aaqo+UJKT5xVOnSBGAuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 103/156] xfs: remove the xfs_efd_log_item_t typedef
Date:   Mon, 20 Feb 2023 14:35:47 +0100
Message-Id: <20230220133606.799739494@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit c84e819090f39e96e4d432c9047a50d2424f99e0 upstream.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_extfree_item.h |    4 ++--
 fs/xfs/xfs_super.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -63,12 +63,12 @@ struct xfs_efi_log_item {
  * the fact that some extents earlier mentioned in an efi item
  * have been freed.
  */
-typedef struct xfs_efd_log_item {
+struct xfs_efd_log_item {
 	struct xfs_log_item	efd_item;
 	struct xfs_efi_log_item *efd_efip;
 	uint			efd_next_extent;
 	xfs_efd_log_format_t	efd_format;
-} xfs_efd_log_item_t;
+};
 
 /*
  * Max number of extents in fast allocation path.
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1914,7 +1914,7 @@ xfs_init_zones(void)
 	if (!xfs_buf_item_zone)
 		goto out_destroy_trans_zone;
 
-	xfs_efd_zone = kmem_zone_init((sizeof(xfs_efd_log_item_t) +
+	xfs_efd_zone = kmem_zone_init((sizeof(struct xfs_efd_log_item) +
 			((XFS_EFD_MAX_FAST_EXTENTS - 1) *
 				 sizeof(xfs_extent_t))), "xfs_efd_item");
 	if (!xfs_efd_zone)


