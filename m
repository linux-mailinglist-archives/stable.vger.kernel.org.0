Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E49543143
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 15:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240086AbiFHNYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 09:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240083AbiFHNYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 09:24:41 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42FF17E13
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 06:24:39 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id c2so27052699edf.5
        for <stable@vger.kernel.org>; Wed, 08 Jun 2022 06:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4zXWGfcym220rQoqMln+g1qCeZQVimpcGBnQ/M/+deY=;
        b=dQ4fAtu2uA/rykY5FTpGO7IDbzqr5w0R3da4HYHe0zIYH/5IPCEpQGatnLajpib9eh
         pTwwrGHfosOUDf4cq9pGy7pIEQcSyMkKPC4OEoEO+fZchKrJLfyhZ+zWZ5ReQdj4c39v
         DY1GOz0vJayPlpa01/+dXCQeIh0smfpKhgcUZBnCyTKRXM3tgGmjGOhhGpDGFa0k/Axr
         j/M/dLbnXUJbvYeS1dYnE23sBgg7NGk0YZ1ClksU9bzCO1Xcdb/R5kxZLJ5q/G/OkfH0
         5XDr4pxrbBjrJbE1bBzdxO2ioagfS7L7QPmex9kCUqRy+jxt/TyYu23Ao7RAZPOV9MN2
         gM8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4zXWGfcym220rQoqMln+g1qCeZQVimpcGBnQ/M/+deY=;
        b=MBGFs8T/gkzFTh6vWdVsQYVkQe2pzYQbrenRlK5W4GLSlCihXOA0lzWpV0A9qB7peN
         sGNRcDDMPtN7GQ1KVNnce8CntfB3CAhvjlNh4UlNea0m30QeWUyVo85LZsVz3XJiGbtv
         TMVCdRtYtNq8bkWaymzOG9WW38Ed7IyDHhx/xAvoDfu9dOHhmMhXbnFf8eeHOOiCWgZs
         3uRTNBzYq/XaJ5NmZU01IHk1G8cVc/KziYEy1tqzxHIq1xknZvOKyBl6xMshVhs00r3w
         T8Oyb7GouKtc/d3TVMrD/hi17fx9hFI7ReO/h78iF6+mZnJNpqeyD//V6v5ZD8OkeF+c
         ht6Q==
X-Gm-Message-State: AOAM532LEdxDLY9YYSjZGbgxz9NlQctMGQbu1s190rXOccRpdO1fBGph
        cwxTQHQumdFFBM6B6smsBiFjvRjhlMVjX3EjwiS/
X-Google-Smtp-Source: ABdhPJxxlvSdKM12gRkTggQE89DANTDDlnuffsKEl2/Abaxr6hdPEx9/eXfR5Ck+AhrlMQjfgN262Rfq2fmxjK2OKeg=
X-Received: by 2002:a05:6402:23a2:b0:42d:d5f1:d470 with SMTP id
 j34-20020a05640223a200b0042dd5f1d470mr26180253eda.365.1654694678345; Wed, 08
 Jun 2022 06:24:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220426073656.229-1-xieyongji@bytedance.com> <YmeoSuMfsdVxuGlf@kroah.com>
 <20220608085133-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220608085133-mutt-send-email-mst@kernel.org>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 8 Jun 2022 21:25:36 +0800
