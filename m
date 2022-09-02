Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A2B5AA921
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 09:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbiIBHxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 03:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbiIBHxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 03:53:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAF7BB6A2
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 00:52:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95E6A6209C
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 07:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5D8C433C1;
        Fri,  2 Sep 2022 07:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662105175;
        bh=ydzhWkm/ph4fs5HhqOVqe6XTEWILs7pGHIgSZNMT0MM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MoWMFuHrraLrhnx2v8Abd70AVNbloFvEGAfThsLl8lyNZm5bDisTd9tZXjI/Y9REg
         Zrt0DMfKRva3wRD6YAjzHKL/GXLhPZVHrvTg+NndXH6Znmfs2F2u05TpkLpvDHTNrQ
         DjkCwiUBA6qyGWsg4l/5WOuT8ahjGlCqH87iMJTA=
Date:   Fri, 2 Sep 2022 09:52:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Properly reflect IOMMU DMA Protection in 5.15.y+
Message-ID: <YxG2VIMFLXX9k+nx@kroah.com>
References: <MN0PR12MB6101D6CA042DB26E76179482E27A9@MN0PR12MB6101.namprd12.prod.outlook.com>
 <YxGUnAjojULtdhfL@kroah.com>
 <2f525452-fbe8-6780-b552-9ba7c16047e7@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f525452-fbe8-6780-b552-9ba7c16047e7@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 02, 2022 at 12:37:15AM -0500, Mario Limonciello wrote:
> On 9/2/22 00:29, Greg KH wrote:
> > On Fri, Sep 02, 2022 at 03:00:26AM +0000, Limonciello, Mario wrote:
> > > [Public]
> > > 
> > > Hi,
> > > 
> > > A sysfs file /sys/bus/thunderbolt/devices/domainX/iommu_dma_protection is exported from the kernel and used by userspace to make judgments on whether to automatically authorize PCIe tunnels for USB4 devices.
> > > Before kernel 5.19 this file was only populated on Intel USB4 and TBT3 controllers, but starting with 5.19 it also populates for non-Intel as well.
> > 
> > So that's a new kernel feature?
> 
> The sysfs file was there all along, but it always showed "0" for anything
> but Intel systems.  This makes it work properly on everyone else.
> 
> > 
> > > This is accomplished by an assertion from the IOMMU subsystem that it's safe to do so by a combination of firmware and hardware.
> > > 
> > > Here is the patch series on top of 5.15.64:
> > > 
> > > 3f6634d997dba8140b3a7cba01776b9638d70dff
> > > ed36d04e8f8d7b00db451b0fa56a54e8e02ec43e
> > > d0be55fbeb6ac694d15af5d1aad19cdec8cd64e5
> > > f316ba0a8814f4c91e80a435da3421baf0ddd24c
> > > f1ca70717bcb4525e29da422f3d280acbddb36fe
> > > bfb3ba32061da1a9217ef6d02fbcffb528e4c8df
> > > 418e0a3551bbef5b221705b0e5b8412cdc0afd39
> > > acdb89b6c87a2d7b5c48a82756e6f5c6f599f60a
> > > ea4692c75e1c63926e4fb0728f5775ef0d733888
> > > 86eaf4a5b4312bea8676fb79399d9e08b53d8e71
> > > 
> > > Can you please consider backporting them to 5.15.y+?
> > 
> > I don't understand why all of the string helpers are needed just for the
> > last commit, are you sure this is all necessary?
> > 
> The last commit (thunderbolt commit) uses one of them.  That commit for the
> one of them doesn't come back cleanly, but catching all of them up does.
> 
> So I could potentially change the thunderbolt commit to not use the string
> helper, but figured this was cleaner.
> 
> > And again, this feels like new features are being added that are much
> > more than just a "new device id added".  Why not just use 5.19 for this
> > hardware?
> 
> Stuff like this is targeted towards businesses that would want to be using
> LTS kernels.  In fact I heard "But on Intel we just plug in the dock and it
> just works" is what prompted the series in the first place.
> 
> It improves usability quite a bit because without it you need to know to
> manually change the sysfs file for your dock to work or you need to have
> GNOME installed and go and find the panel to change it.
> 
> With this sysfs file is showing the right value you get all that happening
> automatically.

I understand the wish to have hardware work on older kernel versions,
but in looking over the full patch series here, it's not just a trivial
addition.  This is adding lots of things that were never in 5.15 to
start with for AMD hardware (and touching other platform's code at the
same time), which is fine for newer kernels, but not to backport to
older ones.

Here's the overall diffstat of what you are asking for:

 drivers/iommu/amd/amd_iommu_types.h |  4 ++++
 drivers/iommu/amd/init.c            |  3 +++
 drivers/iommu/amd/iommu.c           |  2 ++
 drivers/iommu/dma-iommu.c           |  5 +++++
 drivers/iommu/intel/iommu.c         |  2 ++
 drivers/iommu/iommu.c               | 73 ++++++++++++++++++++++++++++++++++++++++++++++++-------------------------
 drivers/thunderbolt/domain.c        | 12 +++---------
 drivers/thunderbolt/nhi.c           | 44 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/iommu.h               | 19 +++++++++++++++++++
 include/linux/string_helpers.h      | 25 +++++++++++++++++++++++++
 include/linux/thunderbolt.h         |  2 ++
 lib/string_helpers.c                | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 12 files changed, 221 insertions(+), 34 deletions(-)

The string helpers are trivial, but those iommu changes were not.

As proof of that, you missed some fixes in the kernel tree for the above
requested commits that would have caused problems.  Heck, even the
string helpers needed a fix that you missed, so I was wrong in saying
they were trivial!

So if I would have taken these commits as asked for, they might not have
even worked properly and caused problems for people.  So for that reason
alone I would have had to reject this request.

Remember, stable kernels are not for "new hardware enablement", unlike
how some distro kernels work.  If you wanted this hardware to be
supported for last year's stable kernel release, you all would have done
the work back then to get it accepted as obviously you all had the
hardware back then and knew it was going to be an issue.

Just point any user of this hardware to the latest kernel release, and
all will be fine.  And work on getting your new hardware supported
upstream quicker please.  That will prevent this issue from happening
again in the future.

thanks,

greg k-h
