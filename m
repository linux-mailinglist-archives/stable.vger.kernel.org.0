Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C285C5F5392
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiJELgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiJELfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:35:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C0F785AC;
        Wed,  5 Oct 2022 04:34:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 721006164C;
        Wed,  5 Oct 2022 11:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807DFC433C1;
        Wed,  5 Oct 2022 11:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969654;
        bh=FTP0Lmh5M9tJNDoLKEL/OY3mjGBsd/tmQmjAPkpht7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=orHDtlYqgjM57EDQr1iR6P+ouDdwpkV+gMIPHepU0Rrk02xUGlTv0pZXpZEqqzSDH
         HlZWepgk074V1TVFsuueyxxsQgSu9QtdhxrQg6memtmOPM5686lHZU4YxgAVtCydtD
         Bz5NJn+T++7yDoC3vMEd2feuurHdUd5BX4R9slLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 39/51] xfs: introduce XFS_MAX_FILEOFF
Date:   Wed,  5 Oct 2022 13:32:27 +0200
Message-Id: <20221005113212.104481774@linuxfoundation.org>
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

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit a5084865524dee1fe8ea1fee17c60b4369ad4f5e upstream.

Introduce a new #define for the maximum supported file block offset.
We'll use this in the next patch to make it more obvious that we're
doing some operation for all possible inode fork mappings after a given
offset.  We can't use ULLONG_MAX here because bunmapi uses that to
detect when it's done.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_format.h |    7 +++++++
 fs/xfs/xfs_reflink.c       |    3 ++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1540,6 +1540,13 @@ typedef struct xfs_bmdr_block {
 #define BMBT_BLOCKCOUNT_BITLEN	21
 
 #define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
+#define BMBT_BLOCKCOUNT_MASK	((1ULL << BMBT_BLOCKCOUNT_BITLEN) - 1)
+
+/*
+ * bmbt records have a file offset (block) field that is 54 bits wide, so this
+ * is the largest xfs_fileoff_t that we ever expect to see.
+ */
+#define XFS_MAX_FILEOFF		(BMBT_STARTOFF_MASK + BMBT_BLOCKCOUNT_MASK)
 
 typedef struct xfs_bmbt_rec {
 	__be64			l0, l1;
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1544,7 +1544,8 @@ xfs_reflink_clear_inode_flag(
 	 * We didn't find any shared blocks so turn off the reflink flag.
 	 * First, get rid of any leftover CoW mappings.
 	 */
-	error = xfs_reflink_cancel_cow_blocks(ip, tpp, 0, NULLFILEOFF, true);
+	error = xfs_reflink_cancel_cow_blocks(ip, tpp, 0, XFS_MAX_FILEOFF,
+			true);
 	if (error)
 		return error;
 


