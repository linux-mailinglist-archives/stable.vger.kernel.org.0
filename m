Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC29D53B2D2
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 06:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiFBEyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 00:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiFBEyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 00:54:14 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98672A3095
        for <stable@vger.kernel.org>; Wed,  1 Jun 2022 21:54:12 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id x62so4750802ede.10
        for <stable@vger.kernel.org>; Wed, 01 Jun 2022 21:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5GweRPgIYKJ63spP15VCdqoYVrexCVLzWIgKUzmsoNU=;
        b=6qWpPnGgmhTHXpsvu607+eF8FDU1WPUc31y7ww6sgQDnROI7IPZgUS5YH109oIm76J
         BDzV07Oe74JkTZMcGMoR8h2Zyr9AFAbeClD2sC1cPIF0pNLji+LxIBETjXgyINi6Xi8n
         O1veQTIszLNQnH9tcHMdr10usqs++J4MlhcgNLSg0aD+ND6Mf/Y3F88K85YZWcHZj9Jz
         V95pA2qm48vlrmf8chVVmzL0FAO1GwjRdLJYAR/aeF4YLQwjSFV+sMh9Fryg4Rga7SIr
         DeyttL3pV+IK/hKtqFZKoeGCIywuPWwi6167ND6wp0OFckjFz35OYIeeRKEdHbLu+E+N
         Nw5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5GweRPgIYKJ63spP15VCdqoYVrexCVLzWIgKUzmsoNU=;
        b=nDyQhg7MgwLcjgGIIcd1x16vEP3CTHq+PQERC9jtlngYIsTtOC2UZHeTUecbsE+Adn
         xQw1LuPMq3eDgDEfICg6ThJengE8VaSWhTKP7FbMdrUyyUbAIsYQesPQ1rUHDgR/qrCs
         zTToxUYncicwOIqVSgfsW3HOUkQg8OPJDavyY5ZXVLFqbr3f8QHt6n5agUrL2NvmeVUk
         qARhsqfP8m6prEEMVsg/igSF4TcmivT73y7hwcWa6oAi9xG6zYl61RYOZGW4z6SCSLcA
         3y4n3mWdKauyXxTfeAfPoOaFJjjS4Q1tHif+NcSGhM2pKYclpB7K9sxshblO0ZOrjEZa
         bY2Q==
X-Gm-Message-State: AOAM533kUq6onAiqoYkTlAoFTEcg2yNd/mT0pmUpjYzbujwqshy2MSJA
        fbODLKg0gGmiG04nY5iJt/+9Ci8zrCsGOzllBC/a
X-Google-Smtp-Source: ABdhPJy23FwsY5/z1C4kvJ6Rqsw5x7gkbieRiE0q+nCIGPEeaV0iEN84HMyfqGJPdnATtZ7WT8sc8QsPve9M86qEWN8=
X-Received: by 2002:a50:fc0d:0:b0:42d:c1ae:28bc with SMTP id
 i13-20020a50fc0d000000b0042dc1ae28bcmr3401593edr.24.1654145651233; Wed, 01
 Jun 2022 21:54:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220426073656.229-1-xieyongji@bytedance.com>
In-Reply-To: <20220426073656.229-1-xieyongji@bytedance.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 2 Jun 2022 12:55:02 +0800
Message-ID: <CACycT3v+r1-RO1q_BuStkaais7n0yDXK4gT89WhchpX3AvRPcg@mail.gmail.com>
Subject: Re: [PATCH v2] vduse: Fix NULL pointer dereference on sysfs access
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
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

Ping.

On Tue, Apr 26, 2022 at 3:36 PM Xie Yongji <xieyongji@bytedance.com> wrote:
>
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
>         dev->minor = ret;
>         dev->msg_timeout = VDUSE_MSG_DEFAULT_TIMEOUT;
> -       dev->dev = device_create(vduse_class, NULL,
> -                                MKDEV(MAJOR(vduse_major), dev->minor),
> -                                dev, "%s", config->name);
> +       dev->dev = device_create_with_groups(vduse_class, NULL,
> +                               MKDEV(MAJOR(vduse_major), dev->minor),
> +                               dev, vduse_dev_groups, "%s", config->name);
>         if (IS_ERR(dev->dev)) {
>                 ret = PTR_ERR(dev->dev);
>                 goto err_dev;
> @@ -1595,7 +1595,6 @@ static int vduse_init(void)
>                 return PTR_ERR(vduse_class);
>
>         vduse_class->devnode = vduse_devnode;
> -       vduse_class->dev_groups = vduse_dev_groups;
>
>         ret = alloc_chrdev_region(&vduse_major, 0, VDUSE_DEV_MAX, "vduse");
>         if (ret)
> --
> 2.20.1
>
