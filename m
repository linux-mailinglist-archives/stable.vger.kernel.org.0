Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6ABA53CF15
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345413AbiFCRwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345844AbiFCRu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:50:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5345B59320;
        Fri,  3 Jun 2022 10:46:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E6AD60A24;
        Fri,  3 Jun 2022 17:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E8DC385B8;
        Fri,  3 Jun 2022 17:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278386;
        bh=ckAXMjdtX0ur87WUhgGjR/BsA7WVjQYxbNCalliwZs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UAtTWNbyZBv//mlVQJbgoqVRxRNv4/0SdOP29eHkssr4j0rfw8Qi7s2dMDWqaKuAA
         Z0ickdhdI+syb9Bi839L1BKTv0HqmTZ3Pstj39o/mSL4VCsC1nMJyZBf0r87xN4jdF
         0d9y1uiOMvoFA5WObEapsrDk/259EmrLKrRp37pM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 16/53] xfs: detect overflows in bmbt records
Date:   Fri,  3 Jun 2022 19:43:01 +0200
Message-Id: <20220603173819.194392585@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173818.716010877@linuxfoundation.org>
References: <20220603173818.716010877@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit acf104c2331c1ba2a667e65dd36139d1555b1432 upstream.

Detect file block mappings with a blockcount that's either so large that
integer overflows occur or are zero, because neither are valid in the
filesystem.  Worse yet, attempting directory modifications causes the
iext code to trip over the bmbt key handling and takes the filesystem
down.  We can fix most of this by preventing the bad metadata from
entering the incore structures in the first place.

Found by setting blockcount=0 in a directory data fork mapping and
watching the fireworks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6229,6 +6229,11 @@ xfs_bmap_validate_extent(
 	xfs_fsblock_t		endfsb;
 	bool			isrt;
 
+	if (irec->br_startblock + irec->br_blockcount <= irec->br_startblock)
+		return __this_address;
+	if (irec->br_startoff + irec->br_blockcount <= irec->br_startoff)
+		return __this_address;
+
 	isrt = XFS_IS_REALTIME_INODE(ip);
 	endfsb = irec->br_startblock + irec->br_blockcount - 1;
 	if (isrt && whichfork == XFS_DATA_FORK) {


