Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911BA5EA311
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbiIZLTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237560AbiIZLSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:18:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570C566A4D;
        Mon, 26 Sep 2022 03:38:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01E34B80977;
        Mon, 26 Sep 2022 10:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452D0C433C1;
        Mon, 26 Sep 2022 10:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188688;
        bh=+p6XPmpKOcfY08Yxyub/1jU9Xatr3GVDNkLDWbXy9ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2lyFr1gSAO9CMxP8YvXbor8ev/PgQiakQU9VKAfd9uqYI4QsZC7Ih+NPpVoS4REsJ
         cAEe1HT4lyL+yBggbM0GEtzymv+kkzIajprl3zpQ1IPCCyM5vTmzIop7+cS+drNlm4
         CRe4jdTk64HGkho3Q5qV5h6ZUygcq0RqsA3HJnaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 057/148] xfs: validate inode fork size against fork format
Date:   Mon, 26 Sep 2022 12:11:31 +0200
Message-Id: <20220926100758.167761628@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 1eb70f54c445fcbb25817841e774adb3d912f3e8 ]

xfs_repair catches fork size/format mismatches, but the in-kernel
verifier doesn't, leading to null pointer failures when attempting
to perform operations on the fork. This can occur in the
xfs_dir_is_empty() where the in-memory fork format does not match
the size and so the fork data pointer is accessed incorrectly.

Note: this causes new failures in xfs/348 which is testing mode vs
ftype mismatches. We now detect a regular file that has been changed
to a directory or symlink mode as being corrupt because the data
fork is for a symlink or directory should be in local form when
there are only 3 bytes of data in the data fork. Hence the inode
verify for the regular file now fires w/ -EFSCORRUPTED because
the inode fork format does not match the format the corrupted mode
says it should be in.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -337,19 +337,36 @@ xfs_dinode_verify_fork(
 	int			whichfork)
 {
 	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	mode_t			mode = be16_to_cpu(dip->di_mode);
+	uint32_t		fork_size = XFS_DFORK_SIZE(dip, mp, whichfork);
+	uint32_t		fork_format = XFS_DFORK_FORMAT(dip, whichfork);
 
-	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
+	/*
+	 * For fork types that can contain local data, check that the fork
+	 * format matches the size of local data contained within the fork.
+	 *
+	 * For all types, check that when the size says the should be in extent
+	 * or btree format, the inode isn't claiming it is in local format.
+	 */
+	if (whichfork == XFS_DATA_FORK) {
+		if (S_ISDIR(mode) || S_ISLNK(mode)) {
+			if (be64_to_cpu(dip->di_size) <= fork_size &&
+			    fork_format != XFS_DINODE_FMT_LOCAL)
+				return __this_address;
+		}
+
+		if (be64_to_cpu(dip->di_size) > fork_size &&
+		    fork_format == XFS_DINODE_FMT_LOCAL)
+			return __this_address;
+	}
+
+	switch (fork_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		/*
-		 * no local regular files yet
+		 * No local regular files yet.
 		 */
-		if (whichfork == XFS_DATA_FORK) {
-			if (S_ISREG(be16_to_cpu(dip->di_mode)))
-				return __this_address;
-			if (be64_to_cpu(dip->di_size) >
-					XFS_DFORK_SIZE(dip, mp, whichfork))
-				return __this_address;
-		}
+		if (S_ISREG(mode) && whichfork == XFS_DATA_FORK)
+			return __this_address;
 		if (di_nextents)
 			return __this_address;
 		break;


