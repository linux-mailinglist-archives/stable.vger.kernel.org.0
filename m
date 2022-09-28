Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFC45ED56F
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 08:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbiI1GyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 02:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbiI1Gxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 02:53:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B7563F2;
        Tue, 27 Sep 2022 23:51:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15835B81EF3;
        Wed, 28 Sep 2022 06:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5611AC433C1;
        Wed, 28 Sep 2022 06:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664347911;
        bh=dgw5f7X+AyhVCxQYLvXsTNyRYiQwWoKk4kYT5DaqxEk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qFQjOKqux1WcsTvo7rOzor89HDfOi14FzytRmeaQQNNvO+vo14+W1SOXolmGAZnYh
         5RMUNwmtjXw3dMtoeGB+SfjhHXHbvh944c5mwGRPCfZiiJEMV6Q4lADGU+kRDh2JTL
         T//bRYGYjM34gpA0+H6Q/ZjQbFVe8HD6MkSugP4A=
Date:   Wed, 28 Sep 2022 08:51:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kurt Garloff <kurt@garloff.de>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Sasha Levin <sashal@kernel.org>,
        "anna@kernel.org" <anna@kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "it+linux-nfs@molgen.mpg.de" <it+linux-nfs@molgen.mpg.de>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        Trond Myklebust <trondmy@hammerspace.com>
Subject: Re: nfs_scan_commit: BUG: unable to handle page fault for address:
 000000001d473c07
Message-ID: <YzPvBLBTyISlNz4k@kroah.com>
References: <c5d8485b-0dbc-5192-4dc6-10ef2b86b520@molgen.mpg.de>
 <e845f65cb78d31aa1982da4bc752ee2e5191f10f.camel@hammerspace.com>
 <ae96779e-e3a7-b4b5-78fc-e5b53d456ece@molgen.mpg.de>
 <ef08bf84da796db2a85549d882d655a370deb835.camel@hammerspace.com>
 <0e1263a1-9d3d-a6cf-deb7-197ab1eed437@leemhuis.info>
 <5dc1b00f-0451-bb0d-56e4-6c178d3c2ce7@garloff.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5dc1b00f-0451-bb0d-56e4-6c178d3c2ce7@garloff.de>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 27, 2022 at 08:59:31PM +0200, Kurt Garloff wrote:
