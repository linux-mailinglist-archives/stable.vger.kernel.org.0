Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CD96980CB
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 17:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjBOQY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 11:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBOQY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 11:24:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41E53A864;
        Wed, 15 Feb 2023 08:24:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68FD0B82278;
        Wed, 15 Feb 2023 16:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A3BC433EF;
        Wed, 15 Feb 2023 16:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676478293;
        bh=JgwgyrTOZ5qy1XAEMyhB/UhliaDHRv8s569lBZJgikQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OYbC0HzKqiybKcoZkHh6mEcHIztl11XhlgmPL9G9wiVmVGdOZD2kxLW0OofD0/QqD
         4KTD/qA1yo1AU0YoqS6TWohjzodYbypjNZBaH0d9ZhQaQmDK46uIQOcu4d1D8YFwIF
         PMP8O9iU6jTzMKKW31zeWn9Yrx59nYFs1nBVH1r5da6SoR1yRuU5Rwey4ogFaFBsiu
         s0Zd9UtqkFV/iUSr8sxSccZqQMTRj2UsoZUB9lLgbdjw/OHvO4XNytBlg6nZ8oXOM8
         g9yV9iU1Yfm7nBgo363ADgzLnuBOXbsM8xCXZ6epB9+7fxx7YIaFRWtwwdREYNuuB8
         TATl2hHS6gpDA==
Date:   Wed, 15 Feb 2023 08:24:52 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     stable@vger.kernel.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, chandan.babu@oracle.com
Subject: Re: [PATCH 5.15 00/10] xfs backports for 5.15.y
Message-ID: <Y+0HVLgoXMWCAtYX@magnolia>
References: <20230214212534.1420323-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214212534.1420323-1-leah.rumancik@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 14, 2023 at 01:25:24PM -0800, Leah Rumancik wrote:
> Hello,
> 
> Here is the next batch of backports for 5.15.y. These patches have
> already been ACK'd on the xfs mailing list. Testing included
> 25 runs of auto group on 12 xfs configs. No regressions were seen.
> I checked xfs/538 was run without issue as this test was mentioned
> in 56486f307100. Also, from 86d40f1e49e9, I ran ran xfs/117 with
> XFS compiled as a module and TEST_FS_MODULE_REOLOAD set, but I was
> unable to reproduce the issue.
> 
> Below I've outlined which series the backports came from:
> 
> series "xfs: intent whiteouts" (1):
> [01/10] cb512c921639613ce03f87e62c5e93ed9fe8c84d
>     xfs: zero inode fork buffer at allocation
> [02/10] c230a4a85bcdbfc1a7415deec6caf04e8fca1301
>     xfs: fix potential log item leak
> 
> series "xfs: fix random format verification issues" (2):
> [1/4] dc04db2aa7c9307e740d6d0e173085301c173b1a
>     xfs: detect self referencing btree sibling pointers
> [2/4] 1eb70f54c445fcbb25817841e774adb3d912f3e8 -> already in 5.15.y
>     xfs: validate inode fork size against fork format
> [3/4] dd0d2f9755191690541b09e6385d0f8cd8bc9d8f
>     xfs: set XFS_FEAT_NLINK correctly
> [4/4] f0f5f658065a5af09126ec892e4c383540a1c77f
>     xfs: validate v5 feature fields
> 
> series "xfs: small fixes for 5.19 cycle" (3):
> [1/3] 5672225e8f2a872a22b0cecedba7a6644af1fb84
>     xfs: avoid unnecessary runtime sibling pointer endian conversions
> [2/3] 5b55cbc2d72632e874e50d2e36bce608e55aaaea
>     fs: don't assert fail on perag references on teardown
> [2/3] 56486f307100e8fc66efa2ebd8a71941fa10bf6f
>     xfs: assert in xfs_btree_del_cursor should take into account error
> 
> series "xfs: random fixes for 5.19" (4):
> [1/2] 86d40f1e49e9a909d25c35ba01bea80dbcd758cb
>     xfs: purge dquots after inode walk fails during quotacheck
> [2/2] a54f78def73d847cb060b18c4e4a3d1d26c9ca6d
>     xfs: don't leak btree cursor when insrec fails after a split

Looks good!
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> (1) https://lore.kernel.org/all/20220503221728.185449-1-david@fromorbit.com/
> (2) https://lore.kernel.org/all/20220502082018.1076561-1-david@fromorbit.com/
> (3) https://lore.kernel.org/all/20220524022158.1849458-1-david@fromorbit.com/
> (4) https://lore.kernel.org/all/165337056527.993079.1232300816023906959.stgit@magnolia/
> 
> - Leah
> 
> Darrick J. Wong (2):
>   xfs: purge dquots after inode walk fails during quotacheck
>   xfs: don't leak btree cursor when insrec fails after a split
> 
> Dave Chinner (8):
>   xfs: zero inode fork buffer at allocation
>   xfs: fix potential log item leak
>   xfs: detect self referencing btree sibling pointers
>   xfs: set XFS_FEAT_NLINK correctly
>   xfs: validate v5 feature fields
>   xfs: avoid unnecessary runtime sibling pointer endian conversions
>   xfs: don't assert fail on perag references on teardown
>   xfs: assert in xfs_btree_del_cursor should take into account error
> 
>  fs/xfs/libxfs/xfs_ag.c         |   3 +-
>  fs/xfs/libxfs/xfs_btree.c      | 175 +++++++++++++++++++++++++--------
>  fs/xfs/libxfs/xfs_inode_fork.c |  12 ++-
>  fs/xfs/libxfs/xfs_sb.c         |  70 +++++++++++--
>  fs/xfs/xfs_bmap_item.c         |   2 +
>  fs/xfs/xfs_icreate_item.c      |   1 +
>  fs/xfs/xfs_qm.c                |   9 +-
>  fs/xfs/xfs_refcount_item.c     |   2 +
>  fs/xfs/xfs_rmap_item.c         |   2 +
>  9 files changed, 221 insertions(+), 55 deletions(-)
> 
> -- 
> 2.39.1.581.gbfd45094c4-goog
> 
