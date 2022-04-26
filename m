Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC38B50F0FD
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 08:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239393AbiDZGeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 02:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235756AbiDZGeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 02:34:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60F313F4D
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 23:31:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65482B81C1C
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 06:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1FEC385A0;
        Tue, 26 Apr 2022 06:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650954667;
        bh=lqnrpEKQOuMfPH6GYY28U3wO31/9OTEThTe0MnNEy5o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pIj8NAqg/sK+08dG8EFPLS5kS/frmEbKdv04qO2pChL23Cyb1UchYz8zHvVzJzoR+
         uAKiNqJ3uyF5tFkClIWrdZSsAuHZO6opu/lsoMd8Om9yBnLqe4ekJ1SkZSJrgmVxiV
         yxAzSIVuyOjfYLZVf5Pt6OCVruh5y8/Axh2e2AUU=
Date:   Tue, 26 Apr 2022 08:31:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, mcgrof@kernel.org,
        akpm@linux-foundation.org, oliver.sang@intel.com,
        virtualization@lists.linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH] vduse: Fix NULL pointer dereference on sysfs access
Message-ID: <YmeRp87WgjC9Bjr+@kroah.com>
References: <20220426060103.104-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426060103.104-1-xieyongji@bytedance.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 02:01:03PM +0800, Xie Yongji wrote:
> The control device has no drvdata. So we will get a NULL
> NULL pointer dereference when accessing control device's
> msg_timeout via sysfs:
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
> To fix it, let's add a NULL check in msg_timeout_show() and
> msg_timeout_store().
> 
> Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>  drivers/vdpa/vdpa_user/vduse_dev.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
> index f85d1a08ed87..f1c42f4aabb4 100644
> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> @@ -1268,6 +1268,9 @@ static ssize_t msg_timeout_show(struct device *device,
>  {
>  	struct vduse_dev *dev = dev_get_drvdata(device);
>  
> +	if (!dev)
> +		return -EPERM;
> +
>  	return sysfs_emit(buf, "%u\n", dev->msg_timeout);

What prevents the pointer from going away right after you checked it if
this is something that changes over time?

If this attribute is never going to be valid for this device, just do
not create it.

thanks,

greg k-h
