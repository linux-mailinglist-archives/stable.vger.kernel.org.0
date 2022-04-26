Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A072750F176
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 08:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237092AbiDZGtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 02:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245648AbiDZGtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 02:49:45 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912B5186FD
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 23:46:38 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id y3so13656424ejo.12
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 23:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fen/7x7QpxuTMdFlSeWgDV5I5clH/DAvJpLkJQ2a0WY=;
        b=ll1kHo82Clz51swVgcRlbExnT4pC66DvJiQzgxgcWLf/lpmXLJPc6NIAk8gX09jkvy
         fKuXuVkHkh0MEX7/ReZlS4GG4ji4JxjHVSTbyrsBI3M3/al+BIaow6bXBLCcOHX84CGC
         3ZrsIaICqqvuEiCY7WNSHAVIdEsu14Gd3dNjLeLG3A/tKosBKwaGEJj7a6BBPatIOofl
         QyTPaBBbj5piFax7861i4fJd+wkPx25kiV0kUQ7dHVvX1yYqeXz6zMGvgWtihR6pqpSS
         w69rjUb2Kla0hWwJZnSsm1zjSW1e4z5Bo40S0ZyymglEZmLhP6t8p6AoOWkS1VJFxAc+
         Js5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fen/7x7QpxuTMdFlSeWgDV5I5clH/DAvJpLkJQ2a0WY=;
        b=6lsN/nzzLR9825z129hu6WGHkQeZnv7HIy4XQdkBzY8U/5M9tw19guFtnKDksHPj8e
         urjKWCw/VTw6AHYvKJJkoRDNgbenswnwjym1JysCKzLMyWNCEJTTTpnMshxJc6TAIqrs
         8aVy53kcbKQdn+3vo/7rtK/Xs2vp6AIHLoTthyXArl/o6QQ0p/sYwucB7ioSmPfGBN9N
         nCyEIhSULH/nqtf/D2uY9f9TkboaLd7tbAnYQ4VgnbxZxgrhi9v1L53XTG24RZxaN6o8
         /66EGw453to5zs3iJvd9hFE0lTuU098EVRCbc12c8oXPI9DkTVr/V129cXsaCCmsOHye
         965g==
X-Gm-Message-State: AOAM532uhL2ecaOHvXFyZ/Pj+IxFsOhPZd8GhVUJVxbGnrUIfid6zbH2
        nZtq/2HOalkDfLuWZ7hRmchRhXjMSCq9DhLMjNpt
X-Google-Smtp-Source: ABdhPJyI//+7LCcmeYQQMuohT3HqZkHnjG5jaYJcCM/TbaV6r6ymvF8tJQf3E05ibobQYi/5cqhMCA63Zi9mwDoT8AA=
X-Received: by 2002:a17:906:7954:b0:6f3:b2f4:b22b with SMTP id
 l20-20020a170906795400b006f3b2f4b22bmr1344611ejo.536.1650955597163; Mon, 25
 Apr 2022 23:46:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220426060103.104-1-xieyongji@bytedance.com> <CACGkMEued=Pewd-xfLu7nhY0_gvMowAte4084mLWxAkykzJ8gw@mail.gmail.com>
In-Reply-To: <CACGkMEued=Pewd-xfLu7nhY0_gvMowAte4084mLWxAkykzJ8gw@mail.gmail.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 26 Apr 2022 14:47:06 +0800
Message-ID: <CACycT3sgQZVgSKWuvGbaduEhGHdUJcatPiCC28oibJYXNdjMZg@mail.gmail.com>
Subject: Re: [PATCH] vduse: Fix NULL pointer dereference on sysfs access
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst <mst@redhat.com>, Luis Chamberlain <mcgrof@kernel.org>,
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

On Tue, Apr 26, 2022 at 2:19 PM Jason Wang <jasowang@redhat.com> wrote:
>
> On Tue, Apr 26, 2022 at 2:01 PM Xie Yongji <xieyongji@bytedance.com> wrote:
> >
> > The control device has no drvdata. So we will get a NULL
> > NULL pointer dereference when accessing control device's
> > msg_timeout via sysfs:
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
> > To fix it, let's add a NULL check in msg_timeout_show() and
> > msg_timeout_store().
> >
> > Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >  drivers/vdpa/vdpa_user/vduse_dev.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
> > index f85d1a08ed87..f1c42f4aabb4 100644
> > --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> > +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> > @@ -1268,6 +1268,9 @@ static ssize_t msg_timeout_show(struct device *device,
> >  {
> >         struct vduse_dev *dev = dev_get_drvdata(device);
> >
> > +       if (!dev)
> > +               return -EPERM;
> > +
>
> I wonder if it's possible to not have those attributes for the control device.
>

Yes, I think we can. Will do it in v2.

Thanks,
Yongji