> Hi Thorsten,
> 
> thanks for collecting this issue and providing relevant context!
> 
> On 26/09/2022 08:00, Thorsten Leemhuis wrote:
> 
> > [adding Greg and Sasha to the recipients, to ensure they see this; CCing
> > Kurt as well, to keep him in the loop]
> > 
> > On 22.09.22 15:44, Trond Myklebust wrote:
> > > On Thu, 2022-09-22 at 13:42 +0200, Paul Menzel wrote:
> > > > Am 21.09.22 um 14:44 schrieb Trond Myklebust:
> > > > > On Wed, 2022-09-21 at 13:42 +0200, Paul Menzel wrote:
> > > > > > Moving from Linux 5.10.113 to 5.15.69, starting Mozilla
> > > > > > Thunderbird or
> > > > > > Mozilla Firefox with the home on NFS, both programs get killed,
> > > > > > and
> > > > > > Linux 5.15.69 logs:
> > > > > > 
> > > > > > ```
> > > > > > [ 3827.604396] BUG: unable to handle page fault for address:
> > > > > > 000000001d473c07
> > > > > > [ 3827.611297] #PF: supervisor read access in kernel mode
> > > > > > [ 3827.616452] #PF: error_code(0x0000) - not-present page
> > > > > > [ 3827.621604] PGD 0 P4D 0
> > > > > > [ 3827.624152] Oops: 0000 [#1] SMP PTI
> > > > > > [ 3827.627657] CPU: 0 PID: 2378 Comm: firefox Not tainted
> > > > > > 5.15.69.mx64.435 #1
> > > > > > [ 3827.634551] Hardware name: Dell Inc. Precision Tower
> > > > > > 3620/0MWYPT, BIOS 2.20.0 12/09/2021
> > > > […]
> > > > 
> > > > > > [ 3827.743328] Call Trace:
> > > > > > [ 3827.745779]  <TASK>
> > > > > > [ 3827.747883]  nfs_scan_commit+0x76/0xb0 [nfs]
> > > > > > [ 3827.752167]  __nfs_commit_inode+0x108/0x180 [nfs]
> > > > > > [ 3827.756886]  nfs_wb_all+0x59/0x110 [nfs]
> > > > > > [ 3827.760822]  nfs4_inode_return_delegation+0x58/0x90 [nfsv4]
> > > > > > [ 3827.766413]  nfs4_proc_remove+0x101/0x110 [nfsv4]
> > > > > > [ 3827.771130]  nfs_unlink+0xf5/0x2d0 [nfs]
> > > > > > [ 3827.775065]  vfs_unlink+0x10b/0x280
> > > > > > [ 3827.778563]  do_unlinkat+0x19e/0x2c0
> > > > > > [ 3827.782158]  __x64_sys_unlink+0x3e/0x60
> > > > > > [ 3827.786002]  ? __x64_sys_readlink+0x1b/0x30
> > > > > > [ 3827.790192]  do_syscall_64+0x40/0x90
> > > > > > [ 3827.793779]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
> > > > […]
> > > > 
> > > > > > ```
> > > > > > 
> > > > > Does cherry-picking commit 6e176d47160c ("NFSv4: Fixes for
> > > > > nfs4_inode_return_delegation()") into 5.15.69 from the upstream
> > > > > kernel
> > > > > tree fix the problem?
> > > > > 
> > > > > 8<---------------------------------------------------
> > > > >  From 6e176d47160cec8bcaa28d9aa06926d72d54237c Mon Sep 17 00:00:00
> > > > > 2001
> > > > > From: Trond Myklebust <trond.myklebust@hammerspace.com>
> > > > > Date: Sun, 10 Oct 2021 10:58:12 +0200
> > > > > Subject: [PATCH] NFSv4: Fixes for nfs4_inode_return_delegation()
> > > > […]
> > > > 
> > > > Indeed with that commit, present since v5.16-rc1, we are unable to
> > > > reproduce the issue, so it seems to be the fix. It looks like there
> > > > are
> > > > not a lot of 5.15 NFS users out there. ;-)
> > > > 
> > > I believe this is a dependency that was introduced by the back port of
> > > commit e591b298d7ec ("NFS: Save some space in the inode") into 5.15.68.
> > > So the reason it wasn't seen is because the change is very recent.
> > Side note: I wonder if that is causing this problem from Kurt as well:
> > https://lore.kernel.org/all/f6755107-b62c-a388-0ab5-0a6633bf9082@garloff.de/
> 
> Looks like it:
> After confirming that the 5.15.69 kernel worked again fine backing out
> those last three NFS commits, I reapplied them and cherry-picked commit
> 6e176d47160c as suggested. The kernel worked flawlessly thus far, so this
> seems to indeed be a requirement for e591b298d7ec not to cause harm.
> 
> > > FYI Greg and Sasha: please also consider pulling 6e176d47160c ("NFSv4:
> > > Fixes for nfs4_inode_return_delegation()") into that stable series.
> > Greg, I noticed you in the past few days added quite a few patches into
> > the queue for the next 5.15.y release, but this one was not among them
> > afaics. So just to be sure: is that still on your todo list or is more
> > needed to get 6e176d47160c added in time for the next stable -rc?
> 
> So by all means, Greg, please put this in the stable queue unless the
> NFS wizards out there consider it safer to revert e591b298d7ec instead.

Already queued up for the next 5.15.y release that will happen in a few
hours, thanks for testing.

greg k-h
