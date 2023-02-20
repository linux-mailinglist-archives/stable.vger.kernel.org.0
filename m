Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8CC69CD7F
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbjBTNuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbjBTNuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:50:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11831E5DF
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:49:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5328FB80D53
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EC3C433EF;
        Mon, 20 Feb 2023 13:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900981;
        bh=cflMtuHm1s3zWKgNMyEiB268gQATvl2GHfWqz6u4KUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZVyWE7BefDDOIq8Nw1tgN1X4nIZQTPsW9kL2I4vCB2Xd/zZrFiqKxH05xb/0jkkR
         UgoZFG+arh+34TKrwmUo1g2Re+af0Ye7wbzdK3v8wute6m7GsiM4q1ANX7aaMI3p4X
         5dPZ/AeEwZ2Z15xuaGykhrI2mVJSdmO9+F7NB7pQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 102/156] xfs: remove the xfs_efi_log_item_t typedef
Date:   Mon, 20 Feb 2023 14:35:46 +0100
Message-Id: <20230220133606.755774836@linuxfoundation.org>
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

commit 82ff450b2d936d778361a1de43eb078cc043c7fe upstream.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_extfree_item.c |    2 +-
 fs/xfs/xfs_extfree_item.h |   10 +++++-----
 fs/xfs/xfs_log_recover.c  |    4 ++--
 fs/xfs/xfs_super.c        |    2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -161,7 +161,7 @@ xfs_efi_init(
 
 	ASSERT(nextents > 0);
 	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
-		size = (uint)(sizeof(xfs_efi_log_item_t) +
+		size = (uint)(sizeof(struct xfs_efi_log_item) +
 			((nextents - 1) * sizeof(xfs_extent_t)));
 		efip = kmem_zalloc(size, 0);
 	} else {
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -50,13 +50,13 @@ struct kmem_zone;
  * of commit failure or log I/O errors. Note that the EFD is not inserted in the
  * AIL, so at this point both the EFI and EFD are freed.
  */
-typedef struct xfs_efi_log_item {
+struct xfs_efi_log_item {
 	struct xfs_log_item	efi_item;
 	atomic_t		efi_refcount;
 	atomic_t		efi_next_extent;
 	unsigned long		efi_flags;	/* misc flags */
 	xfs_efi_log_format_t	efi_format;
-} xfs_efi_log_item_t;
+};
 
 /*
  * This is the "extent free done" log item.  It is used to log
@@ -65,7 +65,7 @@ typedef struct xfs_efi_log_item {
  */
 typedef struct xfs_efd_log_item {
 	struct xfs_log_item	efd_item;
-	xfs_efi_log_item_t	*efd_efip;
+	struct xfs_efi_log_item *efd_efip;
 	uint			efd_next_extent;
 	xfs_efd_log_format_t	efd_format;
 } xfs_efd_log_item_t;
@@ -78,10 +78,10 @@ typedef struct xfs_efd_log_item {
 extern struct kmem_zone	*xfs_efi_zone;
 extern struct kmem_zone	*xfs_efd_zone;
 
-xfs_efi_log_item_t	*xfs_efi_init(struct xfs_mount *, uint);
+struct xfs_efi_log_item	*xfs_efi_init(struct xfs_mount *, uint);
 int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
 					    xfs_efi_log_format_t *dst_efi_fmt);
-void			xfs_efi_item_free(xfs_efi_log_item_t *);
+void			xfs_efi_item_free(struct xfs_efi_log_item *);
 void			xfs_efi_release(struct xfs_efi_log_item *);
 
 int			xfs_efi_recover(struct xfs_mount *mp,
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3384,7 +3384,7 @@ xlog_recover_efd_pass2(
 	struct xlog_recover_item	*item)
 {
 	xfs_efd_log_format_t	*efd_formatp;
-	xfs_efi_log_item_t	*efip = NULL;
+	struct xfs_efi_log_item	*efip = NULL;
 	struct xfs_log_item	*lip;
 	uint64_t		efi_id;
 	struct xfs_ail_cursor	cur;
@@ -3405,7 +3405,7 @@ xlog_recover_efd_pass2(
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
 	while (lip != NULL) {
 		if (lip->li_type == XFS_LI_EFI) {
-			efip = (xfs_efi_log_item_t *)lip;
+			efip = (struct xfs_efi_log_item *)lip;
 			if (efip->efi_format.efi_id == efi_id) {
 				/*
 				 * Drop the EFD reference to the EFI. This
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1920,7 +1920,7 @@ xfs_init_zones(void)
 	if (!xfs_efd_zone)
 		goto out_destroy_buf_item_zone;
 
-	xfs_efi_zone = kmem_zone_init((sizeof(xfs_efi_log_item_t) +
+	xfs_efi_zone = kmem_zone_init((sizeof(struct xfs_efi_log_item) +
 			((XFS_EFI_MAX_FAST_EXTENTS - 1) *
 				sizeof(xfs_extent_t))), "xfs_efi_item");
 	if (!xfs_efi_zone)


