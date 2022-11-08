Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13EDF621353
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbiKHNtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234564AbiKHNtS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:49:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884B56314
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:49:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48541B81AE8
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A32AC433D6;
        Tue,  8 Nov 2022 13:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915355;
        bh=RuYchei7QOwh8d7mI7NwwXlTPRmugQtjgst3vuEKIvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=onZDsD3RWTIAvDJKtKkDa7hZPMBrqjL25rW5uhldAWmw32218//t4UaryJljy1LeN
         KP6v2l36RtlqkbvVrI+pXXrBoo9VFp0uihDd/cjUwjLey6t6yVaDt7mnjkkxmCOXfe
         mLP0VdX8MU9mUKVcv47O/UzjfjZRC9dTAsP+HLiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 37/74] xfs: dont fail verifier on empty attr3 leaf block
Date:   Tue,  8 Nov 2022 14:39:05 +0100
Message-Id: <20221108133335.235304148@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
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

From: Brian Foster <bfoster@redhat.com>

commit f28cef9e4daca11337cb9f144cdebedaab69d78c upstream.

The attr fork can transition from shortform to leaf format while
empty if the first xattr doesn't fit in shortform. While this empty
leaf block state is intended to be transient, it is technically not
due to the transactional implementation of the xattr set operation.

We historically have a couple of bandaids to work around this
problem. The first is to hold the buffer after the format conversion
to prevent premature writeback of the empty leaf buffer and the
second is to bypass the xattr count check in the verifier during
recovery. The latter assumes that the xattr set is also in the log
and will be recovered into the buffer soon after the empty leaf
buffer is reconstructed. This is not guaranteed, however.

If the filesystem crashes after the format conversion but before the
xattr set that induced it, only the format conversion may exist in
the log. When recovered, this creates a latent corrupted state on
the inode as any subsequent attempts to read the buffer fail due to
verifier failure. This includes further attempts to set xattrs on
the inode or attempts to destroy the attr fork, which prevents the
inode from ever being removed from the unlinked list.

To avoid this condition, accept that an empty attr leaf block is a
valid state and remove the count check from the verifier. This means
that on rare occasions an attr fork might exist in an unexpected
state, but is otherwise consistent and functional. Note that we
retain the logic to avoid racing with metadata writeback to reduce
the window where this can occur.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -251,14 +251,6 @@ xfs_attr3_leaf_verify(
 		return fa;
 
 	/*
-	 * In recovery there is a transient state where count == 0 is valid
-	 * because we may have transitioned an empty shortform attr to a leaf
-	 * if the attr didn't fit in shortform.
-	 */
-	if (!xfs_log_in_recovery(mp) && ichdr.count == 0)
-		return __this_address;
-
-	/*
 	 * firstused is the block offset of the first name info structure.
 	 * Make sure it doesn't go off the block or crash into the header.
 	 */


