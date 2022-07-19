Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCCF579F93
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239644AbiGSN0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237477AbiGSN02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:26:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4456FD8126;
        Tue, 19 Jul 2022 05:42:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5562B81B29;
        Tue, 19 Jul 2022 12:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2B0C341C6;
        Tue, 19 Jul 2022 12:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658234523;
        bh=6dQmBIkrc9O8Sm5HFnAjLAH6QQP59ojwGuIzKpNYx4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zI22xcAZGR1yt20Zri4/DwWeKPMu0qNTVL1ixAWASobCz555vTgO+5cfBz6h9VFKj
         kj+TqhsE99D469y2cEQyUnEQe1s9wLC+TK3P2ap2J4pJHNlXTPbwUtgnRNoPwcGOgl
         j7bbTH2w83ENv19t0RU/eB1TlcDo9gj1toQyO/zc=
Date:   Tue, 19 Jul 2022 14:25:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     stable@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, ritesh.list@gmail.com,
        lczerner@redhat.com, enwlinux@gmail.com,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        yebin10@huawei.com, yukuai3@huawei.com,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH 4.19] ext4: fix race condition between
 ext4_ioctl_setflags and ext4_fiemap
Message-ID: <YtairkXvrX6IZfrR@kroah.com>
References: <20220715023928.2701166-1-libaokun1@huawei.com>
 <YtF1XygwvIo2Dwae@kroah.com>
 <425ab528-7d9a-975a-7f4c-5f903cedd8bc@huawei.com>
 <YtaVAWMlxrQNcS34@kroah.com>
 <ffb13c36-521e-0e06-8fd6-30b0fec727da@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ffb13c36-521e-0e06-8fd6-30b0fec727da@huawei.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 08:15:13PM +0800, Baokun Li wrote:
> 在 2022/7/19 19:26, Greg KH 写道:
> > On Sat, Jul 16, 2022 at 10:33:30AM +0800, Baokun Li wrote:
> > > 在 2022/7/15 22:10, Greg KH 写道:
> > > > On Fri, Jul 15, 2022 at 10:39:28AM +0800, Baokun Li wrote:
> > > > > This patch and problem analysis is based on v4.19 LTS.
> > > > > The d3b6f23f7167("ext4: move ext4_fiemap to use iomap framework") patch
> > > > > is incorporated in v5.7-rc1. This patch avoids this problem by switching
> > > > > to iomap in ext4_fiemap.
> > > > > 
> > > > > Hulk Robot reported a BUG on stable 4.19.252:
> > > > > ==================================================================
> > > > > kernel BUG at fs/ext4/extents_status.c:762!
> > > > > invalid opcode: 0000 [#1] SMP KASAN PTI
> > > > > CPU: 7 PID: 2845 Comm: syz-executor Not tainted 4.19.252 #46
> > > > > RIP: 0010:ext4_es_cache_extent+0x30e/0x370
> > > > > [...]
> > > > > Call Trace:
> > > > >    ext4_cache_extents+0x238/0x2f0
> > > > >    ext4_find_extent+0x785/0xa40
> > > > >    ext4_fiemap+0x36d/0xe90
> > > > >    do_vfs_ioctl+0x6af/0x1200
> > > > > [...]
> > > > > ==================================================================
> > > > > 
> > > > > Above issue may happen as follows:
> > > > > -------------------------------------
> > > > >              cpu1		    cpu2
> > > > > _____________________|_____________________
> > > > > do_vfs_ioctl
> > > > >    ext4_ioctl
> > > > >     ext4_ioctl_setflags
> > > > >      ext4_ind_migrate
> > > > >                           do_vfs_ioctl
> > > > >                            ioctl_fiemap
> > > > >                             ext4_fiemap
> > > > >                              ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)
> > > > >                              ext4_fill_fiemap_extents
> > > > >       down_write(&EXT4_I(inode)->i_data_sem);
> > > > >       ext4_ext_check_inode
> > > > >       ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS)
> > > > >       memset(ei->i_data, 0, sizeof(ei->i_data))
> > > > >       up_write(&EXT4_I(inode)->i_data_sem);
> > > > >                               down_read(&EXT4_I(inode)->i_data_sem);
> > > > >                               ext4_find_extent
> > > > >                                ext4_cache_extents
> > > > >                                 ext4_es_cache_extent
> > > > >                                  BUG_ON(end < lblk)
> > > > > 
> > > > > We can easily reproduce this problem with the syzkaller testcase:
> > > > > ```
> > > > > 02:37:07 executing program 3:
> > > > > r0 = openat(0xffffffffffffff9c, &(0x7f0000000040)='./file0\x00', 0x26e1, 0x0)
> > > > > ioctl$FS_IOC_FSSETXATTR(r0, 0x40086602, &(0x7f0000000080)={0x17e})
> > > > > mkdirat(0xffffffffffffff9c, &(0x7f00000000c0)='./file1\x00', 0x1ff)
> > > > > r1 = openat(0xffffffffffffff9c, &(0x7f0000000100)='./file1\x00', 0x0, 0x0)
> > > > > ioctl$FS_IOC_FIEMAP(r1, 0xc020660b, &(0x7f0000000180)={0x0, 0x1, 0x0, 0xef3, 0x6, []}) (async, rerun: 32)
> > > > > ioctl$FS_IOC_FSSETXATTR(r1, 0x40086602, &(0x7f0000000140)={0x17e}) (rerun: 32)
> > > > > ```
> > > > > 
> > > > > To solve this issue, we use __generic_block_fiemap() instead of
> > > > > generic_block_fiemap() and add inode_lock_shared to avoid race condition.
> > > > > 
> > > > > Reported-by: Hulk Robot <hulkci@huawei.com>
> > > > > Signed-off-by: Baokun Li <libaokun1@huawei.com>
> > > > > ---
> > > > >    fs/ext4/extents.c | 15 +++++++++++----
> > > > >    1 file changed, 11 insertions(+), 4 deletions(-)
> > > > What is the git commit id of this change in Linus's tree?
> > > > 
> > > > If it is not in Linus's tree, why not?
> > > > 
> > > > confused,
> > > > 
> > > > greg k-h
> > > > .
> > > This patch does not exist in the Linus' tree.
> > > 
> > > This problem persists until the patch d3b6f23f7167("ext4: move ext4_fiemap
> > > to use iomap framework") is incorporated in v5.7-rc1.
> > Then why not ask for that change to be added instead?
> > 
> > thanks,
> > 
> > greg k-h
> > .
> 
> If we want to switch to the iomap framework, we need to analyze and
> integrate about 60 patches.
> 
> The workload may be greater than that of solving this problem alone.

95% of the time we take a patch that is not in Linus's tree, it is buggy
and causes problems in the long run.  See what those 60 patches really
require and if this issue really does need all of that.

Or better yet, take the effort here and move off of 4.19 to a newer
kernel without this problem in it.  What is preventing you from doing
that today?  4.19 is not going to be around for forever, and will
probably not even be getting fixes for stuff like RETBLEED, so are you
_SURE_ you want to keep using it?

thanks,

greg k-h
