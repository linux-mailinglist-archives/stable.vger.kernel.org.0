Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78AB50F9F8
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 12:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345561AbiDZKR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 06:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345262AbiDZKRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 06:17:10 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5066D845
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 02:40:47 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b24so21568896edu.10
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 02:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rTJ2o0jAXG371kRJBCt46VAP7HH9uQ1lUQ+60vQhb8U=;
        b=ESHVQCRWzhYrYV7P/yohdj/c8m7oBmCP1iopBWrYnergsXrofcaeDVLZIY39UJbcKb
         oO1cQUOVpGe4oT9CG8BpteNv8Zk1rC/zJ86yGpxjEawCC+jW7d1Hgw/0DPIqARaAeXBu
         SMN8ochUfp4MFfaj8i92h/VrEmfo2XBO5KkSmr/uTCQvlhjznLPKto9h2F+l2B8udsqu
         LgeFrtt1RiCCEymd2d+3e+VfQvQe3B00M7LwRNl6olaXFd15h/xt3D88wOt5Sa13lySF
         k2Q4izo1JJ8spmD34k58JugRBm0cOdX7Zoot/wGRrHJLJHNxNAVXdDuw1vYm1e/NqWFn
         2j/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rTJ2o0jAXG371kRJBCt46VAP7HH9uQ1lUQ+60vQhb8U=;
        b=BVLXrvvyuxdPH1GoH3dwVoF7vHntsPOVMPPDYO693oTFUGei2dMXeXqLGGNjXP2DSs
         aB7HumNf0YTFsq5SpdW2kA35qeO5RTuQg81LTULfBF6d7m7PCT5qqedXALcdqlDtowP4
         6+vl7k9CNVHLHWxgW7yMHCtvg3OuxJ4T7f0f3OxNH9s21K7yLt8YLJqldLDe8qVpN9ur
         u1d4N8lY3YkPXGJVJqo7QP0049HHjIeW3at0R91YJUorxBtdhp5SU419Dmo1GClB8A+u
         DCpGy+GzTT3d+UVsmBAi7zQoccHOClNsXZnmOKMvtgikSfum9e4KzzPbJrkDS2kXuXx3
         QgfA==
X-Gm-Message-State: AOAM533hW0NCvCIT19hoL4gOy94qOFTrPqgDYC2gTsw8t/GoujMHkD96
        unDjQbtn8krFDZ6IJygFVEFLpTlGfUAoVkf+zFTs
X-Google-Smtp-Source: ABdhPJwk/pt52n673idOUBUeMyg6t4EYUxACDpkns3cFM+YhAxTctP6QV7+/FJiO9F7Z3NNQrKzBbGomDowm+7y8zbo=
X-Received: by 2002:aa7:cac5:0:b0:41c:c1fb:f5cc with SMTP id
 l5-20020aa7cac5000000b0041cc1fbf5ccmr22875861edt.219.1650966046458; Tue, 26
 Apr 2022 02:40:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220426073656.229-1-xieyongji@bytedance.com> <YmeoSuMfsdVxuGlf@kroah.com>
In-Reply-To: <YmeoSuMfsdVxuGlf@kroah.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 26 Apr 2022 17:41:15 +0800
Message-ID: <CACycT3sLgihkgX5cB6GxDehaTsPn9rqhtWF7G_=J=__oTopJZw@mail.gmail.com>
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

