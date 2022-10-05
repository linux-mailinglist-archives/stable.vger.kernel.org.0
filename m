Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D942A5F5394
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiJELgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiJELf4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:35:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFCA786F8;
        Wed,  5 Oct 2022 04:34:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A031C61639;
        Wed,  5 Oct 2022 11:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB199C433C1;
        Wed,  5 Oct 2022 11:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969652;
        bh=7H36+bGM/K0rmtrqZ0EZ7Q0z04NzUgj+kjvHLFrlzcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7K1YXCrK8TnbhjbDeeUpytmRK3GwBj8PFJ1Tw7d4aKzUo8wqKcrmTFiY3PGYW2wy
         +aH6rJ+xAgCusPAc+Mod0mqCUcU0jftCB5p85yTx7zF30RreJfRwLJXsyixOsJtqaB
         +WXDd4eREXmmRLk4hV7/ES2rA6xbxRQAScARxNF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 38/51] xfs: fix misuse of the XFS_ATTR_INCOMPLETE flag
Date:   Wed,  5 Oct 2022 13:32:26 +0200
Message-Id: <20221005113212.064213076@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
References: <20221005113210.255710920@linuxfoundation.org>
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

commit 780d29057781d986cd87dbbe232cd02876ad430f upstream.

XFS_ATTR_INCOMPLETE is a flag in the on-disk attribute format, and thus
in a different namespace as the ATTR_* flags in xfs_da_args.flags.
Switch to using a XFS_DA_OP_INCOMPLETE flag in op_flags instead.  Without
this users might be able to inject this flag into operations using the
attr by handle ioctl.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr.c      |    2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c |    4 ++--
 fs/xfs/libxfs/xfs_da_btree.h  |    4 +++-
 fs/xfs/libxfs/xfs_da_format.h |    2 --
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1007,7 +1007,7 @@ restart:
 		 * The INCOMPLETE flag means that we will find the "old"
 		 * attr, not the "new" one.
 		 */
-		args->flags |= XFS_ATTR_INCOMPLETE;
+		args->op_flags |= XFS_DA_OP_INCOMPLETE;
 		state = xfs_da_state_alloc();
 		state->args = args;
 		state->mp = mp;
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2345,8 +2345,8 @@ xfs_attr3_leaf_lookup_int(
 		 * If we are looking for INCOMPLETE entries, show only those.
 		 * If we are looking for complete entries, show only those.
 		 */
-		if ((args->flags & XFS_ATTR_INCOMPLETE) !=
-		    (entry->flags & XFS_ATTR_INCOMPLETE)) {
+		if (!!(args->op_flags & XFS_DA_OP_INCOMPLETE) !=
+		    !!(entry->flags & XFS_ATTR_INCOMPLETE)) {
 			continue;
 		}
 		if (entry->flags & XFS_ATTR_LOCAL) {
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -82,6 +82,7 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
 #define XFS_DA_OP_ALLOCVAL	0x0020	/* lookup to alloc buffer if found  */
+#define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -89,7 +90,8 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
-	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }
+	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }, \
+	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
 
 /*
  * Storage for holding state during Btree searches and split/join ops.
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -740,8 +740,6 @@ struct xfs_attr3_icleaf_hdr {
 
 /*
  * Flags used in the leaf_entry[i].flags field.
- * NOTE: the INCOMPLETE bit must not collide with the flags bits specified
- * on the system call, they are "or"ed together for various operations.
  */
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */


