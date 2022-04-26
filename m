Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC45350F366
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbiDZILC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344450AbiDZIKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:10:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8AB48881
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 01:07:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98F47B81C18
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 08:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E07EC385AE;
        Tue, 26 Apr 2022 08:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650960462;
        bh=vXnXFqQTsLMD9FGeK4Ctz/DZti/ATeqZqWeCCMJrbbw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lv1Sv3zed1DsoPoseIZf746zkWGvdx3NPqvljUfAKjCbucFc5hk9bWHCFH+WcnXNB
         7Pz55Rk0EYyJ8Cqe/s7dBLAjSNq+yVxgRU7lmCc/+gzwBMReZT87HWqIicPf2yZ3mk
         qhnFGdwIGHLd9PAaDAEt3kP8rbOtoIqoOlfIZB1c=
Date:   Tue, 26 Apr 2022 10:07:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, mcgrof@kernel.org,
        akpm@linux-foundation.org, oliver.sang@intel.com,
        virtualization@lists.linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] vduse: Fix NULL pointer dereference on sysfs access
Message-ID: <YmeoSuMfsdVxuGlf@kroah.com>
References: <20220426073656.229-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426073656.229-1-xieyongji@bytedance.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 03:36:56PM +0800, Xie Yongji wrote:
> The control device has no drvdata. So we will get a
> NULL pointer dereference when accessing control
> device's msg_timeout attribute via sysfs:
> 
> [ 132.841881][ T3644] BUG: kernel NULL pointer dereference, address: 00000000000000f8
> [ 132.850619][ T3644] RIP: 0010:msg_timeout_show (drivers/vdpa/vdpa_user/vduse_dev.c:1271)
> [ 132.869447][ T3644] dev_attr_show (drivers/base/core.c:2094)
> [ 132.870215][ T3644] sysfs_kf_seq_show (fs/sysfs/file.c:59)
> [ 132.871164][ T3644] ? device_remove_bin_file (drivers/base/core.c:2088)
> [ 132.872082][ T3644] kernfs_seq_show (fs/kernfs/file.c:164)
> [ 132.872838][ T3644] seq_read_iter (fs/seq_file.c:230)
> [ 132.873578][ T3644] ? __vmalloc_area_node (mm/vmalloc.c:3041)
> [ 132.874532][ T3644] kernfs_fop_read_iter (fs/kernfs/file.c:238)
> [ 132.875513][ T3644] __kernel_read (fs/read_write.c:440 (discriminator 1))
> [ 132.876319][ T3644] kernel_read (fs/read_write.c:459)
> [ 132.877129][ T3644] kernel_read_file (fs/kernel_read_file.c:94)
> [ 132.877978][ T3644] kernel_read_file_from_fd (include/linux/file.h:45 fs/kernel_read_file.c:186)
> [ 132.879019][ T3644] __do_sys_finit_module (kernel/module.c:4207)
> [ 132.879930][ T3644] __ia32_sys_finit_module (kernel/module.c:4189)
> [ 132.880930][ T3644] do_int80_syscall_32 (arch/x86/entry/common.c:112 arch/x86/entry/common.c:132)
> [ 132.881847][ T3644] entry_INT80_compat (arch/x86/entry/entry_64_compat.S:419)
> 
> To fix it, don't create the unneeded attribute for
> control device anymore.
> 
> Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>  drivers/vdpa/vdpa_user/vduse_dev.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
> index f85d1a08ed87..160e40d03084 100644
> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> @@ -1344,9 +1344,9 @@ static int vduse_create_dev(struct vduse_dev_config *config,
>  
>  	dev->minor = ret;
>  	dev->msg_timeout = VDUSE_MSG_DEFAULT_TIMEOUT;
> -	dev->dev = device_create(vduse_class, NULL,
> -				 MKDEV(MAJOR(vduse_major), dev->minor),
> -				 dev, "%s", config->name);
> +	dev->dev = device_create_with_groups(vduse_class, NULL,
> +				MKDEV(MAJOR(vduse_major), dev->minor),
> +				dev, vduse_dev_groups, "%s", config->name);
>  	if (IS_ERR(dev->dev)) {
>  		ret = PTR_ERR(dev->dev);
>  		goto err_dev;
> @@ -1595,7 +1595,6 @@ static int vduse_init(void)
>  		return PTR_ERR(vduse_class);
>  
>  	vduse_class->devnode = vduse_devnode;
> -	vduse_class->dev_groups = vduse_dev_groups;

Ok, this looks much better.

But wow, there are some problems in this code overall.  I see a number
of flat-out-wrong things in there that should have been caught by code
reviews.  Some examples:
	- empty release() callbacks.  That is a huge sign the code
	  design is wrong and broken and you are just trying to make the
	  driver core quiet for some reason.  The documentation in the
	  kernel explains why this is not ok.
	- __module_get(THIS_MODULE);  That's racy, buggy, and doesn't do
	  what you think it does.  Please never ever ever do that.  It
	  too is a sign of a broken design.
	- no Documentation/ABI/ entries for the sysfs files here.  I
	  think it's burried in some other documentation file but that's
	  not the correct place for it and if you run scripts/get_abi.pl
	  with the code loaded it will rightly complain about this.

Do you want to address these, or do you want patches for them?

thanks,

greg k-h