On Tue, Apr 26, 2022 at 4:07 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Apr 26, 2022 at 03:36:56PM +0800, Xie Yongji wrote:
> > The control device has no drvdata. So we will get a
> > NULL pointer dereference when accessing control
> > device's msg_timeout attribute via sysfs:
> >
> > [ 132.841881][ T3644] BUG: kernel NULL pointer dereference, address: 00000000000000f8
> > [ 132.850619][ T3644] RIP: 0010:msg_timeout_show (drivers/vdpa/vdpa_user/vduse_dev.c:1271)
> > [ 132.869447][ T3644] dev_attr_show (drivers/base/core.c:2094)
> > [ 132.870215][ T3644] sysfs_kf_seq_show (fs/sysfs/file.c:59)
> > [ 132.871164][ T3644] ? device_remove_bin_file (drivers/base/core.c:2088)
> > [ 132.872082][ T3644] kernfs_seq_show (fs/kernfs/file.c:164)
> > [ 132.872838][ T3644] seq_read_iter (fs/seq_file.c:230)
> > [ 132.873578][ T3644] ? __vmalloc_area_node (mm/vmalloc.c:3041)
> > [ 132.874532][ T3644] kernfs_fop_read_iter (fs/kernfs/file.c:238)
> > [ 132.875513][ T3644] __kernel_read (fs/read_write.c:440 (discriminator 1))
> > [ 132.876319][ T3644] kernel_read (fs/read_write.c:459)
> > [ 132.877129][ T3644] kernel_read_file (fs/kernel_read_file.c:94)
> > [ 132.877978][ T3644] kernel_read_file_from_fd (include/linux/file.h:45 fs/kernel_read_file.c:186)
> > [ 132.879019][ T3644] __do_sys_finit_module (kernel/module.c:4207)
> > [ 132.879930][ T3644] __ia32_sys_finit_module (kernel/module.c:4189)
> > [ 132.880930][ T3644] do_int80_syscall_32 (arch/x86/entry/common.c:112 arch/x86/entry/common.c:132)
> > [ 132.881847][ T3644] entry_INT80_compat (arch/x86/entry/entry_64_compat.S:419)
> >
> > To fix it, don't create the unneeded attribute for
> > control device anymore.
> >
> > Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >  drivers/vdpa/vdpa_user/vduse_dev.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
> > index f85d1a08ed87..160e40d03084 100644
> > --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> > +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> > @@ -1344,9 +1344,9 @@ static int vduse_create_dev(struct vduse_dev_config *config,
> >
> >       dev->minor = ret;
> >       dev->msg_timeout = VDUSE_MSG_DEFAULT_TIMEOUT;
> > -     dev->dev = device_create(vduse_class, NULL,
> > -                              MKDEV(MAJOR(vduse_major), dev->minor),
> > -                              dev, "%s", config->name);
> > +     dev->dev = device_create_with_groups(vduse_class, NULL,
> > +                             MKDEV(MAJOR(vduse_major), dev->minor),
> > +                             dev, vduse_dev_groups, "%s", config->name);
> >       if (IS_ERR(dev->dev)) {
> >               ret = PTR_ERR(dev->dev);
> >               goto err_dev;
> > @@ -1595,7 +1595,6 @@ static int vduse_init(void)
> >               return PTR_ERR(vduse_class);
> >
> >       vduse_class->devnode = vduse_devnode;
> > -     vduse_class->dev_groups = vduse_dev_groups;
>
> Ok, this looks much better.
>
> But wow, there are some problems in this code overall.  I see a number
> of flat-out-wrong things in there that should have been caught by code
> reviews.  Some examples:
>         - empty release() callbacks.  That is a huge sign the code
>           design is wrong and broken and you are just trying to make the
>           driver core quiet for some reason.  The documentation in the
>           kernel explains why this is not ok.

Sorry, I failed to find the documentation. Do you mean we should
remove the empty release() callbacks?

>         - __module_get(THIS_MODULE);  That's racy, buggy, and doesn't do
>           what you think it does.  Please never ever ever do that.  It
>           too is a sign of a broken design.

I don't find a good way to remove it. We have to make sure the module
can't be removed until all vduse devices are destroyed.

And I think __module_get(THIS_MODULE) should be safe in our case since
we always call it when we have a reference from open().

>         - no Documentation/ABI/ entries for the sysfs files here.  I
>           think it's burried in some other documentation file but that's
>           not the correct place for it and if you run scripts/get_abi.pl
>           with the code loaded it will rightly complain about this.
>

OK, I will add one.

> Do you want to address these, or do you want patches for them?
>

Let me send some individual patches for them.

Thanks,
Yongji
