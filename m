Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E8A50FD05
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 14:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbiDZMdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 08:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346613AbiDZMdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 08:33:19 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D48C20F56
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 05:30:11 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id z99so22127710ede.5
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 05:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aIwyEe6pw8BoST7kzB3chnuVOcOnUCeAaOG42SeMGJo=;
        b=FER0zH/anDThkLCd4JUSyAUk33bOhJ5RWhoEdNcWPeQtbAJjB+wZCnpxsRV3tE6QAr
         fYbj3n3bsQLmNjQ+J+8ySGpX3Ef9WxBIk8NaM8/ZsL61gY/zn61bHipu9PkReCiy4OCB
         rUJqE+nG6xfGosHH47zkZCgChZlDXeZwLSFlA8p6Ua8nKvRap0j0PxU48OCDLn4CO9bJ
         tXpkiDxjRiN8Ca7HkmuN9qE+cKOlJ4G0P0/gFO/Sxi6qQtkIPxf+vKZ0ixQYXk7tRyUR
         //EGEyt15Z+nogETq0zAnVQyQAFVysMJ40wtR1waQaw3KYbAEA8wBLIylcRmExo3UiTe
         /hTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aIwyEe6pw8BoST7kzB3chnuVOcOnUCeAaOG42SeMGJo=;
        b=jqiGTbx13vgeCfFeP082FmxASwU+eQcSBrjCyFlTDmub5RdM1njIoQbkllWoHi35aQ
         vYLSnj/wYy/ZVmvZy5vJZ0AcgmU8q+O7suOeuTamcqVKEHituyJ32lY6JIlexAKfu0fa
         md6eN2vFz+TakWcp2wVlrJBLxbBcE3qquGqJtyYSF2xfkueGpiu6J5+UXAWSJQQk5au3
         jPI6QJDlbCKrENCV4ogD3mrPggkDekcKEWSMutoTi9gW6asMKjetpAAt8RTzPYtZC32p
         UNRPCFspTNO7D5Xv8wdMJrCEq41bGLGC+2QP5QH5Iu0yz5DQiXWFX5eLwNHKuOuR92W3
         g5OQ==
X-Gm-Message-State: AOAM531vXaqe5V0VYuzAVh6m7Mjm2Ari6Lx0lTlNMlYtC2DvWtSJH9Q0
        fYO57zUK3wtR3GI3NHJEvLkndSTv3ReRyPI9n4qU
X-Google-Smtp-Source: ABdhPJw6KD31osaYUI1RDGU2+2glczm0r6BUqyAw7SsLOG1AKRdy+Bj9NQPoKU5PZOnHtW/Ud9hB8eygTqRLHWvuDbc=
X-Received: by 2002:a05:6402:51d2:b0:424:536:94dd with SMTP id
 r18-20020a05640251d200b00424053694ddmr24575637edd.191.1650976209877; Tue, 26
 Apr 2022 05:30:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220426073656.229-1-xieyongji@bytedance.com> <YmeoSuMfsdVxuGlf@kroah.com>
 <CACycT3sLgihkgX5cB6GxDehaTsPn9rqhtWF7G_=J=__oTopJZw@mail.gmail.com> <YmfIv2YuARnPe97k@kroah.com>
