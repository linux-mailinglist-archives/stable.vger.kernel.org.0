Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C4959E101
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353474AbiHWKPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353343AbiHWKNZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:13:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0220572B79;
        Tue, 23 Aug 2022 01:59:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9129461524;
        Tue, 23 Aug 2022 08:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F32AC433C1;
        Tue, 23 Aug 2022 08:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245170;
        bh=6SRByEKUyJPn1PDZBkn4uOumc2OTkqEOF++mfzePOz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OwMJyyHkddJ8YR0X6jHk+ZoYPs4fRi6pTOijK+4Bgcd+Oy0n5epq/91+n6EFngQRD
         pwRJ1Kn1pfU6yectNYyrw01OTFAfbUy0JOtXyF9KpzUIBXasDHVIe+WPSDrEOwKkQb
         VqKdMsxfXOuxenDVsOX6WRLKy9d+7bfmK3IO9hgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 238/244] xfs: reserve quota for target dir expansion when renaming files
Date:   Tue, 23 Aug 2022 10:26:37 +0200
Message-Id: <20220823080107.529005534@linuxfoundation.org>
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

[ Upstream commit 41667260bc84db4dfe566e3f6ab6da5293d60d8d ]

XFS does not reserve quota for directory expansion when renaming
children into a directory.  This means that we don't reject the
expansion with EDQUOT when we're at or near a hard limit, which means
that unprivileged userspace can use rename() to exceed quota.

Rename operations don't always expand the target directory, and we allow
a rename to proceed with no space reservation if we don't need to add a
block to the target directory to handle the addition.  Moreover, the
unlink operation on the source directory generally does not expand the
directory (you'd have to free a block and then cause a btree split) and
it's probably of little consequence to leave the corner case that
renaming a file out of a directory can increase its size.

As with link and unlink, there is a further bug in that we do not
trigger the blockgc workers to try to clear space when we're out of
quota.

Because rename is its own special tricky animal, we'll patch xfs_rename
directly to reserve quota to the rename transaction.  We'll leave
cleaning up the rest of xfs_rename for the metadata directory tree
patchset.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3103,7 +3103,8 @@ xfs_rename(
 	bool			new_parent = (src_dp != target_dp);
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
 	int			spaceres;
-	int			error;
+	bool			retried = false;
+	int			error, nospace_error = 0;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -3127,9 +3128,12 @@ xfs_rename(
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
 				inodes, &num_inodes);
 
+retry:
+	nospace_error = 0;
 	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, spaceres, 0, 0, &tp);
 	if (error == -ENOSPC) {
+		nospace_error = error;
 		spaceres = 0;
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, 0, 0, 0,
 				&tp);
@@ -3184,6 +3188,31 @@ xfs_rename(
 					spaceres);
 
 	/*
+	 * Try to reserve quota to handle an expansion of the target directory.
+	 * We'll allow the rename to continue in reservationless mode if we hit
+	 * a space usage constraint.  If we trigger reservationless mode, save
+	 * the errno if there isn't any free space in the target directory.
+	 */
+	if (spaceres != 0) {
+		error = xfs_trans_reserve_quota_nblks(tp, target_dp, spaceres,
+				0, false);
+		if (error == -EDQUOT || error == -ENOSPC) {
+			if (!retried) {
+				xfs_trans_cancel(tp);
+				xfs_blockgc_free_quota(target_dp, 0);
+				retried = true;
+				goto retry;
+			}
+
+			nospace_error = error;
+			spaceres = 0;
+			error = 0;
+		}
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	/*
 	 * Check for expected errors before we dirty the transaction
 	 * so we can return an error without a transaction abort.
 	 *
@@ -3429,6 +3458,8 @@ out_trans_cancel:
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);
+	if (error == -ENOSPC && nospace_error)
+		error = nospace_error;
 	return error;
 }
 


