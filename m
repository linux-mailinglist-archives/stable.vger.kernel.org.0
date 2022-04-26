Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E94450FD7C
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 14:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238899AbiDZMrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 08:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbiDZMri (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 08:47:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B55177D6B
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 05:44:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25E75B81BEF
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 12:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611D3C385AA;
        Tue, 26 Apr 2022 12:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650977067;
        bh=9yG+KNqJCGXgYQZ2TqI3kb2ZBUi7qY1LYLnAFlSj0S4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QwFupAILyphF1iUIKpxCw7v4SF6UGYA0nZcqlxBBww74orJkb7E6Whac/H2bPg6JH
         X3GCf7kgrZMmQTL7SOrMtAwkVAWU+1mN8tSRzg4IGl5rRDWc/QYR6lbQ69rC9XbKAm
         rz3j7idhsFVvd1BbbngLa/AB3wL+pBlmlr99wnPg=
Date:   Tue, 26 Apr 2022 14:44:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kernel test robot <oliver.sang@intel.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] vduse: Fix NULL pointer dereference on sysfs access
Message-ID: <YmfpKGZB06Ix5WPu@kroah.com>
References: <20220426073656.229-1-xieyongji@bytedance.com>
 <YmeoSuMfsdVxuGlf@kroah.com>
 <CACycT3sLgihkgX5cB6GxDehaTsPn9rqhtWF7G_=J=__oTopJZw@mail.gmail.com>
 <YmfIv2YuARnPe97k@kroah.com>
 <CACycT3sq6WM1uCa+ix79AwTJHaEOhkLycwkZOhqPhABZ4xa2AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACycT3sq6WM1uCa+ix79AwTJHaEOhkLycwkZOhqPhABZ4xa2AA@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 08:30:38PM +0800, Yongji Xie wrote:
