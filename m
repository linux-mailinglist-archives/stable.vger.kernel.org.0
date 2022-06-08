Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E9A5430D8
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 14:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239862AbiFHMwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 08:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239890AbiFHMw0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 08:52:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C1F30249320
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 05:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654692719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mz+mEKznZ4YkzrtEHnGGxYGAfNYpR4omjcfYj9XsMt4=;
        b=Mdfqq3HSto3cb/ADmItvONnuK8g66UaVWCoWLWIMc+Nq43ky7cs5k1eUxGh1K8fWoVj6C6
        kA2VXnREFoZLMDBgzPcV8BoRT63IKmV932kzUVAsYoOECVtlD2K1srjnjaVZrdIVpKJRwc
        axNR/9AmMb/ilp4AdLnkhcT0M1P7Snw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-plhPRkbrMHWxLo1nAsa3cQ-1; Wed, 08 Jun 2022 08:51:58 -0400
X-MC-Unique: plhPRkbrMHWxLo1nAsa3cQ-1
Received: by mail-wm1-f71.google.com with SMTP id n15-20020a05600c4f8f00b0039c3e76d646so6498641wmq.7
        for <stable@vger.kernel.org>; Wed, 08 Jun 2022 05:51:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mz+mEKznZ4YkzrtEHnGGxYGAfNYpR4omjcfYj9XsMt4=;
        b=PPoRtokTI4AZH1eHbQ/oo5x5rvcWXq+qXe3AwfvgsLjTGMFajO+ZoA35WIkvCNZeze
         pj349LMxluHU8hZPzW7v5ep9agfTvZLK3xPIeKa0St17/HvrpfZSe02IFmCg+0SkbLRa
         SYdDIgsdBhcPDQZFnFxLjpJoRgb8OJ7Bynq/nG4NxwQlJwtgBSm3JjSCIn35SjjznwK1
         2B0FVc6ehfnKSVN/ik5KLzMSpqcEJUDYwhY52ZfgPtMV2KYkPO1+5HsBpGqDQhleyFZL
         lf3MMBGja/AQZA/3CoGsv9qLR1kn1Vxqu1SxpkphCInOG6Dg8B3P9wn/uWuXHS1J0EcV
         hfqg==
X-Gm-Message-State: AOAM530qCHV3apBIhUKXN2R+9ytuFNYVig4pARBk3d2QB3cYMIMPGO0o
        mcRSbBXm6OudrSVn2X5lkp7EV5B5rKANnq/RA1NzVUG4PqY9qmeNmdmSm1EdZ29uBWQtBit6EQB
        Ry1m+ok1KMX0iJ6at
X-Received: by 2002:a05:6000:2a8:b0:213:ba0c:fef8 with SMTP id l8-20020a05600002a800b00213ba0cfef8mr28659994wry.485.1654692716597;
        Wed, 08 Jun 2022 05:51:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEvuVnHPbh1Pwji+4efIhOO+jRS9yko+Rj5RWlqq1wts/bzOt9ul1CrVpwkKJduoyDthZzyA==
X-Received: by 2002:a05:6000:2a8:b0:213:ba0c:fef8 with SMTP id l8-20020a05600002a800b00213ba0cfef8mr28659981wry.485.1654692716340;
        Wed, 08 Jun 2022 05:51:56 -0700 (PDT)
Received: from redhat.com ([176.12.150.13])
        by smtp.gmail.com with ESMTPSA id h6-20020adfa4c6000000b0020fe61acd09sm22283068wrb.12.2022.06.08.05.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 05:51:55 -0700 (PDT)
Date:   Wed, 8 Jun 2022 08:51:50 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Xie Yongji <xieyongji@bytedance.com>, jasowang@redhat.com,
        mcgrof@kernel.org, akpm@linux-foundation.org,
        oliver.sang@intel.com, virtualization@lists.linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] vduse: Fix NULL pointer dereference on sysfs access
Message-ID: <20220608085133-mutt-send-email-mst@kernel.org>
References: <20220426073656.229-1-xieyongji@bytedance.com>
 <YmeoSuMfsdVxuGlf@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmeoSuMfsdVxuGlf@kroah.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 10:07:38AM +0200, Greg KH wrote:
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
> >  	dev->minor = ret;
> >  	dev->msg_timeout = VDUSE_MSG_DEFAULT_TIMEOUT;
> > -	dev->dev = device_create(vduse_class, NULL,
> > -				 MKDEV(MAJOR(vduse_major), dev->minor),
> > -				 dev, "%s", config->name);
> > +	dev->dev = device_create_with_groups(vduse_class, NULL,
> > +				MKDEV(MAJOR(vduse_major), dev->minor),
> > +				dev, vduse_dev_groups, "%s", config->name);
> >  	if (IS_ERR(dev->dev)) {
> >  		ret = PTR_ERR(dev->dev);
> >  		goto err_dev;
> > @@ -1595,7 +1595,6 @@ static int vduse_init(void)
> >  		return PTR_ERR(vduse_class);
> >  
> >  	vduse_class->devnode = vduse_devnode;
> > -	vduse_class->dev_groups = vduse_dev_groups;
> 
> Ok, this looks much better.
> 
> But wow, there are some problems in this code overall.  I see a number
> of flat-out-wrong things in there that should have been caught by code
> reviews.  Some examples:
> 	- empty release() callbacks.  That is a huge sign the code
> 	  design is wrong and broken and you are just trying to make the
> 	  driver core quiet for some reason.  The documentation in the
> 	  kernel explains why this is not ok.
> 	- __module_get(THIS_MODULE);  That's racy, buggy, and doesn't do
> 	  what you think it does.  Please never ever ever do that.  It
> 	  too is a sign of a broken design.
> 	- no Documentation/ABI/ entries for the sysfs files here.  I
> 	  think it's burried in some other documentation file but that's
> 	  not the correct place for it and if you run scripts/get_abi.pl
> 	  with the code loaded it will rightly complain about this.
> 
> Do you want to address these, or do you want patches for them?
> 
> thanks,
> 
> greg k-h

So, any patches?

-- 
MST