Message-ID: <CACycT3vjNwESmoAy14+NCGxHaXJtFq6ykHTkqcpm8nvb0=sbog@mail.gmail.com>
Subject: Re: [PATCH v2] vduse: Fix NULL pointer dereference on sysfs access
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kernel test robot <oliver.sang@intel.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 8, 2022 at 8:52 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Apr 26, 2022 at 10:07:38AM +0200, Greg KH wrote:
> > On Tue, Apr 26, 2022 at 03:36:56PM +0800, Xie Yongji wrote:
> > > The control device has no drvdata. So we will get a
> > > NULL pointer dereference when accessing control
> > > device's msg_timeout attribute via sysfs:
> > >
> > > [ 132.841881][ T3644] BUG: kernel NULL pointer dereference, address: 00000000000000f8
> > > [ 132.850619][ T3644] RIP: 0010:msg_timeout_show (drivers/vdpa/vdpa_user/vduse_dev.c:1271)
> > > [ 132.869447][ T3644] dev_attr_show (drivers/base/core.c:2094)
> > > [ 132.870215][ T3644] sysfs_kf_seq_show (fs/sysfs/file.c:59)
> > > [ 132.871164][ T3644] ? device_remove_bin_file (drivers/base/core.c:2088)
> > > [ 132.872082][ T3644] kernfs_seq_show (fs/kernfs/file.c:164)
> > > [ 132.872838][ T3644] seq_read_iter (fs/seq_file.c:230)
> > > [ 132.873578][ T3644] ? __vmalloc_area_node (mm/vmalloc.c:3041)
> > > [ 132.874532][ T3644] kernfs_fop_read_iter (fs/kernfs/file.c:238)
> > > [ 132.875513][ T3644] __kernel_read (fs/read_write.c:440 (discriminator 1))
> > > [ 132.876319][ T3644] kernel_read (fs/read_write.c:459)
> > > [ 132.877129][ T3644] kernel_read_file (fs/kernel_read_file.c:94)
> > > [ 132.877978][ T3644] kernel_read_file_from_fd (include/linux/file.h:45 fs/kernel_read_file.c:186)
> > > [ 132.879019][ T3644] __do_sys_finit_module (kernel/module.c:4207)
> > > [ 132.879930][ T3644] __ia32_sys_finit_module (kernel/module.c:4189)
> > > [ 132.880930][ T3644] do_int80_syscall_32 (arch/x86/entry/common.c:112 arch/x86/entry/common.c:132)
> > > [ 132.881847][ T3644] entry_INT80_compat (arch/x86/entry/entry_64_compat.S:419)
> > >
> > > To fix it, don't create the unneeded attribute for
> > > control device anymore.
> > >
> > > Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
> > > Reported-by: kernel test robot <oliver.sang@intel.com>
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > ---
> > >  drivers/vdpa/vdpa_user/vduse_dev.c | 7 +++----
> > >  1 file changed, 3 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
> > > index f85d1a08ed87..160e40d03084 100644
> > > --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> > > +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> > > @@ -1344,9 +1344,9 @@ static int vduse_create_dev(struct vduse_dev_config *config,
> > >
> > >     dev->minor = ret;
> > >     dev->msg_timeout = VDUSE_MSG_DEFAULT_TIMEOUT;
> > > -   dev->dev = device_create(vduse_class, NULL,
> > > -                            MKDEV(MAJOR(vduse_major), dev->minor),
> > > -                            dev, "%s", config->name);
> > > +   dev->dev = device_create_with_groups(vduse_class, NULL,
> > > +                           MKDEV(MAJOR(vduse_major), dev->minor),
> > > +                           dev, vduse_dev_groups, "%s", config->name);
> > >     if (IS_ERR(dev->dev)) {
> > >             ret = PTR_ERR(dev->dev);
> > >             goto err_dev;
> > > @@ -1595,7 +1595,6 @@ static int vduse_init(void)
> > >             return PTR_ERR(vduse_class);
> > >
> > >     vduse_class->devnode = vduse_devnode;
> > > -   vduse_class->dev_groups = vduse_dev_groups;
> >
> > Ok, this looks much better.
> >
> > But wow, there are some problems in this code overall.  I see a number
> > of flat-out-wrong things in there that should have been caught by code
> > reviews.  Some examples:
> >       - empty release() callbacks.  That is a huge sign the code
> >         design is wrong and broken and you are just trying to make the
> >         driver core quiet for some reason.  The documentation in the
> >         kernel explains why this is not ok.
> >       - __module_get(THIS_MODULE);  That's racy, buggy, and doesn't do
> >         what you think it does.  Please never ever ever do that.  It
> >         too is a sign of a broken design.
> >       - no Documentation/ABI/ entries for the sysfs files here.  I
> >         think it's burried in some other documentation file but that's
> >         not the correct place for it and if you run scripts/get_abi.pl
> >         with the code loaded it will rightly complain about this.
> >
> > Do you want to address these, or do you want patches for them?
> >
> > thanks,
> >
> > greg k-h
>
> So, any patches?
>

For empty release() callbacks, I think Parav is working on it based on
the discussion [1]. I can help test and send the patch if Parav wants.

For Documentation, I have sent a patch [2].

[1] https://www.spinics.net/lists/linux-virtualization/msg56518.html
[2] https://lore.kernel.org/all/CACGkMEuJeU6c1z8+_FqGtovbF+Sq8w_eQUcG8SHm_GXV5q7yNA@mail.gmail.com/

Thanks,
Yongji