> On Tue, Apr 26, 2022 at 6:26 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Apr 26, 2022 at 05:41:15PM +0800, Yongji Xie wrote:
> > > On Tue, Apr 26, 2022 at 4:07 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Tue, Apr 26, 2022 at 03:36:56PM +0800, Xie Yongji wrote:
> > > > > The control device has no drvdata. So we will get a
> > > > > NULL pointer dereference when accessing control
> > > > > device's msg_timeout attribute via sysfs:
> > > > >
> > > > > [ 132.841881][ T3644] BUG: kernel NULL pointer dereference, address: 00000000000000f8
> > > > > [ 132.850619][ T3644] RIP: 0010:msg_timeout_show (drivers/vdpa/vdpa_user/vduse_dev.c:1271)
> > > > > [ 132.869447][ T3644] dev_attr_show (drivers/base/core.c:2094)
> > > > > [ 132.870215][ T3644] sysfs_kf_seq_show (fs/sysfs/file.c:59)
> > > > > [ 132.871164][ T3644] ? device_remove_bin_file (drivers/base/core.c:2088)
> > > > > [ 132.872082][ T3644] kernfs_seq_show (fs/kernfs/file.c:164)
> > > > > [ 132.872838][ T3644] seq_read_iter (fs/seq_file.c:230)
> > > > > [ 132.873578][ T3644] ? __vmalloc_area_node (mm/vmalloc.c:3041)
> > > > > [ 132.874532][ T3644] kernfs_fop_read_iter (fs/kernfs/file.c:238)
> > > > > [ 132.875513][ T3644] __kernel_read (fs/read_write.c:440 (discriminator 1))
> > > > > [ 132.876319][ T3644] kernel_read (fs/read_write.c:459)
> > > > > [ 132.877129][ T3644] kernel_read_file (fs/kernel_read_file.c:94)
> > > > > [ 132.877978][ T3644] kernel_read_file_from_fd (include/linux/file.h:45 fs/kernel_read_file.c:186)
> > > > > [ 132.879019][ T3644] __do_sys_finit_module (kernel/module.c:4207)
> > > > > [ 132.879930][ T3644] __ia32_sys_finit_module (kernel/module.c:4189)
> > > > > [ 132.880930][ T3644] do_int80_syscall_32 (arch/x86/entry/common.c:112 arch/x86/entry/common.c:132)
> > > > > [ 132.881847][ T3644] entry_INT80_compat (arch/x86/entry/entry_64_compat.S:419)
> > > > >
> > > > > To fix it, don't create the unneeded attribute for
> > > > > control device anymore.
> > > > >
> > > > > Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
> > > > > Reported-by: kernel test robot <oliver.sang@intel.com>
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > > > ---
> > > > >  drivers/vdpa/vdpa_user/vduse_dev.c | 7 +++----
> > > > >  1 file changed, 3 insertions(+), 4 deletions(-)
> > > > >
> > > > > diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
> > > > > index f85d1a08ed87..160e40d03084 100644
> > > > > --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> > > > > +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> > > > > @@ -1344,9 +1344,9 @@ static int vduse_create_dev(struct vduse_dev_config *config,
> > > > >
> > > > >       dev->minor = ret;
> > > > >       dev->msg_timeout = VDUSE_MSG_DEFAULT_TIMEOUT;
> > > > > -     dev->dev = device_create(vduse_class, NULL,
> > > > > -                              MKDEV(MAJOR(vduse_major), dev->minor),
> > > > > -                              dev, "%s", config->name);
> > > > > +     dev->dev = device_create_with_groups(vduse_class, NULL,
> > > > > +                             MKDEV(MAJOR(vduse_major), dev->minor),
> > > > > +                             dev, vduse_dev_groups, "%s", config->name);
> > > > >       if (IS_ERR(dev->dev)) {
> > > > >               ret = PTR_ERR(dev->dev);
> > > > >               goto err_dev;
> > > > > @@ -1595,7 +1595,6 @@ static int vduse_init(void)
> > > > >               return PTR_ERR(vduse_class);
> > > > >
> > > > >       vduse_class->devnode = vduse_devnode;
> > > > > -     vduse_class->dev_groups = vduse_dev_groups;
> > > >
> > > > Ok, this looks much better.
> > > >
> > > > But wow, there are some problems in this code overall.  I see a number
> > > > of flat-out-wrong things in there that should have been caught by code
> > > > reviews.  Some examples:
> > > >         - empty release() callbacks.  That is a huge sign the code
> > > >           design is wrong and broken and you are just trying to make the
> > > >           driver core quiet for some reason.  The documentation in the
> > > >           kernel explains why this is not ok.
> > >
> > > Sorry, I failed to find the documentation. Do you mean we should
> > > remove the empty release() callbacks?
> >
> > Yes, why are they needed?
> >
> > (hint, retorical question, you added them to remove the driver core
> > warning when the device is removed, which means someone added them just
> > because they thought that their code could ignore the hints that the
> > driver core was telling them.)
> >
> 
> OK, I see.
> 
> > Please properly free the memory here.
> >
> 
> One question is how to deal with the case if the device/kobject is
> defined as a static variable. We should not need to free any resources
> in this case. Or do you suggest just using dynamic allocation here?

A kobject can NEVER be a static variable[1].  That's not how the driver
model works at all.  If this is how this code is written, it needs to be
fixed.

[1] Ok, yes, drivers and busses and classes have static kobjects, ignore
    them...

> 
> > > >         - __module_get(THIS_MODULE);  That's racy, buggy, and doesn't do
> > > >           what you think it does.  Please never ever ever do that.  It
> > > >           too is a sign of a broken design.
> > >
> > > I don't find a good way to remove it. We have to make sure the module
> > > can't be removed until all vduse devices are destroyed.
> >
> > That will happen automatically when the module is removed.
> >
> > > And I think __module_get(THIS_MODULE) should be safe in our case since
> > > we always call it when we have a reference from open().
> >
> > What happened if someone removed the module _right before_ this was
> > called?  You can not grab your own reference count safely.
> >
> 
> I don't get you here. We should already grab a reference count from
> open() before calling this. So it should fail if someone tries to
> remove the module at this time.

Then why are you trying to grab the module reference again?

> > Please just remove it, it's not needed and is broken.  There should not
> > be any reason that the module can not be unloaded, UNLESS a file handle
> > is open, and you properly handle that already.
> >
> 
> But in our case, I think we should prevent unloading the module If we
> already created some vduse devices via /dev/vduse/control (note that
> the control device's file handle could be closed after device
> creation). Otherwise, we might get some crashes when accessing those
> created vduse devices.

Then the code is written incorrectly, this should not be an issue at
all.  Your devices will all be cleaned up properly before your code is
unloaded from the system.

Note that no other driver or bus does this, what makes this different?

thanks,

greg k-h
