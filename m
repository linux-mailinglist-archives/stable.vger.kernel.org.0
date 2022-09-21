Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7E55C01BF
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiIUPio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbiIUPiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:38:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA739E6B3;
        Wed, 21 Sep 2022 08:34:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E895662C64;
        Wed, 21 Sep 2022 15:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EF4C433C1;
        Wed, 21 Sep 2022 15:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663774442;
        bh=JhebLJakorI9e3uYtDL3TF6zYEH7dOBs64b2sF4QskI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TKlmOQVLKd1Bl1xAvrpriBI+ECrXyjXs0f4AG/XChZRX6cN53N0W3npSh90M7MXUj
         b0UNp3kSj8SWEp+yoQCqTPKWrxbLU018Mx98tbJkB8MtYOK9XPU5P6fruiR1o8IU40
         ji6xjRpVAPZ7so+7X7lG6KnxodV3xKRJA0MKLIQY=
Date:   Wed, 21 Sep 2022 17:33:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 00/17] xfs stable patches for 5.4.y (from v5.5)
Message-ID: <Yysu56U3OYFozSLD@kroah.com>
References: <20220921032352.307699-1-chandan.babu@oracle.com>
 <YyrS7dE8UtDydjZF@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyrS7dE8UtDydjZF@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 11:01:33AM +0200, Greg KH wrote:
> On Wed, Sep 21, 2022 at 08:53:35AM +0530, Chandan Babu R wrote:
> > Hi Greg,
> > 
> > This 5.4.y backport series contains fixes from v5.5. The patchset has
> > been acked by Darrick.
> > 
> > Brian Foster (2):
> >   xfs: stabilize insert range start boundary to avoid COW writeback race
> >   xfs: use bitops interface for buf log item AIL flag check
> > 
> > Chandan Babu R (1):
> >   MAINTAINERS: add Chandan as xfs maintainer for 5.4.y
> > 
> > Christoph Hellwig (1):
> >   xfs: slightly tweak an assert in xfs_fs_map_blocks
> > 
> > Darrick J. Wong (11):
> >   xfs: replace -EIO with -EFSCORRUPTED for corrupt metadata
> >   xfs: add missing assert in xfs_fsmap_owner_from_rmap
> >   xfs: range check ri_cnt when recovering log items
> >   xfs: attach dquots and reserve quota blocks during unwritten
> >     conversion
> >   xfs: convert EIO to EFSCORRUPTED when log contents are invalid
> >   xfs: constify the buffer pointer arguments to error functions
> >   xfs: always log corruption errors
> >   xfs: fix some memory leaks in log recovery
> >   xfs: refactor agfl length computation function
> >   xfs: split the sunit parameter update into two parts
> >   xfs: don't commit sunit/swidth updates to disk if that would cause
> >     repair failures
> > 
> > Dave Chinner (1):
> >   iomap: iomap that extends beyond EOF should be marked dirty
> > 
> > kaixuxia (1):
> >   xfs: Fix deadlock between AGI and AGF when target_ip exists in
> >     xfs_rename()
> > 
> >  MAINTAINERS                    |   3 +-
> >  fs/xfs/libxfs/xfs_alloc.c      |  27 ++++--
> >  fs/xfs/libxfs/xfs_attr_leaf.c  |  12 ++-
> >  fs/xfs/libxfs/xfs_bmap.c       |  16 +++-
> >  fs/xfs/libxfs/xfs_btree.c      |   5 +-
> >  fs/xfs/libxfs/xfs_da_btree.c   |  24 +++--
> >  fs/xfs/libxfs/xfs_dir2.c       |   4 +-
> >  fs/xfs/libxfs/xfs_dir2.h       |   2 +
> >  fs/xfs/libxfs/xfs_dir2_leaf.c  |   4 +-
> >  fs/xfs/libxfs/xfs_dir2_node.c  |  12 ++-
> >  fs/xfs/libxfs/xfs_dir2_sf.c    |  28 +++++-
> >  fs/xfs/libxfs/xfs_ialloc.c     |  64 +++++++++++++
> >  fs/xfs/libxfs/xfs_ialloc.h     |   1 +
> >  fs/xfs/libxfs/xfs_inode_fork.c |   6 ++
> >  fs/xfs/libxfs/xfs_refcount.c   |   4 +-
> >  fs/xfs/libxfs/xfs_rtbitmap.c   |   6 +-
> >  fs/xfs/xfs_acl.c               |  15 ++-
> >  fs/xfs/xfs_attr_inactive.c     |  10 +-
> >  fs/xfs/xfs_attr_list.c         |   5 +-
> >  fs/xfs/xfs_bmap_item.c         |   7 +-
> >  fs/xfs/xfs_bmap_util.c         |  12 +++
> >  fs/xfs/xfs_buf_item.c          |   2 +-
> >  fs/xfs/xfs_dquot.c             |   2 +-
> >  fs/xfs/xfs_error.c             |  27 +++++-
> >  fs/xfs/xfs_error.h             |   7 +-
> >  fs/xfs/xfs_extfree_item.c      |   5 +-
> >  fs/xfs/xfs_fsmap.c             |   1 +
> >  fs/xfs/xfs_inode.c             |  32 ++++++-
> >  fs/xfs/xfs_inode_item.c        |   5 +-
> >  fs/xfs/xfs_iomap.c             |  17 ++++
> >  fs/xfs/xfs_iops.c              |  10 +-
> >  fs/xfs/xfs_log_recover.c       |  72 +++++++++-----
> >  fs/xfs/xfs_message.c           |   2 +-
> >  fs/xfs/xfs_message.h           |   2 +-
> >  fs/xfs/xfs_mount.c             | 168 +++++++++++++++++++++++----------
> >  fs/xfs/xfs_pnfs.c              |   4 +-
> >  fs/xfs/xfs_qm.c                |  13 ++-
> >  fs/xfs/xfs_refcount_item.c     |   5 +-
> >  fs/xfs/xfs_rmap_item.c         |   9 +-
> >  fs/xfs/xfs_trace.h             |  21 +++++
> >  include/linux/iomap.h          |   2 +
> >  41 files changed, 523 insertions(+), 150 deletions(-)
> > 
> > -- 
> > 2.35.1
> > 
> 
> All now queued up, thanks.

Any specific reason why you didn't also include 2 other commits in this
series, that fix issues that were created by some patches in this
series?

I am referring to:
	496b9bcd62b0 ("xfs: fix use-after-free when aborting corrupt attr inactivation")
	6da1b4b1ab36 ("xfs: fix an ABBA deadlock in xfs_rename")

Do you want me to add them to, or are they not relevant anymore?

thanks,

greg k-h