In-Reply-To: <YmfIv2YuARnPe97k@kroah.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 26 Apr 2022 20:30:38 +0800
Message-ID: <CACycT3sq6WM1uCa+ix79AwTJHaEOhkLycwkZOhqPhABZ4xa2AA@mail.gmail.com>
Subject: Re: [PATCH v2] vduse: Fix NULL pointer dereference on sysfs access
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kernel test robot <oliver.sang@intel.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 6:26 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Apr 26, 2022 at 05:41:15PM +0800, Yongji Xie wrote:
> > On Tue, Apr 26, 2022 at 4:07 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Apr 26, 2022 at 03:36:56PM +0800, Xie Yongji wrote:
> > > > The control device has no drvdata. So we will get a
> > > > NULL pointer dereference when accessing control
> > > > device's msg_timeout attribute via sysfs:
> > > >
> > > > [ 132.841881][ T3644] BUG: kernel NULL pointer dereference, address: 00000000000000f8
> > > > [ 132.850619][ T3644] RIP: 0010:msg_timeout_show (drivers/vdpa/vdpa_user/vduse_dev.c:1271)
> > > > [ 132.869447][ T3644] dev_attr_show (drivers/base/core.c:2094)
> > > > [ 132.870215][ T3644] sysfs_kf_seq_show (fs/sysfs/file.c:59)
> > > > [ 132.871164][ T3644] ? device_remove_bin_file (drivers/base/core.c:2088)
> > > > [ 132.872082][ T3644] kernfs_seq_show (fs/kernfs/file.c:164)
> > > > [ 132.872838][ T3644] seq_read_iter (fs/seq_file.c:230)
> > > > [ 132.873578][ T3644] ? __vmalloc_area_node (mm/vmalloc.c:3041)
> > > > [ 132.874532][ T3644] kernfs_fop_read_iter (fs/kernfs/file.c:238)
> > > > [ 132.875513][ T3644] __kernel_read (fs/read_write.c:440 (discriminator 1))
> > > > [ 132.876319][ T3644] kernel_read (fs/read_write.c:459)
> > > > [ 132.877129][ T3644] kernel_read_file (fs/kernel_read_file.c:94)
> > > > [ 132.877978][ T3644] kernel_read_file_from_fd (include/linux/file.h:45 fs/kernel_read_file.c:186)
> > > > [ 132.879019][ T3644] __do_sys_finit_module (kernel/module.c:4207)
> > > > [ 132.879930][ T3644] __ia32_sys_finit_module (kernel/module.c:4189)
> > > > [ 132.880930][ T3644] do_int80_syscall_32 (arch/x86/entry/common.c:112 arch/x86/entry/common.c:132)
> > > > [ 132.881847][ T3644] entry_INT80_compat (arch/x86/entry/entry_64_compat.S:419)
> > > >
> > > > To fix it, don't create the unneeded attribute for
> > > > control device anymore.
> > > >
> > > > Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
> > > > Reported-by: kernel test robot <oliver.sang@intel.com>
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > > ---
> > > >  drivers/vdpa/vdpa_user/vduse_dev.c | 7 +++----
> > > >  1 file changed, 3 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
> > > > index f85d1a08ed87..160e40d03084 100644
> > > > --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> > > > +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> > > > @@ -1344,9 +1344,9 @@ static int vduse_create_dev(struct vduse_dev_config *config,
> > > >
> > > >       dev->minor = ret;
> > > >       dev->msg_timeout = VDUSE_MSG_DEFAULT_TIMEOUT;
> > > > -     dev->dev = device_create(vduse_class, NULL,
> > > > -                              MKDEV(MAJOR(vduse_major), dev->minor),
> > > > -                              dev, "%s", config->name);
> > > > +     dev->dev = device_create_with_groups(vduse_class, NULL,
> > > > +                             MKDEV(MAJOR(vduse_major), dev->minor),
> > > > +                             dev, vduse_dev_groups, "%s", config->name);
> > > >       if (IS_ERR(dev->dev)) {
> > > >               ret = PTR_ERR(dev->dev);
> > > >               goto err_dev;
> > > > @@ -1595,7 +1595,6 @@ static int vduse_init(void)
> > > >               return PTR_ERR(vduse_class);
> > > >
> > > >       vduse_class->devnode = vduse_devnode;
> > > > -     vduse_class->dev_groups = vduse_dev_groups;
> > >
> > > Ok, this looks much better.
> > >
> > > But wow, there are some problems in this code overall.  I see a number
> > > of flat-out-wrong things in there that should have been caught by code
> > > reviews.  Some examples:
> > >         - empty release() callbacks.  That is a huge sign the code
> > >           design is wrong and broken and you are just trying to make the
> > >           driver core quiet for some reason.  The documentation in the
> > >           kernel explains why this is not ok.
> >
> > Sorry, I failed to find the documentation. Do you mean we should
> > remove the empty release() callbacks?
>
> Yes, why are they needed?
>
> (hint, retorical question, you added them to remove the driver core
> warning when the device is removed, which means someone added them just
> because they thought that their code could ignore the hints that the
> driver core was telling them.)
>

OK, I see.

> Please properly free the memory here.
>

One question is how to deal with the case if the device/kobject is
defined as a static variable. We should not need to free any resources
in this case. Or do you suggest just using dynamic allocation here?

> > >         - __module_get(THIS_MODULE);  That's racy, buggy, and doesn't do
> > >           what you think it does.  Please never ever ever do that.  It
> > >           too is a sign of a broken design.
> >
> > I don't find a good way to remove it. We have to make sure the module
> > can't be removed until all vduse devices are destroyed.
>
> That will happen automatically when the module is removed.
>
> > And I think __module_get(THIS_MODULE) should be safe in our case since
> > we always call it when we have a reference from open().
>
> What happened if someone removed the module _right before_ this was
> called?  You can not grab your own reference count safely.
>

I don't get you here. We should already grab a reference count from
open() before calling this. So it should fail if someone tries to
remove the module at this time.

> Please just remove it, it's not needed and is broken.  There should not
> be any reason that the module can not be unloaded, UNLESS a file handle
> is open, and you properly handle that already.
>

But in our case, I think we should prevent unloading the module If we
already created some vduse devices via /dev/vduse/control (note that
the control device's file handle could be closed after device
creation). Otherwise, we might get some crashes when accessing those
created vduse devices.

Thanks,
Yongji
