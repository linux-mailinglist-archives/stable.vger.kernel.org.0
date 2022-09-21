Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890185BFA05
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 11:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiIUJCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 05:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiIUJCT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 05:02:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06228857E7;
        Wed, 21 Sep 2022 02:02:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6538CB82EC6;
        Wed, 21 Sep 2022 09:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BC4C433C1;
        Wed, 21 Sep 2022 09:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663750931;
        bh=/Hc3OgBN6R6g+SbhVdDMl56jPmzJ6KYpC0YKu675wTs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hSpypWQxvJ5DvRm0FQkIAocXE0dyS7DG6l5STuw9ZZgrEVaGX2Ou/sjgoLkcRqexe
         oyt7xvbbyslMS4b+3OGFwAXdJ1us5B+rlFzLhSC+66JGE8tcIhIuvMRZcjhmRohjJm
         u7jud5PdTET3M1+q/0TJ56XmW2skIIenSs1LWQ+Q=
Date:   Wed, 21 Sep 2022 11:01:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 00/17] xfs stable patches for 5.4.y (from v5.5)
Message-ID: <YyrS7dE8UtDydjZF@kroah.com>
References: <20220921032352.307699-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921032352.307699-1-chandan.babu@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 08:53:35AM +0530, Chandan Babu R wrote:
> Hi Greg,
> 
> This 5.4.y backport series contains fixes from v5.5. The patchset has
> been acked by Darrick.
> 
> Brian Foster (2):
>   xfs: stabilize insert range start boundary to avoid COW writeback race
>   xfs: use bitops interface for buf log item AIL flag check
> 
> Chandan Babu R (1):
>   MAINTAINERS: add Chandan as xfs maintainer for 5.4.y
> 
> Christoph Hellwig (1):
>   xfs: slightly tweak an assert in xfs_fs_map_blocks
> 
> Darrick J. Wong (11):
>   xfs: replace -EIO with -EFSCORRUPTED for corrupt metadata
>   xfs: add missing assert in xfs_fsmap_owner_from_rmap
>   xfs: range check ri_cnt when recovering log items
>   xfs: attach dquots and reserve quota blocks during unwritten
>     conversion
>   xfs: convert EIO to EFSCORRUPTED when log contents are invalid
>   xfs: constify the buffer pointer arguments to error functions
>   xfs: always log corruption errors
>   xfs: fix some memory leaks in log recovery
>   xfs: refactor agfl length computation function
>   xfs: split the sunit parameter update into two parts
>   xfs: don't commit sunit/swidth updates to disk if that would cause
>     repair failures
> 
> Dave Chinner (1):
>   iomap: iomap that extends beyond EOF should be marked dirty
> 
> kaixuxia (1):
>   xfs: Fix deadlock between AGI and AGF when target_ip exists in
>     xfs_rename()
> 
>  MAINTAINERS                    |   3 +-
>  fs/xfs/libxfs/xfs_alloc.c      |  27 ++++--
>  fs/xfs/libxfs/xfs_attr_leaf.c  |  12 ++-
>  fs/xfs/libxfs/xfs_bmap.c       |  16 +++-
>  fs/xfs/libxfs/xfs_btree.c      |   5 +-
>  fs/xfs/libxfs/xfs_da_btree.c   |  24 +++--
>  fs/xfs/libxfs/xfs_dir2.c       |   4 +-
>  fs/xfs/libxfs/xfs_dir2.h       |   2 +
>  fs/xfs/libxfs/xfs_dir2_leaf.c  |   4 +-
>  fs/xfs/libxfs/xfs_dir2_node.c  |  12 ++-
>  fs/xfs/libxfs/xfs_dir2_sf.c    |  28 +++++-
>  fs/xfs/libxfs/xfs_ialloc.c     |  64 +++++++++++++
>  fs/xfs/libxfs/xfs_ialloc.h     |   1 +
>  fs/xfs/libxfs/xfs_inode_fork.c |   6 ++
>  fs/xfs/libxfs/xfs_refcount.c   |   4 +-
>  fs/xfs/libxfs/xfs_rtbitmap.c   |   6 +-
>  fs/xfs/xfs_acl.c               |  15 ++-
>  fs/xfs/xfs_attr_inactive.c     |  10 +-
>  fs/xfs/xfs_attr_list.c         |   5 +-
>  fs/xfs/xfs_bmap_item.c         |   7 +-
>  fs/xfs/xfs_bmap_util.c         |  12 +++
>  fs/xfs/xfs_buf_item.c          |   2 +-
>  fs/xfs/xfs_dquot.c             |   2 +-
>  fs/xfs/xfs_error.c             |  27 +++++-
>  fs/xfs/xfs_error.h             |   7 +-
>  fs/xfs/xfs_extfree_item.c      |   5 +-
>  fs/xfs/xfs_fsmap.c             |   1 +
>  fs/xfs/xfs_inode.c             |  32 ++++++-
>  fs/xfs/xfs_inode_item.c        |   5 +-
>  fs/xfs/xfs_iomap.c             |  17 ++++
>  fs/xfs/xfs_iops.c              |  10 +-
>  fs/xfs/xfs_log_recover.c       |  72 +++++++++-----
>  fs/xfs/xfs_message.c           |   2 +-
>  fs/xfs/xfs_message.h           |   2 +-
>  fs/xfs/xfs_mount.c             | 168 +++++++++++++++++++++++----------
>  fs/xfs/xfs_pnfs.c              |   4 +-
>  fs/xfs/xfs_qm.c                |  13 ++-
>  fs/xfs/xfs_refcount_item.c     |   5 +-
>  fs/xfs/xfs_rmap_item.c         |   9 +-
>  fs/xfs/xfs_trace.h             |  21 +++++
>  include/linux/iomap.h          |   2 +
>  41 files changed, 523 insertions(+), 150 deletions(-)
> 
> -- 
> 2.35.1
> 

All now queued up, thanks.

greg k-h
