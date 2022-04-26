Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC8F50F17E
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 08:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343529AbiDZGvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 02:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343527AbiDZGvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 02:51:02 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DEB27B0E
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 23:47:55 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id g6so11208186ejw.1
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 23:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h4eAjqnVJzj5k5ilbbqHz80sPzWI6cSAAxt2X7Fn2ag=;
        b=6QhhDBqB8F7ICCUgSayRPO8ZaAuiGvf/EOdhzmHi0iIYWSnBO0Tht3iLTTdVQGU4su
         7QeesaXRpOzpN9RJtXAPlOEHmGsDVIi76RJBAuwZZ6lhBhZdx8qb2od1/6nJSck8csry
         TzimzIqEhbhhrDEV4iKEYqhEaYH2ctJf9AD8su+GHC+wksWSxqIQn/mLmKeyQUdsDCXx
         U8jji4Lb6eOJ0OCN6/3xI+KHukVwx29ZIZKTBkrztYhl+Krb5ZpTTpENBbNQ8nrRe44G
         Xj5hjVzgCqrdi1ckI2aAd1TbQprOePARDYNF2Mi8nExk32cExl9Ri9ll5Sp1D35AZ6Uf
         iCUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h4eAjqnVJzj5k5ilbbqHz80sPzWI6cSAAxt2X7Fn2ag=;
        b=ktuGPQue6ATtO2lkY2q77E3kbarfviSpDP1hboYbT2h+nS/lZUi5GMbpi2a0OUKUMv
         REO9ALRYmiqBqy/ulgRpp0pKTThpsY/ScShJx8GVrisnqhazdMyL5Emlz8i/AI5RdpGI
         YSJE83aU4Tr0w74BtrWpAd9hyB90YsnPIF9m8ILlxsjAdtX+g+7v3hDebb6ZbXjufZ23
         rybq45j6h/LnFsf39qtDJu2fnFVtL8dWnWp7lFgoNIwNsPyS5uUmr2emD5lcAS2Bjkcm
         8G69VxUU5p85V+k/qolHB3NH+H13IvlzltG9yBNL06gOEzKOfGtgOobzBr5/bJpRCFjQ
         2hVw==
X-Gm-Message-State: AOAM531KqSKinzmt1MIrQ1/dZ7SOaCXuqvZjCTr1kMhPDEst+h96OXxn
        uiRN5BZKB+Sq478z2ZMIugtdoxy8dhk4wVue+ik9x6wt7g==
X-Google-Smtp-Source: ABdhPJyPZME6Uuwyn7BTlc/0LDcQs1TMC7nE1w3rfcjgDh3fwhVvaPKDEngSgXEI+uGv5jx687u3B1KLSOA5iAH3PkI=
X-Received: by 2002:a17:907:6ea4:b0:6f3:87c8:21cc with SMTP id
 sh36-20020a1709076ea400b006f387c821ccmr11062647ejc.490.1650955674286; Mon, 25
 Apr 2022 23:47:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220426060103.104-1-xieyongji@bytedance.com> <YmeRp87WgjC9Bjr+@kroah.com>
In-Reply-To: <YmeRp87WgjC9Bjr+@kroah.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 26 Apr 2022 14:48:23 +0800
Message-ID: <CACycT3uf0Bf2RJ=F=MdH9w4K_U9BOAwsxWerU4P4wMYhcMOHHg@mail.gmail.com>
Subject: Re: [PATCH] vduse: Fix NULL pointer dereference on sysfs access
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

On Tue, Apr 26, 2022 at 2:31 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Apr 26, 2022 at 02:01:03PM +0800, Xie Yongji wrote:
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
> >       struct vduse_dev *dev = dev_get_drvdata(device);
> >
> > +     if (!dev)
> > +             return -EPERM;
> > +
> >       return sysfs_emit(buf, "%u\n", dev->msg_timeout);
>
> What prevents the pointer from going away right after you checked it if
> this is something that changes over time?
>
> If this attribute is never going to be valid for this device, just do
> not create it.
>

Got it. Will fix it in v2.

Thanks,
Yongji
